From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Fri, 11 Jun 2010 01:44:26 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA871286CE1A0@AVEXMB1.qlogic.org>
References: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
 <4BFF6124.8000101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:17867 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310Ab0FKIo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2010 04:44:29 -0400
In-Reply-To: <4BFF6124.8000101@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Mike,

Please find my response inline. Current set of patches
which I submitted addresses your comments.

Thanks for your review.

Thanks,
Vikas.

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Thursday, May 27, 2010 11:22 PM
>To: Vikas Chaudhary
>Cc: James Bottomley; Linux-SCSI Mailing List; Karen Higgins; Ravi Anand
>Subject: Re: [PATCH 09/11] qla4xxx: Added support for ISP82XX
>
>On 04/28/2010 01:14 AM, Vikas Chaudhary wrote:
>>      struct Scsi_Host *host; /* pointer to host data */
>>      uint32_t tot_ddbs;
>> @@ -375,7 +455,7 @@ struct scsi_qla_host {
>>      uint8_t alias[32];
>>      uint8_t name_string[256];
>>      uint8_t heartbeat_interval;
>> -    uint8_t rsvd;
>> +    uint8_t rsvd2;
>>
>
>rsvd2 is not used so remove it.

Removed all unused reserved field.

>
>I must have been asleep when rsvd went in (is that from a distro driver).
>
>
>>      /* --- From FlashSysInfo --- */
>>      uint8_t my_mac[MAC_ADDR_LEN];
>> @@ -458,7 +538,7 @@ struct scsi_qla_host {
>>      uint8_t ipv4_addr_state;
>>      uint16_t ipv4_options;
>>
>> -    uint32_t resvd2;
>> +    uint32_t rsvd3;
>
>
>Also not used.
>
>
>>      uint32_t ipv6_options;
>>      uint32_t ipv6_addl_options;
>>      uint8_t ipv6_link_local_state;
>> @@ -469,6 +549,44 @@ struct scsi_qla_host {
>>      struct in6_addr ipv6_addr0;
>>      struct in6_addr ipv6_addr1;
>>      struct in6_addr ipv6_default_router_addr;
>> +    uint16_t ifcb_size;
>> +
>> +    /* qla82xx specific fields */
>> +    struct device_reg_82xx  __iomem *qla82xx_reg; /* Base I/O address */
>> +    unsigned long nx_pcibase;       /* Base I/O address */
>> +    uint8_t *nx_db_rd_ptr;         /* Doorbell read pointer */
>> +    unsigned long nx_db_wr_ptr;     /* Door bell write pointer */
>> +    unsigned long first_page_group_start;
>> +    unsigned long first_page_group_end;
>> +
>> +    uint32_t crb_win;
>> +    uint32_t curr_window;
>> +    uint32_t ddr_mn_window;
>> +    unsigned long mn_win_crb;
>> +    unsigned long ms_win_crb;
>> +    int qdr_sn_window;
>> +    rwlock_t hw_lock;
>> +    uint16_t func_num;
>> +    int link_width;
>> +
>> +    void *rsvd4;
>
>Also not used.
>
>
>> +    struct qla82xx_legacy_intr_set nx_legacy_intr;
>> +    u32 nx_crb_mask;
>> +
>> +    uint8_t revision_id;
>> +    uint8_t rsvd5[3];
>
>
>Not used.
>
>
>> +void qla4xxx_free_ddb(struct scsi_qla_host *ha,
>> +    struct ddb_entry *ddb_entry)
>>   {
>>      /* Remove device entry from list */
>>      list_del_init(&ddb_entry->list);
>> @@ -85,6 +89,25 @@ void qla4xxx_free_ddb_list(struct scsi_qla_host *ha)
>>      }
>>   }
>>
>> +/*
>
>
>For docbook I think you want an extra *

Done.

>
>/**
>
>
>>   }
>>
>> @@ -399,6 +430,7 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
>>              DEBUG2(printk("scsi%ld: %s: FW initialized, but "
>>                            "auto-discovery still in process\n",
>>                             ha->host_no, __func__));
>> +            ready = 1;
>
>
>Does this have anything to do with the new hardware. Did the behavior
>change or are you just sneaking in a bug fix.
>

It is bug fix. Separated out this bug fix and submitted
A separate patch for this one.

>
>
>>      }
>>
>>      return ready;
>> @@ -453,7 +485,7 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct
>scsi_qla_host *ha,
>>              DEBUG2(printk("scsi%ld: %s: failed get_ddb_entry for "
>>                            "fw_ddb_index %d\n", ha->host_no, __func__,
>>                            fw_ddb_index));
>> -            return NULL;
>> +            goto exit_get_ddb_entry;
>
>
>
>>      }
>>
>>      /* Allocate DDB if not already allocated. */
>> @@ -479,6 +511,7 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct
>scsi_qla_host *ha,
>>              ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
>>      }
>>
>> +exit_get_ddb_entry:
>>      /* if not found allocate new ddb */
>>      dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
>fw_ddb_entry,
>>                        fw_ddb_entry_dma);
>> @@ -510,7 +543,7 @@ static int qla4xxx_update_ddb_entry(struct
>scsi_qla_host *ha,
>>      if (ddb_entry == NULL) {
>>              DEBUG2(printk("scsi%ld: %s: ddb_entry is NULL\n", ha->host_no,
>>                            __func__));
>> -            goto exit_update_ddb;
>> +            return status;
>>      }
>>
>>      /* Make sure the dma buffer is valid */
>> @@ -520,8 +553,7 @@ static int qla4xxx_update_ddb_entry(struct
>scsi_qla_host *ha,
>>      if (fw_ddb_entry == NULL) {
>>              DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
>>                            ha->host_no, __func__));
>> -
>> -            goto exit_update_ddb;
>> +            return status;
>>      }
>>
>>      if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
>> @@ -547,6 +579,9 @@ static int qla4xxx_update_ddb_entry(struct
>scsi_qla_host *ha,
>>      ddb_entry->default_relogin_timeout =
>>              le16_to_cpu(fw_ddb_entry->def_timeout);
>>      ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry-
>>iscsi_def_time2wait);
>> +    ddb_entry->ka_timeout = le16_to_cpu(fw_ddb_entry->ka_timeout);
>> +    if (ddb_entry->sess)
>> +            ddb_entry->sess->recovery_tmo = ddb_entry->ka_timeout;
>
>
>I do not think port_down_retry_count is used anymore is it?
>
>I also could not tell where port_down_timer is used. I saw it get set in
>ql4_init.c but I did not see it get read anywhere.

