Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A58C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A21A661A1B
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhCYEsz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCYEsk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 00:48:40 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15D0C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:48:39 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ce10so784001ejb.6
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zkln0ljKOCViu52rMpS8lPufo15N3brziM6BRZQ15pE=;
        b=dtk72x9hBAqWtTceBHBVRH+Pem4eM3SEsIwSnkT72yzEbihd0KrkElXXh82xwW3h1/
         VpaeSCcfTC2H1DNV2z6wGH5UZTNUUCEkgjFOil5TYCVdCyutoZMmQ5CNXKvcgS639yUV
         A1ro5MovgiL+2sxTA+RkNtjnBNZAHnrfK549qN+H9QoAKrCSu7HuyaqraaweXdtkxGDN
         P1ZV5LMtoVzcLXoHacYym6crGJ0HY2s88wUaWm3QUh6lWc/4nIMBcj/dX6nQIGSHtIkm
         EN9VXL1HwPOMl9+lx2beGjggIPMgtyhGUX3wzwf7Z1mLszsZAbm32oQOQ9TG9UitnPZf
         njcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zkln0ljKOCViu52rMpS8lPufo15N3brziM6BRZQ15pE=;
        b=a2J/DYtfQFnIzgVicYXpnW4ENyvf+7VT4zwgR1pIaKDev2OJokSOVUGwSJFBs0mGV0
         ZbJvwaBhnP5RyK2evA6zDZL/Cn1foWmoVjR2wXl9EQLFMq4IqdAJLW0eAXeCgiK0Fvxn
         F7YoOSr+qLd6em7dPZnf/I773A1ITykqfBgLC2NfLtOlw2VQyCCwn0pfiDUOT+xxVHri
         MG4L07aPf/2qXzsRFS8GRH7CQPke9lzmNL2C6ZEghSaUvVa+uQ4tDJGWtpH4emcvXm3p
         mrp8vGSwjM5ukp0qzmmrG2B6CoqyaACOYHm857IhAHSSXwHS5ic8AveLYQeArqlvMYps
         G+Zw==
X-Gm-Message-State: AOAM53338kIlpALaYEOV6SVonvBx5Mfyg9ehFeBYUy1jM0DySOfbi2R4
        /9iW2VC68PZ4tXZCLStVixa6Vh5drYXd6DGnrUqpXGbIIcg=
X-Google-Smtp-Source: ABdhPJzjPUJW3g8Q8ZveMjIIJ/kQ2Xi5z4KUrAgThFieGTfdJMcjFS4q1VzEx9acm9XSTItWZ0ttmvEsMxVaINvZlV4=
X-Received: by 2002:a17:906:2504:: with SMTP id i4mr7356757ejb.115.1616647718308;
 Wed, 24 Mar 2021 21:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210324170357.9765-1-Viswas.G@microchip.com> <20210324170357.9765-4-Viswas.G@microchip.com>
In-Reply-To: <20210324170357.9765-4-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 25 Mar 2021 05:48:27 +0100
Message-ID: <CAMGffEmME8MPcLxN5hN-NuW=vb3D61hbcqocM3MCLx0mOP+Vdw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] pm80xx: Add sysfs attribute to track iop0 count
To:     Viswas G <Viswas.G@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        John Garry <john.garry@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 24, 2021 at 5:54 PM Viswas G <Viswas.G@microchip.com> wrote:
>
> From: Vishakha Channapattan <vishakhavc@google.com>
>
> A new sysfs variable 'ctl_iop0_count' is being introduced that tells if
> the controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing that indicates that controller is not
> dead.
>
> Tested: Using 'ctl_iop0_count' sysfs variable we can see ticks
> incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/ctl_iop0_count
> 0x000000a3
> 0x000001db
> 0x000001e4
> 0x000001e7
>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Looks you've addressed comments from me and John, thx!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 98e5b47b9bb7..b8170da49112 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -941,6 +941,29 @@ static ssize_t ctl_raae_count_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(ctl_raae_count);
>
> +/**
> + * ctl_iop0_count_show - controller iop0 count check
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +
> +static ssize_t ctl_iop0_count_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int iop0cnt;
> +       int c;
> +
> +       iop0cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 16);
> +       c = sysfs_emit(buf, "0x%08x\n", iop0cnt);
> +       return c;
> +}
> +static DEVICE_ATTR_RO(ctl_iop0_count);
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -966,6 +989,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_inc_fw_ver,
>         &dev_attr_ctl_mpi_state,
>         &dev_attr_ctl_raae_count,
> +       &dev_attr_ctl_iop0_count,
>         NULL,
>  };
>
> --
> 2.16.3
>
