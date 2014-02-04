From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 05/22] csiostor: Remove superfluous call to pci_disable_msix()
Date: Tue,  4 Feb 2014 12:16:51 +0100
Message-ID: <6370db6e9c7174b586f9df844aa2d382ccc36e57.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Naresh Kumar Inna <naresh@chelsio.com>, Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Naresh Kumar Inna <naresh@chelsio.com>
Cc: Arvind Bhushan <arvindb@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/csiostor/csio_isr.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
index 7ee9777..91ba91d 100644
--- a/drivers/scsi/csiostor/csio_isr.c
+++ b/drivers/scsi/csiostor/csio_isr.c
@@ -529,10 +529,8 @@ csio_enable_msix(struct csio_hw *hw)
 			csio_reduce_sqsets(hw, cnt - extra);
 		}
 	} else {
-		if (rv > 0) {
-			pci_disable_msix(hw->pdev);
+		if (rv > 0)
 			csio_info(hw, "Not using MSI-X, remainder:%d\n", rv);
-		}
 
 		kfree(entries);
 		return -ENOMEM;
-- 
1.7.7.6
