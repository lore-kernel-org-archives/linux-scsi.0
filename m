Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B4FC77B7D
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 09:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbjEOJ6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 05:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbjEOJ6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 05:58:50 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8C3A0
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2023 02:58:49 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-44fd6c24d5aso4457071e0c.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2023 02:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1684144728; x=1686736728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbXtIGp63Fscsuq6HvXYDK8e/YBIj3uFeNgrwLOtSjg=;
        b=W8n2J/7TndzsZATZelIs3QwudW1eqdOYL3HJYK8CXM1bZGxhhsMsBBHq27NGgmaRwV
         m144VzSX5RUi6NQek8gWDGbqMlNCljhgs2ADrAS7S22hXtzw9diQF9D1BSgy+wWMF9zK
         STUM0/0OJDhbaJ8FzhUsRdM3brxuzyvZn1BnxrjaLxhBHV43P2yRU6GayDNot2dVWZ6g
         v3ibb4q+oVC6dBmMgjXcowBMN61F+z9RtC0J6T+oDXlYuBxyvVxyZS9Jn4r1HRqnAArD
         Ia0Nz+n/KKFnn8Z241c+4juVYqQ9D/dF2QD5O43RcnygL4yOZxJVZCAPRnadD7doLMDI
         caUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684144728; x=1686736728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EbXtIGp63Fscsuq6HvXYDK8e/YBIj3uFeNgrwLOtSjg=;
        b=EsqJ7yUkWhBYt0FmzUXV37RYTPAgBiOdlOnOzbV4wYkoweoO/AeVUPiABJ9sd9gOxr
         DODOgGMNyOy9TDRIgLU/FTKOja+Z1JiZLuGEiVRwsL/bjzFKlf9ytuXZElGaXQ/VhoDR
         GFGl1Q438u6H8IojGf6GNghRvu1qv/9msX8cae314gDAkln4Edt0itO7s7idPhJhdL9P
         uJPto2XJoI13fXYLXdSjDZH4D2yVAnc2zr4PDSr4gSMNyjbtj7J4BLg5dq+8lcalg6Wl
         NnPqwLcqoyY7oPvr9YQYRVG7BmqsyKTebSqSNBuSuJWZllGg0flN6EPMwzQg0+QjbGCc
         O4rA==
X-Gm-Message-State: AC+VfDyeDY7F8yYMfcc2JEo6/NQsPDzu71L0Hr+IdGjJ+SZnCe6IIll8
        lY8vb/o8yLjf1u07MYJB2a2xsWfS9jdINUSMmexr7A==
X-Google-Smtp-Source: ACHHUZ6DHZcKjPVvUXhtel4kMOfQHIuPoYEDoT3uupfFpobTSZjjgpOCyVhxviL7y9JsLigfEdajYPxDkpqzdJoa9X4=
X-Received: by 2002:a1f:3d14:0:b0:453:75ff:7fbe with SMTP id
 k20-20020a1f3d14000000b0045375ff7fbemr4987110vka.16.1684144728426; Mon, 15
 May 2023 02:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230515095308.183424-1-brgl@bgdev.pl> <d10d66a6-3e28-5c42-c650-9d00d53045f0@linaro.org>
In-Reply-To: <d10d66a6-3e28-5c42-c650-9d00d53045f0@linaro.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 15 May 2023 11:58:37 +0200
Message-ID: <CAMRc=MdffxxgXqb3APCrc3en23WgHY6rxAb8Ed80oLc=bGLuCg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] arm64: qcom: sa8775p: add support for UFS
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 15, 2023 at 11:57=E2=80=AFAM Konrad Dybcio <konrad.dybcio@linar=
o.org> wrote:
>
>
>
> On 15.05.2023 11:53, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > Update relevant DT bindings, add new config to the driver and add UFS
> > and PHY nodes to the .dtsi and enable them in the board .dts for
> > sa8775p-ride.
> >
> > v3 -> v4:
> > - drop applied patches
> > - mark the UFS as dma-coherent
> Bjorn picked all of these up, you need to send an incremental
> patch now.
>
> Konrad

Ah cr*p just saw it too, they were not in next yet so didn't notice
when rebasing. Will send an incremental patch then.

Bart
