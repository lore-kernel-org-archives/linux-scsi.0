From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/15] be2iscsi: Set mbox timeout to 30s
Date: Fri, 18 Dec 2015 10:00:18 +0100
Message-ID: <5673CB22.4010405@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-6-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567AbbLRJAU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:00:20 -0500
In-Reply-To: <1450194906-12925-6-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/15/2015 04:54 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> FW recommended timeout for all mbox command is 30s.
> Use msleep instead mdelay to relinquish CPU when polling for
> mbox completion.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index 6f58063..1e70053 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -587,7 +587,8 @@ int be_mcc_notify_wait(struct beiscsi_hba *phba)
>    **/
>   static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
>   {
> -#define BEISCSI_MBX_RDY_BIT_TIMEOUT	12000	/* 12sec */
> +	/* wait 30s for generic non-flash MBOX operation */
> +#define BEISCSI_MBX_RDY_BIT_TIMEOUT	30000
>   	void __iomem *db =3D ctrl->db + MPU_MAILBOX_DB_OFFSET;
>   	struct beiscsi_hba *phba =3D pci_get_drvdata(ctrl->pdev);
>   	unsigned long timeout;
> @@ -612,7 +613,7 @@ static int be_mbox_db_ready_wait(struct be_ctrl_i=
nfo *ctrl)
>
>   		if (time_after(jiffies, timeout))
>   			break;
> -		mdelay(1);
> +		msleep(20);
>   	} while (!ready);
>
>   	beiscsi_log(phba, KERN_ERR,
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
