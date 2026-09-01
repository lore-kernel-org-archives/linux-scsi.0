Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578D93D411B
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 19:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788291904; cv=none; b=rKbb2rW8wMqJSPrnUdMTK8oPlC2g3yMPJA2LZngL8qLP1n3esR2uiuGQ/YcEHtcs9J0HSTP5srwpheNfOXY5zdp2fQ1HmdUErPrUAwhZNDgyz+1BUqQuQZJOrB08l0hCFigkqNeFwEhYLjoIxaXEdAhu9w14uS8v0RQCatogfNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788291904; c=relaxed/simple;
	bh=qns4i0vzSza9eI1E6ltQNoq6qlBATVjFAq09uyq6JPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgSRmuF4CmiQIJ5QeTx1gUvnlUg0qlLc0vcSakTmooCwebqVXm9jPA1nE06+nKki/zoyl8yixqVQ6yYkAF7g0YbkMm9JZz7BENS39pdwv3PNaAOW3t6S56bFT/ftohGo+1FtU0biro6BVg8eC9xpJyI0DOYe5s13a/eCBGxpZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D2dkNDmo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D2dkNDmo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788291901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wIhbsrwMr09604DPmSKwiuTmZlNDoR3Q+zpCXUlj+6w=;
	b=D2dkNDmoekfRF62Ro+4CjO796om0u4WaIzR0xlnp0OJ3QNphcLm03zT+rKwZkaooFXdz8L
	XruE3NzmjRTFERp66vFAnNWCGiRHu+B6jscubthXbSDdo6YnfZxNPWDcDcOMohnEq+2m07
	+TCwheLQj7x8F8UjUG/cG37Ab3CjNU8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-huxZQ2l0OP6dx2nzCofDrA-1; Tue,
 01 Sept 2026 15:44:54 -0400
X-MC-Unique: huxZQ2l0OP6dx2nzCofDrA-1
X-Mimecast-MFC-AGG-ID: huxZQ2l0OP6dx2nzCofDrA_1788291891
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8585C195411F;
	Tue,  1 Sep 2026 19:44:50 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5BF418005B8;
	Tue,  1 Sep 2026 19:44:48 +0000 (UTC)
Date: Tue, 1 Sep 2026 15:44:47 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, axboe@kernel.dk, mst@redhat.com,
	jasowangio@gmail.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, neeraj.soni@oss.qualcomm.com,
	gaurav.kashyap@oss.qualcomm.com, mani@kernel.org,
	andersson@kernel.org, konradybcio@kernel.org, bvanassche@acm.org,
	alim.akhtar@samsung.com, avri.altman@sandisk.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] FBE virtualization: inline encryption for
 virtio-blk guests
Message-ID: <20260901194447.GE527638@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827184219.GB2137493@google.com>
 <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
 <20260831210759.GE86114@quark>
 <ca838905-f0f8-4f0a-96aa-2bc05ab6c0a7@oss.qualcomm.com>
 <d7ce6c39-d9c0-4746-ba18-1c37a929819b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KTDsgjxbEoEJOa6J"
Content-Disposition: inline
In-Reply-To: <d7ce6c39-d9c0-4746-ba18-1c37a929819b@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

--KTDsgjxbEoEJOa6J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 01, 2026 at 04:45:19PM +0800, Linlin Zhang wrote:
>=20
>=20
> On 9/1/2026 4:22 PM, Linlin Zhang wrote:
> >=20
> >=20
> > On 9/1/2026 5:07 AM, Eric Biggers wrote:
> >> On Fri, Aug 28, 2026 at 11:37:57PM +0800, Linlin Zhang wrote:
> >>> Thanks for your comments!
> >>>
> >>> Not making virtio-blk itself support key programming and eviction is
> >>> something done deliberately. Based on that HW-wrapped key management
> >>> operations are also handled in the out-of-band path.
> >>>
> >>> There are bellow 2 approaches I investigated to let virtio-blk progra=
mming
> >>> the key.
> >>>
> >>>   1. virtio_blk implements blk_crypto_ll_ops interfaces, including pr=
ogram
> >>>      key and evict key interfaces.(Same to 'the virtio-blk interface =
standardized
> >>>      blk_crypto_ll_ops requests' mentioned by Stefan in the virtio SP=
EC thread)
> >>>
> >>>      The guest's block crypto profile manages the keyslot in virtual =
slot
> >>>      format in this scenario.
> >>>
> >>>       - block crypto key and virt_slot index it passed to the hypervi=
sor's
> >>>        (EL2) device emulation (QEMU, using QEMU in the following) whi=
ch
> >>>        runs in userspace of the host. Besides of transferring the vir=
tual
> >>>        slot to the physical slot, a programming block crypto key UAPI=
 need
