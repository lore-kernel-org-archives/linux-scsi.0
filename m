Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0716C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 06:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhKXGLp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 01:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhKXGLp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 01:11:45 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924FDC061574
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 22:08:35 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so5167439eda.12
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 22:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ujRKFX4PIJvnclF/OPPhkXaFhG9Mw/UagvepGlC2Pog=;
        b=Ll/Xp/lCc6Y7OG6aoSVqeTPn5ibbyYKh6LcX2V/aJX9sUavPZ+Sv70HEEeCmD0RLsS
         Y8rNwU0+lrholo5cW+E1C7ZtmiKbEsKh3UvkxmAKAQbFjzWb+qrybqdDn6iYv40sTD1e
         o9O8acUm0ofVdo5Krs6jejENl5VFruUippASmSZvprqVWkgPjOKBtuoEb3/rx/FWA7Qx
         sJHCTXCW/3I0VxAcIxzRMcRpE5qyycEtQ+1iRPjE6JjOVXJW7i/UEXQX9pr4OWDZx8Hn
         9iI+SZWhVa0uomeNqXqoehNwJsjzQQPDxxCkgSEl1l2O3XhOiLlODNhSaDsNd8AZwK70
         AV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ujRKFX4PIJvnclF/OPPhkXaFhG9Mw/UagvepGlC2Pog=;
        b=33h+i7ZbPmHLFC5TOJYweRfBMkWKc092WcbM6FqhA9gddnLk7XAJ0xtTQz3yvKjdN2
         MLFUUItr5phEo7r7f+C5bZuYDKeaVxho6um8IL6xZ1EdDZxi1ZTuNWJxuTiA/92P0NjT
         IznxN7tNO1QrCprsCOLg8biGaA/yAnKVOrIv4dt4N4UET7be9ixbXgXnXaOYE5jJT/rA
         OyJ6IFNolqexxNn/jMnB8k+4QNIEHnOV/0iyncJTc8bhPd7xpYQQSMSb4QufuSJ1noIj
         +okXH0szkLAwcN0VXYB+nGAs5LsXAck4a258BfQ531jGG1Ma9Q3gNs9ve0gUkbK89rT2
         qTvg==
X-Gm-Message-State: AOAM530Nt7kaIuDQAxal7jLSFi27jZ1oSiT8HO4xRafJhlHYW82Gv+6j
        AqHlm9f4w4nlfr7bHS4s8anNcvUNlmMYoBtJcROGWw==
X-Google-Smtp-Source: ABdhPJwTLhN/Lnn9FeT8LuDtEdOM8fV7sCnVbAq14AkrDWsBdmhnCEq+upBOFS+i49Z6XHihd3vteiXO3T11i8+0o2g=
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr16716295ejc.507.1637734114075;
 Tue, 23 Nov 2021 22:08:34 -0800 (PST)
MIME-Version: 1.0
References: <20211124005217.2300458-1-bvanassche@acm.org> <20211124005217.2300458-12-bvanassche@acm.org>
In-Reply-To: <20211124005217.2300458-12-bvanassche@acm.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 24 Nov 2021 07:08:23 +0100
Message-ID: <CAMGffE=+zdRykynKMn+N525e_He-hOVOvTx5aNX_PWiZj=NYPA@mail.gmail.com>
Subject: Re: [PATCH 11/13] scsi: pm8001: Fix kernel-doc warnings
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        kernel test robot <lkp@intel.com>,
        Radha Ramachandran <radha@google.com>,
        Viswas G <Viswas.G@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 24, 2021 at 1:52 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Fix the following kernel-doc warnings:
>
> drivers/scsi/pm8001/pm8001_ctl.c:900: warning: cannot understand function prototype: 'const char *const mpiStateText[] = '
> drivers/scsi/pm8001/pm8001_ctl.c:930: warning: Function parameter or member 'attr' not described in 'ctl_hmi_error_show'
> drivers/scsi/pm8001/pm8001_ctl.c:951: warning: Function parameter or member 'attr' not described in 'ctl_raae_count_show'
> drivers/scsi/pm8001/pm8001_ctl.c:972: warning: Function parameter or member 'attr' not described in 'ctl_iop0_count_show'
> drivers/scsi/pm8001/pm8001_ctl.c:993: warning: Function parameter or member 'attr' not described in 'ctl_iop1_count_show'
>
> Fixes: 4ddbea1b6f51 ("scsi: pm80xx: Add sysfs attribute to check MPI state")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
looks good to me, thx!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 397eb9f6a1dd..41a63c9b719b 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -889,14 +889,6 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
>  static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>         pm8001_show_update_fw, pm8001_store_update_fw);
>
> -/**
> - * ctl_mpi_state_show - controller MPI state check
> - * @cdev: pointer to embedded class device
> - * @buf: the buffer returned
> - *
> - * A sysfs 'read-only' shost attribute.
> - */
> -
>  static const char *const mpiStateText[] = {
>         "MPI is not initialized",
>         "MPI is successfully initialized",
> @@ -904,6 +896,14 @@ static const char *const mpiStateText[] = {
>         "MPI initialization failed with error in [31:16]"
>  };
>
> +/**
> + * ctl_mpi_state_show - controller MPI state check
> + * @cdev: pointer to embedded class device
> + * @attr: device attribute (unused)
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
>  static ssize_t ctl_mpi_state_show(struct device *cdev,
>                 struct device_attribute *attr, char *buf)
>  {
> @@ -920,11 +920,11 @@ static DEVICE_ATTR_RO(ctl_mpi_state);
>  /**
>   * ctl_hmi_error_show - controller MPI initialization fails
>   * @cdev: pointer to embedded class device
> + * @attr: device attribute (unused)
>   * @buf: the buffer returned
>   *
>   * A sysfs 'read-only' shost attribute.
>   */
> -
>  static ssize_t ctl_hmi_error_show(struct device *cdev,
>                 struct device_attribute *attr, char *buf)
>  {
> @@ -941,11 +941,11 @@ static DEVICE_ATTR_RO(ctl_hmi_error);
>  /**
>   * ctl_raae_count_show - controller raae count check
>   * @cdev: pointer to embedded class device
> + * @attr: device attribute (unused)
>   * @buf: the buffer returned
>   *
>   * A sysfs 'read-only' shost attribute.
>   */
> -
>  static ssize_t ctl_raae_count_show(struct device *cdev,
>                 struct device_attribute *attr, char *buf)
>  {
> @@ -962,11 +962,11 @@ static DEVICE_ATTR_RO(ctl_raae_count);
>  /**
>   * ctl_iop0_count_show - controller iop0 count check
>   * @cdev: pointer to embedded class device
> + * @attr: device attribute (unused)
>   * @buf: the buffer returned
>   *
>   * A sysfs 'read-only' shost attribute.
>   */
> -
>  static ssize_t ctl_iop0_count_show(struct device *cdev,
>                 struct device_attribute *attr, char *buf)
>  {
> @@ -983,11 +983,11 @@ static DEVICE_ATTR_RO(ctl_iop0_count);
>  /**
>   * ctl_iop1_count_show - controller iop1 count check
>   * @cdev: pointer to embedded class device
> + * @attr: device attribute (unused)
>   * @buf: the buffer returned
>   *
>   * A sysfs 'read-only' shost attribute.
>   */
> -
>  static ssize_t ctl_iop1_count_show(struct device *cdev,
>                 struct device_attribute *attr, char *buf)
>  {
