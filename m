From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH v2] pcmcia: add error handling for pcmcia_enable_device
Date: Thu, 14 Jun 2018 17:23:25 +0800
Message-ID: <1528968207-48671-1-git-send-email-jiazhouyang09@gmail.com>
References: <1528694152-31724-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528694152-31724-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When pcmcia_enable_device fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling pcmcia_enable_device.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
v1->v2:
- Remove pcmcia_disable_device.
---
 drivers/scsi/pcmcia/qlogic_stub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 0556054..eb2c8bf 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -254,8 +254,12 @@ static void qlogic_release(struct pcmcia_device *link)
 static int qlogic_resume(struct pcmcia_device *link)
 {
 	scsi_info_t *info = link->priv;
+	int ret;
+
+	ret = pcmcia_enable_device(link);
+	if (ret)
+		return -ENODEV;
 
-	pcmcia_enable_device(link);
 	if ((info->manf_id == MANFID_MACNICA) ||
 	    (info->manf_id == MANFID_PIONEER) ||
 	    (info->manf_id == 0x0098)) {
-- 
2.7.4
