From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 022/103] target: Ensure transport_dump_vpd_ident_type returns null-terminated str
Date: Thu, 21 Jul 2011 00:04:58 -0700
Message-ID: <1311231979-6631-23-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.164]:38369 "HELO
	nm14-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750973Ab1GUHAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:00:47 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

strncpy() may leave the string not NULL-terminated if the buffer length
is shorter than the string. Return -EINVAL if too short, instead.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 473032e..72e4726 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1392,10 +1392,13 @@ int transport_dump_vpd_ident_type(
 		break;
 	}
 
-	if (p_buf)
+	if (p_buf) {
+		if (p_buf_len < strlen(buf)+1)
+			return -EINVAL;
 		strncpy(p_buf, buf, p_buf_len);
-	else
+	} else {
 		printk("%s", buf);
+	}
 
 	return ret;
 }
-- 
1.7.6

