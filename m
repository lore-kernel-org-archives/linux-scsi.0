From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 11:04:32 +0100
Message-ID: <5698C430.5030102@suse.de>
References: <20160114214602.GC3520@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbcAOKEe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 05:04:34 -0500
In-Reply-To: <20160114214602.GC3520@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

On 01/14/2016 10:46 PM, Tejun Heo wrote:
> SCSI command completion path bumps ioerr_cnt whenever scsi_cmd->resul=
t
> isn't zero; unfortunately, this means that non-error sense reporting
> bumps the counter too.  This is pronounced with ATA passthrough
> commands because most of them explicitly request the resulting
> taskfile to be transported via sense data bumping the count
> unconditionally.
>
> Don't bump the counter if scsi_cmd->result simply indicates that sens=
e
> data is available.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Dave Jones <dsj@fb.com>
> ---
>   drivers/scsi/scsi_lib.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fa6b2c4..e90e3f7 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1622,7 +1622,8 @@ static void scsi_softirq_done(struct request *r=
q)
>   	INIT_LIST_HEAD(&cmd->eh_entry);
>
>   	atomic_inc(&cmd->device->iodone_cnt);
> -	if (cmd->result)
> +	if (cmd->result &&
> +	    cmd->result !=3D ((DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITI=
ON))
>   		atomic_inc(&cmd->device->ioerr_cnt);
>
>   	disposition =3D scsi_decide_disposition(cmd);

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
