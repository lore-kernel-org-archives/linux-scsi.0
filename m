From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:for-next 72/72]
 drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26: sparse: incorrect type in
 initializer (different base types)
Date: Sat, 01 Dec 2012 20:49:23 +0800
Message-ID: <50b9fcd3.E/iBJ4v7zysB92u0%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6654 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab2LAMt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Dec 2012 07:49:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
head:   f92363d12359498f9a9960511de1a550f0ec41c2
commit: f92363d12359498f9a9960511de1a550f0ec41c2 [72/72] [SCSI] mpt3sas: add new driver supporting 12GB SAS


sparse warnings:

+ drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26: sparse: incorrect type in initializer (different base types)
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    expected unsigned long long [unsigned] [usertype] data_out
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    got restricted __le64 [usertype] <noident>
+ drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26: sparse: incorrect type in initializer (different base types)
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    expected unsigned long long [unsigned] [usertype] data_out
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    got restricted __le64 [usertype] <noident>
+ drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26: sparse: incorrect type in initializer (different base types)
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    expected unsigned long long [unsigned] [usertype] data_out
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    got restricted __le64 [usertype] <noident>
+ drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26: sparse: incorrect type in initializer (different base types)
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    expected unsigned long long [unsigned] [usertype] data_out
drivers/scsi/mpt3sas/mpt3sas_base.c:2099:26:    got restricted __le64 [usertype] <noident>
+ drivers/scsi/mpt3sas/mpt3sas_base.c:3236:24: sparse: incorrect type in argument 1 (different base types)
drivers/scsi/mpt3sas/mpt3sas_base.c:3236:24:    expected unsigned int [unsigned] val
drivers/scsi/mpt3sas/mpt3sas_base.c:3236:24:    got restricted __le32 [usertype] <noident>
+ drivers/scsi/mpt3sas/mpt3sas_base.c:3257:20: sparse: cast to restricted __le16
drivers/scsi/mpt3sas/mpt3sas_base.c:3266:20: sparse: cast to restricted __le16
drivers/scsi/mpt3sas/mpt3sas_base.c:3280:36: sparse: cast to restricted __le16
--
+ drivers/scsi/mpt3sas/mpt3sas_scsih.c:3456:61: sparse: incorrect type in assignment (different base types)
drivers/scsi/mpt3sas/mpt3sas_scsih.c:3456:61:    expected restricted __le32 [usertype] PrimaryReferenceTag
drivers/scsi/mpt3sas/mpt3sas_scsih.c:3456:61:    got restricted __be32 [usertype] <noident>

vim +2099 drivers/scsi/mpt3sas/mpt3sas_base.c

f92363d1 Sreekanth Reddy 2012-11-30  2083   *
f92363d1 Sreekanth Reddy 2012-11-30  2084   * Glue for handling an atomic 64 bit word to MMIO. This special handling takes
f92363d1 Sreekanth Reddy 2012-11-30  2085   * care of 32 bit environment where its not quarenteed to send the entire word
f92363d1 Sreekanth Reddy 2012-11-30  2086   * in one transfer.
f92363d1 Sreekanth Reddy 2012-11-30  2087   */
f92363d1 Sreekanth Reddy 2012-11-30  2088  #if defined(writeq) && defined(CONFIG_64BIT)
f92363d1 Sreekanth Reddy 2012-11-30  2089  static inline void
f92363d1 Sreekanth Reddy 2012-11-30  2090  _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
f92363d1 Sreekanth Reddy 2012-11-30  2091  {
f92363d1 Sreekanth Reddy 2012-11-30  2092  	writeq(cpu_to_le64(b), addr);
f92363d1 Sreekanth Reddy 2012-11-30  2093  }
f92363d1 Sreekanth Reddy 2012-11-30  2094  #else
f92363d1 Sreekanth Reddy 2012-11-30  2095  static inline void
f92363d1 Sreekanth Reddy 2012-11-30  2096  _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
f92363d1 Sreekanth Reddy 2012-11-30  2097  {
f92363d1 Sreekanth Reddy 2012-11-30  2098  	unsigned long flags;
f92363d1 Sreekanth Reddy 2012-11-30 @2099  	__u64 data_out = cpu_to_le64(b);
f92363d1 Sreekanth Reddy 2012-11-30  2100  
f92363d1 Sreekanth Reddy 2012-11-30  2101  	spin_lock_irqsave(writeq_lock, flags);
f92363d1 Sreekanth Reddy 2012-11-30  2102  	writel((u32)(data_out), addr);
f92363d1 Sreekanth Reddy 2012-11-30  2103  	writel((u32)(data_out >> 32), (addr + 4));
f92363d1 Sreekanth Reddy 2012-11-30  2104  	spin_unlock_irqrestore(writeq_lock, flags);
f92363d1 Sreekanth Reddy 2012-11-30  2105  }
f92363d1 Sreekanth Reddy 2012-11-30  2106  #endif
f92363d1 Sreekanth Reddy 2012-11-30  2107  

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
