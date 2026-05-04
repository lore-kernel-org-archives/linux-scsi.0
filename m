Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61673E3C60
	for <linux-scsi@vger.kernel.org>; Mon,  4 May 2026 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777917365; cv=pass; b=meFPR+DkgtWvw8THyT/gWAwNjQ0OHaN1n7ATdwICX0MvGgRDl3m0HCkpmr9PKliNz+euuDIQsSA7huKTWZXuwehp6Dk/TuGrc7fx9DeBOkBLRZJgid5hPP4wO0MSl6QRnT4+e9OrItdf+1HwdOFl7B/fyRMWlbKQY3abvwICE7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777917365; c=relaxed/simple;
	bh=bmNymKc+WlzZEEC+pNTT+/WQ3FaUTTrwyjCxZ/xSL2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EX2omTZOwDVKGX9HdJgvxRllaLCLVaqKyYqn5OTz5eSz4pJqe3u4QydnckLwkjXqtIoVCO/lOjWPmTq2z7/yN20fEinARyiG0rW/OlSoLwE8ncVD31kuq/ESuk6BPsztfN40r6O42MQQiPoBQLxZiBUcNRXRKTm0F7OhnSbfKDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=a4Vut8WE; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="a4Vut8WE"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7dcd809f8f1so318610a34.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2026 10:55:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777917356; cv=none;
        d=google.com; s=arc-20240605;
        b=KD9ZYZ/rAgZ8rUjLtGxXMgXpHF6CvIK/bprp4FLNq/NL6nJGNDUMg7P+dDKIfAyTkZ
         7y9Zo9CedxUt1z2+BDNr3yg+2VTSGmRnhn591LIbN7jJBKK/V4RVkPyA8zyOVDFs0Tuw
         08pDoG0Vi0FtL/Clm8K0uVEleLJk3iX9o1Qb3GIT97IJrj1SDbCadPqK6DsloJUZwLDQ
         lmxj+XhNiM8k5i4gm6Sn09TIyyddIbBZU11VU7y6NkiY8oD/KXM30GCP5s2gdEkRtpHF
         nTwQKQ+c1W+jU6jZt2WAkd0IQI4r/O3ks8THWmn8y3BCsjBXVeUzU+f86uZSLmweBCFR
         5XGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bmNymKc+WlzZEEC+pNTT+/WQ3FaUTTrwyjCxZ/xSL2Q=;
        fh=6ro7g5IffQ0u6RVeFf+rBWcgm9prQK1KPDr4ZClfAtk=;
        b=Qac6aFFwR5VBk0BOWo2YxOtc3GSEiiQ0xWMQlnT3J8b7fq3VyuXE19k73o2MmEAgkk
         ligIB1PdxUt/ZzuZ+wDcbRdD3n6AV1FeiJR7PLD+WD8qaO8JLxemuszl9upvDnSkckUV
         B8SWyDxUQMAJAuHlTfy6zfdni7JacUYK2dbAjPSbHVXLiOiZ6lw7AP8iPkX4Ne9OQbfF
         sgnPNRdbnWBwbBU8ayZH4ajEr/kizHgqSwpegOdZ6hXltYIwAptkJ3Y3J/ry2WHQ6EWd
         wS12Y9OzdK3m7225a7A4qAP6/HPbgJtFVwGCMR719KPd73rZMh1PAQGUWw2aj+CXl78R
         1sPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777917356; x=1778522156; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmNymKc+WlzZEEC+pNTT+/WQ3FaUTTrwyjCxZ/xSL2Q=;
        b=a4Vut8WE8RLH/3YO/k+1r4rZ4hy+1lwjhwX/Eccnz9XYIuqQuU8hFplBUfTby9Tn+L
         K+q0X6majklIy0Lj/11mbBhb5gAFsvJXcT9Gr8LZBKknjdg9B8L14a3lTz3PmqAqAtpA
         xi4IU1oyGgoxWjB9tda1Y7IMocs/9UHFYQB6CY23de+3SeJAVLHN443FQTOuMX3WmVna
         4HPDlBzKCC7F+09ngUFu8alDAZP7lH2aU8uVdWb+TaryoPV7CiL5OlWomNZxqKy3y6Vt
         PES5n0mV3owYSGgYrUX7g19/75Pb0115ZtvyrvY3ev8G3wGANjA6fRT1wuqYLi0XHDL9
         r+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777917356; x=1778522156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bmNymKc+WlzZEEC+pNTT+/WQ3FaUTTrwyjCxZ/xSL2Q=;
        b=XwUvxJ5nA8bVZp4TUB30wUtQKutJ2QRiuJFbS8mqU2KniyAF2xOYOcsFIJxV7iirOr
         QdOrzMFT4A8G5A8w/YOPWFucJQ/DcgpAf2JDPaKVP9+Z0ssYZWo7gJDxHfFvnZfGAEII
         NPMR7QvA+HqjqlVBz1hT72Rwpi+RBsj2eQiEx0GNL+hffy65oVFMNN70OfrQ/iV+K2pB
         2HsgCHEiIR5ZOyciwNTS9VEeKXxO/TP7H4QOLU++9DbWAoGnihJK/Yzxe2KP2+sXldvZ
         b6vJrGFipubKPSnm6hNoyWYF99adv/aPk6tb5HUDR0LeBtO7QyHpr1bLODWYw/XU3q+x
         bmUA==
