From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 06/15] qla4xxx: Do not wait for the outstanding commands
 to complete
Date: Mon, 11 Oct 2010 02:24:40 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406BE7@AVEXMB1.qlogic.org>
References: <5E4F49720D0BAD499EE1F01232234BA87129406789@AVEXMB1.qlogic.org>
 <4CAE8604.1020702@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:45206 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0JKJYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2010 05:24:45 -0400
In-Reply-To: <4CAE8604.1020702@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Nilesh Javali <nilesh.javali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Friday, October 08, 2010 8:16 AM
>To: Vikas Chaudhary
>Cc: James.Bottomley@suse.de; linux-scsi@vger.kernel.org; Nilesh Javali;
>Ravi Anand
>Subject: Re: [PATCH 06/15] qla4xxx: Do not wait for the outstanding
>commands to complete
>
>On 10/07/2010 12:49 AM, Vikas Chaudhary wrote:
>> From: Nilesh Javali<nilesh.javali@qlogic.com>
>>
>> Do not wait for the outstanding commands to complete in case of
>> firmware hang.
>>
>> Signed-off-by: Nilesh Javali<nilesh.javali@qlogic.com>
>> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
>> ---
>>   drivers/scsi/qla4xxx/ql4_os.c |    6 ++++--
>>   1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c
>> b/drivers/scsi/qla4xxx/ql4_os.c index 56962e5..a6455fb 100644
>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>> @@ -1102,7 +1102,8 @@ static int qla4xxx_recover_adapter(struct
>scsi_qla_host *ha)
>>   		    ha->host_no, __func__));
>>   		status = ha->isp_ops->reset_firmware(ha);
>>   		if (status == QLA_SUCCESS) {
>> -			qla4xxx_cmd_wait(ha);
>> +			if (!test_bit(AF_FW_RECOVERY,&ha->flags))
>> +				qla4xxx_cmd_wait(ha);
>>   			ha->isp_ops->disable_intrs(ha);
>>   			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
>>   			qla4xxx_abort_active_cmds(ha, DID_RESET<<  16); @@ -
>1119,7
>> +1120,8 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
>>   	 * or if stop_firmware fails for ISP-82xx.
>>   	 * This is the default case for ISP-4xxx */
>>   	if (!is_qla8022(ha) || reset_chip) {
>> -		qla4xxx_cmd_wait(ha);
>> +		if (!test_bit(AF_FW_RECOVERY,&ha->flags))
>> +			qla4xxx_cmd_wait(ha);
>>   		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
>>   		qla4xxx_abort_active_cmds(ha, DID_RESET<<  16);
>>   		DEBUG2(ql4_printk(KERN_INFO, ha,
>
>If we go from qla4xxx_eh_host_reset->qla4xxx_recover_adapter and you do not
>wait, is is possible for the driver to be accessing scsi commands after
>qla4xxx_eh_host_reset returns? If so I think there is a problem where the
>scsi eh will fail or retry the cmd so the memory for the scsi command could
>be reallocated/freed.
>

We do not access command after qla4xxx_eh_host_reset returns.

>On a related note, has qla4xxx_eh_host_reset ever returned SUCCESS? I think
>there is a problem in qla4xxx_cmd_wait when the scsi eh is running. At that
>time blk_finish_request->blk_queue_end_tag is not going to be run, because
>if the driver were to call scsi_done the block layer would do
>blk_complete_request and the blk_mark_rq_complete would fail (this is
>because the scsi/block eh timeout could has already marked it complete).
>
>I think you need the attached patch.

Yes. We need attached patch. I am doing some testing with this patch.
I will send out this patch for inclusion soon.
