From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 7/9] target: Add internal READ_INSERT support
Date: Sat, 28 Feb 2015 10:36:04 +0000
Message-ID: <1425119766-11878-8-git-send-email-nab@daterainc.com>
References: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:55277 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbB1LKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 06:10:08 -0500
Received: by mail-oi0-f45.google.com with SMTP id i138so19852134oig.4
        for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2015 03:10:07 -0800 (PST)
In-Reply-To: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds READ_INSERT support in target_check_read_prot() that
invokes sbc_dif_generate() when LIO is responsible for generating the
outgoing T10-PI.

Required for supporting fabrics that exchange protection information,
and would like to function with un-protected devices.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3b9923f..1fd0f12 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1970,6 +1970,12 @@ static bool target_check_read_prot(struct se_cmd *cmd)
 			}
 		}
 		break;
+	case TARGET_PROT_DIN_INSERT:
+		if (cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_INSERT)
+			break;
+
+		sbc_dif_generate(cmd);
+		break;
 	default:
 		break;
 	}
-- 
1.9.1

