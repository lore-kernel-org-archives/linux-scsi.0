From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 2/2] qla2xxx: Code changes for qla data structure refactoring
Date: Fri, 23 Jan 2009 11:47:45 -0600
Message-ID: <497A02C1.5000109@sgi.com>
References: <alpine.OSX.1.00.0811061031030.605@ac-mac.local> <20090122105016.GA100061@sgi.com> <20090122161338.GA30580@plap4-2.local> <3CE58734-9F21-4AF2-8E45-81A540C64BC7@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.171.31]:54276 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754977AbZAWRrs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 12:47:48 -0500
In-Reply-To: <3CE58734-9F21-4AF2-8E45-81A540C64BC7@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Jeremy Higdon <jeremy@sgi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Smart@emulex.com" <James.Smart@emulex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Driver <Linux-Driver@qlogic.com>

Anirban Chakraborty wrote:
> On Jan 22, 2009, at 8:13 AM, Andrew Vasquez wrote:
> 
>> On Thu, 22 Jan 2009, Jeremy Higdon wrote:
>>
>>> On Thu, Nov 06, 2008 at 10:40:51AM -0800, Anirban Chakraborty wrote:
>>>> Following changes have been made:
>>>> 1. Outstanding commands are based on a request queue,  
>>>> scsi_qla_host does not
>>>> maintain it anymore.
>>>> 2. start_scsi is accessed via isp_ops struct instead of direct  
>>>> invocation.
>>>> 3. Interrupt registrations are done using response queue instead  
>>>> of device id.
>>>>
>>>> Thanks,
>>>> Anirban
>>>>
>>>> Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
>>> Hello Anirban,
>>>
>>> We found a problem in this patch.
>>> The problem is that in the function qla2x00_probe_one() in qla_os.c,
>>> you should be calling qla2x00_config_dma_addressing() before calling
>>> qla2x00_mem_alloc(), so that the DMA mask can be set properly.
>>>
>>> Now I notice that qla2x00_config_dma_addressing() uses the virtual
>>> SCSI host, while qla2x00_mem_alloc() uses the physical host adapter
>>> structure.  I don't see why qla2x00_config_dma_addressing() couldn't
>>> be rewritten to use the physical host adapter structure.  But if not,
>>> then it may need to be split into two parts -- one to set the
>>> consistent dma mask and another to set the streaming dma mask.
>> Jeremy,
>>
>> Thanks for finding this.  I'll add the following patch into my
>> patch-queue if their's no major objections...
>>
>> --
>> av
>>
>> ---
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/ 
>> qla_os.c
>> index f344b68..703d8a8 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -65,8 +65,6 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
>>
>> static void qla2x00_free_device(scsi_qla_host_t *);
>>
>> -static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
>> -
>> int ql2xfdmienable=1;
>> module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
>> MODULE_PARM_DESC(ql2xfdmienable,
>> @@ -1242,9 +1240,8 @@ qla2x00_change_queue_type(struct scsi_device  
>> *sdev, int tag_type)
>>  * supported addressing method.
>>  */
>> static void
>> -qla2x00_config_dma_addressing(scsi_qla_host_t *vha)
>> +qla2x00_config_dma_addressing(struct qla_hw_data *ha)
>> {
>> -	struct qla_hw_data *ha = vha->hw;
>> 	/* Assume a 32bit DMA mask. */
>> 	ha->flags.enable_64bit_addressing = 0;
>>
>> @@ -1870,6 +1867,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const  
>> struct pci_device_id *id)
>>
>> 	set_bit(0, (unsigned long *) ha->vp_idx_map);
>>
>> +	qla2x00_config_dma_addressing(ha);
>> 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
>> 	if (!ret) {
>> 		qla_printk(KERN_WARNING, ha,
>> @@ -1896,8 +1894,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const  
>> struct pci_device_id *id)
>>
>> 	pci_set_drvdata(pdev, base_vha);
>>
>> -	qla2x00_config_dma_addressing(base_vha);
>> -
>> 	host = base_vha->host;
>> 	base_vha->req_ques[0] = req->id;
>> 	host->can_queue = req->length + 128;
> 
> The patch looks good to me. Thanks Jeremy for pointing it out.
> -Anirban
> 
I tested this patch on a system which exhibited the problem.  The
patch has addressed the issue.

Mike
