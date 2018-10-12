From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: fix integer type usage in uapi header
Date: Fri, 12 Oct 2018 13:32:38 +0000
Message-ID: <SN6PR04MB4925ED3D6D5FFD616FA9D69AFCE20@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20181012104143.1931393-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012104143.1931393-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Arnd,
=20
> We get a warning from 'make headers_check' about a newly introduced
> usage of integer types in the scsi/scsi_bsg_ufs.h uapi header:
>=20
> usr/include/scsi/scsi_bsg_ufs.h:18: found __[us]{8,16,32,64} type without
> #include <linux/types.h>
>=20
> Aside from the missing linux/types.h inclusion, I also noticed that it
> uses the wrong types: 'u32' is not available at all in user space,
> and 'uint32_t' depends on the inclusion of a standard header that
> we should not include from kernel headers.
>=20
> Change the all to __u32 and similar types here.
Ok, Thank you for fixing this.
Reviewed-by: Avri Altman <avri.altman@wdc.com>


>=20
> I also note the usage of '__be32' and '__be16' that seems unfortunate
> for a user space API. I wonder if it would be better to define the
> interface in terms of a CPU-endian structure and convert it in kernel
> space.
I think its fine to leave this as it is.
The user-space app that will use this API, is the mmc-utils sibling for ufs=
 devices.
It uses the ufs transport-layer protocol, so whomever uses it,=20
Is aware of, and will account for the hw endianness whenever needed,
Just like it's done in mmc-utils.

Thanks a lot,
Avri
