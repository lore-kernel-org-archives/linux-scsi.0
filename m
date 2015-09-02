From: ygardi@codeaurora.org
Subject: Re: [PATCH v4 6/8] scsi: ufs: make the UFS variant a platform
 device
Date: Wed, 2 Sep 2015 08:18:09 -0000
Message-ID: <dd0c8afc696db852e57b7559eb6361df.squirrel@www.codeaurora.org>
References: <1440946354-16071-1-git-send-email-ygardi@codeaurora.org>
    <1440946354-16071-7-git-send-email-ygardi@codeaurora.org>
    <CAL_JsqJ2w3Czutb7vkT5Mt0Fs5jG_Lsm82-SD0Oe511X5-68Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53784 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbbIBISL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2015 04:18:11 -0400
In-Reply-To: <CAL_JsqJ2w3Czutb7vkT5Mt0Fs5jG_Lsm82-SD0Oe511X5-68Eg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, hch@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaur>

> On Sun, Aug 30, 2015 at 9:52 AM, Yaniv Gardi <ygardi@codeaurora.org>
> wrote:
>> This change turns the UFS variant (SCSI_UFS_QCOM) into a UFS
>> a platform device.
>> In order to do so a few additional changes are required:
>> 1. The ufshcd-pltfrm is no longer serves as a platform device.
>>    Now it only serves as a group of platform APIs such as PM APIs
>>    (runtime suspend/resume, system suspend/resume etc), parsers of
>>    clocks, regulators and pm_levels from DT.
>> 2. What used to be the old platform "probe" is now "only"
>>    a pltfrm_init() routine, that does exactly the same, but only
>>    being called by the new probe function of the UFS variant.
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  Documentation/devicetree/bindings/ufs/ufs-qcom.txt | 57 ++++++++++++++
>>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 +-
>
> For the binding:
>
> Reviewed-by: Rob Herring <robh@kernel.org>
>
> A comment on the driver part still.
>
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 329ac84..8027435 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>
> [...]
>
>> +static int ufs_qcom_probe(struct platform_device *pdev)
>> +{
>> +       int err;
>> +       struct device *dev = &pdev->dev;
>> +       struct ufs_hba *hba;
>> +
>> +       /* Perform generic probe */
>> +       err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
>> +       if (err) {
>> +               dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
>> +               goto out;
>> +       }
>> +
>> +       hba = platform_get_drvdata(pdev);
>
> I thought this was not necessary?

skipped my eye. i'm uploading another version without this redundant check

>
>> +       if (unlikely(!hba)) {
>> +               dev_err(dev, "no hba structure after successful
>> probing\n");
>> +               goto dealloc_host;
>> +       }
>> +
>> +       return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


