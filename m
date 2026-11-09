Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192725;
	b=ZKtB/hRRzZ5lqv00cgNwFcHdYVktO3ELWQFSKuz7B1rfIRbi4VDWttcet3qWL3nh/mKF
	 0cb9h7ao/kBF37yFHg2KZfjySdBltYPnDDm5dcwOhgCd8QmmyEADS8cm7pXGxXFDyO7h6
	 Fb/MAjgucmegrrQuf/YQNa2Si6XPUSmCq8c+e/5lNLYsAHTKb1QMa1kaztUpfEXdMdX6a
	 /8P5d19Qu/8HvpYiAQz7jBRftDHE9hcteRQuMsZ8sHX1QmKTrcLnAi4sj3YP9fxsK/Dv6
	 4MeETKXtf/fW9IGmlJUG5ddbHGKoztsUXzabR3bQ2pHuH/KPkUd6526ZwUwHjLBvU5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192725;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=0IVgJm9SwBtqm3JEH4p4DgqeS4PG7F4ayQmUO2+CLgM=;
	b=ONgTQcWk5acFEzmOIJKCELU9CxJ2dGQGc/Oyvb/LMUpbc1xGIZuKCS+ie0qnMP8ZUmji
	 4a5CMpHUECyuCKTSGdmfHRdnk9ds+wMre2Mr7unZ9/ZsTzvDsZiPNXu+N+jNEeNktNegg
	 KYftyFSoGKte23gna7WBoJB43jfexjfIss/vE3w9+D7BglQIIi4ScwpQt/uGegT9NbXXs
	 WeRiyRF4sfGv5uzm57uUsUTnXSb/jqTM0Slp/2kIBY4jFjBkV+DCz0NLfrU9nnSgbIlUp
	 15Z2Hxx77JYOwmPj8t7qXuR3YIROIIH6EGNO9kyc861xYkZzXH+oX276wV22Y33NFxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="hh/ehNtT";
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96BA606A325;
	Mon,  9 Nov 2026 02:52:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A96BA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=hh/ehNtT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=0I
	VgJm9SwBtqm3JEH4p4DgqeS4PG7F4ayQmUO2+CLgM=; b=hh/ehNtTirXnykZrAB
	F+Zj+3J3BVQ0bh/uAmJ7M9vNjUv/idcL4jYPwdmmgMi71gSgrdW0IbMXa4Jdp03M
	fYcbQ1Ie8RxklmVUHRhIFiiw7+KLx254o8Y6MaoKrvExXH/Yx3mOkXuUbrF57YER
	ZNqTnCC4saGC9xeZHwIuQ3FuI=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgCX2nMiNfFq6L9SEw--.17801S2;
	Mon, 09 Nov 2026 10:51:15 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: x-professor@outlook.com
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	axboe@kernel.dk,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	jthoughton@google.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/6] io_uring/cmd: allow reusing SQE storage for completion data
Date: Mon,  9 Nov 2026 10:51:14 +0800
Message-Id: <20261109025114.433681-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <a4ec8431c2f36172348449b872faf26d7d6d4d7a.1794045010.git.x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com> <a4ec8431c2f36172348449b872faf26d7d6d4d7a.1794045010.git.x-professor@outlook.com>
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
X-CM-TRANSID:PygvCgCX2nMiNfFq6L9SEw--.17801S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurW8KFyrCFyrJF1DWFW3Wrg_yoWxuFX_Cr
	Z8tr1xArW3G3Z3KwsxKFZavw4qgay5Cr1kW395ur9xX343uas5CryDJr4Fk3Waqa12qFs8
	Gr93Z34xJrnrGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUZ2-7UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QRt-WrxNSTgVgAA3B

Hi Yingjie,

On Sat, 7 Nov 2026 at 09:50, Yingjie Wang wrote:
> uring_cmd requests already allocate enough asynchronous state to hold a
> copied 128-byte SQE. Once a driver has consumed every SQE field and
> committed to asynchronous completion, that storage is no longer needed.

> Add a helper that transfers the storage to the driver until command
> completion without growing the request or adding an allocation.

io_async_cmd is io_uring's own async state. sqes[] is what
io_uring_cmd_sqe_copy() points ioucmd->sqe at. Giving that buffer to
scsi_bsg couples the driver to the io_uring layout and lifetime.

Preallocating the buffer in bsg itself may be a better fit.

Thanks,
Yang Xiuwei

