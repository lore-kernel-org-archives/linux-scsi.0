From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 8/8] scsi: hisi_sas: Code cleanup and minor bug fixes
Date: Tue, 6 Mar 2018 12:26:51 +0000
Message-ID: <127bf8a8-f10d-86b7-3d9a-6e969dd9d309@huawei.com>
References: <1520261330-204596-1-git-send-email-john.garry@huawei.com>
 <1520261330-204596-9-git-send-email-john.garry@huawei.com>
 <301d4ff0-e1ac-fc40-9af2-2b6bf54b41b9@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <301d4ff0-e1ac-fc40-9af2-2b6bf54b41b9@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

Thanks for checking this.

>> > +	}
>> >
> return -EINVAL?
>
>> >  	return 0;
>> >  }

[ ... ]

>> > +	}
>> >
>> >  	return 0;
>> >  }
> return -EINVAL?
>
>> > @@ -2408,7 +2410,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
>> >  		spin_lock_irqsave(&hisi_hba->lock, flags);
>> >  		hisi_sas_slot_task_free(hisi_hba, task, slot);
>> >  		spin_unlock_irqrestore(&hisi_hba->lock, flags);

[ ... ]

>> >  		}
>> > -	} else
>> > +	} else {
>> >  		dev_err(dev, "no reset method!\n");
>> > +		return -EIO;
>> > +	}
>> >
>> >  	return 0;
>> >  }
> return -EINVAL?
>

These 3 changes you suggest are accepted.

>> > @@ -731,7 +733,7 @@ static void phy_hard_reset_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
>> >  	start_phy_v3_hw(hisi_hba, phy_no);
>> >  }
>> >
>> > -enum sas_linkrate phy_get_max_linkrate_v3_hw(void)
>> > +static enum sas_linkrate phy_get_max_linkrate_v3_hw(void)
>> >  {
>> >  	return SAS_LINK_RATE_12_0_GBPS;
>> >  }
>> > @@ -1096,7 +1098,7 @@ static int prep_abort_v3_hw(struct hisi_hba *hisi_hba,
>> >  	/* dw0 */
>> >  	hdr->dw0 = cpu_to_le32((5 << CMD_HDR_CMD_OFF) | /*abort*/
>> >  			       (port->id << CMD_HDR_PORT_OFF) |
>> > -				   ((dev_is_sata(dev) ? 1:0)
>> > +				   (dev_is_sata(dev)
>> >  					<< CMD_HDR_ABORT_DEVICE_TYPE_OFF) |
>> >  					(abort_flag
>> >  					 << CMD_HDR_ABORT_FLAG_OFF));
>> > @@ -1114,7 +1116,7 @@ static int prep_abort_v3_hw(struct hisi_hba *hisi_hba,
>> >
>> >  static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
>> >  {
>> > -	int i, res = 0;
>> > +	int i, res;
>> >  	u32 context, port_id, link_rate;
>> >  	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
>> >  	struct asd_sas_phy *sas_phy = &phy->sas_phy;
>> > @@ -1186,7 +1188,7 @@ static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
>> >  	phy->port_id = port_id;
>> >  	phy->phy_attached = 1;
>> >  	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
>> > -
>> > +	res = IRQ_HANDLED;
>> >  end:
>> >  	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
>> >  			     CHL_INT0_SL_PHY_ENABLE_MSK);
>> > @@ -1217,7 +1219,7 @@ static int phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
>> >  	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, CHL_INT0_NOT_RDY_MSK);
>> >  	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 0);
>> >
>> > -	return 0;
>> > +	return IRQ_HANDLED;
>> >  }
>> >
>> >  static void phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
> If we're returning IRQ_HANDLED, shouldn't the function have the return
> type irqreturn_t ?
> But as this isn't an interrupt handler, shouldn't we rather fixup the
> caller to check for the correct return values?

Since function phy_bcast_v3_hw() does no checking and would always 
return IRQ_HANDLED, we saw not point in having a return code and 
checking it. However, I did notice that we don't set res = IRQ_HANDLED 
after calling this function:
                 if (irq_value & CHL_INT0_SL_RX_BCST_ACK_MSK)
                     /* phy bcast */
                     phy_bcast_v3_hw(phy_no, hisi_hba);
             } else {
                 if (irq_value & CHL_INT0_NOT_RDY_MSK)
                     /* phy down */
                     if (phy_down_v3_hw(phy_no, hisi_hba)
                             == IRQ_HANDLED)
                         res = IRQ_HANDLED;
             }
         }
         irq_msk >>= 4;
         phy_no++;
     }

     return res;
}

So this needs to be remedied.

>
>> > @@ -1573,7 +1575,7 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
>> >  		spin_lock_irqsave(&hisi_hba->lock, flags);
>> >  		hisi_sas_slot_task_free(hisi_hba, task, slot);
>> >  		spin_unlock_irqrestore(&hisi_hba->lock, flags);
>> > -		return -1;
>> > +		return ts->stat;
>> >  	}
>> >
>> >  	if (unlikely(!sas_dev)) {
>> >

Thanks,
John

> Cheers,
>
> Hannes
> -- Dr. Hannes Reinecke Teamlead Storage & Networking hare@suse.de	+49
> 911 74053 688 SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg GF: F.
> Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB 21284 (AG
> Nürnberg) .
