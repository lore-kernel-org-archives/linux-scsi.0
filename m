Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9374C47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80A6721D24
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Zx0TX2ub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbgJAMx6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731952AbgJAMx5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:53:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EFFC0613D0
        for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2020 05:53:55 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p9so7870376ejf.6
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2020 05:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=06zHlwXUngyRXgBFfhpGG+CXA5ZNckw9XHHn+j/oAwY=;
        b=Zx0TX2ubgW0Ri33jwwHz69y55RfQINo/RuZyr9Hk+HdKZb0iVhlr8tk98VCxjNy0+Q
         tGMBzczN1vRhX0GveBC6m3gw0DZDnPR0oRfF7IKiY5zolv1BZzW9NVtNp54YliUUB63W
         /kEowAEbvMsVIZlvF1o13OYjfTQkNWCWd2hcxKSzDO0X/vKIDaN9ZB2gvBx7MyQ7uDdd
         OuM0YHROAg2o7vc0wM6w5N1+ZMOdXSbkm+JeE6lbn9CPN4FVW8XAsv6IoIgwRneBc7K4
         elmlOllXsDmnt77Gee5TgFFkKTU9oy8UvXodbOVB/zzWw+Xm543jNb2vEkavsYrbq4LT
         OF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=06zHlwXUngyRXgBFfhpGG+CXA5ZNckw9XHHn+j/oAwY=;
        b=kmM2UQx1iNWkWuEZNKnP1sP2Io0hp+2/zPlP0G0r4JL38p8DRWGvW6BuanbDIWQ84Z
         to0fOHn1gQbL9PKMGoXxZhd9TBKK5d+gNT1PqPMO2i5f6DzstyQFMU6PTymuXFtVWiXV
         8OZODLS9uuhj7qIAlbPAfPyz+iMA0piO6Q/5hHwlwV9tsJG3e77n8pOLCCn8bWKhFhdp
         tx9hDwI/kQzkVNDa6YhoHS0mvhOtbnXnPX/QCAgikMEO9G5OwKzIaMpQvYJvxzOxcycu
         nsVRsRrCpbkUwpbIg1DuQ5uZASkGiKWOtzinLfRX7QR2HsB8poLrzGhY90OYe3Fu0foY
         +mww==
X-Gm-Message-State: AOAM531bV6c9rwSz6DNkfVGthnBfUXJNgmWuFlVr97DiBINsi2GtMWHy
        OTGcpQ5BxOS7my4grzdPfo4jt0v9lCZTdAQkpsr1Kw==
X-Google-Smtp-Source: ABdhPJy2jnDB4nsMZeAxrM672OuFou/ETnP5WUNusUY+Dpfx4FikpknL0KnWapBriVEdeq0glYyNiCavk6KtiEFRwlM=
X-Received: by 2002:a17:906:3397:: with SMTP id v23mr3190662eja.212.1601556834567;
 Thu, 01 Oct 2020 05:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com> <20201001122511.1075420-18-vaibhavgupta40@gmail.com>
In-Reply-To: <20201001122511.1075420-18-vaibhavgupta40@gmail.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 1 Oct 2020 14:53:43 +0200
Message-ID: <CAMGffEkF9ATZJ77FKTfP1g=iBLeVObco7nyQwLTjGu2pDehz-A@mail.gmail.com>
Subject: Re: [PATCH v3 17/28] scsi: pm_8001: Drop PCI Wakeup calls from .resume
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com, megaraidlinux.pdl@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 1, 2020 at 2:30 PM Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:
>
> The driver calls pci_enable_wake(...., false) in pm8001_pci_resume(), and
> there is no corresponding pci_enable_wake(...., true) in
> pm8001_pci_suspend(). Either it should do enable-wake the device in
> .suspend() or should not invoke pci_enable_wake() at all.
>
> Concluding that this driver doesn't support enable-wake and PCI core calls
> pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
> pm8001_pci__resume().
>
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Looks good to me!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>

Thanks!
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9e99262a2b9d..ee27ecb17560 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1248,7 +1248,6 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>                 "operating state [D%d]\n", pdev, pm8001_ha->name, device_state);
>
>         pci_set_power_state(pdev, PCI_D0);
> -       pci_enable_wake(pdev, PCI_D0, 0);
>         pci_restore_state(pdev);
>         rc = pci_enable_device(pdev);
>         if (rc) {
> --
> 2.28.0
>
