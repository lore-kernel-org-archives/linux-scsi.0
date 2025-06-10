Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1125F223DC4;
	Tue, 10 Jun 2025 11:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749554393; cv=none; b=s/4oKYwKtIdmiEuOqOLayOR2WZ/u2eCu6uv/1wbjP2UiMVsrDS9g3ocuCSIpKT2W1Q4ArDy8YamIMQ1s1NS/xKgDRJOH089gvfdR+5/hGo0BdyOUyRS7vMSl/R0XnT7vFDYYgUBDk8uPDlND+DWX4olTmT01cH7w6yvgwI0kK28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749554393; c=relaxed/simple;
	bh=zHtajvWuHMuQcRL0ZxwAkuBW7Mrsb1my4mnRp+x/CrU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MjjE6w1oQmlPL8aU+6GgAMvuEDGf8pl3sgGuFn/9toBgdSjE9rIa71nSB05VrK9zkpnIm9OhoKNsBlBkR8nUr7Z0hMAIydcvQbyvpo0L9l1F8f+uemqsxWBLaiRTN/A8gdjZ2LLDeJ9C1IX8uw+N5pQ5jXH9XDyhxVfaliSxeJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=WHFBo0aA; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="WHFBo0aA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1749554389; x=1750159189; i=markus.elfring@web.de;
	bh=u9QxE558lvkkOQYH+uV3e94Awe9mUZUM75xTUQBPSOw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=WHFBo0aAupmhdc+VW0v5urjjbet5sJreXOLvIO6FtLImFCTVhKLa0gAAEyfIaRtm
	 TXpNFjHCs0vQHrNNWTdMAkBxGg0d9dmCpAg2LBa4qPZ30w74nA9EO615Xo8v3lDGR
	 3MEv1tCOO6dtjufgdApctforqGaNL1A8ZapKQ1gSbr1fOeC7ntro4X67LoZ1nPvfU
	 K5CaNvSB9VWrk/zqSzVggdMjvGKJkufuaJ9fHZ/gJ5h8ezlYiz0MFaAJCgthqODiN
	 EXzQQrlLAXM2BwL/cmbyPejiVWJa7kciVS69q49aLYi7byzwkJDDxDkS/w7m1arkG
	 QKGp1zigOGkEMMdSLQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.183]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MYu16-1uKdSO06ca-00O7lO; Tue, 10
 Jun 2025 13:13:16 +0200
Message-ID: <c578f363-8614-4295-b178-2800764565fa@web.de>
Date: Tue, 10 Jun 2025 13:13:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 James Smart <james.smart@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Ram Vegesna <ram.vegesna@broadcom.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] scsi: elx: efct: Delete an unnecessary check before kfree()
 in efct_hw_rx_post()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lvRqpHAmTyoVWba8qwp05HhtQEyy/6t64x7cWsWoxFcI3BKofFQ
 D5rXXuZKALg9XVKBVHj3XptS9B+zNxGvR3uf8OasIBzje6d0IuO8rD4P1GKKoF9ti97ptRS
 Bgb+bu32YdMuxzUWIKmj5qnXS+pDK06Qpn9cKq9V/Nbf0DBdxteS8udctUNRLY64l7b0fFe
 P8lniUnPnrthuSP5JoBtA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wrUusPyP7W8=;Ws/SCprNPZqV1+FwFn9JTy1ReqQ
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 10 Jun 2025 13:03:50 +0200

It can be known that the function =E2=80=9Ckfree=E2=80=9D performs a null =
pointer check
for its input parameter.
It is therefore not needed to repeat such a check before its call.

Thus remove a redundant pointer check.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/scsi/elx/efct/efct_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_=
hw.c
index 5a5525054d71..4ba1b12576c2 100644
=2D-- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1314,7 +1314,7 @@ efct_hw_rx_post(struct efct_hw *hw)
 			break;
 	}
=20
-	if (rc && hw->seq_pool)
+	if (rc)
 		kfree(hw->seq_pool);
=20
 	return rc;
=2D-=20
2.49.0

