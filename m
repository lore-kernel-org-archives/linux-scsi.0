From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 02/14] qla2xxx: Fix crash due to wrong casting of reg for ISP27XX.
Date: Thu, 9 Apr 2015 14:59:56 -0400
Message-ID: <1428606008-14976-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:65083 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933205AbbDITle (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:34 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index a8c0c73..7a92f60 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -190,7 +190,7 @@ static inline void
 qla27xx_write_reg(__iomem struct device_reg_24xx *reg,
 	uint offset, uint32_t data, void *buf)
 {
-	__iomem void *window = reg + offset;
+	__iomem void *window = (void *)reg + offset;
 
 	if (buf) {
 		WRT_REG_DWORD(window, data);
-- 
1.7.7

