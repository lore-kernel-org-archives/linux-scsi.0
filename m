Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF41F139CEB
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 05:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713938000; cv=none; b=fY388FBsPO/UzUER4IjNKlqF6B9Sso0+RJfSGZswxZMHMI//KiTjHfsu+An7lHXMJqq8wsUjCK9QlR/BXywgxizgB7NaqVVeMvgwf5tPkkjukD56AXo5nwfPm1ht9eXYrYWlu4KQdeDFXqN+ELMEOOEtG4IRk/ONFgp6G+cikbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713938000; c=relaxed/simple;
	bh=ZESxxmxxAV/OtJGR9ABy14gXz78lw3bK6vGHiuZVH4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tHdjZjG5tZaE2C5ZeI4xwLPiyAS5/nge7PzogD2ZV4nj5Xxa4IHnHm/ctTagbITbmdUo9ZQaaPI3ZpYU8pxBZ1+kjd9Ra1pY+jrLkJ5wRtfPZXsi9Z0ZBue9DhMzQv61KEt/Uap345MhcEI68Y4owTTxddRd1HMmOyVCVY9o/C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P94JHOAQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P94JHOAQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=X7Fi1ZpU5DamqdoRD8TAQwIx5vAjLL+bcr/uDS+l02w=; b=P94JHOAQbzQ9HET/Dm2DdynDU7
	vVHXVK3hRPa5lghLGdMWiz6v00UQmQv97EFuT8BDgwhBBC1QJvHFwNw5NTp85ajYcvnqB8Jk/llcZ
	WYchj0puI0jdJIHzfTAbng4R94wbnnLWHlzrbzlKhR3NfudQ/LsOUuvbHBhjlz0jepIV4pcoTHCH7
	De/kJVP+ulaYTh1Z8Jqas3t+KlEKXw3tveZmvrS0mBCBkIyVoxmv8scH9PBuWGFBDgijXjCm0EScK
	RT8FN2k/00cUXcS3k6gWZnaIjoige3FhmUkvIM8Vw2ybCO4/BbEykyVqXCD5KBKlAdwfP1pqKkAdy
	k/Rxx5zw==;
Received: from [50.53.4.147] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzVZF-00000002lVj-0avC;
	Wed, 24 Apr 2024 05:53:17 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: ufs: scsi_bsg_ufs.h: fix all kernel-doc warnings
Date: Tue, 23 Apr 2024 22:53:16 -0700
Message-ID: <20240424055316.1384-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In struct utp_upiu_query_v4_0, add description for @osf3 and mark
the @reserved field as private so that no description is needed for it.

In struct utp_upiu_cmd, use the correct struct member name to
eliminate a kernel-doc warning.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bart Van Assche <bvanassche@acm.org>
---
 include/uapi/scsi/scsi_bsg_ufs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -- a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -123,6 +123,7 @@ struct utp_upiu_query {
  * @idn: a value that indicates the particular type of data B-1
  * @index: Index to further identify data B-2
  * @selector: Index to further identify data B-3
+ * @osf3: spec field B-4
  * @osf4: spec field B-5
  * @osf5: spec field B 6,7
  * @osf6: spec field DW 8,9
@@ -138,12 +139,13 @@ struct utp_upiu_query_v4_0 {
 	__be16 osf5;
 	__be32 osf6;
 	__be32 osf7;
+	/* private: */
 	__be32 reserved;
 };
 
 /**
  * struct utp_upiu_cmd - Command UPIU structure
- * @data_transfer_len: Data Transfer Length DW-3
+ * @exp_data_transfer_len: Data Transfer Length DW-3
  * @cdb: Command Descriptor Block CDB DW-4 to DW-7
  */
 struct utp_upiu_cmd {
