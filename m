From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 8/9] mpt2sas: Enable new EH timeout handler
Date: Mon, 10 Jun 2013 11:31:11 -0400
Message-ID: <20130610153111.GB18076@logfs.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59503 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3FJRAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jun 2013 13:00:36 -0400
Content-Disposition: inline
In-Reply-To: <1370850058-27613-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Mon, 10 June 2013 09:40:57 +0200, Hannes Reinecke wrote:
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2=
sas/mpt2sas_scsih.c
> index c6bdc92..47fc66c 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -2565,6 +2565,16 @@ _scsih_tm_display_info(struct MPT2SAS_ADAPTER =
*ioc, struct scsi_cmnd *scmd)
>  }
> =20
>  /**
> + * _scsih_timed_out - eh timeout handler
> + * @scmd: pointer to scsi command object
> + */
> +static enum blk_eh_timer_return
> +_scsih_timed_out(struct scsi_cmnd *scmd)
> +{
> +	return scsi_abort_command(scmd);
> +}

Why did you create this function and not do the following?
+	.eh_timed_out			=3D scsi_abort_command,

> +/**
>   * _scsih_abort - eh threads main abort routine
>   * @scmd: pointer to scsi command object
>   *
> @@ -7515,6 +7525,7 @@ static struct scsi_host_template scsih_driver_t=
emplate =3D {
>  	.scan_start			=3D _scsih_scan_start,
>  	.change_queue_depth 		=3D _scsih_change_queue_depth,
>  	.change_queue_type		=3D _scsih_change_queue_type,
> +	.eh_timed_out			=3D _scsih_timed_out,
>  	.eh_abort_handler		=3D _scsih_abort,
>  	.eh_device_reset_handler	=3D _scsih_dev_reset,
>  	.eh_target_reset_handler	=3D _scsih_target_reset,
> --=20
> 1.7.12.4
>=20

J=C3=B6rn

--
The cheapest, fastest and most reliable components of a computer
system are those that aren't there.
-- Gordon Bell, DEC labratories
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
