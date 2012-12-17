From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:for-next 23/27] drivers/scsi/fnic/fnic_scsi.c:183:35:
 sparse: invalid assignment: &=
Date: Mon, 17 Dec 2012 21:50:59 +0800
Message-ID: <50cf2343.OFwbZqu4+cv8MZmU%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2LQNvy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 08:51:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: linux-scsi@vger.kernel.org, Narsimhulu Musini <nmusini@cisco.com>, James Bottomley <JBottomley@Parallels.com>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
commit: 188061001ac78b40780af042dd2156e2213e29ed [23/27] [SCSI] fnic:fixing issues in device and firmware reset code


sparse warnings:

+ drivers/scsi/fnic/fnic_scsi.c:183:35: sparse: invalid assignment: &=
drivers/scsi/fnic/fnic_scsi.c:183:35:    left side has type restricted unsigned long long
drivers/scsi/fnic/fnic_scsi.c:183:35:    right side has type unsigned long long
drivers/scsi/fnic/fnic_scsi.c:185:35: sparse: invalid assignment: |=
drivers/scsi/fnic/fnic_scsi.c:185:35:    left side has type restricted unsigned long long
drivers/scsi/fnic/fnic_scsi.c:185:35:    right side has type unsigned long long

vim +183 drivers/scsi/fnic/fnic_scsi.c

5df6d737 Abhijeet Joglekar 2009-04-17  167  
18806100 Hiral Patel       2012-12-10  168  /**
18806100 Hiral Patel       2012-12-10  169   * __fnic_set_state_flags
18806100 Hiral Patel       2012-12-10  170   * Sets/Clears bits in fnic's state_flags
18806100 Hiral Patel       2012-12-10  171   **/
18806100 Hiral Patel       2012-12-10  172  void
18806100 Hiral Patel       2012-12-10  173  __fnic_set_state_flags(struct fnic *fnic, u64 st_flags, u64 clearbits)
18806100 Hiral Patel       2012-12-10  174  {
18806100 Hiral Patel       2012-12-10  175  	struct Scsi_Host *host = fnic->lport->host;
18806100 Hiral Patel       2012-12-10  176  	int sh_locked = spin_is_locked(host->host_lock);
18806100 Hiral Patel       2012-12-10  177  	unsigned long flags = 0;
18806100 Hiral Patel       2012-12-10  178  
18806100 Hiral Patel       2012-12-10  179  	if (!sh_locked)
18806100 Hiral Patel       2012-12-10  180  		spin_lock_irqsave(host->host_lock, flags);
18806100 Hiral Patel       2012-12-10  181  
18806100 Hiral Patel       2012-12-10  182  	if (clearbits)
18806100 Hiral Patel       2012-12-10 @183  		fnic->state_flags &= ~st_flags;
18806100 Hiral Patel       2012-12-10  184  	else
18806100 Hiral Patel       2012-12-10  185  		fnic->state_flags |= st_flags;
18806100 Hiral Patel       2012-12-10  186  
18806100 Hiral Patel       2012-12-10  187  	if (!sh_locked)
18806100 Hiral Patel       2012-12-10  188  		spin_unlock_irqrestore(host->host_lock, flags);
18806100 Hiral Patel       2012-12-10  189  
18806100 Hiral Patel       2012-12-10  190  	return;
18806100 Hiral Patel       2012-12-10  191  }

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
