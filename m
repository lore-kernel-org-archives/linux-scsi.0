Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3312D0C89
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 04:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781065380; cv=none; b=M6G4IIwb+AymvSC7KxFpcjFMj9Z4zS0RgypETgcbDqRh1vKXh5nTzdnep5LU/W9bJ35VsGEE19GtpGvh+Kik8ldaz5XcxmVFeinqgDoFVJiYw1xrQY6XH5yNvN7BM3SzgCbXB8Day8h9ypc8gutkTBmoMahN9W8cAH02wFzd+4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781065380; c=relaxed/simple;
	bh=u9MJanHIU9ofqI3L3XfW6LcD0DmqTSeeLWy/56VnENs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GQwS40xUTen+5fIrWuR2zmHud+f8Wb8ifnwW6LJXxVmeTnjrzd/3ihsB3sLeKecYWNWCKSPSY/Nr1wEhMIHz3SQ7Zvu9+fxh7rnm4fGba+x6IazPfzrxgVn0hLB1oejhn1+FFGHwnPRo2aUPeiIU/dAK8l8DsZg4DPjv23LEW0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=cqAgIo8y; arc=none smtp.client-ip=79.135.106.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="cqAgIo8y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1781065369; x=1781324569;
	bh=DCy3zJISCb+c4W/OQbSo1vWg3TAOf6MV0cZ5ytssApE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=cqAgIo8ykukB+T4cZJMF183Wf2hpS0WpPsQKifjbg4MIDkTi53/QMIdiVkUNr7p+P
	 FoHJ5m76+/SG9qcENsQ6CG4U2LvVTJGibYalDiFd0zFmEzu9UpWQomeebiv64mrQBO
	 rlJQxMDVAPZKIPqj32REWwqI0wCUbi0VnWoboeYRJtAam/mvOCB/AgzGrt1peEPJkv
	 QMYLLJRSZfbfU2SKQgmbHZvOuKPA/ykiGNkoFLSZxfmlf/ZIY8anp19tnfO/dmQWzk
	 /QF8CRDuTzG/k2FXmKCVMRIsc6RWz5r6cs507xGnb2/Y56eL+bD80cCKzDuBB8Mugx
	 J5NGQ0QjSh/+w==
Date: Wed, 10 Jun 2026 04:22:41 +0000
To: "Martin K . Petersen" <martin.petersen@oracle.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mike Christie <michael.christie@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>, John Garry <john.g.garry@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: copy iSCSI ISID before unmapping the PR OUT buffer
Message-ID: <20260610042236.35453-1-hexlabsecurity@proton.me>
In-Reply-To: <6282620112fd9db8224dbf04046dbf24267d0433.camel@HansenPartnership.com>
References: <20260609005858.17504-1-hexlabsecurity@proton.me> <fdb07a39-cf7d-48aa-9e75-1a79dc7ad620@oracle.com> <239dd72a5ee388486f60eff7e6b025d130e08266.camel@HansenPartnership.com> <6b6ebec8-0e92-41bd-8001-0608ee6e804b@oracle.com> <6282620112fd9db8224dbf04046dbf24267d0433.camel@HansenPartnership.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 85afb1269b19ee5e9f96a70ad9b713c9a2935134
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2026-06-09, James Bottomley wrote:
> I was just looking at the multiple error legs in the patched code and
> thinking it's an ideal candidate for a __free() attribute.  If there's
> a way of rearranging the code to keep it longer that you think is more
> readable, by all means do that instead.

I'll keep the mapping in place, which turns out to be the simplest of the
three options: it needs no ownership transfer at all, so neither kfree()
nor __free() comes into it.

The only reason v2 had an iport_ptr to free was that v2 made the parser
allocate.  If the PR-OUT parameter list instead stays mapped, iport_ptr
can remain what it has always been -- a borrowed alias into that buffer --
and v3 is just:

  - drop the early transport_kunmap_data_sg() / buf =3D NULL after the pars=
e;
  - unmap once on the success path, right before "return 0";
  - the existing "if (buf) transport_kunmap_data_sg(cmd)" at out: now
    covers every error leg, because buf is no longer cleared early.

That is -2/+1 lines (plus a comment) in
core_scsi3_emulate_pro_register_and_move() only.
target_core_fabric_lib.c is untouched, and core_scsi3_decode_spec_i_port()
needs no change -- it already uses iport_ptr before its own unmap, so the
loop/free question there does not arise.

On 2026-06-09, John Garry wrote:
> I do notice that there would be regions which we keep spinlocks held
> when this mapping is in place, but I am not sure if that makes a
> difference

It does not.  Holding an already-established kmap/vmap mapping across a
spinlock is fine; what is not allowed is calling kmap()/kunmap() (or
vmap()/vunmap(), which may sleep) while atomic.  In this version both the
map and the unmap happen outside any lock -- the map before
dev_reservation_lock is taken, the unmap after it is dropped (and at out:
after all locks are released).  The only thing done under
dev_reservation_lock is __core_scsi3_locate_pr_reg() reading the ISID
through the mapping, which is an ordinary load.

I re-ran the KASAN A/B for this form on the same CONFIG_KASAN_VMALLOC rig
(6.12.90, 64-bit and 32-bit initiator): unpatched, an 8192-byte (two-page)
REGISTER AND MOVE reports vmalloc-out-of-bounds in strcmp() and the rx
kthread dies; with the patch the same request completes with no report.

v3 follows as a separate posting.

Thanks,
Bryam

