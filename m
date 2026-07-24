Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F79E6BB5B;
	Fri, 24 Jul 2026 02:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784858623; cv=none; b=inwpUuXCW+IM9ZlLf4TQwcphcii3mUentDPmd00tWTqRJJGb3KLawj2qFxPIniUM3Mf/UrrKxt+v+YCU0j1wh/usIU2TQcDQlsQgJGY51hTk/FK8hNzKdU8FU7ha9vQQK7WZIGqRRuRj2Va7YwVcHB/Nd4zWOarTZtDbP/uSBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784858623; c=relaxed/simple;
	bh=jdWqFwfSOPXfLcOiX7Epjzyk3iiJwSWPzkW6gg+Myc8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UAw8mUBwcN2yZQKnpg9ZKvPLSciSpAf8iq3z/OC91hQFukiVHV+cHq34PLPEL03UyPl7ua3lgz9BtuLM9J093iUO9PcMCedkcrp1E/Oh9aiPs4EUdG99n3cXiFIwBBk38pWkwP6w1da22pZPPGZqveHKClB5OJEaBRScZ0dc1XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=O/SHLqjO; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="O/SHLqjO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=VPRMTKwe/wO2jvaTw6rpDeo3SwkBRfJm/PnHUEnX6YI=;
	b=O/SHLqjOuLUxBdqQWGSJBB/1iDp7FufeWmIgNBgBd8CT8hQ+GtFYIHjHWTLSOP
	alJx7tYvo41jlMG3beamaQQuPQvl4WHsdv42FghloQrGmsrgM/ZL77Up9o/6oCfg
	OXz7Eza/PhEdkOmJwLGVLryLSAHFDl0qqSiQmq9Bv5Z80=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDXnznAx2Jqz24sIw--.40933S2;
	Fri, 24 Jul 2026 10:02:42 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: csander@purestorage.com
Cc: James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com,
	rc@rexion.ai,
	axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
Date: Fri, 24 Jul 2026 10:02:40 +0800
Message-Id: <20260724020240.2938587-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CADUfDZpsTH7zU4gyVE11R9GxdadjbcrcGVX+btoEjRYS-tBiGQ@mail.gmail.com>
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn> <20260720032338.461681-2-yangxiuwei@kylinos.cn> <CADUfDZpAW261MhFJg434=4nZFMD7mV=LL7F-ZiAWPa7dYvGpcQ@mail.gmail.com> <20260724004907.2742329-1-yangxiuwei@kylinos.cn> <CADUfDZpsTH7zU4gyVE11R9GxdadjbcrcGVX+btoEjRYS-tBiGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDXnznAx2Jqz24sIw--.40933S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFyUKFykXF45uF13Xry5Jwb_yoW8Jw4fpF
	Wjqw1rX34kuF47JrsrAFy8Zr4FyF1aq343Wrn8XF1xArWUZr1fuw1v93W0vFWxWr4xX34r
	Zw4Uuw1UA3WxX37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRcdb5UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgJV5Wpix8LcIQAA3A

Hi Caleb,

On Thu, Jul 23, 2026 at 06:10:27PM -0700, Caleb Sander Mateos wrote:
> On Thu, Jul 23, 2026 at 5:50 PM Yang Xiuwei <yangxiuwei@kylinos.cn> wrote:
> >
> > max_response_len is similar here: we clamp with
> > min(..., SCSI_SENSE_BUFFERSIZE), so it cannot overflow the sense
> > buffer. Same idea for response.
>
> I don't think that's true. Without READ_ONCE(), the compiler can
> assume no other thread will concurrently write cmd->max_response_len
> (else it would be UB). So it's allowed to load it multiple times:
> cmd->max_response_len ? min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE)
>                       : SCSI_SENSE_BUFFERSIZE
> becomes
> cmd->max_response_len ? (cmd->max_response_len < SCSI_SENSE_BUFFERSIZE ?
>                          cmd->max_response_len : SCSI_SENSE_BUFFERSIZE)
>                       : SCSI_SENSE_BUFFERSIZE
> And if cmd->max_response_len changes between the second and third
> loads, this could definitely evaluate to a value greater than
> SCSI_SENSE_BUFFERSIZE.

IIUC Kernel min() is __careful_cmp() -> __careful_cmp_once(), which does:

  auto ux = (x); auto uy = (y);
  (ux < uy) ? ux : uy;

so cmd->max_response_len is only loaded once inside min(). The outer
?: may load it again for the condition, but the value coming out of
min() should still be <= SCSI_SENSE_BUFFERSIZE. Did I get that right?

Thanks,
Yang Xiuwei

