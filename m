Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69F7485507
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524144; cv=none; b=nObaLyH9iVz2W5go/faw7UB+7HSzwmC+960KlvrKmfVQoQ72cdyrdLSce+8HgIBfeShRvGSIQJZbNxH1zE3iEw5TAC7QAZls0ieeb+TgA7eUnq7EYsWk5EjmSVZBv4WCqKGoxEuOeJyfeQaqfnX7Cb18VrYzzBjCrzl1ZuKZCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524144; c=relaxed/simple;
	bh=WW1toyLzQdA+00pBdQfyFNAZlLSISwAtqqbj6pG3mA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAWTS88MUPIub9NB0r0Sv1/7z7fglKv5Ce1f8g6AlMGn1GJqaVaJeYcPSgrZeRapN1KDK7ztRD0ARdUCWG87+OKAqXr7bzkNQY3jkeIAZac4Gq2abZCeGkZFIB2Y6Lx0SX/sM8vToJMAWqC4H+QtBc834fxT/KAxwM1AwP1XjgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YBPyBkl1; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YBPyBkl1"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6aca0f482e5so901389eaf.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 05:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524140; x=1789128940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GV6g/d91EqbM9PkFl+IOKF3pCVame4JD/wD1xmbKfPs=;
        b=YBPyBkl1fvucTNmw/hyiZf4+qQfLA84sgcbxuDKkyZ3ebgCYpON9emx202RO+Qj8aS
         L+FKcR4uHtdLVOHKm2oF/V36JAhZgFEdX4yfzURWc2i3ezxCUAN2E+HEsYR9zy6Z4fKR
         J5LmeKYPbZIHkdC5txHTOMKLB0OIb4qArSAXVe9Bd72bqGjRsycjYnMDB5RCWDYqmKoz
         VMC9LtZ2HTGIlyWPNjibWV24S6/ctiOJrP2751H82gvQexxUk5oZMY+E3EwFVvj2M4tp
         nK6aZp9lsLmGD3xcgAb45tCOpUICMdq4e329A1uG9xcN4rhSlVdHPFt/fIc5kaaAKXRj
         Tazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524140; x=1789128940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GV6g/d91EqbM9PkFl+IOKF3pCVame4JD/wD1xmbKfPs=;
        b=YmRat+Vw7vnNFxn787iuwiKcaPDxyTpl6djYF0iYXJVWbl5k6eOdV9FYkzV2GTwUNO
         4JbMOlfMErRzjLbZk7qExRLAWeJpiMlX1nOdJKKeP34+h/Z3hlDnBlBxEM+cerhgz75D
         pEISdIGlDapWaJI72gVllNjGvH61UOIVz5U5KCklO1zRnivnjdDcj8ojAExFjezdtIez
         G8IhgLZ7MUfdW3kHqlPFkg0PeUwfRejG8NlKF8rXXFn4gGypOwcwyZ+u2cwx+osQ+C4p
         M0R4jIJ0kq3bfjoAr+Bximp4Hdnx3U7BYig5ydzWSQnAv8YRqY4vDHf/7QTQdICNNNz2
         OkxQ==
X-Forwarded-Encrypted: i=1; AKwUvBztcc3n1vRvBehQXAjqJy1vaZtuU3zWmECynsMn5f3GV63BYZL0KJTYKrJP4jiBoRG7FbYIQcGFrw81@vger.kernel.org
X-Gm-Message-State: AFuF++mBp0mW7lqXxg3Xyj0h1HmZFclVwlsML8wsdgg+LS93ysiyfviz
	mQFENHYBH58daqB32m3jnXBQb5/jXOLHbGHM9Ki3Jiw/xHT35VKXpsHL
