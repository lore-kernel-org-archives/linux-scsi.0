From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] target: tcm_loop: use put_device() if device_register fail
Date: Wed,  7 Mar 2018 15:18:51 +0530
Message-ID: <4903df0f8cc170db01c65ead87d3b7af9fa269c8.1520415984.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

if device_register() returned an error! Always use put_device()
to give up the reference initialized.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/target/loopback/tcm_loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 9cd4ffe..5dffc55 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -412,6 +412,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
 		pr_err("device_register() failed for tl_hba->dev: %d\n", ret);
+		put_device(&tl_hba->dev);
 		return -ENODEV;
 	}
 
-- 
1.9.1
