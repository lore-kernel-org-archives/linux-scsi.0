Received: from mail-yw1-f225.google.com (mail-yw1-f225.google.com [209.85.128.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA5534D4C9
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544048; cv=none; b=G7ipsELJIyPtP9dkwtBJo0VFjQYpEg5kLKc3Zm26B1BSt9MwAa2QoAJphqzTdwjogLYPx3qym467glnJ6qkRjn+kRDGUSVcmuezIlQxlAk2Uz1waraWypQmafZwhKyjTy/Bqc01nb/cv5qr0raUrKGDKUh8EKgScZOBjc3FbHZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544048; c=relaxed/simple;
	bh=vURag62JhsYDYB2a5kzCdPKdraIsgKbvydtKoUy8LQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIogQ2SZVndiJu3OqOC10JYb/4tpf7xpPBieABbMpPQFv34c8X9xIL++pS0BR/E7KjRhG37QdLfLwfWTygQm8CK6zs7EFmNn4hQ4dHQsW4EcGrb8u6g5BiOjNqk5FQZASDVhmDwTIo81R/74crfPTeL2MZYNrXaYmMfzUe5Zl/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cbVTGHEY; arc=none smtp.client-ip=209.85.128.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cbVTGHEY"
Received: by mail-yw1-f225.google.com with SMTP id 00721157ae682-78fb9a67b06so16626647b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544045; x=1769148845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfeskckX4S6zbVwDri3Ju4PqfD8kaKn/y4oMjSoJyMk=;
        b=aXJuGM0+r0PaKvg1b3uco2tBYU1+2qFbSP3UBmxPS4VgOOsHqeBh51KVLPAOzCvV3V
         PWNLhPEgYszNIIKEMgxSCD/PC3OwycCO6SjL8221s9CMhFPR3jbt3sGdWoWtxLFa5QKK
         GTU+2/fCX1/zEXS6BQduNbxgD60DVsM2bV4kOyW4lZ19mIASSLcFw0qcid0+jD3ZxTl5
         qzOeL8emCunVAbtaZ7Q88yqN2Mi04G2C41svdvos12cgkVNwNy24LOa5aGIlHe3U9mzJ
         TUWQxMdb9sEFZ/AYk6U9P3MG+qxHfavZA34FBxrdRIGGXzoaFkyS1xh+tPQe8nRFoav4
         jU4Q==
X-Gm-Message-State: AOJu0YwEdAcIFyV1gOodo4RieDAJ5BcPS1uR0U+0lkak2mCcLvAewn2n
	dOGm+AZ6zyLWK0aV7o1Vf76wXJzRhE/WJxWGnxlQ+TmjizVxf/k6+tOZ4sEk49M0Rcp1grMKYcf
	ehg3j2fI8vEOYVX5f9osH5lzhBQsAwRfU9b7h08Kx+Buzp0h0xKmy8AM2htxSgUvlTQVfbG2CBN
	QEU+fC6CLbo/RiNgB02vCLgpCZo/gLuwTQSkSFxYCbGd7UiitFqH3KRjpVfN+s9dgxhe9sOGkcQ
	mzO8ekty4V5YxJ7
X-Gm-Gg: AY/fxX6xxUEbNfX7uilePxfdlR4rpJuq4yhSEIC9fTI4Wo9aGXQxJ9ABkQjQ1tJaBEz
	yQtuH8jl2pmc2WDFFYjiNvRVdXVkDapU9GCn7nMdKOCCisp6zNdPyCtuioG8tON1V1Z7Z0BEl99
	bUKz5DB0+UnprAPRv64jVG5eFBpKFNQJMQ7v047xrnRDCEN60LMWMUtR8Qz9OpNlmOhRPtVOxGf
	3OTF9tbcxjdifNPDnBT0FpgQI+NVAJutx9Lns7PEqtmQhYwjclzR9FIL3Vwxh5EnmHOwW0zJ/fQ
	FvHRAsCs2dqt0SIjwf56sL0kV1GdCz2LgL6cGoZcZCLrLynNIaH1v9K7Bro+RPjGvPNJzOKKXlk
	jTZ6fdz/Im80eGevXYDiDtuBwgly0CzBYr7D+pBIL5kIuCtJ1G24FZFTBzxYr3XFXp+xXGWh7tl
	PzEnKDxV92ily+2fi0VGPTm+Axg8dmD7Eilh7pH7u07Q==
X-Received: by 2002:a05:690c:f95:b0:792:7721:e072 with SMTP id 00721157ae682-793c66b8ec9mr14458017b3.11.1768544045046;
        Thu, 15 Jan 2026 22:14:05 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6491701556fsm91691d50.7.2026.01.15.22.14.04
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:14:05 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f25a008dbso11695665ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544043; x=1769148843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfeskckX4S6zbVwDri3Ju4PqfD8kaKn/y4oMjSoJyMk=;
        b=cbVTGHEY8/VLU0R2nhKTqNmDMpv3K3EaPazsFeoDlMe8qFDiAASCcCTUgmBxx3ot6F
         VNIO123xQdVF10iF0Oe/oAztKNN898FYfAYywJeD2XWUhWabUukgOBb54i5ae5JjKSXE
         2ADaYWRFB43RBpm+YeRUoNpNRr+DRFWeUJx3U=
X-Received: by 2002:a17:902:d48b:b0:2a0:9040:637b with SMTP id d9443c01a7336-2a7188a302emr16133015ad.26.1768544043267;
        Thu, 15 Jan 2026 22:14:03 -0800 (PST)
X-Received: by 2002:a17:902:d48b:b0:2a0:9040:637b with SMTP id d9443c01a7336-2a7188a302emr16132815ad.26.1768544042680;
        Thu, 15 Jan 2026 22:14:02 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:14:02 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 5/8] mpi3mr: Update MPI Headers to revision 39
Date: Fri, 16 Jan 2026 11:37:16 +0530
Message-ID: <20260116060719.32937-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update MPI Headers to revision 39

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  90 ++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 102 +++++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |   1 +
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h      |   6 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   4 +-
 8 files changed, 197 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 67d72b82cbe0..33dd303c97bb 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2017-2023 Broadcom Inc. All rights reserved.
+ *  Copyright 2017-2026 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_CNFG_H
 #define MPI30_CNFG_H     1
@@ -1037,6 +1037,7 @@ struct mpi3_io_unit_page5 {
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_SSD_SHIFT        (2)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_SSD_MASK          (0x0003)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_SSD_SHIFT         (0)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_HDD_SPINDOWN_ENABLE    (0x8000)
 #define MPI3_IOUNIT5_FLAGS_SATAPUIS_MASK                   (0x0c)
 #define MPI3_IOUNIT5_FLAGS_SATAPUIS_NOT_SUPPORTED          (0x00)
 #define MPI3_IOUNIT5_FLAGS_SATAPUIS_OS_CONTROLLED          (0x04)
@@ -1074,7 +1075,8 @@ struct mpi3_io_unit_page8 {
 	u8                                 current_key_encryption_algo;
 	u8                                 key_digest_hash_algo;
 	union mpi3_version_union              current_svn;
-	__le32                             reserved14;
+	__le16                             pending_svn_time;
+	__le16                             reserved16;
 	__le32                             current_key[128];
 	union mpi3_iounit8_digest             digest[MPI3_IOUNIT8_DIGEST_MAX];
 };
@@ -1406,6 +1408,7 @@ struct mpi3_driver_page1 {
 };
 
 #define MPI3_DRIVER1_PAGEVERSION               (0x00)
+#define MPI3_DRIVER1_FLAGS_DEVICE_SHUTDOWN_ON_UNLOAD_DISABLE		(0x0001)
 #ifndef MPI3_DRIVER2_TRIGGER_MAX
 #define MPI3_DRIVER2_TRIGGER_MAX           (1)
 #endif
@@ -1561,7 +1564,9 @@ struct mpi3_security1_key_record {
 	u8                                 consumer;
 	__le16                             key_data_size;
 	__le32                             additional_key_data;
-	__le32                             reserved08[2];
+	u8                                 library_version;
+	u8                                 reserved09[3];
+	__le32                             reserved0c;
 	union mpi3_security1_key_data         key_data;
 };
 
@@ -1614,6 +1619,85 @@ struct mpi3_security_page2 {
 	u8                                 reserved9d[3];
 	struct mpi3_security2_trusted_root     trusted_root[MPI3_SECURITY2_TRUSTED_ROOT_MAX];
 };
+
+struct mpi3_security_page3 {
+	struct mpi3_config_page_header         header;
+	__le16                             key_data_length;
+	__le16                             reserved0a;
+	u8                                 key_number;
+	u8                                 reserved0d[3];
+	union mpi3_security_mac               mac;
+	union mpi3_security_nonce             nonce;
+	__le32                             reserved90[12];
+	u8                                 flags;
+	u8                                 consumer;
+	__le16                             key_data_size;
+	__le32                             additional_key_data;
+	u8                                 library_version;
+	u8                                 reserved_c9[3];
+	__le32                             reserved_cc;
+	u8                                 key_data[];
+};
+
+#define MPI3_SECURITY3_PAGEVERSION               (0x00)
+#define MPI3_SECURITY3_FLAGS_TYPE_MASK           (0x0f)
+#define MPI3_SECURITY3_FLAGS_TYPE_SHIFT          (0)
+#define MPI3_SECURITY3_FLAGS_TYPE_NOT_VALID      (0)
+#define MPI3_SECURITY3_FLAGS_TYPE_MLDSA_PRIVATE  (1)
+#define MPI3_SECURITY3_FLAGS_TYPE_MLDSA_PUBLIC   (2)
+struct mpi3_security_page10 {
+	struct mpi3_config_page_header         header;
+	__le32                             reserved08[2];
+	union mpi3_security_mac               mac;
+	union mpi3_security_nonce             nonce;
+	__le64                             current_token_nonce;
+	__le64                             previous_token_nonce;
+	__le32                             reserved_a0[8];
+	u8                                 diagnostic_auth_id[64];
+};
+#define MPI3_SECURITY10_PAGEVERSION               (0x00)
+
+struct mpi3_security_page11 {
+	struct mpi3_config_page_header         header;
+	u8                                 flags;
+	u8                                 reserved09[3];
+	__le32                             reserved0c;
+	__le32                             diagnostic_token_length;
+	__le32                             reserved14[3];
+	u8                                 diagnostic_token[];
+};
+#define MPI3_SECURITY11_PAGEVERSION               (0x00)
+#define MPI3_SECURITY11_FLAGS_TOKEN_ENABLED       (0x01)
+
+struct mpi3_security12_diag_feature {
+	__le32                             feature_identifier;
+	u8                                 feature_size;
+	u8                                 feature_type;
+	__le16                             reserved06;
+	u8                                 status;
+	u8                                 section;
+	__le16                             reserved0a;
+	__le32                             reserved0c;
+	u8                                 feature_data[64];
+};
+#define MPI3_SECURITY12_DIAG_FEATURE_STATUS_MASK                 (0x03)
+#define MPI3_SECURITY12_DIAG_FEATURE_STATUS_SHIFT                (0)
+#define MPI3_SECURITY12_DIAG_FEATURE_STATUS_UNKNOWN              (0x00)
+#define MPI3_SECURITY12_DIAG_FEATURE_STATUS_DISABLED             (0x01)
+#define MPI3_SECURITY12_DIAG_FEATURE_STATUS_ENABLED              (0x02)
+#define MPI3_SECURITY12_DIAG_FEATURE_SECTION_PROTECTED           (0x00)
+#define MPI3_SECURITY12_DIAG_FEATURE_SECTION_UNPROTECTED         (0x01)
+#define MPI3_SECURITY12_DIAG_FEATURE_SECTION_PAYLOAD             (0x02)
+#define MPI3_SECURITY12_DIAG_FEATURE_SECTION_SIGNATURE           (0x03)
+struct mpi3_security_page12 {
+	struct mpi3_config_page_header         header;
+	__le32                             reserved08[2];
+	u8                                 num_diag_features;
+	u8                                 reserved11[3];
+	__le32                             reserved14[3];
+	struct mpi3_security12_diag_feature    diag_feature[];
+};
+
 #define MPI3_SECURITY2_PAGEVERSION               (0x00)
 struct mpi3_sas_io_unit0_phy_data {
 	u8                 io_unit_port;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
index 8d824107a678..62ddf094d46c 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_image.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2018-2023 Broadcom Inc. All rights reserved.
+ *  Copyright 2018-2026 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_IMAGE_H
 #define MPI30_IMAGE_H     1
@@ -135,7 +135,7 @@ struct mpi3_ci_manifest_mpi {
 	__le32                                   package_version_string_offset;
 	__le32                                   package_build_date_string_offset;
 	__le32                                   package_build_time_string_offset;
-	__le32                                   reserved4c;
+	__le32                                   diag_authorization_key_offset;
 	__le32                                   diag_authorization_identifier[16];
 	struct mpi3_ci_manifest_mpi_comp_image_ref   component_image_ref[MPI3_CI_MANIFEST_MPI_MAX];
 };
@@ -148,16 +148,112 @@ struct mpi3_ci_manifest_mpi {
 #define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_GCA                        (0x50)
 #define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_POINT                      (0x60)
 #define MPI3_CI_MANIFEST_MPI_FLAGS_DIAG_AUTHORIZATION                 (0x01)
+#define MPI3_CI_MANIFEST_MPI_FLAGS_DIAG_AUTH_ANCHOR_MASK		(0x06)
+#define MPI3_CI_MANIFEST_MPI_FLAGS_DIAG_AUTH_ANCHOR_SHIFT		(1)
+#define MPI3_CI_MANIFEST_MPI_FLAGS_DIAG_AUTH_ANCHOR_IDENTIFIER		(0x00)
+#define MPI3_CI_MANIFEST_MPI_FLAGS_DIAG_AUTH_ANCHOR_KEY_OFFSET		(0x02)
 #define MPI3_CI_MANIFEST_MPI_SUBSYSTEMID_IGNORED                   (0xffff)
 #define MPI3_CI_MANIFEST_MPI_PKG_VER_STR_OFF_UNSPECIFIED           (0x00000000)
 #define MPI3_CI_MANIFEST_MPI_PKG_BUILD_DATE_STR_OFF_UNSPECIFIED    (0x00000000)
 #define MPI3_CI_MANIFEST_MPI_PKG_BUILD_TIME_STR_OFF_UNSPECIFIED    (0x00000000)
+
+struct mpi3_sb_manifest_ci_digest {
+	__le32                      signature1;
+	__le32                      reserved04[2];
+	u8                          hash_algorithm;
+	u8                          reserved09[3];
+	struct mpi3_comp_image_version  component_image_version;
+	__le32                      component_image_version_string_offset;
+	__le32                      digest[16];
+};
+
+struct mpi3_sb_manifest_ci_ref_element {
+	u8                              num_ci_digests;
+	u8                              reserved01[3];
+	struct mpi3_sb_manifest_ci_digest	ci_digest[];
+};
+
+struct mpi3_sb_manifest_embedded_key_element {
+	__le32                      reserved00[3];
+	u8                          key_algorithm;
+	u8                          flags;
+	__le16                      public_key_size;
+	__le32                      start_tag;
+	__le32                      public_key[];
+};
+
+#define MPI3_SB_MANIFEST_EMBEDDED_KEY_FLAGS_KEYINDEX_MASK		(0x03)
+#define MPI3_SB_MANIFEST_EMBEDDED_KEY_FLAGS_KEYINDEX_STRT		(0x00)
+#define MPI3_SB_MANIFEST_EMBEDDED_KEY_FLAGS_KEYINDEX_K2GO		(0x01)
+#define MPI3_SB_MANIFEST_EMBEDDED_KEY_STARTTAG_STRT			(0x54525453)
+#define MPI3_SB_MANIFEST_EMBEDDED_KEY_STARTTAG_K2GO			(0x4f47324b)
+#define MPI3_SB_MANIFEST_EMBEDDED_KEY_ENDTAG_STOP			(0x504f5453)
+#define MPI3_SB_MANIFEST_EMBEDDED_KEY_ENDTAG_K2ST			(0x5453324b)
+
+struct mpi3_sb_manifest_diag_key_element {
+	__le32                      reserved00[3];
+	u8                          key_algorithm;
+	u8                          flags;
+	__le16                      public_key_size;
+	__le32                      public_key[];
+};
+
+#define MPI3_SB_MANIFEST_DIAG_KEY_FLAGS_KEYINDEX_MASK		(0x03)
+#define MPI3_SB_MANIFEST_DIAG_KEY_FLAGS_KEYSELECT_FW_KEY	(0x04)
+union mpi3_sb_manifest_element_data {
+	struct mpi3_sb_manifest_ci_ref_element           ci_ref;
+	struct mpi3_sb_manifest_embedded_key_element     embed_key;
+	struct mpi3_sb_manifest_diag_key_element         diag_key;
+	__le32                                       dword;
+};
+struct mpi3_sb_manifest_element {
+	u8                                   manifest_element_form;
+	u8                                   reserved01[3];
+	union mpi3_sb_manifest_element_data     form_specific[];
+};
+#define MPI3_SB_MANIFEST_ELEMENT_FORM_CI_REFS		(0x01)
+#define MPI3_SB_MANIFEST_ELEMENT_FORM_EMBED_KEY		(0x02)
+#define MPI3_SB_MANIFEST_ELEMENT_FORM_DIAG_KEY		(0x03)
+struct mpi3_sb_manifest_mpi {
+	u8                                       manifest_type;
+	u8                                       reserved01[3];
+	__le32                                   reserved04[3];
+	u8                                       reserved10;
+	u8                                       release_level;
+	__le16                                   reserved12;
+	__le16                                   reserved14;
+	__le16                                   flags;
+	__le32                                   reserved18[2];
+	__le16                                   vendor_id;
+	__le16                                   device_id;
+	__le16                                   subsystem_vendor_id;
+	__le16                                   subsystem_id;
+	__le32                                   reserved28[2];
+	union mpi3_version_union                    package_security_version;
+	__le32                                   reserved34;
+	struct mpi3_comp_image_version               package_version;
+	__le32                                   package_version_string_offset;
+	__le32                                   package_build_date_string_offset;
+	__le32                                   package_build_time_string_offset;
+	__le32                                   component_image_references_offset;
+	__le32                                   embedded_key0offset;
+	__le32                                   embedded_key1offset;
+	__le32                                   diag_authorization_key_offset;
+	__le32                                   reserved5c[9];
+	struct mpi3_sb_manifest_element              manifest_elements[];
+};
+
 union mpi3_ci_manifest {
 	struct mpi3_ci_manifest_mpi               mpi;
+	struct mpi3_sb_manifest_mpi               sb_mpi;
 	__le32                                dword[1];
 };
 
-#define MPI3_CI_MANIFEST_TYPE_MPI                                  (0x00)
+#define MPI3_SB_MANIFEST_APU_IMMEDIATE_DEFER_APU_ENABLE			(0x01)
+
+#define MPI3_CI_MANIFEST_TYPE_MPI			(0x00)
+#define MPI3_CI_MANIFEST_TYPE_SB			(0x01)
+
 struct mpi3_extended_image_header {
 	u8                                image_type;
 	u8                                reserved01[3];
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index bbef5bac92ed..745e1101ebf4 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2026 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_INIT_H
 #define MPI30_INIT_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index b42933fcd423..76dc18684be1 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -661,6 +661,7 @@ struct mpi3_event_data_diag_buffer_status_change {
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED             (0x01)
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED               (0x02)
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED              (0x03)
+#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_CLEARED (0x04)
 #define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
 #define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
 #define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index 4eeb11c3c73e..3092dfe6d952 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2026 Broadcom Inc. All rights reserved.
  *
  */
 #ifndef MPI30_PCI_H
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
index 190b06508b00..f86da445df1e 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2026 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_SAS_H
 #define MPI30_SAS_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
index 50a65b16a818..72d3e6bc52ec 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2024 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2026 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_TOOL_H
 #define MPI30_TOOL_H     1
@@ -8,6 +8,10 @@
 #define MPI3_DIAG_BUFFER_TYPE_TRACE	(0x01)
 #define MPI3_DIAG_BUFFER_TYPE_FW	(0x02)
 #define MPI3_DIAG_BUFFER_ACTION_RELEASE	(0x01)
+#define MPI3_DIAG_BUFFER_ACTION_PAUSE	(0x02)
+#define MPI3_DIAG_BUFFER_ACTION_RESUME	(0x03)
+#define MPI3_DIAG_BUFFER_ACTION_CLEAR	(0x04)
+
 
 #define MPI3_DIAG_BUFFER_POST_MSGFLAGS_SEGMENTED	(0x01)
 struct mpi3_diag_buffer_post_request {
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index 28ab2efb3baa..290a1f5c2924 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2026 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_TRANSPORT_H
 #define MPI30_TRANSPORT_H     1
@@ -18,7 +18,7 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (37)
+#define MPI3_VERSION_UNIT                                               (39)
 #define MPI3_VERSION_DEV                                                (0)
 #define MPI3_DEVHANDLE_INVALID                                          (0xffff)
 struct mpi3_sysif_oper_queue_indexes {
-- 
2.47.3

