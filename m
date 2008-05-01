From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH 2/2] qla4xxx: return SCSI_MLQUEUE_TARGET_BUSY when
	driver has detected session error
Date: Thu, 01 May 2008 15:41:45 -0700
Message-ID: <1209681705.22126.8.camel@d5102avq18960>
References: <1209442937-15130-1-git-send-email-michaelc@cs.wisc.edu>
	 <1209442937-15130-2-git-send-email-michaelc@cs.wisc.edu>
	 <1209442937-15130-3-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7424 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYEAWlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 18:41:52 -0400
In-Reply-To: <1209442937-15130-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-04-28 at 23:22 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When qla4xxx begins recovery and the iscsi class is firing up to handle
> it, we need to retrn SCSI_MLQUEUE_TARGET_BUSY from the driver instead
> of host busy, because the session recovery only affects the one target.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 0c78694..873dc6b 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -439,7 +439,7 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc_fail_command;
>  		}
> -		goto qc_host_busy;
> +		return SCSI_MLQUEUE_TARGET_BUSY;
>  	}
>  
>  	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
Acked-by: David C Somayajulu <david.somayajulu@qlogic.com>
