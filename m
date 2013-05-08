From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pm80xx: NCQ error handling changes
Date: Wed, 8 May 2013 22:57:16 +0300
Message-ID: <20130508195716.GA14142@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48926 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab3EHT5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 15:57:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sakthivel.SaravananKamalRaju@pmcs.com
Cc: linux-scsi@vger.kernel.org

Hello Sakthivel K,

This is a semi-automatic email about new static checker warnings.

The patch 1cde970c1025: "[SCSI] pm80xx: NCQ error handling changes"
from Mar 19, 2013, leads to the following Smatch complaint:

drivers/scsi/pm8001/pm8001_hwi.c:4393 pm8001_chip_sata_req()
	 warn: variable dereferenced before check 'pm8001_ha_dev' (see line 4362)

drivers/scsi/pm8001/pm8001_hwi.c
  4361		sata_cmd.tag = cpu_to_le32(tag);
  4362		sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
                                                 ^^^^^^^^^^^^^
Old dereference.

  4363		sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
  4364		sata_cmd.ncqtag_atap_dir_m =
  4365			cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);
  4366		sata_cmd.sata_fis = task->ata_task.fis;
  4367		if (likely(!task->ata_task.device_control_reg_update))
  4368			sata_cmd.sata_fis.flags |= 0x80;/* C=1: update ATA cmd reg */
  4369		sata_cmd.sata_fis.flags &= 0xF0;/* PM_PORT field shall be 0 */
  4370		/* fill in PRD (scatter/gather) table, if any */
  4371		if (task->num_scatter > 1) {
  4372			pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);
  4373			phys_addr = ccb->ccb_dma_handle +
  4374					offsetof(struct pm8001_ccb_info, buf_prd[0]);
  4375			sata_cmd.addr_low = lower_32_bits(phys_addr);
  4376			sata_cmd.addr_high = upper_32_bits(phys_addr);
  4377			sata_cmd.esgl = cpu_to_le32(1 << 31);
  4378		} else if (task->num_scatter == 1) {
  4379			u64 dma_addr = sg_dma_address(task->scatter);
  4380			sata_cmd.addr_low = lower_32_bits(dma_addr);
  4381			sata_cmd.addr_high = upper_32_bits(dma_addr);
  4382			sata_cmd.len = cpu_to_le32(task->total_xfer_len);
  4383			sata_cmd.esgl = 0;
  4384		} else if (task->num_scatter == 0) {
  4385			sata_cmd.addr_low = 0;
  4386			sata_cmd.addr_high = 0;
  4387			sata_cmd.len = cpu_to_le32(task->total_xfer_len);
  4388			sata_cmd.esgl = 0;
  4389		}
  4390	
  4391		/* Check for read log for failed drive and return */
  4392		if (sata_cmd.sata_fis.command == 0x2f) {
  4393			if (pm8001_ha_dev && ((pm8001_ha_dev->id & NCQ_READ_LOG_FLAG) ||
                            ^^^^^^^^^^^^^
New check.  Probably this check is unneeded and can be removed.

  4394				(pm8001_ha_dev->id & NCQ_ABORT_ALL_FLAG) ||
  4395				(pm8001_ha_dev->id & NCQ_2ND_RLE_FLAG))) {

regards,
dan carpenter
