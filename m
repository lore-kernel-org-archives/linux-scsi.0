From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH -next] advansys: remove set but not used variable
 'srb_tag' in adv_isr_callback
Date: Wed, 17 Oct 2018 15:04:54 +0200
Message-ID: <73b10652-5ccf-4760-4aba-9f58600b6da6@suse.de>
References: <20181017123432.18304-1-yuehaibing@huawei.com>
 <4950b4fe-61b5-e1c3-9d16-7643107857a5@suse.de>
 <20181017130022.GA3575@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017130022.GA3575@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: YueHaibing <yuehaibing@huawei.com>, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 17/10/18 15:00, Matthew Wilcox wrote:
> On Wed, Oct 17, 2018 at 02:49:50PM +0200, Johannes Thumshirn wrote:
>> On 17/10/18 14:34, YueHaibing wrote:
>>> -	srb_tag = le32_to_cpu(scsiqp->srb_tag);
>>>  	scp = scsi_host_find_tag(boardp->shost, scsiqp->srb_tag);
>>
>> Shouldn't this be:
>> 	scp = scsi_host_find_tag(boardp->shost,
>> 					le32_to_cpu(scsiqp->srb_tag));
> 
> I don't think so.  Look at how scsiqp->srb_tag is set:
> 
>  adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>               ADV_SCSI_REQ_Q **adv_scsiqpp)
>  {
> +       u32 srb_tag = scp->request->tag;
> ...
> +       scsiqp->srb_tag = srb_tag;
> 
> If we're not converting it to le32 on the way in, we probably don't want
> to convert it back on the way out.

Yeah right, didn't check the submission path. It was just the removed
srb_tag = le32_to_cpu(scsiqp->srb_tag);
that triggered here.

> Please don't make me power up my PA-RISC machine with an Advansys card
> in it, just to find out ...

Now that your saying it...

-- 
Johannes Thumshirn                                        SUSE Labs
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
