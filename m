Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A793E51F4;
	Mon,  6 Jul 2026 06:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320988; cv=none; b=hhVWhCWpNW9whXatqncWqJV+UalUkAwkrYzJua+emM8ucPXdXsYi/SrFFNtl2ZbIoPvhhVDRx/Cx01t/fNqzcfKLi2H0r9dFSFnq0EfKu0xnxx5uchLJtogsU6BwGC38X+Yexm0N1Q03pFDPJjodku7dSENyQ/Fv/5FyMJr7NJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320988; c=relaxed/simple;
	bh=XDEYCIjpRaFmxTp/j15UBCW1IPEAw6dxYdsGjl3NkUI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4hNiVPAMQDTAwYnSm9JlrWP5iS4Kk/U8lV1xKAl5JCWX/a6IBOvyT+5+6FS4Zox+YfNSwHCxxNnHZk7WpsQZH+ieJYwnlnun3Ls7xQ37PCfH0qWHonZjonLTPVNddduZ5olH2O+MttiCm6lTxeXP/6/LIaK44leAORpNEw6tHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcKhc//k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcKhc//k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFC51F00A3A;
	Mon,  6 Jul 2026 06:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320982;
	bh=RcHH7CKonuhS3diyXn9gLrAYvT+qDsf4+11LSt2XpnM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=IcKhc//kqIeUULWZscAgf6wfRN3V84rmBOkVObB1vUYE4JxDN2eMdGynVUWbAg7qy
	 LW95lLVukSuF+wd5H8sAAM0JRw+2UqaS4hy/8lBakveDwRGgsMiOtDDOZ7oR3mD9tG
	 a6vx4MRceGE5EmSDKBhqTJN8ku0IWbdcMBySOoHoxnHMJdEt+XxT0Zc8H/ZZJXg6Ft
	 hZMJR4FtzierqfWVIs7P2o3vt0UFGUtibL6bCt05m3SOd1O9ENRJEfkVu1MdxfHW6Y
	 Y9j3RusBT6q0qx+7/bBUro81ehtMhzYYwYUmkDsEHsw4dIjKwEYKwSp1t+WTVwRlT/
	 RPDR+I8ObBL2A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 1/9] scsi: scsi_debug: move ASC and ASCQ definitions to scsi_proto.h
Date: Mon,  6 Jul 2026 15:56:02 +0900
Message-ID: <20260706065610.3559692-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706065610.3559692-1-dlemoal@kernel.org>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scsi_debug driver internally defines lots of SCSI additional sense
codes (ASC) and additional sense code qualifiers (ASCQ). Move these
definitions to include/scsi/scsi_proto.h so that they can be reused
elsewhere in the SCSI and ATA code. This also makes the scsi_debug.c file
a little smaller.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 46 -----------------------------------
 include/scsi/scsi_proto.h | 51 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f9..4a95e6bae38b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -67,52 +67,6 @@ static const char *sdebug_version_date = "20210520";
 
 #define MY_NAME "scsi_debug"
 
