Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694ABC433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23FF76113A
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhDIGI1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDIGI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 02:08:27 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C1DC061760
        for <linux-scsi@vger.kernel.org>; Thu,  8 Apr 2021 23:08:14 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u21so6763907ejo.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Apr 2021 23:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKwXD8N1JHHBcf4wI9nAzA8eJamXKsw4F6yNcr3o4hA=;
        b=bVr769uTZK4fThAkfr8e8lrTPnJwtRsjFympwJ8co6ncLkEUZYYEQbvfhErkO2thlj
         98R+1RNbKeNAmbCfGEtUcd+QGKQKmkuRMKljSMlplhpx6hDxNKQrcbFdaMvSw//uZLyD
         AVAcWFP74H/hggcsU+yrFYmf1vdGFtvkkfm/ezhgS8MeSmRoCwdWshvXT7GcQo+efdFl
         MQssEnn/CgyPwvUsKSpNSFe+LZ3GKMyfgEpKD3AMPbyDkGjpmrvkyMVGCJfzdQp++3Tz
         RPAaAf2c9ie3MbXkS/4DDdu+53W7AG1PBYvktPQbtdYsR6RIpStb8V3e5RNxXT7ZF5X3
         Q2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKwXD8N1JHHBcf4wI9nAzA8eJamXKsw4F6yNcr3o4hA=;
        b=cvjyBY6NJdX0ik5PR86kommFqbfZrKHDC5Ytq9as2jnyisJU4awVTjy/JjP5QKVaQt
         Bcrk8UZTxIpf+kduoiCbLfD6PqIrl/5e9PsAYun7DXowVxsbLMF3LjtQAmNRYJslNPZ4
         HpxZSs7YppV4VaCxtpBFm9ny0YSls4hO0zLBuqkIipmS3sFegxyS7GseJbRodSth/CB6
         OdGqzEUULjNfvteR5die9QpaPTP7v8K+UfHTmOASwDahXfmxp4+0i6ueUflirhre9ReV
         DVYNq/uOd57o9npk8nNm6F5tNHhNs+KzNIqYVROmXgCy+C36k8rXe0U4Z7qjPsRGNpE7
         9GBQ==
X-Gm-Message-State: AOAM532xSooWEeuJ8ycEHLmT2ir4LTw3VuIOS2oJj1vAvYoKT1z4o+Nj
        cAUzG0Qa7BoOqfUHbwbEOqIpAwHVbgsIJW4Djb8+QA==
X-Google-Smtp-Source: ABdhPJwnkFmrR8dR4SnKVRk3onb9JUegkIADTZT7f1q0ZMFLoVRKdKDpcKYs/qyAxsXlZWagh/KGYdYuNR1vf9DfOdU=
X-Received: by 2002:a17:906:935a:: with SMTP id p26mr11084596ejw.521.1617948493461;
 Thu, 08 Apr 2021 23:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com> <1617886593-36421-3-git-send-email-luojiaxing@huawei.com>
In-Reply-To: <1617886593-36421-3-git-send-email-luojiaxing@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 9 Apr 2021 08:08:02 +0200
Message-ID: <CAMGffEkc-aYgLR_UWZGoT51hvHaAOG2T-9FK=1ttjWMKUaLJ_Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] scsi: pm8001: clean up for open brace
To:     Luo Jiaxing <luojiaxing@huawei.com>
Cc:     Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 8, 2021 at 2:56 PM Luo Jiaxing <luojiaxing@huawei.com> wrote:
>
> There are few error about open brace is reported by checkpatch.pl:
>
> ERROR: that open brace { should be on the previous line
> +static struct error_fw flash_error_table[] =
> +{
>
> So fix them all.
>
> Signed-off-by: Jianqin Xie <xiejianqin@hisilicon.com>
> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
looks good to me, thx!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 90b816f..8c253b0 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -645,8 +645,7 @@ struct flash_command {
>       int     code;
>  };
>
> -static struct flash_command flash_command_table[] =
> -{
> +static const struct flash_command flash_command_table[] = {
>       {"set_nvmd",    FLASH_CMD_SET_NVMD},
>       {"update",      FLASH_CMD_UPDATE},
>       {"",            FLASH_CMD_NONE} /* Last entry should be NULL. */
> @@ -657,8 +656,7 @@ struct error_fw {
>       int     err_code;
>  };
>
> -static struct error_fw flash_error_table[] =
> -{
> +static const struct error_fw flash_error_table[] = {
>       {"Failed to open fw image file",  FAIL_OPEN_BIOS_FILE},
>       {"image header mismatch",         FLASH_UPDATE_HDR_ERR},
>       {"image offset mismatch",         FLASH_UPDATE_OFFSET_ERR},
> --
> 2.7.4
>
