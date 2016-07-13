From: tom.ty89@gmail.com
Subject: [RFC 3/3] libata-scsi: add optimal transfer length to block limits VPD
Date: Wed, 13 Jul 2016 12:47:08 +0800
Message-ID: <5659242e8546753768944757fc86988f1986585c.1468384890.git.tom.ty89@gmail.com>
References: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

As of commit 6b7e9cde4969 ("sd: Fix rw_max for devices that report
an optimal xfer size"), the scsi disk driver (correctly) derive both
of the queue limits "io_opt" and "max_sectors" from the optimal
transfer length field.

In case we would like the two limits to be derived from a value
other than BLK_DEF_MAX_SECTORS for ATA disks in the future, this
patch has made it easy.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..ab75b5e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2305,6 +2305,13 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	put_unaligned_be16(min_io_sectors, &rbuf[6]);
 
 	/*
+	 * Optimal transfer length.
+	 *
+	 * This is used to derive the queue limit "max_sector" and "io_opt".
+	 */
+	put_unaligned_be32(BLK_DEF_MAX_SECTORS, &rbuf[12]);
+
+	/*
 	 * Optimal unmap granularity.
 	 *
 	 * The ATA spec doesn't even know about a granularity or alignment
-- 
2.9.0