X-Gm-Gg: AYBFou3GLnrBoblCeC/1rqpB2FOD/HxpJQk/7uMVcuxSFcxKpxyjVMGd+kGNmDU5sLO
	fQwoF0+maFmmRrzBFqhdIKDF8T0dSO8ooyg5yWiLiwMa4CmRGDtHLiOEuo7nRlKx341wIdaqKR6
	nQ9yKItx29/Sooz4aYNmyN56qhhrbhlmc1vXG26aOSKBN2zPf4esw/+F/t3pV2aedQKjnYKLVxo
	pyKkbCOcv9smDklNlW2p9sJGUuOfJmKbKe9YE8WVHC8L4ldFE2B22xO2yXmTs76CZ4/Gq8qY71u
	rvk/V99imskwlgADx+TFkrqd1YFpUyw9wtdPbKi57UG6aJJSez32O2+LR2CiiCj/7Yo6oMbNgAF
	vNs1g5EeMwn5rsR57lgipC8fmxczL9RbfNF0fdE8hh0Qpw3iM5Lu0cdLYEzbRjeHpiOsE8YXFIB
	QP84FPJb681ReABhI9CtiIh4JHjRyx5cOoE1NPcgT6keSbajcRPJ6dcOqr/Epdj5YwZPzxKke3d
	oYHfwuXghq89/s=
X-Received: by 2002:a05:6820:1985:b0:6b7:8415:d788 with SMTP id 006d021491bc7-6b78415d841mr1357479eaf.51.1788524140200;
        Fri, 04 Sep 2026 05:15:40 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432424d27asm9311666c88.2.2026.09.04.05.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:15:39 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Hannes Reinecke <hare@suse.de>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Don Brace <don.brace@microchip.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Doug Gilbert <dgilbert@interlog.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	storagedev@microchip.com,
	megaraidlinux.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 2/2] scsi: fix repeated words in comments
Date: Fri,  4 Sep 2026 17:44:23 +0530
Message-ID: <20260904121449.24178-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904121449.24178-1-hemanth.selam@gmail.com>
References: <20260904121449.24178-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop words accidentally written twice, reported by checkpatch.pl as a
possible repeated word.  Only touches comments, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/scsi/aic94xx/aic94xx_scb.c          | 2 +-
 drivers/scsi/bfa/bfa_fcpim.h                | 2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c            | 2 +-
 drivers/scsi/dc395x.c                       | 2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c               | 4 ++--
 drivers/scsi/fnic/vnic_devcmd.h             | 2 +-
 drivers/scsi/hpsa.c                         | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c            | 6 +++---
 drivers/scsi/lpfc/lpfc_init.c               | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c                | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h         | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    | 2 +-
 drivers/scsi/sd.c                           | 2 +-
 drivers/scsi/sg.c                           | 2 +-
 drivers/scsi/snic/snic_debugfs.c            | 2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c         | 2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h         | 2 +-
 18 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 08c8dad9ad62..f0a2a5a26a88 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -621,7 +621,7 @@ int asd_init_post_escbs(struct asd_ha_struct *asd_ha)
  * A note on LEDs:
  *  - an LED blinks if there is IO though it,
  *  - if a device is connected to the LED, it is lit,
- *  - if no device is connected to the LED, is is dimmed (off).
+ *  - if no device is connected to the LED, is dimmed (off).
  */
 static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 					 struct done_list_struct *dl)
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index a89b806c68d1..60912cb438cb 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -67,7 +67,7 @@ void bfa_fcp_res_recfg(struct bfa_s *bfa, u16 num_ioim_fw, u16 max_ioim_fw);
 #define BFA_IOIM_IOTAG_MASK 0x07ff /* 2K IOs */
 #define BFA_IOIM_RETRY_MAX 7
 
