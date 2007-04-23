From: Josef Bacik <jwhiter@redhat.com>
Subject: Re: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Mon, 23 Apr 2007 14:13:19 -0400
Message-ID: <20070423181318.GD22873@korben.rdu.redhat.com>
References: <20070419132459.GB1481@korben.rdu.redhat.com> <1176991356.31764.3.camel@mulgrave.il.steeleye.com> <20070419150655.GC1481@korben.rdu.redhat.com> <20070421002345.673d9988.akpm@linux-foundation.org> <20070421135956.GA22873@korben.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224AbXDWSMJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Apr 2007 14:12:09 -0400
Content-Disposition: inline
In-Reply-To: <20070421135956.GA22873@korben.rdu.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josef Bacik <jwhiter@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 09:59:56AM -0400, Josef Bacik wrote:
> On Sat, Apr 21, 2007 at 12:23:45AM -0700, Andrew Morton wrote:
> > On Thu, 19 Apr 2007 11:06:56 -0400 Josef Bacik <jwhiter@redhat.com> wrote:
> > 
> > > On Thu, Apr 19, 2007 at 10:02:36AM -0400, James Bottomley wrote:
> > > > On Thu, 2007-04-19 at 09:25 -0400, Josef Bacik wrote:
> > > > > Looking through everything I came to the conclusion that we don't really need
> > > > > the scsi_sysfs_add_devices in scsi_finish_async_scan, which gets run everytime
> > > > > we do a do_scan_async.  In doing the scanning, if we come upon anything we will
> > > > > already be registering the device with sysfs so the scsi_sysfs_add_devices step
> > > > > is kind of useless.
> > > > 
> > > > Unfortunately, it isn't.  The registration step while scanning is at the
> > > > end of scsi_add_lun():
> > > > 
> > > > 
> > > > 	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
> > > > 		return SCSI_SCAN_NO_RESPONSE;
> > > > 
> > > > 	return SCSI_SCAN_LUN_PRESENT;
> > > > 
> > > > The !async should mean that the addition *only* occurs for the non async
> > > > scan case ... if you remove the post async scan add, we'll lose devices.
> > > > 

Ok I have a new patch that I've built and tested on both my UP and SMP machine
and it appears to work fine.  I took the async check out of scsi_add_lun, I
don't really see the point in waiting to do the sysfs registration stuff (if
theres a reason I haven't been able to find it in the original submission of
this functionality).  Please let me know if this is incorrect.  Thank you,

Josef

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0949145..8af1e16 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -712,7 +712,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
-		int *bflags, int async)
+		int *bflags)
 {
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
@@ -912,7 +912,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
+	if (scsi_sysfs_add_sdev(sdev) != 0)
 		return SCSI_SCAN_NO_RESPONSE;
 
 	return SCSI_SCAN_LUN_PRESENT;
@@ -1081,7 +1081,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
+	res = scsi_add_lun(sdev, result, &bflags);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1661,15 +1661,6 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 	return 0;
 }
 
-static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev;
-	shost_for_each_device(sdev, shost) {
-		if (scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
-	}
-}
-
 /**
  * scsi_prep_async_scan - prepare for an async scan
  * @shost: the host which will be scanned
@@ -1741,8 +1732,6 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	wait_for_completion(&data->prev_finished);
 
-	scsi_sysfs_add_devices(shost);
-
 	spin_lock(&async_scan_lock);
 	shost->async_scan = 0;
 	list_del(&data->list);
