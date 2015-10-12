From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 15/25] scsi: hisi_sas: add cq interrupt handler
Date: Tue, 13 Oct 2015 06:15:37 +0800
Message-ID: <201510130638.ukcjn8Sr%fengguang.wu@intel.com>
References: <1444663237-238302-16-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31016 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbbJLWQ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 18:16:59 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-16-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Hi John,

[auto build test WARNING on scsi/for-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/John-Garry/HiSilicon-SAS-driver/20151012-231929
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:692:6: sparse: symbol 'enable_phy_v1_hw' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:973:36: sparse: cast from restricted __le32
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:973:36: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:973:36:    expected unsigned int [unsigned] [usertype] dma_err_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:973:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:981:33: sparse: cast from restricted __le32
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:981:33: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:981:33:    expected unsigned int [unsigned] [usertype] trans_tx_fail_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:981:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:983:33: sparse: cast from restricted __le32
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:983:33: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:983:33:    expected unsigned int [unsigned] [usertype] trans_rx_fail_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:983:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1079:5: sparse: symbol 'slot_complete_v1_hw' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1333:34: sparse: cast from restricted __le32
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1333:32: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1333:32:    expected unsigned int [unsigned] [usertype] cmplt_hdr_data
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1333:32:    got restricted __le32 [usertype] <noident>

vim +973 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c

   967		struct device *dev = &hisi_hba->pdev->dev;
   968	
   969		switch (task->task_proto) {
   970		case SAS_PROTOCOL_SSP:
   971		{
   972			int error = -1;
 > 973			u32 dma_err_type = cpu_to_le32(err_record->dma_err_type);
   974			u32 dma_tx_err_type = ((dma_err_type &
   975						ERR_HDR_DMA_TX_ERR_TYPE_MSK)) >>
   976						ERR_HDR_DMA_TX_ERR_TYPE_OFF;
   977			u32 dma_rx_err_type = ((dma_err_type &
   978						ERR_HDR_DMA_RX_ERR_TYPE_MSK)) >>
   979						ERR_HDR_DMA_RX_ERR_TYPE_OFF;
   980			u32 trans_tx_fail_type =
 > 981					cpu_to_le32(err_record->trans_tx_fail_type);
   982			u32 trans_rx_fail_type =
 > 983					cpu_to_le32(err_record->trans_rx_fail_type);
   984	
   985			if (dma_tx_err_type) {
   986				/* dma tx err */

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
