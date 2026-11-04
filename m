Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784532;
	b=FYe375VTs9ZU55xCoLA0aR7t2Vh0DDFf0zJK3EQlFLcaBI95JXfXdg3p6FozOSzQQsaL
	 fD5bNC9IJHSpQmd09SOxIpz5Ie2/zflrfolbj0LRUDdjdeyP8daaOCxLzMZLXDWfkdjkN
	 mPamegF8BfjQbWceO007apINWH4SqpyEt49fiL/Swu2KL3UtU72E/TU9wABtPF+FzjVEB
	 bEvHKc6Z1leea2lT4PHrhjFQnAVzDKKPrzMae4bTrauCe2Fa2b9WtST/xxWSJj+QN3PV0
	 3RdHQqV7+nWtcfvdvB7PR9KWXtGItoyeDMLEcDJMQsN6V5JISEaK7amwEKBkOGQUIxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784532;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=T01zQUJSjbZp4aJnpwJVQI9JvpnXX6u13mZcG0ZeyDQ=;
	b=r1deBZDCTC5tshI5zm2xU4bDuMKY1BWttM86e2lQThBkcZczwbruFCfxQKa+713rgspW
	 N2ucBp2Jfke8Qgld2Bs8mT7VvyOsHbOphcAUQxn4w02ydX7NUeC+oCGAPtNsi9VBX9rqm
	 DTw/p4NIc/XwbJok5mHmPm3rXVSz/iXfzkqjP6Io1aEBsvyXgPcYtfKi19CMLCcX6f4dn
	 YHhNr6r+DC6qYL74cCp5Oqv+RZBZm1rZumthZyvh0pFMccaNb9MDvs7MoqLsj/OVClH9V
	 PZ9sNoHf621RzLBh28KqU2GKATc5CX4hKDPAm4kOSprZ7gezj/dhLuSz8jl0Wlt6P7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=alKTGqUn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677B7606A31B;
	Wed,  4 Nov 2026 09:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=alKTGqUn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB561F000C1;
	Wed,  4 Nov 2026 09:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784532;
	bh=T01zQUJSjbZp4aJnpwJVQI9JvpnXX6u13mZcG0ZeyDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=alKTGqUnuzoexCqwA81KPAyGy0rneY6r5MbFqbvV697+Ik/bjfxk9LHef9GM+MQJQ
	 QlHwwMzWgTBR+V1EVZkBqvL2y+0fpSnZdIRpFx1eImmWwcDpXf+kwZoN+KfbPRIwjh
	 GLUEX2tS20NdiCJARKDNfWQpLYmSC9HacZQpjtFGF6DQjakJaImqqw+1NVIZp8Jkve
	 rhjW0cKAwa0rgro+T+KAxTAshgpXhyosdPn/BLM1fw2d0BZ8BRed4fxkWyQdPz2E0I
	 sRYd32Lzz24ZCjwV4++8ADyzClHdrBNXy/ODBoctV+0gtJXx39Cw7SDphwQ7RfGct5
	 fVZStrNkhDPHg==
Date: Wed, 4 Nov 2026 10:28:38 +0100
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
Subject: Re: [PATCH RFC 11/23] selftests/proc: check that a faulting writer
 doesn't hold up removal
Message-ID: <20261104-miterleben-erdaushub-insel-df331d74044d@brauner>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-11-a994bd4d3b1a@kernel.org>
 <sashiko-outbox-195591@kernel.org>
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
In-Reply-To: <sashiko-outbox-195591@kernel.org>

On Tue, Nov 03, 2026 at 03:18:48PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] selftests/proc: fail and leak scsi_debug host without CONFIG_SCSI_PROC_FS

Fixed.
