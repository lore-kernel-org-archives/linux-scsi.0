Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795634657;
	b=SCx1gKM5E2deTUk9dmoJ3POT2sBahg5Oa7eKu/bC4ecLmf7J4wEE9kzt0vUgQpm19U6F
	 rmOjVdrxrFP61kyRP8RUSMBveSJsxd0GJE6/JixknJ5Knf6PMohtG2BSezHbkpHzudRCZ
	 eaVfbbQikD5vohZFMMvP7K2XP1ywSQUVf80uSu/oyj7yxVmRtZPQCKdcXa/iIrDm5BcSt
	 UrH3Yw0xF1m83vgdhFYFutffQ8F5PlluldVJuEZJ49C1wbaVYU4cT7+CK7To4WsuhTUdf
	 dUoj+nT3FIXgAnKomkzBlwue0paMc35QtycZVSEKjatZ5GG5gneL0uIc3XWWcOFgtrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795634657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=N55gjPKFtoyQEkpZ+mulBFdiGvAn3buEDUMJWwRWBLA=;
	b=fcYSPoK1zlYKZnWwCH14OJ95VlItFUpqry6pKp/O+XGy3xzw0XvVr0q1Y4pdBanBc2lv
	 8veeMF5I5ESGoXATIR8yCG8pakN7DMg9BP0B9eI31oEhHuLrFV71tycqIBJPTH2B98HQ+
	 QkWlSSq7fgg6iA99sydhUiO+sgpCGEZcpPcFI8QD0A4U8oYYheJMGkAF7SQhPG/yVvu8a
	 +In+o2IzwSFYVr9nATECLNlNPEdvaSWg9vYaQirzTVu+rjTEh3DmbviyhxqlibJa0xl4e
	 ubckLMZEIrvPNtkggYTkAWt3BWt0K+lrhCpujqz8Q/zwMHiHhFUCahrGpfynSRFvFxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oCGp0YcP;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD09606A684
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 19:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BD09606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oCGp0YcP
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8ca6a12efd9so2079935b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 11:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795634656; x=1796239456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N55gjPKFtoyQEkpZ+mulBFdiGvAn3buEDUMJWwRWBLA=;
        b=oCGp0YcPvUHi0mkvNJzYjDzOqfg0gHs6ETaxOw6iHkwvvSF4tYjvsaGjV95aPOdQou
         dmAQRQLqlhN3jiNznQ2pOjzWEW/G2t/wbqDp6HuYWHKE0XMdFq9FvURpTwt3LZNjNOiI
         XwXkQTulincExFaiUQD3ExWzaLJgh5f90EbERJvf+q5dn2l8/In7F6eLtSCHApz045QY
         AGa84JuoW96MF2RwV40xmLUxu2P+/+qEsF28w8+r12XoJqwGJeCssnVaJxVXWHGiUXGn
         ECyAOK186fme41Oi47Fv+x2wiNPNPpqw/d4+KhlG9F3LQdPCn4i+tof3zaLzJI7SrBz8
         moaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795634656; x=1796239456;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N55gjPKFtoyQEkpZ+mulBFdiGvAn3buEDUMJWwRWBLA=;
        b=2ZsA26ZWjC5A/yPa+/IA6YqxOuZxOc1ukC4S5OGLJvwftHYkNIWKGYwPAe4CKE3vgr
         zd+ZI6aYSWnjKXzvrvjSDS/M4d+Gfxzkjw9QdrZ1VY+TpMApzFCQCCibLUjBzECrxpEe
         JphoU1y40ugketMQ02cG+qpgZcIqj4b6dIPZ870QkVZ0kfCJYPbKAzJRg1x6FMxhEBac
         PGYxrsRES7fJY1zbFQvME+yudEGZ0RCXy+LyIbxWLKO33Oft91mtLNNHlwt+rMyGVBXw
         xrTnEdVPV6fEkArmbSuY9qFQTtCmc7cQOnnSyb98LcnN+k8trPDXS0xOvMyptyfDrwN2
         h37w==
X-Forwarded-Encrypted: i=1; AL+hErF/Ui3gy0ga8tqB+Y2Z0Pfn9d35vZCetlgGu/ER1maW6fjlLTUFCT35hREpw19trqEshKBcRSSlj4tB@vger.kernel.org
X-Gm-Message-State: APuU4Z+mWebORqxotwcSkd+M5Fp1Umrlh0VcgZZh7uFycej+p78+46ax
	Qedn6Ud0bnNegqfZGL8mSLk7njzUUS1zz8vj/9bEAzXITiSoqNRSiQlykJdIwFrrNg==
