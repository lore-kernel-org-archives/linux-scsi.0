Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784289;
	b=JL7Gv8QSa85xPx+J4zxMKv2KRQNBw8hAkvluor4EgtqQQJpRiyRUQf8VwhxlpLNthMBw
	 M+5vziOfr7bTQa0s20PJhQF0syYiuXLBUObK1YRweBrwCAmNaob3Uxx17o87g4lAZM1PQ
	 xdy1W2hSvF65keHynZZdpJHVCw6qiPFQtZgYZPfZaTt1dMFU0FoPl1aXUDNrFkIvEkmHZ
	 YoXsAROLTm1Ch+IY0HpgRbCpaSPrUvSJQ+ZduSQS5G2fhTf0DwQxMkB8JzVzXqycFWuzr
	 h8UaJiTbwq1S2FpSX24udsx4tGjtHCg5ypynY+c/p8lX8d9ATNYBhtOdB8LGO41ThtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784289;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DU2HnGr13UrjNFDLaLn3EdWjpZutHhABvL9XsGqx5jQ=;
	b=z4O0k03vilFqr0055wR86sDp5cxk7SNdq9P4SGEavo6ENJvJWXCZCdVZxY6QI/eWZHN6
	 hi/9gm7Sp9JMxpfrM2kUh7FIAsWoPhTiaTgWJLTOWIxiOA5oOnhLbm1TZI2EkL0SvuCAZ
	 Nyf0FI+IykIvN/ywogsCjktnTBvi6Ko5Z7JnkWd/AZ8jE682bI2MUCNb6O87AzCCmE6cM
	 n8b5oo8RhKMZ9XsWYmfR2b5bKSCKsF+rp6O+jKElizTM+RxX8WzLsiUCpUi/d54AgJP8m
	 8zWbpiyAymx1mL8TYpDU+5Nfb6fYjyQNtCCI+GlyImDTgwNi8Q03TsNQaWKAMnpVnEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsZRN4mS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0350E606A328;
	Wed,  4 Nov 2026 09:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsZRN4mS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6391F000C1;
	Wed,  4 Nov 2026 09:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784288;
	bh=DU2HnGr13UrjNFDLaLn3EdWjpZutHhABvL9XsGqx5jQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WsZRN4mSiXyNqyPQ2abkla1s08ffMgQM7KLDjLi06P+TT7ab4JbGTgUVRFTqM57p4
	 KtZN+GZbXH5rHBUm61AhQwhDhVpBREBAZXFUjjZwHt8GkhBIFsti2bgsNX4+XQ7hjQ
	 cXpndaUS1eroH/oJVNBJ+Sg56kvdzoMsNnB1THlx9+UhoGdloEsTqTqtrrUok0Vt/q
	 ruKuPDXwVqcZXMIny8nZN4Uca5yxXlYGPJItgjFJ5wO+ybOGurlQmQ1RBi6ccxL0qZ
	 AEyV8CG8Z7QBzwnTCkd8HDyv1seLZcOyLurYeXFpg9fCMOjPk9E0UUS16THupapVJJ
	 /V41KUFcG1/jw==
Date: Wed, 4 Nov 2026 10:24:36 +0100
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
Subject: Re: [PATCH RFC 08/16] selftests/proc: check that a faulting reader
 doesn't hold up removal
Message-ID: <20261104-aufsagen-unermesslich-kehrt-9fbdcf7932fe@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-8-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195535@kernel.org>
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
In-Reply-To: <sashiko-outbox-195535@kernel.org>

On Tue, Nov 03, 2026 at 03:01:17PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] selftests/proc: Makefile and .gitignore entries in wrong commit

Fixed.
