Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3A54749DE
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547722; cv=none; b=lYFqzZhM27Pcuy1yBlFDvo8SAZnYY3KpMjpaqT7qjFa/VwYD6cE2GvN6Mff2clgIVUoNd5H6XG/MxjiwDHpXWIcmdWfNYFtpP1k3JtMWkSD053eBTBAAUNnCrnOayzNojxz8/x3rrROHLDkWBcw3aQYcPRy3jwbYHt/MzV035lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547722; c=relaxed/simple;
	bh=Auuvy03fEk/smktzUHXbSV3LiQi/SgfjHV4AxZMiK80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWHkc4YKT1ad588xhELM6Yp7vqX9pzBGRAdfXJ6TL2xWbN2yjXBQj53xsTqVna12JDIJsm3EKzQe83dSY5KAqktFsWJk0Kea6lE7DoVZRd4tq1avXRwxpQJlUPsaWP/RAqLegGe4TCdXNv51dlboOZb7L0jViGNyAlRcrhtem78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WUA4/Fx+; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WUA4/Fx+"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso4792738a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547718; x=1790152518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GtH5xYq2DxdcDESnx9DJzt+YE63P1nCpIdgUtrdL9ic=;
        b=k4KWD6M6r/EOLHMTs7fE67zGE1oH4OvReIvS7ssQmWYAabX4WDDj33e3qZ+/Xt+psj
         uq78ZLgM0R8ZlpRQS0Gp0d8CU4gBykSXSuQbWLRxkWeJ2WzJkMcqB8UOdoCVL4XzlpZx
         rug/4bfbW2H8rd1LeeA8uBxlJKwOKLWtZme+PoAIePURj4l7f/m77LSI4ouzs65N7VQU
         1B/LwmxuS/sqb7OwT1/IQPE8L1rCvHlwbvhgx1DxzHRNF3TXLtTymu7Lu54aeK3g71fj
         0WC4LYsyoQgz1BoP2nnsjh7+IJkcqZ7ryK6xBEFaVTmcm22193ItC4ga7VVZ5WCrpVw+
         RQhQ==
X-Gm-Message-State: AFuF++nK3XiKa9qvONYO/Y9R2C25KjhubvW20yZ5zxUnG8iCpCCy3YYA
	h+CknY7JKWnN8xYD/crHSW4N3dUM6eVP2e6Ojw1bZRhi+R6SWJ3nz1T6+Of8MUPAzVSD4pAeE+9
	70p4DdJusdjNbZ9C0E9kMeRG8sbeRMeEv2/o2XhmdH8a1ZhR/yyxltzi+OtW+t/Qo9OilwQNq6k
	VgHvAtF7Jwyw2EpTpELZ7tcCwLYmxq0HlQvGpXIQuVZE2mJ0LepqR9XquIJ4uJywDzOsCQnmdGf
	QcZZRZnHhTjDCur
X-Gm-Gg: AYBFou2Bzri3GmdL/TNddHPc4Xvca9v95r34wuWT/YLFZFHdCJXTP5yS7CMnC5lBiCi
	67SgBjiodqJfqx97+lyqR4GxD/6JUK3HfByRxMoZTHsxM4bWZmZVUpv9fGB7zfmT4ucj11s76C4
	8Ec85pxd6G0QGF3imxO6agmFGVNTpt5xKLHzjGahcns1VG71brka+irP4M0T4kSoQaybp/o4TMR
	/Quf/ST0SptKUHBMN2v1+7KZt4bF85qJJXTISd74wTNOuIMwsVjDQdGotjMHvDORUvDP6OrBwsl
	4o8PHYrRBzmc/CeqK1Jj7jbfc1/4oDgUgY3odEarnKgAfja54EI0ZkMn9w8V5vW4Ox2SrcXx7kM
	Zh4QpFVdD/ZBPu50CmMIsdYApzAGqy/GILutFs+6553LO+ytGfStAfFiSHKFY0B5mA2o7vU7X0F
	9uqNndgMWOWAGUiHEW2AqbEoMFqKxhqTUpOqI=
