Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F485111B8;
	Tue,  8 Sep 2026 09:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858272; cv=none; b=pIWUfHSGzHpcyYECN1vCOmX1W3gSGtZwp8XFHT0oJFaUeJjXZjklsl8p4W9tQWBtp8kEg3fe60kZyPiDy1hSb5aNOS+A9dmuNIKrLNTTPDcexmWVm4n2lARwQh6ApnCBJDnjQfsDkgTf5PxbljqUDDk9Qcyw2zoopOj3oLWLH/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858272; c=relaxed/simple;
	bh=aAZ7fFflHQwyUv3VdDcByQ26dJfmx474YNDl/IvQPkY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpgdS0wVyc5LH16qY2nN5CUnqvf2PO8tFkKVdx/SSXh0X0nj9Y5qqjWZy9Hd359bIOAwJ2D5PqSx85L+EiiAumqBuVp4QCctfgWDvkeofgUI+1wD2QIDAd8ZqT3hQEpjDzM6yXW2fqtOFeSRFrXRyBRiGLKm/ydp7AbPL3Yxggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haTV6qFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haTV6qFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427901F00A3E;
	Tue,  8 Sep 2026 09:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858268;
	bh=BpCTGqGxouNyq7AiTahBFxZqCuAhltPPZwCwdehMJYE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=haTV6qFEEYSbrKMG4VCtuV06ZaSLr5PGtz6ssIl6KOeAAV60cPM/jW8bjfDemTF+L
	 1eTTecm2FYvHLrilrwW96SvQk97R60O3+OFAoHWvML/bG8G16W4UGYaL3Pa0HPQf8S
	 5DPvlsWPZ8LQiJaXqPBkXA6ScuahitvO1Vdl25wq26LyGNMdUSrAdmfKPsEw15mFn3
	 z/EpBFVz0C4bunCSXXdUjKupv8XwfLHF9o4eNDcZqN70uKIVtD4G+N83JLX70LPtpL
	 eYjhWdRjlXkLMsr9GG7L3RHxDpoPMnsRcS7IRN2KGyTFlLqVJMGvbGq/WGEHwyAfcV
	 SFzK3jzedBJPg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v6 39/40] scsi: cleanup scsi_proto.h
Date: Tue,  8 Sep 2026 18:03:07 +0900
Message-ID: <20260908090308.1085097-40-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that all users of SCSI sense codes have been modified to use macro
definitions and the 16-bits sense code instead of separate 8-bits ASC and
ASCQ, remove the now unused asc and ascq fields of struct scsi_failure and
struct scsi_sense_hdr, and the old (and incomplete) definitions of SCSI
additional sense codes and sense code qualifiers in scsi_proto.h.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 include/scsi/scsi_common.h | 13 +---------
 include/scsi/scsi_device.h | 13 +---------
 include/scsi/scsi_proto.h  | 51 --------------------------------------
 3 files changed, 2 insertions(+), 75 deletions(-)

diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 6fb2c290ba33..405512554ee8 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -71,18 +71,7 @@ extern u64 scsilun_to_int(struct scsi_lun *);
 struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
 	u8 sense_key;
-	union {
-		struct {
-#if defined(__BIG_ENDIAN)
-			u8 asc;
-			u8 ascq;
-#elif defined(__LITTLE_ENDIAN)
-			u8 ascq;
-			u8 asc;
-#endif
-		};
-		u16 sense_code;
-	};
+	u16 sense_code;
 	u8 byte4;
 	u8 byte5;
 	u8 byte6;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 11910142ac50..e6fd6bc30644 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -527,18 +527,7 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
 struct scsi_failure {
 	int result;
 	u8 sense_key;
-	union {
-		struct {
-#if defined(__BIG_ENDIAN)
-			u8 asc;
-			u8 ascq;
-#elif defined(__LITTLE_ENDIAN)
-			u8 ascq;
-			u8 asc;
-#endif
-		};
-		u16 sense_code;
-	};
+	u16 sense_code;
 	/*
 	 * Number of times scsi_execute_cmd will retry the failure. It does
 	 * not count for the total_allowed.
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index f742a3bfeb86..9c7d31aa6bae 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -219,57 +219,6 @@ enum sam_status {
 
 #define STATUS_MASK         0xfe
 
-/*
- * Additional Sense Codes (ASC).
- */
-#define NO_ADDITIONAL_SENSE		0x00
-#define OVERLAP_ATOMIC_COMMAND_ASC	0x00
-#define LOGICAL_UNIT_NOT_READY		0x04
-#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
-#define WRITE_ERROR_ASC			0x0c
-#define UNRECOVERED_READ_ERR		0x11
-#define PARAMETER_LIST_LENGTH_ERR	0x1a
-#define MISCOMPARE_VERIFY_ASC		0x1d
-#define INVALID_OPCODE			0x20
-#define LBA_OUT_OF_RANGE		0x21
-#define INVALID_FIELD_IN_CDB		0x24
-#define INVALID_FIELD_IN_PARAM_LIST	0x26
-#define WRITE_PROTECTED			0x27
-#define UA_READY_ASC			0x28
-#define UA_RESET_ASC			0x29
-#define UA_CHANGED_ASC			0x2a
-#define TOO_MANY_IN_PARTITION_ASC	0x3b
-#define TARGET_CHANGED_ASC		0x3f
-#define SAVING_PARAMS_UNSUP		0x39
-#define TRANSPORT_PROBLEM		0x4b
-#define INSUFF_RES_ASC			0x55
-#define LOW_POWER_COND_ON		0x5e
-#define THRESHOLD_EXCEEDED		0x5d
-
-/*
- * Additional Sense Code Qualifiers (ASCQ).
- */
-#define POWER_ON_RESET_ASCQ		0x00
-#define MODE_CHANGED_ASCQ		0x01	/* mode parameters changed */
-#define FILEMARK_DETECTED_ASCQ		0x01
-#define POWER_ON_OCCURRED_ASCQ		0x01
-#define MICROCODE_CHANGED_ASCQ		0x01	/* with TARGET_CHANGED_ASC */
-#define BUS_RESET_ASCQ			0x02	/* scsi bus reset occurred */
-#define EOP_EOM_DETECTED_ASCQ		0x02
-#define INSUFF_RES_ASCQ			0x03
-#define BEGINNING_OF_P_M_DETECTED_ASCQ	0x04
-#define UNALIGNED_WRITE_ASCQ		0x04
-#define EOD_DETECTED_ASCQ		0x05
-#define WRITE_BOUNDARY_ASCQ		0x05
-#define READ_INVDATA_ASCQ		0x06
-#define READ_BOUNDARY_ASCQ		0x07
-#define CAPACITY_CHANGED_ASCQ		0x09
-#define ATTEMPT_ACCESS_GAP		0x09
-#define LUNS_CHANGED_ASCQ		0x0e
-#define INSUFF_ZONE_ASCQ		0x0e
-#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
-#define OVERLAP_ATOMIC_COMMAND_ASCQ	0x23
-
 /*
  *  DEVICE TYPES
  *  Please keep them in 0x%02x format for $MODALIAS to work
-- 
2.55.0

