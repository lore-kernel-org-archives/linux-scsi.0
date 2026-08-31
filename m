Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E83F4CCDC6
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 20:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788208902; cv=none; b=WVURuWeBtpaLuFS2Ki4cn8NHFV/mYWh3q7WcZuUVayZ9JmhoK2duq4OpAKVEDLA6x1z85fg0CCLBUU4M17qDZ5jXBDuEVmhCqJxNKHFjjxELGlk7QnB3Qz/c8HT1ukhJjVv8aiqiQBKuflHq+47w23bzr3OiB9tigCwGtedgcm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788208902; c=relaxed/simple;
	bh=Dq8pa77QYu4FtzOcsEqpe7mrfDUJV/T42ISJXum+TLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTan4hLkV1qbZLrlj28Jmbm3UioIZNYyjVx56uoi62qyEO1gc9+gNlp1My3qHp74SztK3fu+xnGu+lWrqugtPQmLnqxPTGxYJxRxhiHCedlzdf/FtvhY3lT714Ti1Q/bcMVoLuA4+XgNVAhgMOQHKrhpjLZcaru5wpFN3zp24wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E3WWxGX4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E3WWxGX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788208899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FBf8tymtxI0Ff77El55JqSXxrhFxge67QUGBFyICcSY=;
	b=E3WWxGX4pnyZFgHPxiuCKcG2XrL/00h1QKHDQ6zJ9CVY1NHxyfwXkb4JnKPrvDt5WQPj2Z
	nk3QjpsPPp+51uFfwRuURr41ud7UDlQoWEEcAlYKTuL7xSJSN7JG5nyqFPOKwAfwPuc6JP
	VMD4Hv1xrXQcy4xTkOEvMFpVvLfkGkk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-LJZ1Gc8rNFSY-n7cQqV5mQ-1; Mon,
 31 Aug 2026 16:41:33 -0400
X-MC-Unique: LJZ1Gc8rNFSY-n7cQqV5mQ-1
X-Mimecast-MFC-AGG-ID: LJZ1Gc8rNFSY-n7cQqV5mQ_1788208889
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 979A018D62D3;
	Mon, 31 Aug 2026 20:41:28 +0000 (UTC)
