From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 2/2] qla2xxx: FC pass through support - revised II
Date: Thu, 30 Oct 2008 08:45:42 -0700
Message-ID: <8DC9BCAF-A524-43D1-91D0-13386C8A9178@qlogic.com>
References: <100CCA84-68CA-4A61-9C7E-CE00C4B1F517@qlogic.com> <20081030131828V.fujita.tomonori@lab.ntt.co.jp> <E416A8D5-84CF-4618-B2C4-176AFDE23E39@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:56055 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbYJ3Ppp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 11:45:45 -0400
In-Reply-To: <E416A8D5-84CF-4618-B2C4-176AFDE23E39@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert W Love <robert.w.love@intel.com>


On Oct 30, 2008, at 8:19 AM, Seokmann Ju wrote:

>
> On Oct 29, 2008, at 9:18 PM, FUJITA Tomonori wrote:
>
>> On Wed, 29 Oct 2008 05:48:08 -0700
>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>
> [snip]
>>> +	service->payload_sg_cnt = dma_map_sg(&rport->dev,
>>> +	    service->payload_dma, service->payload_sg_cnt, DMA_TO_DEVICE);
>>> +	service->response_sg_cnt = dma_map_sg(&rport->dev,
>>> +	    service->response_dma, service->response_sg_cnt,  
>>> DMA_FROM_DEVICE);
>>
>> Please check the return values, service->payload_sg_cnt and
>> service->response_sg_cnt. dma_map_sg could fail.
> OK. Thanks.
>
>>> +	if (service->srv_request->request_type == FC_FRAME_TYPE_ELS) {
>>> +		els_iocb = (struct els_entry_24xx *)iocb;
>>> +		els_iocb->entry_type = ELS_IOCB_TYPE;
>>> +		els_iocb->entry_count = 1;
>>> +		els_iocb->sys_define = 0;
>>> +		els_iocb->entry_status = 0;
>>> +		els_iocb->nport_handle = cpu_to_le16(fcport->loop_id);
>>> +		els_iocb->tx_dsd_count = __constant_cpu_to_le16(1);
>>> +		els_iocb->vp_index = vha->vp_idx;
>>> +		els_iocb->sof_type = EST_SOFI3;
>>> +		els_iocb->rx_dsd_count = __constant_cpu_to_le16(1);
>>> +		els_iocb->opcode = els_pkt[0];
>>> +		els_iocb->port_id[0] = fcport->d_id.b.al_pa;
>>> +		els_iocb->port_id[1] = fcport->d_id.b.area;
>>> +		els_iocb->port_id[2] = fcport->d_id.b.domain;
>>> +		els_iocb->control_flags = 0;
>>> +		els_iocb->rx_byte_count = cpu_to_le32(service->response_size);
>>> +		els_iocb->tx_byte_count = cpu_to_le32(service->payload_size);
>>> +		els_iocb->tx_address[0] = cpu_to_le32(LSD(sg_dma_address
>>> +		    (&service->payload_dma[0])));
>>> +		els_iocb->tx_address[1] = cpu_to_le32(MSD(sg_dma_address
>>> +		    (&service->payload_dma[0])));
>>> +
>>> +		els_iocb->tx_len = cpu_to_le32(sg_dma_len
>>> +		    (&service->payload_dma[0]));
>>> +
>>> +		els_iocb->rx_address[0] = cpu_to_le32(LSD(sg_dma_address
>>> +		    (&service->response_dma[0])));
>>> +		els_iocb->rx_address[1] = cpu_to_le32(MSD(sg_dma_address
>>> +		    (&service->response_dma[0])));
>>> +
>>> +		els_iocb->rx_len = cpu_to_le32(sg_dma_len
>>> +		    (&service->response_dma[0]));
>>> +	
>>> +		/* lld_pkt is only for ELS services in case of abort */
>>> +		service->lld_pkt = (void *) els_iocb;
>>> +	} else {
>>> +		ct_iocb = (struct ct_entry_24xx *)iocb;
>>> +		ct_iocb->entry_type = CT_IOCB_TYPE;
>>> +		ct_iocb->entry_count = 1;
>>> +		ct_iocb->entry_status = 0;
>>> +		ct_iocb->comp_status = __constant_cpu_to_le16(0);
>>> +		if (IS_FWI2_CAPABLE(ha))
>>> +			ct_iocb->nport_handle = cpu_to_le16(NPH_SNS);
>>> +		else
>>> +			ct_iocb->nport_handle =
>>> +			    cpu_to_le16(SIMPLE_NAME_SERVER);
>>> +		ct_iocb->cmd_dsd_count =
>>> +		    __constant_cpu_to_le16(service->payload_sg_cnt);
>>> +		ct_iocb->vp_index = vha->vp_idx;
>>> +		ct_iocb->timeout =
>>> +		    __constant_cpu_to_le16(service->timeout);
>>> +		ct_iocb->rsp_dsd_count =
>>> +		    __constant_cpu_to_le16(service->response_sg_cnt);
>>> +		ct_iocb->rsp_byte_count =
>>> +		    cpu_to_le32(service->response_size);
>>> +		ct_iocb->cmd_byte_count =
>>> +		    cpu_to_le32(service->payload_size);
>>> +		ct_iocb->dseg_0_address[0] = cpu_to_le32(LSD(sg_dma_address
>>> +		    (&service->payload_dma[0])));
>>> +		ct_iocb->dseg_0_address[1] = cpu_to_le32(MSD(sg_dma_address
>>> +		    (&service->payload_dma[0])));
>>> +
>>> +		ct_iocb->dseg_0_len = cpu_to_le32(sg_dma_len
>>> +		    (&service->payload_dma[0]));
>>> +
>>> +		sg_cnt = service->response_sg_cnt;
>>> +		avail_dsds = 1;
>>> +		cur_dsd = (uint32_t *)ct_iocb->dseg_1_address;
>>> +		index = 0;
>>> +		while (sg_cnt) {
>>> +			cont_a64_entry_t *cont_pkt;
>>> +
>>> +			/* Allocate additional continuation packets? */
>>> +			if (avail_dsds == 0) {
>>> +				/*
>>> +				 * Five DSDs are available in the Continuation
>>> +				 * Type 1 IOCB.
>>> +				 */
>>> +				cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
>>> +				cur_dsd =
>>> +				    (uint32_t *) cont_pkt->dseg_0_address;
>>> +				avail_dsds = 5;
>>> +			}
>>> +
>>> +			*cur_dsd++ = cpu_to_le32(LSD(sg_dma_address
>>> +			    (&service->response_dma[index])));
>>> +			*cur_dsd++ = cpu_to_le32(MSD(sg_dma_address
>>> +			    (&service->response_dma[index])));
>>> +			*cur_dsd++ = cpu_to_le32(sg_dma_len
>>> +			    (&service->response_dma[index]));
>>> +			avail_dsds--;
>>> +			sg_cnt--;
>>> +			index++;
>>
>> Can you use the standard API, for_each_sg(), to go through scatter
>> list? With sg chaining, you must use the API.
> I see your point but, for_each_sg() is not applicable here as the  
> pointer to
> the cont_pkt is not guaranteed to be continuous from previous one.
Actually, it is doable as you pointed out initially.
There is an example in the
~/drivers/scsi/qla2xxx/qla_iocb.c:qla2x00_build_scsi_iocb_32/64().
As long as the address is valid and get changed accordingly.
I will make the changes accordingly.

Thank you,
Seokmann

