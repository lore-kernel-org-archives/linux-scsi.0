From: Luben Tuikov <tluben@rogers.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Tue, 20 May 2003 17:25:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECA9D46.7010301@rogers.com>
References: <Pine.LNX.4.44L0.0305191433280.1042-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep03-mail.bloor.is.net.cable.rogers.com ([66.185.86.73]:45419
	"EHLO fep03-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261193AbTETVMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2003 17:12:37 -0400
In-Reply-To: <Pine.LNX.4.44L0.0305191433280.1042-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Alan Stern wrote:
> ===== scsi_error.c 1.27 vs edited =====
> --- 1.27/drivers/scsi/scsi_error.c	Sun May  4 12:50:44 2003
> +++ edited/drivers/scsi/scsi_error.c	Mon May 19 14:17:04 2003
> @@ -753,6 +753,8 @@
>  	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
>  	scmd->underflow = 0;
>  	scmd->sc_data_direction = SCSI_DATA_NONE;
> +	if ((scmd->serial_number -= 999999) == 0)
> +		scmd->serial_number -= 999999;
>  
>  	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT);

Alan, could you please explain this patch?

This looks like:
	if (sn == 999999)
		sn = -sn;

for _that_ particular command, but scsi_core->sn stays unchanged...

Q: Which value does USB Storage reserve for cmdsn, 0 or MAX?

-- 
Luben



