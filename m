Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784087;
	b=aL0LsLVsQDUl8t2kyYSU5MK7zJjUMrpshaGwnxGrVyeXlpIcaEGvg5ufF2j40CuEyxw7
	 iye84AQEU8hT+lbtoMF70Rh0U9UC1jrA0US0XFDl5POHGhIGVk9Xf1shT1yXrZfbdPtWB
	 mlsLN2+fWF8o2K+/vfajhtdE/ZYGHBQCp7Qw7W82xdbG2g9D+0NjujvI0mVY3J/h8Yxwu
	 sKL4oM1c9Xsdt9V455coS41GhwX4VrRM2aFwe6ocvwohdu2gI21kEdhPXGfo12cnGfV8o
	 la07tD5iUhjNb6e3ZawJHgZqtGz1F2gX505FAVviUZjsemfP5QbJSAb1HFiJJCVDiGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784087;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TLWmGN3SfRKJzJtFGqy9xXljoZdTMIGgQAZ0U5pRqZ0=;
	b=0Gn0XyU1/hEbHxhuUDjyv2GM6SMqvq1l+kphHsKgj2pwibFD3IaIMcPiXflBWwXoMnS4
	 uCdHAgAvuooNXs6AOBNZ64coa+ICKi4mBmQLDtH03CrNlALH7pyIB7vnt4g4QdSezmFpg
	 dqTg7tKJ2xC1z6r2LEVeQIUTtv4VZSrIS/N2aX6N+CK7M2MzT+1o2MH/U4SEqqvBntxJr
	 54CTEGtAjUblS220FHl43SBu9au6iUc3I3ZNl+hz7QaaQEk3udEk6PJ7xxZ3jBdPUx83+
	 CoRb1OGipYS4/C1jZHWnwUIA4JcS7vDBTlEEyhfOsjBI5MNV/kjbK5zxNfT0taSBHpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RlGTCzi8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6379F606A31B;
	Wed,  4 Nov 2026 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RlGTCzi8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC751F00A1B;
	Wed,  4 Nov 2026 09:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784087;
	bh=TLWmGN3SfRKJzJtFGqy9xXljoZdTMIGgQAZ0U5pRqZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RlGTCzi8pu88TVAb0kwn4joxUiR7mlBDOdPpezl4XmsvQd8kAh4iDFU4pQONkMHIu
	 eliic42rAIpabkq9bUb6HqnW9ZOmOC+nO6hIz58hrOaEoVJAOD6f1NccFejHSUbQEg
	 UcTtVvMVrKX8rkKsqChfbeyKOblU3iUz404/VcCwAESFTSpzfmuSYLv6tIXqWgvwx4
	 JsaFcHO4jSLDa+WNzQE5ZJzqGGlwKjwInimlKuIR6uaQtqBJZavxLJ41GnGzP1qeFj
	 IB/K6cI148TQ1ND1SEtNwA24wzZ0dXL4wMxQ/4D3P3yQeU5Lj8YAihYUT5N5BdD20o
	 LKB+GT+o55caw==
Date: Wed, 4 Nov 2026 10:21:13 +0100
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
Subject: Re: [PATCH RFC 38/38] selftests/proc: check that a faulting
 readlink() doesn't hold up removal
Message-ID: <20261104-erwecken-pulsieren-anarchie-9a5a7582621e@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-38-59422ed3e465@kernel.org>
 <sashiko-outbox-195510@kernel.org>
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
In-Reply-To: <sashiko-outbox-195510@kernel.org>

On Tue, Nov 03, 2026 at 02:48:45PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] selftests/proc: Makefile adds nonexistent proc-remove-slow-reader target

Fixed.
