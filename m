From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 27/36] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 29 Sep 2015 21:27:20 +0800
Message-ID: <201509292148.9Blq2tHR%fengguang.wu@intel.com>
References: <1443523658-87622-28-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64208 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919AbbI2N2G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 09:28:06 -0400
Content-Disposition: inline
In-Reply-To: <1443523658-87622-28-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Hi Hannes,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
  # apt-get install sparse
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/device_handler/scsi_dh_alua.c:142:16: sparse: Variable length array is used.
   drivers/scsi/device_handler/scsi_dh_alua.c:171:16: sparse: Variable length array is used.
   drivers/scsi/device_handler/scsi_dh_alua.c:194:24: sparse: symbol 'alua_lookup_pg' was not declared. Should it be static?
   drivers/scsi/device_handler/scsi_dh_alua.c:222:24: sparse: symbol 'alua_get_pg' was not declared. Should it be static?
>> drivers/scsi/device_handler/scsi_dh_alua.c:856:14: sparse: incompatible types in comparison expression (different address spaces)
   drivers/scsi/device_handler/scsi_dh_alua.c:900:14: sparse: incompatible types in comparison expression (different address spaces)
   drivers/scsi/device_handler/scsi_dh_alua.c:935:14: sparse: incompatible types in comparison expression (different address spaces)

vim +856 drivers/scsi/device_handler/scsi_dh_alua.c

   840		struct alua_dh_data *h = sdev->handler_data;
   841		struct alua_port_group *pg = NULL;
   842		unsigned int optimize = 0, argc;
   843		const char *p = params;
   844		int result = SCSI_DH_OK;
   845		unsigned long flags;
   846	
   847		if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
   848			return -EINVAL;
   849	
   850		while (*p++)
   851			;
   852		if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
   853			return -EINVAL;
   854	
   855		rcu_read_lock();
 > 856		pg = rcu_dereference(h->pg);
   857		if (!pg) {
   858			rcu_read_unlock();
   859			return -ENXIO;
   860		}
   861		spin_lock_irqsave(&pg->lock, flags);
   862		if (optimize)
   863			pg->flags |= ALUA_OPTIMIZE_STPG;
   864		else

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
