From: Artem Bityutskiy <dedekind@yandex.ru>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 13:59:26 +0200
Message-ID: <49142D9E.5040705@yandex.ru>
References: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4913028B.6010405@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Ric Wheeler wrote:
> After talking to some vendors, one issue that came up is that the arr=
ays=20
> all have a different size that is used internally to track the SCSI=20
> equivalent of TRIM commands (POKE/unmap).
>=20
> What they would like is for us to coalesce these commands into aligne=
d=20
> multiples of these chunks. If not, the target device will most likely=
=20
> ignore the bits at the beginning and end (and all small requests).
>=20
> I have been thinking about whether or not we can (and should) do=20
> anything more than our current best effort to send down large chunks=20
> (note that the "chunk" size can range from reasonable sizes like 8KB =
or=20
> so up to close to 1MB!).

Note, this is relevant to MMC as well. They have an "erase" command,
which is equivalent to discarding a group of sectors, e.g., 128KiB. So
we would speed MMC up if we could make sure our discard requests are:

1. 128KiB aligned
2. of 128KiB in size

P.S. Gropup size is MMC-specific.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
