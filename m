From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: Check LUN numbers
Date: Sun, 13 Feb 2011 14:43:00 -0800
Message-ID: <1297636980.13306.136.camel@haakon2.linux-iscsi.org>
References: <AANLkTimQktk0e2dLiHB=YQNC1tUS1HYgnD3MF76it2Sq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40764 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1BMWtc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2011 17:49:32 -0500
In-Reply-To: <AANLkTimQktk0e2dLiHB=YQNC1tUS1HYgnD3MF76it2Sq@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2011-02-13 at 09:24 +0100, Fubo Chen wrote:
> Check LUN before reading from device_list[] array.
> 
> Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
> ---
>  drivers/target/target_core_device.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+), 0 deletions(-)
> 

I think this is a reasonable check to add considering the number of TCM
fabric modules calling transport_get_lun_for_[cmd,tmr]() directly.

Note this patch did not apply cleanly because of the extra BUG_ON() in
transport_get_lun_for_cmd(), but has been fixed + committed as
0f75d7cf4b259.

Thanks!

--nab

> diff --git a/drivers/target/target_core_device.c
> b/drivers/target/target_core_device.c
> index 27d4858..ba16ad9 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -67,6 +67,13 @@ int transport_get_lun_for_cmd(
> 
>  	BUG_ON(!se_sess);
>  	BUG_ON(!SE_NODE_ACL(se_sess));
> +
> +	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
> +		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
> +		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> +		return -EINVAL;
> +	}
> +
>  	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
>  	deve = se_cmd->se_deve =
>  			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
> @@ -186,6 +193,12 @@ int transport_get_lun_for_tmr(
>  	struct se_session *se_sess = SE_SESS(se_cmd);
>  	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
> 
> +	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
> +		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
> +		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> +		return -EINVAL;
> +	}
> +
>  	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
>  	deve = se_cmd->se_deve =
>  			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];

