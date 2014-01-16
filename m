From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 38/41] hpsa: improve error messages for driver initiated
 commands
Date: Thu, 16 Jan 2014 09:42:52 +0100
Message-ID: <52D79B8C.9070708@suse.de>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com> <20140115223938.5061.20062.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaAPImx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 03:42:53 -0500
In-Reply-To: <20140115223938.5061.20062.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

On 01/15/2014 11:39 PM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>=20
> On encountering unexpected error conditions from driver initiated
> commands, print something useful like CDB and sense data rather than
> something useless like the kernel virtual address of the command buff=
er.
>=20
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |   71 ++++++++++++++++++++++++++++++++---------=
----------
>  1 files changed, 44 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 6a50a83..d469974 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1847,17 +1847,37 @@ static void hpsa_scsi_do_simple_cmd_with_retr=
y(struct ctlr_info *h,
>  	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
>  }
> =20
> -static void hpsa_scsi_interpret_error(struct CommandList *cp)
> +static void hpsa_print_cmd(struct ctlr_info *h, char *txt,
> +				struct CommandList *c)
>  {
> -	struct ErrorInfo *ei;
> +	const u8 *cdb =3D c->Request.CDB;
> +	const u8 *lun =3D c->Header.LUN.LunAddrBytes;
> +
> +	dev_warn(&h->pdev->dev, "%s: LUN:%02x%02x%02x%02x%02x%02x%02x%02x"
> +	" CDB:%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%=
02x\n",
> +		txt, lun[0], lun[1], lun[2], lun[3],
> +		lun[4], lun[5], lun[6], lun[7],
> +		cdb[0], cdb[1], cdb[2], cdb[3],
> +		cdb[4], cdb[5], cdb[6], cdb[7],
> +		cdb[8], cdb[9], cdb[10], cdb[11],
> +		cdb[12], cdb[13], cdb[14], cdb[15]);
> +}
Do you _really_ have to do this?
We do have scsi_logging_level, which would provide exactly this
information.
Can't you rely on the SCSI stack for logging here and drop all
the redundancy in the driver?

Thing is, the hpsa driver is already quite chatty:

hpsa 0000:4f:00.0: Direct-Access     device c0b0t0l0 added.
hpsa 0000:4f:00.0: RAID              device c0b3t0l0 added.
scsi 0:0:0:0: Direct-Access     HP       LOGICAL VOLUME   7.24 PQ
: 0 ANSI: 5
sd 0:0:0:0: [sda] 286677120 512-byte logical blocks: (146 GB/136
GiB)
scsi 0:3:0:0: RAID              HP       P400             7.24 PQ: 0
ANSI: 0

So where is the point of the first two messages?
The enumeration is internal anyway, so it has a very quesionable
value to the user. And the devices are listed afterwards anyway.

Hence it _might_ be an idea to remove some of those messages ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
