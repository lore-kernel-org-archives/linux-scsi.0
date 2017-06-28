From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 04/47] aacraid: use aac_tmf_callback for reset fib
Date: Wed, 28 Jun 2017 19:42:45 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5304EDBF@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0066.outbound.protection.outlook.com ([104.47.40.66]:65376
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751515AbdF1Tmz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 15:42:55 -0400
In-Reply-To: <1498638793-44672-5-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>

>=20
>=20
> When sending a reset fib we shouldn't rely on the scsi command, but rathe=
r set
> the TMF status in the map_info->reset_state variable.
> That allows us to send a TMF independent on a scsi command.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
<snip>
>  /*
>   *     aac_eh_dev_reset        - Device reset command handling
>   *     @scsi_cmd:      SCSI command block causing the reset
> +921,19 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
<snip>
>=20
>         /* Wait up to 15 seconds for completion */
>         for (count =3D 0; count < 15; ++count) {
> -               if (cmd->SCp.sent_command) {
> -                       ret =3D SUCCESS;
> +               if (info->reset_state =3D=3D 0) {

Should this be <=3D 0, as in target reset? Otherwise it will always be succ=
ess ...

-Dave

> +                       ret =3D info->reset_state =3D=3D 0 ? SUCCESS : FA=
ILED;
>                         break;
