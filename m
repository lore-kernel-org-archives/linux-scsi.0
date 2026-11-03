Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723981;
	b=jesyy4S99MNBoptfiHpojXmkI6IiAfIVHkIimZOMA4ngNsakzNCTo4CKFACQhReSNkXv
	 Bpg7HGLitfwllAT9IrISFXTrsr24EFhBrK7VAARcZ3VNt0zgcgoUDxn+9RZv/pWSxvuv3
	 cMEg/frB0wwVU66q2Z8n0amZlunyhD9OffdqQtA8NvmtLJ/N/kP0By95Dpm3xg00oy6fk
	 ECvyhke/eqycoiWWyBt+fAJVJ6LbIaMLX9doF6Pmm8hCpRxOso1QPkQODASyquiFZPWGE
	 chKrL3+dnfyxeelq7NEbnIlAskpGi6A/Sh4+AeNtnFZlNNnxAzDvF3MRHfNOU8YQpOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723981;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=MRMdP7FIxigSeDqcsgSUYB9b6BNpnFg/wAimEqAPxEs=;
	b=ogJfgO/+Yp3S7Qbvz3IcoFaSClbtrICZSfTBcKuu9/C1YEN8lrIljB7Dh6KLp0zpY+yX
	 7YFWvVbXS9R1vw71C4gU20B0yMNG7sqy12yHW68gwly2a73eZcXdHOIHOuCcRsbnFWH0i
	 CV/Y8f79SN8BuFl4Wobxne5Dl4eBIsaNdc3i+ljTboy7U/sirbaZ/UzuLHCEc7YuFcnXy
	 1nwv0KIV6fQVDLk54uO0GbhYIwc8D0P7tZfosUtctGlGTFtAU9M/H3L8ekVc9ENBe/HUe
	 ZhYJr7KUQ5ICeiAkhpeyrMvelouyzZa703xbxPO7OYG2FePI6DOxi3P94bL9EDPCOKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="XQ/nNwuo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F96082BC2;
	Tue,  3 Nov 2026 16:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQ/nNwuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEE01F00919;
	Tue,  3 Nov 2026 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723980;
	bh=MRMdP7FIxigSeDqcsgSUYB9b6BNpnFg/wAimEqAPxEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XQ/nNwuodkCBEaeYlDPGXQ2NBVyaOu+nuL3oimLdbSA+hZnOnCMyBEv8BHrYgwk/m
	 6VRgMfJqoFXxFR5EnYPGf1ATg09kypE1i/OaABYNEuqdO5agM7Fzz0cf/3n/BjKYZM
	 khi+2N49jwOr20dXQgySeVZQ9Nuqnaii9228cGUqmaA9nvn0Bo2QFeSR7x+Zj7TPBN
	 DsnqdVZFYyPlE6EQk0LhOkfKZhj3KG2NrjGmOrcKa6pa4XM1UVKP+71e961E7SnLHB
	 vkz6atcfZ7p6OvtLIdPK+tn8iO+IrzrFsPPZ5RZWhEpbynuwXHq2NjfH4sIU6OUzUj
	 zfP/LOwKBMdTQ==
Date: Tue, 3 Nov 2026 17:39:28 +0100
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
Subject: Re: [PATCH RFC 28/38] scsi: esas2r: bound the lengths of the HBA,
 SMP and firmware ioctls
Message-ID: <20261103-aufmischen-achthundert-reitschule-d97de42062c2@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-28-59422ed3e465@kernel.org>
 <sashiko-outbox-195500@kernel.org>
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
In-Reply-To: <sashiko-outbox-195500@kernel.org>

On Tue, Nov 03, 2026 at 02:48:22PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: esas2r: TOCTOU race on data_length in handle_hba_ioctl() via read_hw()
> --
> 
> commit 8af21917bc01e9991b2ab872e7a4c38c91a6e388
> Author: Christian Brauner <brauner@kernel.org>
> 
> scsi: esas2r: bound the lengths of the HBA, SMP and firmware ioctls
> 
> This commit adds bounds checks on user-supplied lengths for the HBA, SMP,
> and firmware ioctls in esas2r to prevent out-of-bounds reads and writes past
> the end of struct atto_express_ioctl and a->local_atto_ioctl.
> 
> > diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
> > index 3f7c1d131ec34..f99318f61c934 100644
> > --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> > +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> 
> [ ... ]
> 
> > @@ -1221,11 +1231,16 @@ static void hba_ioctl_done_callback(struct esas2r_adapter *a,
> >  	}
> >  }
> >  
> > +/* @room is the size of the buffer that starts with @ioctl_hba. */
> >  u8 handle_hba_ioctl(struct esas2r_adapter *a,
> > -		    struct atto_ioctl *ioctl_hba)
> > +		    struct atto_ioctl *ioctl_hba, size_t room)
> >  {
> >  	struct esas2r_buffered_ioctl bi;
> >  
> > +	/* The data follows @ioctl_hba in the same buffer. */
> > +	if (ioctl_hba->data_length > room - sizeof(struct atto_ioctl))
> > +		return IOCTL_INVALID_PARAM;
> > +
> >  	memset(&bi, 0, sizeof(bi));
> >  
> >  	bi.a = a;
> 
> [Severity: High]
> Can a concurrent write_hw() bypass this bounds check when handle_hba_ioctl()
> is called from read_hw()?

This whole codepath as currently implemented is structurally fscked.
So it's not something fixable in this series apart from the glaringly
obvious.

But for the record:

- The ATTONode entry thing is created as a side effect of reading
  another file.

  So esas2r_info() registers a character device and creates
  /proc/scsi/esas2r/ATTONode the first time it runs. That pins a global
  pointer to whichever host triggered it. So the control node only
  exists after someone looked at the host info. So it is bound to the
  first host and not to the adapter it operates on.


  The lifeteime is then tied to the module and not to the host.
  The entry is removed in esas2r_exit() on module exit.

  But the directory it lives in belongs to SCSI. That removes it when
  the last host of the template goes away.

  So unbind or hotunplug of the last adapter removes a non-empty
  directory... the dir is unlinked and the ATTONode leaks and stays
  reachable through a cached dentry.

  And the global host pointer dangles.

  So every ioctl on the node dereferences it.

  It's like non-empty directory removal basically. Fun.


- No privilege check anywhere. The node is created with mode 0 so 0444
  with procfs the the driver never calls capable().

  Hence, any local user can read and write firmware and NVRAM and issue
  VDA commands.

- The ioctl protocol itself (where to begin):
  - Plain-number commands
  - one struct copied in whole
  - unbounded lengths taken straight from userspace (well, that's fixed here)

Sorry, I'm not going to redesign esas2r.
And from what I can tell that ATTO stuff is legacy anyway so good
riddance as far as I'm concerned.
