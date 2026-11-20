Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795141015;
	b=w5B2GGZqKgrTkfUT2Td6RzucVrmFMsFlnFSDX6UTDCvIVOFJuN0h3EvWaIKZ9TJte2qC
	 Z08uuRK09n56NPYzmb58gArBCojMgPNE12zXVI4NPMw+0sKemc84sErL3Nk6s/VaUQ6XN
	 mq9NcVjiVIbj4X6dPVWPd9bZRAzhIRfS7A4jSGW4hsZwh12rczsCk32bXdfrPPUTjhwIf
	 HbqvCW+rHjXcpKGoQGCfHYdDMmOU8ilSMlCxsdYRmnwlwxkeHrpHfsL+p7JAtAdvUb0dz
	 A3pR7nfJwklztIbj87x6FNemp6+aL3uDE49o80aQkyaFRl2Thzlk+BAev2El5xm0rgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795141015;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=rNSiCXdLtCLt0fmr896KLqf4BIh/6zakbDyHzT79/yw=;
	b=z9hZm5RUhikfxHxX9aCriA5zyr4SJpt2B0lhG3NeL7r6hhprPSf7/oWG2KurzTlKb4sH
	 nKtNEQmC0s9OKmHQHaeU+03jqj4GW9QL5ZUd47CY+7hiYFNja+ibofBODx2mwyAiSpLO6
	 tSDVq7gMmaWRKU3FPMfTSNJbpqE6jTEfTjCUHPhdeMuzL13wG6QyHioww/xyl2sbhQBTQ
	 u1J2QACIengT5oNpf2vr3EElTezQICf4hFV3tmyaYulRbOmxEXM4Mw7bmq0MceFjaC/qK
	 QuD58NHh+euNZuRQffkNWWBwIGdZZhcvCsB7HQWLqVdzf8UkqI6UP7jnO32RqxLpf8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=CQyMd9Ez;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB780606A320;
	Fri, 20 Nov 2026 02:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB780606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=CQyMd9Ez
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rN
	SiCXdLtCLt0fmr896KLqf4BIh/6zakbDyHzT79/yw=; b=CQyMd9Ez361sOAs0rz
	SR9d8D8eNA6IjXS5M/MvkYIfoI7Kep6GXicz8dcZ/pxIuvXR473PCQ9M5LkjOIxv
	N93W5aQj8kBrI48MyHaR9bh0JhlzB9DkuPwAKEc3gZtQWozhbPkWzoLTmIlOFdDK
	hvoZ9Gl1ZKm7NErVygPXkRjNY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wBXXpdkrf9q7GjRIA--.51558S2;
	Fri, 20 Nov 2026 10:16:05 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	jthoughton@google.com,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/2] scsi: bsg: release io_uring requests from end-I/O
Date: Fri, 20 Nov 2026 10:16:04 +0800
Message-Id: <20261120021604.2648220-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261119152529.2431724-1-x-professor@outlook.com>
References: <cover.1795016239.git.x-professor@outlook.com> <20261119031751.3471968-1-yangxiuwei@kylinos.cn> <20261119152529.2431724-1-x-professor@outlook.com>
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
X-CM-TRANSID:_____wBXXpdkrf9q7GjRIA--.51558S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFW5GrWkXFyUAryUAw15CFg_yoWfZrg_uw
	1ktrZrA3Z8Ja4Syw4IgFy3Wan2gw48C34q9ryFqrZxArn3A3y8C34vyryavryrGa92k3Zx
	X3sxAFW2krn7ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUZa9DUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gUfr2r-rWWIEgAA3Y

Hi Yingjie,

On Thu, Nov 19, 2026, Yingjie Wang wrote:
> I'll fold all three into v5 and rerun the tests, with lockdep enabled
> for the end-I/O put. Since patch 1 will mostly be your code, I'll add
> Co-developed-by and keep your Signed-off-by from your posting.

Sounds good, thanks. A couple more small things for the pool while you
are at it, if you like:

1) DECLARE_BITMAP(checked_out, BSG_DEFAULT_CMDS) is enough - no need
   for a separate bitmap allocation.

2) Depth and slot size are fixed, so you can drop buf_size and just put
   u8 bufs[] at the end of the struct, with one kzalloc via
   struct_size().

3) The WARN_ON_ONCE on get(len) and put(!buf / bad index) feel a bit
   heavy for ordinary failure paths; a quiet NULL / return is fine.
   Keeping the double-put WARN and the !bitmap_empty() check on free
   looks right to me.

4) A few of the comments look a bit long and could be trimmed.

Looking forward to v5.

Thanks,
Yang Xiuwei

