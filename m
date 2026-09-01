Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D25C4CCDEF;
	Tue,  1 Sep 2026 21:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788298118; cv=none; b=ITyXI8ksgq5tOrGKf4aSWuecgYmgzVbwY2GqeuQM3jMZ51cbXSCIl2hDTV03vK551co/1QvXmvESg1eWUxR6T8QjwUeHt9TygQCEiMvqse2pcBI9lTdizCEj3Xfkdb990tDHDKCLoGvOBJLaW2p2j47pzekNT/NWMlUWml3IKLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788298118; c=relaxed/simple;
	bh=OfizP+ptEf1HS0hq6hrXMz1mVvO+FePP1zC3RrlmNNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTA0b7Ks+SkTnLUFUGEQUmDpXQbGCPJ1QMc767peSqwF/OMTv4e+QuAJL6xZ02TlLBYC4GfaThtFtxp0ghaqjobA5wm0IyzMmSP93wGwwvGC8yPa/JHtDgQWq15XzfU9KtxG8EGwlXS5EW2kw7bsA9Tqp3iFbiWumxSDX/qSYto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpvrTo1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpvrTo1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B76A1F000E9;
	Tue,  1 Sep 2026 21:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788298117;
	bh=bL7+JBUfnj/CnXAsFEDYoa5vYtw0IXTLDYwqfYjz5rM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SpvrTo1UeB5IOtS2Nlhf2nW1/jIfzmKphPHiRB7O4omy5YsxgikGxJx86X1y20IBz
	 Wuzg60RItOiKmh3wicsMoMqUObBSG53pu2fps1gM9c3eioe9qhQgfx+XA5wM/7RqFd
	 J15c6x6VxecIDwSvmTEd1NfZJ6ZJdRr+pSQY4DVWjWz8RCs735l8vx76QzFVw4gbGv
	 6hmoiCfPgcyP75pU2DiK606etCbO2ongi1PPxBrLm0zjUM0jhrNRhRnWAXWTsKKeqY
	 NOLR2gMPzIkKtX7/aGu8A+jXe6lxbpHLB31ioTBfvYV51qtNzGqxUznIkM4Bhs5qZy
	 Bf7bNjnG13zHg==
Date: Tue, 1 Sep 2026 21:28:34 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
	mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
	bvanassche@acm.org, alim.akhtar@samsung.com,
	avri.altman@sandisk.com, stefanha@redhat.com, pbonzini@redhat.com,
	eperezma@redhat.com, xuanzhuo@linux.alibaba.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] FBE virtualization: inline encryption for
 virtio-blk guests
Message-ID: <20260901212834.GA3585187@google.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827184219.GB2137493@google.com>
 <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
 <20260831210759.GE86114@quark>
 <ca838905-f0f8-4f0a-96aa-2bc05ab6c0a7@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca838905-f0f8-4f0a-96aa-2bc05ab6c0a7@oss.qualcomm.com>

On Tue, Sep 01, 2026 at 04:22:33PM +0800, Linlin Zhang wrote:
> With this design, I believe there would be two VM exits associated with
> encrypted I/O:
>   1. Key programming
>      Before encrypted I/O can be submitted, the guest needs to program a key
>      into a virtual keyslot:
>      
>      Guest virtio-blk driver
>          -> VM exit
>          -> virtio-blk backend (e.g. QEMU)
>          -> ioctl
>          -> host virtio-blk proxy driver
>             (stores the blk_crypto_key in a virtual keyslot)
> 
>   2. Encrypted I/O submission
>      The I/O request carries the virtual keyslot number and DUN:
> 
>      Guest virtio-blk driver
>         -> VM exit
>         -> virtio-blk backend (e.g. QEMU)
>         -> ioctl
>         -> host virtio-blk proxy driver
>            (looks up the blk_crypto_key associated with the virtual keyslot
>             and submits I/O using bio_crypt_set_ctx())

Most I/O requests only need step (2), since they reuse step (1) from a
previous I/O request.  The kernel evicts a keyslot only when it is the
least recently used among all the keyslots and another one is needed.
(Or when eviction is explicitly requested.)

This is especially relevant when only a small number of keys is used,
like is the case when the per-file key support in fscrypt is disabled.
Programming keys on Qualcomm ICE has always been very slow even on
physical hardware, and the kernel was already designed to mitigate that.

> I have been wondering whether a model similar to the passthrough
> blk-crypto-profile used by certain dm targets could be applicable here.
> 
> In such a design, ownership of keyslot management would effectively and totally
> move to the host. The guest would no longer manage virtual keyslots, and the
> host block layer would continue using its existing keyslot manager to allocate,
> reuse, and evict physical keyslots as needed.

I think the virtual keyslots are still useful so that the key bytes, key
size, key type, algorithm, and data unit size don't have to be
transmitted in every I/O request, then all revalidated and processed
again.  There is a reason that inline encryption hardware uses keyslots,
and I think the same largely applies to virtio-blk.

- Eric
