From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH v2 3/9] aacraid: Added EEH support
Date: Tue, 15 Dec 2015 19:10:04 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1F149F@BBYEXM01.pmc-sierra.internal>
References: <1449773159-25058-4-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <201512130816.M5Va6y9e%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:45079 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbbLOTKH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 14:10:07 -0500
In-Reply-To: <201512130816.M5Va6y9e%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>

Hello All,

It looks like the build robot did not   merge the previous aacraid patches
which contained the functions aac_release_resources and aac_acquire_resources,
 before applying and building this set of patches.

As is evident from the commit messages here

https://github.com/0day-ci/linux/tree/master/drivers/scsi/aacraid

This kbuild test robot can be safely ignored.


Regards,
Raghava Aditya

> -----Original Message-----
> From: kbuild test robot [mailto:lkp@intel.com]
> Sent: Saturday, December 12, 2015 4:28 PM
> To: Raghava Aditya Renukunta
> Cc: kbuild-all@01.org; JBottomley@Parallels.com; linux-scsi@vger.kernel.org;
> Mahesh Rajashekhara; Murthy Bhat; Santosh Akula; Gana Sridaran;
> aacraid@pmc-sierra.com; Scott Benesh; Raghava Aditya Renukunta
> Subject: Re: [PATCH v2 3/9] aacraid: Added EEH support
> 
> Hi Raghava,
> 
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on v4.4-rc4 next-20151211]
> 
> url:    https://github.com/0day-ci/linux/commits/Raghava-Aditya-
> Renukunta/aacraid-Patchset-for-aacraid-driver-version-41052/20151211-
> 094405
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: x86_64-randconfig-r0-12130550 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/scsi/aacraid/linit.c: In function 'aac_pci_error_detected':
> >> drivers/scsi/aacraid/linit.c:1546:3: error: implicit declaration of function
> 'aac_release_resources' [-Werror=implicit-function-declaration]
>       aac_release_resources(aac);
>       ^
>    drivers/scsi/aacraid/linit.c: In function 'aac_pci_resume':
> >> drivers/scsi/aacraid/linit.c:1617:2: error: implicit declaration of function
> 'aac_acquire_resources' [-Werror=implicit-function-declaration]
>      aac_acquire_resources(aac);
>      ^
>    cc1: some warnings being treated as errors
> 
> vim +/aac_release_resources +1546 drivers/scsi/aacraid/linit.c
> 
>   1540
>   1541			aac->handle_pci_error = 1;
>   1542			aac->adapter_shutdown = 1;
>   1543
>   1544			scsi_block_requests(aac->scsi_host_ptr);
>   1545			aac_flush_ios(aac);
> > 1546			aac_release_resources(aac);
>   1547
>   1548			pci_disable_pcie_error_reporting(pdev);
>   1549			aac_adapter_ioremap(aac, 0);
>   1550
>   1551			return PCI_ERS_RESULT_NEED_RESET;
>   1552		case pci_channel_io_perm_failure:
>   1553			aac->handle_pci_error = 1;
>   1554			aac->adapter_shutdown = 1;
>   1555
>   1556			aac_flush_ios(aac);
>   1557			return PCI_ERS_RESULT_DISCONNECT;
>   1558		}
>   1559
>   1560		return PCI_ERS_RESULT_NEED_RESET;
>   1561	}
>   1562
>   1563	static pci_ers_result_t aac_pci_mmio_enabled(struct pci_dev *pdev)
>   1564	{
>   1565		dev_err(&pdev->dev, "aacraid: PCI error - mmio
> enabled\n");
>   1566		return PCI_ERS_RESULT_NEED_RESET;
>   1567	}
>   1568
>   1569	static pci_ers_result_t aac_pci_slot_reset(struct pci_dev *pdev)
>   1570	{
>   1571		dev_err(&pdev->dev, "aacraid: PCI error - slot reset\n");
>   1572		pci_restore_state(pdev);
>   1573		if (pci_enable_device(pdev)) {
>   1574			dev_warn(&pdev->dev,
>   1575				"aacraid: failed to enable slave\n");
>   1576			goto fail_device;
>   1577		}
>   1578
>   1579		pci_set_master(pdev);
>   1580
>   1581		if (pci_enable_device_mem(pdev)) {
>   1582			dev_err(&pdev->dev, "pci_enable_device_mem
> failed\n");
>   1583			goto fail_device;
>   1584		}
>   1585
>   1586		return PCI_ERS_RESULT_RECOVERED;
>   1587
>   1588	fail_device:
>   1589		dev_err(&pdev->dev, "aacraid: PCI error - slot reset
> failed\n");
>   1590		return PCI_ERS_RESULT_DISCONNECT;
>   1591	}
>   1592
>   1593
>   1594	static void aac_pci_resume(struct pci_dev *pdev)
>   1595	{
>   1596		struct Scsi_Host *shost = pci_get_drvdata(pdev);
>   1597		struct scsi_device *sdev = NULL;
>   1598		struct aac_dev *aac = (struct aac_dev *)shost_priv(shost);
>   1599
>   1600		pci_cleanup_aer_uncorrect_error_status(pdev);
>   1601
>   1602		if (aac_adapter_ioremap(aac, aac->base_size)) {
>   1603
>   1604			dev_err(&pdev->dev, "aacraid: ioremap failed\n");
>   1605			/* remap failed, go back ... */
>   1606			aac->comm_interface = AAC_COMM_PRODUCER;
>   1607			if (aac_adapter_ioremap(aac,
> AAC_MIN_FOOTPRINT_SIZE)) {
>   1608				dev_warn(&pdev->dev,
>   1609					"aacraid: unable to map adapter.\n");
>   1610
>   1611				return;
>   1612			}
>   1613		}
>   1614
>   1615		msleep(10000);
>   1616
> > 1617		aac_acquire_resources(aac);
>   1618
>   1619		/*
>   1620		 * reset this flag to unblock ioctl() as it was set
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
