Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C87E34D90E;
	Mon, 16 Mar 2026 22:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773700648; cv=none; b=Ayr7CE2+gABAaD06HcJNK6COfrAwyPhsDi6eE7ohpMzw0Rymsnt8hNDf+B0UF2fN42J+R/NerbxcvyLcAvZ4P30Fh9N/nZ7eyPS94hwQfVlw4wL+2gLecYTNiHNN6xO0lQKKqlhnjNA0KdJi5WU5cc5qzF6GV4Emr3Zi3UutBQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773700648; c=relaxed/simple;
	bh=aUKkitkoVezgo05gfBMPBLJrPdwH02m/EFH+p1VoEOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JUHv3G32iJseN+cJjy5tUAqZZD88Lp3og1b5FlOQX/c39ArbBJJ6BmkxH/PvvwjKzRdDabsCsu0d6MpALZr2Os63FZbDxdxpoCcqS2d8nGyD8A6kdDSIaOvTppoQ9oRfvS3r2JjGkyh9mvv76zocmgJeEVOkryjAvGJsmAWIYC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoFCnY8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoFCnY8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F7DC19421;
	Mon, 16 Mar 2026 22:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773700648;
	bh=aUKkitkoVezgo05gfBMPBLJrPdwH02m/EFH+p1VoEOU=;
	h=From:To:Cc:Subject:Date:From;
	b=NoFCnY8okz/ep10onzd7Twng/vMyQxS7hESLd1zsK7TS8sFPkuaEtq9vldY+sKUVS
	 lgpE452SVJZD31qKioWcfezrlV44f9Ee8hzZEzxdEc2cbF01dLOVnF4o4NJnVYRF8V
	 8qxVJh9n6A8D3N2JTe3eRJ4gxdm62U5ZvLoE89qF2bYt8ILLti38s3s6QXmCq6s94A
	 uq9aX8W+gFMOM1b9kejzzhoB7S2gk+U7zphMj5fQU2uPHi3Sh8/CTQqbPm5kKAW0zK
	 JU+XiigukaisfCmJbIEbvd/kS8EAvULx9rP8ST1iyALU0Ab2LOpjHtmJgCAwdUE6k/
	 yCUwfWo/+8U9w==
From: Eric Biggers <ebiggers@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] scsi: lpfc: Use the crc32c() function
Date: Mon, 16 Mar 2026 15:36:31 -0700
Message-ID: <20260316223631.72361-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lpfc_cgn_calc_crc32(data, size, crc) is really just an open-coded
version of ~crc32c(bitrev32(crc), data, size).  However, all callers
pass crc == ~0, so it can be simplified even further to just ~crc32c(~0,
data, size).  Remove the crc argument and implement it that way.

While we're at it, also use proper types in the function prototype.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/scsi/Kconfig          |  1 +
 drivers/scsi/lpfc/lpfc.h      |  2 --
 drivers/scsi/lpfc/lpfc_crtn.h |  2 +-
 drivers/scsi/lpfc/lpfc_els.c  |  6 ++--
 drivers/scsi/lpfc/lpfc_init.c | 58 +++++------------------------------
 5 files changed, 12 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 19d0884479a2..f811ce473c2a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1149,10 +1149,11 @@ config SCSI_LPFC
 	depends on CPU_FREQ
 	depends on SCSI_FC_ATTRS
 	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
 	depends on NVME_FC || NVME_FC=n
 	select CRC_T10DIF
+	select CRC32
 	select IRQ_POLL
 	help
           This lpfc driver supports the Emulex LightPulse
           Family of Fibre Channel PCI host adapters.
 
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 689793d03c20..d9d104d0e640 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -550,12 +550,10 @@ struct lpfc_cgn_info {
 		struct lpfc_cgn_ts stat_lnk;	/* Last link integrity FPIN */
 		struct lpfc_cgn_ts stat_delivery;	/* Last delivery notification FPIN */
 	);
 
 	__le32   cgn_info_crc;
-#define LPFC_CGN_CRC32_MAGIC_NUMBER	0x1EDC6F41
-#define LPFC_CGN_CRC32_SEED		0xFFFFFFFF
 };
 
 #define LPFC_CGN_INFO_SZ	(sizeof(struct lpfc_cgn_info) -  \
 				sizeof(uint32_t))
 
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index efeb61b15a5b..f0e0292a5c94 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -84,11 +84,11 @@ void lpfc_cmf_signal_init(struct lpfc_hba *phba);
 void lpfc_cmf_start(struct lpfc_hba *phba);
 void lpfc_cmf_stop(struct lpfc_hba *phba);
 void lpfc_init_congestion_stat(struct lpfc_hba *phba);
 void lpfc_init_congestion_buf(struct lpfc_hba *phba);
 int lpfc_sli4_cgn_params_read(struct lpfc_hba *phba);
-uint32_t lpfc_cgn_calc_crc32(void *bufp, uint32_t sz, uint32_t seed);
+uint32_t lpfc_cgn_calc_crc32(const void *data, size_t size);
 int lpfc_config_cgn_signal(struct lpfc_hba *phba);
 int lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total);
 void lpfc_cgn_dump_rxmonitor(struct lpfc_hba *phba);
 void lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag);
 void lpfc_unblock_requests(struct lpfc_hba *phba);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index cee709617a31..77f3d6e415ca 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10289,14 +10289,12 @@ lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 						phba->cgn_i->virt;
 					cp->cgn_alarm_freq =
 						cpu_to_le16(value);
 					cp->cgn_warn_freq =
 						cpu_to_le16(value);
