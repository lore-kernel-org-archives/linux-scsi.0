From: Colin King <colin.king@canonical.com>
Subject: [PATCH] mptsas:  fix undefined behaviour of a shift of an int by more than 31 places
Date: Sat,  4 May 2019 17:40:10 +0100
Message-ID: <20190504164010.24937-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the shift of int value 1 by more than 31 places can result
in undefined behaviour. Fix this by making the 1 a ULL value before the
shift operation.

Addresses-Coverity: ("Bad shift operation")
Fixes: 547f9a218436 ("[SCSI] mptsas: wide port support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/message/fusion/mptsas.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 6a79cd0ebe2b..51dcbbcf2518 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -854,7 +854,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		    "%s: [%p]: deleting phy = %d\n",
 		    ioc->name, __func__, port_details, i));
 		port_details->num_phys--;
-		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
+		port_details->phy_bitmask &= ~(1ULL << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
 		if (phy_info->phy) {
 			devtprintk(ioc, dev_printk(KERN_DEBUG,
@@ -889,7 +889,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 			port_details->port_info = port_info;
 			if (phy_info->phy_id < 64 )
 				port_details->phy_bitmask |=
-				    (1 << phy_info->phy_id);
+				    (1ULL << phy_info->phy_id);
 			phy_info->sas_port_add_phy=1;
 			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tForming port\n\t\t"
 			    "phy_id=%d sas_address=0x%018llX\n",
@@ -931,7 +931,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 			phy_info_cmp->port_details = port_details;
 			if (phy_info_cmp->phy_id < 64 )
 				port_details->phy_bitmask |=
-				(1 << phy_info_cmp->phy_id);
+				(1ULL << phy_info_cmp->phy_id);
 			port_details->num_phys++;
 		}
 	}
-- 
2.20.1