X-Forwarded-Encrypted: i=1; AFNElJ+fMeokn1/FU8hmhda+7KbcJ9dGnAirpFAENj3jV5fmIULARCALojE4CI5w6YXTXg1cQbwFStJLAQB6@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8FSoEBCY/CJygtt6ph0iyCgSJGe8B0cu7SRgZOdu+3Dx1D0Uc
	VbfGI9kRRqBQXC1eZPInOJzRreWqWcZ25ajcxi+pi8J0/hS2x9yYY4f9plCzo3tQunpTnOj5zJO
	f2ROamsNFzOvFVj1C1WXZ3FMaPVLmz/L8JaE4dDAUaA==
X-Gm-Gg: AeBDiesOyH8xxAjHYbX61IZO19fLNTRFlZ45Hp/Asf9c2GvWFLHSPSZ6MLudtYT5jpa
	BCb6PZKz4umisW3jM0m6lW7stiH2eUKy7nDgiZmNHp9gdtFLiBSSdBFiiT/cE9eELTs9YLXU75m
	tXf8EEJsAAKUs6TBd/LCnfo2KEUkqMVwV47n3RqANYnUs4+wIbi4w4rQ2XWVTE7vZ7OX3nEVnbX
	b7JZmpp05dZAm3sPH9Y3Yv5WaHN3OMnE5Pr+D99apTXVqFpGYFvQl4IrPsH4NzYLLidds9Vx70m
	Q7nE9OECcW6YjKXZ3vk=
X-Received: by 2002:a05:6830:314a:b0:7dc:cba1:8306 with SMTP id
 46e09a7af769-7dee11cbc2amr4169091a34.2.1777917356159; Mon, 04 May 2026
 10:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417015732.2692434-1-csander@purestorage.com>
 <yq18qams3re.fsf@ca-mkp.ca.oracle.com> <CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
 <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com> <CADUfDZqkT4g3T6uE=hxt9J6JDMXbJt49rM7_Vgs3EBPdFeuuLw@mail.gmail.com>