Removed it as its not used any more.

>
>
>
>>      dev_info(&ha->pdev->dev, "DDB list done..\n");
>
>In a completely different patch on a different day when my eyes do not
>hurt you should send a patch to use your ql4_printk macro in these places.

Replace all dev_info with ql4_printk in separate patch.

>
>
>>
>>   /**
>> - * qla4xxx_update_ddb_list - update the driver ddb list
>> + * qla4xxx_reinitialize_ddb_list - update the driver ddb list
>>    * @ha: pointer to host adapter structure.
>>    *
>>    * This routine obtains device information from the F/W database after
>> @@ -991,10 +1035,15 @@ int qla4xxx_reinitialize_ddb_list(struct
>scsi_qla_host *ha)
>>              if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
>>                      atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
>>                      DEBUG2(printk ("scsi%ld: %s: ddb index [%d] marked "
>> -                                   "ONLINE\n", ha->host_no, __func__,
>> -                                   ddb_entry->fw_ddb_index));
>> -            } else if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
>> +                        "ONLINE\n", ha->host_no, __func__,
>> +                        ddb_entry->fw_ddb_index));
>> +                    iscsi_unblock_session(ddb_entry->sess);
>
>
>
>Was this and below a bug fix? What was it exactly?

Yes, it is bug fix. Submitted again as separate patch.

>
>
>>      if (old_fw_ddb_device_state == state&&
>>      state == DDB_DS_SESSION_ACTIVE) {
>> -            /* Do nothing, state not changed. */
>> +            if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
>> +                    atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
>> +                    iscsi_unblock_session(ddb_entry->sess);
>> +            }
>>              return QLA_SUCCESS;
>>      }
>>
>
>
>
>
>
>> +    } else {
>> +            ql4_printk(KERN_WARNING, ha,
>> +                    "INTx: Failed to reserve interrupt %d already in"
>> +                    " use.\n", ha->pdev->irq);
>> +            return ret;
>> +    }
>> +
>> +irq_attached:
>> +    set_bit(AF_IRQ_ATTACHED,&ha->flags);
>> +    ha->host->irq = ha->pdev->irq;
>> +    dev_info(&ha->pdev->dev, "%s: irq %d attached\n",
>> +                    __func__, ha->pdev->irq);
>
>
>
>Why do you sometimes use your new printk macro, but in other places you
>do not? You should have just added the new macro in a completely
>different patch (one logical change per patch type of thing).
>
>
>
>>
>>      /* Send the mailbox command to the firmware */
>> @@ -76,15 +94,31 @@ static int qla4xxx_mailbox_command(struct
>scsi_qla_host *ha, uint8_t inCount,
>>      for (i = 0; i<  outCount; i++)
>>              ha->mbox_status[i] = 0;
>>
>> -    /* Load all mailbox registers, except mailbox 0. */
>> -    for (i = 1; i<  inCount; i++)
>> -            writel(mbx_cmd[i],&ha->reg->mailbox[i]);
>> -
>> -    /* Wakeup firmware  */
>> -    writel(mbx_cmd[0],&ha->reg->mailbox[0]);
>> -    readl(&ha->reg->mailbox[0]);
>> -    writel(set_rmask(CSR_INTR_RISC),&ha->reg->ctrl_status);
>> -    readl(&ha->reg->ctrl_status);
>> +    if (is_qla8022(ha)) {
>> +            /* Load all mailbox registers, except mailbox 0. */
>> +            #if defined(QL_DEBUG_LEVEL_5)
>
>I think we normally put if defs like this in something like ql4_dbg.h
>

Yes - removed.

>
>
>
>>
>>      /* Wait for completion */
>> @@ -98,26 +132,65 @@ static int qla4xxx_mailbox_command(struct
>scsi_qla_host *ha, uint8_t inCount,
>>              status = QLA_SUCCESS;
>>              goto mbox_exit;
>>      }
>> -    /* Wait for command to complete */
>> -    wait_count = jiffies + MBOX_TOV * HZ;
>> -    while (test_bit(AF_MBOX_COMMAND_DONE,&ha->flags) == 0) {
>> -            if (time_after_eq(jiffies, wait_count))
>> -                    break;
>> -
>> -            spin_lock_irqsave(&ha->hardware_lock, flags);
>> -            intr_status = readl(&ha->reg->ctrl_status);
>> -            if (intr_status&  INTR_PENDING) {
>> +    /*
>> +     * Wait for completion: Poll or completion queue
>> +     */
>> +    if (test_bit(AF_IRQ_ATTACHED,&ha->flags)&&
>> +        test_bit(AF_INTERRUPTS_ON,&ha->flags)&&
>> +        test_bit(AF_ONLINE,&ha->flags)&&
>> +        !test_bit(AF_HBA_GOING_AWAY,&ha->flags)) {
>> +            /* Do not poll for completion. Use completion queue */
>> +            set_bit(AF_MBOX_COMMAND_NOPOLL,&ha->flags);
>> +            wait_for_completion_timeout(&ha->mbx_intr_comp, MBOX_TOV *
>HZ);
>> +            clear_bit(AF_MBOX_COMMAND_NOPOLL,&ha->flags);
>> +    } else {
>> +            /* Poll for command to complete */
>> +            set_current_state(TASK_UNINTERRUPTIBLE);
>
>.....
>
>> +                    spin_unlock_irqrestore(&ha->hardware_lock, flags);
>> +                    msleep(10);
>>              }
>> -            spin_unlock_irqrestore(&ha->hardware_lock, flags);
>> -            msleep(10);
>> +            set_current_state(TASK_RUNNING);
>
>
>
>If you use msleep I do not think you need the set_current_state
>TASK_UNINTERRUPTIBLE and TASK_RUNNING calls. Did you have some
>schedule()s in there before?
>
>

Correct -removed calls to TASK_UNINTERRUPTIBLE and TASK_RUNNING.

>
>> +#include "ql4_def.h"
>> +#include "ql4_glbl.h"
>> +#include<linux/delay.h>
>> +#include<linux/pci.h>
>
>
>
>We normally put the linux includes before the local ones.
>
Yes - Done.

>
>
>> +
>> +#define MASK(n)                     ((1ULL<<(n))-1)
>
>
>
>We have a BIT_MASK(). You should add a common helper for unsigned long
>longs.
>

Replaced it with DMA_BIT_MASK().

>
>
>
>
>
>
>> +#ifndef readq
>
>
>
>Why would this not be defined and you would have to implement your own.
>Is this for a distro kernel?
>

Removed.

>
>
>
>> +
>> +struct crb_128M_2M_block_map crb_128M_2M_map[64] = {
>
>
>I have not seen this before. What is it for?

This is specific to our new hardware ISP82XX.
It's basically address translation table for our hardware.

>
>
>> +    {{{0, 0,         0,         0} } },             /* 0: PCI */
>> +    {{{1, 0x0100000, 0x0102000, 0x120000},  /* 1: PCIE */
>> +            {1, 0x0110000, 0x0120000, 0x130000},
>> +            {1, 0x0120000, 0x0122000, 0x124000},
>> +            {1, 0x0130000, 0x0132000, 0x126000},
>> +            {1, 0x0140000, 0x0142000, 0x128000},
>> +            {1, 0x0150000, 0x0152000, 0x12a000},
>> +            {1, 0x0160000, 0x0170000, 0x110000},
>> +            {1, 0x0170000, 0x0172000, 0x12e000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {1, 0x01e0000, 0x01e0800, 0x122000},
>> +            {0, 0x0000000, 0x0000000, 0x000000} } },
>> +    {{{1, 0x0200000, 0x0210000, 0x180000} } },/* 2: MN */
>> +    {{{0, 0,         0,         0} } },         /* 3: */
>> +    {{{1, 0x0400000, 0x0401000, 0x169000} } },/* 4: P2NR1 */
>> +    {{{1, 0x0500000, 0x0510000, 0x140000} } },/* 5: SRE   */
>> +    {{{1, 0x0600000, 0x0610000, 0x1c0000} } },/* 6: NIU   */
>> +    {{{1, 0x0700000, 0x0704000, 0x1b8000} } },/* 7: QM    */
>> +    {{{1, 0x0800000, 0x0802000, 0x170000},  /* 8: SQM0  */
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {1, 0x08f0000, 0x08f2000, 0x172000} } },
>> +    {{{1, 0x0900000, 0x0902000, 0x174000},  /* 9: SQM1*/
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {1, 0x09f0000, 0x09f2000, 0x176000} } },
>> +    {{{0, 0x0a00000, 0x0a02000, 0x178000},  /* 10: SQM2*/
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {1, 0x0af0000, 0x0af2000, 0x17a000} } },
>> +    {{{0, 0x0b00000, 0x0b02000, 0x17c000},  /* 11: SQM3*/
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {1, 0x0bf0000, 0x0bf2000, 0x17e000} } },
>> +    {{{1, 0x0c00000, 0x0c04000, 0x1d4000} } },/* 12: I2Q */
>> +    {{{1, 0x0d00000, 0x0d04000, 0x1a4000} } },/* 13: TMR */
>> +    {{{1, 0x0e00000, 0x0e04000, 0x1a0000} } },/* 14: ROMUSB */
>> +    {{{1, 0x0f00000, 0x0f01000, 0x164000} } },/* 15: PEG4 */
>> +    {{{0, 0x1000000, 0x1004000, 0x1a8000} } },/* 16: XDMA */
>> +    {{{1, 0x1100000, 0x1101000, 0x160000} } },/* 17: PEG0 */
>> +    {{{1, 0x1200000, 0x1201000, 0x161000} } },/* 18: PEG1 */
>> +    {{{1, 0x1300000, 0x1301000, 0x162000} } },/* 19: PEG2 */
>> +    {{{1, 0x1400000, 0x1401000, 0x163000} } },/* 20: PEG3 */
>> +    {{{1, 0x1500000, 0x1501000, 0x165000} } },/* 21: P2ND */
>> +    {{{1, 0x1600000, 0x1601000, 0x166000} } },/* 22: P2NI */
>> +    {{{0, 0,         0,         0} } },     /* 23: */
>> +    {{{0, 0,         0,         0} } },     /* 24: */
>> +    {{{0, 0,         0,         0} } },     /* 25: */
>> +    {{{0, 0,         0,         0} } },     /* 26: */
>> +    {{{0, 0,         0,         0} } },     /* 27: */
>> +    {{{0, 0,         0,         0} } },     /* 28: */
>> +    {{{1, 0x1d00000, 0x1d10000, 0x190000} } },/* 29: MS */
>> +    {{{1, 0x1e00000, 0x1e01000, 0x16a000} } },/* 30: P2NR2 */
>> +    {{{1, 0x1f00000, 0x1f10000, 0x150000} } },/* 31: EPG */
>> +    {{{0} } },                              /* 32: PCI */
>> +    {{{1, 0x2100000, 0x2102000, 0x120000},  /* 33: PCIE */
>> +            {1, 0x2110000, 0x2120000, 0x130000},
>> +            {1, 0x2120000, 0x2122000, 0x124000},
>> +            {1, 0x2130000, 0x2132000, 0x126000},
>> +            {1, 0x2140000, 0x2142000, 0x128000},
>> +            {1, 0x2150000, 0x2152000, 0x12a000},
>> +            {1, 0x2160000, 0x2170000, 0x110000},
>> +            {1, 0x2170000, 0x2172000, 0x12e000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000},
>> +            {0, 0x0000000, 0x0000000, 0x000000} } },
>> +    {{{1, 0x2200000, 0x2204000, 0x1b0000} } },/* 34: CAM */
>> +    {{{0} } },                              /* 35: */
>> +    {{{0} } },                              /* 36: */
>> +    {{{0} } },                              /* 37: */
>> +    {{{0} } },                              /* 38: */
>> +    {{{0} } },                              /* 39: */
>> +    {{{1, 0x2800000, 0x2804000, 0x1a4000} } },/* 40: TMR */
>> +    {{{1, 0x2900000, 0x2901000, 0x16b000} } },/* 41: P2NR3 */
>> +    {{{1, 0x2a00000, 0x2a00400, 0x1ac400} } },/* 42: RPMX1 */
>> +    {{{1, 0x2b00000, 0x2b00400, 0x1ac800} } },/* 43: RPMX2 */
>> +    {{{1, 0x2c00000, 0x2c00400, 0x1acc00} } },/* 44: RPMX3 */
>> +    {{{1, 0x2d00000, 0x2d00400, 0x1ad000} } },/* 45: RPMX4 */
>> +    {{{1, 0x2e00000, 0x2e00400, 0x1ad400} } },/* 46: RPMX5 */
>> +    {{{1, 0x2f00000, 0x2f00400, 0x1ad800} } },/* 47: RPMX6 */
>> +    {{{1, 0x3000000, 0x3000400, 0x1adc00} } },/* 48: RPMX7 */
>> +    {{{0, 0x3100000, 0x3104000, 0x1a8000} } },/* 49: XDMA */
>> +    {{{1, 0x3200000, 0x3204000, 0x1d4000} } },/* 50: I2Q */
>> +    {{{1, 0x3300000, 0x3304000, 0x1a0000} } },/* 51: ROMUSB */
>> +    {{{0} } },                              /* 52: */
>> +    {{{1, 0x3500000, 0x3500400, 0x1ac000} } },/* 53: RPMX0 */
>> +    {{{1, 0x3600000, 0x3600400, 0x1ae000} } },/* 54: RPMX8 */
>> +    {{{1, 0x3700000, 0x3700400, 0x1ae400} } },/* 55: RPMX9 */
>> +    {{{1, 0x3800000, 0x3804000, 0x1d0000} } },/* 56: OCM0 */
>> +    {{{1, 0x3900000, 0x3904000, 0x1b4000} } },/* 57: CRYPTO */
>> +    {{{1, 0x3a00000, 0x3a04000, 0x1d8000} } },/* 58: SMB */
>> +    {{{0} } },                              /* 59: I2C0 */
>> +    {{{0} } },                              /* 60: I2C1 */
>> +    {{{1, 0x3d00000, 0x3d04000, 0x1dc000} } },/* 61: LPC */
>> +    {{{1, 0x3e00000, 0x3e01000, 0x167000} } },/* 62: P2NC */
>> +    {{{1, 0x3f00000, 0x3f01000, 0x168000} } }       /* 63: P2NR0 */
>> +};
>> +
>
>
>
>> +
>> +/*
>> + * Set the CRB window based on the offset.
>> + * Return 0 if successful; 1 otherwise
>> +*/
>> +void qla82xx_pci_change_crbwindow_128M(struct scsi_qla_host *ha, int
>wndw)
>> +{
>> +    WARN_ON(1);
>> +}
>
>
>Are you going to do something more with this?
>
>Could also be static if you are.
>
>
>
>
>
>> +static inline unsigned long
>> +qla82xx_pci_set_crbwindow(struct scsi_qla_host *ha, u64 off)
>> +{
>
>
>I think this falls under the do not use inline rule in the CodingStyle doc.
>
>
>
>> +
>> +int qla82xx_crb_win_lock(struct scsi_qla_host *ha)
>> +{
>
>
>It seems like there are a lot of functions like this that should be
>static. You just have them in the wrong order.
>
>
>I think if you run sparse it will find these for you.
>

Ran *sparse* and fixed all the warnings - Done.

>
>
>
>
>
>> +int
>> +qla82xx_pci_get_crb_addr_2M(struct scsi_qla_host *ha, ulong *off)
>> +{
>> +    struct crb_128M_2M_sub_block_map *m;
>> +
>> +    if (*off>= QLA82XX_CRB_MAX)
>> +            return -1;
>> +
>> +    if (*off>= QLA82XX_PCI_CAMQM&&  (*off<  QLA82XX_PCI_CAMQM_2M_END)) {
>> +            *off = (*off - QLA82XX_PCI_CAMQM) + QLA82XX_PCI_CAMQM_2M_BASE
>+ ha->nx_pcibase;
>> +            return 0;
>> +    }
>> +
>> +    if (*off<  QLA82XX_PCI_CRBSPACE)
>> +            return -1;
>> +
>> +    *off -= QLA82XX_PCI_CRBSPACE;
>> +    /*
>> +     * Try direct map
>> +     */
>> +
>> +    m =&crb_128M_2M_map[CRB_BLK(*off)].sub_block[CRB_SUBBLK(*off)];
>> +
>> +    if (m->valid&&  (m->start_128M<= *off)&&  (m->end_128M>  *off)) {
>> +            *off = *off + m->start_2M - m->start_128M + ha->nx_pcibase;
>> +            return 0;
>> +    }
>> +
>> +    /*
>> +     * Not in direct map, use crb window
>> +     */
>> +    return 1;
>> +}
>> +
>> +/*  PCI Windowing for DDR regions.  */
>> +#define QLA82XX_ADDR_IN_RANGE(addr, low, high)            \
>> +    (((addr)<= (high))&&  ((addr)>= (low)))
>> +
>> +/*
>> +* check memory access boundary.
>> +* used by test agent. support ddr access only for now
>> +*/
>> +static unsigned long
>> +qla82xx_pci_mem_bound_check(struct scsi_qla_host *ha,
>> +            unsigned long long addr, int size)
>> +{
>> +    if (!QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
>QLA82XX_ADDR_DDR_NET_MAX) ||
>> +            !QLA82XX_ADDR_IN_RANGE(addr + size - 1, QLA82XX_ADDR_DDR_NET,
>QLA82XX_ADDR_DDR_NET_MAX) ||
>> +            ((size != 1)&&  (size != 2)&&  (size != 4)&&  (size != 8))) {
>> +            return 0;
>> +    }
>> +    return 1;
>> +}
>> +
>> +int qla82xx_pci_set_window_warning_count;
>> +
>> +unsigned long
>> +qla82xx_pci_set_window(struct scsi_qla_host *ha, unsigned long long
>addr)
>> +{
>> +    int window;
>> +    u32 win_read;
>> +
>> +    if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
>QLA82XX_ADDR_DDR_NET_MAX)) {
>
>
>
>A bunch of 80 column overruns in this function.
>
>
>> +            /* DDR network side */
>> +            window = MN_WIN(addr);
>> +            ha->ddr_mn_window = window;
>> +            qla82xx_wr_32(ha, ha->mn_win_crb | QLA82XX_PCI_CRBSPACE,
>window);
>> +            win_read = qla82xx_rd_32(ha, ha->mn_win_crb |
>QLA82XX_PCI_CRBSPACE);
>> +            if ((win_read<<  17) != window) {
>> +                    ql4_printk(KERN_WARNING, ha,
>> +                    "%s: Written MNwin (0x%x) != Read MNwin (0x%x)\n",
>> +                    __func__, window, win_read);
>> +            }
>> +            addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_DDR_NET;
>> +    } else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0,
>QLA82XX_ADDR_OCM0_MAX)) {
>> +            unsigned int temp1;
>> +            if ((addr&  0x00ff800) == 0xff800) {    /* if bits 19:18&17:11
>are on */
>> +            printk("%s: QM access not handled.\n", __func__);
>> +            addr = -1UL;
>> +    }
>> +
>> +    window = OCM_WIN(addr);
>> +    ha->ddr_mn_window = window;
>> +    qla82xx_wr_32(ha, ha->mn_win_crb | QLA82XX_PCI_CRBSPACE, window);
>> +    win_read = qla82xx_rd_32(ha, ha->mn_win_crb | QLA82XX_PCI_CRBSPACE);
>> +    temp1 = ((window&  0x1FF)<<  7) | ((window&  0x0FFFE0000)>>  17);
>> +    if (win_read != temp1) {
>> +            printk("%s: Written OCMwin (0x%x) != Read OCMwin (0x%x)\n",
>> +            __func__, temp1, win_read);
>> +    }
>> +    addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_OCM0_2M;
>
>I am not sure what you intended here. Was the line above supposed to go
>in the "if"'s block or was the part below supposed to be a if and not a
>else if?
>
>
>> +
>> +    } else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET,
>QLA82XX_P3_ADDR_QDR_NET_MAX)) {
>> +            /* QDR network side */
>> +            window = MS_WIN(addr);
>> +            ha->qdr_sn_window = window;
>> +            qla82xx_wr_32(ha, ha->ms_win_crb | QLA82XX_PCI_CRBSPACE,
>window);
>> +            win_read = qla82xx_rd_32(ha, ha->ms_win_crb |
>QLA82XX_PCI_CRBSPACE);
>> +            if (win_read != window) {
>> +                    printk("%s: Written MSwin (0x%x) != Read MSwin
>(0x%x)\n",
>> +                    __func__, window, win_read);
>> +            }
>> +            addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_QDR_NET;
>> +
>> +    } else {
>
>
>Indention got messed up.

Corrected in latest patch.

>
>
>> +    /*
>> +    * peg gdb frequently accesses memory that doesn't exist,
>> +    * this limits the chit chat so debugging isn't slowed down.
>> +    */
>> +    if ((qla82xx_pci_set_window_warning_count++<  8) ||
>> +        (qla82xx_pci_set_window_warning_count%64 == 0)) {
>> +            printk("%s: Warning:%s Unknown address range!\n", __func__,
>> +                DRIVER_NAME);
>> +    }
>> +    addr = -1UL;
>> +    }
>> +    /* printk("New address: 0x%08lx\n",addr); */
>
>
>Junk printk.

Removed.
>
>
>> +    return addr;
>> +}
>> +
>> +/* check if address is in the same windows as the previous access */
>> +static int qla82xx_pci_is_same_window(struct scsi_qla_host *ha,
>> +            unsigned long long addr)
>> +{
>> +    int                     window;
>> +    unsigned long long      qdr_max;
>
>
>
>Could you pick a tabbing style and stick to it. Friggen 6k line patch
>and my eyes are bleeding :)
>
>
>> +
>> +    qdr_max = QLA82XX_P3_ADDR_QDR_NET_MAX;
>> +
>> +    if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
>QLA82XX_ADDR_DDR_NET_MAX)) {
>> +            /* DDR network side */
>> +            BUG();  /* MN access can not come here */
>> +    } else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0,
>QLA82XX_ADDR_OCM0_MAX)) {
>> +            return 1;
>> +    } else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM1,
>QLA82XX_ADDR_OCM1_MAX)) {
>> +            return 1;
>> +    } else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET,
>qdr_max)) {
>> +            /* QDR network side */
>> +            window = ((addr - QLA82XX_ADDR_QDR_NET)>>  22)&  0x3f;
>> +            if (ha->qdr_sn_window == window)
>> +                    return 1;
>> +
>> +    }
>> +
>
>
>
>
>
>> +
>> +int
>> +qla82xx_rom_fast_read(struct scsi_qla_host *ha, int addr, int *valp)
>> +{
>> +    int ret, loops = 0;
>> +
>> +    while ((qla82xx_rom_lock(ha) != 0)&&  (loops<  50000)) {
>> +            udelay(100);
>> +            schedule();
>
>
>
>I think udelay is enough.
>
>

Yes. Removed schedule().

>
>> +}
>> +
>> +static int qla82xx_rcvpeg_ready(struct scsi_qla_host *ha)
>> +{
>> +    uint32_t state = 0;
>> +    int loops = 0, err = 0;
>> +
>> +    /* Window 1 call */
>> +    read_lock(&ha->hw_lock);
>> +    state = qla82xx_rd_32(ha, CRB_RCVPEG_STATE);
>> +    read_unlock(&ha->hw_lock);
>> +
>> +    while ((state != PHAN_PEG_RCV_INITIALIZED)&&  (loops<  30000)) {
>> +            udelay(100);
>> +            schedule();
>
>
>Just need one or the other.
>
>

Done.

>
>
>
>
>> +}
>> +
>> +static int
>> +qla82xx_try_start_fw(struct scsi_qla_host *ha)
>> +{
>> +    int rval = QLA_ERROR;
>> +
>> +    /*
>> +     * FW Load priority:
>> +     * 1) Operational firmware residing in flash.
>> +     * 2) Fail
>> +     */
>> +
>> +    ql4_printk(KERN_INFO, ha, "FW: Retrieving flash offsets from FLT/FDT
>...\n");
>> +    rval = qla82xx_get_flash_info(ha);
>> +    if (rval != QLA_SUCCESS)
>> +            return rval;
>> +
>> +    ql4_printk(KERN_INFO, ha, "FW: Attempting to load firmware from
>flash...\n");
>> +    rval = qla82xx_start_firmware(ha, ha->hw.flt_region_fw);
>> +    if (rval == QLA_SUCCESS)
>> +            return rval;
>> +
>> +    ql4_printk(KERN_ERR, ha, "FW: Load firmware from flash
>FAILED...\n");
>> +    rval = QLA_ERROR;
>> +
>> +    return rval;
>
>
>Just do return QLA_ERROR
>

Done.

>
>
>
>
>
>
>
>
>> +
>> +    while (drv_state != drv_active) {
>> +
>
>extra newline
>
>> +            if (time_after_eq(jiffies, reset_timeout)) {
>> +                    printk("%s: RESET TIMEOUT!\n", DRIVER_NAME);
>> +                    break;
>> +            }
>> +
>> +            qla82xx_idc_unlock(ha);
>> +            msleep(1000);
>> +            qla82xx_idc_lock(ha);
>> +
>> +            drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
>> +            drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
>> +    }
>> +
>> +    dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
>> +    ql4_printk(KERN_INFO, ha, "3:Device state is 0x%x = %s\n",
>dev_state,
>> +            dev_state<  MAX_STATES ? qdev_state[dev_state] : "Unknown");
>> +
>> +    /* Force to DEV_COLD unless someone else is starting a reset */
>> +    if (dev_state != QLA82XX_DEV_INITIALIZING) {
>> +            ql4_printk(KERN_INFO, ha, "HW State: COLD/RE-INIT\n");
>> +            qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_COLD);
>> +    }
>> +}
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>> +
>> +/*
>> +Address and length are byte address
>> +*/
>> +uint8_t *
>> +qla82xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
>> +            uint32_t offset, uint32_t length)
>> +{
>> +    scsi_block_requests(ha->host);
>> +
>> +    qla82xx_read_flash_data(ha, (uint32_t *)buf, offset, length);
>> +
>> +    scsi_unblock_requests(ha->host);
>
>
>
>What is the block/unblock for?  Looks like it could be racey.
>
>

We want to block I/O while doing flash operations.

>
>
>
>
>
>
>> +
>> +void
>> +qla82xx_enable_intrs(struct scsi_qla_host *ha)
>> +{
>> +    (void) qla82xx_mbx_intr_enable(ha);
>
>
>Do not need the (void) part.

Removed from all places.

>
>
>> +
>> +    spin_lock_irq(&ha->hardware_lock);
>> +    qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff); /* BIT
>10 - reset */
>> +    spin_unlock_irq(&ha->hardware_lock);
>> +    set_bit(AF_INTERRUPTS_ON,&ha->flags);
>> +}
>> +
>> +void
>> +qla82xx_disable_intrs(struct scsi_qla_host *ha)
>> +{
>> +    if (test_bit(AF_INTERRUPTS_ON,&ha->flags))
>> +            (void) qla82xx_mbx_intr_disable(ha);
>
>
>Do not need the (void) part.
>
>
>
>>
>> -void qla4xxx_hw_reset(struct scsi_qla_host *ha)
>> +int qla4xxx_hw_reset(struct scsi_qla_host *ha)
>>   {
>>      uint32_t ctrl_status;
>>      unsigned long flags = 0;
>>
>>      DEBUG2(printk(KERN_ERR "scsi%ld: %s\n", ha->host_no, __func__));
>>
>> +    if (ql4xxx_lock_drvr_wait(ha) != QLA_SUCCESS)
>> +            return QLA_ERROR;
>> +
>
>
>I know somehwere in here there is the unlock. Does the soft reset
>release the lock for you?
>
>
Yes, soft reset release lock.

>
>
>
>>
>>   /**
>> - * qla4xxx_flush_active_srbs - returns all outstanding i/o requests to
>O.S.
>> + * qla4xxx_abort_active_cmds - returns all outstanding i/o requests to
>O.S.
>>    * @ha: Pointer to host adapter structure.
>
>Should update the function arguments too.
>

Done.

>
>>    *
>>    * This routine is called just prior to a HARD RESET to return all
>> @@ -879,7 +992,7 @@ int qla4xxx_soft_reset(struct scsi_qla_host *ha)
>>    * Caller should make sure that the following locks are released
>>    * before this calling routine: Hardware lock, and io_request_lock.
>>    **/
>> -static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
>> +void qla4xxx_abort_active_cmds(struct scsi_qla_host *ha, int res)
>
>
>Is this only used in qla_os.c? Should be static then. Run sparse and get
>all of these.

Done.

>
>
>
>
>
>
>
>
>
>
>
>>   /**
>>    * qla4xxx_recover_adapter - recovers adapter after a fatal error
>>    * @ha: Pointer to host adapter structure.
>> @@ -904,64 +1030,98 @@ static void qla4xxx_flush_active_srbs(struct
>scsi_qla_host *ha)
>>    * renew_ddb_list value can be 0=preserve ddb list, 1=destroy and
>rebuild
>>    * ddb list.
>
>update function comments.
>
>
>>    **/
>> -static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
>> -                            uint8_t renew_ddb_list)
>> +static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
>>   {
>> -    int status;
>> +    int status = QLA_ERROR;
>> +    uint8_t reset_chip = 0;
>>
>>      /* Stall incoming I/O until we are done */
>> +    scsi_block_requests(ha->host);
>
>
>This looks racey. What about IO that is just hitting the queuecommand or
>in the scsi layer? What is it trying to do? What is up with the use of
>this function but then the use of the DPC_RESET_HA_INTR check in
>queuecommand. Do you just want to check some dpc_flags in queuecommand?
>

While doing recover adapter we are using "scsi_block_requests()" to block i/o.
Btw we are already using dpc_flags in queuecommand
to queue I/O at scsi_ml level while driver is doing internal
recovery. So this takes care of I/O which is just hitting queuecommand.
Here's the snippet from qla4xxx_queuecommand() :

if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
            test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
            test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
            test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags) ||
            test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags) ||
            !test_bit(AF_ONLINE, &ha->flags) ||
            test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
                goto qc_host_busy;

...............

qc_host_busy:
        return SCSI_MLQUEUE_HOST_BUSY;

Let us know if we are missing something over here.

>I do like the scsi_block_requests because it stops it at the scsi layer.
>
>
>>
>> -    if (status == QLA_SUCCESS)
>> -            qla4xxx_enable_intrs(ha);
>> +    if (test_bit(AF_ONLINE,&ha->flags)) {
>> +            ha->isp_ops->enable_intrs(ha);
>> +            scsi_unblock_requests(ha->host);
>
>If there is IO in the block/scsi queue and we do not unblock here, is
>there somehting that when the driver is unloaded will flush the queues
>and kill IO?
>
>If a sync cache is needed on device shutdown, then it looks like sd.c
>will send that and wait then we hit the scsi_host_queue_ready check in
>scsi_request_fn and requeue. Then we will repeat this over and over and
>over, and will we end up waiting forever?

I moved "scsi_block_requests" outside of if case so that it will get
called even if initialize adapter fail and i/o's in block/scsi queue
will get return from queuecommand with status "SCSI_MLQUEUE_HOST_BUSY"
Its addressed in the current patch which I just submitted.

Let us know if you see any issue with this implementation.

Btw thanks for reviewing this patch and providing your feedback.

Thanks
Vikas
