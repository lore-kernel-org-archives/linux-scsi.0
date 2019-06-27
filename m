From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 59/87] scsi: mpt3sas: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:44:05 +0800
Message-ID: <20190627174406.5360-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 60ae2d0feb2b..b09af57840d8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1111,7 +1111,6 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	rc = -EINVAL;
-	memset(data_out, 0, sz);
 	phy_error_log_request = data_out;
 	phy_error_log_request->smp_frame_type = 0x40;
 	phy_error_log_request->function = 0x11;
@@ -1401,7 +1400,6 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	rc = -EINVAL;
-	memset(data_out, 0, sz);
 	phy_control_request = data_out;
 	phy_control_request->smp_frame_type = 0x40;
 	phy_control_request->function = 0x91;
-- 
2.11.0
