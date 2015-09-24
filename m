From: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] scsi_dh: avoid allowing dh_state to pass format specs when requesting a module
Date: Wed, 23 Sep 2015 21:08:26 -0400
Message-ID: <1443056906-7306-1-git-send-email-sasha.levin@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
List-Id: linux-scsi@vger.kernel.org

A malicious string passed from userspace might contain format specifiers which
request_module() might try to handle, which is bad.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/scsi/scsi_dh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..24be260 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -111,7 +111,7 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 
 	dh = __scsi_dh_lookup(name);
 	if (!dh) {
-		request_module(name);
+		request_module("%s", name);
 		dh = __scsi_dh_lookup(name);
 	}
 
-- 
1.7.10.4
