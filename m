From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 24 Aug 2018 16:39:47 +0100
Message-ID: <CAKv+Gu-RwCrdgW69NVpyRLwGPGPCZx+ksTBM7NZk7v0-dzczGg@mail.gmail.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
 <yq1in4gq5jf.fsf@oracle.com> <yq1lg8zb2lp.fsf@oracle.com> <20180822062016.GA10356@infradead.org>
 <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeffrey Lien <Jeff.Lien@wdc.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 24 August 2018 at 16:32, Jeffrey Lien <Jeff.Lien@wdc.com> wrote:
> I rebuilt my 4.18 kernel with CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3Dy as Marti=
n recommended and got even better performance results vs the CRC Slice by 1=
6 changes.  Here's a summary of the results
>
> FIO Sequential Write, 64K Block Size, Queue Depth 64
> PCLMUL =3D y Kernel:        bw =3D 2237 MiB/s
> Slice by 16 CRC Calc:      bw =3D 1964 MiB/s
> Base Kernel:                     bw =3D   357 MiB/s
>
> FIO Sequential Read, 64K Block Size, Queue Depth 64
> PCLMUL =3D y Kernel:        bw =3D 3839 MiB/s
> Slice by 16 CRC Calc:      bw =3D 2730  MiB/s
> Base Kernel:                     bw =3D   797 MiB/s
>
> So it seems the CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3Dy provides the best perf=
ormance.  Are there any negative side effect to this config option?   If no=
t, does it make sense to recommend all the major distro's change their conf=
ig options to have CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3Dy as the default option=
?
>

I think the way the library version of crc_t10dif() invokes the crypto
API should be revised.

Would it be possible to allocate the crypto transform upon first use
instead of from an initcall? If crc_t10dif() is mostly called from
non-process context, that would not really work, but otherwise, we
could simply defer it (and occasional calls from non-process context
that do occur would use the generic code until the point where another
call from process context allocates the transform)

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, August 22, 2018 1:20 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Jeffrey Lien <Jeff.Lien@wdc.com>; linux-kernel@vger.kernel.org; linux=
-crypto@vger.kernel.org; linux-block@vger.kernel.org; linux-scsi@vger.kerne=
l.org; herbert@gondor.apana.org.au; tim.c.chen@linux.intel.com; David Darri=
ngton <david.darrington@wdc.com>; Jeff Furlong <jeff.furlong@wdc.com>
> Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
>
> On Tue, Aug 21, 2018 at 09:40:34PM -0400, Martin K. Petersen wrote:
>> When crc-t10dif is initialized, the crypto infrastructure will pick
>> the algorithm with the highest priority currently registered. Both
>> block and SCSI will cause crc-t10dif to be compiled as a built-in so
>> this selection happens very early.
>
> Ouch.  This might actually happen in a lot of other users of the crypto f=
unctionality as well.
>
>> However, it seems like a bit of a deficiency in crypto that there is
>> no way to upgrade existing transformations if higher priority
>> algorithms become available. btrfs and a few others work around this
>> issue by not using the generic lib/ CRC functions (which defeats the
>> purpose of having these in the first place). Instead they are
>> registering their own transformation at a later time where any
>> accelerator modules are more likely to be loaded.
>
> If we can't fix this in crypto (which doesn't seem that easy), we should =
at least clearly document the issue somewhere, and fix this in the t10pi co=
de by initializing crct10dif_tfm in a lazy fashion only once the fist block=
 device starts using it.
