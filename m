From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 3/3] HCIL accraid updates
Date: Mon, 31 Oct 2005 07:23:49 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01CBC638@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:20693 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932392AbVJaMXv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 07:23:51 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Mark Haverkamp <markh@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

No problem from me.

There was a time I would have resisted while we were working out our
SATA cards as we were exploring the possibility of representing the
increased number of array targets with id & lun by keeping the decision
centralized in a small series of macros allowing us to act quickly; but
I am all over that now. SATA cards have 128 array targets, and still map
one-to-one with id.

Would have preferred the patch to cut the cord completely and drop all
the container to id macros, that can follow in a cosmetic cleanup patch
behind all the big ones on their way.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
Sent: Saturday, October 29, 2005 5:40 PM
To: linux-scsi@vger.kernel.org
Cc: markh@osdl.org
Subject: [patch 3/3] HCIL accraid updates



commit 5ffa5fea1a50cdc3196e5f0c4e18b1aceb88125f
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Sat Oct 29 17:32:26 2005 -0400

    [SCSI] aacraid: use scmd_id(), begin elimination of
ID_LUN_TO_CONTAINER()
    
    - begin elimination of ID_LUN_TO_CONTAINER(), which takes "id" and
"lun"
      arguments, but only uses the "id" argument.  This eliminates
needless
      references to sdev->lun, which are always compiled out.
    
    - begin using wrappers scmd_id(), sdev_id()

 drivers/scsi/aacraid/aachba.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c
b/drivers/scsi/aacraid/aachba.c index 2a128a1..8b797d6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -908,7 +908,7 @@ static void io_callback(void *context, s
 	scsicmd = (struct scsi_cmnd *) context;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id,
scsicmd->device->lun);
+	cid = scmd_id(scsicmd);
 
 	if (nblank(dprintk(x))) {
 		u64 lba;
@@ -1353,7 +1353,7 @@ static void synchronize_callback(void *c
 	else {
 		struct scsi_device *sdev = cmd->device;
 		struct aac_dev *dev = (struct aac_dev
*)sdev->host->hostdata;
-		u32 cid = ID_LUN_TO_CONTAINER(sdev->id, sdev->lun);
+		u32 cid = sdev_id(sdev);
 		printk(KERN_WARNING 
 		     "synchronize_callback: synchronize failed, status =
%d\n",
 		     le32_to_cpu(synchronizereply->status));
@@ -1547,7 +1547,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 	{
 		struct inquiry_data inq_data;
 
-		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n",
scsicmd->device->id));
+		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n",
scmd_id(scsicmd)));
 		memset(&inq_data, 0, sizeof (struct inquiry_data));
 
 		inq_data.inqd_ver = 2;	/* claim compliance to SCSI-2 */
@@ -1774,7 +1774,7 @@ static int query_disk(struct aac_dev *de
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
 	if (qd.cnum == -1)
-		qd.cnum = ID_LUN_TO_CONTAINER(qd.id, qd.lun);
+		qd.cnum = qd.id;
 	else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1)) 
 	{
 		if (qd.cnum < 0 || qd.cnum >=
dev->maximum_num_containers)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
