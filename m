Received: from outbound.qs.icloud.com (qs-2003b-snip4-1.eps.apple.com [57.103.86.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC3337F33E
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 19:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786564108; cv=none; b=KlLPFEJWbi2DSR7i8YJq0TbRh8qXmFjON/epcTn4hzdTZgROf5qVKGUmBFzAAOAdM/VDWftE26/6EZ/QT7N/PFBntSpaDjNI0f5AUkVPI19w/qenqi+u0HyO3Pv7IalKSB91vYyP/3rsSmQpFD3SKgEJF+8/s+CcU6UQmOOPodg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786564108; c=relaxed/simple;
	bh=msfsr2Xu4psqQUI+7pT7TT5XZjVqtJFSnYd7f+QEUAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jFEAuM+OhaE+8cw/D2yHg2vRVeWRo+m8j7uE6W372IgN2Pd7CWRNsE2dFDfESpyWQEbwQOBcKFCCrfy99iIl91DzuLde734t9hXCLbqfwH8C3fSF5ZaOOpBX/mAwOg4jcYFFeEvALlUF8Z+p9HCmY9+rR7INVbOet8uJ18onbII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=dqoU09tv; arc=none smtp.client-ip=57.103.86.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="dqoU09tv"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPS id DBF081800335;
	Wed, 12 Aug 2026 19:48:23 +0000 (UTC)
X-ICL-RepId: 019ff784-ce8e-787f-8e95-66d7b7a42d6c
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkgLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBC0kKWQ9bCl4MTwVYD10fQRQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786564105; x=1789156105; bh=vN7GiDpcgSBRtZsQIVeZ+YPpnWj7rPElkOOQH8pZbNo=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=dqoU09tvcAY9yhyZaeEiMixjRRU/+T2j4COF7LTsbkVvIo9OJ7UK5p5GX9gLEhOAAUE2nFLgeomGWjRxuJHIJ0cWWeaeF+gtaqx79KhKFloZcpELz5Gsm/WGT6U6K+DZYSCT2GqgKuGiRa/w3MBoztNNtEA+4+K2TC+ZlS7om7ZabHNWyDh0MRIuav4FTbKilx1AP2Cjk3BD6+lhoevcORo0YNOuyptrcF+a9MR97sWj4MfszpP922q8W/sFE3QTCr2QI/UT+7mxsL9i3ZgU8zVHVKCOeUFzM2wDGr5WpBPZnYwFt8dEnZ6lB1sk0nbcX8jEn+RfGG/PwNpJm4w4LA==
Received: from machine (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPSA id BFDE31800321;
	Wed, 12 Aug 2026 19:48:22 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v3 0/3] scsi: libsas: Handle errors in 3 functions
Date: Wed, 12 Aug 2026 14:48:05 -0500
Message-ID: <20260812194808.576586-1-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 9dAtaLMEs0UbChnC7ccmCdP6lXaTIo2k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDE1OSBTYWx0ZWRfXwXA1mJCu8Oe7
 KuTQLH1rxXphfRyhBH0XMPTqdjR/2frIRJSeUozlzh1fa3L/N1cttWC2lA/xEfgANTeDH6FWjEb
 /O+3YNgoR5oKIIO7ASjoStJwiYqx7rvKrbUVUt47gnF3MIsjUv7FqPHCklLQNXUs+LWYdPTAMXS
 o5n5wcHiVsE/ZMTCtGEMnbKOC4rCbda6EF4F6vW3nBUP7lzPo3pGdDr2yhrkyHVPQDd1UJZhFT8
 CB/J/rirGLxGhz7HeOUn9kOgoWySSIg7/0pWQN0ZaWwMTvBOdITCxheckjv7crO3ZcAhkNco0nc
 1p1IVqhL3k63iXjJhGO7rfBUCKHQK5fQ+Q7S0A89fFiKb3YgTfPTW9GGzS9yvU=
X-Proofpoint-ORIG-GUID: 9dAtaLMEs0UbChnC7ccmCdP6lXaTIo2k
X-Authority-Info-Out: v=2.4 cv=LZExKzfi c=1 sm=1 tr=0 ts=6a7cce08
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=p5nTp-o6oSFkd0WaucIA:9
X-JNJ: AAAAAAABsSUno0SwCX4JY3mnEzo0f09hFO1yCsSOKqttzlAIO1NlqUhPpxYy8cFFi9mx0RxH06x5/XHZppdTtGJ6EU9HEAjelTTkmMeUPXuaIcOO6CNNFXJzsO+SkWVWAhS98RXuUjgGqGpObS+NgEVOnGljJvQfyAFrCvSj8x9vQ5zcxLJtlc6/nKDpzT1mr+RXWABnQf2wy9rOio0M63oJObZXCCI2tGi8m1mwmknx3z2zP9wfkXd6SBC/pf24GIXD9ZOAp87t8h+RRNG6L/LInsvuIgPqhHMAE+EgpEVWj2dfK0GxIkANTOFhSO9ymRXt5fUxwG3T3xAJyUFj+iTR/NUNrs/ch3GdNvnUOBsqyb/B2Lp2d+lFsl0LBhzGkYxAM4Vke6FHrWNZmZVB8WSqeJeZ5bx1D1sO5jodjk7P49yIYsMdJk+DUfZE3vSZ4KhlGiDMObPpRtyP1Vo+HllRr3tuyux0DFb+epNk8VQ48a43NHmSy6HTOygvYqmjegyY2OAJFWUg5qGOGNmd9UONjkOap0XUAkDf23Nc8ENpXCCriyQ+jmkt0+f496qUgq5zikPTLs2Dx7j/xX8keih7ZciDwlomDdVpO/UVLLCLxdPee+vFLB7z3h5oNnDMl4/OmyWcz6vpG4JlIxnt/95f2tRSpkd3PfN1UFVTbG4KKW+Obq4FFR17heiSwP4dfhs/Pf5Tfud3m1tZwxwW3ahmLQ2ucvjR2ReD4xukLklsAUvVIXaJG6PVHeO4nogGPTvBuWoPpimjGh+04ibRstektEM5Xpq5HrJCEFFq7ZmM6hzPUQJ5dECKYyi/I9SlCQwxYLY1W59SgT94aUhrJJT/io7H9NwjNSr2Nffjas7guu1SutXuVV84Hb0rfLVy2IbVI6Gaw2XUkVFqj2pFatV7fJ023S+vm/8uqAxl/f6ND9XkHjSeBO2dp5Ya3uW/ExdA3lYcRhQHB+GRSHOMjfekGSG8eWl
 qTmcpsSLvwClOYYAXWviM9rE9hXfSEQx/nUbHYC41TQtl9CGvriub1pTICMy6KUTgOrCvicp77kCQ/T2aLwMY2KUI+AUoT1k3pDy7RykG3Yhu67IWOollsbnHz0LgW1U0l2OtRwKKtQV9Qvzea7S0nF/s9EZvqb+9cW1+YaYg8W/3K9W55ksmGpiO2AuHChZcNv7ons1n+3ra+mgr23+x4kpowqpTeL12pRoVI0MPRByONYhPDehLaT+qVqOSr7WAXlnSzgB8Auf1wgMus6xVx2eG2Rvk

These 3 functions include several uses of BUG_ON() and lack error
management. Change all 3 functions to handle their errors in better
ways.

Eshaan Deshmukh (3):
  scsi: libsas: Handle errors in sas_ex_add_parent_port()
  scsi: libsas: Handle errors in sas_set_ex_phy()
  scsi: libsas: Handle errors in  sas_ex_discover_expander()

 drivers/scsi/libsas/sas_expander.c | 99 ++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 34 deletions(-)

-- 
2.55.0

