Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794357466;
	b=Ae1TZj7z9ryl3Jf+RIOFOEr5b7jtmC8D3MTpQjO2MLgaf+Rqywx4NMxuP8ukyQnn0FOj
	 x8VHPQ9S8S+kflef3UyweBI9BVkCKjEAbrV5ICvtlUrSIDg3tdOtPP/G3FPDPDBtyc2tr
	 CzI/gHkXME4hdMjlWx2bpVk9XKkMW7v/QONDxPYmL8Vzml1cOf4fbWlLZ/EM5CJo/Oi4o
	 PR6qpu0sfFmkKdQvfAXNF2L2SeL+lGuH1WWqJZEd0QDZJJUH5O17JqpRYLgJ+zeWoNW59
	 /PQ1pG1X65mDkmFl10uTDCqheR/m0bxy6uxb+dGIxjjgSYXCAQnDFLAOWp3bclRNafA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794357466;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=HOhwJnDwMrJdnAxlnqa+1F3QjuwiESQoaDImj+ZrdAY=;
	b=Eqtm/M7jOdnbzzV7uwSz9VBvwm3eACtwZ9P+XIUJbn8RwxF6+/XlDLnQ0+YR4hY6AslC
	 bDhOzs55ST8F42fVoZaU6yI5hJmUm1sOuVB+rMDaqFJjXL9BilrqDURKcwLBmwHCXMEP1
	 b7HwnkLTV6sjUjQHb0NKvod9z3CTJpAUIhuXOqFDCjK4VDkfYB6TZFT7xpKQcc5uyyZsG
	 77HlWrZQokmgHFFkxauNY7hjzF3sp0/O0jhBuVtwQdL4PvtbBzBVQrHvz89lTGLuNjeuF
	 JjYOPJWnBLe712BtIJYIE1K/XGDJCSTHDBd+rQOdTqI1GvsgueXQYOsJK7/scgRySDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=NYIRMvdU;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B165606A31C;
	Wed, 11 Nov 2026 00:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B165606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=NYIRMvdU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=HO
	hwJnDwMrJdnAxlnqa+1F3QjuwiESQoaDImj+ZrdAY=; b=NYIRMvdUsZVfcgYHBl
	oY4XFk0yW28e0C6oBGA3yJEdEQTlRsretO5q1m7wq1u2d1/wb45VLjLWARPlEg+b
	lYYej574YyXxnRFt/ZhGv1IYsPdjD6NI7KjCssp9y2CYGcl+83pkp9dd0uBLT0ck
	yU6K5Pa0RFsi+t/+oxfcizzM0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3X6SnuPNqctCmGg--.61032S2;
	Wed, 11 Nov 2026 08:36:57 +0800 (CST)
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
Date: Wed, 11 Nov 2026 08:36:55 +0800
Message-Id: <20261111003655.3678579-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110122434.4144043-1-x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com> <a4ec8431c2f36172348449b872faf26d7d6d4d7a.1794045010.git.x-professor@outlook.com> <20261109025114.433681-1-yangxiuwei@kylinos.cn> <20261110122434.4144043-1-x-professor@outlook.com>
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
X-CM-TRANSID:_____wD3X6SnuPNqctCmGg--.61032S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUo38eUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QnvgGrzuKmiigAA3v

Hi Yingjie,

On Tue, 10 Nov 2026 at 12:24, Yingjie Wang wrote:
> Which object did you have in mind for the buffer? With 6/6, end-I/O
> frees the request, and the tag can be reused before task work copies
> the sense data.

Not the request or the tag. A buffer owned by bsg, freed from task
work after the copy. Per-file or per-queue both work.

> Queue depth alone also does not bound the number of completed
> commands waiting for task work once their tags have been released.

Agreed. If the pool is empty, return -EAGAIN. Do not sleep on it.

Thanks,
Yang Xiuwei

