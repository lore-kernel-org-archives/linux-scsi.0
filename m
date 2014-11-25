From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] wd719x: Add firmware documentation
Date: Tue, 25 Nov 2014 10:47:41 +0100
Message-ID: <5474503D.5030501@suse.de>
References: <1416867882-29344-1-git-send-email-linux@rainbow-software.org> <1416867882-29344-4-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416867882-29344-4-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/24/2014 11:24 PM, Ondrej Zary wrote:
> Add documentation and script to obtain required firmware.
>=20
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  Documentation/scsi/wd719x.txt |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/scsi/wd719x.txt
>=20
> diff --git a/Documentation/scsi/wd719x.txt b/Documentation/scsi/wd719=
x.txt
> new file mode 100644
> index 0000000..0816b02
> --- /dev/null
> +++ b/Documentation/scsi/wd719x.txt
> @@ -0,0 +1,21 @@
> +Driver for Western Digital WD7193, WD7197 and WD7296 SCSI cards
> +---------------------------------------------------------------
> +
> +The card requires firmware that can be cut out of the Windows NT dri=
ver that
> +can be downloaded from WD at:
> +http://support.wdc.com/product/download.asp?groupid=3D801&sid=3D27&l=
ang=3Den
> +
> +There is no license anywhere in the file or on the page - so the fir=
mware
> +probably cannot be added to linux-firmware.
> +
> +This script downloads and extracts the firmware, creating wd719x-ris=
c.bin and
> +d719x-wcs.bin files. Put them in /lib/firmware/.
> +
> +#!/bin/sh
> +wget http://support.wdc.com/download/archive/pciscsi.exe
> +lha xi pciscsi.exe pci-scsi.exe
> +lha xi pci-scsi.exe nt/wd7296a.sys
> +rm pci-scsi.exe
> +dd if=3Dwd7296a.sys of=3Dwd719x-risc.bin bs=3D1 skip=3D5760 count=3D=
14336
> +dd if=3Dwd7296a.sys of=3Dwd719x-wcs.bin bs=3D1 skip=3D20096 count=3D=
514
> +rm wd7296a.sys
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
