From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] pcmcia: add error handling for pcmcia_enable_device
Date: Mon, 11 Jun 2018 13:15:50 +0800
Message-ID: <1528694152-31724-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When pcmcia_enable_device fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling pcmcia_enable_device.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/scsi/pcmcia/qlogic_stub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 0556054..9287d52 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -254,8 +254,14 @@ static void qlogic_release(struct pcmcia_device *link)
 static int qlogic_resume(struct pcmcia_device *link)
 {
 	scsi_info_t *info = link->priv;
+	int ret;
+
+	ret = pcmcia_enable_device(link);
+	if (ret) {
+		pcmcia_disable_device(link);
+		return -ENODEV;
+	}
 
-	pcmcia_enable_device(link);
 	if ((info->manf_id == MANFID_MACNICA) ||
 	    (info->manf_id == MANFID_PIONEER) ||
 	    (info->manf_id == 0x0098)) {
-- 
2.7.4
