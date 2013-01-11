From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH V5 3/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Fri, 11 Jan 2013 18:00:38 +0530
Message-ID: <50F005EE.708@codeaurora.org>
References: <50db5b12.644e420a.0ead.ffffbbac@mx.google.com> <50DC6224.7050109@codeaurora.org> <CAKVbJB-rT3qE41AO_vbG-YyKv+F9_FxO6njsVfe+bJkBpw0FoQ@mail.gmail.com> <50E9B638.8010602@codeaurora.org> <50EA7C36.8080807@codeaurora.org> <CAKVbJB_wckWaS5Y0gjhFdxW-SvS3OwZqhyPhEfhwWuuZDzd_EQ@mail.gmail.com> <50EFEC48.3070800@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34850 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3AKMat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2013 07:30:49 -0500
In-Reply-To: <50EFEC48.3070800@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: vinayak holikatti <vinholikatti@gmail.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, santoshsy@gmail.com

On 1/11/2013 4:11 PM, Sujit Reddy Thumma wrote:
> On 1/9/2013 5:41 PM, vinayak holikatti wrote:
>> On Mon, Jan 7, 2013 at 1:11 PM, Sujit Reddy Thumma
>> <sthumma@codeaurora.org> wrote:
>>> Hi Vinayak,
>>>
>>> I have few comments below:
>>>
>>>
>>>>>>> +#ifdef CONFIG_PM
>>>>>>> +/**
>>>>>>> + * ufshcd_pltfrm_suspend - suspend power management function
>>>>>>> + * @pdev: pointer to Platform device handle
>>>>>>> + * @mesg: power state
>>>>>>> + *
>>>>>>> + * Returns -ENOSYS
>>>
>>> What breaks if you return 0 instead of return -ENOSYS? Returning 
>>> error seems
>>> to break platform suspend/resume until all the TODO's are addressed. 
>>> If the
>>> current s/w cannot make h/w suspend, it should be okay to let the 
>>> rest of
>>> the system be suspended.
>>>
>>
>> In that case how will the controller be in a working state once it 
>> resumes.
>> It does not make sense to return zero and to notify the OS that
>> everything is fine.
>
> Since the suspend routine doesn't do anything except returning zero, 
> no power/clocks would be removed and the controller should be in the 
> same state after resume. Do you see any system that removes 
> power/clocks to controllers during suspend without knowledge of 
> corresponding drivers? If so, then such systems must be fixed. In any 
> case, blocking entire system suspend just because s/w isn't taking 
> care of powering down one controller is not a good idea.
>
> I would like to hear from others on this as well.

Yes, i agree with Sujit that there is no point in blocking the entire 
system suspend just because ufshcd haven't implemented their suspend 
functionality. returning 0 from this function should be fine. And as 
Sujit already mentioned, if during resume you don't find the UFS 
(controller / phy) state as it was left in suspend then it's a 
particular system's issue and which needs to be fixed.

>
>>
>>>>>>> + */
>>>>>>> +static int ufshcd_pltfrm_suspend(struct platform_device *pdev,
>>>>>>> +                                pm_message_t mesg)
>>>>>>> +{
>>>>>>> +       /*
>>>>>>> +        * TODO:
>>>>>>> +        * 1. Call ufshcd_suspend
>>>>>>> +        * 2. Do bus specific power management
>>>>>>> +        */
>>>>>>> +
>>>>>>> +       return -ENOSYS;
>>>
>>> Returning error doesn't allow entire system to be suspended. 
>>> Perhaps, you
>>> can do disable_irq() and return 0?
>>>
>>>>>>> +}
>>>>>>> +
>>>>>>> +/**
>>>>>>> + * ufshcd_pltfrm_resume - resume power management function
>>>>>>> + * @pdev: pointer to Platform device handle
>>>>>>> + *
>>>>>>> + * Returns -ENOSYS
>>>>>>> + */
>>>>>>> +static int ufshcd_pltfrm_resume(struct platform_device *pdev)
>>>>>>> +{
>>>>>>> +       /*
>>>>>>> +        * TODO:
>>>>>>> +        * 1. Call ufshcd_resume.
>>>>>>> +        * 2. Do bus specific wake up
>>>>>>> +        */
>>>>>>> +
>>>>>>> +       return -ENOSYS;
>>>
>>> enable_irq() and return 0?
>>>
>>>>>>> +}
>>>>>>> +#endif
>>>>>>> +
>>>
>>>>>>> +static int __devexit ufshcd_pltfrm_remove(struct platform_device
>>>>>>> *pdev)
>>>>>>> +{
>>>>>>> +       struct resource *mem_res;
>>>>>>> +       struct resource *irq_res;
>>>>>>> +       resource_size_t mem_size;
>>>>>>> +       struct ufs_hba *hba = platform_get_drvdata(pdev);
>>>>>>> +
>>>>>>> +       irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>>>>>
>>>>>> It would be better to save the irq number under "struct ufs_hba" 
>>>>>> during
>>>>>> probe. So here during remove you just need simply need to call the
>>>>>> "free_irq(irq_res->start, hba)"
>>>>>
>>>>> Will modify the code accordingly in the next patchset.
>>>>>>>
>>>>>>> +
>>>>>>> +       if (!irq_res)
>>>>>>> +               dev_err(&pdev->dev, "ufshcd: IRQ resource not
>>>>>>> available\n");
>>>>>>> +       else
>>>>>>> +               free_irq(irq_res->start, hba);
>>>
>>>
>>> The documentation of free_irq says:
>>> "... On a shared IRQ the caller must ensure the interrupt is 
>>> disabled on the
>>> card it drives before calling this function. .." I don't see 
>>> disable_irq()
>>> getting called either here or ufshcd_remove().
>>
>> Why would you want to disable the entire IRQ line when it is shared?
>> Logical thing is to disable the interrupt on the controller.
>
> Since you have enabled the irq in ufshcd_init() and decremented the 
> desc->depth you need to need to do disable_irq(). disable_irq() 
> doesn't disable the irq line until all the shared irq drivers disables 
> it.
>
> Also, on some systems not calling disable_irq() could be a problem - 
> the power to wakeup irq monitor block couldn't be turned off if there 
> are active irqs.
>
>>
>>>
>>>
>>>>>>> +
>>>>>>> +       ufshcd_remove(hba);
>>>>>>
>>>>>> Remove should be exactly opposite of probe(). So shouldn't you 
>>>>>> call the
>>>>>> ufshcd_remove() first and then free_irq() after that.
>>>>>
>>>>> Some bugging controllers might raise the interrupt after resources 
>>>>> are
>>>>> removed.
>>>>> this sequence will prevent it.
>>>>
>>>>
>>>> Could you please add the same as comment in above code sequence?
>>>>
>>>>>>> +       mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>>>
>>>>>> You might want to save the pointer to mem_res in "struct ufs_hba" 
>>>>>> during
>>>>>> probe and may use the same here.
>>>>>>>
>>>>>>> +       if (!mem_res)
>>>>>>> +               dev_err(&pdev->dev, "ufshcd: Memory resource not
>>>>>>> available\n");
>>>>>>> +       else {
>>>>>>> +               mem_size = resource_size(mem_res);
>>>>>>> +               release_mem_region(mem_res->start, mem_size);
>>>>>>> +       }
>>>>>>> +       platform_set_drvdata(pdev, NULL);
>>>>>>> +       return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static const struct of_device_id ufs_of_match[] = {
>>>>>>> +       { .compatible = "jedec,ufs-1.1"},
>>>>>>> +};
>>>>>>> +
>>>>>>> +static struct platform_driver ufshcd_pltfrm_driver = {
>>>>>>> +       .probe  = ufshcd_pltfrm_probe,
>>>>>>> +       .remove = __devexit_p(ufshcd_pltfrm_remove),
>>>>>>> +#ifdef CONFIG_PM
>>>
>>>
>>> CONFIG_PM_SLEEP would be better?
>>
>> the current implementation looks fine.
>>
>>> Also, can you move legacy suspend/resume
>>
>> Ok,
>>
>>> callbacks below to dev_pm_ops?
>>>
>>>>>>> +       .suspend = ufshcd_pltfrm_suspend,
>>>>>>> +       .resume = ufshcd_pltfrm_resume,
>>>>>>> +#endif
>>>>>>> +       .driver = {
>>>>>>> +               .name   = "ufshcd",
>>>>>>> +               .owner  = THIS_MODULE,
>>>>>>> +               .of_match_table = ufs_of_match,
>>>>>>> +       },
>>>>>>> +};
>>>
>>>
>>> -- 
>>> Regards,
>>> Sujit Reddy Thumma
>>>
>>> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
>>> member
>>> of Code Aurora Forum, hosted by The Linux Foundation.
>>
>>
>>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

