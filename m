From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 06/20] target: Eliminate usage of struct se_mem
Date: Fri, 08 Jul 2011 17:38:17 -0700
Message-ID: <4E17A2F9.8090309@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com> <1310078011-15504-7-git-send-email-agrover@redhat.com> <20110708201331.GD12288@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1GIAiU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 20:38:20 -0400
In-Reply-To: <20110708201331.GD12288@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/08/2011 01:13 PM, Christoph Hellwig wrote:
>> @@ -1723,10 +1707,6 @@ transport_generic_get_task(struct se_cmd *cmd,
>>  	task->se_dev = dev;
>>  	task->task_data_direction = data_direction;
>>  
>> -	spin_lock_irqsave(&cmd->t_state_lock, flags);
>> -	list_add_tail(&task->t_list, &cmd->t_task_list);
>> -	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>> -
> 
> How is moving the task <-> cmd linkage related to the rest of the patch?
> It probably should be a separate preparatory patch, but at least needs
> some good documentation.

There's no clean (easy) way for me to extract this from the rest of the
patch, so I'm just going to add some text to the changelog.

BTW I've cleaned up alloc_task some more in a follow-on patch, will post
shortly.

>> +	if (cmd->t_bidi_data_sg &&
>> +	    (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
> 
> no need for braces around the comparism.

True, but they're not unusual, so I left instances like this.

>> +		ret = transport_allocate_control_task(cmd);
>> +		if (ret < 0)
>> +			return ret;
>> +		else
>> +			return 1;
> 
> Any reason you don't directly return the expected value from
> transport_allocate_control_task?

See patch 16, it fixes this.

Regards -- Andy
