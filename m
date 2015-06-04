From: ygardi@codeaurora.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Thu, 4 Jun 2015 20:53:16 -0000
Message-ID: <763dbc7b708b5d5b18ce0b5adcc41016.squirrel@www.codeaurora.org>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
    <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
    <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58480 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbbFDUxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2015 16:53:17 -0400
In-Reply-To: <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, merez@qti.qualcomm.com, dovl@qti.qualcomm.com
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Paul Bolle <pebolle@tiscali.nl>, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>Sahitya Tummala <s>

> Hi Yaniv,
>
> 2015-06-03 18:37 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>> @@ -321,7 +313,22 @@ static int ufshcd_pltfrm_probe(struct
>> platform_device *pdev)
>>                 goto out;
>>         }
>>
>> -       hba->vops = get_variant_ops(&pdev->dev);
>> +       err = of_platform_populate(node, NULL, NULL, &pdev->dev);
>> +       if (err)
>> +               dev_err(&pdev->dev,
>> +                       "%s: of_platform_populate() failed\n",
>> __func__);
>> +
>> +       ufs_variant_node = of_get_next_available_child(node, NULL);
>> +
>> +       if (!ufs_variant_node) {
>> +               dev_dbg(&pdev->dev, "failed to find ufs_variant_node
>> child\n");
>> +       } else {
>> +               ufs_variant_pdev =
>> of_find_device_by_node(ufs_variant_node);
>> +
>> +               if (ufs_variant_pdev)
>> +                       hba->vops = (struct ufs_hba_variant_ops *)
>> +                               dev_get_drvdata(&ufs_variant_pdev->dev);
>> +       }
>
> I have no strong objection to 'ufs_variant' sub-node.  But why can't we
> simply add an of_device_id to ufs_of_match, like below:
>
> static const struct of_device_id ufs_of_match[] = {
>         { .compatible = "jedec,ufs-1.1"},
> #if IS_ENABLED(SCSI_UFS_QCOM)
>         { .compatible = "qcom,ufs", .data = &ufs_hba_qcom_vops },
> #neidf
>         {},
> };
>
> and get hba->vops by get_variant_ops()?
>

Hi Mita,
thanks for your comments.

The whole idea, of having a sub-node which includes all variant specific
attributes is to separate the UFS Platform device component, from the need
to know "qcom" or any other future variant.
I believe it keeps the code more modular, and clean - meaning - no
#ifdef's and no need to include all variant attributes inside the driver
DT node.
in that case, we simply have a DT node that is compatible to the Jdec
standard, and sub-node to include variant info.

I hope you agree with this new design, since it provides a good answer
to every future variant that will be added, without the need to change the
platform file.

thanks for your time, Mita
please share your thoughts.

> There is something similar in
> drivers/net/ethernet/freescale/fsl_pq_mdio.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


