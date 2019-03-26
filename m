From: Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 1/3] zfcp: fix rport unblock if deleted SCSI devices on Scsi_Host
Date: Tue, 26 Mar 2019 14:36:58 +0100
Message-ID: <20190326133700.88655-2-maier@linux.ibm.com>
References: <20190326133700.88655-1-maier@linux.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190326133700.88655-1-maier@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

An already deleted SCSI device can exist on the Scsi_Host and remain
there because something still holds a reference.
A new SCSI device with the same H:C:T:L and FCP device, target port WWPN,
and FCP LUN can be created.
When we try to unblock an rport, we still find the deleted SCSI device
and return early because the zfcp_scsi_dev of that SCSI device is
not ZFCP_STATUS_COMMON_UNBLOCKED. Hence we miss to unblock the rport,
even if the new proper SCSI device would be in good state.

Therefore, skip deleted SCSI devices when iterating the sdevs of the shost.
[cf. __scsi_device_lookup{_by_target}() or scsi_device_get()]

The following abbreviated trace sequence can indicate such problem:

Area           : REC
Tag            : ersfs_3
LUN            : 0x4045400300000000
WWPN           : 0x50050763031bd327
LUN status     : 0x40000000     not ZFCP_STATUS_COMMON_UNBLOCKED
Ready count    : n		not incremented yet
Running count  : 0x00000000
ERP want       : 0x01
ERP need       : 0xc1		ZFCP_ERP_ACTION_NONE

Area           : REC
Tag            : ersfs_3
LUN            : 0x4045400300000000
WWPN           : 0x50050763031bd327
LUN status     : 0x41000000
Ready count    : n+1
Running count  : 0x00000000
ERP want       : 0x01
ERP need       : 0x01

...

Area           : REC
Level          : 4		only with increased trace level
Tag            : ertru_l
LUN            : 0x4045400300000000
WWPN           : 0x50050763031bd327
LUN status     : 0x40000000
Request ID     : 0x0000000000000000
ERP status     : 0x01800000
ERP step       : 0x1000
ERP action     : 0x01
ERP count      : 0x00

NOT followed by a trace record with tag "scpaddy"
for WWPN 0x50050763031bd327.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race with LUN recovery")
Cc: <stable@vger.kernel.org> #2.6.32+
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 744a64680d5b..c0b2348d7ce6 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1341,6 +1341,9 @@ static void zfcp_erp_try_rport_unblock(struct zfcp_port *port)
 		struct zfcp_scsi_dev *zsdev = sdev_to_zfcp(sdev);
 		int lun_status;
 
+		if (sdev->sdev_state == SDEV_DEL ||
+		    sdev->sdev_state == SDEV_CANCEL)
+			continue;
 		if (zsdev->port != port)
 			continue;
 		/* LUN under port of interest */
-- 
2.16.4
