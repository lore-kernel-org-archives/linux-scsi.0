Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B82139CEB
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 05:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713938005; cv=none; b=QeGUipJ0mZSTeYNsrLJwRlYz29pDEfW/7Pr5/3vumh2tnjex4zAOpljTB91ZXY0z0evrajPeRPX3N620MiXBmf2DB6j0z++5q1nqF0SnhCp7kVI+nRkziWq+fCfU3uIy6lqxOw1dRxZO0zR20aRSQuD9DvRzb/28U9kKJf1s5+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713938005; c=relaxed/simple;
	bh=IRxJE/wIKbxOswf4pmb9STJKAX9/TsGdAvyH5AO9CW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TUopNqMDqlPFp96Ldc3WIdszu5K2FdO2HT1VMFPETHxF7+g+7hXf9EPV7R9hPZeGUFjzQXX1o15sYDTmiImWGjY6bVOZkfBhFHGigJraVjSoKaSDT55Gz7V/5UZZhdQUB7kofba9clw+tBibWnfqgHZxWy4DfUIWBEFRwillxrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m2lJpM95; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m2lJpM95"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=yQsNnqDaJ1cIMb3CJ4G/eD92oiIlTwLiMpxTp5fFPeI=; b=m2lJpM95/iMdV5ihLeH62AQlD9
	jO/qwVWZE5SIMCFl86gh1IBjwFpkzKXIWahp9wuYys0EhuoD6dHVnazCQxL2L8kmdyD7BwFOxy6OU
	JOKdJXRiuQY/BU30raEa5Ryz/uOTcoL+tiMzwlwh5WKbffbfPPQ6LVPxHgCtrpTCZNxcglxyXmjXC
	xBTG5whS7abpkqItr3oVge6oBllRqgtJqPuIbHoFwJdThBcldMkiTCRTP5ODg4P5VY6u9MeLQnXZX
	CbBeVG0LvVFVtKB75sT1V6/rYt1QMeOtpsJJJP7KZ2iX6IiVtHkhkMgZ6ptl0jQtkxZedxjv2Wy65
	cmfQwRtg==;
Received: from [50.53.4.147] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzVZL-00000002lWc-1Pdp;
	Wed, 24 Apr 2024 05:53:23 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com
Subject: [PATCH] scsi: mpi3mr: fix some kernel-doc warnings in scsi_bsg_mpi3mr.h
Date: Tue, 23 Apr 2024 22:53:22 -0700
Message-ID: <20240424055322.1400-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct the name of a struct in kernel-doc to match the actual
function name.
Add kernel-doc comments for 2 reserved fields to match comments
for other reserved fields.
Correct the kernel-doc comments for a nested struct to eliminate
kernel-doc warnings for them.

Warnings fixed here are:

scsi_bsg_mpi3mr.h:419: warning: expecting prototype for struct mpi3mr_bsg_buf_entry_list. Prototype was for struct mpi3mr_buf_entry_list instead

scsi_bsg_mpi3mr.h:435: warning: Function parameter or struct member 'rsvd2' not described in 'mpi3mr_bsg_mptcmd'
scsi_bsg_mpi3mr.h:456: warning: Function parameter or struct member 'rsvd3' not described in 'mpi3mr_bsg_packet'

scsi_bsg_mpi3mr.h:456: warning: Excess struct member 'drvrcmd' description in 'mpi3mr_bsg_packet'
scsi_bsg_mpi3mr.h:456: warning: Excess struct member 'mptcmd' description in 'mpi3mr_bsg_packet'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
---
 include/uapi/scsi/scsi_bsg_mpi3mr.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -- a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -401,7 +401,7 @@ struct mpi3mr_buf_entry {
 	__u32	buf_len;
 };
 /**
- * struct mpi3mr_bsg_buf_entry_list - list of user buffer
+ * struct mpi3mr_buf_entry_list - list of user buffer
  * descriptor for MPI Passthrough requests.
  *
  * @num_of_entries: Number of buffer descriptors
@@ -424,6 +424,7 @@ struct mpi3mr_buf_entry_list {
  * @mrioc_id: Controller ID
  * @rsvd1: Reserved
  * @timeout: MPI request timeout
+ * @rsvd2: Reserved
  * @buf_entry_list: Buffer descriptor list
  */
 struct mpi3mr_bsg_mptcmd {
@@ -441,8 +442,9 @@ struct mpi3mr_bsg_mptcmd {
  * @cmd_type: represents drvrcmd or mptcmd
  * @rsvd1: Reserved
  * @rsvd2: Reserved
- * @drvrcmd: driver request structure
- * @mptcmd: mpt request structure
+ * @rsvd3: Reserved
+ * @cmd.drvrcmd: driver request structure
+ * @cmd.mptcmd: mpt request structure
  */
 struct mpi3mr_bsg_packet {
 	__u8	cmd_type;
