Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24297C4740A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 08:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6192206A5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 08:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfIJIaB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 04:30:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727058AbfIJIaB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Sep 2019 04:30:01 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6544BC9E30D7A0E935A2;
        Tue, 10 Sep 2019 16:29:59 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 10 Sep 2019
 16:29:51 +0800
Subject: Re: [RESEND PATCH] scsi: megaraid: disable device when probe failed
 after enabled device
To:     chenxiang <chenxiang66@hisilicon.com>, <martin.petersen@oracle.com>
References: <1567818450-173315-1-git-send-email-chenxiang66@hisilicon.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1a96bb50-3d6a-6280-c6a8-1dbf61c1b4b0@huawei.com>
Date:   Tue, 10 Sep 2019 09:29:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <1567818450-173315-1-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/09/2019 02:07, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> For pci device, need to disable device when probe failed after enabled
> device.
>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>  drivers/scsi/megaraid.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 45a6604..ff6d4aa 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -4183,11 +4183,11 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  		 */
>  		if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ &&
>  		    pdev->subsystem_device == 0xC000)
> -		   	return -ENODEV;
> +			goto out_disable_device;
>  		/* Now check the magic signature byte */
>  		pci_read_config_word(pdev, PCI_CONF_AMISIG, &magic);
>  		if (magic != HBA_SIGNATURE_471 && magic != HBA_SIGNATURE)
> -			return -ENODEV;
> +			goto out_disable_device;

It would be nicer if the driver didn't init the return code to -ENODEV 
and we set it explicitly here, but that's a different change.

>  		/* Ok it is probably a megaraid */
>  	}
>
>


