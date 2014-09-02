From: Mark Brown <broonie@kernel.org>
Subject: [PATCH] target: target_core_transport: Don't try to strlen() an integer
Date: Wed,  3 Sep 2014 00:42:43 +0100
Message-ID: <1409701363-29341-1-git-send-email-broonie@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47172 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaIBXmy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2014 19:42:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linaro-kernel@lists.linaro.org, Mark Brown <broonie@kernel.org>

In transport_dump_vpd_ident_type() we try to call strlen() on the integer
len which is obviously a typo; take the length of the string already in
buf instead.

Fixes: 6cfa853ceee4a (target: target_core_transport.c: Cleaning up missing null-terminate
                      in conjunction with strncpy)
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1dd11818f38f..3ce85edc2ea9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -953,7 +953,7 @@ int transport_dump_vpd_ident_type(
 		strlcat(buf, "SCSI name string\n", sizeof(buf));
 		break;
 	default:
-		len = strlen(len);
+		len = strlen(buf);
 		snprintf(&buf[len], sizeof(buf) - len, "Unsupported: 0x%02x\n",
 				vpd->device_identifier_type);
 		ret = -EINVAL;
-- 
2.1.0

