From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Thu, 4 Jun 2015 23:32:16 +0900
Message-ID: <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
	<1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:35045 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbFDOcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2015 10:32:18 -0400
In-Reply-To: <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Paul Bolle <pebolle@tiscali.nl>, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vge>

Hi Yaniv,

2015-06-03 18:37 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> @@ -321,7 +313,22 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>                 goto out;
>         }
>
> -       hba->vops = get_variant_ops(&pdev->dev);
> +       err = of_platform_populate(node, NULL, NULL, &pdev->dev);
> +       if (err)
> +               dev_err(&pdev->dev,
> +                       "%s: of_platform_populate() failed\n", __func__);
> +
> +       ufs_variant_node = of_get_next_available_child(node, NULL);
> +
> +       if (!ufs_variant_node) {
> +               dev_dbg(&pdev->dev, "failed to find ufs_variant_node child\n");
> +       } else {
> +               ufs_variant_pdev = of_find_device_by_node(ufs_variant_node);
> +
> +               if (ufs_variant_pdev)
> +                       hba->vops = (struct ufs_hba_variant_ops *)
> +                               dev_get_drvdata(&ufs_variant_pdev->dev);
> +       }

I have no strong objection to 'ufs_variant' sub-node.  But why can't we
simply add an of_device_id to ufs_of_match, like below:

static const struct of_device_id ufs_of_match[] = {
        { .compatible = "jedec,ufs-1.1"},
#if IS_ENABLED(SCSI_UFS_QCOM)
        { .compatible = "qcom,ufs", .data = &ufs_hba_qcom_vops },
#neidf
        {},
};

and get hba->vops by get_variant_ops()?

There is something similar in
drivers/net/ethernet/freescale/fsl_pq_mdio.c
