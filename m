From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 02/17] scsi: ufs: add option to change default UFS
 power management level
Date: Mon, 26 Oct 2015 13:04:51 -0000
Message-ID: <ff21013c1095e7e3ad6d9282caea5025.squirrel@www.codeaurora.org>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
    <1442155977-7686-3-git-send-email-ygardi@codeaurora.org>
    <CAC5umygzaoA+Ja0Ji0UKzmKkcu5Q4W_R1xggefqtgaU2xxFJSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33243 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbbJZNE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 09:04:57 -0400
In-Reply-To: <CAC5umygzaoA+Ja0Ji0UKzmKkcu5Q4W_R1xggefqtgaU2xxFJSA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshv>

> 2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>> UFS device and link can be put in multiple different low power modes
>> hence UFS driver supports multiple different low power modes.
>> By default UFS driver selects the default (optimal) low power mode
>> (which gives moderate power savings and have relatively less enter
>> and exit latencies) but we might have to tune this default power
>> mode for different chipset platforms to meet the low power
>> requirements/goals. Hence this patch adds option to change default
>> UFS low power mode (level).
>>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ...
>
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 3196197..1d26e49 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -1195,11 +1195,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>>                 if (res) {
>>                         host->dev_ref_clk_ctrl_mmio =
>>                                         devm_ioremap_resource(dev, res);
>> -                       if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
>> -                               dev_warn(dev,
>> -                                       "%s: could not map
>> dev_ref_clk_ctrl_mmio, err %ld\n",
>> +                       if (IS_ERR((__force void const *)
>> +                                  host->dev_ref_clk_ctrl_mmio)) {
>> +                               dev_warn(dev, "%s: could not map
>> dev_ref_clk_ctrl_mmio, err %ld\n",
>>                                         __func__,
>> -
>> PTR_ERR(host->dev_ref_clk_ctrl_mmio));
>> +                                       PTR_ERR((__force void const *)
>> +
>> host->dev_ref_clk_ctrl_mmio));
>>                                 host->dev_ref_clk_ctrl_mmio = NULL;
>>                         }
>>                         host->dev_ref_clk_en_mask = BIT(5);
>
> This change looks unrelated.  Should this be belong to other patch?
>

correct, it's minor change,
but i will separate it to a different patch.



