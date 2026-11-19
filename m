Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058404;
	b=OuSUNrr0z3Wz23Mulr5KjIjv6KZZy+Gj5WEL+9RyP2rDZChSbJg3ld91IN1pah/wDyYL
	 bPyLdLlL3IgYzZuRNTyFO6CZh9rzqzXaNYSYWKGKKTyFLNdgNzwWkJbfbNJEj0G0ClM66
	 kLja4ytVL/49jRqI2jsG8k4HxWVhiQFrkAer5KbB7bHcXNXOtylDrKobKIbitdrHkI3dy
	 HURVXgh/XG7DTGtORjGaD7H4RLP45qh9EEj+Sr8KBQx7p8tx7SiNsNY6zodNWKKi8rnDW
	 NH+p8Ab9bRjy0bZ0QlQcOnn0lFepRTA3/eh6VE/7TxmMnNXCJs3SgfkSgauEnAr/rgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058404;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=abw+fT+rPdNw5VBSp6Wc4U6gjP92lkC7zTwUaEj6Z5o=;
	b=Sa1oHFR32Ks9ZBbfsH9kC48/gpdD085Ax9E+XBljezeAWdPsxfjhHhjeIMe/QZqqyKgY
	 b/0HkhYbHoWeT/zKsppNnjyK06icQX4JGzIBmna1A0iB6XfGrZ8jCl6oN1Ssw6BXkEl0G
	 C+e73Ts6TANa/y8JBOq1O366WQxdPELnAGG4Son62V4xZUF+ArFixheqwzAzyPM5fASKr
	 jDq1nYdfurxN1FPFVQatucyYMMz+BUHxSt1Qo+9hBgaBPGqq4k1krxag5RBaXeH2szoam
	 dq2qL07A2wiseP3aKpMlqTshe7uiKv+UPQxVqqdkcAD/RjUh4tZrhXjPqOH8EzfQ/iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=N5tkAvKg;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A67606A320;
	Thu, 19 Nov 2026 03:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33A67606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=N5tkAvKg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ab
	w+fT+rPdNw5VBSp6Wc4U6gjP92lkC7zTwUaEj6Z5o=; b=N5tkAvKg+34KNFUMV9
	tH06GiqgIrCKWxLbbWW4YoDjhJQXAVUuQ5mOG2OHLY01wSVc4s0rE/pWMAKWPP5U
	iS8xDrc/0Nve9iqvAqaYhjlCNe6Gl8eH+EmFrnLR91SZMF127SnU+xCGrX1T5AbZ
	GCCtguxVF0LbgxuBKZmWK7o28=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDH7+Jfav5qLqoeJQ--.1940S2;
	Thu, 19 Nov 2026 11:17:52 +0800 (CST)
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
Subject: Re: [PATCH v4 0/2] scsi: bsg: release io_uring requests from end-I/O
Date: Thu, 19 Nov 2026 11:17:49 +0800
Message-Id: <20261119031751.3471968-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1795016239.git.x-professor@outlook.com>
References: <cover.1795016239.git.x-professor@outlook.com>
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
X-CM-TRANSID:_____wDH7+Jfav5qLqoeJQ--.1940S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr43uFWrGFy3KFWxCFykKrg_yoW3twc_ur
	Z3CryDWw18X3ZIvF43Cr1IvFWxJa1ruw1v9rs5Xr4UJFy3X3s5Aw1vvryYkr18twsYgF1D
	AwnrWw17J3WxtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUZa9DUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QENnWr+amEC5gAA3D

On Wed, Nov 18, 2026, Yingjie Wang wrote:
> I chose a per-file pool over a per-queue one so that one opener cannot
> exhaust the buffers available to other openers ...

Thanks for the rework. I prefer a few tweaks on the pool side, see the
two following patches:

1) Per-device pool at bsg_register_queue() when uring_cmd_fn is set,
   freed with the bsg device. Avoids open() cost for SG_IO-only
   openers and drops private_data + completion_buf_size. Shared
   -EAGAIN looks fine here; only response-bearing cmds take a slot.

2) free_top + stack and checked_out overlap. A bitmap alone is enough
   (find_first_zero_bit / __set_bit / __test_and_clear_bit). depth can
   just be BSG_DEFAULT_CMDS.

3) In end-I/O, if sense_len is 0, put the buffer immediately. No need
   to hold a slot until task work on the success path.

Thanks,
Yang Xiuwei

