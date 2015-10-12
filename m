From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 10/25] scsi: hisi_sas: add misc HBA initialization
Date: Tue, 13 Oct 2015 05:44:07 +0800
Message-ID: <201510130510.nnYDo5fI%fengguang.wu@intel.com>
References: <1444663237-238302-11-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbbJLVpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 17:45:03 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-11-git-send-email-john.garry@huawei.com>
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

   drivers/scsi/hisi_sas/hisi_sas_init.c:228:5: sparse: symbol 'hisi_sas_ioremap' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_init.c:318:47: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_init.c:318:47:    expected unsigned long long [unsigned] [usertype] dev_sas_addr
   drivers/scsi/hisi_sas/hisi_sas_init.c:318:47:    got restricted __be64 [usertype] <noident>

vim +318 drivers/scsi/hisi_sas/hisi_sas_init.c

307b867d John Garry 2015-10-12  222  				  hisi_hba->sata_breakpoint_dma);
ac2334d3 John Garry 2015-10-12  223  
ac2334d3 John Garry 2015-10-12  224  	if (hisi_hba->wq)
ac2334d3 John Garry 2015-10-12  225  		destroy_workqueue(hisi_hba->wq);
307b867d John Garry 2015-10-12  226  }
307b867d John Garry 2015-10-12  227  
2b5563f7 John Garry 2015-10-12 @228  int hisi_sas_ioremap(struct hisi_hba *hisi_hba)
2b5563f7 John Garry 2015-10-12  229  {
2b5563f7 John Garry 2015-10-12  230  	struct platform_device *pdev = hisi_hba->pdev;
2b5563f7 John Garry 2015-10-12  231  	struct device *dev = &pdev->dev;
2b5563f7 John Garry 2015-10-12  232  	struct resource *res;
2b5563f7 John Garry 2015-10-12  233  
2b5563f7 John Garry 2015-10-12  234  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
2b5563f7 John Garry 2015-10-12  235  	hisi_hba->regs = devm_ioremap(dev,
2b5563f7 John Garry 2015-10-12  236  				      res->start,
2b5563f7 John Garry 2015-10-12  237  				      resource_size(res));
2b5563f7 John Garry 2015-10-12  238  	if (!hisi_hba->regs)
2b5563f7 John Garry 2015-10-12  239  		return -ENOMEM;
2b5563f7 John Garry 2015-10-12  240  
2b5563f7 John Garry 2015-10-12  241  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
2b5563f7 John Garry 2015-10-12  242  	hisi_hba->ctrl_regs = devm_ioremap(dev,
2b5563f7 John Garry 2015-10-12  243  					   res->start,
2b5563f7 John Garry 2015-10-12  244  					   resource_size(res));
2b5563f7 John Garry 2015-10-12  245  	if (!hisi_hba->ctrl_regs)
2b5563f7 John Garry 2015-10-12  246  		return -ENOMEM;
2b5563f7 John Garry 2015-10-12  247  
2b5563f7 John Garry 2015-10-12  248  	return 0;
2b5563f7 John Garry 2015-10-12  249  }
28e5387c John Garry 2015-10-12  250  
28e5387c John Garry 2015-10-12  251  static const struct of_device_id sas_of_match[] = {
28e5387c John Garry 2015-10-12  252  	{ .compatible = "hisilicon,sas-controller-v1",},
28e5387c John Garry 2015-10-12  253  	{},
28e5387c John Garry 2015-10-12  254  };
28e5387c John Garry 2015-10-12  255  MODULE_DEVICE_TABLE(of, sas_of_match);
b94d2f2e John Garry 2015-10-12  256  
b94d2f2e John Garry 2015-10-12  257  static struct hisi_hba *hisi_sas_hba_alloc(
b94d2f2e John Garry 2015-10-12  258  			struct platform_device *pdev,
b94d2f2e John Garry 2015-10-12  259  			struct Scsi_Host *shost,
b94d2f2e John Garry 2015-10-12  260  			struct device_node *np)
b94d2f2e John Garry 2015-10-12  261  {
b94d2f2e John Garry 2015-10-12  262  	int interrupt_count, interrupt_cells;
b94d2f2e John Garry 2015-10-12  263  	struct hisi_hba *hisi_hba;
b94d2f2e John Garry 2015-10-12  264  
b94d2f2e John Garry 2015-10-12  265  	hisi_hba = devm_kzalloc(&pdev->dev, sizeof(*hisi_hba), GFP_KERNEL);
b94d2f2e John Garry 2015-10-12  266  	if (!hisi_hba)
b94d2f2e John Garry 2015-10-12  267  		goto err_out;
b94d2f2e John Garry 2015-10-12  268  
b94d2f2e John Garry 2015-10-12  269  	hisi_hba->pdev = pdev;
307b867d John Garry 2015-10-12  270  
ac2334d3 John Garry 2015-10-12  271  	init_timer(&hisi_hba->timer);
ac2334d3 John Garry 2015-10-12  272  
307b867d John Garry 2015-10-12  273  	if (of_property_read_u32(np, "phy-count", &hisi_hba->n_phy))
307b867d John Garry 2015-10-12  274  		goto err_out;
307b867d John Garry 2015-10-12  275  
307b867d John Garry 2015-10-12  276  	if (of_property_read_u32(np, "queue-count", &hisi_hba->queue_count))
307b867d John Garry 2015-10-12  277  		goto err_out;
307b867d John Garry 2015-10-12  278  
307b867d John Garry 2015-10-12  279  	if (of_property_read_u32(np, "controller-id", &hisi_hba->id))
307b867d John Garry 2015-10-12  280  		goto err_out;
307b867d John Garry 2015-10-12  281  
307b867d John Garry 2015-10-12  282  	interrupt_count = of_property_count_u32_elems(np, "interrupts");
307b867d John Garry 2015-10-12  283  	if (interrupt_count < 0)
307b867d John Garry 2015-10-12  284  		goto err_out;
307b867d John Garry 2015-10-12  285  
307b867d John Garry 2015-10-12  286  	if (of_property_read_u32(np, "#interrupt-cells", &interrupt_cells))
307b867d John Garry 2015-10-12  287  		goto err_out;
307b867d John Garry 2015-10-12  288  
307b867d John Garry 2015-10-12  289  	hisi_hba->int_names = devm_kcalloc(&pdev->dev,
307b867d John Garry 2015-10-12  290  					   interrupt_count / interrupt_cells,
307b867d John Garry 2015-10-12  291  					   HISI_SAS_NAME_LEN,
307b867d John Garry 2015-10-12  292  					   GFP_KERNEL);
307b867d John Garry 2015-10-12  293  	if (!hisi_hba->int_names)
307b867d John Garry 2015-10-12  294  		goto err_out;
307b867d John Garry 2015-10-12  295  
b94d2f2e John Garry 2015-10-12  296  	hisi_hba->shost = shost;
b94d2f2e John Garry 2015-10-12  297  
2b5563f7 John Garry 2015-10-12  298  	if (hisi_sas_ioremap(hisi_hba))
2b5563f7 John Garry 2015-10-12  299  		goto err_out;
2b5563f7 John Garry 2015-10-12  300  
307b867d John Garry 2015-10-12  301  	if (hisi_sas_alloc(hisi_hba, shost)) {
307b867d John Garry 2015-10-12  302  		hisi_sas_free(hisi_hba);
307b867d John Garry 2015-10-12  303  		goto err_out;
307b867d John Garry 2015-10-12  304  	}
307b867d John Garry 2015-10-12  305  
b94d2f2e John Garry 2015-10-12  306  	return hisi_hba;
b94d2f2e John Garry 2015-10-12  307  err_out:
b94d2f2e John Garry 2015-10-12  308  	dev_err(&pdev->dev, "hba alloc failed\n");
b94d2f2e John Garry 2015-10-12  309  	return NULL;
b94d2f2e John Garry 2015-10-12  310  }
b94d2f2e John Garry 2015-10-12  311  
f6486930 John Garry 2015-10-12  312  static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
f6486930 John Garry 2015-10-12  313  {
f6486930 John Garry 2015-10-12  314  	u8 i;
f6486930 John Garry 2015-10-12  315  
f6486930 John Garry 2015-10-12  316  	/* Huawei IEEE id (001882) */
f6486930 John Garry 2015-10-12  317  	for (i = 0; i < hisi_hba->n_phy; i++)
f6486930 John Garry 2015-10-12 @318  		hisi_hba->phy[i].dev_sas_addr =
f6486930 John Garry 2015-10-12  319  			cpu_to_be64(0x5001882016072015ULL);
f6486930 John Garry 2015-10-12  320  
f6486930 John Garry 2015-10-12  321  	memcpy(hisi_hba->sas_addr, &hisi_hba->phy[0].dev_sas_addr,

:::::: The code at line 318 was first introduced by commit
:::::: f6486930094e8da780099095ad77e86b3b766008 scsi: hisi_sas: add phy SAS ADDR initialization

:::::: TO: John Garry <john.garry@huawei.com>
:::::: CC: 0day robot <fengguang.wu@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
