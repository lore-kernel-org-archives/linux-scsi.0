From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH ver3 3/4] qla4xxx: use dev_xxx on some pci/dma resource
 alloc warning and error printks
Date: Thu, 10 Aug 2006 06:18:26 -0400
Message-ID: <44DB07F2.9060704@cs.wisc.edu>
References: <20060805225156.9557.99072.stgit@bebe.enoyolf.org> <20060805225227.9557.30796.stgit@bebe.enoyolf.org> <20060809230550.480743@bebe.enoyolf.org> <44DB01F2.9000101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:22951 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161168AbWHJLSk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 07:18:40 -0400
In-Reply-To: <44DB01F2.9000101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Doug Maxey wrote:
>> On Wed, 09 Aug 2006 13:52:07 EDT, Mike Christie wrote:
>> ...
>>>> @@ -836,9 +825,8 @@ static int qla4xxx_mem_alloc(struct scsi
>>>>  	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
>>>>  					 mempool_free_slab, srb_cachep);
>>>>  	if (ha->srb_mempool == NULL) {
>>>> -		ql4_printk(KERN_WARNING, ha,
>>>> -			   "Memory Allocation failed - SRB Pool.\n");
>>>> -
>>>> +		dev_warn(&ha->pdev->dev,
>>>> +			 "Memory Allocation failed - SRB Pool.\n");
>>>>  		goto mem_alloc_error_exit;
>>> Sorry for the late response on this one. As you know I was out for a
>>> while and I was waiting to get internet access yesterday.
>>>
>>> For these host messages, do we want something like the sdev_printk and
>>> starget_printk or does it really make more sense to use the pci bus id
>>> for the message prefix? What about other scsi host messages, will they
>>> always go with the pci bus id or some scsi-ml id? And even if we want to
>>> print out the pci bus id as the prefix instead of some scsi info, should
>>> we still have some scsi wrapper?
>>>
>>  
>> I do agree that iscsi_transport sessions could use a new macro.
>>
>> My intention in this instance was to go with the widely used idiom, and 
>> to not have a driver specific one.  Was trying to replace
>>  #define ql4_printk(level, ha, format, arg...)			\
>>      dev_printk(level, &((ha)->pdev->dev), format, ## arg)
>>
>> But to follow on from irc, one more pass at this to help me clarify and
>> understand what is need here.
>>
>> dev_xxx is a wrapper around dev_print(xxx ...).  
>>
>> In the specific instance above, this should print
>> scsiN arg...
> 
> I think the ones in qla4xxx_mem_alloc print
> 
> %pci_id: arg...
> 

Maybe I was wrong...

Given that some messages are printing the pci bus id (the ones like
above in qla4xxx_mem_alloc using ql4_printk), and other messages are
printing the host number (the ones using printk with "scsi%ld" coded in
them) maybe this means....

> removing the needless ql4_printk wrapper, I think just replacing
> ql4_printk usage with dev_printk is ok for now.
> 

that this comment is wrong and maybe we need to to more.

> starget_printk and I was wondering if we need a shost_printk that the
> LLD could use and that would complete the API.
> 

And maybe we need a shost_printk to go along with the sdev and starget
printks, so drivers do not end up printing different prefixes for the
same objects like is happening with qla4xxx.
