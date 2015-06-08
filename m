From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Mon, 8 Jun 2015 23:51:45 +0900
Message-ID: <CAC5umyhBHh=Wu=yXwUz9HxCXyPFofzYBu2AmekqaU=o5VRYMZw@mail.gmail.com>
References: <1433694425-23478-1-git-send-email-ygardi@codeaurora.org>
	<1433694425-23478-5-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433694425-23478-5-git-send-email-ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Jej B <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Santosh Y <santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sahitya Tummala <stummala-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vge>
List-Id: linux-scsi@vger.kernel.org

2015-06-08 1:27 GMT+09:00 Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>:
>  static int ufshcd_pltfrm_remove(struct platform_device *pdev)
>  {
>         struct ufs_hba *hba =  platform_get_drvdata(pdev);
> +       struct device_node *node = pdev->dev.of_node;
> +       struct device_node *ufs_variant_node;
> +       struct platform_device *ufs_variant_pdev;
> +
> +       ufs_variant_node = of_get_next_available_child(node, NULL);
> +
> +       if (!ufs_variant_node)
> +               dev_dbg(&pdev->dev, "no ufs_variant_node found\n");
> +       else
> +               ufs_variant_pdev = of_find_device_by_node(ufs_variant_node);
>
>         pm_runtime_get_sync(&(pdev)->dev);
>         ufshcd_remove(hba);
> +       module_put(ufs_variant_pdev->dev.driver->owner);

module_put() should only be called when ufs_variant sub-node exists
and hba->vops was found.
If ufs->vops == NULL or no ufs_variant sub-node exists, this line
causes uninitialized pointer dereference.

>         return 0;
>  }
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
