From: Jeffrey Lien <Jeff.Lien@wdc.com>
Subject: RE: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 24 Aug 2018 15:32:52 +0000
Message-ID: <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
 <yq1in4gq5jf.fsf@oracle.com> <yq1lg8zb2lp.fsf@oracle.com>
 <20180822062016.GA10356@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180822062016.GA10356@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org

I rebuilt my 4.18 kernel with CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3Dy as Martin =
recommended and got even better performance results vs the CRC Slice by 16 =
changes.  Here's a summary of the results

FIO Sequential Write, 64K Block Size, Queue Depth 64
PCLMUL =3D y Kernel:        bw =3D 2237 MiB/s
Slice by 16 CRC Calc:      bw =3D 1964 MiB/s
Base Kernel:                     bw =3D   357 MiB/s

FIO Sequential Read, 64K Block Size, Queue Depth 64
PCLMUL =3D y Kernel:        bw =3D 3839 MiB/s
Slice by 16 CRC Calc:      bw =3D 2730  MiB/s
Base Kernel:                     bw =3D   797 MiB/s

So it seems the CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3Dy provides the best perfor=
mance.  Are there any negative side effect to this config option?   If not,=
 does it make sense to recommend all the major distro's change their config=
 options to have CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3Dy as the default option? =
=20


Jeff Lien


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]=20
Sent: Wednesday, August 22, 2018 1:20 AM
To: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jeffrey Lien <Jeff.Lien@wdc.com>; linux-kernel@vger.kernel.org; linux-c=
rypto@vger.kernel.org; linux-block@vger.kernel.org; linux-scsi@vger.kernel.=
org; herbert@gondor.apana.org.au; tim.c.chen@linux.intel.com; David Darring=
ton <david.darrington@wdc.com>; Jeff Furlong <jeff.furlong@wdc.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.

On Tue, Aug 21, 2018 at 09:40:34PM -0400, Martin K. Petersen wrote:
> When crc-t10dif is initialized, the crypto infrastructure will pick=20
> the algorithm with the highest priority currently registered. Both=20
> block and SCSI will cause crc-t10dif to be compiled as a built-in so=20
> this selection happens very early.

Ouch.  This might actually happen in a lot of other users of the crypto fun=
ctionality as well.

> However, it seems like a bit of a deficiency in crypto that there is=20
> no way to upgrade existing transformations if higher priority=20
> algorithms become available. btrfs and a few others work around this=20
> issue by not using the generic lib/ CRC functions (which defeats the=20
> purpose of having these in the first place). Instead they are=20
> registering their own transformation at a later time where any=20
> accelerator modules are more likely to be loaded.

If we can't fix this in crypto (which doesn't seem that easy), we should at=
 least clearly document the issue somewhere, and fix this in the t10pi code=
 by initializing crct10dif_tfm in a lazy fashion only once the fist block d=
evice starts using it.
