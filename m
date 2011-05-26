From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH] Reduce error recovery time by reducing use of TURs
Date: Thu, 26 May 2011 13:37:16 +0530
Message-ID: <4DDE0A34.7090300@suse.de>
References: <4DD56448.7060003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50865 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab1EZIFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2011 04:05:51 -0400
In-Reply-To: <4DD56448.7060003@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <dhjeffery@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 05/20/2011 12:11 AM, David Jeffery wrote:
>...
>  
>  /**
> + * scsi_eh_test_devices - check if devices are responding from error recovery.
> + * @cmd_list:	scsi commands in error recovery.
> + * @work_q:     queue for commands which still need more error recovery
> + * @done_q:     queue for commands which are finished
> + * @try_stu:    boolean on if a STU command should be tried in addition to TUR.
> + *
> + * Decription:
> + *    Tests if devices are in a working state.  Commands to devices now in
> + *    a working state are sent to the done_q while commands to devices which
> + *    are still failing to respond are returned to the work_q for more
> + *    processing.
> + **/
> +static int scsi_eh_test_devices(struct list_head *cmd_list, struct list_head *work_q, struct list_head *done_q, int try_stu)
> +{
> +	struct scsi_cmnd *scmd, *next;
> +	struct scsi_device *sdev;
> +	int finish_cmds;
> +
> +	while (!list_empty(cmd_list)) {
> +		scmd = list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
> +		sdev = scmd->device;
> +
> +		finish_cmds = !scsi_device_online(scmd->device) || 
> +			(try_stu && !scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd)) ||
> +			!scsi_eh_tur(scmd);

If "(try_stu && !scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd))" is false,
then this could be sending the TUR command twice. I'm very new to this,
so am not sure what the cost/implication of doing that might be, but it
seems like, that wasn't the intention.

Thanks,
-- 
Ankit Jain
SUSE Labs
