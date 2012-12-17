From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [scsi:for-next 12/27] drivers/scsi/ipr.c:6568 ipr_qc_issue() warn:
 inconsistent returns spin_lock:&ipr_cmd->hrrq->_lock: locked (6562) unlocked
 (6499,6507,6568)
Date: Mon, 17 Dec 2012 16:24:04 +0300
Message-ID: <20121217132403.GO5083@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33259 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LQNYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2012 08:24:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, kbuild@01.org

Hi,

FYI, there are new smatch warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
commit: e7ef7307d9e2c15802e8ea1da9878e0550ec87bc [12/27] [SCSI] ipr: Reduce lock contention

  drivers/scsi/ipr.c:5434 ipr_build_ioadl64() info: why not propagate 'nseg' from scsi_dma_map() instead of (-1)?
  drivers/scsi/ipr.c:5485 ipr_build_ioadl() info: why not propagate 'nseg' from scsi_dma_map() instead of (-1)?
+ drivers/scsi/ipr.c:6568 ipr_qc_issue() warn: inconsistent returns spin_lock:&ipr_cmd->hrrq->_lock: locked (6562) unlocked (6499,6507,6568)

git remote add scsi git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
git remote update scsi
git checkout e7ef7307d9e2c15802e8ea1da9878e0550ec87bc
vim +6568 drivers/scsi/ipr.c

35a39691 Brian King                  2006-09-25  6493  
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6494  	if (qc->lldd_task == NULL)
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6495  		ipr_qc_defer(qc);
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6496  
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6497  	ipr_cmd = qc->lldd_task;
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6498  	if (ipr_cmd == NULL)
0feeed82 Brian King                  2007-03-29 @6499  		return AC_ERR_SYSTEM;
35a39691 Brian King                  2006-09-25  6500  
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6501  	qc->lldd_task = NULL;
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6502  	spin_lock(&ipr_cmd->hrrq->_lock);
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6503  	if (unlikely(!ipr_cmd->hrrq->allow_cmds ||
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6504  			ipr_cmd->hrrq->ioa_is_dead)) {
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6505  		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6506  		spin_unlock(&ipr_cmd->hrrq->_lock);
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03 @6507  		return AC_ERR_SYSTEM;
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6508  	}
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6509  
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  6510  	ipr_init_ipr_cmnd(ipr_cmd, ipr_lock_and_done);
35a39691 Brian King                  2006-09-25  6511  	ioarcb = &ipr_cmd->ioarcb;
35a39691 Brian King                  2006-09-25  6512  
a32c055f Wayne Boyer                 2010-02-19  6513  	if (ioa_cfg->sis64) {
a32c055f Wayne Boyer                 2010-02-19  6514  		regs = &ipr_cmd->i.ata_ioadl.regs;
a32c055f Wayne Boyer                 2010-02-19  6515  		ioarcb->add_cmd_parms_offset = cpu_to_be16(sizeof(*ioarcb));
a32c055f Wayne Boyer                 2010-02-19  6516  	} else
a32c055f Wayne Boyer                 2010-02-19  6517  		regs = &ioarcb->u.add_data.u.regs;
a32c055f Wayne Boyer                 2010-02-19  6518  
a32c055f Wayne Boyer                 2010-02-19  6519  	memset(regs, 0, sizeof(*regs));
a32c055f Wayne Boyer                 2010-02-19  6520  	ioarcb->add_cmd_parms_len = cpu_to_be16(sizeof(*regs));
35a39691 Brian King                  2006-09-25  6521  
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6522  	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_pending_q);
35a39691 Brian King                  2006-09-25  6523  	ipr_cmd->qc = qc;
35a39691 Brian King                  2006-09-25  6524  	ipr_cmd->done = ipr_sata_done;
3e7ebdfa Wayne Boyer                 2010-02-19  6525  	ipr_cmd->ioarcb.res_handle = res->res_handle;
35a39691 Brian King                  2006-09-25  6526  	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_ATA_PASSTHRU;
35a39691 Brian King                  2006-09-25  6527  	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
35a39691 Brian King                  2006-09-25  6528  	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
dde20207 James Bottomley             2008-02-19  6529  	ipr_cmd->dma_use_sg = qc->n_elem;
35a39691 Brian King                  2006-09-25  6530  
a32c055f Wayne Boyer                 2010-02-19  6531  	if (ioa_cfg->sis64)
a32c055f Wayne Boyer                 2010-02-19  6532  		ipr_build_ata_ioadl64(ipr_cmd, qc);
a32c055f Wayne Boyer                 2010-02-19  6533  	else
a32c055f Wayne Boyer                 2010-02-19  6534  		ipr_build_ata_ioadl(ipr_cmd, qc);
a32c055f Wayne Boyer                 2010-02-19  6535  
35a39691 Brian King                  2006-09-25  6536  	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
35a39691 Brian King                  2006-09-25  6537  	ipr_copy_sata_tf(regs, &qc->tf);
35a39691 Brian King                  2006-09-25  6538  	memcpy(ioarcb->cmd_pkt.cdb, qc->cdb, IPR_MAX_CDB_LEN);
3e7ebdfa Wayne Boyer                 2010-02-19  6539  	ipr_trc_hook(ipr_cmd, IPR_TRACE_START, IPR_GET_RES_PHYS_LOC(res));
35a39691 Brian King                  2006-09-25  6540  
35a39691 Brian King                  2006-09-25  6541  	switch (qc->tf.protocol) {
35a39691 Brian King                  2006-09-25  6542  	case ATA_PROT_NODATA:
35a39691 Brian King                  2006-09-25  6543  	case ATA_PROT_PIO:
35a39691 Brian King                  2006-09-25  6544  		break;
35a39691 Brian King                  2006-09-25  6545  
35a39691 Brian King                  2006-09-25  6546  	case ATA_PROT_DMA:
35a39691 Brian King                  2006-09-25  6547  		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
35a39691 Brian King                  2006-09-25  6548  		break;
35a39691 Brian King                  2006-09-25  6549  
0dc36888 Tejun Heo                   2007-12-18  6550  	case ATAPI_PROT_PIO:
0dc36888 Tejun Heo                   2007-12-18  6551  	case ATAPI_PROT_NODATA:
35a39691 Brian King                  2006-09-25  6552  		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
35a39691 Brian King                  2006-09-25  6553  		break;
35a39691 Brian King                  2006-09-25  6554  
0dc36888 Tejun Heo                   2007-12-18  6555  	case ATAPI_PROT_DMA:
35a39691 Brian King                  2006-09-25  6556  		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
35a39691 Brian King                  2006-09-25  6557  		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
35a39691 Brian King                  2006-09-25  6558  		break;
35a39691 Brian King                  2006-09-25  6559  
35a39691 Brian King                  2006-09-25  6560  	default:
35a39691 Brian King                  2006-09-25  6561  		WARN_ON(1);
0feeed82 Brian King                  2007-03-29 @6562  		return AC_ERR_INVALID;
35a39691 Brian King                  2006-09-25  6563  	}
35a39691 Brian King                  2006-09-25  6564  
a32c055f Wayne Boyer                 2010-02-19  6565  	ipr_send_command(ipr_cmd);
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  6566  	spin_unlock(&ipr_cmd->hrrq->_lock);
a32c055f Wayne Boyer                 2010-02-19  6567  
35a39691 Brian King                  2006-09-25 @6568  	return 0;
35a39691 Brian King                  2006-09-25  6569  }
35a39691 Brian King                  2006-09-25  6570  
35a39691 Brian King                  2006-09-25  6571  /**

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
