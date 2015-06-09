From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Tue, 9 Jun 2015 05:53:03 -0000
Message-ID: <bfade46f9d953e10240acb835105b81d.squirrel@www.codeaurora.org>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
    <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
    <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
    <763dbc7b708b5d5b18ce0b5adcc41016.squirrel@www.codeaurora.org>
    <CAC5umyhWTLe_K+q9U=4M4N4Yu4Hp7hUxy4QiL=ch=JmYEiMBnQ@mail.gmail.com>
    <68c91f08f2be6c84055a303ca8aa3fe0.squirrel@www.codeaurora.org>
    <CAL_JsqKYqZyayzN3imi55EFP=ao4NTSgfXjP5J5rSxMAg4ZSMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqKYqZyayzN3imi55EFP=ao4NTSgfXjP5J5rSxMAg4ZSMA@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: ygardi@codeaurora.org, Akinobu Mita <akinobu.mita@gmail.com>, merez@qti.qualcomm.com, dovl@qti.qualcomm.com, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Paul Bolle <pebolle@tiscali.nl>, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>R
List-Id: linux-scsi@vger.kernel.org

> On Sun, Jun 7, 2015 at 10:32 AM,  <ygardi@codeaurora.org> wrote:
>>> 2015-06-05 5:53 GMT+09:00  <ygardi@codeaurora.org>:
>>>>> Hi Yaniv,
>>>>>
>>>>> 2015-06-03 18:37 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>>>>>> @@ -321,7 +313,22 @@ static int ufshcd_pltfrm_probe(struct
>>>>>> platform_device *pdev)
>>>>>>                 goto out;
>>>>>>         }
>>>>>>
>>>>>> -       hba->vops = get_variant_ops(&pdev->dev);
>>>>>> +       err = of_platform_populate(node, NULL, NULL, &pdev->dev);
>>>>>> +       if (err)
>>>>>> +               dev_err(&pdev->dev,
>>>>>> +                       "%s: of_platform_populate() failed\n",
>>>>>> __func__);
>>>>>> +
>>>>>> +       ufs_variant_node = of_get_next_available_child(node, NULL);
>>>>>> +
>>>>>> +       if (!ufs_variant_node) {
>>>>>> +               dev_dbg(&pdev->dev, "failed to find ufs_variant_node
>>>>>> child\n");
>>>>>> +       } else {
>>>>>> +               ufs_variant_pdev =
>>>>>> of_find_device_by_node(ufs_variant_node);
>>>>>> +
>>>>>> +               if (ufs_variant_pdev)
>>>>>> +                       hba->vops = (struct ufs_hba_variant_ops *)
>>>>>> +
>>>>>> dev_get_drvdata(&ufs_variant_pdev->dev);
>>>>>> +       }
>>>>>
>>>>> I have no strong objection to 'ufs_variant' sub-node.  But why can't
>>>>> we
>>>>> simply add an of_device_id to ufs_of_match, like below:
>>>>>
>>>>> static const struct of_device_id ufs_of_match[] = {
>>>>>         { .compatible = "jedec,ufs-1.1"},
>>>>> #if IS_ENABLED(SCSI_UFS_QCOM)
>>>>>         { .compatible = "qcom,ufs", .data = &ufs_hba_qcom_vops },
>>>>> #neidf
>>>>>         {},
>>>>> };
>>>>>
>>>>> and get hba->vops by get_variant_ops()?
>>>>>
>>>>
>>>> Hi Mita,
>>>> thanks for your comments.
>>>>
>>>> The whole idea, of having a sub-node which includes all variant
>>>> specific
>>>> attributes is to separate the UFS Platform device component, from the
>>>> need
>>>> to know "qcom" or any other future variant.
>>>> I believe it keeps the code more modular, and clean - meaning - no
>>>> #ifdef's and no need to include all variant attributes inside the
>>>> driver
>>>> DT node.
>>>> in that case, we simply have a DT node that is compatible to the Jdec
>>>> standard, and sub-node to include variant info.
>>>>
>>>> I hope you agree with this new design, since it provides a good answer
>>>> to every future variant that will be added, without the need to change
>>>> the
>>>> platform file.
>>>
>>> Thanks for your explanation, I agree with it.
>>>
>>> I found two problems in the current code, but both can be fixed
>>> relatively easily as described below:
>>>
>>> 1) If ufshcd-pltfrm driver is loaded before ufs-qcom driver,
>>> ufshcd_pltfrm_probe() can't find a ufs_variant device.
>>>
>>> In order to trigger re-probing ufs device when ufs-qcom driver has
>>> been loaded, ufshcd_pltfrm_probe() should return -EPROBE_DEFER in
>>> case 'ufs_variant' sub-node exists and no hba->vops found.
>>>
>>> 2) Nothing prevents ufs-qcom module from being unloaded while the
>>> variant_ops is referenced by ufshcd-pltfrm.
>>>
>>> It can be fixed by incrementing module refcount of ufs_variant module
>>> by __module_get(ufs_variant_pdev->dev.driver->owener) in
>>> ufshcd_pltfrm_probe(), and module_put() in ufshcd_pltfrm_remove()
>>> to descrement the refcount.
>>>
>>
>> again, Mita, your comments are very appreciated.
>>
>> 1)
>> If ufshcd-pltfrm driver is loaded before ufs-qcom, (what actually
>> happens
>> always), then the calling to of_platform_populate() which is added,
>> guarantees that ufs-qcom probe will be called and finish, before
>> ufshcd_pltfrm probe continues.
>> so ufs_variant device is always there, and ready.
>> I think it means we are safe - since either way, we make sure ufs-qcom
>> probe will be called and finish before dealing with ufs_variant device
>> in
>> ufshcd_pltfrm probe.
>
> This is due to the fact that you have 2 platform drivers. You should
> only have 1 (and 1 node). If you really think you need 2, then you
> should do like many other common *HCIs do and make the base UFS driver
> a set of library functions that drivers can use or call. Look at EHCI,
> AHCI, SDHCI, etc. for inspiration.

Hi Rob,
We did look at SDHCI and decided to go with this design due to its
simplicity and lack of library functions. Yaniv described the proper flow
of probing and, as we understand things, it is guaranteed to work as
designed.

Furthermore, the design of having a subcore in the dts is used in the
Linux kernel. Please have a look at drivers/usb/dwc3 where - as an example
- both dwc3-msm and dwc3-exynox invoke the probing function in core.c
(i.e. the shared underlying Synopsys USB dwc3 core) by calling
of_platform_populate().

Do you see a benefit in the SDHCi implementation?

>
> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
