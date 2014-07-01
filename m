From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv3 9/8] target: Fix return with spinlock held in scsi3_ua_check()
Date: Tue,  1 Jul 2014 09:15:37 -0700
Message-ID: <1404231337-7019-1-git-send-email-agrover@redhat.com>
References: <53B275CA.50002@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53B275CA.50002@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, mlombard@redhat.com
List-Id: linux-scsi@vger.kernel.org

Reported-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
---

Hi Maurizio, yup, thanks!

Here's a patch that fixes the issue - it can be applied as 9/8 or
alternatively squashed into 1/8.

Thanks again -- Regards -- Andy


 drivers/target/target_core_ua.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 5c9d980..0eac3a9 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -53,8 +53,10 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 
 	spin_lock_irq(&nacl->device_list_lock);
 	deve = nacl->device_list[cmd->orig_fe_lun];
-	if (!atomic_read(&deve->ua_count))
+	if (!atomic_read(&deve->ua_count)) {
+		spin_unlock_irq(&nacl->device_list_lock);
 		return 0;
+	}
 	spin_unlock_irq(&nacl->device_list_lock);
 
 	/*
-- 
1.9.3
