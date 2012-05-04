From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Handle GET_EVENT_STATUS_NOTIFICATION
 passthrough
Date: Thu, 03 May 2012 18:24:06 -0700
Message-ID: <1336094646.22393.102.camel@haakon2.linux-iscsi.org>
References: <1335800113-28075-1-git-send-email-stefanha@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33195 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab2EDBYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2012 21:24:09 -0400
In-Reply-To: <1335800113-28075-1-git-send-email-stefanha@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 16:35 +0100, Stefan Hajnoczi wrote:
> The SCSI MMC GET_EVENT_STATUS_NOTIFICATION command can be used to find
> out about media change, among other things.  This patch adds it to the
> command sequencer so that PSCSI CD-ROM passthrough works with modern
> Linux guests that issue this command.
> 
> Tested-by: Cong Meng <mengcong@cn.ibm.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_transport.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index a953ca0..5b83fd2 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3146,6 +3146,10 @@ static int transport_generic_cmd_sequencer(
>  			cmd->sam_task_attr = MSG_HEAD_TAG;
>  		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
> +	case GET_EVENT_STATUS_NOTIFICATION:
> +		size = (cdb[7] << 8) | cdb[8];
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
> +		break;
>  	default:
>  		pr_warn("TARGET_CORE[%s]: Unsupported SCSI Opcode"
>  			" 0x%02x, sending CHECK_CONDITION.\n",

Applied to lio-core, and will get this added into for-next for 3.5-rc1

Thanks Cong + Stefan!

--nab

