Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795485739;
	b=dosLihXIJIWE00eMTg/0llPUv2CWmDwS9m1A+xwvZmVOHL+R5+kC+uTte4VzJsxkqxsC
	 Clg/iFrqLC5Whzxx0Osr9pPkbqi+cRTpkHtuBbvjTSrxRt+1oq8SGGkgQep54opvFpnt0
	 0hkqj8Qum9d0ju2WmmnPSITKoZm903a7uTMNMAX1M4ZhyBQF2aETitfnOB8msaZ/4fnyH
	 rKnBdh3Nk+ANQEt2zkV0YiJh98U/NBdJDOoq7Btlu4dQfe84va4UNGG0NxdqiwGczqeMi
	 3R7uSMKsnh3dcZeqZOtZhAs94PzOBFbMd3gPMxBLegw1AN9JyOBeCQGsY8vt6BP3CFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795485739;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=B2HqxD6gMJA2qMiV5PK3moRBZbUYepj3nmGjNS+tWec=;
	b=GW682DO4XAtRq/iTdrSHc6+pSgeX6b67tNcDhQDpQ6OyAs+RgAk5WIVC1gXhdAsUS1+g
	 hS7Y1uSpRlsmg6b1eb7SCPqXdAiOgjvr44IrTG5sM6nqw4QNPvRo4dt6qnW1xyi5CSCbf
	 SFrF69hiEKeAnTAQywjZ7oZymKP0ycY8m4Rf+N5JT309/L4i9w7eBzqDfYSJh8CjYURty
	 /aEV/oHm3CYEnNDc1Aj5UGOitsPesXZMGAn1qY5ywl2hWXWzqpdMdUqhAXV+5SMU/4360
	 Hn9Ublxn2jqoR2qG5zqVjUkBKiflOTmUQXcigMwQDLIJEh7SqeGrJBJHbnN5kIc2tNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=YoMg4gtq;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBD3606A31E;
	Tue, 24 Nov 2026 02:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DBD3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=YoMg4gtq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=B2
	HqxD6gMJA2qMiV5PK3moRBZbUYepj3nmGjNS+tWec=; b=YoMg4gtq5gae4Enpjv
	EwsZeAbwD8vIuor3ivnq+p0F9DQov7s4eRWoEXaJtxVeTxA/ct6XINbR8LtqA4+r
	odjha+Z4JhomIY8kDTHgzNi8QKyDU+KAWg/yCtPjH3tliiLmX+hFBLjSwEImTPu6
	R+Mvg4PiJqGlwjG8TUVIitkUs=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3_7T07wRrdNz8JQ--.10039S2;
	Tue, 24 Nov 2026 10:01:25 +0800 (CST)
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
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] block: bsg: add a per-device pool of uring_cmd completion buffers
Date: Tue, 24 Nov 2026 10:01:24 +0800
Message-Id: <20261124020124.313203-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <scsi-pool-v5.1795249365940711260.1.x-professor@outlook.com>
References: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com> <scsi-pool-v5.1795249365940711260.1.x-professor@outlook.com>
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
X-CM-TRANSID:_____wD3_7T07wRrdNz8JQ--.10039S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUogAwDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RUVpWsE7-XQIwAA3K

Hi Yingjie,

On Sat, Nov 21, 2026, Yingjie Wang wrote:
> Allocate a pool when a bsg queue with a uring_cmd handler is registered,
> and free it when the bsg device is released.

Thanks for folding this into v5. Looks good to me.

