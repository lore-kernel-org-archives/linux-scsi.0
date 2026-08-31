Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0787738888C;
	Mon, 31 Aug 2026 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788210483; cv=none; b=dGRuy+X8iF6E7dGsV7Ni7+vqBhXAB2nD/BV4pNKMPKOaSnVC1ieYv3tLdGRoWs21qqWGP+ncvMeuG9xnx2bOXxvzdjEhBYLW8qQIZ+BohbUEPr6IBKAsSd6DX5x+hlrScYa1DJD47hdQVf15sP3SWWW3BRJkElKJlug8pK29JX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788210483; c=relaxed/simple;
	bh=zcm8ggJed5PjXC+9lg/xPUfVJkdcYjA3JSXdynW72Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCk8FuMGGRbP6gFH1w89+JwV3xu72qJ0LDttYk8dvjKUyRNX85QHhNasL2FnrP9rdNPT9e+S2KUugMuBhyoH4Is+7SXjuWehyH1lq9DbvAa7Bpvi5RrLRF00TjoMthXY/gSzB0sc9vGtnR5LOlv1OuMGtaUm1VIlF+jtFE+rU6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKZUz43L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKZUz43L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7711F000E9;
	Mon, 31 Aug 2026 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788210481;
	bh=QYx9KC4MIYUH9ekoEcwCMnVwX3dAfHBqBgdU/xOfYwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dKZUz43LXHW4oXXwv67Upy9MfEsw9rlqnr503Dd1gXznuApyHbDBk35ZmgfAT56xJ
	 SYTsg33QtvTaI1vJ0Izvyb+AtN39XfKYQisxJavxVwPCl1gLxBqnLqiO8CcOX00jMg
	 SOh2f8zhfEcR4p1MHl52Z6hgOQsWZRti0dC9ua9cZOtAbsK1S2nkjd9JLgI742p4ex
	 OcrFfMoBBZIdZ7zNRPD8CkEiAqVL5aUfP+PdBDbuUTXpes5cbCNp5Hif4c+/O26eWY
	 ZK0QMiNhcCf9piH79cnMgt6mERIBc1Ep/m9kyTKThrwq+94DpMVgmdW1T4kxsVZRXb
	 rAe1OX3iPbaTQ==
Date: Mon, 31 Aug 2026 14:07:59 -0700
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
Message-ID: <20260831210759.GE86114@quark>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827184219.GB2137493@google.com>
 <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>

On Fri, Aug 28, 2026 at 11:37:57PM +0800, Linlin Zhang wrote:
> Thanks for your comments!
> 
> Not making virtio-blk itself support key programming and eviction is
> something done deliberately. Based on that HW-wrapped key management
> operations are also handled in the out-of-band path.
> 
> There are bellow 2 approaches I investigated to let virtio-blk programming
> the key.
> 
>   1. virtio_blk implements blk_crypto_ll_ops interfaces, including program
>      key and evict key interfaces.(Same to 'the virtio-blk interface standardized
>      blk_crypto_ll_ops requests' mentioned by Stefan in the virtio SPEC thread)
> 
>      The guest's block crypto profile manages the keyslot in virtual slot
>      format in this scenario.
> 
>       - block crypto key and virt_slot index it passed to the hypervisor's
>        (EL2) device emulation (QEMU, using QEMU in the following) which
>        runs in userspace of the host. Besides of transferring the virtual
>        slot to the physical slot, a programming block crypto key UAPI need
>        be added. Follow current blk-crypto design, it may be like
>        BLKCRYPTOGENERATEKEY. I thought this results in a security risk that
>        allows userspace process a key into a key slot.
> 
>      - For key eviction, it's similar to above key programming handling, also
>        need a key eviction in blk IOCTLs, but leads to the security risk
>        that allow userspace client to evict a key in a key slot.
> 
>     virt_slot, DUN and DUSize is appended to virtblk request during crypto
>     I/O.
> 
>   2. virtio_blk implements blk_crypto_ll_ops interfaces, excluding program
>      key and evict key interfaces.
> 
>      The guest's block crypto profile doesn't manage keyslot for the guest,
>      the host's block crypto profile manages keyslot for both the guest and
>      the host. The trigger of key programming operation is moved from the
>      guest to the host.
> 
>        - The whole block crypto key (key size, key bytes, blk_crypto_config)
>          and DUN are appended to the virtblk request during IO, a little
>          high payload.
> 
>          The backend parses the crypto message in the virtio queue and
>          construct a block crypto key and DUN for the bio_crypto_ctx
>          set to the BIO. So that the IO flow in the host can program
>          the key. 
> 
>          The question is that the blk-crypto-profile distinguishs the
>          block crypto key via the key's address. But the host has
>          different key addresses for the programming and eviction key
>          operations of the same block crypto key from GVM, because the
>          key is re-constructed in the host for the key program and
>          eviction operations. 
> 
>          To fix it, the approach I thought is maintaining a new key
>          hash table in the backend, and comparing the block crypto key
>          content and DUN parsed from virtio queue with that in the key
>          hash table. 
>          My major concern is that this need keep the keys synchronization
>          b/w this new hash table and the blk-crypto-profile's hash table
>          carefully, avoiding that key is still present in the
>          blk-crypto-profile's hash table, but removed in backend hash
>          table. Another point is that the whole block crypto key and
>          DUN are appended into virtio block request per crypto I/O.
> 
>        - For key eviction, adding a key eviction in blk IOCTLs allows
>          userspace client to evict a key in a key slot. I thought this
>          is a security concern.
> 
> 
>      This option doesn't need map virt_slot to physical one.
> 
> 
> Taking all the above into account, I made a compromise to implement
> blk_crypto_ll_ops interfaces in a out-of-band path, which lets the virtio
> blk only need focus on the data path. I agree that it is complex than
> the second option mentioned in the above, but small payload (only
> virt_slot, DUN, DUSize) in the virtio block request and no security
> risk of key eviction from userspace.
> 
> 
> I would like to hear your thoughts about the above and am appreciated
> if you could share your insights about the design of inline
> encryption in virtio block.

Well, the way it should work is that each virtio-blk device should have
its own set of *virtual* keyslots on the host side.  From the guest's
perspective it would act very similarly to UFS / eMMC inline encryption,
and it would be easy to integrate into the existing stack.

Then to process encrypted I/O, the host would use the keyslot number in
the I/O to look up the blk_crypto_key it previously saved, and issue I/O
using that key (using bio_crypt_set_ctx()).  The existing keyslot
management logic in the block layer would allocate or wait for a
physical keyslot as needed, so it should just work.

Eviction would similarly be passed through to blk_crypto_evict_key().

Note that with this design, there would be no static partitioning of the
physical keyslots.  The host would just allocate and release them as
needed, similar to memory allocation.  The total number of virtual
keyslots could be greater than the number of physical keyslots.

This design would also work with hardware-wrapped keys.

The hardest part is still the UAPIs for the VMM to do what it needs to
do (assuming that it even needs to support physical inline encryption
hardware at all, and not simply use the AES acceleration on the CPU),
but that is the case with any of the proposals.

- Eric
