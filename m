Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC231C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 06:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B152065F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 06:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgGTGQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 02:16:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48380 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbgGTGQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 02:16:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F053821341B1D8D5B252;
        Mon, 20 Jul 2020 14:16:53 +0800 (CST)
Received: from [127.0.0.1] (10.74.219.194) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 14:16:45 +0800
Subject: Re: [PATCH v1 07/15] scsi: hisi_sas_v3_hw: use generic power
 management
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        "Dick Kennedy" <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
References: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
 <20200717063438.175022-8-vaibhavgupta40@gmail.com>
CC:     Shuah Khan <skhan@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        <megaraidlinux.pdl@broadcom.com>,
        <MPT-FusionLinux.pdl@broadcom.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <367bd5d3-f0a6-2bd7-2945-3095c827dbe6@hisilicon.com>
Date:   Mon, 20 Jul 2020 14:16:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200717063438.175022-8-vaibhavgupta40@gmail.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.219.194]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Vaibhav,

ÔÚ 2020/7/17 14:34, Vaibhav Gupta Ð´µÀ:
> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states.
>
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
>
> The driver was calling pci_save/restore_state(), pci_choose_state(),
> pci_enable/disable_device() and pci_set_power_state() which is no more
> needed.
>
> Compile-tested only.
>
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Just a small comment, below.

> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 32 ++++++++------------------
>   1 file changed, 10 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 55e2321a65bc..45605a520bc8 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -3374,13 +3374,13 @@ enum {
>   	hip08,
>   };
>   
> -static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused hisi_sas_v3_suspend(struct device *dev_d)
>   {
> +	struct pci_dev *pdev = to_pci_dev(dev_d);
>   	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>   	struct hisi_hba *hisi_hba = sha->lldd_ha;
>   	struct device *dev = hisi_hba->dev;
>   	struct Scsi_Host *shost = hisi_hba->shost;
> -	pci_power_t device_state;
>   	int rc;
>   
>   	if (!pdev->pm_cap) {
> @@ -3406,21 +3406,15 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
>   
>   	hisi_sas_init_mem(hisi_hba);
>   
> -	device_state = pci_choose_state(pdev, state);
> -	dev_warn(dev, "entering operating state [D%d]\n",
> -			device_state);

Please retain above print to keep consistence with the print in function 
hisi_sas_v3_resume().

> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, device_state);
> -
>   	hisi_sas_release_tasks(hisi_hba);
>   
>   	sas_suspend_ha(sha);
>   	return 0;
>   }
>   
> -static int hisi_sas_v3_resume(struct pci_dev *pdev)
> +static int __maybe_unused hisi_sas_v3_resume(struct device *dev_d)
>   {
> +	struct pci_dev *pdev = to_pci_dev(dev_d);
>   	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>   	struct hisi_hba *hisi_hba = sha->lldd_ha;
>   	struct Scsi_Host *shost = hisi_hba->shost;
> @@ -3430,16 +3424,8 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
>   
>   	dev_warn(dev, "resuming from operating state [D%d]\n",
>   		 device_state);
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
> -	rc = pci_enable_device(pdev);
> -	if (rc) {
> -		dev_err(dev, "enable device failed during resume (%d)\n", rc);
> -		return rc;
> -	}
> +	device_wakeup_disable(dev_d);
>   
> -	pci_set_master(pdev);
>   	scsi_unblock_requests(shost);
>   	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
>   
> @@ -3447,7 +3433,6 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
>   	rc = hw_init_v3_hw(hisi_hba);
>   	if (rc) {
>   		scsi_remove_host(shost);
> -		pci_disable_device(pdev);
>   		return rc;
>   	}
>   	hisi_hba->hw->phys_init(hisi_hba);
> @@ -3468,13 +3453,16 @@ static const struct pci_error_handlers hisi_sas_err_handler = {
>   	.reset_done	= hisi_sas_reset_done_v3_hw,
>   };
>   
> +static SIMPLE_DEV_PM_OPS(hisi_sas_v3_pm_ops,
> +			 hisi_sas_v3_suspend,
> +			 hisi_sas_v3_resume);
> +
>   static struct pci_driver sas_v3_pci_driver = {
>   	.name		= DRV_NAME,
>   	.id_table	= sas_v3_pci_table,
>   	.probe		= hisi_sas_v3_probe,
>   	.remove		= hisi_sas_v3_remove,
> -	.suspend	= hisi_sas_v3_suspend,
> -	.resume		= hisi_sas_v3_resume,
> +	.driver.pm	= &hisi_sas_v3_pm_ops,
>   	.err_handler	= &hisi_sas_err_handler,
>   };
>   


