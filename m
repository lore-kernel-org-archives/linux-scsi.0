From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/12] qla4xxx: fixed NULL pointer dereference in	eh_device_reset
Date: Tue, 06 Apr 2010 23:18:44 -0500
Message-ID: <4BBC07A4.6060207@cs.wisc.edu>
References: <20100406101413.GM22922@linux-qf4p> <4BBC01F9.7090409@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34458 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0DGEO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2010 00:14:28 -0400
In-Reply-To: <4BBC01F9.7090409@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

On 04/06/2010 10:54 PM, Mike Christie wrote:
> On 04/06/2010 05:14 AM, Ravi Anand wrote:
>> From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>>
>> Created variables to reference h, b, t, l, because if
>> scsi passthru command completes within eh_device_reset,
>> the cmd structure may no longer be valid.
>
>
>> @@ -1587,16 +1587,34 @@ static int qla4xxx_eh_wait_for_commands(struct
>> scsi_qla_host *ha,
>> **/
>> static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
>> {
>> - struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
>> - struct ddb_entry *ddb_entry = cmd->device->hostdata;
>> + struct scsi_qla_host *ha;
>> + struct ddb_entry *ddb_entry;
>> int ret = FAILED, stat;
>> + struct Scsi_Host *h;
>> + unsigned int b, t, l;
>> +
>> + if (cmd == NULL) {
>> + DEBUG2(printk(KERN_INFO "%s: **** SCSI mid-layer passing in"
>> + " NULL cmd DEVICE RESET - cmd already"
>> + " completed.\n", __func__));
>> + return SUCCESS;
>> + }
>>
>> - if (!ddb_entry)
>> - return ret;
>> + h = cmd->device->host;
>> + b = cmd->device->channel;
>> + t = cmd->device->id;
>> + l = cmd->device->lun;
>> + ha = to_qla_host(h);
>> + ddb_entry = cmd->device->hostdata;
>
>
> Could it complete normally while you are accessing the cmd above still?

Actually, I do not think it matters. For pass through did you mean 
scsi_reset_provider? If so the scmd passed to you for the 
scsi_reset_provider code path is allocated by scsi_reset_provider, so it 
is fine. For the normal code path (the scsi_unjam_host path), the scsi 
completion code is supposed to prevent the scsi cmd from getting 
completed when that code is running. If it is not then I think we are 
going to have other problems.
