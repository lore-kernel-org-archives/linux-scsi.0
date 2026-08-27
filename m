Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B213A25A2DD
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 20:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861138; cv=pass; b=WjH1AkiUBgpJoMApT+CKAGw9Nm86jgCoHk0CDRpgQJvZnLNjW/53IiMi1uZ0N4OJh368HL1ng4R3Ni07nw5wYOTX1THP2gSLRCJIL1XgdAp0HbbV1ELoms3E/bZQPHEaiIv/0CDYAlEMZrOX4xnilUSECew2sYDeckisAfQqqTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861138; c=relaxed/simple;
	bh=Amq2Nq7g4Rvhi+A8MmnZy28GeuV84bebu12tbajvslg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fYhGoi9Rogh1pt7PDRNWq+gM5+HO64z2tDjSN84by6pr41d142h825Ip3V1P1F4nxBZictsyBXVniKAiRIn/uXPir9Baw9VTiBQdjRBmBhqR3Z05UGYt8hKESMGQqQ3z+Jnj5FBiXgqeZP+Wkk5wfO629V7CihvnvOvh8oDlHM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBTcaEmd; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBTcaEmd"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso1663015e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 13:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787861128; cv=none;
        d=google.com; s=arc-20260327;
        b=FOJlwRmvvysPU3EErG9bEatM1D6h/48IkKciTM6DvjHkw5PRTppLA+B6XvAAkpNpW4
         AZ2tqBFplYCnsyZ2eNf+6IRDtDLuTGqjvcr0WqZRJwI5zhfl8I4raqEsOEz22+Z5oClZ
         pgsPJVhfZPGJJpAnN/scjYsUisEvivQKSmdnknq3l0Nfm3OLAmg8BIhNBtinuBravZWY
         1tD9ml/BQoDumN6QWDxyeuJW8fze6ITxn0bggkJ7eaR+FMFLOujMTHEONMJsVuC6vUGB
         8Diwffg/dJ8Ld7lPS43a4TcLiSk1m8goL8BMEV1u43wBQ37xYJj5EtosKu/wX+bx1djB
         zMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BIsnd6xgeWrgcQT3jCCMdd8DVWxNR+Gr3QkvZG2o5wQ=;
        fh=nChvqGyT9U9zaQliXXCirJByRO3cyeb2rygWcUh7smU=;
        b=OR4heq1GhoS7EsxxaBMrcROrZlM49WvKkKtSz21dASlflcBVrDaOns8aiXVWv9cztc
         DGcFysXxS+ypUMRkD2jpNgkMAurYNC5WNcXLK2lIcr+5GHsmhZSwpOht7iBXauiIBTYC
         +jylfM7FVSJKZrwj1UNs9beUT5FYVs5UOfIQIlwQz9DTY+oD+/xOJLU8O5OdxDE8nSpP
         EQ6lu1uvsy7us2Lyq/FXmpGbhZjREbhJze0iKGAfs1OPyAGllhZeRR3e9bQenUDuWfXw
         /1D1Q6ky3LAZwFdfGz+26GBy/Ekg5aYq/j6A6caebcZujGhDnrbiCMIxL8DD2JYpblOI
         gf6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787861128; x=1788465928; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BIsnd6xgeWrgcQT3jCCMdd8DVWxNR+Gr3QkvZG2o5wQ=;
        b=jBTcaEmdwdW1DRedprV3w9bCe6/SEJs/DHjsy+D+PHot4C/PbHh5tD3BM6AzYCRCi6
         pWnhe7FihJi7qfBJNS+BVYisD9dMsX12faXTjzTw/9IRGDEtAaH35EU+ihqp2Uu33ynq
         uhZIwC3LG35wBKRoLsXUPWgEl4QAOtGU46rOl9i566IVSK9phMB5SNzdSqaXtnnPIoqQ
         H9sy42ymjOdy+f63Je0waSafi6q1BeCdb6uW23+Y+Sv6XzOv32pHLYs+qlaK6knAMBza
         CkfyYJEVtbS/VyPG1h9ao2I1/CL4JxF13UInCu9/qA+jqeRjk3uNvG3ELapCPsDwbqta
         iJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787861128; x=1788465928;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIsnd6xgeWrgcQT3jCCMdd8DVWxNR+Gr3QkvZG2o5wQ=;
        b=nHSOeD3ZxWf2pr/eVoTb5D7dctf4cr8mn5Xz9Xr3301/zmI9vIlOtxFZ5aNkc1dVDQ
         nVoeNQFW3qr+PLiHdd2IEw8L8EzAf60N7HuL9FOgOr21smX4ZXJ3fZNaYWQvvSvsmAlv
         MvayIXM+gQYiuyxvuPKCZCGqDcRZQ9ACmeahsR8738iThYLrFw65HFisAtdOrgqoVRuP
         QziSZyMnkMaFKyeAtc0ssjyuhpsf3v+zxp69UXdlCorUD3NEjPWFu0RqzVgYLBC9xzoU
         YMGW0lZf2ryDcAPhhMLUD6rnK+6hB9EJypDgKq9Gl6m1LuArTVpew+ajzodf7r17ImDB
         zyqg==
