Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061061;
	b=ScUSIwmGciIRwLl3YwnM+d3M+9+4zIEzKPGwZTD3BMK51FexodtuaF1AFjZQ54XggWre
	 BNttlKNCGbxEk1t2bTlZbudoERL775EZsy9ywWvX5veQLdrwwADApRdZAPHhqYnz3jSKT
	 nSJ58dy9HpLtVws7LY+qCigm1EhJldlbHPS0va6PxN7yqWm+GZPR6yvDD7dBTu7yWZxZa
	 NXkX7DAKSr9obELOnHhhggV14LP+TTBLfZUpsZv4WGTIMangNGkkZxrhOVzBYo+sp9qkq
	 VOBdUh/S1pRjCROPGAX8RNtGug/4DP4lf6BowIEirDgvdjKQxMWUI1RLjVea6CTBf/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061061;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=cQrq4eGPzaHQ9y1tM6q6POHLDfy8u+mRXlfZSjZNVPY=;
	b=0iwijcmqVFyfYTvENBKSN+2RVt38/w++nQuNAGd6cCmRNebSQfxkOZPvbhlyQH/VepV+
	 7T7ieGSQuhLfEga6LJj/yE+Q5SXs6TM/lwOWNBxJzd/p4nOVFOUlU/t7dKmrnzayVvqbJ
	 QkfHo41Kfh229OlEj1t/0EGLQWp+1CtDcAd6lr4vP/2vUPNF1qC47D61vPFtWGtzyfyEz
	 6oiX8TrztP+cMeiM1V06Mi0VMMRigoXml9Nn1Thf8ddwkUl4UenABbXvf0aAkfn4Rm1x0
	 2KYBFaDrgyDqpeTLa0Jbnvx0HwAcolyPTsDn2WVrrhMoPWQyZ8AouOdniDnpTEWaVIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Rlf6z3MZ;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75641606A332;
	Thu, 19 Nov 2026 04:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75641606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Rlf6z3MZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cQ
	rq4eGPzaHQ9y1tM6q6POHLDfy8u+mRXlfZSjZNVPY=; b=Rlf6z3MZsT4FdC49K1
	eH9817Qg0entCoUGMiaaET/Ljanz6ieNQ4R9go/x89yocoK+7UBNEt0fC7gZLsR2
	q4TDtxoI3Zrp9nSufTdXu7IxcGGTFUtKttU3+xutg2NC9u5uP706U+FTlsZRXfij
	M16i7L2qe7Ia0Qt1DDCtS4vgw=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDX3xPCdP5qPI14Ig--.40788S2;
	Thu, 19 Nov 2026 12:02:11 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	jthoughton@google.com,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 1/2] block: bsg: add a per-device pool of uring_cmd completion buffers
Date: Thu, 19 Nov 2026 12:02:10 +0800
Message-Id: <20261119040210.3585064-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261119031751.3471968-2-yangxiuwei@kylinos.cn>
References: <cover.1795016239.git.x-professor@outlook.com> <20261119031751.3471968-1-yangxiuwei@kylinos.cn> <20261119031751.3471968-2-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDX3xPCdP5qPI14Ig--.40788S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr43uFWrGFy3KFWxCFykKrg_yoW3urc_ur
	ZruFyDW34fZFs3tr4xKw1YgrWDAay8Xw109ayYvw4avrsxXFyrXwnFvr9Ikw4xGanYk3Zr
	Cryvvw48AF4rKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUZYFtUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QOnOGr+dMNldAAA3H

Hi Yingjie,

On Wed, Nov 18, 2026, Yingjie Wang wrote:
> I chose a per-file pool over a per-queue one so that one opener cannot
> exhaust the buffers available to other openers ...

One more note on that.

A per-device pool is enough here because only commands with a response
buffer take a slot, and end-I/O puts it back immediately when sense_len
is 0. The common success path does not pin buffers until task work, so
one opener is much less likely to hold the whole pool across a
DEFER_TASKRUN delay. If the pool is still empty, -EAGAIN is the same
contract either way; sharing BSG_DEFAULT_CMDS across openers looks
preferable to paying a pool on every open.

Also, pool->lock needs irqsave: early put from end-I/O can run in
hardirq/softirq, so plain spin_lock() can self-deadlock with get.

Thanks,
Yang Xiuwei

