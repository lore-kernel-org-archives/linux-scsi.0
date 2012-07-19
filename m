From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH V2 3/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Thu, 19 Jul 2012 21:16:32 +0900
Message-ID: <CAKYAXd92fTRPpHHeNkH1bSZD1hAaU-Xm8wxjCUMHO21wX21vQA@mail.gmail.com>
References: <1342189698-20393-1-git-send-email-vinholikatti@gmail.com>
	<1342189698-20393-2-git-send-email-vinholikatti@gmail.com>
	<CAKYAXd9cPuN-HfifDmz4M==QfjEW7CX6BF=rumSBSwRtO38_PQ@mail.gmail.com>
	<CAKVbJB8PGZqOUOjDk-2uckx4MUkgKEb-EZ_TYt6C5fGjP2k85g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <CAKVbJB8PGZqOUOjDk-2uckx4MUkgKEb-EZ_TYt6C5fGjP2k85g@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: vinayak holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

2012/7/17 vinayak holikatti <vinholikatti@gmail.com>:
> On Mon, Jul 16, 2012 at 7:19 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> Hi Vinayak.
>>> + * ufshcd_pltfrm_remove - remove platform driver routine
>>> + * @pdev: pointer to platform device handle
>>> + *
>>> + * Returns 0 on success, non-zero value on failure
>>> + */
>>> +static int __devexit ufshcd_pltfrm_remove(struct platform_device *pdev)
>>> +{
>>> +     struct resource *mem_res;
>>> +     struct resource *irq_res;
>>> +     resource_size_t mem_size;
>>> +     struct ufs_hba *hba =  platform_get_drvdata(pdev);
>>> +
>>> +     ufshcd_remove(hba);
>>> +     irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>> +     if (!irq_res)
>>> +             dev_err(&pdev->dev, "ufshcd: IRQ resource not available\n");
>>> +     free_irq(irq_res->start, hba);
>> Is there no possibility of null pointer dereferencing error ?(irq_res->start)
>> I think that free_irq should be not called if irq_res is NULL.
> I agree, I have overlooked at this logic, the free_irq should have
> been in the else
> part of this section. I will make the modification in the next version
> of patches.
Okay.
You can add my
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
in these patchset

Thanks.
>>> +     mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> Looks mem_res is also same with upper case.
>> Thanks.
>>> +     mem_size = resource_size(mem_res);
>>> +     release_mem_region(mem_res->start, mem_size);
>>> +     platform_set_drvdata(pdev, NULL);
>>> +     return 0;
>>> +}
>>> +
