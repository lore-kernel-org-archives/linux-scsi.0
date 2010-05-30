From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/2] [tgt]: Add support for SG_IO CDB passthrough in scsi_cmd_perform()
Date: Sun, 30 May 2010 12:02:35 +0300
Message-ID: <4C0229AB.1090506@panasas.com>
References: <1274159589-6095-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:57143 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437Ab0E3JCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 May 2010 05:02:43 -0400
In-Reply-To: <1274159589-6095-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>

On 05/18/2010 08:13 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch changes usr/scsi.c:scsi_cmd_perform() to first check to see if
> the struct backingstore_template->bs_passthrough=1 for SG_IO, then
> check for a valid struct device_type_template->cmd_passthrough()
> function pointer to determine if the device supports SG_IO.
> 
> This patch then updates the device_type in usr/sb.c to enable the functionality
> for TYPE_DISK.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  usr/sbc.c  |    1 +
>  usr/scsi.c |   11 +++++++++++
>  usr/tgtd.h |    1 +
>  3 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/usr/sbc.c b/usr/sbc.c
> index a048d53..d53f7f9 100644
> --- a/usr/sbc.c
> +++ b/usr/sbc.c
> @@ -269,6 +269,7 @@ static struct device_type_template sbc_template = {
>  	.lu_online	= spc_lu_online,
>  	.lu_offline	= spc_lu_offline,
>  	.lu_exit	= spc_lu_exit,
> +	.cmd_passthrough = sbc_rw,
>  	.ops		= {
>  		{spc_test_unit,},
>  		{spc_illegal_op,},
> diff --git a/usr/scsi.c b/usr/scsi.c
> index cef231b..1db786e 100644
> --- a/usr/scsi.c
> +++ b/usr/scsi.c
> @@ -242,6 +242,17 @@ int scsi_cmd_perform(int host_no, struct scsi_cmd *cmd)
>  
>  	if (spc_access_check(cmd))
>  		return SAM_STAT_RESERVATION_CONFLICT;
> +	/* 
> +	 * Use dev_type_template->cmd_passthrough() for usr/bs_sg.c devices
> +	 */
> +	if (cmd->dev->bst->bs_passthrough) {
> +		if (!(cmd->dev->dev_type_template.cmd_passthrough)) {
> +			eprintf("cmd->dev->dev_type_template.cmd_passthrough()"
> +				" is NULL!\n");
> +			return SAM_STAT_CHECK_CONDITION;
> +		}
> +		return cmd->dev->dev_type_template.cmd_passthrough(host_no, cmd);
> +	}
>  

Can't you just perform this check once somewhere and set cmd_perform to the
new cmd_passthrough? why check for every command?

This is not accepted it is the hot path.

>  	return cmd->dev->dev_type_template.ops[op].cmd_perform(host_no, cmd);
>  }
> diff --git a/usr/tgtd.h b/usr/tgtd.h
> index 4f26a29..f8ee47f 100644
> --- a/usr/tgtd.h
> +++ b/usr/tgtd.h
> @@ -108,6 +108,7 @@ struct device_type_template {
>  	int (*lu_config)(struct scsi_lu *lu, char *args);
>  	int (*lu_online)(struct scsi_lu *lu);
>  	int (*lu_offline)(struct scsi_lu *lu);
> +	int (*cmd_passthrough)(int, struct scsi_cmd *);
>  

Actually you can do more:
If you leave the checking and decisions to the target driver
then you don't need to touch this file. Just let the device_type
decide which vector to set once it knows what target is used.

(Like start with a vector that check and sets the vector to
 the passthrough or the regular path, on first IO)

>  	struct device_type_operations ops[256];
>  

Boaz
