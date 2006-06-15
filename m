From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Ubuntu PATCH] lpfc: Add missing proc_name entry to scsi_host_table
Date: Thu, 15 Jun 2006 15:05:34 -0700
Message-ID: <4491D9AE.1080607@oracle.com>
References: <4491BC65.8010202@oracle.com> <4491BE0A.8030209@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:33480 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1031375AbWFOVFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 17:05:16 -0400
In-Reply-To: <4491BE0A.8030209@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@SteelEye.com>, akpm <akpm@osdl.org>

James Smart wrote:
> Is this destined for upstream (2.6.16 or later) ? If it is, I don't see why
> this change is needed, as:
> - As lpfc doesn't support /proc interface, it never initializes the fields
>   in the host template, so proc_info and proc_name will be null.
> - scsi_proc_hostdir_add() validates that sht->proc_info is non-null before
>   attempting to use sht->proc_name.
> - the only reference in scsi_sysfs properly deals with a null name pointer
>   (e.g. the proc_name is an empty string). Which seems the right thing to
>   do if there is no proc entry.
> 
> That said - the change is trivial, so I really don't mind if it goes in.

Hi James,

It's not necessarily "destined".  It's in the Ubuntu kernel tree and I'm
in the process of scrubbing thru their kernel tree to see what (if anything)
should/could be considered for adding to the mainline kernel tree.

If their patch justification is incorrect, then it's definitely not
destined.

Thanks,
~Randy

> Randy Dunlap wrote:
>> [UBUNTU:drivers/scsi/lpfc] Add missing proc_name entry to 
>> scsi_host_table.
>>
>> http://www.kernel.org/git/?p=linux/kernel/git/bcollins/ubuntu-dapper.git;a=commitdiff;h=8e3174d462c06d45138ff7a9a25667a7347ff5ab 
>>
>>
>> According to a few people, the scsi proc interface should die, but sysfs
>> still uses some proc_* entries from scsi_host_table.
>>
>> The Emulex driver needs to export at least proc_name.
>>
>> Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
>> ---
>> drivers/scsi/lpfc/lpfc_scsi.c |    1 +
>> 1 files changed, 1 insertion(+)
>>
>> --- linux-2617-rc6g7.orig/drivers/scsi/lpfc/lpfc_scsi.c
>> +++ linux-2617-rc6g7/drivers/scsi/lpfc/lpfc_scsi.c
>> @@ -1269,6 +1269,7 @@ struct scsi_host_template lpfc_template     
>> .slave_alloc        = lpfc_slave_alloc,
>>     .slave_configure    = lpfc_slave_configure,
>>     .slave_destroy        = lpfc_slave_destroy,
>> +    .proc_name        = "lpfc",
>>     .this_id        = -1,
>>     .sg_tablesize        = LPFC_SG_SEG_CNT,
>>     .cmd_per_lun        = LPFC_CMD_PER_LUN,
>>
>>

