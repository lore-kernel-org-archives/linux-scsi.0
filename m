Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D0B1DE3B3
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 10:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730888614; cv=none; b=Hi8+Ek5uz3/AffEQE0om0cqC6gQvs4g+xFlhKxMdNl5OqeHLSUfCMI9DhA8D9whV3DOzsNTYoT5jBChiqEvAefYdDMR84aZeVSYxaAwZV0LvVpJbhoWLNrfjhRJiGJqzqW2iofeDV2ZyoI19siSg1w9Pfp1aj8rbplyHCiya/K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730888614; c=relaxed/simple;
	bh=hCAsFXe44seidFFgTgfHkUggtqNmCnRkdW9r+ujnpzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wwh0OCNmwdlIaMMGavr/Ysg8KGtj0gkDcEl7OKqIMz/ygDDGmykkC9JeIsq1NNQ/XcK2xtG9u3xExynBNXntjy7EMWtW3OY9zrSBU6olzU8huoZsdtONeFIMk7CmFuzEcpWc7B/XQa+8yTxrx2flYTNLQU1XWFOE2TZOma2ymVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=Uth4GZZG; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="Uth4GZZG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=WLlfNyTSmnGJ0DcbPPTnnBzsepmaQ5AHHyxtnSY/zMs=;
	b=Uth4GZZGU8FXSfzZL/QJ/uc9uyjhUAkjSkXKJDChBvmJd+Hp6f0x4y8XKxTC1WMZyaP4c+DUGfw/M
	 Yml2IgLe9Hguu9h2sBt2GuEfZ6XvFYOVdIfvugO4izDobti1iProNtQkW+0sdzNfYgqZeVfzeozCid
	 +4rWkNpr/IcpyLO5tbRWMUu/K4VxRI9giaGyoCxyGK+ubfdabCKml0EBWTYtwpYr9v3uwTjJhFvCHJ
	 gr/NM+z4BETmaaduflBKsz2VEoSFx4CNLXFmv1r4t2qqDI1ESNhQ7Blzh7dX766rPcB4uMDFc2KHE0
	 5aEwDpk1YbtP74SC2veQEzbl6ICArXg==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 2728102f-9c29-11ef-8872-005056bdd08f;
	Wed, 06 Nov 2024 12:23:23 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 3/3] scsi: st: New session only when Unit Attention for new tape
Date: Wed,  6 Nov 2024 12:23:16 +0200
Message-ID: <20241106102316.63462-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106095723.63254-4-Kai.Makisara@kolumbus.fi>
References: <20241106095723.63254-4-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently the code starts new tape session when any Unit Attention
(UA) is seen when opening the device. This leads to incorrectly
clearing pos_unknown when the UA is for reset. Set new session only
when the UA is for a new tape.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c9038284bc89..e8ef27d7ef61 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -991,7 +991,10 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 			scode = cmdstatp->sense_hdr.sense_key;
 
 			if (scode == UNIT_ATTENTION) { /* New media? */
-				new_session = 1;
+				if (cmdstatp->sense_hdr.asc == 0x28) { /* New media */
+					new_session = 1;
+					DEBC_printk(STp, "New tape session.");
+				}
 				if (attentions < MAX_ATTENTIONS) {
 					attentions++;
 					continue;
-- 
2.43.0

