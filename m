Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0F3C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 22:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjKFWNf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 17:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbjKFWNe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 17:13:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E82ED73
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 14:13:31 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B2CC433C8;
        Mon,  6 Nov 2023 22:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699308811;
        bh=b6LBRNRyFfdKZwmzgybiv6QMAZBi3CH56y7IgwlvLu8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gxYbrHdsa7YUAvGVWhj13Z2dCfiESIjwNKX6WOTnV6KlWDgUuTIv/J8vcgNfVS3fq
         lnoIlvNln61j6Nb/ZVrZ5GdfdtDZ+D+e9CKjc3DJlscFJxO0qXP5HN032UJGpYSIL+
         fwA+GSf4TVr6iMMPwA42+22ZZqMEAfsk4NxHCaJZ4Gvlt4Q92fZPyWETqpdoJ1z93M
         CuVVVcfLEz5N0Y2BtiroF8+i+sGzjSkUONviRDDXTvD98Y65oF+0/CVl5HOInu6I3B
         18jDBBtKBqmLWoRFTuLzG6Z+Ng084VhObxF29GmsZWQ1K3ovDQ31v/9CnjgMuloYyd
         69GQdEUTNS+qQ==
Message-ID: <084d867e-62c1-4ab4-a152-7e2b99c86312@kernel.org>
Date:   Tue, 7 Nov 2023 07:13:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: mvsas: Try to enable MSI
To:     John Garry <john.g.garry@oracle.com>, Marek Vasut <marex@denx.de>,
        linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Yan <yanaijie@huawei.com>
References: <20231105183712.26520-1-marex@denx.de>
 <6f36e52c-e77c-0695-ff33-c4f737430c13@oracle.com>
 <9565b53d-68b4-464d-bbd6-290ec1fe66eb@denx.de>
 <c69856fa-8ff9-b35f-b644-319c0593de71@oracle.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <c69856fa-8ff9-b35f-b644-319c0593de71@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/6/23 23:12, John Garry wrote:
> On 06/11/2023 12:59, Marek Vasut wrote:
>>>> drivers/scsi/mvsas/mv_init.c | 17 +++++++++++++++++
>>>>   1 file changed, 17 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
>>>> index 43ebb331e2167..d3b1cee6b3252 100644
>>>> --- a/drivers/scsi/mvsas/mv_init.c
>>>> +++ b/drivers/scsi/mvsas/mv_init.c
>>>> @@ -571,6 +571,17 @@ static int mvs_pci_init(struct pci_dev *pdev, 
>>>> const struct pci_device_id *ent)
>>>>       rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>>>>       if (rc)
>>>>           goto err_out_shost;
>>>> +
>>>> +    /* Try to enable MSI, this is needed at least on OCZ RevoDrive 3 
>>>> X2 */
>>>> +    if (pdev->vendor == PCI_VENDOR_ID_OCZ) {
>>>
>>> PCI_VENDOR_ID_OCZ means 9485.
> 
> I meant chip_9485, not the PCI vendor ID. See how it is used as a lookup 
> to chip-specific parameters for multiple OCZ and MARVELL SoCs in 
> mvs_pci_table[] and mvs_chips[]
> 
>>
>> It does not, see:
>>
>> $ git grep PCI_VENDOR_ID_OCZ include/
>> include/linux/pci_ids.h:#define PCI_VENDOR_ID_OCZ               0x1b85
>>
>>> So how about enable MSI for all PCI device IDs which use that, which 
>>> is all OCZ and MARVELL_EXT? I could not get my hands on a datasheet 
>>> for that SoC (could you?), but since all previous generations 
>>> supported MSI, I think that it's a safe bet.
>>
>> Nope. I only have the one device here.
> 
> Checking whether the PCI vendor is PCI_VENDOR_ID_OCZ actually covers 
> many PCI devices, but they all use chip_9485
> 
>>
>>> Then, if we do that, instead of repeating this same vendor check, how 
>>> about add a new member to mvs_chip_info to flag whether we need to try 
>>> MSI? For example, it could be mvs_chip_info.use_msi .
>>>
>>>> +        rc = pci_enable_msi(mvi->pdev);
>>>> +        if (rc) {
>>>> +            dev_err(&mvi->pdev->dev,
>>>> +                "mvsas: Failed to enable MSI for OCZ device, 
>>>> attached drives may not be detected. rc=%d\n",
>>>> +                rc);
>>>
>>> We should fail to load the driver in this case.
>>
>> Wouldn't it be better to give the legacy IRQ a chance in any case, maybe 
>> those do work on some of the other OCZ devices (or other versions of 
>> firmware) ?
> 
> Then according to the change here, we would always call 
> pci_disable_msi() in removal path for OCZ, regardless of whether the 
> original pci_enable_msi() call was successful - is that safe and proper?

pci_disable_msi() does nothing if MSI is not enabled. So it shouldn't be an issue.

> 
> Thanks,
> John
> 
> 
> 

-- 
Damien Le Moal
Western Digital Research

