Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC5E3603D9
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776967383; cv=pass; b=ETmabWZVQc44/ve2LlN6VyRjRDWLSFsp2r7M3xRz9TaDojoHGtJKe24BrTaSsKSM4YGogITU7X02kERGVkR59MaJ1RHwqTAiv/MxmMD/k1yldl5Bzllj1X++8em5IU6ky90Jo2AMPZ+Q4W7leqv2A4OYdIPRi3XKBBPfatlvJ7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776967383; c=relaxed/simple;
	bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xca1xZ/d4fwbeWSW/Y58V9q6ZykpN+jey+UiHLYzRGxPfS5Hj4svzP9Pda6lr1CT8riF7RQo90xzJimKmj04MIfp6CtSkixEHO8UJ+OCYtIc1QY/zJMpM1+pNsMO3wFue70gT+l807ufEPHFYh5CMIRR25xca3KUq1eKWxu392E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RnaXudyK; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RnaXudyK"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-66dfeb899f4so258524eaf.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 11:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776967381; cv=none;
        d=google.com; s=arc-20240605;
        b=Rpw8JAVvmM/ORK8ikV7ftKXyR0G7nvmDjjRkjZmdiyOTb8Anf7hSrnYGBSiHLdAUTM
         nKFHq7/d6oHc6vJ5yRO23y7loq+oIl9bLRmkWaIfyo11UssindD3E1h0zgFQ+sh8UTYM
         kYknCbRGyvBuXhhCg9ncTsbqqp0iL/hcIun5/0xkBXPLJ2OqKd9DLjl1gs2ZEniz6Rwv
         ygl0Ft+In5qSahaugqX7QYclg0c9VdRd/ewCzFQfvEf6kTCdVpiAi8E6aJatxtNglxkZ
         D4rkIdfRIMuPRFx8j8U8n1qGX1kFtrWKB/u0lsaWlsJSJXr22MOikQARzd9IDPU23ooe
         DbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
        fh=SVm7kBdnyIF5nFvNa11H9lJvMaiFMEmzxCt0oK3Scww=;
        b=LgpVkKc223p8owX8lbWfFgFQBNNeuntEA2GY62zE05F6f9kbMEpdMHxDM+QuCjmwrW
         ON4yNH9c+j8G/0ojWD5Bwwaxzlfr/Sd3IjKJ6rNdyY7oNzrGg7w6S/gDj+o2lN+G5owE
         ok1R5plUOZaDVWxHOvIzUqhIfW+VVcl5gPA6aWJWtg4p4fnbUOHf05tKSOMTzKV1YjUi
         BQAKyrqo1h+bedfAIVbvi9wVpF7mfga8T5r7hH48DFkGAAkiVCYHeT4Wxqy/lNnM2h5o
         NIPZwlS2dhkx68U0/ygCU0PkOfLMSDMyuRyq2Pz7Y5Fv4E8hcDHCD6+QHLM86ZSHfchU
         qtHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776967381; x=1777572181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
        b=RnaXudyKoIRW7/MZFIRNUV3etWC4Z1oh6blReqmk9KsUHGLVtiZJhueSL+EpsWHShy
         gbYPoR/rIuiWVLUnYmWJPawaEfjhyMhl6fa0BFIEl0g7GE2B21gpdAbSNl8ZYM1aUa0w
         5y18yjZ22b/SBT6S6nDpyzatVzciz4cfE3x/PsmX2N86Be7fYbhLzzksn8om1kO6LbBx
         pcCB2OTWF1pqgEVixXoNE0bSlSaxQffsNPjfwmBkQ7hssxldz4HNRZIKftWWGxZQcU4Q
         Q6sGN8dYbnq1VBIg4OQjz/yOY/s+++E1tbTXf5Bzh/ZG97Tyovyv9O2s6qPnSEvWmxit
         Bvmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776967381; x=1777572181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
        b=Na5VrxCXtWuw0073mEJfA/SAZCi9ZJ9R1mgUHyRZYNFkYdY5eZr5El0fqVl4rNYEte
         myMhIL/FU++MtQ6oJRzlWQb7jYhyGrPt/WpdhZ4A/ZKMXpVGBe5T5ZIdzeWOzorMtuH8
         PipWod6yljt2Gw+Ltq/Uwu/Cvis0y122OXd5XzyTdl/1/Q5QugGrD5cqzt38Vn2qivAx
         RTl5LA/Z/nIZHG0lGFEj1GaQ0tAKzoUVr0TTUf/+8dxLTQnFaPxO4AzLbcbFt1+neVVL
         1CpigL8aRpAWa2MFQTFsIToi8X8yAzInwFDy7swK62x4FLbPxO3dQ1//35KwxwV6lpYa
         lkZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+RbvJI1MBDA1lPSy+M6054fKu5mnk2jxjbKLV5QMZDGVElpEGl2QxM5LiqZJ4JdT5OzHA92OS/0yxI@vger.kernel.org
X-Gm-Message-State: AOJu0YxxihGuso+mC3U+NCqFCZDqwfh+s5/3RSnRiQbP6ZMaxpKX9GEn
	SW7Pqntt3F6k7pNIhbCGp7I44DDLUrr+0Mp9Ji7H0XO2Hz8HxroX4POnC5RuJuw7esSeB+T5Nkb
	oMooVPZSH4do8gPR1tFETo2q4zRXkxtMd1aGZWIwvVQ==
