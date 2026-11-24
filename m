Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795485551;
	b=M5aYI3QL2sVRguxEuLXYrUsvU1WFRowXicCkfnEe/SahqHpOYSKSJki79iErkmkc2t5E
	 BffKIDjAuK3jmoQbv1H0C69eMI0bAbKlpp4W5hED9i2mBmj0DTLhCEPQQsOIt6jbqYwFK
	 GtR2FMFtTI3Cw9ESFFNKacwKr125vW+w6oyCa4dHf5SxMIcc4tF7jCqTFPKW9WOLRLQ6d
	 gzo0/GxQ9M48oXBmo1zPhxXtGSXfDpIb/lqxwsy55UBiedfRHJw48VtRbv+Mml4oiA2e5
	 Zo7WK9F3o4xnengGeO1W8rMZGM/V36UIa1FGPuSiIDPd4/sR/azMnPk2xIAj+32YNwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795485551;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=kt9+HMGbhuf4JXlIYwAKYBroCyqlzdBSipAe8z207t4=;
	b=v+l6J6pK9Om23s8IH5X/WFzwpvpB1GcjA5jFTESu55ue7GmfSvrhOdimneHfjTZWJ5wL
	 IaBlaF2ZRpaEHoS8x977zRoRLf/qY6V3MlaquFByJTyRmp7EGHkyh14x/hvOa7UgWFwnA
	 xVSWHBSRCD//KZTJ75gnNU+HvI5Y4A9IDTa708+xHMIT6nhZ96ERwuwvXdTYEaH7niDny
	 YBHK/ARzuQtQz+CJ8x0qJXmAK7K1fusBHmK6QI1h2WYF6Q2a9SOYAPRplRzCt21RBRheZ
	 esNxComUA5bL6tYs9vne+LmuQQFqJZXc/qOjkosrm3VWPdsd+Dyf8ROaS46UVZB+vlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mfFHN9bG;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45C1606A31E;
	Tue, 24 Nov 2026 01:59:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E45C1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mfFHN9bG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=kt
	9+HMGbhuf4JXlIYwAKYBroCyqlzdBSipAe8z207t4=; b=mfFHN9bGCm+6GY9dmJ
	z+6A0bszuubXxdTUlNExtzmPQ7kcp7U1x3uCh4FO/RYWZhNP+ly9GMvyJzbUcm4B
	S3JyEew6qyJRRhKKlcnreuY1PQfPcZg9Z/4HkDCqnVUMIY8I+W+mnrb59oyZRT5G
	md2ur8nKVieuZ7nubl+H5t0uo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD30w857wRruvUZJw--.28654S2;
	Tue, 24 Nov 2026 09:58:18 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	James.Bottomley@HansenPartnership.com,
	Bart Van Assche <bvanassche@acm.org>,
	James Houghton <jthoughton@google.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v5 2/2] scsi: bsg: Release io_uring requests from end-I/O
Date: Tue, 24 Nov 2026 09:58:15 +0800
Message-Id: <20261124015815.303492-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <scsi-pool-v5.1795249365940711260.2.x-professor@outlook.com>
References: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com> <scsi-pool-v5.1795249365940711260.2.x-professor@outlook.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD30w857wRruvUZJw--.28654S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUoVbkDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hrldmsE7zpBSAAA3Q

Hi Yingjie,

On Sat, Nov 21, 2026, Yingjie Wang wrote:
> Return the slot in end-I/O when no sense data needs copying, allowing
> successful commands to release it without waiting for task work.

Looks good to me.

Reviewed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

