From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 1/3] nvme-fabrics: rework nvmf_get_address() for variable
 options
Date: Thu, 28 Jul 2016 17:00:25 -0700
Message-ID: <579a9c99.RE/wCYn5/6zl6dPY%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36669 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbcG2AA1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2016 20:00:27 -0400
Received: by mail-pa0-f54.google.com with SMTP id pp5so25284593pac.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2016 17:00:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


Revise nvmf_get_address() string to account for not all options being
present.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/nvme/host/fabrics.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index dc99676..2867b92 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -109,8 +109,16 @@ static void nvmf_host_put(struct nvmf_host *host)
  */
 int nvmf_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 {
-	return snprintf(buf, size, "traddr=%s,trsvcid=%s\n",
-			ctrl->opts->traddr, ctrl->opts->trsvcid);
+	int len = 0;
+
+	if (ctrl->opts->mask & NVMF_OPT_TRADDR)
+		len += snprintf(buf, size, "traddr=%s", ctrl->opts->traddr);
+	if (ctrl->opts->mask & NVMF_OPT_TRSVCID)
+		len += snprintf(buf + len, size - len, "%strsvcid=%s",
+				(len) ? "," : "", ctrl->opts->trsvcid);
+	len += snprintf(buf + len, size - len, "\n");
+
+	return len;
 }
 EXPORT_SYMBOL_GPL(nvmf_get_address);
 
-- 
2.5.0

