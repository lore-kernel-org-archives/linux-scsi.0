Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007698;
	b=ZfsrcIcxJVtqgfY4an/YumRYi+3LtJVDEF2v0S7cKJXxk6F8fX7Ktc7QkJqyJ8giZqg1
	 tcLj+8PX83UhD8KXU0k0VO/XxHarmLdmCZ1HkFuj6V/reSvSwGGHSOqQl5T+qzzY9KWtC
	 vp7GmuOnRr3FscXGXdrcsCwGE5BxyfbAbdBgunfGVkz0nAlxLsslnQmE0IMV4/nBThN/r
	 R0rJBfuPzWODqYj5MVh6ZBnw/ZwmCTyOwV2WEy1TTc1wygnrtTjjZ62DMmL9dLeqwHuQx
	 /qKWjs4bwCmWzZIG61jZDIlwJpFLSFlAp5NWLGElAba7wWzEgskcNRW7keceIfSllhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007698;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=MFif6pDLzC32CKs5uzyVezp8Q0gm/lvoNpUChn18Rdw=;
	b=QV8voylUUQ7SPOu5AWAYym9fQI4OpT7Hg5r0rijxTC3pS4wkx2otEDfxcBnVWjh9+BO7
	 kQrtCLS07AUAIKFLYG+jeRCUuN3JHUv4zSqxO+0rxiZa8z2ylrQLXK3hO6EGY7UsYLQuY
	 HBL8rLCUPVL/PyLMU/EjjZ9QjEJOCXDcUyUvsvHyhzxqnfcOgkwa/6+KEWUYsZxoZPgiG
	 lGgRICBPgVOOB7kOpfvFPypmEDbKSx64PTsRaCS7CWodE1oeJMv5fvG2hoPad6ojCQLmr
	 bKGsbfzdv6DIgTko2b4vgVpMqY2A/LDkwX9vjbELFohLxYPdx85iV3BGfg9qIA3fcfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=J6nOd1+Z;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D00A606A338;
	Mon, 26 Oct 2026 09:41:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D00A606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=J6nOd1+Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=MF
	if6pDLzC32CKs5uzyVezp8Q0gm/lvoNpUChn18Rdw=; b=J6nOd1+Z87Xj4bknoT
	78Ixp8uuLzuZCt2rCzeYsrtTSka6eM9L+n5P7C6Mck/x2wVCX7DrQ6AwdUQsVHws
	KHAHzfsPbnoBf3srYzjFYBVHZYJ5f4Gps8TSx0k63hpcQ57UN8JX/L7AtcRn2afQ
	sszwA6Q9BIyX7jkFOrS5HTjtI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3HwD1H99qOWaGCg--.44051S2;
	Mon, 26 Oct 2026 17:40:06 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: x-professor@outlook.com
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] scsi: bsg: clear io_uring sense length on copy failure
Date: Mon, 26 Oct 2026 17:40:05 +0800
Message-Id: <20261026094005.1324014-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <43ee84525e456f95cc0efbb6b65c2074cc874e1e.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com> <43ee84525e456f95cc0efbb6b65c2074cc874e1e.1793003363.git.x-professor@outlook.com>
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
X-CM-TRANSID:_____wD3HwD1H99qOWaGCg--.44051S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUYv38DUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RaXKGrfH-ZwVwAA37

Hi Yingjie,

On Mon, 26 Oct 2026, Yingjie Wang wrote:
> This reporting error predates the request-lifetime changes and can be
> fixed independently.

6/6 drops sense_len_wr and rebuilds res2 with a zero sense length,
so this does not need to be a separate patch.

Thanks,
Yang Xiuwei

