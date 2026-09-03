Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DDE376468;
	Thu,  3 Sep 2026 03:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406950; cv=none; b=EwXXU4bvP75eIh8SAOSuV8FZk8iK2JnaFmLegq+9ThTZCvygseCaniHjS+DtCzjAgEuaR2W3sPo1ev10gpDPKnAIvaMDVJOXWdaRh4s5yvBXK86y3oCq+ahvkOyc536ZYdAEEOCqVIhhu3c3PgKFYBO8eYgCCbPwtnJK5zzGn8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406950; c=relaxed/simple;
	bh=qsGEd0KXlTnqzF7nlTZeADt4SwJufjuUfh60ga1DdsM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbLSMxY/olnFg6itg6XgBUTnY5Cy3SA+BVtOo0So6RAMF1rJilgNr0S34Jc4enCaDJyIopbdg+03Pa3a0fXgLoHnQlip5h+8iiL2UxXzZFeyA/OwkylAXrBaoP0Z6TvTXORvZ1sJyLhIFVC0JAitl4gR5JJawH3I6WzfCgSCxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqgiSfuq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqgiSfuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76181F00A3D;
	Thu,  3 Sep 2026 03:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406944;
	bh=LSswKHMdAi/dsbRGIaFaHwDVI3E91CJKyT5dfZ2W6OQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=YqgiSfuqR6lPcdob/zKlKrLjKF+VIfO9QBmdxr4v4qDsgzSi7011zRPbYMLGUTxGx
	 dhMGgBdjMzYUlE6X3Ur1Udr8NWyH9Ufb5AvYr2DFG3JuZtgn4Ul0Tx5FbvZ26f6Poc
	 b9WYqsHYYVALoxN3PyquswAzlkzRElNGsSWIhb1j4DAYaGSU7P4CGqj9zXDbJajkXt
	 1RCvBvfkdNTGY4WjUebziwm8PYeEZ8FQeADenjCzfL/YzzzqPA5VkWKcI/OJ74bl3M
	 eFhewgMawcDCpa0+D+YTt6AZMyZlOzr0dCzT+SE8dNxLbEgLvZs0i5PrpLb74q5DRe
	 5BsbGEaXud/FA==
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
Subject: [PATCH v2 05/40] scsi: prepare for using 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:26 +0900
Message-ID: <20260903034201.112211-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for handling sense codes and their qualifiers as a single
16-bits sense code field, with the values  defined as macros in
include/scsi/scsi_sense.h, modify the definition of the structures
scsi_failure and scsi_sense_hdr to introduce a 16-bits sense_code field
as a union with the existing 8-bits asc and ascq fields.

This temporary modification allows accessing either the asc and ascq
fields individually, or their combination as the 16-bits sense_code field.

The helper functions scsi_sense_asc(), scsi_sense_ascq() are defined to
allow accessing the 8-bits ASC and ASCQ values from the sense_code filed
of struct scsi_sense_hdr. The helper functions scsi_failure_asc() and
scsi_failure_ascq() provide the same for the sense code field of struct
scsi_failure.

The helper functions scsi_set_sense_buffer() and scsi_set_sense() are also
added to wrap calls to scsi_build_sense_buffer() and scsi_build_sense()
using a 16-bits sense code aregument instead of the 8-bits ASC and ASCQ
arguments.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 include/scsi/scsi_cmnd.h   |  7 +++++++
 include/scsi/scsi_common.h | 31 +++++++++++++++++++++++++++++--
 include/scsi/scsi_device.h | 25 +++++++++++++++++++++++--
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db..bf6d69f0249f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -394,6 +394,13 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 			     u8 key, u8 asc, u8 ascq);
 
+static inline void scsi_set_sense(struct scsi_cmnd *scmd, int desc,
+				  u8 key, u16 code)
+{
+	scsi_build_sense(scmd, desc, key, scsi_sense_code_asc(code),
+			 scsi_sense_code_ascq(code));
+}
+
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
 
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 00c8a16d3cd2..6fb2c290ba33 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -71,8 +71,18 @@ extern u64 scsilun_to_int(struct scsi_lun *);
 struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
 	u8 sense_key;
-	u8 asc;
-	u8 ascq;
+	union {
+		struct {
+#if defined(__BIG_ENDIAN)
+			u8 asc;
+			u8 ascq;
+#elif defined(__LITTLE_ENDIAN)
+			u8 ascq;
+			u8 asc;
+#endif
+		};
+		u16 sense_code;
+	};
 	u8 byte4;
 	u8 byte5;
 	u8 byte6;
@@ -87,10 +97,27 @@ static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
 	return (sshdr->response_code & 0x70) == 0x70;
 }
 
+static inline u8 scsi_sense_asc(const struct scsi_sense_hdr *sshdr)
+{
+	return scsi_sense_code_asc(sshdr->sense_code);
+}
+
+static inline u8 scsi_sense_ascq(const struct scsi_sense_hdr *sshdr)
+{
+	return scsi_sense_code_ascq(sshdr->sense_code);
+}
+
 extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				 struct scsi_sense_hdr *sshdr);
 
 extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
+
+static inline void scsi_set_sense_buffer(int desc, u8 *buf, u8 key, u16 code)
+{
+	scsi_build_sense_buffer(desc, buf, key, scsi_sense_code_asc(code),
+				scsi_sense_code_ascq(code));
+}
+
 int scsi_set_sense_information(u8 *buf, int buf_len, u64 info);
 int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd);
 extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e321471e8ca2..11910142ac50 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -518,6 +518,7 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
  * to match any sense key, ASC, and ASCQ value.
  */
 #define SCMD_FAILURE_SENSE_KEY_ANY	0xff
+#define SCMD_FAILURE_SENSE_CODE_ANY	0xffff
 #define SCMD_FAILURE_ASC_ANY		0xff
 #define SCMD_FAILURE_ASCQ_ANY		0xff
 /* Always retry a matching failure. */
@@ -526,8 +527,18 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
 struct scsi_failure {
 	int result;
 	u8 sense_key;
-	u8 asc;
-	u8 ascq;
+	union {
+		struct {
+#if defined(__BIG_ENDIAN)
+			u8 asc;
+			u8 ascq;
+#elif defined(__LITTLE_ENDIAN)
+			u8 ascq;
+			u8 asc;
+#endif
+		};
+		u16 sense_code;
+	};
 	/*
 	 * Number of times scsi_execute_cmd will retry the failure. It does
 	 * not count for the total_allowed.
@@ -537,6 +548,16 @@ struct scsi_failure {
 	s8 retries;
 };
 
+static inline u8 scsi_failure_asc(const struct scsi_failure *failure)
+{
+	return scsi_sense_code_asc(failure->sense_code);
+}
+
+static inline u8 scsi_failure_ascq(const struct scsi_failure *failure)
+{
+	return scsi_sense_code_ascq(failure->sense_code);
+}
+
 struct scsi_failures {
 	/*
 	 * If a scsi_failure does not have a retry limit setup this limit will
-- 
2.55.0

