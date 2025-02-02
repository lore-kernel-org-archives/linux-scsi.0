Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B838A39ACC;
	Sun,  2 Feb 2025 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738515289; cv=none; b=Kf0R8mNyJ0nFrzZXoTCSDg5Z+wBwwxvloBIX8lhvWkrsPIydQ1wFuRkzJK+0fvsJG9iw3IFiNpUA1rcskAKE/rQJgNk4fiJDJgRq4EsdsVUJNFSN3YkB6T2GVSn9AxsF/JQqlGCwuLCyj85aj57SL+xhzMcQhXX/hE/qbPQ4Jts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738515289; c=relaxed/simple;
	bh=gLhVX1h7o5b2X0O/q1MxHcPO1+3t+2qMA0H9XN9ZuU4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=GfmFfM/AgTMHFZbjxzOtOt7/gItkptPrniRX5hW/ya/C/hReHwcIqcvtPsjLRKZrwxZQdAdFxV3xcy53BmcjOpZ8oSYWFpidniUt7y/vRbKmz82sB5kh9gqpDBEqNwnNqtxe0VGl0ctwMSNG9wavtJ/OSR6lFK1Y1Z7E5vAdQZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Q6gm7Duv; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Q6gm7Duv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738515257; x=1739120057; i=markus.elfring@web.de;
	bh=EaVubEEvNOvGN37xb0CuX8ArlPrOSmXh5BFbwXCd1Qc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Q6gm7Duv//dv3DyOKCVGsbFsNXdvtXyIPCZllYO9rUASE6Fc5r41jP17cTaW5Gk7
	 DJWRWQSCfUqssulqJSpMmlnSXRclnOnlWaWeXOVvqS5lv0Qf7LR5v7jm8xA6l33a2
	 sCbc3xt2TNHAN3BExJksneVJzzmS2J7oEH0UoQ6OUJNKEda+l5JQyd/A+HJcRA8oU
	 CdIW78hTwd5I8nQIeqhy2/r/mAkkKFWEqeOoEh6G7g+crAZ4Vt4zBcm7mTi1RCb7l
	 PiSBze1Rkk5+E4gRyxK/Q/J4fpZWZahEs8x4LtTQrzna13SksWruAt1l0RyzuAMad
	 pAkIiDxjplT3kiLX+Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.26]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MnFyI-1tCxyu44JQ-00i80V; Sun, 02
 Feb 2025 17:54:17 +0100
Message-ID: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
Date: Sun, 2 Feb 2025 17:54:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, linux-scsi@vger.kernel.org,
 GR-QLogic-Storage-Upstream@marvell.com,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Javed Hasan <jhasan@marvell.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Saurav Kashyap <skashyap@marvell.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arun Easi <arun.easi@cavium.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Manish Rangankar <manish.rangankar@cavium.com>,
 Nilesh Javali <nilesh.javali@cavium.com>
References: <20250131213516.7750-1-jiashengjiangcool@gmail.com>
Subject: Re: [PATCH v2] scsi: qedf: Use kcalloc() and add check for bdt_info
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250131213516.7750-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uxMvvBffVAsVai5iEdV1YM2XUA4IjftiSmC3xP/AA6I1nRGFSFn
 Djkr2aXLj/IqAxaavQpqYaAmFeYWSD53N7kwBedspKSUNT9MLAp0qlS9HARhCj+SJmrDoW9
 rAOHPKqLhE+rdIA+gYhfLbEK9+5lheRWMSyTFMTeWRg9D6ChHdK+zI7USS8nn88bx+WcDUR
 YZGhVApikY+e8RGBsN0zg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dTq8ydIxLnI=;+Be+5z4UYFTNXc92GYHZXVroZ6t
 Z1O8r+rbmPqsMi9H9hKEF5py9zcn4ABgbGyvxlkFYbjhnYU/s3zHFuaMCpjl0ibhiHE7mjQ7f
 /9giRB+oBsWZhAufgDrkCnehyXSgs9jzWPrGt2LCBRNGRDYzOMODCIajm3tmZky9fgfxIckIA
 c3oNOtL5s+abSm25rpPV6CZPYisbgyH5l4P7vN79QF0mHlMrYiazEcTVJ3b4j1Aq4IPLivUHI
 DC9P7vkrS9vK1f+6f3Tfmx1v/TYrRaveQLBEyg1906/UzTTWuL/FHRvLYqqYgH7Bvvl7AbVCl
 m942kJM3kvutcnawn1VNMrHNJrzpccD84mHw2BvbbHWyHKO3RrD/z8Y/Iy/cYdPpup58aHaiV
 1spDslKB6BEXNBGdaUx2hDJqJf6ONcqztPwPvwbL/LW8PqguD3aGErGcRIVusK/eBe+kjRo+e
 /tVh7MOuHKS9wnZq+lypw84ezGxGH1QNDYY2yOc0OFxetm1/X92hjWKixuDvgr19s/BuJ0jqa
 0mjEghEyoWdf2oOPutWaje/FAnfiHxAljOBng2RjNTuJSyNVgfrPPr0+djfFWR1S/ubhMG00W
 mTlm7CUybKJmYXxRvLIAIwCeUFuVfhJZapPAInPWfj76GbdHDkBRKvz+lhQusLMIbh+2Pfqpu
 Xkz7XoY8gXFhkjF9BLXziZr6lpBvPno851BQpWiri30Kw5RJGIXV4+q86RyaLx8nfYKXok+c4
 L1VlykkIkfIH7+F0CWcAzC/8cXP7IefNFB+/uF3S1U+ktNxgl3sRJ6JXSJoGQUd4uXLr2aMx2
 5Ny5fzqmMm7sKCh6uzBs0AYwgulwZRSEbhjGNwrQU2SuAsg8n/m/Eh2+ZSYQfYvmXLCU2u2WG
 dTIejTQxP9K7Buc0PVx4Oa0zoeeGkcIWEx2Quf+To199KRr1ApCPDLFanh21d6biTTp7O4K1F
 qZYsIdn+8SVrWaZzVt5c//sHf3E34wGwHViBIn3D5vx3hzL8P2HrsLKQ05B5wh/iLgVYirjik
 tj7XEQW1uO2uVPqZSoY5le0enc0nWEBg+4V3RY4GKFkm+IATI73qXCi4qf788w5Ty8Pve14Jo
 NOOHHwYOI8Dv13d8aTrch25EBsP6u3JjftwgQs8DVPgK8TuchCU4HkOUSqllYyJvVIo0BWDPT
 wJZLQXjmKPmRrOihC9s8ASv4wZqaNUx3nRSFDok4FuoRXuGQW0GD/ffp9exLFGlr4HowF18d5
 h/RJSDNFzjscQ1mv++1UnmF6LPlRNeWLll4iIWbhri2QZUA9ThhIDzZ5TlTJxv/PDMuKZeOJh
 4PRZxQbT0XeClNBRZ/rToj5u7xyqPTdOcyrgJ0c0Labj62WW/8wETeUwjT0cFM7bK2A

=E2=80=A6
> +++ b/drivers/scsi/qedf/qedf_io.c
=E2=80=A6
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ct=
x *qedf)
 	}

 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
=E2=80=A6
+	cmgr->io_bdt_pool =3D kcalloc(num_ios, sizeof(struct io_bdt *), GFP_KERN=
EL);
=E2=80=A6

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.13#n941

Regards,
Markus
