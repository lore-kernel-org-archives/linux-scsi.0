Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419031DBB19
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 09:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887087; cv=none; b=hFEMTtzC6tv0f48MvykR7F8td8/NBeEmj2eRCZPE2xCt/FjFAvi/M48FXPlzdhY559Eg++xflDv+7JsNG7brl20nVLKGo9rzR0pqdSqehaaHVSkKnU7lYhl/ucRd2lh4I9J52FBlSz6mOtz7hgcKVE++zqQSvaM27hfGnBH7EEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887087; c=relaxed/simple;
	bh=l9wBaku2eNrhQlkCJ8tf1ggwj70zRo4TJotF5QWkE4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bbAYj9HVppFof2iX1ZaxHDrLsWmycQRpY0TVSIW6HLzLJOrvDOMJ1o0UWURa87IcPP7sBTITXdTJD4XaeE6fWS671rcrcFdldvFPxqKfW+Lr228ocvI4491YCFD5N7pyAvsHwTAwGcZaWZ/EhaD8ogbdGT+ubf4DTP4GH6fO22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=YdNm7XEP; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="YdNm7XEP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=QAZ4jadDKxvoZ1Vq/VK15yEjhsc69wrd6OeWg15VVDY=;
	b=YdNm7XEP/vRXBKGMJ+PmK4LQ1N7/3gtx9dQINNRhhSBtSq9twOfAwQ8DpTwbxxGbWttEPHtlAT4dy
	 oO6AmzdgXMl7HHzRVfH6hNC5LF6Zf9mo2w3gamvXUgwIw4P8TMtffkhUwQjT34aDMTkXb8LfD19xqu
	 ZF6EWU6C2tQLUSpY+/X7nLFwlaay5P6xUqyp8xc7XMsRFXCxEo0WzYnZV9IKCIcSEpNPvxxn6G+ln6
	 YO0tpbmCJTq78hdzHS3O9eqXQxlGGyH7b+23urN+g3iydxiUczc/9pHwiWCI5qVffdYmWZfP5+kjTD
	 P+T2fKpHRi0pSpH+3smrr3e7eYUoQjw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 9356e484-9c25-11ef-9ac8-005056bd6ce9;
	Wed, 06 Nov 2024 11:57:47 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 1/3] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  6 Nov 2024 11:57:21 +0200
Message-ID: <20241106095723.63254-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
References: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Struct mtget field mt_blkno -1 means it is unknown. Don't add anything
to it.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index beb88f25dbb9..8d27e6caf027 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3756,7 +3756,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		    ((STp->density << MT_ST_DENSITY_SHIFT) & MT_ST_DENSITY_MASK);
 		mt_status.mt_blkno = STps->drv_block;
 		mt_status.mt_fileno = STps->drv_file;
-		if (STp->block_size != 0) {
+		if (STp->block_size != 0 && mt_status.mt_blkno >= 0) {
 			if (STps->rw == ST_WRITING)
 				mt_status.mt_blkno +=
 				    (STp->buffer)->buffer_bytes / STp->block_size;
-- 
2.43.0

