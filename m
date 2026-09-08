Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7E4F30D9;
	Tue,  8 Sep 2026 09:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858274; cv=none; b=eVvxr1bx/aoxcSqRkOt9/aXSRRhu4F6Uz2L+sdvsS83JY0Ny46svmsZuS4UKB3KyfL2nI/7dMyZfM0SeVeHPotw9KwLdT9TVFyzUCn9Q9aGCreZMJZFpvJuNUoefP/BH0AsuJMamCubcWsIMK5InehrY0pjVXnpZ5Y2cV7lhxEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858274; c=relaxed/simple;
	bh=ZJNeg5pTZ18uzsm4DHJLk7inYrbR9OO62tp3hjKMD2k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxxOytcS84dLanR2ins/HwyknqEkPY0cRYzC7Hr5nlU1WA1DukKpMFlSS4Ftnpp5pJPqpSPZas9dlnRNrvrBMeO50UFvt/eE2of9mmL+QDAfbMpF3Z7ctiQtXK1sPjS5BAG9xzmTsWexx1epinuFmEL1qK2OhCV/xd+wY0/QBsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJq7VnIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJq7VnIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D601F00A3A;
	Tue,  8 Sep 2026 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858270;
	bh=HcQa/6bn55Lq4aamp8nGE30jzN4IQu4r4mmmH1jXWMI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MJq7VnIRA1h/jA0+2bSuUBJ0xuESFMN3y8borARDuSX7XFzs12QMPSyR9qKFzxEQN
	 70wLv/vXbNcmlkw7zuP20e/fze6rPbguknpIlCo+OWzDD33/ZnobTnW+233nFko78Z
	 uhhAeSq7cEYlfdc0YPowNViKEBW1I8v80a++oQYbCcOHRzRo2RUcTN3cO2O9S+vmqj
	 MXDavS7FAV7ulHMMS5KMabyFOYMdphm2yrwhoDyCkbv6EqpueorrfuMR8yzxw1yZAx
	 pmu9wrsKFKoQEwEu32Qg36M77vBeNdm1BblKPElSJUspc1wcrny8r8Zt5Q9SRZxtZJ
	 /1hyeCd9zZTDg==
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
Subject: [PATCH v6 40/40] scsi: remove scsi_build_sense() and scsi_build_sense_buffer()
Date: Tue,  8 Sep 2026 18:03:08 +0900
Message-ID: <20260908090308.1085097-41-dlemoal@kernel.org>
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

Now that all code has been converted to use 16-bits sense codes and to
initialize sense with scsi_set_sense() and scsi_set_sense_buffer(), remove
the inline definitions of these new functions, change scsi_build_sense()
and scsi_build_sense_buffer() to use a single 16-bits sense code as
argument (instead of separate arguments for the ASC and ASCQ), and
rename them to scsi_set_sense()  and scsi_set_sense_buffer().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/scsi_common.c | 12 +++++++-----
 drivers/scsi/scsi_lib.c    | 11 +++++------
 include/scsi/scsi_cmnd.h   | 10 +---------
 include/scsi/scsi_common.h |  8 +-------
 4 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 2cabc932acd4..94b160336247 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -276,17 +276,19 @@ const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
 EXPORT_SYMBOL(scsi_sense_desc_find);
 
 /**
- * scsi_build_sense_buffer - build sense data in a buffer
+ * scsi_set_sense_buffer - build sense data in a buffer
  * @desc:	Sense format (non-zero == descriptor format,
  *              0 == fixed format)
  * @buf:	Where to build sense data
  * @key:	Sense key
- * @asc:	Additional sense code
- * @ascq:	Additional sense code qualifier
+ * @code:	Additional sense code and sense code qualifier
  *
  **/
-void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
+void scsi_set_sense_buffer(int desc, u8 *buf, u8 key, u16 code)
 {
+	u8 asc = scsi_sense_code_asc(code);
+	u8 ascq = scsi_sense_code_ascq(code);
+
 	if (desc) {
 		buf[0] = 0x72;	/* descriptor, current */
 		buf[1] = key;
@@ -301,7 +303,7 @@ void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
 		buf[13] = ascq;
 	}
 }
-EXPORT_SYMBOL(scsi_build_sense_buffer);
+EXPORT_SYMBOL(scsi_set_sense_buffer);
 
 /**
  * scsi_set_sense_information - set the information field in a
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7b1684379021..db64470f5229 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3585,21 +3585,20 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
 
 /**
- * scsi_build_sense - build sense data for a command
+ * scsi_set_sense - build sense data for a command
  * @scmd:	scsi command for which the sense should be formatted
  * @desc:	Sense format (non-zero == descriptor format,
  *              0 == fixed format)
  * @key:	Sense key
- * @asc:	Additional sense code
- * @ascq:	Additional sense code qualifier
+ * @code:	Additional sense code and sense code qualifier
  *
  **/
-void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
+void scsi_set_sense(struct scsi_cmnd *scmd, int desc, u8 key, u16 code)
 {
-	scsi_build_sense_buffer(desc, scmd->sense_buffer, key, asc, ascq);
+	scsi_set_sense_buffer(desc, scmd->sense_buffer, key, code);
 	scmd->result = SAM_STAT_CHECK_CONDITION;
 }
-EXPORT_SYMBOL_GPL(scsi_build_sense);
+EXPORT_SYMBOL_GPL(scsi_set_sense);
 
 #ifdef CONFIG_SCSI_LIB_KUNIT_TEST
 #include "scsi_lib_test.c"
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bf6d69f0249f..2f2364c96457 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -391,15 +391,7 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 	return xfer_len;
 }
 
-extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
-			     u8 key, u8 asc, u8 ascq);
-
-static inline void scsi_set_sense(struct scsi_cmnd *scmd, int desc,
-				  u8 key, u16 code)
-{
-	scsi_build_sense(scmd, desc, key, scsi_sense_code_asc(code),
-			 scsi_sense_code_ascq(code));
-}
+void scsi_set_sense(struct scsi_cmnd *scmd, int desc, u8 key, u16 code);
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 405512554ee8..88a076c1a137 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -99,13 +99,7 @@ static inline u8 scsi_sense_ascq(const struct scsi_sense_hdr *sshdr)
 extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				 struct scsi_sense_hdr *sshdr);
 
-extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
-
-static inline void scsi_set_sense_buffer(int desc, u8 *buf, u8 key, u16 code)
-{
-	scsi_build_sense_buffer(desc, buf, key, scsi_sense_code_asc(code),
-				scsi_sense_code_ascq(code));
-}
+void scsi_set_sense_buffer(int desc, u8 *buf, u8 key, u16 code);
 
 int scsi_set_sense_information(u8 *buf, int buf_len, u64 info);
 int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd);
-- 
2.55.0

