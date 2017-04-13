From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Thu, 13 Apr 2017 00:28:54 +0000
Message-ID: <1492043332.2764.28.camel@sandisk.com>
References: <20170410175402.9003-1-bart.vanassche@sandisk.com>
         <20170410175402.9003-4-bart.vanassche@sandisk.com>
         <20170412144135.GC22576@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:34527 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755515AbdDMA25 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 20:28:57 -0400
In-Reply-To: <20170412144135.GC22576@bblock-ThinkPad-W530>
Content-Language: en-US
Content-ID: <0FABB8A096A823459254B94FB86428B4@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "maxg@mellanox.com" <maxg@mellanox.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Wed, 2017-04-12 at 16:41 +0200, Benjamin Block wrote:
> On Mon, Apr 10, 2017 at 10:54:01AM -0700, Bart Van Assche wrote:
> > [ ... ]
> OK, so I take it the problem is when the queue is stopped, then the
> completion in blk_execute_rq() will never be triggered and then we wait
> for a timeout there, or potentially forever?

Hello Benjamin,

Thanks for the review.

If a request is queued after a queue has been stopped then that request
will never be started and hence even the timeout timer won't be started.
blk_cleanup_queue() hangs if invoked for a stopped queue and one or more
requests have not yet been started.

> But then what is the point in trying to do it async here anyway? Won't
> that just be doomed in the same way, just that we don't see the effect?

Have you noticed that patch 4/4 in this series restarts the queue just
before calling blk_cleanup_queue()?

Anyway, can you have a look at the patch below and see whether this new
version addresses all the concerns you had reported in your previous
e-mail?

Thanks,

Bart.


Subject: [PATCH] sd: Make synchronize cache upon shutdown asynchronous

This patch avoids that sd_shutdown() hangs on the SYNCHRONIZE CACHE
command if the block layer queue has been stopped by
scsi_target_block().
---
=A0drivers/scsi/sd.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
=A01 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fe0f7997074e..deff564fe649 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1489,6 +1489,33 @@ static unsigned int sd_check_events(struct gendisk *=
disk, unsigned int clearing)
=A0	return retval;
=A0}
=A0
+static void sd_sync_cache_done(struct request *rq, int e)
+{
+	struct scsi_disk *sdkp =3D scsi_disk(rq->rq_disk);
+
+	sd_printk(KERN_DEBUG, sdkp, "%s\n", __func__);
+
+	blk_put_request(rq);
+}
+
+/*
+ * Issue a SYNCHRONIZE CACHE command asynchronously. Since blk_cleanup_que=
ue()
+ * waits for all commands to finish, __scsi_remove_device() will wait for =
the
+ * SYNCHRONIZE CACHE command to finish.
+ */
+static int sd_sync_cache_async(struct scsi_disk *sdkp)
+{
+	const struct scsi_device *sdp =3D sdkp->device;
+	const int timeout =3D sdp->request_queue->rq_timeout *
+			=A0=A0=A0=A0SD_FLUSH_TIMEOUT_MULTIPLIER;
+	const unsigned char cmd[10] =3D { SYNCHRONIZE_CACHE };
+
+	sd_printk(KERN_DEBUG, sdkp, "%s\n", __func__);
+	return scsi_execute_async(sdp, sdkp->disk, cmd, DMA_NONE, NULL, 0,
+				=A0=A0timeout, SD_MAX_RETRIES, 0, 0,
+				=A0=A0sd_sync_cache_done);
+}
+
=A0static int sd_sync_cache(struct scsi_disk *sdkp)
=A0{
=A0	int retries, res;
@@ -3349,13 +3376,15 @@ static int sd_start_stop_device(struct scsi_disk *s=
dkp, int start)
=A0}
=A0
=A0/*
- * Send a SYNCHRONIZE CACHE instruction down to the device through
- * the normal SCSI command structure.=A0=A0Wait for the command to
- * complete.
+ * Send a SYNCHRONIZE CACHE instruction down to the device through the nor=
mal
+ * SCSI command structure. When stopping the disk, wait for the command to
+ * complete. When not stopping the disk, the blk_cleanup_queue() call in
+ * __scsi_remove_device() will wait for this command to complete.
=A0 */
=A0static void sd_shutdown(struct device *dev)
=A0{
=A0	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
+	bool stop_disk;
=A0
=A0	if (!sdkp)
=A0		return;=A0=A0=A0=A0=A0=A0=A0=A0=A0/* this can happen */
@@ -3363,12 +3392,18 @@ static void sd_shutdown(struct device *dev)
=A0	if (pm_runtime_suspended(dev))
=A0		return;
=A0
+	stop_disk =3D system_state !=3D SYSTEM_RESTART &&
+		sdkp->device->manage_start_stop;
+
=A0	if (sdkp->WCE && sdkp->media_present) {
=A0		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp);
+		if (stop_disk)
+			sd_sync_cache(sdkp);
+		else
+			sd_sync_cache_async(sdkp);
=A0	}
=A0
-	if (system_state !=3D SYSTEM_RESTART && sdkp->device->manage_start_stop) =
{
+	if (stop_disk) {
=A0		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
=A0		sd_start_stop_device(sdkp, 0);
=A0	}
--=A0
2.12.2
