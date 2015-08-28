From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:misc 97/113] drivers/scsi/mpt3sas/mpt3sas_scsih.c:5013:27:
 sparse: restricted __le16 degrades to integer
Date: Fri, 28 Aug 2015 09:34:13 +0800
Message-ID: <201508280911.tg302YkN%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27942 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbbH1Bff (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 21:35:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: kbuild-all@01.org, James Bottomley <JBottomley@Odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   b9e8a16466e62d46c0b8551fb807173d6a9c529f
commit: e6d45e3e7e6582fa206ef84631639ce70d50e5c5 [97/113] mpt3sas: Provides the physical location of sas drives
reproduce:
  # apt-get install sparse
  git checkout e6d45e3e7e6582fa206ef84631639ce70d50e5c5
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:5013:27: sparse: restricted __le16 degrades to integer
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:5015:25: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3524:61: sparse: incorrect type in assignment (different base types)
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3524:61:    expected restricted __le32 [usertype] PrimaryReferenceTag
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3524:61:    got restricted __be32 [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4888:35: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4891:33: sparse: cast to restricted __le16
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:6529:63: sparse: restricted __le64 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6530:60: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6554:43: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6557:36: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6565:65: sparse: restricted __le16 degrades to integer
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:6569:44: sparse: incorrect type in assignment (different base types)
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6569:44:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6569:44:    got restricted __le16 [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6571:62: sparse: incorrect type in assignment (different base types)
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6571:62:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6571:62:    got restricted __le16 [usertype] DevHandle
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:6611:51: sparse: incorrect type in assignment (different base types)
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6611:51:    expected restricted __le16 [addressable] [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6611:51:    got unsigned short [unsigned] [usertype] <noident>
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:6616:43: sparse: incorrect type in assignment (different base types)
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6616:43:    expected restricted __le64 [addressable] [usertype] SASAddress
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6616:43:    got unsigned long long [unsigned] [usertype] <noident>
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:6618:37: sparse: incorrect type in assignment (different base types)
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6618:37:    expected restricted __le16 [addressable] [usertype] Slot
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6618:37:    got unsigned short [unsigned] [usertype] <noident>

vim +5013 drivers/scsi/mpt3sas/mpt3sas_scsih.c

  5007		sas_device->device_info = device_info;
  5008		sas_device->sas_address = sas_address;
  5009		sas_device->phy = sas_device_pg0.PhyNum;
  5010		sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
  5011		    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
  5012	
> 5013		if (sas_device_pg0.Flags & MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
  5014			sas_device->enclosure_level =
> 5015				le16_to_cpu(sas_device_pg0.EnclosureLevel);
  5016			memcpy(&sas_device->connector_name[0],
  5017				&sas_device_pg0.ConnectorName[0], 4);
  5018		} else {

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