Received: from localhost (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D91BF1956049;
	Mon, 31 Aug 2026 20:41:26 +0000 (UTC)
Date: Mon, 31 Aug 2026 16:41:23 -0400
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
Message-ID: <20260831204122.GC527638@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827184219.GB2137493@google.com>
 <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fyVDnDSsSdEAr9UL"
Content-Disposition: inline
In-Reply-To: <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

--fyVDnDSsSdEAr9UL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 11:37:57PM +0800, Linlin Zhang wrote:
>=20
>=20
> On 8/28/2026 2:42 AM, Eric Biggers wrote:
> > On Thu, Aug 27, 2026 at 09:07:09AM -0700, Linlin Zhang wrote:
> >> From: linlzhan <linlin.zhang@oss.qualcomm.com>
> >>
> >> Current virtio-blk does not provide a mechanism for a guest to
> >> program hardware keys or submit encrypted I/O using pre-programmed
> >> keyslots.  It drops the crypto context when issuing a bio request
> >> to the virtio-blk queue, preventing inline-encryption-based FBE
> >> on virtio block devices.
> >>
> >> This series enables File-Based Encryption in guest VMs on Qualcomm
> >> GVM platforms where the ICE inline encryption hardware is shared
> >> between the host and guests.  In this environment the guest kernel
> >> has no access to the ICE hardware directly; it supplies a virtual
> >> keyslot index and data unit number with each encrypted I/O request
> >> via VIRTIO_BLK_F_INLINE_ENCRYPTION, and the host must translate the
> >> virtual slot to a physical ICE keyslot and submit the bio =E2=80=94 wi=
thout
> >> transferring raw key material across the VM boundary.
> >=20
> > This seems to be designed incorrectly by not making virtio-blk itself
> > support key programming and eviction.  That complicates things
> > significantly by then having to handle the key programming and eviction
> > out-of-band using Qualcomm-specific SCM calls.  It also means that
> > adding other implementations of this would be very difficult.
> >=20
> > There are some claims that not transmitting keys across the VM boundary
> > is desirable.  But that doesn't seem meaningful, given that all the I/O
> > is transmitted across that boundary in plaintext anyway, and also it
> > seems that hardware-wrapped keys will be supported too.
> >=20
> > Please make virtio-blk support the key programming, eviction, and
> > HW-wrapped key management operations that are needed for this to work.
> >=20
> > - Eric
>=20
> Thanks for your comments!
>=20
> Not making virtio-blk itself support key programming and eviction is
> something done deliberately. Based on that HW-wrapped key management
> operations are also handled in the out-of-band path.
>=20
> There are bellow 2 approaches I investigated to let virtio-blk programming
> the key.
>=20
>   1. virtio_blk implements blk_crypto_ll_ops interfaces, including program
>      key and evict key interfaces.(Same to 'the virtio-blk interface stan=
dardized
>      blk_crypto_ll_ops requests' mentioned by Stefan in the virtio SPEC t=
hread)
>=20
>      The guest's block crypto profile manages the keyslot in virtual slot
>      format in this scenario.
>=20
>       - block crypto key and virt_slot index it passed to the hypervisor's
>        (EL2) device emulation (QEMU, using QEMU in the following) which
>        runs in userspace of the host. Besides of transferring the virtual
>        slot to the physical slot, a programming block crypto key UAPI need
>        be added. Follow current blk-crypto design, it may be like
>        BLKCRYPTOGENERATEKEY. I thought this results in a security risk th=
at
>        allows userspace process a key into a key slot.
>=20
>      - For key eviction, it's similar to above key programming handling, =
also
>        need a key eviction in blk IOCTLs, but leads to the security risk
>        that allow userspace client to evict a key in a key slot.

Yes, userspace shouldn't have access to the entire physical key slot
range. The host kernel or other VMs may need key slots and an untrusted
QEMU process must not be able to modify those key slots or use them for
I/O.

The uapi design should include a solution for this. For example, there
could be an ioctl like BLKCRYPTOSEALKEYS that permanently restricts the
key range on this block device file descriptor and cannot be undone.
Libvirt or other management tooling would call this ioctl with
CAP_SYS_ADMIN before passing the file descriptor when launching QEMU
without CAP_SYS_ADMIN. This prevents QEMU from ever having access to the
full physical key range.

Just an idea. Those familiar with blk-crypto may have a better one. It
seems likely that we can find a design that matches the level of
security of the out-of-band approach.

>=20
>     virt_slot, DUN and DUSize is appended to virtblk request during crypto
>     I/O.
>=20
>   2. virtio_blk implements blk_crypto_ll_ops interfaces, excluding program
>      key and evict key interfaces.
>=20
>      The guest's block crypto profile doesn't manage keyslot for the gues=
t,
>      the host's block crypto profile manages keyslot for both the guest a=
nd
>      the host. The trigger of key programming operation is moved from the
>      guest to the host.
>=20
>        - The whole block crypto key (key size, key bytes, blk_crypto_conf=
ig)
>          and DUN are appended to the virtblk request during IO, a little
>          high payload.
>=20
>          The backend parses the crypto message in the virtio queue and
>          construct a block crypto key and DUN for the bio_crypto_ctx
>          set to the BIO. So that the IO flow in the host can program
>          the key.=20
>=20
>          The question is that the blk-crypto-profile distinguishs the
>          block crypto key via the key's address. But the host has
>          different key addresses for the programming and eviction key
>          operations of the same block crypto key from GVM, because the
>          key is re-constructed in the host for the key program and
>          eviction operations.=20
>=20
>          To fix it, the approach I thought is maintaining a new key
>          hash table in the backend, and comparing the block crypto key
>          content and DUN parsed from virtio queue with that in the key
>          hash table.=20
>          My major concern is that this need keep the keys synchronization
>          b/w this new hash table and the blk-crypto-profile's hash table
>          carefully, avoiding that key is still present in the
>          blk-crypto-profile's hash table, but removed in backend hash
>          table. Another point is that the whole block crypto key and
>          DUN are appended into virtio block request per crypto I/O.

This sounds like an approach that skips key programming and instead
sends the keys along with each I/O request. The device implementation is
responsible for managing key slots on the physical ICE. My main concern
with this would be whether the blk_crypto_ll_ops semantics can be
faithfully replicated (e.g. error reporting) without explicit key
programming operations.

Stefan

>=20
>        - For key eviction, adding a key eviction in blk IOCTLs allows
>          userspace client to evict a key in a key slot. I thought this
>          is a security concern.
>=20
>=20
>      This option doesn't need map virt_slot to physical one.
>=20
>=20
> Taking all the above into account, I made a compromise to implement
> blk_crypto_ll_ops interfaces in a out-of-band path, which lets the virtio
> blk only need focus on the data path. I agree that it is complex than
> the second option mentioned in the above, but small payload (only
> virt_slot, DUN, DUSize) in the virtio block request and no security
> risk of key eviction from userspace.
>=20
>=20
> I would like to hear your thoughts about the above and am appreciated
> if you could share your insights about the design of inline
> encryption in virtio block.
>=20
> Regards,
> Linlin
>=20
>=20
>=20

--fyVDnDSsSdEAr9UL
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqV5vIACgkQnKSrs4Gr
c8gJGwf/X6WcnpoBBjltPgKk5PVTutsk6+tVnODwUPuBfzPYZS23OnnTrZnkESve
L0LIFS850Ih36UbOeC+S3F3WOTD2SxvRSZYj7NlMgYgnA6oKEvISUlea4xJnUldR
w3kQQJGLtOAU7oe7scnA3ZZp9Zx0bsbOVx2cUiDK2OUwcg6oX+gZJttPipSWYagw
UNYCyqu9QwTexHrptgCl0RKJ3f+58eSdND/GvfUROzE8eVFkKIAE/zgWdpyhCcOC
ic6padtYknFeGCnlvkugw7gz0caxHeZgu+pLDgdL42QpLkEs/zbSxPUaAY/LBfGD
bMSh/nUH9ycIif2dGGD8ciVGcT9CXw==
=Sqz3
-----END PGP SIGNATURE-----

--fyVDnDSsSdEAr9UL--

