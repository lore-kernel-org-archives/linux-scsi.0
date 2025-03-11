Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FB5253F02
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741692377; cv=none; b=pgsu3iMULbhuRxEW64278WD/muqHB8hUwZNBeGuJHWFzkXmLnW5gtOAi1nXTXgeSGPPi9vUKOsg9dG2h8iSGJgi2yJwYuNJ/uI3iEfutNk0pJiVTJJ2PgCl8MIRzHSObglALveHkxUmpjEKJ1Vk1S9JdNFXTJ18Far8IBBbvTDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741692377; c=relaxed/simple;
	bh=78ZHj3yLl1oy/F9jK/z2kezFcMN4LUE76iLXRmvGxvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B5ZkOdqXgjK+j7FGBZsPSXw/ppB/6mnkxARN34A/dqCAHMwQkdT1RHBRjirCi4kOtt6+DMfxOTycGkIxuzV4Zl3OpumYQAgqX3F/3LoOO6i2nQHGPIVTmGJ4nojOLjKSrEWiJpTrqyKo7kbiVc/HKhCKbIvT1otyj5p1+lT2ZA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=NGARvuUw; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="NGARvuUw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=UNheqlC9IKNQaiZPET4tWiO8a/5Gz/uEgxbGFLepTuQ=;
	b=NGARvuUwbXZPXKU2iDoqjtY3wMSB1Y7THgzJt4vg/50M2vmsXzMP4ENCndPTcavy+nHprzsghgisP
	 z5oFlBWU8zN6y9hP1fcZDQ0Z0K2hX9+bo9Kld5ZXa8VaJcWNUCoZDj8p9btQkX+w/MvT/x2KkXH3PK
	 ruNiZL4EHqycOKVMUTRZxmwtKtmMEZIgRq/V25Nd/gGUWld1+PgBmqi+I/sy+sangf2Z6cYOHlnj8X
	 IWNRun0w9hkLxc/+jU9ojkz1KKzvOoDeV0+ZHjrlpKV2W7lSARKbjSQNrlEUaBaebAr7TxOjqJ1Sp9
	 0NkLXvZ8BWlGNvg7s4zaq8d8XkIBjfg==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id a171989c-fe6b-11ef-83bd-005056bdf889;
	Tue, 11 Mar 2025 13:26:09 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2/3] scsi: st: ERASE does not change tape location
Date: Tue, 11 Mar 2025 13:25:15 +0200
Message-ID: <20250311112516.5548-3-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
References: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SCSI ERASE command erases from the current position onwards.
Don't clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0d020cb1ffcd..55809f8a62d3 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2915,7 +2915,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.43.0

