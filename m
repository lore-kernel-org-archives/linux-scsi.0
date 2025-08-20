Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874451990B7
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 08:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679668; cv=none; b=lXiiXx+9QY6akvgQ7oflbHpen0OrJfEDkLbwdoKOlCdvZrQ1N1wGZ1PV1RyG10af9GVTdTl36v020ALGWEInRB5hXrJfaGucxtfmgKD61lzPzXW6gj5ZbhZJJ7KA4gs4exfmSMbFtWS3ZF6S0h9vQ3JJpVS4EpSXjTDmzNLpGzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679668; c=relaxed/simple;
	bh=k8nxU+HdtiVScXfeW4yg+T5nSeTmsh4+1sOUKUZ4GBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nGoDVMD88oGHbP/sp63fIpLq7lnjhTZ6hs+c0e8i+StcljeFQHjnmiTYUEOCFQkRGvAq6jHAU08aOiwqrZhAVIAJqIFNRvIPV2Gv8Kkr628/OJn1bTv8bKnAYzKfp4LMhICMpSxPwLdjkDPPXcpQvifR6+ZMDRugN6Enfw9Pkwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FCbCntfK; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FCbCntfK"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-24458242b33so59050415ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755679667; x=1756284467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2try8nbfcpWuOsjdMg7dDEuSkRMMVSf5h/THxqtQ0Lk=;
        b=f2bUtMi066SusBOdSjgXDCwQXS30xfsX9BV0JsC4KnMsN7ixEtpZJ0K0g1+hfb1mgL
         EZsrmoUjWXFU7IwlJM4AQN4B7WXx3h1ZgimdlqAPOvnaGzB94lRRN6J+Bf6iRTHRJ0K5
         5W+o6fiyyr4XZW2yQTuFC2QamNcpldEgjL//1jp8OQ/E5qksXpT6sCD+xctP3szs/EXt
         GFRYAWql36KlFAdAmzwofhqgNlYRrB+3WtTqvxZlu2/SFdLIL3ZDqRzqLuUvxfLh7OV7
         XBruLEtSJRH320Lt4q6rkwIkclm2fSpH6zBa8VYIzEONGsJ7VSZZpLgrrUCCm+TPG3XB
         32YQ==
X-Gm-Message-State: AOJu0YzRoBbQlqBRt4RNpMeIlUhonsxNxkQjIqC28Nm96D4zFn4DypYk
	CuDlFbbXL1iIZLN31H22BVnAt+4gJD4r2wzoa2VExQDUlFO55GXmWpNlYrvOSKt5xyk0R8F66zs
	EwK+InGGv4IhIYVOuGEim3KrLQ3M7+sKUQt4hJfvVKG23lk7J95Eet5MYyvg3JzNKNhHs/V8qMT
	tkLv/UTCQg2OCQ4yDL6RxfVksnmERyiDKlRqR8GvkVnvtVJD7mV4fXvN2HLNLRAVk71g0nDHWGg
	B3/OaJX+u4YiTFACO3gGgAT
X-Gm-Gg: ASbGnctFuTD/uDEig4iOko2pW5z5sfIKFVi9XVNA2BfEhSU5O9wRieL+dbg7nb23T3O
	anduWbpY74jkPI0oXlPfRHgh8n8ILAvcCoqxqHaQbn9oqKKhnRlk+g3jCrvN+1vgVAmHlbWHoGl
	PvbSWcXJSQAS+C3nre2+gesBkzr0o/VbwQB7s5/XEB51aWLw80SrxgOq2aHtYezoAfqTWOOlm5U
	pzcG1lvZWdlpVRP1E2v6nYGS3xxROGlGQVwjuQ8O8eODN8gzZH1TCWZTmHQxbePPBaegmKZsMoi
	lI5wVPHD2zgcZYQ5W53ohqAoTmaSXjlzhJUEbcoP5oJpVM5VojwK99DdvR2YPWTJJ6AFU4Iflwn
	QLv4j2nYKJRyNXFNHYYWFYkS9xmNQXJdT87Dh3RzlRWLZWo9+fRb9e4W/rplcVFbuR7umVmkTs0
	xxv8Bbc+6GSg==
X-Google-Smtp-Source: AGHT+IHxzklo8yMaN1WmIIylhpywRiOgctDWP/3YWKwQFhnDvpMUEmcLS2bqY8Il0s2S+ETxdGNyykH58yAl
X-Received: by 2002:a17:902:ccd2:b0:240:981d:a4f5 with SMTP id d9443c01a7336-245ef258899mr21495965ad.42.1755679666715;
        Wed, 20 Aug 2025 01:47:46 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-245ed47cb56sm1924515ad.49.2025.08.20.01.47.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:47:46 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-32326bd712cso5833756a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1755679664; x=1756284464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2try8nbfcpWuOsjdMg7dDEuSkRMMVSf5h/THxqtQ0Lk=;
        b=FCbCntfK5xcTYwKnKADYKZ5CyaeUfQ8NswdRgHf9Frvac1VuNIespJeStF9680tR4z
         kN1n8XyO7CUi28Gbeke8REeryonrBNodH3cCDogs32JLzZ2+lKdyRvKjWR9h2r/tcm4N
         hcSaUsTDhMcbEso9JtLloslG/FGkIrj2dKoQ8=
X-Received: by 2002:a17:90b:4a:b0:321:abd4:b108 with SMTP id 98e67ed59e1d1-324e1334fe2mr3582536a91.12.1755679664139;
        Wed, 20 Aug 2025 01:47:44 -0700 (PDT)
