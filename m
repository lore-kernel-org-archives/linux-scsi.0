Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C5FC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 13:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjKFNgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjKFNgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 08:36:54 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BB9D8
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 05:36:50 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 34EB38704D;
        Mon,  6 Nov 2023 14:36:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1699277808;
        bh=XgDMncUSoy4s8DFUUpDMpA7qdh3DKzpvujuIQ7sJITw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=T04Ld67eQGuYSwOiPldbywkmVPFy5ehw+PNbRFxtnG2NlOfKFdAmBvuKoUehm3cd0
         2AvENLDD+dwntFI3OKkN2Fne1tj3uzjQ6rmtu2GA/E76XfZ5vRzW8qZTSthT1ji73c
         B/e8DAq8MESuOvpP5WHi4k/jwH5lPS4EUG3fKqtIHZr49JEhH1Y3fokC33QSsIKIOh
         ws5TSXfkdjSasMFMQB5G70ERvDZC8p709nLNWaYIya/La6bWurFto6DxzUL4iawdBd
         Qrk3nJx2naImJsSR3wHe5ZFaNQ6KaJrqUP9natYa69Ut2j/GdGsToJaNr8mzHMLuYR
         /7I9VjRTq/rwg==
Message-ID: <9565b53d-68b4-464d-bbd6-290ec1fe66eb@denx.de>
Date:   Mon, 6 Nov 2023 13:59:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: mvsas: Try to enable MSI
To:     John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>
References: <20231105183712.26520-1-marex@denx.de>
 <6f36e52c-e77c-0695-ff33-c4f737430c13@oracle.com>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <6f36e52c-e77c-0695-ff33-c4f737430c13@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/6/23 12:08, John Garry wrote:

Hi,

>>   drivers/scsi/mvsas/mv_init.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
>> index 43ebb331e2167..d3b1cee6b3252 100644
>> --- a/drivers/scsi/mvsas/mv_init.c
>> +++ b/drivers/scsi/mvsas/mv_init.c
>> @@ -571,6 +571,17 @@ static int mvs_pci_init(struct pci_dev *pdev, 
>> const struct pci_device_id *ent)
>>       rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>>       if (rc)
>>           goto err_out_shost;
>> +
>> +    /* Try to enable MSI, this is needed at least on OCZ RevoDrive 3 
>> X2 */
>> +    if (pdev->vendor == PCI_VENDOR_ID_OCZ) {
> 
> PCI_VENDOR_ID_OCZ means 9485.

It does not, see:

$ git grep PCI_VENDOR_ID_OCZ include/
include/linux/pci_ids.h:#define PCI_VENDOR_ID_OCZ               0x1b85

> So how about enable MSI for all PCI device 
> IDs which use that, which is all OCZ and MARVELL_EXT? I could not get my 
> hands on a datasheet for that SoC (could you?), but since all previous 
> generations supported MSI, I think that it's a safe bet.

Nope. I only have the one device here.

> Then, if we do that, instead of repeating this same vendor check, how 
> about add a new member to mvs_chip_info to flag whether we need to try 
> MSI? For example, it could be mvs_chip_info.use_msi .
> 
>> +        rc = pci_enable_msi(mvi->pdev);
>> +        if (rc) {
>> +            dev_err(&mvi->pdev->dev,
>> +                "mvsas: Failed to enable MSI for OCZ device, attached 
>> drives may not be detected. rc=%d\n",
>> +                rc);
> 
> We should fail to load the driver in this case.

Wouldn't it be better to give the legacy IRQ a chance in any case, maybe 
those do work on some of the other OCZ devices (or other versions of 
firmware) ?
