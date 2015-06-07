From: ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Sun, 7 Jun 2015 15:22:18 -0000
Message-ID: <9e35d6a7cdfd3d53510d41b0ff0a22fc.squirrel@www.codeaurora.org>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
    <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
    <1433426833.15728.15.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433426833.15728.15.camel@x220>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sahitya Tummala <stummala-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "open list:OPEN FIRMWARE AND..." <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Paul for the review and comments.
please see inline.



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

you are correct. it will be removed.

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

when removing the cast there is compilation error:
ufs-qcom.c: warning: passing argument 2 of =91dev_set_drvdata=92 discar=
ds
=91const=92 qualifier from pointer target type
error, forbidden warning: ufs-qcom.c


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
>> +static const struct of_device_id ufs_qcom_of_match[] =3D {
>> +	{ .compatible =3D "qcom,ufs_variant"},
>> +	{},
>> +};
>> +
>> +static struct platform_driver ufs_qcom_pltform =3D {
>> +	.probe	=3D ufs_qcom_probe,
>> +	.remove	=3D ufs_qcom_remove,
>> +	.driver	=3D {
>> +		.name	=3D "ufs_qcom",
>> +		.owner	=3D THIS_MODULE,
>> +		.of_match_table =3D of_match_ptr(ufs_qcom_of_match),
>> +	},
>> +};
>> +module_platform_driver(ufs_qcom_pltform);
>
>> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
>> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
>
>> +	struct device_node *node =3D pdev->dev.of_node;
>> +	struct device_node *ufs_variant_node;
>> +	struct platform_device *ufs_variant_pdev;
>
>> -	hba->vops =3D get_variant_ops(&pdev->dev);
>> +	err =3D of_platform_populate(node, NULL, NULL, &pdev->dev);
>> +	if (err)
>> +		dev_err(&pdev->dev,
>> +			"%s: of_platform_populate() failed\n", __func__);
>> +
>> +	ufs_variant_node =3D of_get_next_available_child(node, NULL);
>> +
>> +	if (!ufs_variant_node) {
>> +		dev_dbg(&pdev->dev, "failed to find ufs_variant_node child\n");
>> +	} else {
>> +		ufs_variant_pdev =3D of_find_device_by_node(ufs_variant_node);
>> +
>> +		if (ufs_variant_pdev)
>> +			hba->vops =3D (struct ufs_hba_variant_ops *)
>> +				dev_get_drvdata(&ufs_variant_pdev->dev);
>
> (Another cast that I think is not needed.)

here you are right - this one can be removed and will be
>
>> +	}
>
> If I scanned this correctly, the dev_set_drvdata() and dev_get_drvdat=
a()
> pair adds an actual user of ufs_hba_qcom_vops. So that ends the obvio=
us
> issue I think the code currently has. And I gladly defer to the scsi
> people to determine whether that is done the right way.
>
> Thanks,
>
>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