In-Reply-To: <CADUfDZqkT4g3T6uE=hxt9J6JDMXbJt49rM7_Vgs3EBPdFeuuLw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 4 May 2026 10:55:44 -0700
X-Gm-Features: AVHnY4KNYsVR2kYl7eJ0Hwf9__aBJ8ZzUEN24LJvPWcKnRGqgghNGjpf2B_6MDk
Message-ID: <CADUfDZq+BZ4Xn19TXH53NndDwDwMKm3xS8wSMnMtRsF7dWSyGg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 11:02=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Apr 20, 2026 at 7:09=E2=80=AFPM Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >
> >
> > Hi Caleb!
> >
> > > NVM Command Set specification 1.1 section 5.3.3 requires the referenc=
e
> > > tag to increment by 1 per logical block, so that seems to determine
> > > the increment unit:
> >
> > SCSI allows PI to be interleaved at intervals smaller than the logical
> > block size. This was done for PI compatibility in mixed environments
> > with both 512[en] and 4Kn disks. Interleaving allows 8 bytes of PI per
> > 512 bytes of data on devices using 4 KB logical blocks. That is the
> > reason why we use the term "integrity interval" instead of assuming
> > logical block size.
>
> Thanks for the explanation, I'm not too familiar with SCSI. I meant to
> refer to integrity intervals in my explanation if they differ from the
> logical block size.
>
> >
> > > The ref tag used for a particular block needs to be consistent. And
> > > since reftag(block N) can be computed as the reftag(M) + N - M if
> > > block N is accessed as part of an I/O that begins at block M, the
> > > function must be of the form reftag(block N) =3D N + c for some const=
ant
> > > c. Thus, the ref tag seed needs to be computed in units of logical
> > > blocks (integrity intervals); no other unit (e.g. 512-byte sectors)
> > > works.
> >
> > Whoever attaches the PI decides on the seed value. In the case of the
> > block layer it made sense to use block layer sector number since that
> > value is inevitably going to be the same for a future read.
>
> I'm not following "going to be the same for a future read". The block
> can be read back by an I/O with a different starting
> offset/sector/seed, as my example illustrates. When the integrity
> interval size differs from the sector size (512 bytes), mixing the two
> units results in a different ref tag seed for the block depending on
> the starting offset of the I/O.
>
> >
> > Note that with MD, DM, and partitioning in the mix, the sector number
> > seen by whoever submits the I/O is going to be different from the LBAs
> > on the target devices which eventually receive the I/O. Nobody says
> > there is a computable constant offset. Think scattered LVM extent
> > allocations. Or RAID stripes placed at mismatched LBA offsets.
>
> The constant offset relationship still needs to hold over any
> contiguous range of a backing block device that can be accessed by a
> single I/O. For example, with partitions, it's not possible for a
> single I/O to cross a partition boundary, so each partition can have a
> different constant offset between the ref tags and absolute integrity
> interval numbers. With RAID, each shard can have a different constant
> offset. etc.
>
> >
> > > To see the issue with the current approach, consider an example
> > > accessing LBA 1 on a device with a 4 KB block size. If the block is
> > > written as part of a write that begins at LBA 0, its ref tag in the
> > > generated PI will be 1 (sector 0 + 1 integrity interval). If it's
> > > later read by a read starting at LBA 1, its expected ref tag will be =
8
> > > (sector 8 + 0 integrity intervals), and the auto-integrity code will
> > > fail the read due to a reftag mismatch.
> >
> > Something is broken, then. Because the ref tag in the received PI shoul=
d
> > have been remapped to start at 8 in that case.
>
> Ah, I missed the remapping piece. Thanks for pointing that out. I
> guess I was testing with a ublk device that doesn't advertise
> BLK_INTEGRITY_REF_TAG. Since commit 203247c5cb97 ("blk-integrity:
> support arbitrary buffer alignment"), the ref tag is unconditionally
> set in the PI from the (sector) seed, but the remapping is conditional
> on BLK_INTEGRITY_REF_TAG. That explains why I was seeing ref tags in
> the PI that didn't match the integrity interval numbers.
>
> So seems like patch 1 ("block: use integrity interval instead of
> sector as seed") doesn't need a Fixes tag. Still, I'm confused why the
> auto-integrity code bothers setting the seed to the sector number in
> the first place if it's going to be remapped later. Why not just leave
> the seed zeroed?

Martin,
I would appreciate a response here. Would you be okay with patch 1 if
the Fixes tags were dropped? Do you think we can get rid of the ref
tag seed initialization entirely if the ref tags get remapped later
anyways? Even if patch 1 is not required for correctness, patch 2 is a
fix for a separate issue introduced in the 7.1 merge window and has
reviews from Christoph and Anuj. I would prefer not to hold up that
fix over this ref tag seed discussion.

Best,
Caleb
