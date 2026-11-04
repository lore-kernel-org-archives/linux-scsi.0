Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784441;
	b=yqPjaBWfxJ5D1HDeDq1dXE2CQEDzFFIg7kRzdMMJ/JeCPPBo+pLu7B2rSh4mEhaHWBMO
	 Zi5kCYk825wBrCdX0NlgtthGhYbMHOZjFkGRLj5L8fCx/mZuKX7iBWOSjogxXXgJ2mFDS
	 iNeiO6FEhoSaNam/Ku9dYZjAi9DOFEcx5KMxUG+lsOtzKC1DMHfDSXkYeorq9yHAs8yKZ
	 IVU2xnUboev0+5QgtE9YsYhpvVLDov7GZqXYQdwcVRkFXIgEAdmcH1Bj3NLF3k3DhS2S1
	 wPnPhKWgCH5yx1vxF/rlmhp3mTwOf9qv0RNTC9riroLOAwbRTDZGfRMEOiMhKznRtDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784441;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=pha1RY94GjOtnqXrQOQE3qKs4iPAcIL8wQlgIsnD1VI=;
	b=GdlYm1Mf7OH0RiIW3oqc5/TiqEeQT3peJqcNSt5XyoOK7uOb2OPLgSBTVQB1LHAYW3A8
	 5HRBPm63Jfn/53F0ue6M1Z62Q4j3Ax/WJLj+5OBe6zW4rrkS61tuXRMPjIPypwd7zgaco
	 iGVooeND/a3/3lUcF5aa35bXR0hvK750vdxIqXFqigZFbBVUAsrLLXl7FOZ4X0NvM15/Z
	 riu0kwIb2IGRKdCNDdvOoo1xkyIMN/fXLfJ1dF2x55NsX2GsCOH/KjFnmCPEvzg9jk0CW
	 Cn9oupJvq3m8riJK6+GsjgKzBmhd+XDV9xxKeT5EQzrEQBCkbO0BBZbiaB1T+OWHu4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKMrkOmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76BD606D807;
	Wed,  4 Nov 2026 09:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKMrkOmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48201F000C1;
	Wed,  4 Nov 2026 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784440;
	bh=pha1RY94GjOtnqXrQOQE3qKs4iPAcIL8wQlgIsnD1VI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hKMrkOmtm3B2gZiQeO5JvnZ9p2ma/4Ab4QoV2RY1r26cux4zCCLh9wEH2c33BbHXK
	 fbNgj5kWSSvaYoEB4LaR958tQgbKkBQGFEq4mxLA85jgB1KOgLoszMSGVrY9Ha931r
	 D0hMpbsmsCVo3Bmo207nmKQT+W9saDNTG/2QCtQUHOWdxFm2doY6iFV0wGD7GNxdFv
	 FmgbHDeh91BIDzv96YPjHlswJc8awRukjfsVnSPjYTrsCRqLuc7lscOjkrPunvesMJ
	 Tjwc/nSfJXhQ01Nzv2q6cSJ99acGT39x8EGT/eIVENZ4EHlmNUtg6FDEG8FGp/Kj5W
	 DRZXkXKQhuqlg==
Date: Wed, 4 Nov 2026 10:27:08 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 13/16] proc: let procfs copy out reads that don't go
 through seq_file
Message-ID: <20261104-weswegen-magen-gezaubert-373ca765d28c@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-13-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195540@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195540@kernel.org>

On Tue, Nov 03, 2026 at 03:01:30PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] proc: define and initialize __free(kvfree) variable buf in one statement in pde_read_buf()

Intentional.
