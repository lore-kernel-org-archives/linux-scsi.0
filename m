From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH RESEND] scsi: ppa: use new parport device model
Date: Thu, 11 Feb 2016 10:42:49 +0530
Message-ID: <1455167569-4235-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36470 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbcBKFM7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 00:12:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>

Modify ppa driver to use the new parallel port device model.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

Resending as there was no review or ACK for this change.
This has exactly same changes as done in scsi/imm.c which has already
been accepted.

 drivers/scsi/ppa.c | 46 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index ee00e27..f6ad579 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -37,6 +37,7 @@ typedef struct {
 	unsigned long recon_tmo;	/* How many usecs to wait for reconnection (6th bit) */
 	unsigned int failed:1;	/* Failure flag                 */
 	unsigned wanted:1;	/* Parport sharing busy flag    */
+	unsigned int dev_no;	/* Device number		*/
 	wait_queue_head_t *waiting;
 	struct Scsi_Host *host;
 	struct list_head list;
@@ -985,15 +986,40 @@ static struct scsi_host_template ppa_template = {
 
 static LIST_HEAD(ppa_hosts);
 
+/*
+ * Finds the first available device number that can be alloted to the
+ * new ppa device and returns the address of the previous node so that
+ * we can add to the tail and have a list in the ascending order.
+ */
+
+static inline ppa_struct *find_parent(void)
+{
+	ppa_struct *dev, *par = NULL;
+	unsigned int cnt = 0;
+
+	if (list_empty(&ppa_hosts))
+		return NULL;
+
+	list_for_each_entry(dev, &ppa_hosts, list) {
+		if (dev->dev_no != cnt)
+			return par;
+		cnt++;
+		par = dev;
+	}
+
+	return par;
+}
+
 static int __ppa_attach(struct parport *pb)
 {
 	struct Scsi_Host *host;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waiting);
 	DEFINE_WAIT(wait);
-	ppa_struct *dev;
+	ppa_struct *dev, *temp;
 	int ports;
 	int modes, ppb, ppb_hi;
 	int err = -ENOMEM;
+	struct pardev_cb ppa_cb;
 
 	dev = kzalloc(sizeof(ppa_struct), GFP_KERNEL);
 	if (!dev)
@@ -1002,8 +1028,15 @@ static int __ppa_attach(struct parport *pb)
 	dev->mode = PPA_AUTODETECT;
 	dev->recon_tmo = PPA_RECON_TMO;
 	init_waitqueue_head(&waiting);
-	dev->dev = parport_register_device(pb, "ppa", NULL, ppa_wakeup,
-					    NULL, 0, dev);
+	temp = find_parent();
+	if (temp)
+		dev->dev_no = temp->dev_no + 1;
+
+	memset(&ppa_cb, 0, sizeof(ppa_cb));
+	ppa_cb.private = dev;
+	ppa_cb.wakeup = ppa_wakeup;
+
+	dev->dev = parport_register_dev_model(pb, "ppa", &ppa_cb, dev->dev_no);
 
 	if (!dev->dev)
 		goto out;
@@ -1110,9 +1143,10 @@ static void ppa_detach(struct parport *pb)
 }
 
 static struct parport_driver ppa_driver = {
-	.name	= "ppa",
-	.attach	= ppa_attach,
-	.detach	= ppa_detach,
+	.name		= "ppa",
+	.match_port	= ppa_attach,
+	.detach		= ppa_detach,
+	.devmodel	= true,
 };
 
 static int __init ppa_driver_init(void)
-- 
1.9.1

