From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [kbuild] [scsi:for-next 12/27] drivers/scsi/ipr.c:4883:17: sparse:
 context imbalance in '__ipr_eh_dev_reset' - different lock contexts for
 basic block
Date: Tue, 18 Dec 2012 22:14:30 +0300
Message-ID: <20121218191430.GV5083@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21922 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2LRTO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2012 14:14:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, kbuild@01.org

[ The unlocks are inside the loops but they were supposed to only
  happen after the loop was finished ]

Hi,

FYI, there are new sparse warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
commit: e7ef7307d9e2c15802e8ea1da9878e0550ec87bc [12/27] [SCSI] ipr: Reduce lock contention

drivers/scsi/ipr.c:1111:31: sparse: restricted __be16 degrades to integer
drivers/scsi/ipr.c:1165:30: sparse: incorrect type in assignment (different base types)
drivers/scsi/ipr.c:1165:30:    expected restricted __be64 [usertype] lun_wwn
drivers/scsi/ipr.c:1165:30:    got unsigned long long
drivers/scsi/ipr.c:1258:28: sparse: incorrect type in assignment (different base types)
drivers/scsi/ipr.c:1258:28:    expected unsigned char [unsigned] [usertype] flags
drivers/scsi/ipr.c:1258:28:    got restricted __be16 [usertype] flags
drivers/scsi/ipr.c:1265:31: sparse: restricted __be16 degrades to integer
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:1857:17: sparse: cast to restricted __be32
drivers/scsi/ipr.c:2324:35: sparse: incorrect type in argument 2 (different base types)
drivers/scsi/ipr.c:2324:35:    expected unsigned int [usertype] *data
drivers/scsi/ipr.c:2324:35:    got restricted __be32 *<noident>
drivers/scsi/ipr.c:2568:24: sparse: context imbalance in 'ipr_reset_reload' - unexpected unlock
+ drivers/scsi/ipr.c:4883:17: sparse: context imbalance in '__ipr_eh_dev_reset' - different lock contexts for basic block
+ drivers/scsi/ipr.c:6484:21: sparse: context imbalance in 'ipr_qc_issue' - different lock contexts for basic block

git remote add scsi git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
git remote update scsi
git checkout e7ef7307d9e2c15802e8ea1da9878e0550ec87bc
vim +/__ipr_eh_dev_reset +4883 drivers/scsi/ipr.c

^1da177e Linus Torvalds              2005-04-16  4867  
eeb88307 Brian King                  2005-11-01  4868  	if (!res)
^1da177e Linus Torvalds              2005-04-16  4869  		return FAILED;
^1da177e Linus Torvalds              2005-04-16  4870  
^1da177e Linus Torvalds              2005-04-16  4871  	/*
^1da177e Linus Torvalds              2005-04-16  4872  	 * If we are currently going through reset/reload, return failed. This will force the
^1da177e Linus Torvalds              2005-04-16  4873  	 * mid-layer to call ipr_eh_host_reset, which will then go to sleep and wait for the
^1da177e Linus Torvalds              2005-04-16  4874  	 * reset to complete
^1da177e Linus Torvalds              2005-04-16  4875  	 */
^1da177e Linus Torvalds              2005-04-16  4876  	if (ioa_cfg->in_reset_reload)
^1da177e Linus Torvalds              2005-04-16  4877  		return FAILED;
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  4878  	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead)
^1da177e Linus Torvalds              2005-04-16  4879  		return FAILED;
^1da177e Linus Torvalds              2005-04-16  4880  
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4881  	for_each_hrrq(hrrq, ioa_cfg) {
e7ef7307 wenxiong@linux.vnet.ibm.com 2012-12-03  4882  		spin_lock(&hrrq->_lock);
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03 @4883  		list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4884  			if (ipr_cmd->ioarcb.res_handle == res->res_handle) {
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4885  				if (ipr_cmd->scsi_cmd)
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4886  					ipr_cmd->done = ipr_scsi_eh_done;
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4887  				if (ipr_cmd->qc)
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4888  					ipr_cmd->done = ipr_sata_eh_done;
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4889  				if (ipr_cmd->qc &&
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4890  				    !(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  4891  					ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
_______________________________________________
kbuild mailing list
kbuild@lists.01.org
https://lists.01.org/mailman/listinfo/kbuild
