From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/4] bfa: fix calls to
 dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 09:23:37 +0300
Message-ID: <20190218062337.GK2304@kadam>
References: <20190213114234.67275-4-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20190213114234.67275-4-hare@suse.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
To: kbuild@01.org
Cc: Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, kbuild-all@01.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/scsi-fixup-dma_set_mask_and_coherent-calls/20190214-044535
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next

smatch warnings:
drivers/scsi/bfa/bfad.c:805 bfad_pci_init() error: uninitialized symbol 'rc'.

# https://github.com/0day-ci/linux/commit/48d00fbe6a39ffd9e97f505206b4394efb9803bc
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 48d00fbe6a39ffd9e97f505206b4394efb9803bc
vim +/rc +805 drivers/scsi/bfa/bfad.c

7725ccfda Jing Huang        2009-09-23  726  
7725ccfda Jing Huang        2009-09-23  727  int
7725ccfda Jing Huang        2009-09-23  728  bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
7725ccfda Jing Huang        2009-09-23  729  {
48d00fbe6 Hannes Reinecke   2019-02-13  730  	int rc;
7725ccfda Jing Huang        2009-09-23  731  
7725ccfda Jing Huang        2009-09-23  732  	if (pci_enable_device(pdev)) {
a36c61f90 Krishna Gudipati  2010-09-15  733  		printk(KERN_ERR "pci_enable_device fail %p\n", pdev);
7725ccfda Jing Huang        2009-09-23  734  		goto out;
                                                        ^^^^^^^^^

7725ccfda Jing Huang        2009-09-23  735  	}
7725ccfda Jing Huang        2009-09-23  736  
7725ccfda Jing Huang        2009-09-23  737  	if (pci_request_regions(pdev, BFAD_DRIVER_NAME))
7725ccfda Jing Huang        2009-09-23  738  		goto out_disable_device;
                                                        ^^^^^^^^^^^^^^^^^^^^^^^^
7725ccfda Jing Huang        2009-09-23  739  
7725ccfda Jing Huang        2009-09-23  740  	pci_set_master(pdev);
7725ccfda Jing Huang        2009-09-23  741  
48d00fbe6 Hannes Reinecke   2019-02-13  742  	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
48d00fbe6 Hannes Reinecke   2019-02-13  743  	if (rc)
48d00fbe6 Hannes Reinecke   2019-02-13  744  		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
48d00fbe6 Hannes Reinecke   2019-02-13  745  
48d00fbe6 Hannes Reinecke   2019-02-13  746  	if (rc) {
a69b08002 Christoph Hellwig 2018-10-18  747  		printk(KERN_ERR "dma_set_mask_and_coherent fail %p\n", pdev);
7725ccfda Jing Huang        2009-09-23  748  		goto out_release_region;
7725ccfda Jing Huang        2009-09-23  749  	}
48d00fbe6 Hannes Reinecke   2019-02-13  750  	rc = -ENODEV;
7725ccfda Jing Huang        2009-09-23  751  
881c1b3c4 Krishna Gudipati  2012-08-22  752  	/* Enable PCIE Advanced Error Recovery (AER) if kernel supports */
881c1b3c4 Krishna Gudipati  2012-08-22  753  	pci_enable_pcie_error_reporting(pdev);
881c1b3c4 Krishna Gudipati  2012-08-22  754  
b3522f08e Jing Huang        2010-03-19  755  	bfad->pci_bar0_kva = pci_iomap(pdev, 0, pci_resource_len(pdev, 0));
111892082 Krishna Gudipati  2011-06-13  756  	bfad->pci_bar2_kva = pci_iomap(pdev, 2, pci_resource_len(pdev, 2));
7725ccfda Jing Huang        2009-09-23  757  
7725ccfda Jing Huang        2009-09-23  758  	if (bfad->pci_bar0_kva == NULL) {
a36c61f90 Krishna Gudipati  2010-09-15  759  		printk(KERN_ERR "Fail to map bar0\n");
7725ccfda Jing Huang        2009-09-23  760  		goto out_release_region;
7725ccfda Jing Huang        2009-09-23  761  	}
7725ccfda Jing Huang        2009-09-23  762  
7725ccfda Jing Huang        2009-09-23  763  	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
7725ccfda Jing Huang        2009-09-23  764  	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
7725ccfda Jing Huang        2009-09-23  765  	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
7725ccfda Jing Huang        2009-09-23  766  	bfad->hal_pcidev.device_id = pdev->device;
1a4d8e1bd Krishna Gudipati  2011-06-24  767  	bfad->hal_pcidev.ssid = pdev->subsystem_device;
7725ccfda Jing Huang        2009-09-23  768  	bfad->pci_name = pci_name(pdev);
7725ccfda Jing Huang        2009-09-23  769  
7725ccfda Jing Huang        2009-09-23  770  	bfad->pci_attr.vendor_id = pdev->vendor;
7725ccfda Jing Huang        2009-09-23  771  	bfad->pci_attr.device_id = pdev->device;
7725ccfda Jing Huang        2009-09-23  772  	bfad->pci_attr.ssid = pdev->subsystem_device;
7725ccfda Jing Huang        2009-09-23  773  	bfad->pci_attr.ssvid = pdev->subsystem_vendor;
7725ccfda Jing Huang        2009-09-23  774  	bfad->pci_attr.pcifn = PCI_FUNC(pdev->devfn);
7725ccfda Jing Huang        2009-09-23  775  
7725ccfda Jing Huang        2009-09-23  776  	bfad->pcidev = pdev;
a36c61f90 Krishna Gudipati  2010-09-15  777  
a36c61f90 Krishna Gudipati  2010-09-15  778  	/* Adjust PCIe Maximum Read Request Size */
c0102c00d Yijing Wang       2013-09-05  779  	if (pci_is_pcie(pdev) && pcie_max_read_reqsz) {
c0102c00d Yijing Wang       2013-09-05  780  		if (pcie_max_read_reqsz >= 128 &&
c0102c00d Yijing Wang       2013-09-05  781  		    pcie_max_read_reqsz <= 4096 &&
c0102c00d Yijing Wang       2013-09-05  782  		    is_power_of_2(pcie_max_read_reqsz)) {
c0102c00d Yijing Wang       2013-09-05  783  			int max_rq = pcie_get_readrq(pdev);
a36c61f90 Krishna Gudipati  2010-09-15  784  			printk(KERN_WARNING "BFA[%s]: "
a36c61f90 Krishna Gudipati  2010-09-15  785  				"pcie_max_read_request_size is %d, "
c0102c00d Yijing Wang       2013-09-05  786  				"reset to %d\n", bfad->pci_name, max_rq,
a36c61f90 Krishna Gudipati  2010-09-15  787  				pcie_max_read_reqsz);
c0102c00d Yijing Wang       2013-09-05  788  			pcie_set_readrq(pdev, pcie_max_read_reqsz);
c0102c00d Yijing Wang       2013-09-05  789  		} else {
c0102c00d Yijing Wang       2013-09-05  790  			printk(KERN_WARNING "BFA[%s]: invalid "
c0102c00d Yijing Wang       2013-09-05  791  			       "pcie_max_read_request_size %d ignored\n",
c0102c00d Yijing Wang       2013-09-05  792  			       bfad->pci_name, pcie_max_read_reqsz);
a36c61f90 Krishna Gudipati  2010-09-15  793  		}
a36c61f90 Krishna Gudipati  2010-09-15  794  	}
a36c61f90 Krishna Gudipati  2010-09-15  795  
881c1b3c4 Krishna Gudipati  2012-08-22  796  	pci_save_state(pdev);
881c1b3c4 Krishna Gudipati  2012-08-22  797  
7725ccfda Jing Huang        2009-09-23  798  	return 0;
7725ccfda Jing Huang        2009-09-23  799  
7725ccfda Jing Huang        2009-09-23  800  out_release_region:
7725ccfda Jing Huang        2009-09-23  801  	pci_release_regions(pdev);
7725ccfda Jing Huang        2009-09-23  802  out_disable_device:
7725ccfda Jing Huang        2009-09-23  803  	pci_disable_device(pdev);
7725ccfda Jing Huang        2009-09-23  804  out:
7725ccfda Jing Huang        2009-09-23 @805  	return rc;
7725ccfda Jing Huang        2009-09-23  806  }
7725ccfda Jing Huang        2009-09-23  807  

:::::: The code at line 805 was first introduced by commit
:::::: 7725ccfda59715ecf8f99e3b520a0b84cc2ea79e [SCSI] bfa: Brocade BFA FC SCSI driver

:::::: TO: Jing Huang <huangj@brocade.com>
:::::: CC: James Bottomley <James.Bottomley@suse.de>
