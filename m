From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 1/2] Target/transport: SCSI Status Respond being
 sent to Initiator twice.
Date: Wed, 01 Oct 2014 14:24:34 -0700
Message-ID: <1412198674.5120.1.camel@haakon3.risingtidesystems.com>
References: <1411640549-8013-1-git-send-email-saurav.kashyap@qlogic.com>
	 <1411640549-8013-2-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56086 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaJAVYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 17:24:42 -0400
In-Reply-To: <1411640549-8013-2-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com

Hi Saurav,

Apologies for the delayed response, comments are below.

On Thu, 2014-09-25 at 06:22 -0400, Saurav Kashyap wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
> 
> During temporary resource starvation at lower transport layer, command
> is placed on queue full retry path, which expose this problem.  The TCM
> Qfull handling send the same cmd twice to lower layer.  The 1st time
> led to cmd normal free path.  The 2nd time cause Null pointer access.
> 
> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> ---
>  drivers/target/target_core_transport.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 7fa62fc..ab61014 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1877,8 +1877,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
>  	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
>  		trace_target_cmd_complete(cmd);
>  		ret = cmd->se_tfo->queue_status(cmd);
> -		if (ret)
> -			goto out;
> +		goto out;
>  	}
>  
>  	switch (cmd->data_direction) {

Applied to target-pending/for-next with a CC' to v3.1 stable, as the bug
was introduced as a regression in:

  commit e057f53308a5f071556ee80586b99ee755bf07f5
  Author: Christoph Hellwig <hch@infradead.org>
  Date:   Mon Oct 17 13:56:41 2011 -0400

Thank you,

--nab





