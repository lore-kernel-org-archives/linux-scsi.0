From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 15/21] aic94xx: Fix DDB and SCB initialization
Date: Thu, 11 Jan 2007 14:15:29 -0800
Message-ID: <20070111221529.3543.8533.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35504 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbXAKWPK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:10 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMF995026342
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:09 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMF9Sx289056
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:09 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMF9jT014042
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:09 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Ed Chim of Adaptec informs us that the DDB registers need to be zeroed at
initialization time and that some SCB initializations need to happen even if
we don't use the SCB.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 drivers/scsi/aic94xx/aic94xx_sas.h  |    1 +
 drivers/scsi/aic94xx/aic94xx_seq.c  |   33 +++++++++++++++++++++++----------
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 6faa10f..7344f4d 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -234,7 +234,7 @@ static int __devinit asd_common_setup(st
 	}
 	/* Provide some sane default values. */
 	asd_ha->hw_prof.max_scbs = 512;
-	asd_ha->hw_prof.max_ddbs = 128;
+	asd_ha->hw_prof.max_ddbs = ASD_MAX_DDBS;
 	asd_ha->hw_prof.num_phys = ASD_MAX_PHYS;
 	/* All phys are enabled, by default. */
 	asd_ha->hw_prof.enabled_phys = 0xFF;
diff --git a/drivers/scsi/aic94xx/aic94xx_sas.h b/drivers/scsi/aic94xx/aic94xx_sas.h
index 9050e93..fa7c529 100644
--- a/drivers/scsi/aic94xx/aic94xx_sas.h
+++ b/drivers/scsi/aic94xx/aic94xx_sas.h
@@ -34,6 +34,7 @@ #include <scsi/libsas.h>
  * domain that this sequencer can maintain low-level connections for
  * us.  They are be 64 bytes.
  */
+#define ASD_MAX_DDBS	128
 
 struct asd_ddb_ssp_smp_target_port {
 	u8     conn_type;	  /* byte 0 */
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 21569ec..0d343cf 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -907,6 +907,16 @@ static void asd_init_scb_sites(struct as
 		for (i = 0; i < ASD_SCB_SIZE; i += 4)
 			asd_scbsite_write_dword(asd_ha, site_no, i, 0);
 
+		/* Initialize SCB Site Opcode field to invalid. */
+		asd_scbsite_write_byte(asd_ha, site_no,
+				       offsetof(struct scb_header, opcode),
+				       0xFF);
+
+		/* Initialize SCB Site Flags field to mean a response
+		 * frame has been received.  This means inadvertent
+		 * frames received to be dropped. */
+		asd_scbsite_write_byte(asd_ha, site_no, 0x49, 0x01);
+
 		/* Workaround needed by SEQ to fix a SATA issue is to exclude
 		 * certain SCB sites from the free list. */
 		if (!SCB_SITE_VALID(site_no))
@@ -922,16 +932,6 @@ static void asd_init_scb_sites(struct as
 		/* Q_NEXT field of the last SCB is invalidated. */
 		asd_scbsite_write_word(asd_ha, site_no, 0, first_scb_site_no);
 
-		/* Initialize SCB Site Opcode field to invalid. */
-		asd_scbsite_write_byte(asd_ha, site_no,
-				       offsetof(struct scb_header, opcode),
-				       0xFF);
-
-		/* Initialize SCB Site Flags field to mean a response
-		 * frame has been received.  This means inadvertent
-		 * frames received to be dropped. */
-		asd_scbsite_write_byte(asd_ha, site_no, 0x49, 0x01);
-
 		first_scb_site_no = site_no;
 		max_scbs++;
 	}
@@ -1173,6 +1173,16 @@ static void asd_init_ddb_0(struct asd_ha
 	set_bit(0, asd_ha->hw_prof.ddb_bitmap);
 }
 
+static void asd_seq_init_ddb_sites(struct asd_ha_struct *asd_ha)
+{
+	unsigned int i;
+	unsigned int ddb_site;
+
+	for (ddb_site = 0 ; ddb_site < ASD_MAX_DDBS; ddb_site++)
+		for (i = 0; i < sizeof(struct asd_ddb_ssp_smp_target_port); i+= 4)
+			asd_ddbsite_write_dword(asd_ha, ddb_site, i, 0);
+}
+
 /**
  * asd_seq_setup_seqs -- setup and initialize central and link sequencers
  * @asd_ha: pointer to host adapter structure
@@ -1182,6 +1192,9 @@ static void asd_seq_setup_seqs(struct as
 	int 		lseq;
 	u8		lseq_mask;
 
+	/* Initialize DDB sites */
+	asd_seq_init_ddb_sites(asd_ha);
+
 	/* Initialize SCB sites. Done first to compute some values which
 	 * the rest of the init code depends on. */
 	asd_init_scb_sites(asd_ha);
