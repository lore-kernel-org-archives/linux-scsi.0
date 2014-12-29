From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [SCSI] aha152x: cleanup on stack DECLARE_COMPLETION
Date: Mon, 29 Dec 2014 13:51:00 -0500
Message-ID: <1419879060-29972-1-git-send-email-der.herr@hofr.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Juergen E. Fischer" <fischer@norbit.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
List-Id: linux-scsi@vger.kernel.org

fix-up for incorrect use of DECLARE_COMPLETION. see also commit
6e9a4738 ("completions: lockdep annotate on stack completions")

V2: split out patch for individual files and (hopefully) proper
    labeling this time

patch is against linux-next 3.19.0-rc1 -next-20141226

patch was compile tested with i386_defconfig + CONFIG_ISA=y
SCSI_LOWLEVEL=y, CONFIG_SCSI_AHA152X=y

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/scsi/aha152x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 create mode 100644 fixups

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 2b960b3..b16afb9 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1055,7 +1055,7 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
 static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);
 	int ret, issued, disconnected;
 	unsigned char old_cmd_len = SCpnt->cmd_len;
 	unsigned long flags;
diff --git a/fixups b/fixups
new file mode 100644
index 0000000..e69de29
-- 
1.7.10.4
