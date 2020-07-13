Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7ECC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23432206F0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="XLao+p1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgGMIST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgGMIST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:18:19 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662FCC061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:18:19 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y10so15516411eje.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JP1Yyp+DTsbRDEveTS8YwrT8f2VEO8CdIRFCeUgVxQ=;
        b=XLao+p1V5JORtXNlcnEOcYEcU8EJSO/lRaYhZO3XmgfuF21T31seX/KeejsgSYB/dH
         9Mtzc6sD0ywKjPrk4YHzeSWPbmFx4cZwR8sgmBUOfTXTsukGhDYlx0yeT7wzCN3UPuIu
         u48JA1UwjkiLL7Du7ODyx85cRfcRXQfHsGYEmhYjSXUTxNFnqEywTwpxHWMy1ugojrgK
         pcbagL35jFPmlEmuAhruE3o6KM6BKgpVutSeb0ABNj5aUbzZxe0DCJhMIR9mB1thYzO3
         eqxYHou/QhiKuyswI8nlJrw5jmV3dqxdqWYuU6h1iLGNgu56Fjd91dRiWupz2EBmGJuk
         6Vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JP1Yyp+DTsbRDEveTS8YwrT8f2VEO8CdIRFCeUgVxQ=;
        b=XhqVkWTZhXQIiixi4YgiSMIp099ZyVFEp9sk+4GaAYpp6Ku3apMATwzh63h7crB0ul
         FZCzTHH9ChIAfHn1WENRLpF6Cl6xdmy4CqxxKo43EOHoxsnlIRf1tjFtXMJfKByafmhj
         T+ZNsdyEGHGTxuhE9uKQ376F4deA5z8QK5OvrAE6KwgUEjyQgNUvgZNTS3tVqi5OYUaT
         ziT3qz94eJxGgzFgE2a6W45rBd86SQLsGjasOmUP8jbdf9RvXGcvgN4c75XqvI5koRSH
         GaZce245D/McnZGd8Z1A/vCEFR3pcS39IEDo4cQB24izSGAqN0wDzWwkhBRYslV/AoEo
         Qa5Q==
X-Gm-Message-State: AOAM530xyM+MGQPkULVtKXKHK0l1inuCAE3MQjpVbPbLaCqsrgPGe83M
        fKiE+4gHsHgTk3BTfL9DCIhDlE6bbCPw55RlsXVw3w==
X-Google-Smtp-Source: ABdhPJxfrzyIRllQdfLdumU9+TZZyekQcPC/KWcapEDU2nFmJDRgWdJeqmsnwXUbP2/nb/mNJboQFf0aegkdjFp3mFI=
X-Received: by 2002:a17:906:3b01:: with SMTP id g1mr37201239ejf.353.1594628298066;
 Mon, 13 Jul 2020 01:18:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200713080001.128044-1-lee.jones@linaro.org> <20200713080001.128044-11-lee.jones@linaro.org>
In-Reply-To: <20200713080001.128044-11-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 13 Jul 2020 10:18:07 +0200
Message-ID: <CAMGffEmhV+wznX2Og26nL4oe6dj8VaHO1ksOZpP7m5owB-t9yg@mail.gmail.com>
Subject: Re: [PATCH v2 10/24] scsi: pm8001: pm8001_ctl: Provide descriptions
 for the many undocumented 'attr's
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 13, 2020 at 10:00 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> ... even if they are completely unused.
>
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_ctl.c:56: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_mpi_interface_rev_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:81: warning: Function parameter or member 'attr' not described in 'controller_fatal_error_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:100: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_fw_version_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:130: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ila_version_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:155: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_inactive_fw_version_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:181: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_max_out_io_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:204: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_max_devices_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:230: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_max_sg_list_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:274: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_sas_spec_support_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:303: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_host_sas_address_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:322: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_logging_level_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:355: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_aap_log_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:390: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ib_queue_log_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:423: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ob_queue_log_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:454: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_bios_version_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:492: warning: Function parameter or member 'attr' not described in 'event_log_size_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:510: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_iop_log_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:548: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_fatal_log_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:566: warning: Function parameter or member 'attr' not described in 'non_fatal_log_show'
>  drivers/scsi/pm8001/pm8001_ctl.c:609: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_gsm_log_show'
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
good to have kernel doc warning clean.
Thanks!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
