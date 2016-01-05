From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] scsi: imm: use new parport device model
Date: Tue,  5 Jan 2016 18:10:50 +0530
Message-ID: <1451997650-10573-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Modify imm driver to use the new parallel port device model.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

I usually submit checkpatch cleanup and other modifications while
converting a driver to use parport device model. For this driver i
hesitated. If you want I can send a series with this modification and
checkpatch fix. Same for scsi/ppa.c.

 drivers/scsi/imm.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 4e1a632..f8b88fa 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -43,6 +43,7 @@ typedef struct {
 	unsigned dp:1;		/* Data phase present           */
 	unsigned rd:1;		/* Read data in data phase      */
 	unsigned wanted:1;	/* Parport sharing busy flag    */
+	unsigned int dev_no;	/* Device number		*/
 	wait_queue_head_t *waiting;
 	struct Scsi_Host *host;
 	struct list_head list;
@@ -1120,15 +1121,40 @@ static struct scsi_host_template imm_template = {
 
 static LIST_HEAD(imm_hosts);
 
+/*
+ * Finds the first available device number that can be alloted to the
+ * new imm device and returns the address of the previous node so that
+ * we can add to the tail and have a list in the ascending order.
+ */
+
+static inline imm_struct *find_parent(void)
+{
+	imm_struct *dev, *par = NULL;
+	unsigned int cnt = 0;
+
+	if (list_empty(&imm_hosts))
+		return NULL;
+
+	list_for_each_entry(dev, &imm_hosts, list) {
+		if (dev->dev_no != cnt)
+			return par;
+		cnt++;
+		par = dev;
+	}
+
+	return par;
+}
+
 static int __imm_attach(struct parport *pb)
 {
 	struct Scsi_Host *host;
-	imm_struct *dev;
+	imm_struct *dev, *temp;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waiting);
 	DEFINE_WAIT(wait);
 	int ports;
 	int modes, ppb;
 	int err = -ENOMEM;
+	struct pardev_cb imm_cb;
 
 	init_waitqueue_head(&waiting);
 
@@ -1141,9 +1167,15 @@ static int __imm_attach(struct parport *pb)
 	dev->mode = IMM_AUTODETECT;
 	INIT_LIST_HEAD(&dev->list);
 
-	dev->dev = parport_register_device(pb, "imm", NULL, imm_wakeup,
-						NULL, 0, dev);
+	temp = find_parent();
+	if (temp)
+		dev->dev_no = temp->dev_no + 1;
+
+	memset(&imm_cb, 0, sizeof(imm_cb));
+	imm_cb.private = dev;
+	imm_cb.wakeup = imm_wakeup;
 
+	dev->dev = parport_register_dev_model(pb, "imm", &imm_cb, dev->dev_no);
 	if (!dev->dev)
 		goto out;
 
@@ -1207,7 +1239,10 @@ static int __imm_attach(struct parport *pb)
 	host->unique_id = pb->number;
 	*(imm_struct **)&host->hostdata = dev;
 	dev->host = host;
-	list_add_tail(&dev->list, &imm_hosts);
+	if (!temp)
+		list_add_tail(&dev->list, &imm_hosts);
+	else
+		list_add_tail(&dev->list, &temp->list);
 	err = scsi_add_host(host, NULL);
 	if (err)
 		goto out2;
@@ -1245,9 +1280,10 @@ static void imm_detach(struct parport *pb)
 }
 
 static struct parport_driver imm_driver = {
-	.name	= "imm",
-	.attach	= imm_attach,
-	.detach	= imm_detach,
+	.name		= "imm",
+	.match_port	= imm_attach,
+	.detach		= imm_detach,
+	.devmodel	= true,
 };
 
 static int __init imm_driver_init(void)
-- 
1.9.1
