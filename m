Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05B849F12A
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288460; cv=none; b=ZH1pt0rOWJljfu1mWWmEkk3ZsOh4DPkDgISzxOIJNyNNeOptxj4BTvrCn/0HavciQTuIZXG7qHS3rVM8JLyHz0sQg8DVhtkMbow8Q0+PLnBvcFvexw+Sf8WiO9azTq4YlTsiASRK1CSqnV2C4CNA1HqlS4fM4PkWjgVayrUgzzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288460; c=relaxed/simple;
	bh=37Jyf2Og03HL2RNpJK6fCzQGF/A6jmxwa298hL04IW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=raWyx7sqVszBwSp4F3dUrHwxh1W/H3LWAEPiwiNSfDH2iyuV1ljF8LeplY3gDLyZH1QunSWg7eWaF19OxAOVhqZf6YlVb26pVKIzmIxiC5QjUM3DdVpSo32RDzEm6U3L5cg7r2ywH+T9mHPPVmrKipbjTKwjqA1ACpjwYDBrmLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DMavSJuN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMavSJuN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788288456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4yzqurxJCh3TbmATixRFTedMTmqRz4G3gTD9h2e+jg=;
	b=DMavSJuNKlu4XelZLbhIUOexi2A/sWBiKwMih5vP2RDySa4jxKs7mXLQxum4uNAKGkjb3Q
	9Yk4rry7hdZkCRv7FNjuqEcWr40Ik30kF6dZDsAQ/hWCzo3HSJt2e5tRf5CrkWn4wRCaqN
	ficJ013TghjSn+/K68xSNKCU2Rl/4r8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-28-sVJaRTP2MUSGMiEowFh_EA-1; Tue,
 01 Sept 2026 14:47:33 -0400
X-MC-Unique: sVJaRTP2MUSGMiEowFh_EA-1
X-Mimecast-MFC-AGG-ID: sVJaRTP2MUSGMiEowFh_EA_1788288449
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 185B7180133D;
	Tue,  1 Sep 2026 18:47:28 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E83B21955F09;
	Tue,  1 Sep 2026 18:47:25 +0000 (UTC)
Date: Tue, 1 Sep 2026 14:47:24 -0400
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
Message-ID: <20260901184724.GD527638@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827184219.GB2137493@google.com>
 <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
 <20260831204122.GC527638@fedora>
 <71fcde90-3d26-4f34-8908-7a0947d8ceb9@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="le1+zzq4kRSwMP92"
Content-Disposition: inline
In-Reply-To: <71fcde90-3d26-4f34-8908-7a0947d8ceb9@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

