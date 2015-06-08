From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Mon, 8 Jun 2015 09:51:59 -0500
Message-ID: <CAL_JsqJd-Gc-0T+za9UaerLupybwfjzsGKyVYOErngCw3zFvKw@mail.gmail.com>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
 <1433324255-27510-5-git-send-email-ygardi@codeaurora.org> <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jej B <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-msm <linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Santosh Y <santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sahitya Tummala <stummala@codeaurora.>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 4, 2015 at 9:32 AM, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Yaniv,
>
> 2015-06-03 18:37 GMT+09:00 Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>:
>> @@ -321,7 +313,22 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>>                 goto out;
>>         }
>>
>> -       hba->vops = get_variant_ops(&pdev->dev);
>> +       err = of_platform_populate(node, NULL, NULL, &pdev->dev);
>> +       if (err)
>> +               dev_err(&pdev->dev,
>> +                       "%s: of_platform_populate() failed\n", __func__);
>> +
>> +       ufs_variant_node = of_get_next_available_child(node, NULL);
>> +
>> +       if (!ufs_variant_node) {
>> +               dev_dbg(&pdev->dev, "failed to find ufs_variant_node child\n");
>> +       } else {
>> +               ufs_variant_pdev = of_find_device_by_node(ufs_variant_node);
>> +
>> +               if (ufs_variant_pdev)
>> +                       hba->vops = (struct ufs_hba_variant_ops *)
>> +                               dev_get_drvdata(&ufs_variant_pdev->dev);
>> +       }
>
> I have no strong objection to 'ufs_variant' sub-node.  But why can't we
> simply add an of_device_id to ufs_of_match, like below:

But I do have objections on both the naming and having a sub-node.

>
> static const struct of_device_id ufs_of_match[] = {
>         { .compatible = "jedec,ufs-1.1"},
> #if IS_ENABLED(SCSI_UFS_QCOM)
>         { .compatible = "qcom,ufs", .data = &ufs_hba_qcom_vops },

Be more specific: qcom,<socname>-ufs

> #neidf

Drop the ifdef.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