> >>>        be added. Follow current blk-crypto design, it may be like
> >>>        BLKCRYPTOGENERATEKEY. I thought this results in a security ris=
k that
> >>>        allows userspace process a key into a key slot.
> >>>
> >>>      - For key eviction, it's similar to above key programming handli=
ng, also
> >>>        need a key eviction in blk IOCTLs, but leads to the security r=
isk
> >>>        that allow userspace client to evict a key in a key slot.
> >>>
> >>>     virt_slot, DUN and DUSize is appended to virtblk request during c=
rypto
> >>>     I/O.
> >>>
> >>>   2. virtio_blk implements blk_crypto_ll_ops interfaces, excluding pr=
ogram
> >>>      key and evict key interfaces.
> >>>
> >>>      The guest's block crypto profile doesn't manage keyslot for the =
guest,
> >>>      the host's block crypto profile manages keyslot for both the gue=
st and
> >>>      the host. The trigger of key programming operation is moved from=
 the
> >>>      guest to the host.
> >>>
> >>>        - The whole block crypto key (key size, key bytes, blk_crypto_=
config)
> >>>          and DUN are appended to the virtblk request during IO, a lit=
tle
> >>>          high payload.
> >>>
> >>>          The backend parses the crypto message in the virtio queue and
> >>>          construct a block crypto key and DUN for the bio_crypto_ctx
> >>>          set to the BIO. So that the IO flow in the host can program
> >>>          the key.=20
> >>>
> >>>          The question is that the blk-crypto-profile distinguishs the
> >>>          block crypto key via the key's address. But the host has
> >>>          different key addresses for the programming and eviction key
> >>>          operations of the same block crypto key from GVM, because the
> >>>          key is re-constructed in the host for the key program and
> >>>          eviction operations.=20
> >>>
> >>>          To fix it, the approach I thought is maintaining a new key
> >>>          hash table in the backend, and comparing the block crypto key
> >>>          content and DUN parsed from virtio queue with that in the key
> >>>          hash table.=20
> >>>          My major concern is that this need keep the keys synchroniza=
tion
> >>>          b/w this new hash table and the blk-crypto-profile's hash ta=
ble
> >>>          carefully, avoiding that key is still present in the
> >>>          blk-crypto-profile's hash table, but removed in backend hash
> >>>          table. Another point is that the whole block crypto key and
> >>>          DUN are appended into virtio block request per crypto I/O.
> >>>
> >>>        - For key eviction, adding a key eviction in blk IOCTLs allows
> >>>          userspace client to evict a key in a key slot. I thought this
> >>>          is a security concern.
> >>>
> >>>
> >>>      This option doesn't need map virt_slot to physical one.
> >>>
> >>>
> >>> Taking all the above into account, I made a compromise to implement
> >>> blk_crypto_ll_ops interfaces in a out-of-band path, which lets the vi=
rtio
> >>> blk only need focus on the data path. I agree that it is complex than
> >>> the second option mentioned in the above, but small payload (only
> >>> virt_slot, DUN, DUSize) in the virtio block request and no security
> >>> risk of key eviction from userspace.
> >>>
> >>>
> >>> I would like to hear your thoughts about the above and am appreciated
> >>> if you could share your insights about the design of inline
> >>> encryption in virtio block.
> >>
> >> Well, the way it should work is that each virtio-blk device should have
> >> its own set of *virtual* keyslots on the host side.  From the guest's
> >> perspective it would act very similarly to UFS / eMMC inline encryptio=
n,
> >> and it would be easy to integrate into the existing stack.
> >>
> >> Then to process encrypted I/O, the host would use the keyslot number in
> >> the I/O to look up the blk_crypto_key it previously saved, and issue I=
/O
> >> using that key (using bio_crypt_set_ctx()).  The existing keyslot
> >> management logic in the block layer would allocate or wait for a
> >> physical keyslot as needed, so it should just work.
> >>
> >> Eviction would similarly be passed through to blk_crypto_evict_key().
> >>
> >> Note that with this design, there would be no static partitioning of t=
he
> >> physical keyslots.  The host would just allocate and release them as
> >> needed, similar to memory allocation.  The total number of virtual
> >> keyslots could be greater than the number of physical keyslots.
> >>
> >> This design would also work with hardware-wrapped keys.
> >>
> >> The hardest part is still the UAPIs for the VMM to do what it needs to
> >> do (assuming that it even needs to support physical inline encryption
> >> hardware at all, and not simply use the AES acceleration on the CPU),
> >> but that is the case with any of the proposals.
> >>
> >> - Eric
> >=20
> > Thanks for your insights and clarification.
> >=20
> > This is a very clear architecture for virtio-blk inline encryption supp=
ort
> > and is quite similar to what I referred to as approach 1, with a few no=
table
> > differences:
> >=20
> >   - The host maintains a set of virtual keyslots per virtio-blk device.
> >   - Physical keyslots are not statically partitioned.
> >   - The virtual-to-physical slot mapping is managed as part of the virt=
io-blk
> >     device implementation rather than being tied to a VM-wide slot tabl=
e.
> >=20
> > With this design, I believe there would be two VM exits associated with
> > encrypted I/O:
> >   1. Key programming
> >      Before encrypted I/O can be submitted, the guest needs to program =
a key
> >      into a virtual keyslot:
> >     =20
> >      Guest virtio-blk driver
> >          -> VM exit
> >          -> virtio-blk backend (e.g. QEMU)
> >          -> ioctl
> >          -> host virtio-blk proxy driver
> >             (stores the blk_crypto_key in a virtual keyslot)
> >=20
> >   2. Encrypted I/O submission
> >      The I/O request carries the virtual keyslot number and DUN:
> >=20
> >      Guest virtio-blk driver
> >         -> VM exit
> >         -> virtio-blk backend (e.g. QEMU)
> >         -> ioctl
> >         -> host virtio-blk proxy driver
> >            (looks up the blk_crypto_key associated with the virtual key=
slot
> >             and submits I/O using bio_crypt_set_ctx())
>=20
> Supplementation.
> This may be a potential security concern. The host virtio-blk proxy drive=
r exposes
> API for key programming, the input parameters are blk_crypto key and virt=
ual
> slot. If a malicious program replace the key in a specific virtual slot b=
etween
> key program call and I/O submission via this API, the data would be encry=
pted
> by the unintentional key.

