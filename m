Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F9437FF56;
	Wed, 17 Jun 2026 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781721257; cv=none; b=FM+x54QSM1TErZ1cZi1cV3OOet+UdPtPDHhQ2Dmq4PkHJO5TajpZuVhEt/JJUnDISVHIKcH6Npp7CZtJaAdy97oaNI553EVktiwtxyuPD7QCOx+GAtxTC1s/x8igFkQo/kQ+Q9zFZhgA6NCfcLx4nOQSWUX+1XZB/O7JQX+rqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781721257; c=relaxed/simple;
	bh=kLXqLKOmJcb9gRtJ/zcWvvxqdEjaPDsWzi5ePHkWkis=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=G/3DLh0Pgs1vPNP1rga+UwLpWzBLt7vNsnNcNdgo6Cvz61MspYWS9tt/PnFtJ6IU3bpXjZJYB6kbWPk8hPrN6Hec7i9mJbLc98lKYJRgO1OBE1TdWlxKqf/I3t7hlt6yqUcLDXozCZhPcjgNr717SmoMCpKJmB4p2u2ZazTzg0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kn/nFdow; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kn/nFdow"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1781721252; x=1782326052; i=markus.elfring@web.de;
	bh=xuEzfovj3i18X8yRm1xhgHg9N8LGQZ5zlKbmPRRKq48=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kn/nFdow59Hdjls2dvNSnOqs5Nom5RKRqzcYsniFbzEkWV3V0oKq7YeUSszA9pkm
	 v6FlLjiyw0gU1hFYp1AyR2WwnuYH6mlgfzM7q5Ovpy9DV5zVACE8aFrFWQQZTnEjM
	 BnWE/CYllWaD6VCoje9z5bH1M5++c+NkxpWuz3ZXsIyqV6XVcNnVmZ7rA5YlvWgK6
	 1sqVhZL/gB3YCsS8NQ/QsYs96Yx29GnEGxmPlANUNqeTTB/o8vKMOGW/WRTjkzUl3
	 v17hJLjqPjHSV+BM07R1/O5NtyN/hCcZZLATh4ufebgYMfolBdAt3Lr/L5xzpfI1v
	 xpczhNOkOgyqeBLlbg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mrfou-1wwrpv3tjA-00eEYb; Wed, 17
 Jun 2026 20:34:11 +0200
Message-ID: <645f850d-bd48-4c72-97e4-5771e247de8f@web.de>
Date: Wed, 17 Jun 2026 20:34:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
 "Ewan D. Milne" <emilne@redhat.com>, Johannes Thumshirn
 <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, Tomas Henzl <thenzl@redhat.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Insu Yun <wuninsu@gmail.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] scsi: message: fusion: Use more common error handling code in
 mpt_attach()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EuxB213uooNPymCXAEk9hwmuljNX/GH8g3+254w+FrxqRufFrBu
 F51AiNTY/Lc+x9PMfc+xCB6s4zRWuUyMDSUZ94xxzptH1q/r/0Gadz1MFgTuTlYt10dsxNJ
 CBQia40H0lSiwUQlK2RVcT7nZZi4WRW0ZWSqkilbZpRG8dOCch4FMf/G/55Wq74eS3ceyFm
 0QqafiVA2LAFLRyO8nIpA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cPz53IFt96k=;R+bPX8QP/UTnq0Nv3zQyNNF9LDs
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 17 Jun 2026 20:22:26 +0200

Use an existing label once more so that a bit of exception handling can be
better reused at the end of this function implementation.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/message/fusion/mptbase.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mpt=
base.c
index 3a431ffd3e2e..c2c5a25cf5ae 100644
=2D-- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2014,9 +2014,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_de=
vice_id *id)
=20
 		destroy_workqueue(ioc->reset_work_q);
 		ioc->reset_work_q =3D NULL;
-
-		kfree(ioc);
-		return r;
+		goto out_free_ioc;
 	}
=20
 	/* call per device driver probe entry point */
=2D-=20
2.54.0

