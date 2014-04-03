From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/6] be2iscsi: Fix MCCQ posting for Mbx-Cmd after driver
 initialization is complete
Date: Thu, 03 Apr 2014 13:30:39 -0500
Message-ID: <533DA8CF.3080800@cs.wisc.edu>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com> <1395938371-2149-3-git-send-email-Jayamohan.Kallickal@emulex.com> <5334C639.9000007@cs.wisc.edu> <d28ae082-c08a-4ac1-ad7f-044d6220fb98@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36174 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbaDCSa6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Apr 2014 14:30:58 -0400
In-Reply-To: <d28ae082-c08a-4ac1-ad7f-044d6220fb98@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Cc: Jayamohan Kallickal <jayamohank@gmail.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sony John-N <Sony.John-N@Emulex.Com>, "cleech@redhat.com" <cleech@redhat.com>

On 04/03/2014 12:02 AM, Jayamohan Kallickal wrote:
> 
> 
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
> Sent: Thursday, March 27, 2014 5:46 PM
> To: Jayamohan Kallickal; jbottomley@parallels.com; linux-scsi@vger.kernel.org
> Cc: Jayamohan Kallickal; Sony John-N
> Subject: Re: [PATCH 3/6] be2iscsi: Fix MCCQ posting for Mbx-Cmd after driver initialization is complete
> 
> On 03/27/2014 09:39 AM, Jayamohan Kallickal wrote:
>>  Even before probe for function was completed, iSCSI Daemon had 
>> initiated login  to target while OS was coming up. The targets which 
>> had node.startup=automatic,  login process was initiated.Since 
>> function specific initialization was still in  progress this lead to kernel panic.
>>  The reson was MCCQ was not yet created and login Mbx_Cmd was sent on MCCQ.
>>  wrb_from_mccq() failed with kernel-panic access.
>>
>>  In the fix checking in alloc_mcc_tag() if driver initialization is complete or not.
>>  Based on the result driver continues or return with an Error.
>>
>> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
>> Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
>> ---
>>  drivers/scsi/be2iscsi/be_cmds.c | 8 ++++++++  
>> drivers/scsi/be2iscsi/be_main.c | 2 ++  
>> drivers/scsi/be2iscsi/be_main.h | 1 +
>>  3 files changed, 11 insertions(+)
>>
>> diff --git a/drivers/scsi/be2iscsi/be_cmds.c 
>> b/drivers/scsi/be2iscsi/be_cmds.c index 1432ed5..4cabf5f 100644
>> --- a/drivers/scsi/be2iscsi/be_cmds.c
>> +++ b/drivers/scsi/be2iscsi/be_cmds.c
>> @@ -118,6 +118,14 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba 
>> *phba)  {
>>  	unsigned int tag = 0;
>>  
>> +
>> +	if (phba->state & BE_ADAPTER_INIT_PHASE) {
>> +		beiscsi_log(phba, KERN_ERR,
>> +			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
>> +			    "BC_%d : Driver Initialization still in progress\n");
>> +		return tag;
>> +	}
>> +
> 
>> I think normally we do not call scsi_host_add and expose the host until the driver can handle requests from entry points like sysfs and queuecommand.
> 
>> Can you just move iscsi_host_add from beiscsi_hba_alloc to beiscsi_dev_probe after beiscsi_setup_boot_info is called?
> 
> Tried moving iscsi_add_host and it did not help the issue where the ep_connect was being called before the probe is completed.
> 
> Chris Leech has a solution for this and when applied along with this patch works for us.
> 

Did you test the host add solution with Chris's fix? With your patch and
Chris's patch __session_create will return error. iscsiadm would then
retry and eventually the host would be added. With your patch,
__session_create -> iscsi_sysfs_get_host_no_from_hwinfo would probably
fail, because iscsid tries to read a host attr and gets a error because
the host is not yet setup.

If you move the host add and uses Chris's patch then something similar
should happen. The host will not even be in sysfs yet, so
iscsi_sysfs_get_host_no_from_hwinfo will fail. __session_create will
return error and iscsiadm will retry.

For what I am suggesting you do not need "if full_init" tests in every
driver. The host is not added until it is actually setup.
