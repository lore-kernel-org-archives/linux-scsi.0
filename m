From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 13/59] scsi: bnx2fc: Fix NULL dereference in error handling
Date: Wed, 26 Dec 2018 17:37:53 -0500
Message-ID: <20181226223839.150262-13-sashal@kernel.org>
References: <20181226223839.150262-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181226223839.150262-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9ae4f8420ed7be4b13c96600e3568c144d101a23 ]

If "interface" is NULL then we can't release it and trying to will only
lead to an Oops.

Fixes: aea71a024914 ("[SCSI] bnx2fc: Introduce interface structure for each vlan interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 6844ba361616..89f09b122135 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2372,7 +2372,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 	if (!interface) {
 		printk(KERN_ERR PFX "bnx2fc_interface_create failed\n");
 		rc = -ENOMEM;
-		goto ifput_err;
+		goto netdev_err;
 	}
 
 	if (is_vlan_dev(netdev)) {
-- 
2.19.1
