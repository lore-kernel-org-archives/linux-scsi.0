Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C21A3A7F78
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 03:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787888041; cv=pass; b=bcTbQDWuaFBShFuv7Bj7/i6Aflu9jYDXZk6Wc2JoK8GAtcs+fYtEjiWymJNj/CtukCrGvnZd2qOs/NxVHxeZbTnEDZjlRgYfY9qoMG8oUXOkYs0ZCUPM6jqRfiGBVCcRfjZvskcu16Cc7aQC9VQOVQgnpLJ0jRTNvguUy+5RsZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787888041; c=relaxed/simple;
	bh=eVCUgnuZPY9rp4G0hxfWBoh/8wdCFKKRU8Eq9Q7yXbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PBGf3o9+i0YMtxIBw9Axi073+IgZpGtKBYGgIChwL+TYETV9J59S3F4eVs5L3L4HfkYnM0MnMM2nRg1hEJuh++lBPbd7AwsuYuKqueAVqVciK0ihPjEKxmwRM9AzjMysO9j42Xul7q8izUOpVAk7lcaPO7Up9VUNB59//uJF5Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qoJ0brIm; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qoJ0brIm"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f4f824de5dso151188a34.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 20:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787888039; cv=none;
        d=google.com; s=arc-20260327;
        b=LTFOETzC0yySMhkVxGQ91xwBXIfbpA+okpBDa6gEiNhDlrCVaZy9F7Ot0wJ15/7jPw
         TisQluLuMOKAzoOfchnLmDxEQ/UdgkKbpf1LYKYY6k7vCY2hMNSkcgq/DSjlrly8LS5c
         UfWoM1rPkHxFDXa827XqztsoRuJTAgLpfOTd5AgAfFfKcjk5xgS1O1MLGZCXzdp0rNqd
         +hIjTQiTWQGJQs3RK9QzBC8b/sx/TzUwVpc6ImerTX43uxl2NhL4zvIhnNvSEMYGOkFH
         bXor4J/rk9FF22nespTd94vp/DhMfbFE0j6uMtSjv8uX1W+lfAmi38QpZTS6S/ccEFt/
         OLTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tJ6GRA/2LwQW6/jDEIjrj/TZS2ZKHOJ3XYsZbyYACDw=;
        fh=CW9X3CPgER36fz0Eds3JMg7O8dSMo1nMwOYdN0zulKY=;
        b=I3Tvqw7rL909EVHezoMOto9npZwqJ74y8ZT3jxfyGqgcbTLQwmNGuonHcCIe3efsVe
         3BWHOYanNlQ8li4MfnyrPQ5bp6jkuBEb1o6caNcsvpB+leiYJQNPhUnB7LemQDkN48S2
         ipGw+oa2NpY2myQsAfMtikAzwtgZkgAhmvSUTtbre55F3ASCx8gNO35c6E7TWmHiIl1r
         10VwvqDT5GrGuUKt0PMPeMrAfcIdsjtyzXJmUomG3hw1fDxh5bvugxykG7OmOu5OK85P
         +kMNNH3BH5O18BzWYyApTp1R81mBQ7QOZqdP+2YB2UlcsBMbDaLs4+fCobiDyMoX+0mq
         pF5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787888039; x=1788492839; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tJ6GRA/2LwQW6/jDEIjrj/TZS2ZKHOJ3XYsZbyYACDw=;
        b=qoJ0brImXYW2jxuJ/+X9STf16jjXZ92rLmZ4786e6MVSpMWvhHnkJ14DzuZd++/cjq
         iXnv5vvRllyON65+nnXaCJ/b6+YH56o0zedDj/zHvJNlAGDchuDSruVJyLQBrV8WAXWs
         SravIim8345TcwwvXjYeU75tQ4kL7jLhRajFS1OSDokJJV/2VK2hrLyNHeytc09YbPBE
         jM2IhEqSV04jlyvKp+lPOuB2WYY9aatRDk+LOTBeBnMlDt3YlDDVrTb0oSdatP/JD6YQ
         IL0Ud2rj4HI2GkkPVHkPeM+vv4EnsEOhUTSW45cOfdJ43h4sIYmtFzLdciJnJMx53rpl
         0bRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787888039; x=1788492839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tJ6GRA/2LwQW6/jDEIjrj/TZS2ZKHOJ3XYsZbyYACDw=;
        b=IRAlJKrdTlnLfd1zh5UYkkNyxMy/5gSzPO6oUwNaFIV7mX15jZEMoZReFtmrcyproz
         eKm9fktZdQ6vW/nYHf5LzbhYnR9tha8EsXKQM79suPQOOJvyMwXwuUkfch3Ie9zLKhdu
         xT26WwvmLN4j4mez52HMs7lmahHsx3hKRWiYW835Pz7kaSt+dFzFsfo62i3UOBoLeGoV
         AFBOQxPPYi4ONIjzlGXl9f5jRQJ58vRXsOC1DRYBOwm5ms109VibCeT2M1rJ6BJqi9yR
         6+vAtDTTjan4O1L2QIC9QxsnrhMp1/UJpnno+nolcdE3cKV9RofENSvdetPX8qfDN4uj
         iMPA==