--le1+zzq4kRSwMP92
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 01, 2026 at 05:21:53PM +0800, Linlin Zhang wrote:
>=20
>=20
> On 9/1/2026 4:41 AM, Stefan Hajnoczi wrote:
> > On Fri, Aug 28, 2026 at 11:37:57PM +0800, Linlin Zhang wrote:
> >>
> >>
> >> On 8/28/2026 2:42 AM, Eric Biggers wrote:
> >>> On Thu, Aug 27, 2026 at 09:07:09AM -0700, Linlin Zhang wrote:
> >>>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
> >>>>
> >>>> Current virtio-blk does not provide a mechanism for a guest to
> >>>> program hardware keys or submit encrypted I/O using pre-programmed
> >>>> keyslots.  It drops the crypto context when issuing a bio request
> >>>> to the virtio-blk queue, preventing inline-encryption-based FBE
> >>>> on virtio block devices.
> >>>>
> >>>> This series enables File-Based Encryption in guest VMs on Qualcomm
> >>>> GVM platforms where the ICE inline encryption hardware is shared
> >>>> between the host and guests.  In this environment the guest kernel
> >>>> has no access to the ICE hardware directly; it supplies a virtual
> >>>> keyslot index and data unit number with each encrypted I/O request
> >>>> via VIRTIO_BLK_F_INLINE_ENCRYPTION, and the host must translate the
> >>>> virtual slot to a physical ICE keyslot and submit the bio =E2=80=94 =
without
> >>>> transferring raw key material across the VM boundary.
> >>>
> >>> This seems to be designed incorrectly by not making virtio-blk itself
> >>> support key programming and eviction.  That complicates things
> >>> significantly by then having to handle the key programming and evicti=
on
> >>> out-of-band using Qualcomm-specific SCM calls.  It also means that
> >>> adding other implementations of this would be very difficult.
> >>>
> >>> There are some claims that not transmitting keys across the VM bounda=
ry
> >>> is desirable.  But that doesn't seem meaningful, given that all the I=
/O
> >>> is transmitted across that boundary in plaintext anyway, and also it
> >>> seems that hardware-wrapped keys will be supported too.
> >>>
> >>> Please make virtio-blk support the key programming, eviction, and
> >>> HW-wrapped key management operations that are needed for this to work.
> >>>
> >>> - Eric
> >>
> >> Thanks for your comments!
> >>
> >> Not making virtio-blk itself support key programming and eviction is
> >> something done deliberately. Based on that HW-wrapped key management
> >> operations are also handled in the out-of-band path.
> >>
> >> There are bellow 2 approaches I investigated to let virtio-blk program=
ming
> >> the key.
> >>
> >>   1. virtio_blk implements blk_crypto_ll_ops interfaces, including pro=
gram
> >>      key and evict key interfaces.(Same to 'the virtio-blk interface s=
tandardized
> >>      blk_crypto_ll_ops requests' mentioned by Stefan in the virtio SPE=
C thread)
> >>
> >>      The guest's block crypto profile manages the keyslot in virtual s=
lot
> >>      format in this scenario.
> >>
> >>       - block crypto key and virt_slot index it passed to the hypervis=
or's
> >>        (EL2) device emulation (QEMU, using QEMU in the following) which
> >>        runs in userspace of the host. Besides of transferring the virt=
ual
> >>        slot to the physical slot, a programming block crypto key UAPI =
need
> >>        be added. Follow current blk-crypto design, it may be like
> >>        BLKCRYPTOGENERATEKEY. I thought this results in a security risk=
 that
