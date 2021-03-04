Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69C6C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B720B64F09
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhCDJxf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbhCDJx3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:53:29 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530CEC06175F
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:52:49 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mm21so47819083ejb.12
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yTv8ns99iDjsNYF6DJGXhF2BaQsgZOApT0z1Peuz2dM=;
        b=Olt3Fh0oAHXVbOPOyfZu3Fkf63T9Bzgd3CIQpPpECW9DIM3bVgp09fgRlgjy/VGncp
         M1O8ARLFKdgOCjwhXz3nJm1QqLbOiW9xQz7Hz/X8IjEW8e9EWQ+QqpH1aGsrLXg00Bwz
         eqEiRuC7fz5YoGjmXDKVpIQRdbvH8JposY7mFgmi2vqWtSlQprnzz0QTt06hqTjXtntZ
         6CC4qAB0Jk8HknkJYrRqXgHiha6iiq5OS2Xz8OH8atniceinZvvVrR2+6XSiIfZQWYtK
         tVjIluJENE73Ds6lGvYhXZ4QEkIt+Yzk/CL/7j3yJyIdJBeEUMf51S+Ccp1TpZzjCjRY
         Fegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yTv8ns99iDjsNYF6DJGXhF2BaQsgZOApT0z1Peuz2dM=;
        b=uBQFNutHhTcE/Tk981PdRInfrfHwem+fVfRcsn3Sq8fIZKkUdzBITly47Pv6XB4oP5
         M0XZkPT+Nkyn0Xe3mehmcnr6rkcBz/E8ICm2S9kKP1nKW1tZ5VxOCmckguM0NO1QMoNN
         e0ZGdZ3fxyWS0pb9QWPGTeDTvlSFVlRzdonDQXo6EhdvlVAA+2492+hHeWFZYQCCLg9I
         apQVov93PYbmUHF7F2iIyBGCVmq4HjqyEjdIpZK3fI8TxfE3VKDafv5cNwV0qj8vKAsB
         TcwiUQ9+NdJ/xCaCjipXkTouiGRXcBGIia0cUj/mI+H8w+B+6dHXHoH12VuujO97etcM
         odMw==
X-Gm-Message-State: AOAM530lnFj1VVI9kuL1FcTNTAcXsytMIMgBIxhb/Ho1JhhjQA+CjUXH
        VUCG/S8HJFM1+5NJ0yGVMYiUpTnxhHQDSJx4V7kHcva3Me2KWg==
X-Google-Smtp-Source: ABdhPJw9+UMEHt8R+CuVGe8UGeZKwjPXUG67gkw6+jSuXcXepDwqzaZg8BmKaTSe3lCLDc3HwcrYqCSkWpZss4Irzv4=
X-Received: by 2002:a17:906:cf90:: with SMTP id um16mr3302448ejb.389.1614851568111;
 Thu, 04 Mar 2021 01:52:48 -0800 (PST)
MIME-Version: 1.0
References: <20210303144631.3175331-1-lee.jones@linaro.org> <20210303144631.3175331-14-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-14-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:52:37 +0100
Message-ID: <CAMGffEkigSZ8TqM0Q5mi7Q6d7oU_+Bzzzp9S87jgjqOWMEqjaQ@mail.gmail.com>
Subject: Re: [PATCH 13/30] scsi: pm8001: pm8001_ctl: Fix incorrectly named
 functions in headers
To:     Lee Jones <lee.jones@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 3, 2021 at 3:47 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_ctl.c:313: warning: expecting prototype for pm8001_ctl_sas_address_show(). Prototype was for pm8001_ctl_host_sas_address_show() instead
>  drivers/scsi/pm8001/pm8001_ctl.c:530: warning: expecting prototype for pm8001_ctl_aap_log_show(). Prototype was for pm8001_ctl_iop_log_show() instead
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 12035baf0997b..1921e69bc2328 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -299,7 +299,7 @@ static DEVICE_ATTR(sas_spec_support, S_IRUGO,
>                    pm8001_ctl_sas_spec_support_show, NULL);
>
>  /**
> - * pm8001_ctl_sas_address_show - sas address
> + * pm8001_ctl_host_sas_address_show - sas address
>   * @cdev: pointer to embedded class device
>   * @attr: device attribute (unused)
>   * @buf: the buffer returned
> @@ -518,7 +518,7 @@ static ssize_t event_log_size_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(event_log_size);
>  /**
> - * pm8001_ctl_aap_log_show - IOP event log
> + * pm8001_ctl_iop_log_show - IOP event log
>   * @cdev: pointer to embedded class device
>   * @attr: device attribute (unused)
>   * @buf: the buffer returned
> --
> 2.27.0
>
