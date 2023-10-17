Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E84CDB487
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 20:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344296AbjJQUsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 16:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344190AbjJQUsa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 16:48:30 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AA6FA;
        Tue, 17 Oct 2023 13:48:26 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6b2018a11efso4280935b3a.0;
        Tue, 17 Oct 2023 13:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697575706; x=1698180506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4k+JDqEcQkKs3J5VRs0ivCwgTJsm0PTpYm6Nj592ys=;
        b=RgkIRboai4lX0Xy1ylkKgXRKV77aYnylQsHi7S/6cqY7+KFBFp/Y4/O4leOYn5tEOY
         5Sco1MCoVi8H6yw8EYNRMWahoQ7d7eHqTjtQjxI6hiTwBn405uLuMbZpm4dNKbR2DkhZ
         N6dZDvtO8Es0QLRsE5F41BC79q7dxN5cEF2C4pordmLtEKuFags5A56GlvzoVORWvRCf
         e1c8K60qUXsjprpxegBoULzGUdF9Bz0ke8pws3eU+9HwLQhOzGeCJwYr/EH2xoDNrtvD
         1JCZsmPyQCjEa1MzQiwHK/yieQJmXVD9AVjfWOGx00pH8+PmtlaIhQzD1Sd/MMmuoGPN
         FC1Q==
X-Gm-Message-State: AOJu0Yw/hmceKiDU81ZAMFE8/HQyfSh+rDz0kfUctcDaGZavEM8xhFx6
        6/PIn7QU884ZRFPSh6PsRtUTDJXOCJo=
X-Google-Smtp-Source: AGHT+IE9JmC7mnpFAERJjbxXj8433DA2LiY59WlVX6Lr+DI/sHn29bu/4VP2IM+dMqjwkD0A6kKnow==
X-Received: by 2002:aa7:88ce:0:b0:6b1:c1c4:ae98 with SMTP id k14-20020aa788ce000000b006b1c1c4ae98mr3811496pff.18.1697575705851;
        Tue, 17 Oct 2023 13:48:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8f02:2919:9600:ac09])
        by smtp.gmail.com with ESMTPSA id fa36-20020a056a002d2400b006b2e07a6235sm1874704pfb.136.2023.10.17.13.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 13:48:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 06/14] scsi_proto: Add structures and constants related to I/O groups and streams
Date:   Tue, 17 Oct 2023 13:47:14 -0700
Message-ID: <20231017204739.3409052-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231017204739.3409052-1-bvanassche@acm.org>
References: <20231017204739.3409052-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code that will query the I/O advice hints group
descriptors and for adding code that will retrieve the stream status.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_proto.h | 75 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 07d65c1f59db..9ee4983c23b4 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -10,6 +10,7 @@
 #ifndef _SCSI_PROTO_H_
 #define _SCSI_PROTO_H_
 
+#include <linux/build_bug.h>
 #include <linux/types.h>
 
 /*
@@ -126,6 +127,7 @@
 #define	SAI_READ_CAPACITY_16  0x10
 #define SAI_GET_LBA_STATUS    0x12
 #define SAI_REPORT_REFERRALS  0x13
+#define SAI_GET_STREAM_STATUS 0x16
 /* values for maintenance in */
 #define MI_REPORT_IDENTIFYING_INFORMATION 0x05
 #define MI_REPORT_TARGET_PGS  0x0a
@@ -275,6 +277,79 @@ struct scsi_lun {
 	__u8 scsi_lun[8];
 };
 
+/* SBC-5 IO advice hints group descriptor */
+struct scsi_io_group_descriptor {
+#if defined(__BIG_ENDIAN)
+	u8 io_advice_hints_mode: 2;
+	u8 reserved1: 3;
+	u8 st_enble: 1;
+	u8 cs_enble: 1;
+	u8 ic_enable: 1;
+#elif defined(__LITTLE_ENDIAN)
+	u8 ic_enable: 1;
+	u8 cs_enble: 1;
+	u8 st_enble: 1;
+	u8 reserved1: 3;
+	u8 io_advice_hints_mode: 2;
+#else
+#error
+#endif
+	u8 reserved2[3];
+	/* Logical block markup descriptor */
+#if defined(__BIG_ENDIAN)
+	u8 acdlu: 1;
+	u8 reserved3: 1;
+	u8 rlbsr: 2;
+	u8 lbm_descriptor_type: 4;
+#elif defined(__LITTLE_ENDIAN)
+	u8 lbm_descriptor_type: 4;
+	u8 rlbsr: 2;
+	u8 reserved3: 1;
+	u8 acdlu: 1;
+#else
+#error
+#endif
+	u8 params[2];
+	u8 reserved4;
+	u8 reserved5[8];
+};
+
+static_assert(sizeof(struct scsi_io_group_descriptor) == 16);
+
+struct scsi_stream_status {
+#if defined(__BIG_ENDIAN)
+	u16 perm: 1;
+	u16 reserved1: 15;
+#elif defined(__LITTLE_ENDIAN)
+	u16 reserved1: 15;
+	u16 perm: 1;
+#else
+#error
+#endif
+	__be16 stream_identifier;
+#if defined(__BIG_ENDIAN)
+	u8 reserved2: 2;
+	u8 rel_lifetime: 6;
+#elif defined(__LITTLE_ENDIAN)
+	u8 rel_lifetime: 6;
+	u8 reserved2: 2;
+#else
+#error
+#endif
+	u8 reserved3[3];
+};
+
+static_assert(sizeof(struct scsi_stream_status) == 8);
+
+struct scsi_stream_status_header {
+	__be32 len;	/* length in bytes of stream_status[] array. */
+	u16 reserved;
+	u16 number_of_open_streams;
+	DECLARE_FLEX_ARRAY(struct scsi_stream_status, stream_status);
+};
+
+static_assert(sizeof(struct scsi_stream_status_header) == 8);
+
 /* SPC asymmetric access states */
 #define SCSI_ACCESS_STATE_OPTIMAL     0x00
 #define SCSI_ACCESS_STATE_ACTIVE      0x01
