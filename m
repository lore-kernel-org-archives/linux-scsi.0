Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9274CC5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F702217F4
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:49:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="CufScxpO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfKFKtt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:49:49 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33853 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfKFKts (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 05:49:48 -0500
Received: by mail-il1-f194.google.com with SMTP id p6so8643179ilp.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 02:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4CcG+LXXru/ecY1GlToQJDjMt5nzcelgowcr+T/0AnM=;
        b=CufScxpOx1Ec6S75ulZXGBbdnW1WvSAvTsXtITCv6uqz4FFIjuKHunwURkvXIP1Bma
         O6HBU5vIib9JZalXn1+dEYIquEwb8qOTuVPR4JmhToUfoA03f9vpIsgnWTv0uZB3xLP/
         X+k+n3hUDzXxPRIK8Ynkp0ZFyxwGLmbpvuvizYl3Tsf55yBGSNziGMWNBLEaUypepI2S
         rnZhsAAX1sommH0rkoTXIBv04c4LtQNtBnWLFve7FahjN6FfcWmb+S+Dfu/AHRMkFW66
         NpoZq4JoGXCPfBvBXdkyf7SQwKd3cvXDAMgP/J3yNnbZa4ItoKOBvcEJzgpFxC7I5byE
         6PDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4CcG+LXXru/ecY1GlToQJDjMt5nzcelgowcr+T/0AnM=;
        b=sHC5aW8QiF4JWXfPA4qPzrZPCXhmV6vw0JhVqLtLmAV2APZReZuRZGHB4fSq06VHmf
         /cyMgt4999T+qDJ0x17TdtB/Nb8o+wyyFlPQJyY8UVNmVRJMKl0n2U86NMRoTPaujZXC
         o1fujORpF8zrjKtigSxCvByr28VUSA6VDFHBLXM4CmGf2Je9n6p0vs7/Sp01rE3hV3ER
         xTZgIYFpMQxcHY1FyOexEYQSFKtD57F4PmeW4GWnW2KHtQmpxjOpzJclCVoxcX9WpSdI
         XWS7f1DglAis/ZAhpU0WpXLDfGR+0BXla3WO1Eyq6gFWEllgVyEMxc4oBh2NurCY41bf
         8qIA==
X-Gm-Message-State: APjAAAWMmFIVlOW5UZVkod7IoBxzTN6/Tb7XqsG/ylYo9xj/HyHOOkRV
        fjafHRuQ/gWB5bw1FSY+3Qc3h2DxQk2SiX4Zf+NfHg==
X-Google-Smtp-Source: APXvYqw5EqjVqm6QstbCEIMNCm5XPfFk/lGRGuxG8d2acqlGz7D3foP9TOCZpWTduV8HKDC2uHmDYeMl8hgyoobmWp4=
X-Received: by 2002:a92:d64d:: with SMTP id x13mr1865784ilp.54.1573037387892;
 Wed, 06 Nov 2019 02:49:47 -0800 (PST)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-11-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-11-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 6 Nov 2019 11:49:37 +0100
Message-ID: <CAMGffE=qMtx7m_9up1N9j0bGT+cjb0VOUwB2LD5z8=BMU_3MRA@mail.gmail.com>
Subject: Re: [PATCH 10/12] pm80xx : Controller fatal error through sysfs.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added support to check controller fatal error through sysfs.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 6b85016b4db3..fbdd0bf0e1ab 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -69,6 +69,25 @@ static ssize_t pm8001_ctl_mpi_interface_rev_show(struct device *cdev,
>  static
>  DEVICE_ATTR(interface_rev, S_IRUGO, pm8001_ctl_mpi_interface_rev_show, NULL);
>
> +/**
> + * pm8001_ctl_controller_fatal_err - check controller is under fatal err
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read only' shost attribute.
> + */
> +static ssize_t controller_fatal_error_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
The kernel-doc doesn't match the function name, please fix it.
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +       return snprintf(buf, PAGE_SIZE, "%d\n",
> +                       pm8001_ha->controller_fatal_error);
> +}
> +static DEVICE_ATTR_RO(controller_fatal_error);
> +
>  /**
>   * pm8001_ctl_fw_version_show - firmware version
>   * @cdev: pointer to embedded class device
> @@ -804,6 +823,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>         pm8001_show_update_fw, pm8001_store_update_fw);
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
> +       &dev_attr_controller_fatal_error,
>         &dev_attr_fw_version,
>         &dev_attr_update_fw,
>         &dev_attr_aap_log,
> --
> 2.16.3
>
With the updated kernel-doc.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
