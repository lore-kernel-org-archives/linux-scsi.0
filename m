From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCHv2 02/14] libsas: enable FPDMA SEND/RECEIVE
Date: Tue, 12 Apr 2016 15:19:34 +0800
Message-ID: <201604121545.aZhu7sOa%fengguang.wu@intel.com>
References: <1460443678-57934-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460443678-57934-3-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
Cc: kbuild-all@01.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

[auto build test WARNING on tj-libata/for-next]
[also build test WARNING on next-20160412]
[cannot apply to v4.6-rc3]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/ZAC-support/20160412-145232
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/libata for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:1576:14: sparse: undefined identifier 'ATA_CMD_FPMDA_RECV'
>> drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:1576:14: sparse: incompatible types for 'case' statement
   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:1576:14: sparse: Expected constant expression in case statement
   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c: In function 'get_ata_protocol':
   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:1576:7: error: 'ATA_CMD_FPMDA_RECV' undeclared (first use in this function)
     case ATA_CMD_FPMDA_RECV:
          ^
   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:1576:7: note: each undeclared identifier is reported only once for each function it appears in

vim +/case +1576 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c

  1560			sas_dev->running_req--;
  1561	
  1562		hisi_sas_slot_task_free(hisi_hba, task, slot);
  1563		sts = ts->stat;
  1564	
  1565		if (task->task_done)
  1566			task->task_done(task);
  1567	
  1568		return sts;
  1569	}
  1570	
  1571	static u8 get_ata_protocol(u8 cmd, int direction)
  1572	{
  1573		switch (cmd) {
  1574		case ATA_CMD_FPDMA_WRITE:
  1575		case ATA_CMD_FPDMA_READ:
> 1576		case ATA_CMD_FPMDA_RECV:
  1577		case ATA_CMD_FPDMA_SEND:
  1578		return SATA_PROTOCOL_FPDMA;
  1579	
  1580		case ATA_CMD_ID_ATA:
  1581		case ATA_CMD_PMP_READ:
  1582		case ATA_CMD_READ_LOG_EXT:
  1583		case ATA_CMD_PIO_READ:
  1584		case ATA_CMD_PIO_READ_EXT:

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