If the virtual key slots in the uapi are per file descriptor rather than
per inode, then other programs cannot interfere with each other's
virtual key slots. Each program gets its own virtual key space when it
opens a file descriptor. Sharing is only possible by inheriting or
passing a file descriptor to another process and that's good for
security.

Stefan

--KTDsgjxbEoEJOa6J
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqXKy8ACgkQnKSrs4Gr
c8jlIwf/XtrVPKfbvVHOezfxoBBhyVjeR1eN6QSR80TwYiZGnwvAAfJmUt+TyFvd
3QY3hxHd2SoscVPH6yikmmXWRCFBwr00Ud2aHqarQBwZ2Qdgpf4D6XXpMogM7QRK
jgncJtStCEvt1vBuN8S6uYFw7mcK5uIQY5bQzM2tlBgZ6eoAh6DfNYKB8aUlWdrt
DnxE7S4YM4CgeEPIleGL/q9kmwZJfFNdM42cVoXdrheyrBCxf+jYqBw3zWIqdfmm
k7GPAVo6uhJGCyRNK86PY0I+7onsxKf4/epTETxsDTFw1RAdLj6hbyaZnWKH69n+
WR6Bhot/CtallVCNZApsVjfifkADRA==
=hDIx
-----END PGP SIGNATURE-----

--KTDsgjxbEoEJOa6J--

