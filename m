From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 06/21] scsi: bnx2fc: Fix NULL dereference in error handling
Date: Wed, 26 Dec 2018 17:54:44 -0500
Message-ID: <20181226225501.151365-6-sashal@kernel.org>
References: <20181226225501.151365-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181226225501.151365-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
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
index d0b227ffbd5f..573aeec7a02b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2279,7 +2279,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 	if (!interface) {
 		printk(KERN_ERR PFX "bnx2fc_interface_create failed\n");
 		rc = -ENOMEM;
-		goto ifput_err;
+		goto netdev_err;
 	}
 
 	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
-- 
2.19.1
