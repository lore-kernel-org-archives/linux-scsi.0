From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Patch] scsi_error: should not get sense for timeout IO in scsi
 error handler
Date: Fri, 31 Jul 2015 15:17:33 +0200
Message-ID: <55BB756D.5090606@suse.de>
References: <OFAF74C95C.6058723F-ON48257E93.00322982-48257E93.00363C6C@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbbGaNRh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:17:37 -0400
In-Reply-To: <OFAF74C95C.6058723F-ON48257E93.00322982-48257E93.00363C6C@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jiang.biao2@zte.com.cn, linux-scsi@vger.kernel.org, JBottomley@odin.com

On 07/31/2015 11:52 AM, jiang.biao2@zte.com.cn wrote:
> scsi_error: should not get sense for timeout IO in scsi error handler
>=20
> When an IO timeout occurs, the IO will be aborted in
> scsi_abort_command() and SCSI_EH_ABORT_SCHEDULED will be set. Because
> of that, the SCSI_EH_CANCEL_CMD will be clear in scsi_eh_scmd_add().
> So when scsi error handler starts, it will get sense for this
> timeout IO and the scmd of the IO request will be reused. In that
> case, the scmd may be double released when racing with io_done(),
> which will result in crash.
> SO SCSI_EH_ABORT_SCHEDULED should also be checked when getting sense.
> The bug maybe reproduced when the link between host and disk is
> unstable.
>=20
> Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
> Signed-off-by: Long Chun <long.chun@zte.com.cn>
> Reviewed-by: Tan Hu <tan.hu@zte.com.cn>
> Reviewed-by: Chen Donghai <chen.donghai@zte.com.cn>
> Reviewed-by: Cai Qu <cai.qu@zte.com.cn>
>=20
> diff -uprN drivers/scsi/scsi_error.c drivers_new/scsi/scsi_error.c
> --- scsi/scsi_error.c   2015-07-31 16:03:18.000000000 +0800
> +++ scsi_new/scsi_error.c       2015-07-31 16:29:25.000000000 +0800
> @@ -1156,9 +1156,14 @@ int scsi_eh_get_sense(struct list_head *
>         struct Scsi_Host *shost;
>         int rtn;
>=20
> +       /*
> +        * If SCSI_EH_ABORT_SCHEDULED has been set, it is timeout IO,
> +        * should not get sense.
> +        */
>         list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>                 if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
> -                   SCSI_SENSE_VALID(scmd))
> +                   (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) ||
> +                    SCSI_SENSE_VALID(scmd))
>                         continue;
>=20
>                 shost =3D scmd->device->host;
> --
_Actually_ you need to test for both, SCSI_EH_CANCEL_CMD _and_
SCSI_EH_ABORT_SCHEDULED.
Not every driver is required to implement and/or support
asynchronous command aborts, and those will be setting
SCSI_EH_CANCEL_CMD even though they've run into a timeout.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
