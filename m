From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V5 3/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Mon, 07 Jan 2013 13:11:42 +0530
Message-ID: <50EA7C36.8080807@codeaurora.org>
References: <50db5b12.644e420a.0ead.ffffbbac@mx.google.com> <50DC6224.7050109@codeaurora.org> <CAKVbJB-rT3qE41AO_vbG-YyKv+F9_FxO6njsVfe+bJkBpw0FoQ@mail.gmail.com> <50E9B638.8010602@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34766 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3AGHlr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2013 02:41:47 -0500
In-Reply-To: <50E9B638.8010602@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>, vinayak holikatti <vinholikatti@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, santoshsy@gmail.com

Hi Vinayak,

I have few comments below:


 >>>> +#ifdef CONFIG_PM
 >>>> +/**
 >>>> + * ufshcd_pltfrm_suspend - suspend power management function
 >>>> + * @pdev: pointer to Platform device handle
 >>>> + * @mesg: power state
 >>>> + *
 >>>> + * Returns -ENOSYS

What breaks if you return 0 instead of return -ENOSYS? Returning error 
seems to break platform suspend/resume until all the TODO's are 
addressed. If the current s/w cannot make h/w suspend, it should be okay 
to let the rest of the system be suspended.

 >>>> + */
 >>>> +static int ufshcd_pltfrm_suspend(struct platform_device *pdev,
 >>>> +                                pm_message_t mesg)
 >>>> +{
 >>>> +       /*
 >>>> +        * TODO:
 >>>> +        * 1. Call ufshcd_suspend
 >>>> +        * 2. Do bus specific power management
 >>>> +        */
 >>>> +
 >>>> +       return -ENOSYS;

Returning error doesn't allow entire system to be suspended. Perhaps, 
you can do disable_irq() and return 0?

 >>>> +}
 >>>> +
 >>>> +/**
 >>>> + * ufshcd_pltfrm_resume - resume power management function
 >>>> + * @pdev: pointer to Platform device handle
 >>>> + *
 >>>> + * Returns -ENOSYS
 >>>> + */
 >>>> +static int ufshcd_pltfrm_resume(struct platform_device *pdev)
 >>>> +{
 >>>> +       /*
 >>>> +        * TODO:
 >>>> +        * 1. Call ufshcd_resume.
 >>>> +        * 2. Do bus specific wake up
 >>>> +        */
 >>>> +
 >>>> +       return -ENOSYS;

enable_irq() and return 0?

 >>>> +}
 >>>> +#endif
 >>>> +

>>>> +static int __devexit ufshcd_pltfrm_remove(struct platform_device
>>>> *pdev)
>>>> +{
>>>> +       struct resource *mem_res;
>>>> +       struct resource *irq_res;
>>>> +       resource_size_t mem_size;
>>>> +       struct ufs_hba *hba =  platform_get_drvdata(pdev);
>>>> +
>>>> +       irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>> It would be better to save the irq number under "struct ufs_hba" during
>>> probe. So here during remove you just need simply need to call the
>>> "free_irq(irq_res->start, hba)"
>> Will modify the code accordingly in the next patchset.
>>>> +
>>>> +       if (!irq_res)
>>>> +               dev_err(&pdev->dev, "ufshcd: IRQ resource not
>>>> available\n");
>>>> +       else
>>>> +               free_irq(irq_res->start, hba);

The documentation of free_irq says:
"... On a shared IRQ the caller must ensure the interrupt is disabled on 
the card it drives before calling this function. .." I don't see 
disable_irq() getting called either here or ufshcd_remove().


>>>> +
>>>> +       ufshcd_remove(hba);
>>> Remove should be exactly opposite of probe(). So shouldn't you call the
>>> ufshcd_remove() first and then free_irq() after that.
>> Some bugging controllers might raise the interrupt after resources are
>> removed.
>> this sequence will prevent it.
>
> Could you please add the same as comment in above code sequence?
>
>>>> +       mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> You might want to save the pointer to mem_res in "struct ufs_hba" during
>>> probe and may use the same here.
>>>> +       if (!mem_res)
>>>> +               dev_err(&pdev->dev, "ufshcd: Memory resource not
>>>> available\n");
>>>> +       else {
>>>> +               mem_size = resource_size(mem_res);
>>>> +               release_mem_region(mem_res->start, mem_size);
>>>> +       }
>>>> +       platform_set_drvdata(pdev, NULL);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static const struct of_device_id ufs_of_match[] = {
>>>> +       { .compatible = "jedec,ufs-1.1"},
>>>> +};
>>>> +
>>>> +static struct platform_driver ufshcd_pltfrm_driver = {
>>>> +       .probe  = ufshcd_pltfrm_probe,
>>>> +       .remove = __devexit_p(ufshcd_pltfrm_remove),
>>>> +#ifdef CONFIG_PM

CONFIG_PM_SLEEP would be better? Also, can you move legacy 
suspend/resume callbacks below to dev_pm_ops?

>>>> +       .suspend = ufshcd_pltfrm_suspend,
>>>> +       .resume = ufshcd_pltfrm_resume,
>>>> +#endif
>>>> +       .driver = {
>>>> +               .name   = "ufshcd",
>>>> +               .owner  = THIS_MODULE,
>>>> +               .of_match_table = ufs_of_match,
>>>> +       },
>>>> +};

-- 
Regards,
Sujit Reddy Thumma

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
