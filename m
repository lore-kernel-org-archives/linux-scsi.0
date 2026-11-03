Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724048;
	b=CgzKZpbQwpeMyWBrDi3KTT8fRkUVee/dxY1YSESOlpM9HqXYFhEyzXSufHp5OtRB1N/B
	 A/ZHwzFZmtS74ANAWgC0Qdsc3p2vzRylSVBxSKYBE7bsG2Gj6WudOa/ckoc4g6FMzl14f
	 Fp3UbMS9IQqLMJbkChwM8lUYx3U3q3lruxNMyRaiyHFlYLHkdfcf//WWMfPFQAAvuno70
	 4JrkgtgBgazZaYrhUd/21+O7+4sqAeo882O6FaHSzexo2rBtGyuoNHpBtpovmECHpJmVN
	 4JutxRAGbthilE38FZR/J6ASMYU0RpdDdfZ6m9svUbEJ3t59kzanEJYiTnqDOiIl+SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724048;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3/pwRZodtv5H9vRDvB09UF4TkDVIqcbW+/AB21sxSLI=;
	b=FgyyR37QKb6g5dDdoFRb1gjKRZNCoqtQQHPr4EDCmDUoVNupZJbg/rsVv82hHIy/yzp5
	 9lBMfEDCTRINmv0TyVbjfwkqLv5YKdu4rAG9JM8slUFsltrZ2F+XNEHYVeVGZfqCBQm7G
	 ymfKy8KbiBBZ4wiywYpty0GXOYte6gseR6p6f7iVC+zpd4B44yDfEWTDVNZMu5Q6Q+aaw
	 syAm87otK0QsTriSolo7NJN2cTz0o1zQIEEZvsMJ1eKnL+hIx7xRa+wIKElSn51gx7514
	 hKQRyutHDFSjwqNKHaPoZdr4tTjC0KGfgeJqyTbdiiCtJxSFXN8LAC/Xa9Z/7TKCJPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcCk3E9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0055D606D836;
	Tue,  3 Nov 2026 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcCk3E9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE5F1F00919;
	Tue,  3 Nov 2026 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724047;
	bh=3/pwRZodtv5H9vRDvB09UF4TkDVIqcbW+/AB21sxSLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kcCk3E9DDzqb581VxJ5reyHZgYV3mxqJrzazBrWKk/8awLxY14WY1qQjIrfNtyW9+
	 +fgInAFIOA8pbj4OnlZMuT+n3NlUcuq2yEYeXQNrWe8ebUqvrivCfRVtWDr/3yvXbz
	 /BWBSYNXk+FF83ZDTD4OKx7IKTkClzRWexwwPPed/RG1Xv+LYlKNqShYqAnmueVcHC
	 gTpUG+UUL6OOUv1NGnTCJgrYlEvrsdp0yuuXL06dDPAQlPxzRqYs0ah3iWC0gI9/Bt
	 TyO0WuPIBe1MXUewf/anvSyELn8SkDADqP4mdxifTwWZEneQ2Nc7h/8SBuhSMroZc5
	 ZN0fxv3D5A0Jw==
Date: Tue, 3 Nov 2026 17:40:36 +0100
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
Subject: Re: [PATCH RFC 32/38] selftests/proc: check a sysctl listing while
 entries come and go
Message-ID: <20261103-unwichtig-puten-tauglich-389f0d95257d@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-32-59422ed3e465@kernel.org>
 <sashiko-outbox-195504@kernel.org>
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
In-Reply-To: <sashiko-outbox-195504@kernel.org>

On Tue, Nov 03, 2026 at 02:48:31PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] selftests/proc: proc-sysctl-readdir-churn duplicates proc-readdir-churn

My appetite for churn due to "low" issues in tests is low.
