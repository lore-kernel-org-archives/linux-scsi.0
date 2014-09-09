From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] drivers: target: target_core_transport.c: build warning
Date: Tue,  9 Sep 2014 12:53:50 +0530
Message-ID: <1410247430-11293-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

build is giving : 
warning: passing argument 1 of 'strlen' makes pointer from integer 
without a cast [enabled by default]

the snprintf after the strlen is trying to put the "Unsupported" string
at the end of exising string. so len should give the string length here

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1dd1181..3ce85ed 100644
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
1.8.1.2
