Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717324;
	b=NtgDEEfWyQ8//lySdtVyIlOq14Cer3+hyLTapmpWxZso/bdZoICJQhTCM4qRtMTsHpfK
	 u6egAQauvHGBEDxgC+gNZEnT76aTkgxG9OrrxKrCJ4J6IY4F4EEb7J0W0j7fPiVoOSMRR
	 EBZmNVG4Bl7cHPwhXktLZU3R3mm45GqAobeUOLbqmHBcOwMOrY0SH1d2v1+/nJa5Kla7Y
	 2wY6RizI9GWc3R32gtSGFaCcDwJcw4EjvNLi6hRqGBvOPxH5BKaXSLktLjGRyr0A61yEM
	 r/ZnjxY0Wz0vNiPCvcTYDlXQ2AN/CBlzGghOL2HmMxRUhJc7w2gt8j6Vo5rXqWIli4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717324;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ED7DfxpP0C+3U90pEocB+hyI9bQg1Q/rMH3eRirphfo=;
	b=2gp182rsppAKGIP8LOl38vsJOB9aSxBJ0KM9RAlAablyXuPC/h+xK7R/zX6L8RmsYVir
	 S5/I1M9c2AP/WORuTPaz5O0cgeoxZRj3RZbJxhv4ehizt0iRlv9VnvBoXNal7Vq0i/mSp
	 /29+814sTB95qOg5kBTpQPeC9v1IbETxBiHJ6f/CAxC7K7pdU4L4HaW6vaR2yHUyXjSct
	 Ge7uuZ+JZ5WojNjp74qnR9pMAPsLtaX2fmfqndmY7nYiJ5M0TXLv/9QIj3ZJF5uv4B+Nw
	 OgV9JGzv0dGmxOaZSyU00JbYOG+NwiZuKTra9RMSJf6Uv48mTDO+jUDste7VIxEQ8PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ljtTrKrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CA0606B243;
	Tue,  3 Nov 2026 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ljtTrKrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4781F000C1;
	Tue,  3 Nov 2026 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717323;
	bh=ED7DfxpP0C+3U90pEocB+hyI9bQg1Q/rMH3eRirphfo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ljtTrKrzjwh9bmTgB/C4QRv4lPNCmDXb0oGrnMVLkXCeEPfpYMq2XwmiskAtwQlsK
	 oR+9Ko1Pl3b/OoYpR0JTmvi3u4DF0d6V6KQt841p42E0GJwXEsp4zexEhStpCZGKot
	 pkJLfSa1M3AMrCCthqht9MFhgLn+Yh9p8Octt6Ghr3uXvq/2JhHMONBnt+SmQKq34t
	 I08bZ2ixHGY9RHmh/bJlC1bBT/o22sClyAftWhJVYpDvJ2AVldTnb++uYWhQYb014k
	 kzsT0ppwzb8VRvjDyZBpKuGuVZJ8s3MbvTiItwdFL05JRwkjFnFrqSpfLfwR7+VZN8
	 /LmgWCZM8tKSQ==
Message-ID: <sashiko-outbox-195508@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 36/38] selftests/proc: check that faulting sysctl
 accesses don't hold up removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-36-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-36-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:40 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/proc: getdents test faults in dir_emit_dots() before e=
ntry lookup
--

commit fc0ab3f791b6ab04b43d13e015f97882092d54fc
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that faulting sysctl accesses don't hold up removal

This commit adds a proc selftest using userfaultfd and a tun device in a new
network namespace to verify that page faults during read(), write(), and
getdents64() on /proc/sys do not block sysctl table unregistration.

> diff --git a/tools/testing/selftests/proc/proc-remove-slow-sysctl.c b/too=
ls/testing/selftests/proc/proc-remove-slow-sysctl.c
> new file mode 100644
> index 0000000000000..e1b1fd19a07ab
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-remove-slow-sysctl.c
> @@ -0,0 +1,213 @@

[ ... ]

> +TEST_F(proc_sys_slow, getdents)
> +{
> +	struct worker w =3D {
> +		.op	=3D SYSCTL_GETDENTS,
> +		.len	=3D BUF_PAGES * self->psz,
> +	};
> +
> +	w.fd =3D open(CONF_PATH, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
> +	ASSERT_GE(w.fd, 0);
> +	stall_and_remove(_metadata, self, &w);
> +
> +	/* What was looked up before the removal still arrives, then nothing. */
> +	EXPECT_GT(w.ret, 0);

[Severity: Medium]
Does TEST_F(proc_sys_slow, getdents) in
tools/testing/selftests/proc/proc-remove-slow-sysctl.c actually fault on a
looked-up sysctl entry, or does it fault inside dir_emit_dots() before any
entry is looked up?

In FIXTURE_SETUP(proc_sys_slow), only the first page of self->buf is
registered with userfaultfd. When TEST_F(proc_sys_slow, getdents) opens
CONF_PATH, w.fd starts at file position 0 and is passed directly to
stall_and_remove() -> work_thread() -> getdents64().

In fs/proc/proc_sysctl.c:proc_sys_readdir(), dir_emit_dots() runs before
sysctl_dir_next():

fs/proc/proc_sysctl.c:proc_sys_readdir() {
	...
	if (!dir_emit_dots(file, ctx))
		return 0;

	if (cursor && cursor->pos =3D=3D ctx->pos) {
		err =3D sysctl_dir_next(ctl_dir, &d, cursor->name, cursor->len);
	} else {
		loff_t pos =3D 2;

		err =3D sysctl_dir_next(ctl_dir, &d, NULL, 0);
	...
}

Because ctx->pos is 0, dir_emit_dots() writes "." at the start of self->buf
and triggers the single userfaultfd page fault before sysctl_dir_next() is
called and while d.head is still NULL.

While work_thread() is sleeping in dir_emit_dots(), stall_and_remove() clos=
es
self->tun (which unregisters CONF_PATH and marks ctl_dir->header as
unregistering) and resolves the fault on the first page with UFFDIO_ZEROPAG=
E.
When work_thread() resumes, dir_emit_dots() finishes emitting "." and "..",
sysctl_dir_next() immediately returns -ENOENT, and getdents64() returns the
48 bytes from the dot entries without ever entering the entry-emission loop.

Should TEST_F(proc_sys_slow, getdents) advance w.fd past "." and ".." first
(for example with lseek(w.fd, 2, SEEK_SET)) before calling stall_and_remove=
()
so the fault occurs in dir_emit() after sysctl_dir_next() and
proc_sys_fill_dirent() have looked up an entry?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D36
