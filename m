From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 05/15] target: Eliminate usage of struct se_mem
Date: Tue, 28 Jun 2011 16:22:24 -0700
Message-ID: <4E0A6230.9040809@redhat.com>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com> <1309289377-8029-6-git-send-email-agrover@redhat.com> <20110628211228.GA7594@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab1F1XW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 19:22:29 -0400
In-Reply-To: <20110628211228.GA7594@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/28/2011 02:12 PM, Christoph Hellwig wrote:
> This code pretty much is exactly the same as allocation in
> iscsit_alloc_buffs.  If we can't switch iscsi to use internal buffers
> directly we should at least export this helper so it can use it.
> 
> That also means killing the superflous t_mem_sg/t_mem_sg_nents members
> in favour of t_data/t_data_nents.

Yeah I think iscsi can go back to relying on the core to allocate. I
know it's a little weird to change it to self-allocation and then back,
but what the move to self-allocation *really* was about was getting
se_mem out of iscsi. Now that core no longer has se_mem, and allocating
data buffs doesn't involve task switches, having core allocate data
buffs sounds good again.

>> +		ret = transport_allocate_control_task(cmd);
>> +		if (ret < 0)
>> +			return ret;
>> +		else
>> +			return 1;
> 
> What about making transport_allocate_control_task return the expected
> value directly?

Yeah you're right.

>> @@ -4863,19 +4395,13 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>>  	if (ret < 0)
>>  		return ret;
>>  
>> -	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
>> -		list_for_each_entry(task, &cmd->t_task_list, t_list) {
>> -			if (atomic_read(&task->task_sent))
>> -				continue;
>> -			if (!dev->transport->map_task_SG)
>> -				continue;
>> -
>> -			ret = dev->transport->map_task_SG(task);
>> -			if (ret < 0)
>> -				return ret;
>> -		}
>> -	} else {
>> -		ret = transport_map_control_cmd_to_task(cmd);
>> +	list_for_each_entry(task, &cmd->t_task_list, t_list) {
>> +		if (atomic_read(&task->task_sent))
>> +			continue;
>> +		if (!dev->transport->map_task_SG)
>> +			continue;
>> +  
>> +		ret = dev->transport->map_task_SG(task);
> 
> transport_map_control_cmd_to_task might have called ->cdb_none
> before.  While I'd love to kill that method I haven't seen any work
> towards actually making that happen.  So for now I suspect you'll
> still need the conditionally call to ->cdb_none.

Whups, ok.

Regards -- Andy