X-Received: by 2002:a17:90b:254a:b0:39b:ac66:bbc with SMTP id 98e67ed59e1d1-39e1e2ee271mr4414254a91.7.1789547718474;
        Wed, 16 Sep 2026 01:35:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-98.dlp.protect.broadcom.com. [144.49.247.98])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e1b8fb5b5sm997812a91.1.2026.09.16.01.35.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so10639170a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547715; x=1790152515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GtH5xYq2DxdcDESnx9DJzt+YE63P1nCpIdgUtrdL9ic=;
        b=WUA4/Fx+VhPrRqX1GVyCHHKHEpywkdv321nJhzUo8e42oXYogoP36t7688bFTw6Xiy
         Z/zUrlo3IQKgZKahYcvyNAXljOGbkePS3HkcTprEqM3YjBtptSRl0nexAFk790Sfnlrf
         nKFux1rupUwcvh4INCEWBnGzY77NIOimGtDiw=
X-Received: by 2002:a17:90b:3950:b0:396:d27b:89b9 with SMTP id 98e67ed59e1d1-39e1e31e264mr4337700a91.10.1789547715340;
        Wed, 16 Sep 2026 01:35:15 -0700 (PDT)
X-Received: by 2002:a17:90b:3950:b0:396:d27b:89b9 with SMTP id 98e67ed59e1d1-39e1e31e264mr4337586a91.10.1789547714706;
        Wed, 16 Sep 2026 01:35:14 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:14 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v5 02/10] mpi3mr: Update MPI Headers to revision 41
Date: Wed, 16 Sep 2026 13:56:57 +0530
Message-ID: <20260916082705.44712-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update MPI Headers to revision 41

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 77 +++++++++++++++++++++--
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  7 ++-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 15 +++--
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  2 +-
 4 files changed, 87 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 33dd303c97bb..7cf16a5c15b7 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -72,6 +72,12 @@
 #define MPI3_SECURITY_PGAD_SLOT_GROUP_SHIFT		(8)
 #define MPI3_SECURITY_PGAD_SLOT_MASK                    (0x000000ff)
 #define MPI3_INSTANCE_PGAD_INSTANCE_MASK                (0x0000ffff)
