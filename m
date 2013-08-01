From: Jan Vesely <jvesely@redhat.com>
Subject: [PATCH 2/2] mpt3sas: Remove phys on topology change
Date: Thu,  1 Aug 2013 12:01:31 +0200
Message-ID: <1375351291-27107-3-git-send-email-jvesely@redhat.com>
References: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Vesely <jvesely@redhat.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Jan Vesely <jvesely@redhat.com>

CC: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
CC: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Jan Vesely <jvesely@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 87ca2b7..45bc98e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1003,9 +1003,12 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 		    &mpt3sas_phy->remote_identify);
 		_transport_add_phy_to_an_existing_port(ioc, sas_node,
 		    mpt3sas_phy, mpt3sas_phy->remote_identify.sas_address);
-	} else
+	} else {
 		memset(&mpt3sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
+		_transport_del_phy_from_an_existing_port(ioc, sas_node,
+		    mpt3sas_phy);
+	}
 
 	if (mpt3sas_phy->phy)
 		mpt3sas_phy->phy->negotiated_linkrate =
-- 
1.7.1
