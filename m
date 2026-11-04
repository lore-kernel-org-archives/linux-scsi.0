Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784334;
	b=rgVDzLIZ4+lHZfrpQId+vs47N8BcCWq5uZKqhY7BM8zuKOQyCj8zoZ+AqdEgI6/ebG/6
	 OVyw1JtDKiLpPiWjvpb+d5VjW0a7Wfp+7/wfnALpzbz56XGCoMOGp5roCO8u+Iaa7Qy7F
	 BMe9rNYvW8amX7Kp9dQC52Bu/KQsMcqoXJNFYzURMYgO7CroadsVk9cnlDA2PxYkjZPwB
	 5Bidw3HyD8y/MQdKhysPhLMzI7uIHoOIum1ojBDFHxxfKRAhVcmu6pmWpTedOnJnht46H
	 OoPZ+nE7tos+p9mTDB3eAApMYI2fNpm6L1VOQr+FfyP9UKpF5D18kNx/VUWputWwN7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784334;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6y/QB0A+W+6N3jiXZRGNY1xzzbI4566zJ/BaiNow5YE=;
	b=H9vqTHr8Q+QPjaedgq54hgH8GA2EmF+Np+ZyVHFGGa0as2P6UhL5/Qt3vUX03/n090qz
	 XD4uvXQzKEz2Y6a29yXF4yJ/GQAQOH64fbYzh8waICeGHiGUZxIHlzkfNIWji0CSWNgFN
	 cONFsZbNG9V921mCyB5jp/1BUdngWA+ATAIcSq117cdjYcMtafJCD4CbQz/GDLkhYFXmb
	 c37oN56tXhzen2Uym3BqDGGUyyt7foo4XMUDZqZ+tlQFxOfY1z2q56dCzQT3t+JNYER1/
	 1T+RYm4OVyCQd+K8nZAB+psNmy/HjCtDOMRFFa88Eml90hOchkWdyboicUvdaiDTO3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blm3Fzks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAB5606A31B;
	Wed,  4 Nov 2026 09:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blm3Fzks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF441F00A15;
	Wed,  4 Nov 2026 09:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784334;
	bh=6y/QB0A+W+6N3jiXZRGNY1xzzbI4566zJ/BaiNow5YE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=blm3FzksIwmy/gfP+m6bQ3l19t8u+6D7VnMjx0mDrwJfI9yqkrKHuitgS+09MOaFB
	 5IAfK41yIRysnuekyE6n0MoqHw1erKQfYIHd4bcxX9IzwZZwgAZVYki7z4Cj5AIA7/
	 ZPGTgJBvsmIssHVAjO0+bxwX4CubbRT4ywfOYmYyDPmpCbFuRzICtnH6f+UaysQImg
	 q7wpeNs4gNICgefy3SKpkaeX4BbxjIfO+vSSQmRySEd1imrt/h87R+LlDv4MuyR4ux
	 lqn+1ClVwhwp9e3GHxStc7SnGYtfRsRPS5FsY3RelvLgIwBZIwrO2g2A54DZvsL3tG
	 vhwB9M0WME18g==
Date: Wed, 4 Nov 2026 10:25:21 +0100
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
Subject: Re: [PATCH RFC 11/16] proc: let procfs copy in writes before pinning
 the entry
Message-ID: <20261104-ankurbeln-gepflanzt-elegant-896e9dc995a2@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-11-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195538@kernel.org>
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
In-Reply-To: <sashiko-outbox-195538@kernel.org>

On Tue, Nov 03, 2026 at 03:01:26PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] proc: split __free(kvfree) declaration and initialization in pde_write_buf()

Intentional.
