Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30DAEEBA
	for <linux-scsi@vger.kernel.org>; Mon,  5 May 2025 06:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746425207; cv=none; b=FZHWC0hp11DpUdqYbFp+iPJraJHg0WTMCmgJjPwv5nXUtOdXlTxlrROjCeu31TFRzBGsjeMY8pKb2l/cF14si9oIXBRDO5FcqN9ViAJoEqWf3hUdiXbigkA5LDfxi7UZ7Xrhl82Dhx77kAkE5eiCjZMqF45jnmzM5AgGsfWAQLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746425207; c=relaxed/simple;
	bh=0zF284AoHkxHgKhB9ExEjv+3/TdDfI/HB8kqVmczLzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bf58omUvkGiizYjifgrvPcDi+hpfQuYUCkq7jEh00p8YnFsHcVLIPUQLGa40ZmceDwSgIWmkntD+B8nSu9lmqA0OZxJdZElU/IQkSaWS0krKU7oO6rcaWp18TC/mtKWxBEcoTLT/iYmwDBk0ZVCkGF1BP+tfewLNkNK1Jtq6atk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YJy2/zqD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YJy2/zqD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=GbB72e0IjLuIG23f2fQJb+6u4QUVQMMPG11Acgi9jSs=; b=YJy2/zqDOEmwyGvZsAAtbK3WGa
	aNQEiDOZ+hs0RQSaTh5KSdk/poPYRuGgBG99XlVL8L9SUmVQYsTNXM5h72KSTqgni/Tp3FfsAPFKX
	MRIqxoOYPwzdhaHHreRD93c1sNki9O9W/dmtTnSom2lFwwcWqZSv9Hmhh04dZpT05tdlXImqpnVgK
	JUi5DudKXdzeeFtsnfOlfdjV3BuATsiPfazBRSpXy+Od5o4LPIs/Msums2I4skbE3eseJpo/mBo9A
	sGqF5UqLaM4dwF03zxP74EXi9vW1leg4Fy2ytY9t2C20Io2gJrqjzIhNCo6pFXdm3gsGVjV0cYzMj
	eaw5Bz4Q==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBoyS-00000006Ufw-49zC;
	Mon, 05 May 2025 06:06:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: remove the stream_status member from scsi_stream_status_header
Date: Mon,  5 May 2025 08:06:37 +0200
Message-ID: <20250505060640.3398500-1-hch@lst.de>
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
only cause problems.  Remove it and switch sd_is_perm_stream which is
the only place that currently uses it to use the scsi_stream_status
directly following it in the local buf structure.

Besides being a much better data structure design, this also avoids
a -Wflex-array-member-not-at-end warning.

Reported-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c         | 2 +-
 include/scsi/scsi_proto.h | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

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
index aeca37816506..f64385cde5b9 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -346,10 +346,9 @@ static_assert(sizeof(struct scsi_stream_status) == 8);
 
 /* GET STREAM STATUS parameter data */
 struct scsi_stream_status_header {
-	__be32 len;	/* length in bytes of stream_status[] array. */
+	__be32 len;	/* length in bytes of following payload */
 	u16 reserved;
 	__be16 number_of_open_streams;
-	DECLARE_FLEX_ARRAY(struct scsi_stream_status, stream_status);
 };
 
 static_assert(sizeof(struct scsi_stream_status_header) == 8);
-- 
2.47.2

