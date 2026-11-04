Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784020;
	b=a0chEMFdAakNV95mH1tEBqLncM1Vn4nXwyWHxO/AbGqWY7Rbc5CI9DZgFVkGenrJlAdT
	 LlbNFVqJ4D0AAgAV4t3b2+ViBp52XQ8GbUokiQ5XUoUJnVQDZNhmllD2bOnn3M0DpdG4R
	 xbKhSmhOPjLV5q+1AdfxZDlLhSANmT4ZV/sKCT0or/UmD5m9uNU46+kiPiEwWsJpRa57V
	 QKJPAiACbFdCHFF5ZtGmORXjc1pu23MV/7YxOAnZZz0SoJdYWSNWTlOm54xeEj7CfuRZY
	 bbSq1nGeQFEIszc08ruX3TMnufqm687Fq1CVVrcJXR9obhd5QTSuqdF/ohvPE4gUhQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784020;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BqLsI51xXE9XvqQwrewS8kVZYOVybuvhFSYA9nKiQ5w=;
	b=5Q5gtPiYk8gn3nUjx4Y6+5L4MqZA5km6gawV+F1ZR6k6bdfVzqPVR7K2zIk1OCQCqq+m
	 WGGDTUHJwpkKAMWYl9cBrcyeNmrg9lBYeprMqEvkjeQghdt9qn4aSEKagEEaM3q7qIpxj
	 4upHh3gS+iG0HwduWX54gx2lsFW3E6ZaPJHxEPTHLgdgibmmtlDW+OzFAXEdtqn5X6jAN
	 hJQozqVQ3nkkitaXFoOKDxgQ0zY9Na+yLO5buyRf5nr8WqI9RDiHZvWyBuo75k1mhxDG2
	 OuT56JZTnli6o71R46YVaaJxXQBnOVsOJUCYpDMTY8Tb/OEL/FcSKgW2WzzlTg3Z0ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RI03ExhV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7BF606A32C;
	Wed,  4 Nov 2026 09:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RI03ExhV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14201F000C1;
	Wed,  4 Nov 2026 09:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784019;
	bh=BqLsI51xXE9XvqQwrewS8kVZYOVybuvhFSYA9nKiQ5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RI03ExhVHW+vXW50GI/z1t5fOv/JldWAfo3PTbpnjtH9ZHo58Lc2AcPxXJ5PtbXAX
	 8g4KSTO5fOZQCtpyjjL/bJvrwiezCM9YEtZIA/HFUZUjXdYaQqcpF0TeHFBMUlhQKU
	 cwV4vnKJXipMsVWc69bizj8nAauOCKTGcIiZij9G7eWxZ3rmj4e0CBFYHzcKtXnQSl
	 AJB/iwP2dB6oj6qGqoWsBFGeMkJxlpj4mX3YlYJ3ZSSJ9f+IEjQkqzGNq+iWXf8V9P
	 ITxx8RHhN/lsRkk2i0dJRQVWI5FBwtmizQ/MBQbxSu+48ni+gfhGCNjOwQDZHYMP7B
	 rmF7LwmTvp1Aw==
Date: Wed, 4 Nov 2026 10:20:07 +0100
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
Subject: Re: [PATCH RFC 35/38] proc: sysctl: don't hold the tables while
 readdir copies to userspace
Message-ID: <20261104-getreide-fallpauschalen-uralt-d366f2bf03b0@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-35-59422ed3e465@kernel.org>
 <sashiko-outbox-195507@kernel.org>
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
In-Reply-To: <sashiko-outbox-195507@kernel.org>

On Tue, Nov 03, 2026 at 02:48:38PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] proc: sysctl: premature EOF and lost errors in proc_sys_readdir()

This is pre-existing. proc_sys_make_inode() refuses a table that is
being unregistered since ace0c791e6c3 ("proc/sysctl: Don't grab i_lock
under sysctl_lock."). The old proc_sys_readdir() stops at an entry the
same way.

We can fix this by skpping the entry.

> - [Low] proc: sysctl: unused mode field in struct sysctl_dirent

Dropped.

-- 
