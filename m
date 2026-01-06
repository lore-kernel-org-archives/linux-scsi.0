Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3A3081B8
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 19:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726032; cv=none; b=dWnBcRwcBMW/xEhWOzL/fBdPbIGSSoL4JYmOETTuowjRn7P7XwtDyRRAZhW+QFBIQg75GTJj46w8u13X683BJtTHqj6c9Wd5TDxVt1LVBarQ6o35m/Cxcdc7r+H2ARNMBhTzfjAnFcFrTDuNjWYEKHzoU8LM4wdZVg9hoFk/cgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726032; c=relaxed/simple;
	bh=ShrMlvVSmBpySujKQRGPdz68bioymZEkWhj8Oi2gRTc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NTSKZBk4Rxl6Qiv9HM+pxFc6VMenRTGQ8ofBTg0gOikaoOB6/f0H4tkn1l4ggbo9gmVXPX+3JbBx6p6nr6oxzayR+HLHSQZheTRDgRCQvXBTMQB00SOaabyFOw4MoVgZiji1YcEugA733MNVfj3jN7aLGuYRSVlvPgWtEqlCe7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hcOCEWQn; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hcOCEWQn"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dm0qK6hZVzm3QsT;
	Tue,  6 Jan 2026 19:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1767726028; x=1770318029; bh=QipDuGfe0YRYdc4pqAPbyWxP6kMjYkDHgMH
	jEXboAd8=; b=hcOCEWQnjE/71/WlwySU8vWpjwWSz5phkJdfFx/CHhFRNTD+jo9
	puD5apbbzrAm7+iQMg+ZW/fLINOkN04WNH4NdFnJ/TpxhsSR/A58yUS8GVHInCEO
	iN3bpUDjO/D3PxUwXk5qnQHmENu0BVGEGScDV8Yy76OpGCXz7Agy+sn0+VJAb2Yy
	LDylDlvd68W+ms1xXObYseR++sBjhZyicq9ETwy4jlskqtUxRTp2IZkyqREcnw3b
	jPGY+Ifqr0ALGrbUDfbidOkIJQdK89eXnxgjw+G2A8qcBU/ObyvLsmdkmKtQt9Nu
	fqQUvePXtNymHV7Ke+2xO+AnuH1mR79salw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DaUAD4XArx0i; Tue,  6 Jan 2026 19:00:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dm0qH0SL0zlfl5W;
	Tue,  6 Jan 2026 19:00:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] ufs: core: Improve the documentation of UFS data frames
Date: Tue,  6 Jan 2026 12:00:17 -0700
Message-ID: <20260106190017.2527978-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In source code comments, use terminology that comes from the JEDEC
UFS standard. This makes it easier to compare the UFS driver code with th=
e
JEDEC UFS standard. Add static_assert() statements that verify the size
of data structures defined in the UFS standard.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 17 ++++++++---------
 include/ufs/ufs.h                |  5 ++++-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bs=
g_ufs.h
index 8c29e498ef98..06f88d1b1876 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -94,16 +94,15 @@ struct utp_upiu_header {
 };
=20
 /**
- * struct utp_upiu_query - upiu request buffer structure for
- * query request.
- * @opcode: command to perform B-0
- * @idn: a value that indicates the particular type of data B-1
- * @index: Index to further identify data B-2
- * @selector: Index to further identify data B-3
+ * struct utp_upiu_query - QUERY REQUEST UPIU structure.
+ * @opcode: query function to perform B-0
+ * @idn: descriptor or attribute identification number B-1
+ * @index: Index that further identifies which data to access B-2
+ * @selector: Index that further identifies which data to access B-3
  * @reserved_osf: spec reserved field B-4,5
- * @length: number of descriptor bytes to read/write B-6,7
- * @value: Attribute value to be written DW-5
- * @reserved: spec reserved DW-6,7
+ * @length: number of descriptor bytes to read or write B-6,7
+ * @value: if @opcode =3D=3D UPIU_QUERY_OPCODE_WRITE_ATTR, the value to =
be written B-6,7
+ * @reserved: reserved for future use DW-6,7
  */
 struct utp_upiu_query {
 	__u8 opcode;
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index ab8f6c07b5a2..602aa34c9822 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -21,6 +21,7 @@
  * in this header file of the size of struct utp_upiu_header.
  */
 static_assert(sizeof(struct utp_upiu_header) =3D=3D 12);
+static_assert(sizeof(struct utp_upiu_query) =3D=3D 20);
=20
 #define GENERAL_UPIU_REQUEST_SIZE (sizeof(struct utp_upiu_req))
 #define QUERY_DESC_MAX_SIZE       255
@@ -561,7 +562,7 @@ enum ufs_dev_pwr_mode {
 #define UFS_WB_BUF_REMAIN_PERCENT(val) ((val) / 10)
=20
 /**
- * struct utp_cmd_rsp - Response UPIU structure
+ * struct utp_cmd_rsp - RESPONSE UPIU structure
  * @residual_transfer_count: Residual transfer count DW-3
  * @reserved: Reserved double words DW-4 to DW-7
  * @sense_data_len: Sense data length DW-8 U16
@@ -574,6 +575,8 @@ struct utp_cmd_rsp {
 	u8 sense_data[UFS_SENSE_SIZE];
 };
=20
+static_assert(sizeof(struct utp_cmd_rsp) =3D=3D 40);
+
 /**
  * struct utp_upiu_rsp - general upiu response structure
  * @header: UPIU header structure DW-0 to DW-2
