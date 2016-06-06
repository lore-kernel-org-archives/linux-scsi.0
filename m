From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Mon, 6 Jun 2016 09:34:38 +0200
Message-ID: <5755278E.8040002@suse.de>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbcFFHek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2016 03:34:40 -0400
In-Reply-To: <1464702149-26573-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 05/31/2016 03:42 PM, Ewan D. Milne wrote:
> Linux fails to boot as a guest with a QEMU CD-ROM:
>=20
> [    4.439488] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max UDMA/100
> [    4.443649] ata2.00: configured for MWDMA2
> [    4.450267] scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM  =
    0.8. PQ: 0 ANSI: 5
> [    4.464317] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action =
0x6 frozen
> [    4.464319] ata2.00: BMDMA stat 0x5
> [    4.464339] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0=
 dma 16640 in
> [    4.464339]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:0=
0/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
> [    4.464341] ata2.00: status: { DRDY DRQ }
> [    4.465864] ata2: soft resetting link
> [    4.625971] ata2.00: configured for MWDMA2
> [    4.628290] ata2: EH complete
> [    4.646670] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action =
0x6 frozen
> [    4.646671] ata2.00: BMDMA stat 0x5
> [    4.646683] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0=
 dma 16640 in
> [    4.646683]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:0=
0/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
> [    4.646685] ata2.00: status: { DRDY DRQ }
> [    4.648193] ata2: soft resetting link
>=20
> ...
>=20
> Fix this by suppressing VPD inquiry for this device.
>=20
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Tested-by: Jan Stancek <jstancek@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_devinfo.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.=
c
> index bbfbfd9..09bbd3f 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -228,6 +228,7 @@ static struct {
>  	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLEL=
UN},
>  	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
>  	{"Promise", "", NULL, BLIST_SPARSELUN},
> +	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
>  	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
>  	{"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
>  	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
>=20
This doesn't apply to all versions of QEMU (upstream qemu works fine),
so at the very least it needs to be restricted to a specific version.

At the same time I'd _rather_ like to figure out why things break in th=
e
first place.
QEMU CD-ROM claims to support SPC-3, for which VPD pages are mandatory.
So why is this error generated?

Either way, this patch is wrong.

NACK.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
