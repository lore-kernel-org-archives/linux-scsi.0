From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] Reduce amount of TURs sent in error recovery
Date: Tue, 29 Mar 2011 18:09:45 -0500
Message-ID: <4D9266B9.40209@cs.wisc.edu>
References: <4D80F6D0.1010404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49651 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1C2XIw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2011 19:08:52 -0400
In-Reply-To: <4D80F6D0.1010404@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <dhjeffery@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 03/16/2011 12:43 PM, David Jeffery wrote:
> +static int scsi_eh_test_devices(struct list_head *cmd_list, struct list_head *work_q, struct list_head *done_q, int try_stu)
> +{
> +	struct scsi_cmnd *scmd, *next;
> +	struct scsi_device *sdev;
> +	int finish_cmds;
> +
> +	while(!list_empty(cmd_list)){

Just some small nits. I think you need some white spaces. Other code 
does "while (!list_empty(cmd_list)) {"

> +		scmd = list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
> +		sdev = scmd->device;
> +
> +		finish_cmds = !scsi_device_online(scmd->device) ||
> +			(try_stu&&  !scsi_eh_try_stu(scmd)&&  !scsi_eh_tur(scmd)) ||
> +			!scsi_eh_tur(scmd);
> +			
> +		list_for_each_entry_safe(scmd, next, cmd_list, eh_entry)
> +			if (scmd->device == sdev) {
> +				if(finish_cmds)

Need space here too.