X-Forwarded-Encrypted: i=1; AHgh+Rri0DJTSvGA464hRbIUG1Ag08YgdCgLMArMt/4THftA9Akpjz1rEEI2Xtbe6f7p4J0VEOo6OOpy+j4D@vger.kernel.org
X-Gm-Message-State: AFuF++nM1+N6/S1kqYvxdHZTvTI+ZNXoau2PAL8LI1VZ5NZRmQW6rPff
	JhiofZ4wlYyIsG5QauW9GnjHRYsK9C1jeUtxWei+7ZitRNB9orGYs/RkeR+h3lEH7RnKXdXGB68
	X6Qq8xBYa+0HEjjFQOcWJPNd16lpgE6Q=
X-Gm-Gg: AR+sD13glpOOX6rQYgoGZ25qgUHM0dtX285iF2VkmBNVRmSiOTO8hvszhu8TlB0Wjby
	3hcIslCnjYyd5Sr5tIfaRVHtJEPC8RJBIQv4g4k6uq1BTGT3fix/SUE1sJQxpBjFsTOnoaKUJir
	XKVYgFi/Kdu3XheLKWbhe62Y/IwjCo4dbNEzQVfrPZI8XUi3CwPkucwjev0h3wscinYayq6GAAr
	E+EL2ymCdh/LigcczBUOGNDe1X1Y5VPSXg761PuyhyGxib0HPQ181tvwO0vOZRuJlNuMNj38jqZ
	R10BTUz/hw5xNVeO6xXgvrvZiQp1CdzJ6PT6sSEE6c71BVsHAGlsKOuQgkK9PM/GyFomFrusrLD
	yID0oMcv5BtRbjIUaQPJalJb/sqc=
X-Received: by 2002:a05:600c:c4aa:b0:499:d513:e507 with SMTP id
 5b1f17b1804b1-49b91c17d72mr16962265e9.2.1787861127504; Thu, 27 Aug 2026
 13:05:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827185722.3234622-1-csander@purestorage.com> <20260827185722.3234622-2-csander@purestorage.com>
In-Reply-To: <20260827185722.3234622-2-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 27 Aug 2026 13:05:15 -0700
X-Gm-Features: AcwNN1UExlY2vL2SpJh0tNQapsYMiZcr3z5sWaZZFYGrbWrJd63x35h50FR6wzE
Message-ID: <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/cmd: split io_uring_cmd_set_res() from io_uring_cmd_done()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Caleb,

On Thu, Aug 27, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> In preparation for setting the io_uring NVMe passthru CQE results from
> the blk-mq request completion rather than the task work callback, split
> out functions io_uring_cmd_set_res{,32}() from io_uring_cmd_done{,32}().
> This allows io_uring_cmd_done{,32}() and __io_uring_cmd_done() to be
> consolidated into a single CQE-size-agnostic function with 3 fewer
> arguments than __io_uring_cmd_done().
>

The conversion looks logically correct to me but the interface feels a
bit annoying / fragile on the caller side.

Is there a way nvme can get what it needs without changing the other
callers? Would it work to just keep the existing
io_uring_cmd_done{,32}() as is and add a separate API for special
callers like nvme, eg:

  void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64 res2);
  void __io_uring_cmd_done(struct io_uring_cmd *cmd, unsigned issue_flags);

where io_uring_cmd_done{,32} would then just be inline wrappers over
those? afaict, then only the nvme callsite would have to change and
fuse, btrfs, block, ublk, and scsi_bsg could just stay as is. Do you
think something like that makes sense to do?

Thanks,
Joanne
