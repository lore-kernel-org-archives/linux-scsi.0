From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/4] stex: fix reset recovery for console device
Date: Thu, 10 May 2007 17:04:12 -0400
Message-ID: <464388CC.8030103@garzik.org>
References: <NONAMEBPke3fzk76oJD00001143@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60343 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762040AbXEJVEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2007 17:04:14 -0400
In-Reply-To: <NONAMEBPke3fzk76oJD00001143@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
> After reset completed, the scsi error handler sends out TEST_UNIT_READY
> to the device. For 'normal' devices the command will be handled by firmware.
> However, because the RAID console only interfaces to scsi mid layer, the
> firmware will not process the command for it. This will make the console to
> be offlined right after reset. Add the handling in driver to fix this problem.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>
> ---
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 81dd3b7..47c2ef9 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -612,6 +612,13 @@ stex_queuecommand(struct scsi_cmnd *cmd,
>  			return 0;
>  		}
>  		break;
> +	case TEST_UNIT_READY:
> +		if (id == host->max_id - 1) {
> +			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +			done(cmd);
> +			return 0;
> +		}
> +		break;

Long term, it seems like a more obvious separation between the RAID 
console and the firmware-handled devices would be useful, rather than 
repeating the "if (id == host->max_id - 1)" for each command in question.


