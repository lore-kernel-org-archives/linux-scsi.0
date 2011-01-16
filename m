From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [SCSI] target: Remove unneeded test of se_cmd
Date: Sat, 15 Jan 2011 23:12:21 -0800
Message-ID: <1295161941.22813.25.camel@haakon2.linux-iscsi.org>
References: <adazkr1z9hk.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58803 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1APHMZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Jan 2011 02:12:25 -0500
In-Reply-To: <adazkr1z9hk.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2011-01-15 at 21:46 -0800, Roland Dreier wrote:
> se_cmd is dereferenced unconditionally in many other parts of
> transport_get_lun_for_cmd() so remove the last test whether se_cmd is NULL.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> I'm not 100% sure of this patch (perhaps se_cmd can be NULL here and the
> whole rest of the function needs to be fixed instead), but this seems
> like the more sensible thing.
> 

Yep, the explict test for se_cmd is left-over legacy cruft, and can be
safely dropped here..  Committed as 722a630caa and pushed into
lio-core-2.6.git/linus-38-rc1 and scsi-post-merge-2.6.git/for-jejb.

Thanks again Roland!

--nab

>  drivers/target/target_core_device.c |   22 +++++++++-------------
>  1 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 317ce58..d94933d 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -69,21 +69,17 @@ int transport_get_lun_for_cmd(
>  	deve = se_cmd->se_deve =
>  			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
>  	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> -		if (se_cmd) {
> -			deve->total_cmds++;
> -			deve->total_bytes += se_cmd->data_length;
> -
> -			if (se_cmd->data_direction == DMA_TO_DEVICE) {
> -				if (deve->lun_flags &
> -						TRANSPORT_LUNFLAGS_READ_ONLY) {
> -					read_only = 1;
> -					goto out;
> -				}
> -				deve->write_bytes += se_cmd->data_length;
> -			} else if (se_cmd->data_direction ==
> -				   DMA_FROM_DEVICE) {
> -				deve->read_bytes += se_cmd->data_length;
> +		deve->total_cmds++;
> +		deve->total_bytes += se_cmd->data_length;
> +
> +		if (se_cmd->data_direction == DMA_TO_DEVICE) {
> +			if (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
> +				read_only = 1;
> +				goto out;
>  			}
> +			deve->write_bytes += se_cmd->data_length;
> +		} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
> +			deve->read_bytes += se_cmd->data_length;
>  		}
>  		deve->deve_cmds++;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

