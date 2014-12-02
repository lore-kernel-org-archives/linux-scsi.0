From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 1/2] Revert "[SCSI] mpt2sas: Remove phys on topology change."
Date: Tue,  2 Dec 2014 20:58:46 +0530
Message-ID: <1417534127-6189-2-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1417534127-6189-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417534127-6189-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This reverts commit 3520f9c779bed098ca76dd3fb6377264301d57ed
("mpt2sas: Remove phys on topology change")

Reverting the previous mpt2sas drives patch changes,
since we will observe below issue

Issue:
Drives connected Enclosure/Expander will unregister with
SCSI Transport Layer, if any one remove and add expander
cable with in DMD (Device Missing Delay) time period or
even any one power-off and power-on the Enclosure with in
the DMD period.

Cc: <stable@vger.kernel.org>
Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 0d1d064..e689bf2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1006,12 +1006,9 @@ mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
 		    &mpt2sas_phy->remote_identify);
 		_transport_add_phy_to_an_existing_port(ioc, sas_node,
 		    mpt2sas_phy, mpt2sas_phy->remote_identify.sas_address);
-	} else {
+	} else
 		memset(&mpt2sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
-		_transport_del_phy_from_an_existing_port(ioc, sas_node,
-		    mpt2sas_phy);
-	}
 
 	if (mpt2sas_phy->phy)
 		mpt2sas_phy->phy->negotiated_linkrate =
-- 
2.0.2
