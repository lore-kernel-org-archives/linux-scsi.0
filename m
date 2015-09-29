From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v4 12/32] cxlflash: Fix to avoid spamming the kernel log
Date: Tue, 29 Sep 2015 15:05:55 +1000
Message-ID: <560A1C33.8040709@au1.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222936-9385-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46057 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbI2FGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 01:06:36 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Tue, 29 Sep 2015 15:06:34 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 489D72CE8054
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:06:30 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8T56BHR42926092
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:06:19 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8T55u8T010898
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:05:57 +1000
In-Reply-To: <1443222936-9385-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 26/09/15 09:15, Matthew R. Ochs wrote:
> During run-time the driver can be very chatty and spam the system
> kernel log. Various print statements can be limited and/or moved
> to development-only mode. Additionally, numerous prints can be
> converted to trace the corresponding device.
>
> The following changes were made:
>   - pr_debug to pr_devel
>   - pr_debug to pr_debug_ratelimited
>   - pr_err to dev_err
>   - pr_debug to dev_dbg
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

Changes mostly look fine, further comments below.

> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -58,8 +58,8 @@ static struct afu_cmd *cmd_checkout(struct afu *afu)
>   		cmd = &afu->cmd[k];
>
>   		if (!atomic_dec_if_positive(&cmd->free)) {
> -			pr_debug("%s: returning found index=%d\n",
> -				 __func__, cmd->slot);
> +			pr_devel("%s: returning found index=%d cmd=%p\n",
> +				 __func__, cmd->slot, cmd);

>   	pr_debug("%s: cmd failed afu_rc=%d scsi_rc=%d fc_rc=%d "
> -		 "afu_extra=0x%X, scsi_entra=0x%X, fc_extra=0x%X\n",
> +		 "afu_extra=0x%X, scsi_extra=0x%X, fc_extra=0x%X\n",
>   		 __func__, ioasa->rc.afu_rc, ioasa->rc.scsi_rc,
>   		 ioasa->rc.fc_rc, ioasa->afu_extra, ioasa->scsi_extra,
>   		 ioasa->fc_extra);

Minor nitpicking: mention that you fix these in the commit message.

> @@ -240,9 +240,9 @@ static void cmd_complete(struct afu_cmd *cmd)
>   		cmd_is_tmf = cmd->cmd_tmf;
>   		cmd_checkin(cmd); /* Don't use cmd after here */
>
> -		pr_debug("%s: calling scsi_set_resid, scp=%p "
> -			 "result=%X resid=%d\n", __func__,
> -			 scp, scp->result, resid);
> +		pr_debug_ratelimited("%s: calling scsi_done scp=%p result=%X "
> +				     "ioasc=%d\n", __func__, scp, scp->result,
> +				     cmd->sa.ioasc);
>
>   		scsi_set_resid(scp, resid);
>   		scsi_dma_unmap(scp);

Why has the message changed from scsi_set_resid to scsi_done, and should 
the message be moved to immediately before the scsi_done call?


Andrew

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

