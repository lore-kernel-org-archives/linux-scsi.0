From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/6] libata: Setup nbytes in ata_sg_init_one
Date: Wed, 07 Jun 2006 11:25:31 -0500
Message-ID: <200606071625.k57GPXRp013683@d01av01.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Setup nbytes in ata_sg_init_one to the total transfer length
of the command. This is needed by some HBAs that need to know
the total transfer length of each command.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/libata-core.c~libata_setup_nbytes drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_setup_nbytes	2006-06-05 12:52:22.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-06 08:55:34.000000000 -0500
@@ -3321,6 +3321,7 @@ void ata_sg_init_one(struct ata_queued_c
 	qc->n_elem = 1;
 	qc->orig_n_elem = 1;
 	qc->buf_virt = buf;
+	qc->nbytes = buflen;
 
 	sg = qc->__sg;
 	sg_init_one(sg, buf, buflen);
_