X-Forwarded-Encrypted: i=1; AHgh+RoQa3TahrbJ2d5GdsOEv+EX4WAAz6VFLiFmt2jtwWe4qeZyJQ5J1t61hGb4nVA1+HqjWwN8yXyBKp2F@vger.kernel.org
X-Gm-Message-State: AFuF++kxwjx6PWjm+TsOo+5ZucNwPd8oU7yI7POJtHmPy5FoglnyGuIm
	UJASefdIpZgcvtXGI0/JSfBe/0j4peURZOaMJlG5dHdPRaivGkezsk1Cwu8VZF/08qjQ4X+Qfvk
	QuvHAPgsNWe39uciseeaXU63/AWxMLIk=
X-Gm-Gg: AR+sD13Apm3f4DAS9M48I46E02oIELY8WVSJ3KyNVjMoPz9tMhyqrBA0J08QiD9H6na
	2LxdZNZblOl85avahqFLIbk37JUDygob+RwtgvOG9mEy58ipnJKsHfhhwXNpsfs0/O833FqWnbN
	WhYv4Sk8g0Yh2NeYEQXw+g7fsPr5Z88V8/UBBPGjShLpL0XXsKE00WNptv1OuVdILAibbxaw6wY
	9GB/OokToZgcUALOqhf3V+IqBWpYcrNOwLD3COO6UaMuxQcsloMPb+5kpVPbKurw9zma2VMP7gk
	ocOkc4CPEa6Vy0eKODfGLInjMaSUIyyvckhDajMZDz1OQ6+f54l/868YDW7ljRKdzu4SajPBeKR
	hBMrLeCozDSDrJgUF5rK4d0LO63wT5mKIaM8kirCechfU
X-Received: by 2002:a05:6820:340e:10b0:6b1:67e1:fc8e with SMTP id
 006d021491bc7-6b1c66e6ce5mr2559540eaf.25.1787888038951; Thu, 27 Aug 2026
 20:33:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827185722.3234622-1-csander@purestorage.com>
 <20260827185722.3234622-2-csander@purestorage.com> <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
 <CADUfDZoEosgMMQ47BDWBskTOZrYZpg6VUT5c4kwczDLRLXYk=Q@mail.gmail.com>
In-Reply-To: <CADUfDZoEosgMMQ47BDWBskTOZrYZpg6VUT5c4kwczDLRLXYk=Q@mail.gmail.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Thu, 27 Aug 2026 22:33:46 -0500
X-Gm-Features: AcwNN1V96G10EnqkMmlBEbQoJ8ihVOlJhML3SIuW3TsrH3jrmu0CBU7aGovmtII
Message-ID: <CACVXFVOLBVVGwfo+mbn+4jnGKZS66dL_2ghsKiaT6buscWJg6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/cmd: split io_uring_cmd_set_res() from io_uring_cmd_done()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 4:44=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Thu, Aug 27, 2026 at 1:05=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Hi Caleb,
> >
> > On Thu, Aug 27, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > In preparation for setting the io_uring NVMe passthru CQE results fro=
m
> > > the blk-mq request completion rather than the task work callback, spl=
it
> > > out functions io_uring_cmd_set_res{,32}() from io_uring_cmd_done{,32}=
().
> > > This allows io_uring_cmd_done{,32}() and __io_uring_cmd_done() to be
> > > consolidated into a single CQE-size-agnostic function with 3 fewer
> > > arguments than __io_uring_cmd_done().
> > >
> >
> > The conversion looks logically correct to me but the interface feels a
> > bit annoying / fragile on the caller side.
> >
> > Is there a way nvme can get what it needs without changing the other
> > callers? Would it work to just keep the existing
> > io_uring_cmd_done{,32}() as is and add a separate API for special
> > callers like nvme, eg:
> >
> >   void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64 re=
s2);
> >   void __io_uring_cmd_done(struct io_uring_cmd *cmd, unsigned issue_fla=
gs);
> >
> > where io_uring_cmd_done{,32} would then just be inline wrappers over
> > those? afaict, then only the nvme callsite would have to change and
> > fuse, btrfs, block, ublk, and scsi_bsg could just stay as is. Do you
> > think something like that makes sense to do?

Yeah, this way is definitely much better from a driver viewpoint.



Thanks,
Ming Lei
