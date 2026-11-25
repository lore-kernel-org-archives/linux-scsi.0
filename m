Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.79.88.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625137;
	b=d7PihfG8THwoBJDKt1sW+ZleRR42s30RFBmqCyjDrFAWsxuZV4Yr5eV0+TVwQfNKy76l
	 37MmJxCButtmfr5ujtpQzyKL8CO/BRKTCQLM2IbfP19asYFiBm/7lkTNMK8s/48gFIkZJ
	 G/MhgwC1+5cTNEcp8xesI4axVxEbe1/Wacm6n70fCji7IFATTISr+2uCuhtP5g2gRLWch
	 OJR5qaty3Is/CwVWSgXKGO5ZnnrDSE+F+vISrjJDR3nPnYGRATofmLINqWubaHziwPAd6
	 yGp/RMkR7ffED9cZI7QZzU1VtK1/Mwbwu19nMDCRuyXYODeJBsIpE+/SBNgGN9jIBKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625137;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type;
	bh=11zt4OupvieQqDw22Q2ubqyLm0TwPHTf9uDp8UQ/aNg=;
	b=PUsbplCsMhlqiymWe4V5Xj/NroXrL6l5nwWUHeAe+tJogdDy8zUOeEkMzFcJNRInmf+Q
	 Zjji2Mth+x5/ypT5hjyfsZV+DJlbCDhDP9SVZavQG79hsWIvKkMekf0zhvdHPWK4Xisa7
	 0OLHR1E8Hg7Yvzz3zEDDiiyU729leUZO7zbT0URM5MwvsfrRKVK/VaerhW82piXXxpal5
	 YY+PM/cgeZQrO1gojlBzOuc1R85JbaT3S7vlqlDVxnKY2gXjGQXbPApahWRk9Q1nGwk6+
	 /6wQs7SGFbO7KbnQ/Sb2YHFSFjj7A2wxpg2Rm8yyRqjng5fp+Cef4UaWGd6Cw5rmWgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lwn.net;
	spf=pass smtp.mailfrom=lwn.net;
	dkim=pass header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=gYew8w2z;
	arc=none smtp.remote-ip=45.79.88.28
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEEE606A327;
	Wed, 25 Nov 2026 16:45:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AEEE606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=gYew8w2z
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 164CF410D0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1795625135; bh=11zt4OupvieQqDw22Q2ubqyLm0TwPHTf9uDp8UQ/aNg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gYew8w2zbH6+bi/mBbqli+h0aBDamw00BioPDCMMC4Es4g+qCaaIw8gBYOLhfGAsU
	 9mfNHzR2Wjt3eb5ezNkPplfVvqDZB4yLXc7H/uIjYl6k/R0SNrt0O4pqewchTPc4H+
	 DoPRzU4+fJgJOU7hPx03jLkV4HVaXJMTTjxyrWRVyiE+GFkUio915W5ZUB0L5VMnbm
	 Z5AtjEERksNhEMgjG3ZSm0ynjzhzYrKmQP0JaqQq4T6DitPDhHE0cz5cUJ9ItE/n9j
	 Ip9FDRPDTnpXpMfA3rcqvq+BtjVyvtC+AdbQzNra/9WErFSqw5foLA7PdpN6n18WG/
	 9pepodyHhS3sA==
Received: from localhost (unknown [205.220.129.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 164CF410D0;
	Wed, 25 Nov 2026 16:45:34 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jason
 Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-mm@kvack.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, linux-sound@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, linux-block@vger.kernel.org, Marcel Holtmann
 <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowangio@gmail.com>,
 David Heidelberg <david@ixit.cz>, oe-linux-nfc@lists.linux.dev, Chas
 Williams <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, Miquel Raynal
 <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, Vignesh
 Raghavendra <vigneshr@ti.com>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>, Eugenio
 =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Sean Christopherson
 <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>, Namjae Jeon
 <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, Florian Fainelli
 <florian.fainelli@broadcom.com>, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Tzung-Bi Shih
 <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 intel-gfx@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v3 00/12] docs: ioctl-number: update entries
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
Date: Wed, 25 Nov 2026 09:45:27 -0700
Message-ID: <875wxkx3ko.fsf@trenco.lwn.net>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:

> Update file names that define ioctls and update the range of
> ioctl function numbers that are used where they have changed.
>
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]
>
>  [PATCH 01/12 v2] docs: ioctl-number: update MM entries
>  [PATCH 02/12 v2] docs: ioctl-number: update sound entries
>  [PATCH 03/12 v2] docs: ioctl-number: update block entries
>  [PATCH 04/12 v2] docs: ioctl-number: update networking entries
>  [PATCH 05/12 v2] docs: ioctl-number: update video/fbdev entries
>  [PATCH 06/12 v2] docs: ioctl-number: update SCSI entries
>  [PATCH 07/12 v2] docs: ioctl-number: update MTD entries
>  [PATCH 08/12 v2] docs: ioctl-number: update USB entries
>  [PATCH 09/12 v2] docs: ioctl-number: update virtualization entries
>  [PATCH 10/12 v2] docs: ioctl-number: update FS entries
>  [PATCH 11/12 v2] docs: ioctl-number: update platform entries
>  [PATCH 12/12 v2] docs: ioctl-number: update DRM entries
>
>  Documentation/userspace-api/ioctl/ioctl-number.rst |   91 ++++++++---
>  1 file changed, 72 insertions(+), 19 deletions(-)

I've applied the series, thanks.

jon
