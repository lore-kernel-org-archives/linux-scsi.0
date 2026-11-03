Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719131;
	b=tHgLfxBqB3OVYSTbTVuR4b30dEoUnAL9GiPZBjsGtxWP2LmCOdyhnzDuzw8aV67qxJu+
	 OqvR1pzkDbvj/YnTPMoUc60nlk58kn79UuOdMJh9+ou8w+1y+dwdqijQeIm991OtVu+Rq
	 ePKC0NuCDvbQSaM1GB988tNCH7eMLeLntboAGrthjNN/R7nxteb05QTlnEFTr9U/zkC+R
	 yAofY4FgyroyA8LcXBIsqC01SveaM/mDc7o8h4Ca3RfZ/aTSnnQgBuYTD7ahBdpibSReC
	 ShxH68CuHuA7ekWNzdEbt+mXajVcTkQ02osCyp7a3B258cqyLDOPIFrS0VSfOlOHWWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719131;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Bc8aT4Z6get1K0vbpp5ygtanM/hIwI+PelNNb0VgB7c=;
	b=mtXPuqtX4jmWHuPTnUJp5WMiDcrBAjULAoqzcagKStFaOzHRViFtmNFsPL5lnTuXAdgc
	 osWYd/7r9GUgW0uzvvmr0aEW9VXh772nO5GGWe8W/vLHf9OpzKXX+z0kL5G1R/D75+6GT
	 Xr2LsdliHD6AeBI+95m562i5YosYCaUpcFluESpI9nR9hBlPJFtpYd1ISPGU7Fv0jJeim
	 FYtChRzTwfc+ESh/hXpdUSWiSDsumM+PjTYTSu1iVE/7DQ8c2L4X5hQ42RzUSAMYtUwgO
	 j84EL7wmu9afc5BudIIky0Qf9u3/sdU27piGNpxus5M7fI5z/VNSC3ZhylQOVjkMvew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CoJeH/FT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EB2606B258;
	Tue,  3 Nov 2026 15:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CoJeH/FT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856681F0093A;
	Tue,  3 Nov 2026 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719130;
	bh=Bc8aT4Z6get1K0vbpp5ygtanM/hIwI+PelNNb0VgB7c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CoJeH/FTtYurhrEu7pHCjreAy8kglbRPwM3Bp2MFbNXs5sfimskiQ6GdFaw2b46h5
	 LFYZjIjC0HLk9VtZElPrV+LCrvrtO/TXriYCzcHxI7ww7m4DuMtGSua9gCijZ8ag5C
	 C1QyPEjg//XpCtccxJ83qTFkU2bPqiwCZUATJ82pjvzmj0HhclIwZdtkBZ4X0D4FpB
	 W2kjXVSW4Jh+gJKkh7n8hluL4QKxxLPc9zkayoPnR79tHeS7TL9oS5+LArhquuyOcO
	 R0f20W9hUcQSALMEMf5u4F5ldJdbIIx8/qJHUPE3ePz+MiGIzk37ns/uj3hE88ZoNC
	 wd/gwuy246nxg==
Message-ID: <sashiko-outbox-195591@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 11/23] selftests/proc: check that a faulting writer
 doesn't hold up removal
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
In-Reply-To: <20261102-work-procfs-drivers-v1-11-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-11-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:48 +0000
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
- [Medium] selftests/proc: fail and leak scsi_debug host without CONFIG_SCS=
I_PROC_FS
--

commit d0cceed0cde591b286c7977ad630183fc653ded2
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that a faulting writer doesn't hold up removal

This commit adds a procfs selftest that uses userfaultfd and scsi_debug to
verify that a writer faulting during copy-in does not block removal of a
/proc/scsi/scsi_debug/<host> entry and fails with -EIO once the fault is
resolved.

> diff --git a/tools/testing/selftests/proc/proc-remove-slow-writer.c b/too=
ls/testing/selftests/proc/proc-remove-slow-writer.c
> new file mode 100644
> index 0000000000000..f69ca75ba87cb
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-remove-slow-writer.c
> @@ -0,0 +1,203 @@

[ ... ]

> +/* the numbers of the hosts in /proc/scsi/scsi_debug as a bitmap */
> +static int list_hosts(unsigned long *hosts)
> +{
> +	struct dirent *d;
> +	DIR *dir;
> +
> +	memset(hosts, 0, MAX_HOSTS / 8);
> +	dir =3D opendir(HOST_DIR);
> +	if (!dir)
> +		/* the directory comes with the first host and goes with the last */
> +		return errno =3D=3D ENOENT ? 0 : -errno;

[ ... ]

> +FIXTURE_SETUP(host)
> +{
> +	unsigned long before[MAX_HOSTS / HOST_BITS];
> +	unsigned long after[MAX_HOSTS / HOST_BITS];
> +
> +	self->host =3D -1;
> +	if (access(ADD_HOST, W_OK) && system("modprobe -q scsi_debug add_host=
=3D0"))
> +		SKIP(return, "no scsi_debug");
> +	if (access(ADD_HOST, W_OK))
> +		SKIP(return, ADD_HOST ": %s", strerror(errno));
> +
> +	/* host numbers are reused, so look for the one that's new */
> +	ASSERT_EQ(list_hosts(before), 0);
> +	ASSERT_EQ(add_host(1), 0);
> +	ASSERT_EQ(list_hosts(after), 0);
> +	self->host =3D new_host(before, after);
> +	ASSERT_GE(self->host, 0);
> +	snprintf(self->path, sizeof(self->path), HOST_DIR "/%d", self->host);
> +}
> +
> +FIXTURE_TEARDOWN(host)
> +{
> +	if (self->host >=3D 0 && !access(self->path, F_OK))
> +		add_host(-1);
> +}

[Severity: Medium]
What happens if the test runs on a kernel where scsi_debug is available
(CONFIG_SCSI_DEBUG is enabled), but CONFIG_SCSI_PROC_FS is disabled?

The sysfs attribute /sys/bus/pseudo/drivers/scsi_debug/add_host is still
present and writable without CONFIG_SCSI_PROC_FS, while /proc/scsi is never
created. In FIXTURE_SETUP(host), list_hosts(before) sees ENOENT on
/proc/scsi/scsi_debug and returns 0, add_host(1) creates a new scsi_debug
host in the kernel, and list_hosts(after) still sees ENOENT and returns 0
with an empty bitmap.

As a result, new_host(before, after) returns -1 and ASSERT_GE(self->host, 0)
fails the test instead of skipping for the missing prerequisite. Because
FIXTURE_SETUP(host) aborts with self->host still set to -1, the newly
created scsi_debug host is never removed by add_host(-1) and remains leaked.

Should FIXTURE_SETUP(host) check that /proc/scsi exists and skip before
calling add_host(1)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D11