> >>        allows userspace process a key into a key slot.
> >>
> >>      - For key eviction, it's similar to above key programming handlin=
g, also
> >>        need a key eviction in blk IOCTLs, but leads to the security ri=
sk
> >>        that allow userspace client to evict a key in a key slot.
> >=20
> > Yes, userspace shouldn't have access to the entire physical key slot
> > range. The host kernel or other VMs may need key slots and an untrusted
> > QEMU process must not be able to modify those key slots or use them for
> > I/O.
> >=20
> > The uapi design should include a solution for this. For example, there
> > could be an ioctl like BLKCRYPTOSEALKEYS that permanently restricts the
> > key range on this block device file descriptor and cannot be undone.
> > Libvirt or other management tooling would call this ioctl with
> > CAP_SYS_ADMIN before passing the file descriptor when launching QEMU
> > without CAP_SYS_ADMIN. This prevents QEMU from ever having access to the
> > full physical key range.
> >=20
> > Just an idea. Those familiar with blk-crypto may have a better one. It
> > seems likely that we can find a design that matches the level of
> > security of the out-of-band approach.
>=20
> Thanks for your comment!
>=20
> Eric mentioned a proposal that each virtio block device has its own *virt=
ual*
> keyslots in the host, which is not static partitioning of the physical ke=
yslots.
> I have concerns about the new key programing UAPI and 2 VM exits per encr=
ypted
> I/O. I'll confirm with Eric if that needs be considered and if we need pa=
ss
> through the crypto to the host blk-crypto-profile (which means the max sl=
ots
> of blk-crypto-profile in the guest is 0, and virtio block driver only doe=
sn't
> implement the key program interface in blk_crypto_ll_ops).
>=20
> >=20
> >>
> >>     virt_slot, DUN and DUSize is appended to virtblk request during cr=
ypto
> >>     I/O.
> >>
> >>   2. virtio_blk implements blk_crypto_ll_ops interfaces, excluding pro=
gram
> >>      key and evict key interfaces.
> >>
> >>      The guest's block crypto profile doesn't manage keyslot for the g=
uest,
> >>      the host's block crypto profile manages keyslot for both the gues=
t and
> >>      the host. The trigger of key programming operation is moved from =
the
> >>      guest to the host.
> >>
> >>        - The whole block crypto key (key size, key bytes, blk_crypto_c=
onfig)
> >>          and DUN are appended to the virtblk request during IO, a litt=
le
> >>          high payload.
> >>
> >>          The backend parses the crypto message in the virtio queue and
> >>          construct a block crypto key and DUN for the bio_crypto_ctx
> >>          set to the BIO. So that the IO flow in the host can program
> >>          the key.=20
> >>
> >>          The question is that the blk-crypto-profile distinguishs the
> >>          block crypto key via the key's address. But the host has
> >>          different key addresses for the programming and eviction key
> >>          operations of the same block crypto key from GVM, because the
> >>          key is re-constructed in the host for the key program and
> >>          eviction operations.=20
> >>
> >>          To fix it, the approach I thought is maintaining a new key
> >>          hash table in the backend, and comparing the block crypto key
> >>          content and DUN parsed from virtio queue with that in the key
> >>          hash table.=20
> >>          My major concern is that this need keep the keys synchronizat=
ion
> >>          b/w this new hash table and the blk-crypto-profile's hash tab=
le
> >>          carefully, avoiding that key is still present in the
> >>          blk-crypto-profile's hash table, but removed in backend hash
> >>          table. Another point is that the whole block crypto key and
> >>          DUN are appended into virtio block request per crypto I/O.
> >=20
> > This sounds like an approach that skips key programming and instead
> > sends the keys along with each I/O request. The device implementation is
> > responsible for managing key slots on the physical ICE. My main concern
> > with this would be whether the blk_crypto_ll_ops semantics can be
> > faithfully replicated (e.g. error reporting) without explicit key
> > programming operations.
> >=20
> > Stefan
>=20
> You're right. When the virtio-blk device processes encrypted I/O, it
> would be responsible for extracting the blk_crypto_key and DUN from the
> virtqueue and attaching them to the bio (via bio_crypt_set_ctx()). The
> existing keyslot management logic in the block layer would then handle
> physical keyslot allocation and waiting as needed, so the rest of the
> blk-crypto infrastructure should continue to work unchanged.
>=20
> Regarding your concern, there is already a somewhat similar
> implementation in the device-mapper layer (
> dm_table_construct_crypto_profile() implements a passthrough
> blk_crypto_ll_ops profile. See
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/md/dm-table.c?h=3Dv7.3-rc1
> ).
>=20
> Based on my current understanding, I don't see any obvious
> architectural issues with this approach. However, I may be missing
> something, so I'd appreciate any feedback if you see flaws in the
> design or potential problems that should be taken into account.

I don't have enough blk-crypto knowledge to give good feedback on the
details of this approach, but Eric and others could help with that.

Stefan

--le1+zzq4kRSwMP92
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqXHbwACgkQnKSrs4Gr
c8gZXAgAyk+ykFlJgnNUvYAfetdqn3qvfOcLaR2xVwjxEk0NzBDFP/HZW/wgWzwe
ugHuAyKQ44stXShQ8DVuF5yalv17oZSE2LgxtKfIH/eHUSzCA7S08xRAXbZci9cn
0ZcZ0WfXv6EroR6pGugfa5A4NjLHAONVYl9/z8jr1nStq8CqzDui1K5SLQjzr5Ou
vVPsa26fU5+2U944ctg1Fw+3cjIndA5krRUN4DvNlmY3qseFoves6mlc271wzus7
RpN1+wGrBVa6nb5WMF31dgoAm5TcFOXAX98RnjnyOzZgD5gwlG28LH6qM/POvCbC
HwYdUNvLgBP2bm9xfMTBPXTXnK+Ryw==
=1s2S
-----END PGP SIGNATURE-----

--le1+zzq4kRSwMP92--

