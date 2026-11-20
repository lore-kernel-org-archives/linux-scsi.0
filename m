Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795162127;
	b=cRRasoQTObwdC/WtvTrU3Fd8kuQaVwJV18tht7O7FGKDpbK7L9Z1u2vcDLmrbP6L0ICG
	 pS8J/zfTkBKcWL/slWeK0tS+fa41sQhuVQyNB+iSHt0lpO5iBAvUQiS3SXrgU3YtrvVN6
	 +HAeNuKPIbKOgzmy/fc+Wnv/wmZVTxzH7FVfSoxLRi6nld/VhRAvekc6s++ubRGQTxHF4
	 d2LrjGRxhWdvE+PMajx2foPZjezTiC6kMNnVAFNRPFrTZZ9ICc1JLxYe5AgWP9qSUF4D5
	 nOgSP1ALSXP0NMsQeuy0VIyuCR7HFxWJpruEeGiMaJzOQc/rShKmeSOuRBFhw65DyzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162127;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nhWTtz/XtWf+zHzkg8QT/u7XDoQ0xAQ0UFQlVcaEpd4=;
	b=4USGx7nU205lARgP8/HDMojtNV3S9Dy3CAbuVMSlQgfXg8a19uE++7GCxTO+NrZXTFce
	 Q8KX7f9QfjO5hWvd6kdgdDKiEr8yy9Gcl+vstmYOz1yJukXOXHfB5bIB7DRUDsCvja5Fm
	 2ZqFU1eDKnbRxV8lX46t2HvYovtD+QyCkcCzGoKyjMzm6OCjHThz0mvWMz+etUjca4tej
	 37f8cwYZRPIC3JiuTKVyuE6Yc7LRUt6R1UhG2/Rj5rJMivZ2ulbiixFm78lNdoazYaOui
	 S1J8uBaPv5eaVcygetjd8CD/l0hzRwgxIC3LqaU6bFGB2DBWL/oxK4zixZBD3sYAXCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNThT0mS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F661606A331;
	Fri, 20 Nov 2026 08:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNThT0mS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042371F000CA;
	Fri, 20 Nov 2026 08:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795162127;
	bh=nhWTtz/XtWf+zHzkg8QT/u7XDoQ0xAQ0UFQlVcaEpd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oNThT0mSGG6kUZAwqZsOB53nYtEkre5+BXqj2CeCW2DezGxoseqckwyiR/VE/H5rV
	 fasb29VNh/hB3PNLtjFkss79IjJ2QxSftm4LCX3QTWO6ojWb5uhH6sv3drEWCZAFZL
	 WHSdRIgt+zBwwz1WhpggeQETXK/uvYvzW9vMcVhg=
Date: Fri, 20 Nov 2026 09:08:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>, linux-usb@vger.kernel.org,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v2 08/12] docs: ioctl-number: update USB entries
Message-ID: <2026112013-crave-ocean-6117@gregkh>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-9-rdunlap@infradead.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119053514.255348-9-rdunlap@infradead.org>

On Wed, Nov 18, 2026 at 09:35:09PM -0800, Randy Dunlap wrote:
> Update the list of files where USB ioctls are defined.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: no change
> 
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