+#define MPI3_INSTANCE_PGAD_INSTANCE_SHIFT               (0)
+#define MPI3_INTERFACE_PGAD_INTERFACE_MASK              (0x0000000f)
+#define MPI3_INTERFACE_PGAD_INTERFACE_SHIFT             (0)
+#define MPI3_INTERFACE_PGAD_INTERFACE_MPI               (0)
+#define MPI3_INTERFACE_PGAD_INTERFACE_NVME_VD           (1)
+#define MPI3_INTERFACE_PGAD_INTERFACE_NVME_PD           (2)
 struct mpi3_config_request {
 	__le16             host_tag;
 	u8                 ioc_use_only02;
@@ -492,10 +498,31 @@ struct mpi3_man10_istwi_ctrlr_entry {
 };
 
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_MASK         (0x000c)
-#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_100K         (0x0000)
-#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_400K         (0x0004)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_100_KHZ		(0x0000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_400_KHZ		(0x0004)
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_TARGET_ENABLED          (0x0002)
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_INITIATOR_ENABLED         (0x0001)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_MASK	(0xc000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_SHIFT      (14)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_50_NS      (0x0000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_10_NS      (0x4000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_5_NS       (0x8000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_0_NS       (0xc000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_TYPE_MASK              (0x3000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_TYPE_SHIFT             (12)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_TYPE_I2C               (0x0000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_TYPE_I3C               (0x1000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_TYPE_AUTO              (0x2000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_MASK     (0x0e00)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_SHIFT    (9)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_12_5_MHZ (0x0000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_8_MHZ    (0x0200)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_6_MHZ    (0x0400)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_4_MHZ    (0x0600)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_2_MHZ    (0x0800)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_MASK             (0x000c)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_SHIFT            (0)
+
 #ifndef MPI3_MAN10_ISTWI_CTRLR_MAX
 #define MPI3_MAN10_ISTWI_CTRLR_MAX          (1)
 #endif
@@ -1027,6 +1054,16 @@ struct mpi3_io_unit_page5 {
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SWITCH_ATTACHED       (0x02)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_DIRECT_AND_EXPANDER   (0x03)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_DIRECT_AND_SWITCH     (0x03)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_HDD_SPINDOWN_MASK     (0xc000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_HDD_SPINDOWN_NONE     (0x0000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_HDD_SPINDOWN_ALL      (0x4000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_HDD_SPINDOWN_FILTERED (0x8000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_HDD_SPINDOWN_RESERVED (0xc000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SYNC_CACHE_MASK       (0x3000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SYNC_CACHE_ALL        (0x0000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SYNC_CACHE_FILTERED   (0x1000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SYNC_CACHE_NONE       (0x2000)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SYNC_CACHE_RESERVED   (0x3000)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_HDD_MASK         (0x0300)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_HDD_SHIFT        (8)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_HDD_MASK          (0x00c0)
@@ -1069,7 +1106,8 @@ struct mpi3_io_unit_page8 {
 	struct mpi3_config_page_header         header;
 	u8                                 sb_mode;
 	u8                                 sb_state;
-	__le16                             reserved0a;
+	u8                                 flags;
+	u8				   reserved0b;
 	u8                                 num_slots;
 	u8                                 slots_available;
 	u8                                 current_key_encryption_algo;
@@ -1088,6 +1126,8 @@ struct mpi3_io_unit_page8 {
 #define MPI3_IOUNIT8_SBSTATE_SVN_UPDATE_PENDING   (0x04)
 #define MPI3_IOUNIT8_SBSTATE_KEY_UPDATE_PENDING   (0x02)
 #define MPI3_IOUNIT8_SBSTATE_SECURE_BOOT_ENABLED  (0x01)
+#define MPI3_IOUNIT8_FLAGS_FWQR_CAPABLE			(0x80)
+#define MPI3_IOUNIT8_FLAGS_FWQR_SECURED			(0x40)
 #define MPI3_IOUNIT8_SBMODE_CURRENT_KEY_IOUNIT17	(0x10)
 #define MPI3_IOUNIT8_SBMODE_HARD_SECURE_RECERTIFIED	(0x08)
 struct mpi3_io_unit_page9 {
@@ -1174,10 +1214,16 @@ struct mpi3_io_unit_page12 {
 #define MPI3_IOUNIT12_FLAGS_NUMPASSES_32           (0x00000200)
 #define MPI3_IOUNIT12_FLAGS_NUMPASSES_64           (0x00000300)
 #define MPI3_IOUNIT12_FLAGS_PASSPERIOD_MASK        (0x00000003)
+#define MPI3_IOUNIT12_FLAGS_PASSPERIOD_SHIFT       (0)
 #define MPI3_IOUNIT12_FLAGS_PASSPERIOD_DISABLED    (0x00000000)
 #define MPI3_IOUNIT12_FLAGS_PASSPERIOD_500US       (0x00000001)
 #define MPI3_IOUNIT12_FLAGS_PASSPERIOD_1MS         (0x00000002)
 #define MPI3_IOUNIT12_FLAGS_PASSPERIOD_2MS         (0x00000003)
+#define MPI3_IOUNIT12_FLAGS_INTERFACE_MASK         (0x0000000c)
+#define MPI3_IOUNIT12_FLAGS_INTERFACE_SHIFT        (2)
+#define MPI3_IOUNIT12_FLAGS_INTERFACE_MPI          (0x00000000)
+#define MPI3_IOUNIT12_FLAGS_INTERFACE_NVME_VD      (0x00000004)
+#define MPI3_IOUNIT12_FLAGS_INTERFACE_NVME_PD      (0x00000008)
 #ifndef MPI3_IOUNIT13_FUNC_MAX
 #define MPI3_IOUNIT13_FUNC_MAX                                     (1)
 #endif
@@ -1238,6 +1284,7 @@ struct mpi3_io_unit_page15 {
 #define MPI3_IOUNIT15_PAGEVERSION                                   (0x00)
 #define MPI3_IOUNIT15_FLAGS_EPRINIT_INITREQUIRED                    (0x04)
 #define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_MASK                         (0x03)
+#define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_SHIFT                        (0)
 #define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_NOT_SUPPORTED                (0x00)
 #define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_WITHOUT_POWER_BRAKE_GPIO     (0x01)
 #define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_WITH_POWER_BRAKE_GPIO        (0x02)
@@ -1255,6 +1302,9 @@ struct mpi3_io_unit_page17 {
 	__le32                             current_key[];
 };
 #define MPI3_IOUNIT17_PAGEVERSION		(0x00)
+#define MPI3_IOUNIT17_FLAGS_KEYROOT_MASK	(0x01)
+#define MPI3_IOUNIT17_FLAGS_KEYROOT_HW		(0x00)
+#define MPI3_IOUNIT17_FLAGS_KEYROOT_FW		(0x01)
 struct mpi3_io_unit_page18 {
 	struct mpi3_config_page_header		header;
 	u8					flags;
@@ -1640,11 +1690,28 @@ struct mpi3_security_page3 {
 };
 
 #define MPI3_SECURITY3_PAGEVERSION               (0x00)
-#define MPI3_SECURITY3_FLAGS_TYPE_MASK           (0x0f)
+#define MPI3_SECURITY3_FLAGS_TYPE_MASK           (0x1f)
 #define MPI3_SECURITY3_FLAGS_TYPE_SHIFT          (0)
 #define MPI3_SECURITY3_FLAGS_TYPE_NOT_VALID      (0)
 #define MPI3_SECURITY3_FLAGS_TYPE_MLDSA_PRIVATE  (1)
 #define MPI3_SECURITY3_FLAGS_TYPE_MLDSA_PUBLIC   (2)
+union mpi3_security_digest {
+	__le32                             dword[16];
+	__le16                             word[32];
+	u8                                 byte[64];
+};
+struct mpi3_security_page4 {
+	struct mpi3_config_page_header         header;
+	__le32                             reserved08[2];
+	union mpi3_security_mac               mac;
+	union mpi3_security_nonce             nonce;
+	u8                                 num_digests;
+	u8                                 hash_algorithm;
+	__le16                             reserved92;
+	__le32                             reserved94[3];
+	union mpi3_security_digest		digest[];
+};
+#define MPI3_SECURITY4_PAGEVERSION               (0x00)
 struct mpi3_security_page10 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08[2];
@@ -2074,7 +2141,7 @@ struct mpi3_sas_phy3_phy_event_config {
 #define MPI3_SASPHY3_EVENT_CODE_LCCONN_TIME                 (0xd5)
 #define MPI3_SASPHY3_EVENT_CODE_SSP_TX_START_TRANSMIT       (0xd6)
 #define MPI3_SASPHY3_EVENT_CODE_SATA_TX_START               (0xd7)
-#define MPI3_SASPHY3_EVENT_CODE_SMP_TX_START_TRANSMT        (0xd8)
+#define MPI3_SASPHY3_EVENT_CODE_SMP_TX_START_TRANSMIT       (0xd8)
 #define MPI3_SASPHY3_EVENT_CODE_TX_SMP_BREAK_CONN           (0xd9)
 #define MPI3_SASPHY3_EVENT_CODE_SSP_RX_START_RECEIVE        (0xda)
 #define MPI3_SASPHY3_EVENT_CODE_SATA_RX_START_RECEIVE       (0xdb)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
index 62ddf094d46c..5fa09fa79358 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_image.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -18,7 +18,7 @@ struct mpi3_hash_exclusion_format {
 	__le32                     size;
 };
 
-#define MPI3_IMAGE_HASH_EXCUSION_NUM                           (4)
+#define MPI3_IMAGE_HASH_EXCLUSION_NUM                           (4)
 struct mpi3_component_image_header {
 	__le32                            signature0;
 	__le32                            load_address;
@@ -42,7 +42,7 @@ struct mpi3_component_image_header {
 	union mpi3_version_union             rmc_interface_version;
 	union mpi3_version_union             etp_interface_version;
 	struct mpi3_comp_image_version        component_image_version;
-	struct mpi3_hash_exclusion_format     hash_exclusion[MPI3_IMAGE_HASH_EXCUSION_NUM];
+	struct mpi3_hash_exclusion_format     hash_exclusion[MPI3_IMAGE_HASH_EXCLUSION_NUM];
 	__le32                            next_image_header_offset;
 	union mpi3_version_union             security_version;
 	__le32                            reserved84[31];
@@ -347,7 +347,8 @@ struct mpi3_encrypted_hash_entry {
 struct mpi3_encrypted_hash_data {
 	u8                                  image_version;
 	u8                                  num_hash;
-	__le16                              reserved02;
+	u8                                  fw_num_hash;
+	u8                                  reserved03;
 	__le32                              reserved04;
 	struct mpi3_encrypted_hash_entry        encrypted_hash_entry[MPI3_ENCRYPTED_HASH_ENTRY_MAX];
 };
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 68efa0d51345..aa42fba7f930 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -428,10 +428,10 @@ struct mpi3_event_data_sas_discovery {
 #define MPI3_EVENT_SAS_DISC_FLAGS_IN_PROGRESS                   (0x01)
 #define MPI3_EVENT_SAS_DISC_RC_STARTED                          (0x01)
 #define MPI3_EVENT_SAS_DISC_RC_COMPLETED                        (0x02)
-#define MPI3_SAS_DISC_STATUS_MAX_ENCLOSURES_EXCEED            (0x80000000)
-#define MPI3_SAS_DISC_STATUS_MAX_EXPANDERS_EXCEED             (0x40000000)
-#define MPI3_SAS_DISC_STATUS_MAX_DEVICES_EXCEED               (0x20000000)
-#define MPI3_SAS_DISC_STATUS_MAX_TOPO_PHYS_EXCEED             (0x10000000)
+#define MPI3_SAS_DISC_STATUS_MAX_ENCLOSURES_EXCEEDED            (0x80000000)
+#define MPI3_SAS_DISC_STATUS_MAX_EXPANDERS_EXCEEDED             (0x40000000)
+#define MPI3_SAS_DISC_STATUS_MAX_DEVICES_EXCEEDED               (0x20000000)
+#define MPI3_SAS_DISC_STATUS_MAX_TOPO_PHYS_EXCEEDED             (0x10000000)
 #define MPI3_SAS_DISC_STATUS_INVALID_CEI                      (0x00010000)
 #define MPI3_SAS_DISC_STATUS_FECEI_MISMATCH                   (0x00008000)
 #define MPI3_SAS_DISC_STATUS_MULTIPLE_DEVICES_IN_SLOT         (0x00004000)
@@ -965,7 +965,7 @@ struct mpi3_ci_download_reply {
 	u8                                 flags;
 	u8                                 cache_dirty;
 	u8                                 pending_count;
-	u8                                 reserved13;
+	u8                                 additional_flags;
 };
 
 #define MPI3_CI_DOWNLOAD_FLAGS_DOWNLOAD_IN_PROGRESS                  (0x80)
@@ -979,6 +979,11 @@ struct mpi3_ci_download_reply {
 #define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_ONLINE_PENDING      (0x04)
 #define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_OFFLINE_PENDING     (0x06)
 #define MPI3_CI_DOWNLOAD_FLAGS_COMPATIBLE                            (0x01)
+#define MPI3_CI_DOWNLOAD_ADDITIONALFLAGS_REDUNDANCYRESTORATION_MASK       (0x03)
+#define MPI3_CI_DOWNLOAD_ADDITIONALFLAGS_REDUNDANCYRESTORATION_SHIFT      (0)
+#define MPI3_CI_DOWNLOAD_ADDITIONALFLAGS_REDUNDANCYRESTORATION_NONE       (0x00)
+#define MPI3_CI_DOWNLOAD_ADDITIONALFLAGS_REDUNDANCYRESTORATION_PRIMARY    (0x01)
+#define MPI3_CI_DOWNLOAD_ADDITIONALFLAGS_REDUNDANCYRESTORATION_SECONDARY  (0x02)
 struct mpi3_ci_upload_request {
 	__le16                             host_tag;
 	u8                                 ioc_use_only02;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index 290a1f5c2924..794ecc778945 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -18,7 +18,7 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (39)
+#define MPI3_VERSION_UNIT                                               (41)
 #define MPI3_VERSION_DEV                                                (0)
 #define MPI3_DEVHANDLE_INVALID                                          (0xffff)
 struct mpi3_sysif_oper_queue_indexes {
-- 
2.47.3

