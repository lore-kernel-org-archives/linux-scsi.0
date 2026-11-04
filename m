Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784049;
	b=LrMvFjHf8HoLCnOS71QtmFONYcNjyIy6Xslk+cYUw5p24Nrc/0JygcI5OOui5sbfrG4z
	 LFP5cvvXmdhLB/Rm5aGiMjyjlHDQWxnhSSdWqdxTqn7hSNW6A/+LvcOM+yuRxb3Zy9z2b
	 PUdhfmwtWzzzxlFjM6Q2fFGm78Qn8d/NCiAjBTWDM2RMP6P8rvHtVSRQpw1K5qkvX64nF
	 D3pNT+ZHaWFHZwdrcMOd6Cw2FXZ6D0YjrhuKk4KnGFqW9+VjBWrKDtKLmz3cmFUdcOtZj
	 HVQf1IO4BWppdH40BtSoVvrS2V5x+qpRlNBJm1st4W/u7pm/l99GVrIAc+4/cW+O2Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784049;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=O/cNspokMh0UNXOA6wOkvv54jlnPVAhKOKNo3zScL80=;
	b=Fud28JmyJmVj2PWjXvjOLegk+EOWcBZPD+rn5kdJPg/RyiUacz9pAG2M+t7pJu9OFq3G
	 qfSV5ob3R/h5iPvdUj3oXHUadstR4T92mgUnlnx6BqgSk+3nsM8y0ar2CLwR3eyLLyCck
	 c4dsdTAwb3mit2pReaU8ihzoQR9759Id7R4aP3C5njIVbdG5FPI1Fjn15QytfYRE90ci5
	 ZAYPfM3T1niTrIWLiOLp/V6rAg+y9WvuiX5hp059fBkURk5oLH/asL+j+7Cqq42NWBLSk
	 17mAW4wDue/qsHWWxETlFZeFYAi+9qPC2njS838qLFhCmI/OSIEske+z1NPIi9hpkDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BcEaKSaA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366F8606A326;
	Wed,  4 Nov 2026 09:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BcEaKSaA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884BF1F000C1;
	Wed,  4 Nov 2026 09:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784048;
	bh=O/cNspokMh0UNXOA6wOkvv54jlnPVAhKOKNo3zScL80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BcEaKSaAGlv24CwtAidx4vgcs6qvpVaJft+GsrdUwgsUzcXrxh3uKvNOUoNaojM0u
	 zeaAufJdghxwNsRVYbDAL/xLeKpNsJ3Qayq8R/yEjD/hXG6tybWAoeeY/Tcg+J2REY
	 2VHx7FHMLCTTzYzu20RNN6+W/eGKH3XQSxBPLu21a3FQK4L4xV10mVduwGQuGwRq6Y
	 1A0ZHeMOGLNd3RiETXNw1XPlv0+sn3aHbmYt6VyuIs0KUjdL9KaF/E0tjXUuJZvvKv
	 OzKIqB04C/jh70SwJGTPrT4CcqF9fgN0yPVMCzRgZsEpdaIpp/2cLp+CNRnZLAYstK
	 OnLeMUpNmqPkw==
Date: Wed, 4 Nov 2026 10:20:35 +0100
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
Subject: Re: [PATCH RFC 36/38] selftests/proc: check that faulting sysctl
 accesses don't hold up removal
Message-ID: <20261104-aktionen-endlich-ruhmreich-92f35a0ee397@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-36-59422ed3e465@kernel.org>
 <sashiko-outbox-195508@kernel.org>
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
In-Reply-To: <sashiko-outbox-195508@kernel.org>

On Tue, Nov 03, 2026 at 02:48:40PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] selftests/proc: getdents test faults in dir_emit_dots() before entry lookup

Fixed.
