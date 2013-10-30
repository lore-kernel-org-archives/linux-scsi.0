From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 02/22] qla2xxx: Honor execute firmware failures.
Date: Wed, 30 Oct 2013 03:38:09 -0400
Message-ID: <1383118709-5569-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:46877 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752940Ab3J3ILm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:42 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If the execute firmware command fails we do not stop the rest of the
initialization process which will continue to fail so if we encounter an error
simply short circuit the process.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 03f715e..e7e5f4f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1694,6 +1694,8 @@ enable_82xx_npiv:
 				if (!fw_major_version && ql2xallocfwdump
 				    && !(IS_P3P_TYPE(ha)))
 					qla2x00_alloc_fw_dump(vha);
+			} else {
+				goto failed;
 			}
 		} else {
 			ql_log(ql_log_fatal, vha, 0x00cd,
-- 
1.7.7

