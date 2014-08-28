From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Date: Thu, 28 Aug 2014 14:49:08 +0200
Message-ID: <53FF2544.8020601@redhat.com>
References: <1408433122.4748.73.camel@Centos6.3-64>	 <53FDE490.1070201@redhat.com> <1409240809.4762.259.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409240809.4762.259.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/28/2014 05:46 PM, Ching Huang wrote:
> On Wed, 2014-08-27 at 16:00 +0200, Tomas Henzl wrote:
>> On 08/19/2014 09:25 AM, Ching Huang wrote:
>>> From: Ching Huang <ching2048@areca.com.tw>
>>>
>>> Add code for supporting Areca new Raid adapter ARC12x4 series.
>>>
>>> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
>>> ---
>> Hi Ching,
>> please look at the comments below -
>>
>>>  }
>>> @@ -1039,7 +1147,60 @@ static void arcmsr_done4abort_postqueue(
>>>  			error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
>>>  			arcmsr_drain_donequeue(acb, pCCB, error);
>>>  		}
>>> -	}
>>> +		}
>>> +		break;
>>> +	case ACB_ADAPTER_TYPE_D: {
>>> +		struct MessageUnit_D  *pmu = acb->pmuD;
>>> +		uint32_t ccb_cdb_phy, outbound_write_pointer;
>>> +		uint32_t doneq_index, index_stripped, addressLow, residual;
>>> +		bool error;
>>> +		struct CommandControlBlock *pCCB;
>> I have noticed this^ in this driver already before. Sometimes it makes sense
>> when a variable is declared in a 'case' block but often it is just
>> a waste of space. In this function this is the third 'bool error' declared.
>> Is there a reason for this style (this function is not the worst case) ?
> Yea, there is many variable are duplicate declaration, I will clean it up.
>>> +		outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
>>> +		doneq_index = pmu->doneq_index;
>>> +		residual = atomic_read(&acb->ccboutstandingcount);
>>> +		for (i = 0; i < residual; i++) {
>>> +			while ((doneq_index & 0xFFF) !=
>>> +				(outbound_write_pointer & 0xFFF)) {
>>> +				if (doneq_index & 0x4000) {
>>> +					index_stripped = doneq_index & 0xFFF;
>>> +					index_stripped += 1;
>>> +					index_stripped %=
>>> +						ARCMSR_MAX_ARC1214_DONEQUEUE;
>>> +					pmu->doneq_index = index_stripped ?
>>> +						(index_stripped | 0x4000) :
>>> +						(index_stripped + 1);
>>> +				} else {
>>> +					index_stripped = doneq_index;
>>> +					index_stripped += 1;
>>> +					index_stripped %=
>>> +						ARCMSR_MAX_ARC1214_DONEQUEUE;
>>> +					pmu->doneq_index = index_stripped ?
>>> +						index_stripped :
>>> +						((index_stripped | 0x4000) + 1);
>>> +				}
>>> +				doneq_index = pmu->doneq_index;
>>> +				addressLow = pmu->done_qbuffer[doneq_index &
>>> +					0xFFF].addressLow;
>>> +				ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
>>> +				pARCMSR_CDB = (struct  ARCMSR_CDB *)
>>> +					(acb->vir2phy_offset + ccb_cdb_phy);
>>> +				pCCB = container_of(pARCMSR_CDB,
>>> +					struct CommandControlBlock, arcmsr_cdb);
>>> +				error = (addressLow &
>>> +					ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ?
>>> +					true : false;
>>> +				arcmsr_drain_donequeue(acb, pCCB, error);
>>> +				writel(doneq_index, pmu->outboundlist_read_pointer);
>>> +			}
>>> +			mdelay(10);
>>> +			outbound_write_pointer =
>>> +				pmu->done_qbuffer[0].addressLow + 1;
>>> +			doneq_index = pmu->doneq_index;
>>> +		}
>>> +		pmu->postq_index = 0;
>>> +		pmu->doneq_index = 0x40FF;
>>> +		}
>>> +		break;
>>>  	}
>>>  }
>> ...
>>
>>>  
>>> @@ -1256,6 +1424,38 @@ static void arcmsr_post_ccb(struct Adapt
>>>  			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
>>>  		}
>>>  		}
>>> +		break;
>>> +	case ACB_ADAPTER_TYPE_D: {
>>> +		struct MessageUnit_D  *pmu = acb->pmuD;
>>> +		u16 index_stripped;
>>> +		u16 postq_index;
> 		u16 postq_index, toggle;
>>> +		unsigned long flags;
>>> +		struct InBound_SRB *pinbound_srb;
>>> +
>>> +		spin_lock_irqsave(&acb->postq_lock, flags);
>>> +		postq_index = pmu->postq_index;
>>> +		pinbound_srb = (struct InBound_SRB *)&(pmu->post_qbuffer[postq_index & 0xFF]);
>>> +		pinbound_srb->addressHigh = dma_addr_hi32(cdb_phyaddr);
>>> +		pinbound_srb->addressLow = dma_addr_lo32(cdb_phyaddr);
>>> +		pinbound_srb->length = ccb->arc_cdb_size >> 2;
>>> +		arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
>>> +		if (postq_index & 0x4000) {
>>> +			index_stripped = postq_index & 0xFF;
>>> +			index_stripped += 1;
>>> +			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
>>> +			pmu->postq_index = index_stripped ?
>>> +				(index_stripped | 0x4000) : index_stripped;
>>> +		} else {
>>> +			index_stripped = postq_index;
>>> +			index_stripped += 1;
>>> +			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
>>> +			pmu->postq_index = index_stripped ? index_stripped :
>>> +				(index_stripped | 0x4000);
>>> +		}
>> The code above could be a bit easier -
> Yea. I simplify it to following.
> 		toggle = postq_index & 0x4000;

I might be wrong but the following two lines:

> 		index_stripped = (postq_index & 0xFF) + 1;

the first '&' is not needed, because we use a modulo in a next step
>		 index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
and module is for certain binary numbers equivalent to '&', so this
could be changed into 
		index_stripped = postq_index + 1;
		index_stripped &= (ARCMSR_MAX_ARC1214_POSTQUEUE - 1);
( ARCMSR_MAX_ARC1214_POSTQUEUE is equal 0x100)

and this 
>		pmu->postq_index = index_stripped ? (index_stripped | toggle) :
>			(index_stripped | (toggle ^ 0x4000));
into 
		pmu->postq_index = index_stripped ? (index_stripped | toggle) :
			 (toggle ^ 0x4000);

Let us stop this discussion, it's not a bug, you may or may not include it in your next series,
we can discuss it there. 
For another question, please look below.

>> 		
>> 		arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
>>                 index_stripped = postq_index + 1;
>>                 index_stripped &= (ARCMSR_MAX_ARC1214_POSTQUEUE - 1);
>>
>>                 if (postq_index & 0x4000)
>>                         pmu->postq_index = index_stripped ?
>>                                 (index_stripped | 0x4000) : index_stripped;
>>                 else
>>                         pmu->postq_index = index_stripped ?
>>                                  index_stripped : (index_stripped | 0x4000);
>> or am I wrong? This is repeated in the code many times
> Yea. one for postQueue and 3 times for doneQueue. They all can be simplified as above.
>>  
>>
>>> +		writel(postq_index, pmu->inboundlist_write_pointer);
>>> +		spin_unlock_irqrestore(&acb->postq_lock, flags);
>>> +		break;
>>> +		}
>>>  	}
>>>  }
>>>  
>> ...
>>> +static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
>>> +				struct CommandControlBlock *poll_ccb)
>>> +{
>>> +	bool error;
>>> +	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
>>> +	int rtn, doneq_index, index_stripped, outbound_write_pointer;
>>> +	unsigned long flags;
>>> +	struct ARCMSR_CDB *arcmsr_cdb;
>>> +	struct CommandControlBlock *pCCB;
>>> +	struct MessageUnit_D *pmu = acb->pmuD;
>>> +
>>> +polling_hbaD_ccb_retry:
>>> +	poll_count++;
>>> +	while (1) {
>>> +		outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
>>> +		doneq_index = pmu->doneq_index;
>> You seem to protect the doneq with a spinlock on some other places, arcmsr_hbaD_postqueue_isr
>> and below in this function. Why not here, is it intentional? 
> Before came here, the h/w interrupt was disabled. Hence, don't worry about other thread
> to change doneq_index.

I guess you mean the hw interrupts from your card. If so and if you know that no other thread on another 
processor can access the doneq_index - why do you use the spinlock just few lines below?

>>> +		if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {
>>> +			if (poll_ccb_done) {
>>> +				rtn = SUCCESS;
>>> +				break;
>>> +			} else {
>>> +				msleep(25);
>>> +				if (poll_count > 40) {
>>> +					rtn = FAILED;
>>> +					break;
>>> +				}
>>> +				goto polling_hbaD_ccb_retry;
>>> +			}
>>> +		}
>>> +		spin_lock_irqsave(&acb->doneq_lock, flags);
>>> +		if (doneq_index & 0x4000) {
>>> +			index_stripped = doneq_index & 0xFFF;
>>> +			index_stripped += 1;
>>> +			index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
>>> +			pmu->doneq_index = index_stripped ?
>>> +				(index_stripped | 0x4000) :
>>> +				(index_stripped + 1);
>>> +		} else {
>>> +			index_stripped = doneq_index;
>>> +			index_stripped += 1;
>>> +			index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
>>> +			pmu->doneq_index = index_stripped ? index_stripped :
>>> +				((index_stripped | 0x4000) + 1);
>>> +		}
>>> +		spin_unlock_irqrestore(&acb->doneq_lock, flags);
>>> +		doneq_index = pmu->doneq_index;
>>> +		flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
>>> +		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
>>> +		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
>>> +			ccb_cdb_phy);
>>> +		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
>>> +			arcmsr_cdb);
>>> +		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
>>> +		if ((pCCB->acb != acb) ||
>>> +			(pCCB->startdone != ARCMSR_CCB_START)) {
>>> +			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
>>> +				pr_notice("arcmsr%d: scsi id = %d "
>>> +					"lun = %d ccb = '0x%p' poll command "
>>> +					"abort successfully\n"
>>> +					, acb->host->host_no
>>> +					, pCCB->pcmd->device->id
>>> +					, (u32)pCCB->pcmd->device->lun
>>> +					, pCCB);
>>> +				pCCB->pcmd->result = DID_ABORT << 16;
>>> +				arcmsr_ccb_complete(pCCB);
>>> +				continue;
>>> +			}
>>> +			pr_notice("arcmsr%d: polling an illegal "
>>> +				"ccb command done ccb = '0x%p' "
>>> +				"ccboutstandingcount = %d\n"
>>> +				, acb->host->host_no
>>> +				, pCCB
>>> +				, atomic_read(&acb->ccboutstandingcount));
>>> +			continue;
>>> +		}
>>> +		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
>>> +			? true : false;
>>> +		arcmsr_report_ccb_state(acb, pCCB, error);
>>> +	}
>>> +	return rtn;
>>> +}
>>> +
>>>  static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
>>>  					struct CommandControlBlock *poll_ccb)
>>>  {
>>> @@ -2711,6 +3280,10 @@ static int arcmsr_polling_ccbdone(struct
>>>  	case ACB_ADAPTER_TYPE_C: {
>>>  		rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
>>>  		}
>>> +		break;
>>> +	case ACB_ADAPTER_TYPE_D:
>>> +		rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
>>> +		break;
>>>  	}
>>>  	return rtn;
>>>  }
>>> @@ -2728,6 +3301,7 @@ static int arcmsr_iop_confirm(struct Ada
>>>  	*/
>>>  	switch (acb->adapter_type) {
>>>  		case ACB_ADAPTER_TYPE_B:
>>> +		case ACB_ADAPTER_TYPE_D:
>>>  			dma_coherent_handle = acb->dma_coherent_handle2;
>>>  			break;
>>>  		default:
>>> @@ -2817,6 +3391,27 @@ static int arcmsr_iop_confirm(struct Ada
>>>  			}
>>>  		}
>>>  		}
>>> +		break;
>>> +	case ACB_ADAPTER_TYPE_D: {
>>> +		uint32_t __iomem *rwbuffer;
>>> +		struct MessageUnit_D *reg = acb->pmuD;
>>> +		reg->postq_index = 0;
>>> +		reg->doneq_index = 0;
>>> +		rwbuffer = reg->msgcode_rwbuffer;
>>> +		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
>>> +		writel(cdb_phyaddr_hi32, rwbuffer++);
>>> +		writel(cdb_phyaddr, rwbuffer++);
>>> +		writel(cdb_phyaddr + (ARCMSR_MAX_ARC1214_POSTQUEUE *
>>> +			sizeof(struct InBound_SRB)), rwbuffer++);
>>> +		writel(0x100, rwbuffer);
>>> +		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, reg->inbound_msgaddr0);
>>> +		if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
>>> +			pr_notice("arcmsr%d: 'set command Q window' timeout\n",
>>> +				acb->host->host_no);
>>> +			return 1;
>>> +		}
>>> +		}
>>> +		break;
>>>  	}
>>>  	return 0;
>>>  }
>>> @@ -2848,6 +3443,15 @@ static void arcmsr_wait_firmware_ready(s
>>>  			firmware_state = readl(&reg->outbound_msgaddr1);
>>>  		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
>>>  		}
>>> +		break;
>>> +	case ACB_ADAPTER_TYPE_D: {
>>> +		struct MessageUnit_D *reg = acb->pmuD;
>>> +		do {
>>> +			firmware_state = readl(reg->outbound_msgaddr1);
>>> +		} while ((firmware_state &
>>> +			ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
>>> +		}
>>> +		break;
>>>  	}
>>>  }
>>>  
>>> @@ -2918,6 +3522,35 @@ static void arcmsr_hbaC_request_device_m
>>>  	return;
>>>  }
>>>  
>>> +static void arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)
>>> +{
>>> +	struct MessageUnit_D *reg = acb->pmuD;
>>> +
>>> +	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
>>> +		((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
>>> +		((acb->acb_flags & ACB_F_ABORT) != 0)) {
>>> +		mod_timer(&acb->eternal_timer,
>>> +			jiffies + msecs_to_jiffies(6 * HZ));
>>> +	} else {
>>> +		acb->fw_flag = FW_NORMAL;
>>> +		if (atomic_read(&acb->ante_token_value) ==
>>> +			atomic_read(&acb->rq_map_token)) {
>>> +			atomic_set(&acb->rq_map_token, 16);
>>> +		}
>>> +		atomic_set(&acb->ante_token_value,
>>> +			atomic_read(&acb->rq_map_token));
>>> +		if (atomic_dec_and_test(&acb->rq_map_token)) {
>>> +			mod_timer(&acb->eternal_timer, jiffies +
>>> +				msecs_to_jiffies(6 * HZ));
>>> +			return;
>>> +		}
>>> +		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
>>> +			reg->inbound_msgaddr0);
>>> +		mod_timer(&acb->eternal_timer, jiffies +
>>> +			msecs_to_jiffies(6 * HZ));
>>> +	}
>>> +}
>>> +
>>>  static void arcmsr_request_device_map(unsigned long pacb)
>>>  {
>>>  	struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;
>>> @@ -2933,6 +3566,10 @@ static void arcmsr_request_device_map(un
>>>  		case ACB_ADAPTER_TYPE_C: {
>>>  			arcmsr_hbaC_request_device_map(acb);
>>>  		}
>>> +		break;
>>> +		case ACB_ADAPTER_TYPE_D:
>>> +			arcmsr_hbaD_request_device_map(acb);
>>> +		break;
>>>  	}
>>>  }
>>>  
>>> @@ -2970,6 +3607,19 @@ static void arcmsr_hbaC_start_bgrb(struc
>>>  	}
>>>  	return;
>>>  }
>>> +
>>> +static void arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)
>>> +{
>>> +	struct MessageUnit_D *pmu = pACB->pmuD;
>>> +
>>> +	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
>>> +	writel(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);
>>> +	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
>>> +		pr_notice("arcmsr%d: wait 'start adapter "
>>> +			"background rebulid' timeout\n", pACB->host->host_no);
>>> +	}
>>> +}
>>> +
>>>  static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
>>>  {
>>>  	switch (acb->adapter_type) {
>>> @@ -2981,6 +3631,10 @@ static void arcmsr_start_adapter_bgrb(st
>>>  		break;
>>>  	case ACB_ADAPTER_TYPE_C:
>>>  		arcmsr_hbaC_start_bgrb(acb);
>>> +		break;
>>> +	case ACB_ADAPTER_TYPE_D:
>>> +		arcmsr_hbaD_start_bgrb(acb);
>>> +		break;
>>>  	}
>>>  }
>>>  
>>> @@ -3026,6 +3680,29 @@ static void arcmsr_clear_doorbell_queue_
>>>  				break;
>>>  		}
>>>  		}
>>> +		break;
>>> +	case ACB_ADAPTER_TYPE_D: {
>>> +		struct MessageUnit_D *reg = acb->pmuD;
>>> +		uint32_t outbound_doorbell, i;
>>> +		/* empty doorbell Qbuffer if door bell ringed */
>>> +		outbound_doorbell = readl(reg->outbound_doorbell);
>>> +		writel(outbound_doorbell, reg->outbound_doorbell);
>>> +		writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
>>> +			reg->inbound_doorbell);
>>> +		for (i = 0; i < 200; i++) {
>>> +			msleep(20);
>>> +			outbound_doorbell = readl(reg->outbound_doorbell);
>>> +			if (outbound_doorbell &
>>> +				ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {
>>> +				writel(outbound_doorbell,
>>> +					reg->outbound_doorbell);
>>> +				writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
>>> +					reg->inbound_doorbell);
>>> +			} else
>>> +				break;
>>> +		}
>>> +		}
>>> +		break;
>>>  	}
>>>  }
>>>  
>>> @@ -3056,6 +3733,7 @@ static void arcmsr_hardware_reset(struct
>>>  	int i, count = 0;
>>>  	struct MessageUnit_A __iomem *pmuA = acb->pmuA;
>>>  	struct MessageUnit_C __iomem *pmuC = acb->pmuC;
>>> +	struct MessageUnit_D *pmuD = acb->pmuD;
>>>  
>>>  	/* backup pci config data */
>>>  	printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n", acb->host->host_no);
>>> @@ -3076,6 +3754,8 @@ static void arcmsr_hardware_reset(struct
>>>  			writel(0xD, &pmuC->write_sequence);
>>>  		} while (((readl(&pmuC->host_diagnostic) & ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
>>>  		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
>>> +	} else if ((acb->dev_id == 0x1214)) {
>>> +		writel(0x20, pmuD->reset_request);
>>>  	} else {
>>>  		pci_write_config_byte(acb->pdev, 0x84, 0x20);
>>>  	}
>>> @@ -3272,6 +3952,66 @@ sleep:
>>>  			}
>>>  			break;
>>>  		}
>>> +		case ACB_ADAPTER_TYPE_D: {
>>> +			if (acb->acb_flags & ACB_F_BUS_RESET) {
>>> +				long timeout;
>>> +				pr_notice("arcmsr: there is an bus reset"
>>> +					" eh proceeding.......\n");
>>> +				timeout = wait_event_timeout(wait_q, (acb->acb_flags
>>> +					& ACB_F_BUS_RESET) == 0, 220 * HZ);
>>> +				if (timeout)
>>> +					return SUCCESS;
>>> +			}
>>> +			acb->acb_flags |= ACB_F_BUS_RESET;
>>> +			if (!arcmsr_iop_reset(acb)) {
>>> +				struct MessageUnit_D *reg;
>>> +				reg = acb->pmuD;
>>> +				arcmsr_hardware_reset(acb);
>>> +				acb->acb_flags &= ~ACB_F_IOP_INITED;
>>> +			nap:
>>> +				ssleep(ARCMSR_SLEEPTIME);
>>> +				if ((readl(reg->sample_at_reset) & 0x80) != 0) {
>>> +					pr_err("arcmsr%d: waiting for "
>>> +						"hw bus reset return, retry=%d\n",
>>> +						acb->host->host_no, retry_count);
>>> +					if (retry_count > ARCMSR_RETRYCOUNT) {
>>> +						acb->fw_flag = FW_DEADLOCK;
>>> +						pr_err("arcmsr%d: waiting for hw bus"
>>> +							" reset return, "
>>> +							"RETRY TERMINATED!!\n",
>>> +							acb->host->host_no);
>>> +						return FAILED;
>>> +					}
>>> +					retry_count++;
>>> +					goto nap;
>>> +				}
>>> +				acb->acb_flags |= ACB_F_IOP_INITED;
>>> +				/* disable all outbound interrupt */
>>> +				intmask_org = arcmsr_disable_outbound_ints(acb);
>>> +				arcmsr_get_firmware_spec(acb);
>>> +				arcmsr_start_adapter_bgrb(acb);
>>> +				arcmsr_clear_doorbell_queue_buffer(acb);
>>> +				arcmsr_enable_outbound_ints(acb, intmask_org);
>>> +				atomic_set(&acb->rq_map_token, 16);
>>> +				atomic_set(&acb->ante_token_value, 16);
>>> +				acb->fw_flag = FW_NORMAL;
>>> +				mod_timer(&acb->eternal_timer,
>>> +					jiffies + msecs_to_jiffies(6 * HZ));
>>> +				acb->acb_flags &= ~ACB_F_BUS_RESET;
>>> +				rtn = SUCCESS;
>>> +				pr_err("arcmsr: scsi bus reset "
>>> +					"eh returns with success\n");
>>> +			} else {
>>> +				acb->acb_flags &= ~ACB_F_BUS_RESET;
>>> +				atomic_set(&acb->rq_map_token, 16);
>>> +				atomic_set(&acb->ante_token_value, 16);
>>> +				acb->fw_flag = FW_NORMAL;
>>> +				mod_timer(&acb->eternal_timer,
>>> +					jiffies + msecs_to_jiffies(6 * HZ));
>>> +				rtn = SUCCESS;
>>> +			}
>>> +			break;
>>> +		}
>>>  	}
>>>  	return rtn;
>>>  }
>>> @@ -3348,6 +4088,7 @@ static const char *arcmsr_info(struct Sc
>>>  	case PCI_DEVICE_ID_ARECA_1280:
>>>  		type = "SATA";
>>>  		break;
>>> +	case PCI_DEVICE_ID_ARECA_1214:
>>>  	case PCI_DEVICE_ID_ARECA_1380:
>>>  	case PCI_DEVICE_ID_ARECA_1381:
>>>  	case PCI_DEVICE_ID_ARECA_1680:
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