-/* Buckets are are 512 bytes to 2MB */
+/* Buckets are 512 bytes to 2MB */
 static inline u32
 bfa_ioim_get_index(u32 n) {
 	int pos = 0;
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 0cff934e0f36..d7af1431358b 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1987,7 +1987,7 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			/*
 			 * Device's PID has changed. We need to cleanup
 			 * and re-login. If there is another device with
-			 * the the newly discovered pid, send an scn notice
+			 * the newly discovered pid, send an scn notice
 			 * so that its new pid can be discovered.
 			 */
 			list_for_each(qe, &rport->port->rport_q) {
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index ba490174a417..e8958a921624 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3632,7 +3632,7 @@ static void adapter_init_params(struct AdapterCtlBlk *acb)
  * values that we have already stored in the adapter instance. There's
  * some mention that a lot of these are deprecated, so we won't use
  * them (we'll use the ones in the adapter instance) but we'll fill
- * them in in case something else needs them.
+ * them in case something else needs them.
  *
  * The eeprom structure, irq and io ports in the adapter need to have
  * been set before calling this function.
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 496ddd45f74d..ca81addbe17b 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -205,7 +205,7 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 		 * that doesn't have a priv (fcf was deleted). However,
 		 * libfcoe will always delete FCFs before trying to add
 		 * them. This is ensured because both recv_adv and
-		 * age_fcfs are protected by the the fcoe_ctlr's mutex.
+		 * age_fcfs are protected by the fcoe_ctlr's mutex.
 		 * This means that we should never get a FCF with a
 		 * non-NULL priv pointer.
 		 */
@@ -689,7 +689,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
  *
  * The caller must check that the length is a multiple of 4.
  * The SKB must have enough headroom (28 bytes) and tailroom (8 bytes).
- * The the skb must also be an fc_frame.
+ * The skb must also be an fc_frame.
  *
  * This is called from the lower-level driver with spinlocks held,
  * so we must not take a mutex here.
diff --git a/drivers/scsi/fnic/vnic_devcmd.h b/drivers/scsi/fnic/vnic_devcmd.h
index 20878a3e9e26..9c55cc57de16 100644
--- a/drivers/scsi/fnic/vnic_devcmd.h
+++ b/drivers/scsi/fnic/vnic_devcmd.h
@@ -299,7 +299,7 @@ enum vnic_devcmd_cmd {
 	 *
 	 *   intr_timer_cycles = intr_timer_usec * multiplier / divisor
 	 *
-	 * Interrupt coalescing timer in usecs can be be converted/obtained
+	 * Interrupt coalescing timer in usecs can be converted/obtained
 	 * from CPU cycles as follows:
 	 *
 	 *   intr_timer_usec = intr_timer_cycles * divisor / multiplier
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8edad1830abe..38da98e94030 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9173,7 +9173,7 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	struct access_method access = SA5_performant_access;
 
 	/* This is a bit complicated.  There are 8 registers on
-	 * the controller which we write to to tell it 8 different
+	 * the controller which we write to tell it 8 different
 	 * sizes of commands which there may be.  It's a way of
 	 * reducing the DMA done to fetch each command.  Encoded into
 	 * each command's tag are 3 bits which communicate to the controller
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 30e3cc050aaa..59c68a2a1dc2 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -137,7 +137,7 @@ static struct lpfc_idiag idiag;
  * gather from the beginning of the log and process until the current entry.
  *
  * Notes:
- * Discovery logging will be disabled while while this routine dumps the log.
+ * Discovery logging will be disabled while this routine dumps the log.
  *
  * Return Value:
  * This routine returns the amount of bytes that were dumped into @buf and will
@@ -203,7 +203,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
  * gather from the beginning of the log and process until the current entry.
  *
  * Notes:
- * Slow ring logging will be disabled while while this routine dumps the log.
+ * Slow ring logging will be disabled while this routine dumps the log.
  *
  * Return Value:
  * This routine returns the amount of bytes that were dumped into @buf and will
@@ -2546,7 +2546,7 @@ lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
  * @ppos: The position in the file to start reading from.
  *
  * Description:
- * This routine reads data from from the buffer indicated in the private_data
+ * This routine reads data from the buffer indicated in the private_data
  * field of @file. It will start reading at @ppos and copy up to @nbytes of
  * data to @buf.
  *
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 23355f12fbff..7a949918945d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13681,7 +13681,7 @@ lpfc_reg_congestion_buf(struct lpfc_hba *phba)
  * This function is called in the SLI4 code path to read the port's
  * sli4 capabilities.
  *
- * This function may be be called from any context that can block-wait
+ * This function may be called from any context that can block-wait
  * for the completion.  The expectation is that this routine is called
  * typically from probe_one or from the online routine.
  **/
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cfa4371169f1..e532c577876e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4797,7 +4797,7 @@ lpfc_sli_brdready_s3(struct lpfc_hba *phba, uint32_t mask)
  *
  * This function checks the host status register to check if HBA is
  * ready. This function will wait in a loop for the HBA to be ready
- * If the HBA is not ready , the function will will reset the HBA PCI
+ * If the HBA is not ready , the function will reset the HBA PCI
  * function again. The function returns 1 when HBA fail to be ready
  * otherwise returns zero.
  **/
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 056cbe50e19e..b380c4853df9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2552,14 +2552,14 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
 }
 
 /**
- * megasas_stream_detect -	stream detection on read and and write IOs
+ * megasas_stream_detect -	stream detection on read and write IOs
  * @instance:		Adapter soft state
  * @cmd:		    Command to be prepared
  * @io_info:		IO Request info
  *
  */
 
-/** stream detection on read and and write IOs */
+/** stream detection on read and write IOs */
 static void megasas_stream_detect(struct megasas_instance *instance,
 				  struct megasas_cmd_fusion *cmd,
 				  struct IO_REQUEST_INFO *io_info)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 458a716b7f7d..80b9997254c6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -840,7 +840,7 @@ struct _enclosure_node {
 /**
  * enum reset_type - reset state
  * @FORCE_BIG_HAMMER: issue diagnostic reset
- * @SOFT_RESET: issue message_unit_reset, if fails to to big hammer
+ * @SOFT_RESET: issue message_unit_reset, if fails to big hammer
  */
 enum reset_type {
 	FORCE_BIG_HAMMER,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e74a526efa8d..2dfbc28052c2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1812,7 +1812,7 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 		goto out;
 	}
 
-	/* unable to enable/disable phys when when discovery is active */
+	/* unable to enable/disable phys when discovery is active */
 	for (i = 0, discovery_active = 0; i < ioc->sas_hba.num_phys ; i++) {
 		if (sas_iounit_pg0->PhyData[i].PortFlags &
 		    MPI2_SASIOUNIT0_PORTFLAGS_DISCOVERY_IN_PROGRESS) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e54..86934080f499 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2249,7 +2249,7 @@ static void scsi_disk_free_disk(struct gendisk *disk)
  *
  *	This function is called by the SCSI midlayer before starting
  *	SCSI EH. When counting medium access failures we have to be
- *	careful to register it only only once per device and SCSI EH run;
+ *	careful to register it only once per device and SCSI EH run;
  *	there might be several timed out commands which will cause the
  *	'max_medium_access_timeouts' counter to trigger after the first
  *	SCSI EH run already and set the device to offline.
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 66be4f1a0316..05a3fc108ffd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -688,7 +688,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	}
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
-	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
+	 * but is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
 	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index edf3e5ef28a6..2b38c473ea6e 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -360,7 +360,7 @@ void snic_stats_debugfs_init(struct snic *snic)
  *
  * Description:
  * When Debufs is configured this routine removes debugfs file system
- * elements that are specific to to snic stats
+ * elements that are specific to snic stats
  */
 void
 snic_stats_debugfs_remove(struct snic *snic)
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index d5ca66afab34..8e6740215910 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5052,7 +5052,7 @@ static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln)
 	int i;
 
 	/*
-	 *  Allocate the task table and and the tag allocation 
+	 *  Allocate the task table and the tag allocation 
 	 *  circular buffer. We want both or none.
 	 */
 	lp->itlq_tbl = sym_calloc_dma(SYM_CONF_MAX_TASK*4, "ITLQ_TBL");
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 9231a2899064..0c212788531a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -357,7 +357,7 @@ struct sym_tcbh {
 	/*
 	 *  Scripts bus addresses of LUN table accessed from scripts.
 	 *  LUN #0 is a special case, since multi-lun devices are rare, 
-	 *  and we we want to speed-up the general case and not waste 
+	 *  and we want to speed-up the general case and not waste 
 	 *  resources.
 	 */
 	u32	luntbl_sa;	/* bus address of this table	*/
-- 
2.48.1

