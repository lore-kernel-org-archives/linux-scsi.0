From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 10 May 2007 18:48:50 +0300
Message-ID: <46433EE2.8020406@panasas.com>
References: <1178722514.3695.23.camel@mulgrave.il.steeleye.com>	<4641FCC8.4040600@panasas.com>	<20070510155322R.fujita.tomonori@lab.ntt.co.jp> <20070510164535F.fujita.tomonori@lab.ntt.co.jp> <4643121C.600@panasas.com> <464335D2.3020900@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:41643 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754709AbXEJPuN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 11:50:13 -0400
In-Reply-To: <464335D2.3020900@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

Douglas Gilbert wrote:
> Boaz Harrosh wrote:
>> FUJITA Tomonori wrote:
>>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> Subject: Re: [PATCH v2] add bidi support for block pc requests
>>> Date: Thu, 10 May 2007 15:53:22 +0900
>>>
>>>> From: Boaz Harrosh <bharrosh@panasas.com>
>>>> Subject: Re: [PATCH v2] add bidi support for block pc requests
>>>> Date: Wed, 09 May 2007 19:54:32 +0300
>>>>
>>>>> James Bottomley wrote:
>>>>>> Actually, the first order of business is to use accessors on the command
>>>>>> pointers in the drivers to free them from the internal layout of the
>>>>>> structure (and where it is allocated).
>>>>>>
>>>>> Thanks! I totally second that. Let me look into my old patches and come
>>>>> up with all the needed accessors. I hope 3-5 will be enough.
>>>>> I will send some suggestions tomorrow.
>>>>>> No, that's why you do the accessors.  Convert all of the common drivers
>>>>>> to accessors on the current structure, then throw the switch to convert
>>>>>> to the new structure (whatever form is finally settled on).  Then any
>>>>>> unconverted drivers break and people fix the ones they care about.
>>>>> Last time I was able to compile 97% of drivers and convert by search-and-replace
>>>>> the rest. Not a huge deal.
>>>> We need to remove the non-use-sg code in the drivers and convert
>>>> them. So it's a bit more complicated than search-and-replace.
>>> Here's a patch to convert ibmvscsi to use helper functions (though it
>>> needs more testings).
>>>
>>> ---
>>> ---
>>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>>> index d6948d0..799f204 100644
>>> --- a/include/scsi/scsi_cmnd.h
>>> +++ b/include/scsi/scsi_cmnd.h
>>> @@ -138,4 +138,17 @@ extern void scsi_kunmap_atomic_sg(void *
>>>  extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
>>>  extern void scsi_free_sgtable(struct scatterlist *, int);
>>>  
>>> +extern int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd);
>>> +extern void scsi_dma_unmap(struct device *dev, struct scsi_cmnd *cmd);
>>> +
>>> +/* moved to scatterlist.h after chaining sg */
>>> +#define sg_next(sg) ((sg) + 1)
>>> +
>>> +#define scsi_for_each_sg(cmd, nseg, i)					\
>>> +	for (i = 0, sg = (cmd)->request_buffer; i < nseg;		\
>>> +		sg = sg_next(sg), i++)					\
>>> +
>> Better we do like Jens's patch
>> +#define for_each_sg(sglist, sg, nr, __i)	\
>> +	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
>>
>> I think that we should wait for Jens pending patchset and do this work on top
>> of his, then use his sg macros directly. This way the cleaners can also be
>> watchfully for any drivers that might brake with big IO sent to them.
>>
>>> +#define scsi_sg_count(cmd) ((cmd)->use_sg)
>>> +#define scsi_bufferlen(cmd) ((cmd)->request_bufflen)
>>> +
>>>  #endif /* _SCSI_SCSI_CMND_H */
>> Above helpers look good. However I am missing 2 of them:
>>
>> 1.
>> +#define scsi_sgl(cmd) ((struct scatterlist*)(cmd)->request_buffer)
>>
>> This is for drivers like iSCSI that do not do any dma mapping, as dma
>> is done at the lower level in the NICs. And lots of other places that just
>> transfer the sglist around.
>>
>> 2.
>> +#define scsi_resid(cmd) ((cmd)->resid)
> 
> I have defined resid in the past as a signed (32 bit)
> integer following the CAM spec. The cases are:
>    - resid=0 : initiator's DMA engine got (or sent?) the
>                number of bytes it expected
>    - resid>0 : dxfer_len-resid bytes received, less than
>                expected
>    - resid<0 : more bytes received (or could have been)
>                than indicated by dxfer_len
> 
> Some definitions of resid make it unsigned which rules out
> the less common resid<0 case. Can this case happen? Does it
> happen in practice? Naturally no more than dxfer_len should
> be placed in the scatter gather list.
> 
> SPI and SAS do not convey dxfer_len (or data direction) to
> a target in their transport frames. This means that the
> relevant field in the cdb (e.g. transfer length) dictates
> how much data a target sends back to an initiator in the
> case of a read like operation. So that opens up the
> possibility that dxfer_len and the cdb disagree.
> 
> FCP does convey dxfer_len and data_direction to a target.
> So a FCP target can detect a mismatch between this and the
> cdb and send resid information (either under or over) in its
> response frame back to the initiator. Alternatively it
> can treat the "over" case as an error (fcp3r04.pdf section
> 9.4.2).
> iSCSI and SRP?
> 
> The resid<0 case may become more common if a driver or
> application does not properly take account of protection
> information being sent together with the requested
> data.
> 
> So should we keep resid signed?
> 
> Doug Gilbert
You are probably right just that I was afraid of this: req->data_len = sc->resid
and I saw in iSCSI :

iscsi_scsi_cmd_rsp()
...

		if (res_count > 0 && res_count <= sc->request_bufflen)
			sc->resid = res_count;
		else
			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;

So I'm confused. It looks like the struct scsi_cmnd member resid is only the
one case of 0 <= target_resid <= request_bufflen, and the other cases are covered by
an error result?

Boaz

