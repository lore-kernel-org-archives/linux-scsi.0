Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29F3C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9538F21655
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="akyIAGXs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgABMIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 07:08:05 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:39080 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgABMIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 07:08:05 -0500
Received: by mail-il1-f196.google.com with SMTP id x5so33917511ila.6
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2020 04:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g7pH+wCAXrenCI5q1aI4HvCFl/uq0JzfBZ1cYlHyv+8=;
        b=akyIAGXshAgMbfTi6Ej1Sol+7Jw4s5DnSPakAKgJPFqO93Of0Svo2Vux+DnIRh6hmz
         TYff+Q1VH4cOQjv0rxeAil7Qlv7rg1WfdQMNoNhGqhK5ImyUXUbVXhL450CBqpxL0Zg+
         Pf0IVEj0T0Bgn259ZEk84lXJPXM3EwMp5Zkw7NCrjMawwhuPHR4d9i7wE3BIcEKMutf1
         PoEChz0rOS91Og7/TRes1Teh74C0DnsYo8Ibj23v6TMlBlFKa5DmHejpRVrl8tkEv/ih
         MMH5OK3T/2orBPwxgaPI/e/iN0Pk66sZJ+0rE/70SmMtf7OFbScGUyHM148a9tL3Zj1E
         5LbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g7pH+wCAXrenCI5q1aI4HvCFl/uq0JzfBZ1cYlHyv+8=;
        b=GTv+tmq01vkNm9Gj8Q+y2MmvmuuZPS4AfjKvdhTNehjNnNyfrU70ZsFsdrh3w0xfc/
         /UGt6vBU04mqSqQ7eCLMmvADaTweTgsF8oSbdqwx6HUgfyl83gpAAWa7S0Y3t9pYgvLl
         LYaHqyyZAJQ2Rw5Fjnb/6DmN5W7EhlIlLylhlagoi3iFM7PC81rAUMpX/EwgNmiP5pfm
         pVVGp9a7sOnh96oXlucoupW0lhNq7+3Yqt/68KjVKfNuMbpDBGmQFdXFY3ruH5rJAGYK
         jGxjxNbExo7WFAFooycf/r9UILweImdGkp2VL7QXeuq6/xj+AVTBInvRbswI2eqDWOrK
         WZWw==
X-Gm-Message-State: APjAAAXG6w2k2Ynu0Kel8r8+mGH+i83JYJQJd5UuLOeNl5006+79dwaJ
        5t4b45p1BN2ptVL//GfoPOQiLUcaGGnr7J9i41VBfA==
X-Google-Smtp-Source: APXvYqxoLmKgTIyM0FAY7YHj+dP26qEvCEriv9wNmt4u+/Us4x9D6nlp3CwF6UttA8ZqCHFByxbOSQvxc6JYVlYVHKc=
X-Received: by 2002:a05:6e02:4d2:: with SMTP id f18mr67064981ils.54.1577966884231;
 Thu, 02 Jan 2020 04:08:04 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-7-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-7-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 2 Jan 2020 13:07:53 +0100
Message-ID: <CAMGffEkzAt4FrP2DbhZhGE20nFWPpuGkN83t7Tvw6+LsQg=m3Q@mail.gmail.com>
Subject: Re: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> Added sysfs attribute to show number of phys.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Yu Zheng <yuuzheng@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 69458b318a20..704c0daa7937 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -89,6 +89,25 @@ static ssize_t controller_fatal_error_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(controller_fatal_error);
>
> +/**
> + * pm8001_ctl_num_phys_show - Number of phys
> + * @cdev:pointer to embedded class device
> + * @buf:the buffer returned
> + * A sysfs 'read-only' shost attribute.
> + */
> +static ssize_t num_phys_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
please use pm8001_ctl_num_phys_show as function name, so it follows
same conversion as other functions.
Better also rename controller_fatal_error too.

Thanks
> +{
> +       int ret;
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +       ret = sprintf(buf, "%d", pm8001_ha->chip->n_phy);
> +       return ret;
> +}
> +static DEVICE_ATTR_RO(num_phys);
> +
>  /**
>   * pm8001_ctl_fw_version_show - firmware version
>   * @cdev: pointer to embedded class device
> @@ -825,6 +844,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> +       &dev_attr_num_phys,
>         &dev_attr_fw_version,
>         &dev_attr_update_fw,
>         &dev_attr_aap_log,
> --
> 2.16.3
>
