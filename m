From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 19/35] aacraid: split off lun reset function
Date: Fri, 23 Jun 2017 16:46:48 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5304D246@avsrvexchmbx2.microsemi.net>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
 <1498222975-71858-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0070.outbound.protection.outlook.com ([104.47.34.70]:44426
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752756AbdFWQrU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 12:47:20 -0400
In-Reply-To: <1498222975-71858-20-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

 -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Friday, June 23, 2017 7:03 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Hannes Reinecke <hare@suse.de>; Hannes Reinecke <hare@suse.com>
> Subject: [PATCH 19/35] aacraid: split off lun reset function
>=20
> The current host reset function does both, a LUN reset over all LUNs foll=
owed
> by a host reset.
> So split them off into individual functions.

Hi Hannes,

I don't have a problem with breaking out the two functions, however the LUN=
 reset only affects the current scmd, while your change will affect anythin=
g that has callback data, which may or may not be an scmd. In addition it i=
s impacting the whole controller, not just the device affected by the input=
 scmd ...

Thanks, -Dave
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/linit.c | 70 ++++++++++++++++++++++++++------------=
------
>  1 file changed, 41 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c =
index
> 0f277df..bbacbf2 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -815,11 +815,11 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)  }
>=20
> -                       if (fib->hw_fib_va->header.XferState &&
> -                               (fib->flags & FIB_CONTEXT_FLAG) &&
> -                               (fib->callback_data =3D=3D cmd)) {						<=
< only affects one scmd
> -                               fib->flags |=3D FIB_CONTEXT_FLAG_TIMED_OU=
T;
> -                               cmd->SCp.phase =3D AAC_OWNER_ERROR_HANDLE=
R;
> -                       }
> +       /* Mark the assoc. FIB to not complete, eh handler does this */
> +       for (count =3D 0; count < (host->can_queue + AAC_NUM_MGT_FIB);
> +            ++count) {
> +               struct fib *fib =3D &aac->fibs[count];
> +
> +               if (fib->hw_fib_va->header.XferState &&
> +                   (fib->flags & FIB_CONTEXT_FLAG) &&
> +                   fib->callback_data) {								<< affects anything with=
 callback data
> +                       fib->flags |=3D FIB_CONTEXT_FLAG_TIMED_OUT;
> +                       cmd =3D fib->callback_data;
> +                       cmd->SCp.phase =3D AAC_OWNER_ERROR_HANDLER;
> +                       ret =3D SUCCESS;
>                 }
>         }
> +       return ret;
> +}