-/* Additional Sense Code (ASC) */
-#define NO_ADDITIONAL_SENSE 0x0
-#define OVERLAP_ATOMIC_COMMAND_ASC 0x0
-#define OVERLAP_ATOMIC_COMMAND_ASCQ 0x23
-#define FILEMARK_DETECTED_ASCQ 0x1
-#define EOP_EOM_DETECTED_ASCQ 0x2
-#define BEGINNING_OF_P_M_DETECTED_ASCQ 0x4
-#define EOD_DETECTED_ASCQ 0x5
-#define LOGICAL_UNIT_NOT_READY 0x4
-#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
-#define UNRECOVERED_READ_ERR 0x11
-#define PARAMETER_LIST_LENGTH_ERR 0x1a
-#define INVALID_OPCODE 0x20
-#define LBA_OUT_OF_RANGE 0x21
-#define INVALID_FIELD_IN_CDB 0x24
-#define INVALID_FIELD_IN_PARAM_LIST 0x26
-#define WRITE_PROTECTED 0x27
-#define UA_READY_ASC 0x28
-#define UA_RESET_ASC 0x29
-#define UA_CHANGED_ASC 0x2a
-#define TOO_MANY_IN_PARTITION_ASC 0x3b
-#define TARGET_CHANGED_ASC 0x3f
-#define LUNS_CHANGED_ASCQ 0x0e
-#define INSUFF_RES_ASC 0x55
-#define INSUFF_RES_ASCQ 0x3
-#define POWER_ON_RESET_ASCQ 0x0
-#define POWER_ON_OCCURRED_ASCQ 0x1
-#define BUS_RESET_ASCQ 0x2	/* scsi bus reset occurred */
-#define MODE_CHANGED_ASCQ 0x1	/* mode parameters changed */
-#define CAPACITY_CHANGED_ASCQ 0x9
-#define SAVING_PARAMS_UNSUP 0x39
-#define TRANSPORT_PROBLEM 0x4b
-#define THRESHOLD_EXCEEDED 0x5d
-#define LOW_POWER_COND_ON 0x5e
-#define MISCOMPARE_VERIFY_ASC 0x1d
-#define MICROCODE_CHANGED_ASCQ 0x1	/* with TARGET_CHANGED_ASC */
-#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
-#define WRITE_ERROR_ASC 0xc
-#define UNALIGNED_WRITE_ASCQ 0x4
-#define WRITE_BOUNDARY_ASCQ 0x5
-#define READ_INVDATA_ASCQ 0x6
-#define READ_BOUNDARY_ASCQ 0x7
-#define ATTEMPT_ACCESS_GAP 0x9
-#define INSUFF_ZONE_ASCQ 0xe
-/* see drivers/scsi/sense_codes.h */
-
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index f64385cde5b9..965cde7ebc5b 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -233,6 +233,57 @@ enum sam_status {
 #define MISCOMPARE          0x0e
 #define COMPLETED	    0x0f
 
+/*
+ * Additional Sense Codes (ASC).
+ */
+#define NO_ADDITIONAL_SENSE		0x00
+#define OVERLAP_ATOMIC_COMMAND_ASC	0x00
+#define LOGICAL_UNIT_NOT_READY		0x04
+#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
+#define WRITE_ERROR_ASC			0x0c
+#define UNRECOVERED_READ_ERR		0x11
+#define PARAMETER_LIST_LENGTH_ERR	0x1a
+#define MISCOMPARE_VERIFY_ASC		0x1d
+#define INVALID_OPCODE			0x20
+#define LBA_OUT_OF_RANGE		0x21
+#define INVALID_FIELD_IN_CDB		0x24
+#define INVALID_FIELD_IN_PARAM_LIST	0x26
+#define WRITE_PROTECTED			0x27
+#define UA_READY_ASC			0x28
+#define UA_RESET_ASC			0x29
+#define UA_CHANGED_ASC			0x2a
+#define TOO_MANY_IN_PARTITION_ASC	0x3b
+#define TARGET_CHANGED_ASC		0x3f
+#define SAVING_PARAMS_UNSUP		0x39
+#define TRANSPORT_PROBLEM		0x4b
+#define INSUFF_RES_ASC			0x55
+#define LOW_POWER_COND_ON		0x5e
+#define THRESHOLD_EXCEEDED		0x5d
+
+/*
+ * Additional Sense Code Qualifiers (ASCQ).
+ */
+#define POWER_ON_RESET_ASCQ		0x00
+#define MODE_CHANGED_ASCQ		0x01	/* mode parameters changed */
+#define FILEMARK_DETECTED_ASCQ		0x01
+#define POWER_ON_OCCURRED_ASCQ		0x01
+#define MICROCODE_CHANGED_ASCQ		0x01	/* with TARGET_CHANGED_ASC */
+#define BUS_RESET_ASCQ			0x02	/* scsi bus reset occurred */
+#define EOP_EOM_DETECTED_ASCQ		0x02
+#define INSUFF_RES_ASCQ			0x03
+#define BEGINNING_OF_P_M_DETECTED_ASCQ	0x04
+#define UNALIGNED_WRITE_ASCQ		0x04
+#define EOD_DETECTED_ASCQ		0x05
+#define WRITE_BOUNDARY_ASCQ		0x05
+#define READ_INVDATA_ASCQ		0x06
+#define READ_BOUNDARY_ASCQ		0x07
+#define CAPACITY_CHANGED_ASCQ		0x09
+#define ATTEMPT_ACCESS_GAP		0x09
+#define LUNS_CHANGED_ASCQ		0x0e
+#define INSUFF_ZONE_ASCQ		0x0e
+#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
+#define OVERLAP_ATOMIC_COMMAND_ASCQ	0x23
+
 /*
  *  DEVICE TYPES
  *  Please keep them in 0x%02x format for $MODALIAS to work
-- 
2.54.0

