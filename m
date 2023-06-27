Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B10C001B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 08:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjF0Ia7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjF0Iah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 04:30:37 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246B92D53
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:29:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-991da766865so210621266b.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687854571; x=1690446571;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqX5DHgOV5JQh3n7wQTrKqWa0S9nC80jd5IBZP65NGs=;
        b=a4GBqxpv7jmHHEKUWeBkMva7W8g70p2YDS9GOd07Uc026C9bLeWu0YTtk0uNpHY9AM
         n6EJOWy+3oafyfX58MRJtYU7Gv5CCMH4n68fNbXwD/RiLNPDUl3FKnvsGlYYCPTPS0Fk
         A145SpaxENj2UwkTrlvH6FuXf4tcGJPUgqZbRsTiOOJZiBaI47prE0BaPIasVX5WoChS
         b9b1Np5DrL0nHV8qCVMpOqMG2tomiTFGwZxcWAqKGfi5CFBeUMHJwESu0Elojtbat8FE
         sAPaqG61Rfs5IE+jnGIGf2LCn5RSfJlx+c5QiFIb+DBTFgimDYgKPo9XR6cg/dAGs+an
         oJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687854571; x=1690446571;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fqX5DHgOV5JQh3n7wQTrKqWa0S9nC80jd5IBZP65NGs=;
        b=aWJDNHzG5K6UDTYQ0qgO57bgpY5+/Nw9t+Ie/OURkVrPB3nG0+ofG5IZHZcadKKGhq
         /OT5PyVIG3eUtxyh9fpLW6MFLZMzZiq/J4Iai0hab7E6+xVdH0WZGPr/bBpnSBD2+ten
         JtbPisRCbkmx+Ylnqqj4P5tqFIsVGZPb6pGsQbU1DRvprQedvluktX+dx7MWGsUYn9pH
         kglMAIsOTUSy0qjfGNBuxN23mBEopzBs7j4AI8GBTzPiaXgz6QSo+zA9rPxwaW35Ac0N
         BCGDQ8Wj/4YO2Ld+JPKsILhzABnU5jZ9K9VlsBd/MDQ+aPcyRqEMHvMPthOgsQGzcurr
         RLMA==
X-Gm-Message-State: AC+VfDxaCBhNutTMVkR1JhiKgtwuE7RjxhNjCpdImcjfMIeewEGogP9/
        2jXMflvkcJ/B0gSUSn8kqZebIA==
X-Google-Smtp-Source: ACHHUZ77eTguqYS4KE49xThLrCpVm5BbKtN84P5H1lk8As6ayJ7KnW61tc4r0vgr+44A4yGyfCjF7A==
X-Received: by 2002:a17:906:974f:b0:98c:df38:517b with SMTP id o15-20020a170906974f00b0098cdf38517bmr15489785ejy.33.1687854571341;
        Tue, 27 Jun 2023 01:29:31 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id ot6-20020a170906ccc600b0098df7d0e096sm3955863ejb.54.2023.06.27.01.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 01:29:31 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 27 Jun 2023 10:29:30 +0200
Message-Id: <CTNAIDCV0BIO.2JMX8MXEQ197U@otso>
Cc:     <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>,
        <phone-devel@vger.kernel.org>, "Eric Biggers" <ebiggers@google.com>
Subject: Re: [PATCH v4 3/3] dt-bindings: ufs: qcom: Fix sm8450 bindings
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Iskren Chernev" <me@iskren.info>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Conor Dooley" <conor+dt@kernel.org>
X-Mailer: aerc 0.15.1
References: <20221209-dt-binding-ufs-v4-0-14ced60f3d1b@fairphone.com>
 <20221209-dt-binding-ufs-v4-3-14ced60f3d1b@fairphone.com>
 <1f94de94-c5bd-738d-5fbe-907558333cb2@linaro.org>
In-Reply-To: <1f94de94-c5bd-738d-5fbe-907558333cb2@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon Jun 26, 2023 at 10:27 AM CEST, Krzysztof Kozlowski wrote:
> On 26/06/2023 10:15, Luca Weiss wrote:
> > SM8450 actually supports ICE (Inline Crypto Engine) so adjust the
> > bindings and the example to match.
> >=20
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > Reviewed-by: Iskren Chernev <me@iskren.info>
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>
> SM8450 should be rather converted to qcom,ice.

In v5 sm8450 is now using ICE, both in dtsi and binding example. But I
guess you could also argue reg-names should be purged from dtsi and
binding completely and to convert all existing dtsi to use the
standalone ice node, right?

But I'd also like for this series to finally land at some point, we can
do this later, okay?

Regards
Luca

>
> Best regards,
> Krzysztof

