From: ygardi@codeaurora.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Thu, 4 Jun 2015 20:42:58 -0000
Message-ID: <27c2bccc1e1824de1e930bfe0df6caf7.squirrel@www.codeaurora.org>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
    <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
    <1433426833.15728.15.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1433426833.15728.15.camel@x220>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> On Wed, 2015-06-03 at 12:37 +0300, Yaniv Gardi wrote:
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>
>>  EXPORT_SYMBOL(ufs_hba_qcom_vops);
>
> Nothing uses this export. It's still a (static) symbol that is not
> included in any header. I think this export serves no purpose. Am I
> missing something subtle here?
>

correct Paul. I will remove it.


>> +/**
>> + * ufs_qcom_probe - probe routine of the driver
>> + * @pdev: pointer to Platform device handle
>> + *
>> + * Always return 0
>> + */
>> +static int ufs_qcom_probe(struct platform_device *pdev)
>> +{
>> +	dev_set_drvdata(&pdev->dev, (void *)&ufs_hba_qcom_vops);
>
> (Cast to void * should not be needed.)
>
>> +	return 0;
>> +}
>> +
>> +/**
>> + * ufs_qcom_remove - set driver_data of the device to NULL
>> + * @pdev: pointer to platform device handle
>> + *
>> + * Always return 0
>> + */
>> +static int ufs_qcom_remove(struct platform_device *pdev)
>> +{
>> +	dev_set_drvdata(&pdev->dev, NULL);
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id ufs_qcom_of_match[] = {
>> +	{ .compatible = "qcom,ufs_variant"},
>> +	{},
>> +};
>> +
>> +static struct platform_driver ufs_qcom_pltform = {
>> +	.probe	= ufs_qcom_probe,
>> +	.remove	= ufs_qcom_remove,
>> +	.driver	= {
>> +		.name	= "ufs_qcom",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table = of_match_ptr(ufs_qcom_of_match),
>> +	},
>> +};
>> +module_platform_driver(ufs_qcom_pltform);
>
>> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
>> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
>
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct device_node *ufs_variant_node;
>> +	struct platform_device *ufs_variant_pdev;
>
>> -	hba->vops = get_variant_ops(&pdev->dev);
>> +	err = of_platform_populate(node, NULL, NULL, &pdev->dev);
>> +	if (err)
>> +		dev_err(&pdev->dev,
>> +			"%s: of_platform_populate() failed\n", __func__);
>> +
>> +	ufs_variant_node = of_get_next_available_child(node, NULL);
>> +
>> +	if (!ufs_variant_node) {
>> +		dev_dbg(&pdev->dev, "failed to find ufs_variant_node child\n");
>> +	} else {
>> +		ufs_variant_pdev = of_find_device_by_node(ufs_variant_node);
>> +
>> +		if (ufs_variant_pdev)
>> +			hba->vops = (struct ufs_hba_variant_ops *)
>> +				dev_get_drvdata(&ufs_variant_pdev->dev);
>
> (Another cast that I think is not needed.)
>
>> +	}
>
> If I scanned this correctly, the dev_set_drvdata() and dev_get_drvdata()
> pair adds an actual user of ufs_hba_qcom_vops. So that ends the obvious
> issue I think the code currently has. And I gladly defer to the scsi
> people to determine whether that is done the right way.
>

yes, you got it right.
these 2 routines use the vops structure, that binds the driver and the
variant (in our case qcom)

thanks for your time, Paul


> Thanks,
>
>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
