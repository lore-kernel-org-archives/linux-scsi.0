Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF13CE79A8
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 22:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjISWak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 18:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjISWaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 18:30:39 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72377BA
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 15:30:33 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-59bdad64411so63265507b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 15:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695162632; x=1695767432; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWE12E4GSEQPScLBBOQ9P6hDatI6KkLL6gqpAgFkrJo=;
        b=soJyAgZiT4Cl7Zd2UErM9QgPsoV+TWtECVkyzApg8RgfBkCVmq++TeHLMxGN4JQvdC
         JC1JY1D+T4gmIgV3LHMka6wvWCDNq/OrVM6vjYTtbJEe0v4LnoNXhWtZe/DhSN1jX3ZW
         ninZ1J+7mXQ0cMMISmlrIT8FVutMPdQX4WuH1qO5L3aom8xYy0Oyxww+r7d/YVUfEYPQ
         b8pKQ1lOXj2wIoRatfTCnjRMoIh8SYslIdt2xaTwQiZYo3vqu1JWn03RP+RU9Es5CAf9
         GOsVIG1mIb1rURhhaMZtZX+2QGts9z+H6Ir1MdvV49b2VzIMo/jZcSX8aYuBY8JJFKXV
         bMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695162632; x=1695767432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWE12E4GSEQPScLBBOQ9P6hDatI6KkLL6gqpAgFkrJo=;
        b=ONjZuSxjqd9BE7Jmt2uWC/uSEKmSvmSEhYPP1oHaSLT1M+cmY5nEZZpZ3IjJCqHdI+
         C/MXhgIXPMyDAReUu+tptAnFoGUDajAdbU3a08r7Q6ndZWMLJexzKZgPFyjT8Al92BdX
         Ro0fG84jErGv1A8Y7Eyf5Em9jn318X0AeDOQ6ld6+rN1T2dhi25yvvL3ST6mz1zpSMQR
         w2DOV/IRx+VsQSKmmsqISw7ILA54g1S7No8mA7brB1FmvBMLetNdm7WFBC2iJxZNmDZO
         P2Ip/q83AIvw8D5rEzLTqB5wMGu9v85AZVEA1PTcmem9BN1kludfojShjWtwZJNNywFi
         0J0g==
X-Gm-Message-State: AOJu0Yyr85olHLLnYEC0NkCy2L22zPaFWibkfxhzDyQi5Cao12+jUENS
        /1CetgZ7wufwXuXLUU0F05o+6rkLL5r1fl71rfd2og==
X-Google-Smtp-Source: AGHT+IEV8SVk5WgId3f74CGiOEcj5v/vf1O/cO2KcQDyXtlP/RbqH7RmWLEiFf0qFc30CL2l7x/95xY4aKHQ9wEx8sQ=
X-Received: by 2002:a0d:d88e:0:b0:58f:96d8:e7ad with SMTP id
 a136-20020a0dd88e000000b0058f96d8e7admr899833ywe.18.1695162632620; Tue, 19
 Sep 2023 15:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <1694411968-14413-1-git-send-email-quic_cang@quicinc.com>
 <1694411968-14413-5-git-send-email-quic_cang@quicinc.com> <CAA8EJpoWnXeJKPB04kJW6Qo7ifAnt1u2ZSiq+W2HWOez=hi5gA@mail.gmail.com>
 <20230919121524.GD4732@thinkpad>
In-Reply-To: <20230919121524.GD4732@thinkpad>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Wed, 20 Sep 2023 01:30:21 +0300
Message-ID: <CAA8EJpoqRBxS7HJrFdRAvv677hKJw+d_K+fN_4ABDrj+68r28w@mail.gmail.com>
Subject: Re: [PATCH 4/6] phy: qualcomm: phy-qcom-qmp-ufs: Move data structs
 and setting tables to header
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Can Guo <quic_cang@quicinc.com>, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Sept 2023 at 15:15, Manivannan Sadhasivam <mani@kernel.org> wrote:
>
> On Thu, Sep 14, 2023 at 03:28:59PM +0300, Dmitry Baryshkov wrote:
> > On Mon, 11 Sept 2023 at 09:01, Can Guo <quic_cang@quicinc.com> wrote:
> > >
> > > To make the code more readable, move the data structs and PHY settting
> > > tables to a header file, namely the phy-qcom-qmp-ufs.h.
> > >
> > > Signed-off-by: Can Guo <quic_cang@quicinc.com>
> > > ---
> > >  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 802 +------------------------------
> > >  drivers/phy/qualcomm/phy-qcom-qmp-ufs.h | 805 ++++++++++++++++++++++++++++++++
> > >  2 files changed, 806 insertions(+), 801 deletions(-)
> > >  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-ufs.h
> >
> > Is there any reason to do so? Other than just moving stuff around, it
> > doesn't give us anything. This header will not be shared with any
> > other driver. Just moving data tables to the header (ugh, static data
> > in the header) doesn't make code more readable.
> >
>
> I think the motive here is to move the static tables to one file and have the
> rest of the code in another. Because, the static tables itself occupy 1.2k LoC
> now and it is going to grow. So let's keep them in a single file to avoid mixing
> it with rest of the driver code.

My 2c is that this is mostly useless. The headers are for sharing, not
for moving the data out of the .c files. Not to mention that the
driver code comes after the tables.
I'd really suggest starting such a move with separating common parts
of all the QMP drivers.

>
> - Mani
>
> > If you really would like to clean up the QMP drivers, please consider
> > splitting _common_ parts. But at this point I highly doubt that it is
> > possible in a useful way.


-- 
With best wishes
Dmitry