X-Received: by 2002:a17:90b:4a:b0:321:abd4:b108 with SMTP id 98e67ed59e1d1-324e1334fe2mr3582498a91.12.1755679663572;
        Wed, 20 Aug 2025 01:47:43 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2643bafsm1604034a91.23.2025.08.20.01.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 01:47:43 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 4/6] mpi3mr: Update MPI headers to revision 37
Date: Wed, 20 Aug 2025 14:11:36 +0530
Message-Id: <20250820084138.228471-5-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
References: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Sync MPI header files to revision 37 to match current firmware/spec
definitions.

No functional change.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 38 ++++++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |  2 ++
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |  1 +
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  2 +-
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 96401eb7e231..8c8bfbbdd34e 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -322,6 +322,9 @@ struct mpi3_man6_gpio_entry {
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_MASK                       (0x01)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_EDGE                       (0x00)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_LEVEL                      (0x01)
+#define MPI3_MAN6_GPIO_OVER_TEMP_PARAM1_LEVEL_WARNING                         (0x00)
+#define MPI3_MAN6_GPIO_OVER_TEMP_PARAM1_LEVEL_CRITICAL                        (0x01)
+#define MPI3_MAN6_GPIO_OVER_TEMP_PARAM1_LEVEL_FATAL                           (0x02)
 #define MPI3_MAN6_GPIO_PORT_GREEN_PARAM1_PHY_STATUS_ALL_UP                    (0x00)
 #define MPI3_MAN6_GPIO_PORT_GREEN_PARAM1_PHY_STATUS_ONE_OR_MORE_UP            (0x01)
 #define MPI3_MAN6_GPIO_CABLE_MGMT_PARAM1_INTERFACE_MODULE_PRESENT             (0x00)
@@ -1250,6 +1253,37 @@ struct mpi3_io_unit_page17 {
 	__le32                             current_key[];
 };
 #define MPI3_IOUNIT17_PAGEVERSION		(0x00)
+struct mpi3_io_unit_page18 {
+	struct mpi3_config_page_header		header;
+	u8					flags;
+	u8					poll_interval;
+	__le16					reserved0a;
+	__le32					reserved0c;
+};
+
+#define MPI3_IOUNIT18_PAGEVERSION                                   (0x00)
+#define MPI3_IOUNIT18_FLAGS_DIRECTATTACHED_ENABLE                   (0x01)
+#define MPI3_IOUNIT18_POLLINTERVAL_DISABLE                          (0x00)
+#ifndef MPI3_IOUNIT19_DEVICE_MAX
+#define MPI3_IOUNIT19_DEVICE_MAX                                    (1)
+#endif
+struct mpi3_iounit19_device {
+	__le16                             temperature;
+	__le16                             dev_handle;
+	__le16                             persistent_id;
+	__le16                             reserved06;
+};
+
+#define MPI3_IOUNIT19_DEVICE_TEMPERATURE_UNAVAILABLE                (0x8000)
+struct mpi3_io_unit_page19 {
+	struct mpi3_config_page_header		header;
+	__le16					num_devices;
+	__le16					reserved0a;
+	__le32					reserved0c;
+	struct mpi3_iounit19_device		device[MPI3_IOUNIT19_DEVICE_MAX];
+};
+
+#define MPI3_IOUNIT19_PAGEVERSION                                   (0x00)
 struct mpi3_ioc_page0 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08;
@@ -2356,7 +2390,9 @@ struct mpi3_device0_vd_format {
 	__le16     io_throttle_group;
 	__le16     io_throttle_group_low;
 	__le16     io_throttle_group_high;
-	__le32     reserved0c;
+	u8         vd_abort_to;
+	u8         vd_reset_to;
+	__le16     reserved0e;
 };
 #define MPI3_DEVICE0_VD_STATE_OFFLINE                       (0x00)
 #define MPI3_DEVICE0_VD_STATE_PARTIALLY_DEGRADED            (0x01)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index 7c15e5851ce4..4eeb11c3c73e 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -9,9 +9,11 @@
 #define MPI3_NVME_ENCAP_CMD_MAX               (1)
 #endif
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_MASK      (0x0002)
+#define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_SHIFT     (1)
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_FAIL_ONLY (0x0000)
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_ALL       (0x0002)
 #define MPI3_NVME_FLAGS_SUBMISSIONQ_MASK                (0x0001)
+#define MPI3_NVME_FLAGS_SUBMISSIONQ_SHIFT               (0)
 #define MPI3_NVME_FLAGS_SUBMISSIONQ_IO                  (0x0000)
 #define MPI3_NVME_FLAGS_SUBMISSIONQ_ADMIN               (0x0001)
 
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
index 4a93c67d335f..190b06508b00 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
@@ -11,6 +11,7 @@
 #define MPI3_SAS_DEVICE_INFO_STP_INITIATOR          (0x00000010)
 #define MPI3_SAS_DEVICE_INFO_SMP_INITIATOR          (0x00000008)
 #define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK       (0x00000007)
+#define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_SHIFT      (0)
 #define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_NO_DEVICE  (0x00000000)
 #define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE (0x00000001)
 #define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_EXPANDER   (0x00000002)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index 5c522e2531c3..28ab2efb3baa 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -18,7 +18,7 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (35)
+#define MPI3_VERSION_UNIT                                               (37)
 #define MPI3_VERSION_DEV                                                (0)
 #define MPI3_DEVHANDLE_INVALID                                          (0xffff)
 struct mpi3_sysif_oper_queue_indexes {
-- 
2.43.5

