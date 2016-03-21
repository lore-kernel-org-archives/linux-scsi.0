From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 14/23] ncr5380: Reduce max_lun limit
Date: Mon, 21 Mar 2016 13:32:03 +1100
Message-ID: <20160321023153.323999176@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-max_lun
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

The driver has a limit of eight LUs because of the byte-sized bitfield
that is used for busy flags. That means the maximum LUN is 7. The default
is 8.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---

Changed since v1:
- Reduce shost->max_lun limit instead of adding 'MAX_LUN' limit.

---
 drivers/scsi/NCR5380.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-21 13:31:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-21 13:31:36.000000000 +1100
@@ -488,6 +488,8 @@ static int NCR5380_init(struct Scsi_Host
 	int i;
 	unsigned long deadline;
 
+	instance->max_lun = 7;
+
 	hostdata->host = instance;
 	hostdata->id_mask = 1 << instance->this_id;
 	hostdata->id_higher_mask = 0;