X-Gm-Gg: AeBDietgvN6qvR/kU0K66dBT9VDJNXaqdKwhnEsDnhwU9gfB4vuQ67R/iISwXJ7Ds73
	cPped5OyrcmCyBCeXe85ZtwjASuBpyiYC51nagLDPvfW6titbYdPpeXW5XsQwC5CisZNeEN1do0
	8T9DQGwbB5foLFlJ+R1zRQaOkcw9m/LTtF2wUOyXfsWvnhmXNthIKYbP1G0IJRIMhfDNg/iQfxx
	CoMsUTr708lHPRUGundlj46Q4i4RS7sJS9UzOi7fwcGcP3Z4p4DUR1Ly5gvbqODPybG/sOQa1ay
	jv0cgVKERsWL8B4RPPE=
X-Received: by 2002:a05:6870:16f5:b0:42c:1e12:6bac with SMTP id
 586e51a60fabf-42c1e13c7b0mr5869827fac.5.1776967381259; Thu, 23 Apr 2026
 11:03:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417015732.2692434-1-csander@purestorage.com>
 <yq18qams3re.fsf@ca-mkp.ca.oracle.com> <CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
 <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 23 Apr 2026 11:02:50 -0700
X-Gm-Features: AQROBzCpAwBKjPdeKRy_iDk99MgWov4WGujklh5E85jOlbENhysKrBryAPvMMQQ
Message-ID: <CADUfDZqkT4g3T6uE=hxt9J6JDMXbJt49rM7_Vgs3EBPdFeuuLw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 7:09=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Caleb!
>
> > NVM Command Set specification 1.1 section 5.3.3 requires the reference
> > tag to increment by 1 per logical block, so that seems to determine
> > the increment unit:
>
> SCSI allows PI to be interleaved at intervals smaller than the logical
> block size. This was done for PI compatibility in mixed environments
> with both 512[en] and 4Kn disks. Interleaving allows 8 bytes of PI per
> 512 bytes of data on devices using 4 KB logical blocks. That is the
> reason why we use the term "integrity interval" instead of assuming
> logical block size.

Thanks for the explanation, I'm not too familiar with SCSI. I meant to
refer to integrity intervals in my explanation if they differ from the
logical block size.

>
> > The ref tag used for a particular block needs to be consistent. And
> > since reftag(block N) can be computed as the reftag(M) + N - M if
> > block N is accessed as part of an I/O that begins at block M, the
> > function must be of the form reftag(block N) =3D N + c for some constan=
t
> > c. Thus, the ref tag seed needs to be computed in units of logical
> > blocks (integrity intervals); no other unit (e.g. 512-byte sectors)
> > works.
>
> Whoever attaches the PI decides on the seed value. In the case of the
> block layer it made sense to use block layer sector number since that
> value is inevitably going to be the same for a future read.

I'm not following "going to be the same for a future read". The block
can be read back by an I/O with a different starting
offset/sector/seed, as my example illustrates. When the integrity
interval size differs from the sector size (512 bytes), mixing the two
units results in a different ref tag seed for the block depending on
the starting offset of the I/O.

>
> Note that with MD, DM, and partitioning in the mix, the sector number
> seen by whoever submits the I/O is going to be different from the LBAs
> on the target devices which eventually receive the I/O. Nobody says
> there is a computable constant offset. Think scattered LVM extent
> allocations. Or RAID stripes placed at mismatched LBA offsets.

The constant offset relationship still needs to hold over any
contiguous range of a backing block device that can be accessed by a
single I/O. For example, with partitions, it's not possible for a
single I/O to cross a partition boundary, so each partition can have a
different constant offset between the ref tags and absolute integrity
interval numbers. With RAID, each shard can have a different constant
offset. etc.

>
> > To see the issue with the current approach, consider an example
> > accessing LBA 1 on a device with a 4 KB block size. If the block is
> > written as part of a write that begins at LBA 0, its ref tag in the
> > generated PI will be 1 (sector 0 + 1 integrity interval). If it's
> > later read by a read starting at LBA 1, its expected ref tag will be 8
> > (sector 8 + 0 integrity intervals), and the auto-integrity code will
> > fail the read due to a reftag mismatch.
>
> Something is broken, then. Because the ref tag in the received PI should
> have been remapped to start at 8 in that case.

Ah, I missed the remapping piece. Thanks for pointing that out. I
guess I was testing with a ublk device that doesn't advertise
BLK_INTEGRITY_REF_TAG. Since commit 203247c5cb97 ("blk-integrity:
support arbitrary buffer alignment"), the ref tag is unconditionally
set in the PI from the (sector) seed, but the remapping is conditional
on BLK_INTEGRITY_REF_TAG. That explains why I was seeing ref tags in
the PI that didn't match the integrity interval numbers.

So seems like patch 1 ("block: use integrity interval instead of
sector as seed") doesn't need a Fixes tag. Still, I'm confused why the
auto-integrity code bothers setting the seed to the sector number in
the first place if it's going to be remapped later. Why not just leave
the seed zeroed?

Best,
Caleb

>
> > I agree, the seed doesn't need to match the final LBA, but it does
> > need to be in *units* of logical blocks, plus some constant offset.
>
> Your concept of "unit" still sends the wrong message. The seed is an
> integer value used to initialize a counter or hardware register. The
> seed only has meaning to whichever entity submits the I/O. To everything
> else it is a value used for remapping ref tags from the I/O submitter's
> point of view to whichever interpretation is mandated by the storage
> hardware's PI format.
>
> > With a ublk device. It should affect any block device that supports
> > integrity and has a logical block size > 512.
>
> It sounds like the seed value is set incorrectly for reads in your
> configuration.
>
> --
> Martin K. Petersen
