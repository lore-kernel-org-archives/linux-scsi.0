Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A1CC77B73
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 02:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjDUCc2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 22:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbjDUCc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 22:32:27 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F7130ED
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 19:32:23 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2a7ac8a2c8bso10660471fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 19:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682044341; x=1684636341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1QDd65i/47s9L2ZzIwcXb8wI3A/+arhp9EgPexyDaQ=;
        b=mp5GkkIUNrGkCGU96HaA66msaEQ+ifFkvNwojciOUewaoy4gxKy88UAkqo0Wr4Dovg
         htypPR1l/kd3r4x8P7pHzEgYFFKwLnEm8te5Rrw4L3cosaFxdzOyH4dxrVqxqfgnJMpa
         45re3S8WoDMW2jLwSX5Rnr3YnoNJECVAq1vTLr0RVT1fbAAhAitSC5s5pvdUznlfKOCN
         pJccuFYzuWRVmeQRHg8dHSlZAmdFJq2R5ZEm+wvkJUXgbFm/u3f1CzlTvA8Nn/NB8FwW
         Cjc0ebS0BWxrqehPuv+shdWIYmJ6HBqo6joiEMm/8ggkAdmgT56/UOuk65N5qmGaEtA7
         xiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682044341; x=1684636341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1QDd65i/47s9L2ZzIwcXb8wI3A/+arhp9EgPexyDaQ=;
        b=HMX7yEzzcTe19/bEzmN8EwxHUxvpwx6iIfrNuYV5EdNNHro6pV60ZsfPT2W6StJvbd
         y2erdEVej0ValB3/vTv+hkm7Qf+YrR7iEJQ8puMK0onMBBFe9YIcLP5VXh+M7DqEmwr6
         OqaCxSlp/jvZ3RwOw+Vn4QWbnCRxjKV6I+2WhRHQmwNYLTbznM2J/JhENVBRotpvQ/G4
         hM9QbOC8E2og7QuceeDHuPXgSPdLu2oFzjN/qOzZ+vEhxMAtQhGRVTKSwNR21mmf9fHb
         eL7xquwTcDE9PbgSwBPLcquSjX65/c3F9oVC4iqiuRTLifwo75ogzwf1C7o8Xv8U6Fgb
         OAaQ==
X-Gm-Message-State: AAQBX9cYWQXH3XUOK13a4H9V7GunHLvdKtsUI2ILHzKqnQ/4FzFFraMe
        xP8DaZrWXcn2i/E0PgejEHVezhhXwDnAwP3uTg==
X-Google-Smtp-Source: AKy350ZyRDbg66rhGZPcJKjt1FshptD/5aDZ+rPBQpwAjnXM2aEBieyslvTx1+r3TjurYiwaR/YSoXpcXH50390WPgs=
X-Received: by 2002:a2e:8046:0:b0:2a7:6e85:e287 with SMTP id
 p6-20020a2e8046000000b002a76e85e287mr162384ljg.45.1682044341113; Thu, 20 Apr
 2023 19:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681764704.git.quic_nguyenb@quicinc.com>
In-Reply-To: <cover.1681764704.git.quic_nguyenb@quicinc.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Fri, 21 Apr 2023 10:32:09 +0800
Message-ID: <CAGaU9a88zZhH0P2GM0_MvtcbEMaUW9kq5Fn5f662QvRuY-pbbg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc:     quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        bvanassche@acm.org, mani@kernel.org, Powen.Kao@mediatek.com,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bao D. Nguyen <quic_nguyenb@quicinc.com> =E6=96=BC 2023=E5=B9=B44=E6=9C=881=
8=E6=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8A=E5=8D=885:12=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
> This patch series enable support for ufshcd_abort() and error handler in =
MCQ mode.
> The first 3 patches are for supporting ufshcd_abort().
> The 4th and 5th patches are for supporting error handler.
>
> Bao D. Nguyen (5):
>   ufs: mcq: Add supporting functions for mcq abort
>   ufs: mcq: Add support for clean up mcq resources
>   ufs: mcq: Added ufshcd_mcq_abort()
>   ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
>   ufs: core: Add error handling for MCQ mode
> ---
> v1->v2:
> patch #1: Addressed Powen's comment. Replaced read_poll_timeout()
> with ufshcd_mcq_poll_register(). The function read_poll_timeout()
> may sleep while the caller is holding a spin_lock(). Poll the registers
> in a tight loop instead.
> ---
>
>  drivers/ufs/core/ufs-mcq.c     | 258 +++++++++++++++++++++++++++++++++++=
+++++-
>  drivers/ufs/core/ufshcd-priv.h |  15 ++-
>  drivers/ufs/core/ufshcd.c      | 140 ++++++++++++++++++----
>  drivers/ufs/host/ufs-qcom.c    |   2 +-
>  include/ufs/ufshcd.h           |   2 +-
>  include/ufs/ufshci.h           |  17 +++
>  6 files changed, 404 insertions(+), 30 deletions(-)
>
> --
> 2.7.4
>

This series looks good to me.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
