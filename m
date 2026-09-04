Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B152222AA;
	Fri,  4 Sep 2026 00:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481630; cv=none; b=j266lQTf4Gow7JHqM17a/6bRnhhKl7euG/ahLM00Vz9710lhObQpTOJ8/m1PRzVSLFE600paIdi1lyE3/MJTp+Ev3ERtk5DwTxv0+cHOErZQpefdqusSdtNOSIH7cQpSp+vNaTHUZSVl9q0jWagC0mUlakoGhHFiAb6NbEtR9KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481630; c=relaxed/simple;
	bh=p6Vn7ir6GyvBLd/CbT1CC0lsYu99WNCtCn3PS2pKDgQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFlefM28bVl5hsyaDdEKwfaLzOtCdNsKKUla3+6Srm5PlJHaREZZn/aJQR/jFMfdw9a4e93uZdYsmslBh4o8KdzUyO/eWOB7Df006DMtEuKkgwj80xjCPota2i5bBV8crRV6segiFEN8764C0B5d6zZl2ex407rfkc+y/uuYueI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKdARIT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKdARIT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434E71F00A3F;
	Fri,  4 Sep 2026 00:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481626;
	bh=Guaqk/BBX5vgOdW0a3i3b9jcaHjfbK+jFdXc8XR3lFE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=TKdARIT8C3N78xIUlqd0mh1NiI6/Bhaaue4Ice15WpsXxYmvzPXtrZwAkozu0SYMC
	 CCZLyJ/djZfxspJ6FxrsKFYNkjHUt4uv65jGOO7+uJRKPmF1zHhSBxV51LqsLcZzvT
	 NPV0+5gAMoe3j0SyrCKbkBbQMXX4MvQzyWztVPajJQ/FN9QGxPpYovFpXR8A+k8dFx
	 4AxAzPpVkxqg1+6nVjlFJrPfVj8bdWztD1BTG0NnvUK4zLQZF7xRj7PyXGNonVQhMo
	 LWxHnQED3vezWrFH9SuI0Mpbot1iar45NXGKZWCGU7gX1rxKrjka8EEsIjBCXPqJeM
	 lGZLhGh03Wu9g==
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
Subject: [PATCH v3 05/40] scsi: prepare for using 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:09 +0900
Message-ID: <20260904002644.157668-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

