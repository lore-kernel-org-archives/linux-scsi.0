Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ABE1C5F37
	for <linux-scsi@vger.kernel.org>; Thu,  1 May 2025 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746123387; cv=none; b=tmfc7MB1xIDo2nyX0gQfh51JqO29TSrnwv7G719y3XHnFC2+RU/E1o4ZXVGLtW2Zqf1g9GhBIlpYroJe+HvdmpTJ5HN9YLCtLs/SjJ5WWG5COvklZ3pzR7gUG9Yoy9L4vYXvJzsolJWVnf8eLZEOGpUAuUG1mv+TY+DKCfEMseA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746123387; c=relaxed/simple;
	bh=GH66X0NRB2LUyLXSW0soOeRBjGP01SHyTMIAkKknc0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A5VhMYlI4htAnKJjhn5qmVOJhMWz9+ge6VN2/bGb4K6uGKya2wEvGAivECrLsbJc/lePJdmRHd3ml6rFqet1u3dMd/voDU34QvKss3CTzgrdBV+jcvIMlFiKFPePxe1+qc1oQLlK1ZRSK7vKA2xuVZPTuLDa/J7w5emiYiBcW74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q5R+cFGy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q5R+cFGy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bpMdTL6jV6IWJv8W1VMkJqPYCuPfbGT6YumkcrORkA4=; b=Q5R+cFGyR0tBCTPdLN4qNTy/sj
	f6f7CNfLfylqUiSGAPp7cV4S0e1idpb1LB00ZHNZst5+BlMJrmUFapzLBmv3yfMw76XdLbTBaAhIB
	0iQjeozLwX6MuDBh93+HD/BGUdWzZT9cF7HRDO+Nur5etGkdglTW+fN7OywsO0hxWcsJi1k9XvTXo
	RGSeO1wWhSGUqnd1IvhujacO3sIfLRdv++o3yxjcsTVgiPzgwYChLs1BbcXrcdZZpA9usuC2zAUen
	dergrH4ZxkmyDFtapt5L8ggDqOrXMxaJIfo/b9WdfQH4yuizFVOEiK8Z8JEtuyKwprYvrNw5R5JT4
	1wN9sK0w==;
Received: from [165.225.57.164] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAYSO-0000000GLi9-3AyF;
	Thu, 01 May 2025 18:16:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: remove the stream_status member from scsi_stream_status_header
Date: Thu,  1 May 2025 13:16:23 -0500
Message-ID: <20250501181623.2942698-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Having a variable length array at the end of scsi_stream_status_header
only cause problems.  Remove it and switch the one place that actually
used it to use the struct member directly following in the actual on-disk
structure instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c         | 2 +-
 include/scsi/scsi_proto.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..3f6e87705b62 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3215,7 +3215,7 @@ static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
 		return false;
 	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
 		return false;
-	return buf.h.stream_status[0].perm;
+	return buf.s.perm;
 }
 
 static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index aeca37816506..bc8f2b2226be 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -349,7 +349,6 @@ struct scsi_stream_status_header {
 	__be32 len;	/* length in bytes of stream_status[] array. */
 	u16 reserved;
 	__be16 number_of_open_streams;
-	DECLARE_FLEX_ARRAY(struct scsi_stream_status, stream_status);
 };
 
 static_assert(sizeof(struct scsi_stream_status_header) == 8);
-- 
2.47.2

