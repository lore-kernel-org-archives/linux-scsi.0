Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947E4C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 03:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67829206D5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 03:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YFfzJMw6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgFJDgj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 23:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgFJDgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 23:36:37 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7927DC05BD1E;
        Tue,  9 Jun 2020 20:36:36 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id s192so233476vkh.3;
        Tue, 09 Jun 2020 20:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rtx/ri9gwjpUSoBaV9ZRHZGtBga6dLCRzzoB3qYcsG8=;
        b=YFfzJMw6CEHy6iYS376b/KrMjw0qQOTW+nCJ4XkQpANdnQc9Ym8WsRlhboJMu9kVMV
         pe5Jt9hA5VvDDGhTfwtkIB6ueUbW1918gu26533cSKHOmpaxEw/QgIyCiDVwqRQURDGn
         oWg+OEAlrUYVVBjuK2lBEzN68QwZzGjLbZMyx7Vd7hPewbqk/HYa+2v+hk3nNBQIfmSm
         PqYVS5xGe2GotvVwmtLo/0juJbNbq71gQ/M+bK8hs28pZA0qOYnnuPFFC6h0qJW8XqMq
         pRNrlBY4HxtQOvjaZSYtJUUYTVwQHf2HOkrmm9wEwVnrKberVUPobmKkjcybi+a7q6hd
         uvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtx/ri9gwjpUSoBaV9ZRHZGtBga6dLCRzzoB3qYcsG8=;
        b=NZUCe1SteOWJgGKjkWwN5XXr5QV0Xkl/BjTp1Y1A8tS7zYqCvbccQ3AGbLOeC7qaha
         PLK+cfS3c5ZRF+mTgVN1gbdsWeADOswha6gKdydhtAUaqDKzb3vlt/e9/+tN82+jHZUt
         VWQK89bn8EcSvYBLf6xDJz37FbMnQ9gRAPm1DGnaU2piXptfXNeEmfYi3T8eEq6Reiv+
         A8+Ta0aYU4P70JVkLRpwOOXZEWm7G7cLycaRSDJO2o6QMbIMmwNR1P9ZLyjsGJ2rXo2O
         dZ1vsxdFsge9J4h5t0uRTgCRgNvL0aqpddZEvI51QDQfjgYP8q4UD2r+YYzd8hffrIiy
         bnMA==
X-Gm-Message-State: AOAM531SVqYLTlAXAF2NJ691iMyUQmTnswTCvs2x3OXE2Im8dZhMSGOX
        Mi1fECJMbXkG/HoydNhfITIcLMWQTGMmHkHXihg=
X-Google-Smtp-Source: ABdhPJxGHm16dEC5JJMhDXsdFVIDQUW2MIT15A11XgThFQis58lrynuF9GiRAHrOwsEGSqo0JTdqb83g1T7v1yBEhdo=
X-Received: by 2002:ac5:c94b:: with SMTP id s11mr932901vkm.8.1591760195582;
 Tue, 09 Jun 2020 20:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200604063559.18080-1-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20200604063559.18080-1-manivannan.sadhasivam@linaro.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 10 Jun 2020 09:05:59 +0530
Message-ID: <CAGOxZ505Zq=VDhG-S2h5yVRSqpUQmzYi=iYGTGgHAqZm0uOqRQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: Bump supported UFS HCI version to 3.0
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, amit.kucheria@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

HI Manivannan

On Thu, Jun 4, 2020 at 12:08 PM Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> UFS HCI 3.0 versions are being used in Qcom SM8250 based boards. Hence,
> adding it to the list of supported versions.
>
> I don't have the exact information of the additional registers supported
> in version 3.0. Hence the change just adds 0x300 to the list of supported
> versions to remove the below warning:
>
> "ufshcd-qcom 1d84000.ufshc: invalid UFS version 0x300"
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/scsi/ufs/ufshci.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index c2961d37cc1c..f2ee81669b00 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -104,6 +104,7 @@ enum {
>         UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
>         UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
>         UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
> +       UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */

See the current discussion on this https://lkml.org/lkml/2020/4/27/192

>  };
>
>  /*
> --
> 2.17.1
>


-- 
Regards,
Alim