X-Gm-Gg: AZFdTZc/K0LzCwnP7R8WCZukVvBL28r3dvHsdqbB0FWQO6ADGW7lQ56NMIqBAhMjTFD
	5AwLQm/3myjNBAPHtDvr9h5BdXob0hY69jAOeAy33Jl0kQHicK3Q9RZUdkWzh/BHfAV/20IcHyf
	JfAy2WDmTk85T4hqvXmatMWlfaE4lQ8LqE0HVOV2nIr6E/uoMgWT/W5mpMC7p3uD5NLvw6iAFx+
	WcDiw4YM+R1GmiYvsfeGgiHlM4Wpbzn+ydi1iyugkDl5NWmX5EzuVH7bDPxMG7MBNLKU3DQYNNW
	vUVZsKqSJpJ/lvMZLzuHG6NYUqDKik7JnrgUuzyaCcuM4JWztbteHk30nGc8Mq47D7Ow6Xr5TdQ
	HrtJ2jFPuefLzuplKtzgMRCnrOExRgcE8VKOuE/TbQyl5OL5guuyrkelaSqJivXWAoYHmSHLANX
	Gzj9fJ/AnjCEAu9Yx733ulLCC59Yb5KKLs1OqlYK4zXsR1+uXnbZYcIz5UAo77gRJ4mBE7yHybX
	tkFXm/KgCa30HX5taGgCzbGcX63nKC0BOqoByfK0syWoXO65s/7b3SoQx2qnwZ26ZqHZpht8xcN
	Ezo0/M2srkfSBFJ67jukPKsNrY6Ap2oxpYNexhYdl3k5Pf75LigcfpUiaoGEyuiNIx1XnZlI0cx
	tGblXtExgao6DWNpz8+PteyE0hPMb/m24rB94rDQAOzCTPYXplKg3x35dbMx7wqXwpD9w9BNY7w
	kD3ntA7ktWTQ==
X-Received: by 2002:a05:6a00:a908:b0:886:773d:a6a with SMTP id d2e1a72fcca58-8c87c199463mr15925448b3a.28.1795634654761;
        Wed, 25 Nov 2026 11:24:14 -0800 (PST)
Received: from google.com (196.126.197.35.bc.googleusercontent.com. [35.197.126.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87077bc47sm9717494b3a.6.2026.11.25.11.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 11:24:13 -0800 (PST)
Date: Wed, 25 Nov 2026 11:24:10 -0800
From: Benson Leung <bleung@google.com>
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
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Juergen Gross <jgross@suse.com>,
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
Subject: Re: [PATCH v3 11/12] docs: ioctl-number: update platform entries
Message-ID: <awc12oWB5WDJi8XZ@google.com>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
 <20261125061340.3402300-12-rdunlap@infradead.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Kk3dCghKBQNrocaf"
Content-Disposition: inline
In-Reply-To: <20261125061340.3402300-12-rdunlap@infradead.org>


--Kk3dCghKBQNrocaf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 10:13:38PM -0800, Randy Dunlap wrote:
> Update the list of platform/ files where ioctls are defined and update
> the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Tzung-Bi Shih <tzungbi@kernel.org> # cros_ec

For cros_ec as well:

Reviewed-by: Benson Leung <bleung@chromium.org>


> ---
> v2: no change
> v3: rebase
>=20
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]
>=20
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: Florian Fainelli <florian.fainelli@broadcom.com>
> Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadc=
om.com>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
>=20
>  Documentation/userspace-api/ioctl/ioctl-number.rst |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> --- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-numb=
er.rst
> +++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -434,6 +434,7 @@ Code  Seq#    Include File
>  0xBA  00-0F  uapi/linux/liveupdate.h                                   P=
asha Tatashin
>                                                                         <=
mailto:pasha.tatashin@soleen.com>
>  0xC0  00-0F  linux/usb/iowarrior.h
> +0xC4  00-1F  platform/raspberrypi/vchiq-interface/vchiq_ioctl.h
>  0xCA  00-0F  uapi/misc/cxl.h                                           D=
ead since 6.15
>  0xCA  10-2F  uapi/misc/ocxl.h
>  0xCA  80-BF  uapi/scsi/cxlflash_ioctl.h                                D=
ead since 6.15
> @@ -446,7 +447,7 @@ Code  Seq#    Include File
>  0xDD  00-3F                                                            Z=
FCP device driver see drivers/s390/scsi/
>                                                                         <=
mailto:aherrman@de.ibm.com>
>  0xE5  00-3F  linux/fuse.h
> -0xEC  00-01  linux/platform_data/cros_ec_chardev.h                     C=
hromeOS EC driver
> +0xEC  00-02  linux/platform_data/cros_ec_chardev.h                     C=
hromeOS EC driver
>  0xEE  00-09  uapi/linux/pfrut.h                                        P=
latform Firmware Runtime Update and Telemetry
>  0xEF  00-0F  uapi/linux/ntfs.h                                         N=
TFS
>  0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       s=
isfb

--Kk3dCghKBQNrocaf
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCawc12gAKCRBzbaomhzOw
wuvSAP9FFr45oXAv5Psc3n5xsSYyPFouusI/XwRnWy3tYxQspAD+KIeOTWQfcOeC
TWeqyAANog5rg68r7xNPxeH8I/R6xAQ=
=Fk2v
-----END PGP SIGNATURE-----

--Kk3dCghKBQNrocaf--
