Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDDE33C192;
	Sat, 25 Jul 2026 03:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784949921; cv=none; b=Qsoyo7PLUQQKb+ndRyUgZexm7DWp9wzUBbEe4s1Y1r2uhAEff4230RhXqI9HLR7kYbNJsZZ72cvi6+bRwKxyAO6jgYrm+s/Or5dFsrkPZnTEds6vjGGiR6EWyZ0r+AXsv4GUltjeoecRbSVzM/R7odxgZy9Rf3Ql0CBbO2uSS2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784949921; c=relaxed/simple;
	bh=ySt/Lp6Ys83W1xqSPfcXVIOAjTr2e+nreazIrDi536g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSf6nuv+EhQ8y+dkmE1pDbzIihVnLuB6XjUaM2DstCCqdP0fT040s3v5vrVUZytw3R15jDpsHbi7bX0jTGOprRK9S8auZVBauOskH5SpN/R+L2865WTuqSyp9mRFQMHzcQ8nUJ5oQovl43IYRjsWkve9EGIwI0syRaZAUuP864M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dr+Py+H9; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dr+Py+H9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=xEr91LuUOtQnvQ3IhQUaRuOwqOhTKwoFNBzLDV7oJDs=;
	b=dr+Py+H9Iwsfq+0tOMCIHI1x4X5JnOnvmAgp68t0b7ya4XqkM98OSxkdGpKO8E
	JBLjVpwIxLZiY5H8s9yByPZDChap2sQZ3SgFaXqsiN1ZtEXBJqwRSolGL33BTaqd
	C+LlxJBZNK5FMEw2EkdgKixz4x+aUvvsmWAG0m+4fT9AM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCHpeBbLGRqfkhsLw--.33591S2;
	Sat, 25 Jul 2026 11:24:12 +0800 (CST)
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
Date: Sat, 25 Jul 2026 11:24:11 +0800
Message-Id: <20260725032411.2786820-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CADUfDZp=pCYGY0TCnMxXPG3LR3Kwk3DB-Hq+EvHZshruX3pv5Q@mail.gmail.com>
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn> <20260720032338.461681-2-yangxiuwei@kylinos.cn> <CADUfDZpAW261MhFJg434=4nZFMD7mV=LL7F-ZiAWPa7dYvGpcQ@mail.gmail.com> <20260724004907.2742329-1-yangxiuwei@kylinos.cn> <CADUfDZpsTH7zU4gyVE11R9GxdadjbcrcGVX+btoEjRYS-tBiGQ@mail.gmail.com> <20260724020240.2938587-1-yangxiuwei@kylinos.cn> <CADUfDZp=pCYGY0TCnMxXPG3LR3Kwk3DB-Hq+EvHZshruX3pv5Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHpeBbLGRqfkhsLw--.33591S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4DJr15CFy8Gw1UCr1xZrb_yoW8Zw1kpF
	Wjq3WFgr4kZF47ArsFy3W8Za1FyF1aq343Wrs0qF17ArWDur1fCw1v93W0vFW3Zr4kK34r
	Zw4UGw1DA3W7X3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRcAw-UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RzVZmpkLFz1hQAA3I

Hi Caleb,

On Fri, Jul 24, 2026 at 08:43:42AM -0700, Caleb Sander Mateos wrote:
> On Thu, Jul 23, 2026 at 7:03 PM Yang Xiuwei <yangxiuwei@kylinos.cn> wrote:
> >
> > Hi Caleb,
> >
> > On Thu, Jul 23, 2026 at 06:10:27PM -0700, Caleb Sander Mateos wrote:
> > > On Thu, Jul 23, 2026 at 5:50 PM Yang Xiuwei <yangxiuwei@kylinos.cn> wrote:
> > > >
> > > > max_response_len is similar here: we clamp with
> > > > min(..., SCSI_SENSE_BUFFERSIZE), so it cannot overflow the sense
> > > > buffer. Same idea for response.
> > >
> > > I don't think that's true. Without READ_ONCE(), the compiler can
> > > assume no other thread will concurrently write cmd->max_response_len
> > > (else it would be UB). So it's allowed to load it multiple times:
> > > cmd->max_response_len ? min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE)
> > >                       : SCSI_SENSE_BUFFERSIZE
> > > becomes
> > > cmd->max_response_len ? (cmd->max_response_len < SCSI_SENSE_BUFFERSIZE ?
> > >                          cmd->max_response_len : SCSI_SENSE_BUFFERSIZE)
> > >                       : SCSI_SENSE_BUFFERSIZE
> > > And if cmd->max_response_len changes between the second and third
> > > loads, this could definitely evaluate to a value greater than
> > > SCSI_SENSE_BUFFERSIZE.
> >
> > IIUC Kernel min() is __careful_cmp() -> __careful_cmp_once(), which does:
> >
> >   auto ux = (x); auto uy = (y);
> >   (ux < uy) ? ux : uy;
> >
> > so cmd->max_response_len is only loaded once inside min(). The outer
> > ?: may load it again for the condition, but the value coming out of
> > min() should still be <= SCSI_SENSE_BUFFERSIZE. Did I get that right?
>
> Without READ_ONCE(), there is no requirement that
> cmd->max_response_len only be loaded once. The compiler is allowed to
> assume the value won't be modified concurrently by another thread
> (that would be a data race, undefined behavior). So it's free to
> combine or separate the loads. If you want to ensure that the value
> read from cmd->max_response_len is consistent, READ_ONCE() is
> required.

Right —  I'll add READ_ONCE() for max_response_len in the next revision.

Thanks,
Yang Xiuwei

