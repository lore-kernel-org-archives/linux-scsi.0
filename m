Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A171BD508
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730719622; cv=none; b=Bdx8LrEN1dEthmn2R8pq/W7DhUQv8O5/Qe4dw1bwycy4sDee6IaITiOHEeOYBdjSpRXS/UE9jCB9FqAX52PJ15vYuuKtPywvrNshcu0XjyR3Y7vRmXoiB/FgcYLcDgwTMjOETZV+5Waz3YPU2DhYkSkA84hAp5UKdv6bQAH8+OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730719622; c=relaxed/simple;
	bh=qNzIxubdyAACSSilP/41diGh8Aysnz2bQLFS4wC42WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9Xc2KWQiXDCag+NXRrycMILgIoR3qvz+f+pPErvA19rC7UeLZ965GzmdFLM5vXbJBgvjQ2Nev52QmDRhQzGTqrYJd6eHXZb/0C3+Jbbntu1Z+0fcTsvydadV59Sg3CkrCXTElrf2F/k16UAAYg99ZGOt4ZySBmsKPW/teybiX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=Yh+yoosl; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="Yh+yoosl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=zizDeVnse5oSJr33n52Uku2c2fducfcyOLo7vJwdlL4=;
	b=Yh+yoosl87Aa08pmZkwfGxUEnUpwiA4PQmLV9OKsEdjyMBYyq4hTmfJa1yzgT2QC/KSrH7/lZTG5d
	 iAZlSa0Bo0uKFwqo1TNgwWuI0qi2pID2IS6WnyLUa4uOMmgwL8vMcZSvRdbfGWGSLi0YIBxqYARFbT
	 pKPisijgcoIXA3Ntw2ambAqHh0B+1+nAyU7ttEfGzHON+wca2Q8ZlSavC2bSYqz3xvpxnL/chrtRc7
	 1CjrV/YmmFJsNIo9SFFMLWfwNaexYII29R7YuFfodN3nxdJf7UH58+p+0/wL7WckiMzvPJNYBk1O9C
	 QXpGTmZYrPS6kENXTFwErNBAlGx6wyA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id b255fdd0-9a9f-11ef-8872-005056bdd08f;
	Mon, 04 Nov 2024 13:26:55 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 1/2] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Mon,  4 Nov 2024 13:26:22 +0200
Message-ID: <20241104112623.2675-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
References: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Struct mtget field mt_blkno -1 means it is unknown. Don't add anything to
it.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
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

