From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 31/36] scsi: rescan VPD attributes
Date: Tue, 29 Sep 2015 21:38:20 +0800
Message-ID: <201509292135.In4qRnFk%fengguang.wu@intel.com>
References: <1443523658-87622-32-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12402 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828AbbI2NkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 09:40:18 -0400
Content-Disposition: inline
In-Reply-To: <1443523658-87622-32-git-send-email-hare@suse.de>
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

>> drivers/scsi/scsi_lib.c:3181:20: sparse: incompatible types in comparison expression (different address spaces)
   drivers/scsi/scsi_lib.c:3311:20: sparse: incompatible types in comparison expression (different address spaces)
--
   drivers/scsi/scsi_sysfs.c:202:25: sparse: symbol 'dev_attr_hstate' was not declared. Should it be static?
   drivers/scsi/scsi_sysfs.c:377:24: sparse: symbol 'scsi_shost_attr_group' was not declared. Should it be static?
>> drivers/scsi/scsi_sysfs.c:778:1: sparse: incompatible types in comparison expression (different address spaces)
   drivers/scsi/scsi_sysfs.c:779:1: sparse: incompatible types in comparison expression (different address spaces)
--
>> drivers/scsi/ses.c:564:20: sparse: incompatible types in comparison expression (different address spaces)

vim +3181 drivers/scsi/scsi_lib.c

  3165	 * Copies a unique device identification into @id based
  3166	 * on the information in the VPD page 0x83 of the device.
  3167	 * The string will be formatted as a SCSI name string.
  3168	 *
  3169	 * Returns the length of the identification or error on failure.
  3170	 * If the identifier is longer than the supplied buffer the actual
  3171	 * identifier length is returned and the buffer is not zero-padded.
  3172	 */
  3173	int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
  3174	{
  3175		u8 cur_id_type = 0xff;
  3176		u8 cur_id_size = 0;
  3177		unsigned char *d, *cur_id_str, *vpd_pg83;
  3178		int id_size = -EAGAIN;
  3179	
  3180		rcu_read_lock();
> 3181		vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
  3182		if (!vpd_pg83) {
  3183			rcu_read_unlock();
  3184			return -ENXIO;
  3185		}
  3186	
  3187		/*
  3188		 * Look for the correct descriptor.
  3189		 * Order of preference for lun descriptor:

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
