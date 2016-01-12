From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCHv2 13/22] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 13 Jan 2016 00:43:58 +0800
Message-ID: <201601130028.6tkMUAhz%fengguang.wu@intel.com>
References: <1452613258-94084-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:16410 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbcALQpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 11:45:03 -0500
Content-Disposition: inline
In-Reply-To: <1452613258-94084-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi Hannes,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20160112]
[cannot apply to v4.4]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/ALUA-device-handler-update-part-II/20160112-234244
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:228:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> drivers/scsi/device_handler/scsi_dh_alua.c:840:14: sparse: incompatible types in comparison expression (different address spaces)
   drivers/scsi/device_handler/scsi_dh_alua.c:884:14: sparse: incompatible types in comparison expression (different address spaces)
   drivers/scsi/device_handler/scsi_dh_alua.c:918:14: sparse: incompatible types in comparison expression (different address spaces)

vim +840 drivers/scsi/device_handler/scsi_dh_alua.c

   824		struct alua_dh_data *h = sdev->handler_data;
   825		struct alua_port_group *pg = NULL;
   826		unsigned int optimize = 0, argc;
   827		const char *p = params;
   828		int result = SCSI_DH_OK;
   829		unsigned long flags;
   830	
   831		if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
   832			return -EINVAL;
   833	
   834		while (*p++)
   835			;
   836		if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
   837			return -EINVAL;
   838	
   839		rcu_read_lock();
 > 840		pg = rcu_dereference(h->pg);
   841		if (!pg) {
   842			rcu_read_unlock();
   843			return -ENXIO;
   844		}
   845		spin_lock_irqsave(&pg->lock, flags);
   846		if (optimize)
   847			pg->flags |= ALUA_OPTIMIZE_STPG;
   848		else

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