-					crc = lpfc_cgn_calc_crc32
-						(cp,
-						LPFC_CGN_INFO_SZ,
-						LPFC_CGN_CRC32_SEED);
+					crc = lpfc_cgn_calc_crc32(
+						cp, LPFC_CGN_INFO_SZ);
 					cp->cgn_info_crc = cpu_to_le32(crc);
 				}
 
 				/* Don't deliver to upper layer since
 				 * driver took action on this tlv.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e9d9ac7da485..27d14b516a45 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -20,10 +20,11 @@
  * more details, a copy of which can be found in the file COPYING  *
  * included with this package.                                     *
  *******************************************************************/
 
 #include <linux/blkdev.h>
+#include <linux/crc32.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -5632,12 +5633,11 @@ lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag)
 	    phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ) {
 		value = LPFC_CGN_TIMER_TO_MIN / phba->cgn_fpin_frequency;
 		cp->cgn_stat_npm = value;
 	}
 
-	value = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
-				    LPFC_CGN_CRC32_SEED);
+	value = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ);
 	cp->cgn_info_crc = cpu_to_le32(value);
 }
 
 /**
  * lpfc_cgn_update_tstamp - Update cmf timestamp
@@ -5895,12 +5895,11 @@ lpfc_cmf_stats_timer(struct hrtimer *timer)
 	/* Use the frequency found in the last rcv'ed FPIN */
 	value = phba->cgn_fpin_frequency;
 	cp->cgn_warn_freq = cpu_to_le16(value);
 	cp->cgn_alarm_freq = cpu_to_le16(value);
 
-	lvalue = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
-				     LPFC_CGN_CRC32_SEED);
+	lvalue = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ);
 	cp->cgn_info_crc = cpu_to_le32(lvalue);
 
 	hrtimer_forward_now(timer, ktime_set(0, LPFC_SEC_MIN * NSEC_PER_SEC));
 
 	return HRTIMER_RESTART;
@@ -7119,12 +7118,11 @@ lpfc_cgn_params_parse(struct lpfc_hba *phba,
 			cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
 			cp->cgn_info_mode = phba->cgn_p.cgn_param_mode;
 			cp->cgn_info_level0 = phba->cgn_p.cgn_param_level0;
 			cp->cgn_info_level1 = phba->cgn_p.cgn_param_level1;
 			cp->cgn_info_level2 = phba->cgn_p.cgn_param_level2;
-			crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
-						  LPFC_CGN_CRC32_SEED);
+			crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ);
 			cp->cgn_info_crc = cpu_to_le32(crc);
 		}
 		spin_unlock_irq(&phba->hbalock);
 
 		phba->cmf_active_mode = phba->cgn_p.cgn_param_mode;
@@ -13493,58 +13491,18 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Stop the SLI4 device port */
 	if (phba->pport)
 		phba->pport->work_port_events = 0;
 }
 
-static uint32_t
-lpfc_cgn_crc32(uint32_t crc, u8 byte)
-{
-	uint32_t msb = 0;
-	uint32_t bit;
-
-	for (bit = 0; bit < 8; bit++) {
-		msb = (crc >> 31) & 1;
-		crc <<= 1;
-
-		if (msb ^ (byte & 1)) {
-			crc ^= LPFC_CGN_CRC32_MAGIC_NUMBER;
-			crc |= 1;
-		}
-		byte >>= 1;
-	}
-	return crc;
-}
-
-static uint32_t
-lpfc_cgn_reverse_bits(uint32_t wd)
-{
-	uint32_t result = 0;
-	uint32_t i;
-
-	for (i = 0; i < 32; i++) {
-		result <<= 1;
-		result |= (1 & (wd >> i));
-	}
-	return result;
-}
-
 /*
  * The routine corresponds with the algorithm the HBA firmware
  * uses to validate the data integrity.
  */
 uint32_t
-lpfc_cgn_calc_crc32(void *ptr, uint32_t byteLen, uint32_t crc)
+lpfc_cgn_calc_crc32(const void *data, size_t size)
 {
-	uint32_t  i;
-	uint32_t result;
-	uint8_t  *data = (uint8_t *)ptr;
-
-	for (i = 0; i < byteLen; ++i)
-		crc = lpfc_cgn_crc32(crc, data[i]);
-
-	result = ~lpfc_cgn_reverse_bits(crc);
-	return result;
+	return ~crc32c(~0, data, size);
 }
 
 void
 lpfc_init_congestion_buf(struct lpfc_hba *phba)
 {
@@ -13589,11 +13547,11 @@ lpfc_init_congestion_buf(struct lpfc_hba *phba)
 
 	/* last used Index initialized to 0xff already */
 
 	cp->cgn_warn_freq = cpu_to_le16(LPFC_FPIN_INIT_FREQ);
 	cp->cgn_alarm_freq = cpu_to_le16(LPFC_FPIN_INIT_FREQ);
-	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ, LPFC_CGN_CRC32_SEED);
+	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ);
 	cp->cgn_info_crc = cpu_to_le32(crc);
 
 	phba->cgn_evt_timestamp = jiffies +
 		msecs_to_jiffies(LPFC_CGN_TIMER_TO_MIN);
 }
@@ -13612,11 +13570,11 @@ lpfc_init_congestion_stat(struct lpfc_hba *phba)
 
 	cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
 	memset(&cp->cgn_stat, 0, sizeof(cp->cgn_stat));
 
 	lpfc_cgn_update_tstamp(phba, &cp->stat_start);
-	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ, LPFC_CGN_CRC32_SEED);
+	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ);
 	cp->cgn_info_crc = cpu_to_le32(crc);
 }
 
 /**
  * __lpfc_reg_congestion_buf - register congestion info buffer with HBA

base-commit: 2d1373e4246da3b58e1df058374ed6b101804e07
-- 
2.53.0

