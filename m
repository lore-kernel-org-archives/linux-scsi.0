Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8078EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 08:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjFZITP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 04:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjFZITN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 04:19:13 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B59AC
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 01:19:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-988a076a7d3so457032766b.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 01:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687767550; x=1690359550;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vGI+nta4xCb7jjtw4SWdamXlIICUlHtM/Q20S/nMlw=;
        b=lunbIA+tI5QGU+sYKJbiveO7P3sCFCXTWS+j97EzgY6iJlkaSMi97c9Ko94N4P+Lgj
         6Rj9PnlZCeN+RJlQe/7PJDGwPpPLUgFGVe5Rq8sKCDhMcbQH9XxElWOIK5D1s0lIQbPe
         cQ/zvTrnRu0V+H0IW8YT6zE9Csm83cdAkFdWFgxsfn8c/HbF8u0hawfzgncwtpMI5hlp
         UPsdQ60xqpI5mO09VVHotOLyE6FC2M5mJhUCmMAHY+u6JcwdhJbbydtcBq5m35h9hfcb
         yuYhV0aZ+LVR8EiCDV0WLA0VAs0qD1eirChspsSMiMAkC4vkyMMFS55SO5SKPE9u0EYG
         ZJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687767550; x=1690359550;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6vGI+nta4xCb7jjtw4SWdamXlIICUlHtM/Q20S/nMlw=;
        b=TJtwJgdpIstH8wCKLM2NWsxRuBR7Lm2DCeXV5/rZWqHsKEPna7Z/d1sVU8U+TNiNDx
         Fz9+FLshJmDlQTI2ClXu3MWc/f+6mwVmVetv5uvVL6UZ/M8o/N/9oHruvWzhs4x3SXBy
         ooN8jLK9FXj7aaNsC2rHb37gtrh/YNRhvWlUNNoEiEBUR1arpjvnaBR2hf2PV2yj90jg
         pwhnrIff87T89EHR1T0gu0wIeHR8CEBa/jVEz2pYpGyC2mc6TkoPcIlilFyd2F53lq+w
         HNqT9ypbXDBvw4cfXbRE4OWWwzJ9/MG97h+rimFJIGd1rxV/apmTaZfX6LzyeOeR3t7Z
         c2gg==
X-Gm-Message-State: AC+VfDzg4u+jJjpnWP0k3GrsT07RhmNMbyln5qxXGPbr5U5UCUbzatQW
        mzJTYD4sJ+oykNe0gzrghARscA==
X-Google-Smtp-Source: ACHHUZ6tDjEL7i629oGAPKobpegpi1tWcqiC6lIxFPHE3WnYQ2IkEVA9iayQg7YPMnyuVyqfRh8ygQ==
X-Received: by 2002:a17:907:96ab:b0:991:d2a8:658a with SMTP id hd43-20020a17090796ab00b00991d2a8658amr1104916ejc.34.1687767550551;
        Mon, 26 Jun 2023 01:19:10 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id gw10-20020a170906f14a00b0098e16f8c198sm2300279ejb.18.2023.06.26.01.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 01:19:10 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 26 Jun 2023 10:19:09 +0200
Message-Id: <CTMFNWKMSCJP.DBPZEW25594L@otso>
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Rob Herring" <robh@kernel.org>
Cc:     "Abel Vesa" <abel.vesa@linaro.org>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Conor Dooley" <conor+dt@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] scsi: dt-bindings: ufs: qcom: Fix warning for
 sdm845 by adding reg-names
From:   "Luca Weiss" <luca.weiss@fairphone.com>
X-Mailer: aerc 0.15.1
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
 <20230623113009.2512206-6-abel.vesa@linaro.org>
 <cd84b8c6-fac7-ecef-26be-792a1b04a102@linaro.org>
 <CTK1AI4TVYRZ.F77OZB62YYC0@otso> <20230623211746.GA1128583-robh@kernel.org>
 <CTMDIQGOYMKD.1BP88GSB03U54@otso>
 <d3970163-b8e8-9665-3761-8942c28adaa8@linaro.org>
In-Reply-To: <d3970163-b8e8-9665-3761-8942c28adaa8@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon Jun 26, 2023 at 9:41 AM CEST, Krzysztof Kozlowski wrote:
> On 26/06/2023 08:38, Luca Weiss wrote:
> >>>> but I guess no resends and it can be superseded.
> >>>
> >>> Right, the patches got reviews but was never applied... I really need=
 to
> >>> find a strategy to keep track of sent patches until they're applied w=
ith
> >>> my work mailbox, it's not the first time that a patch has gotten
> >>> forgotten.
> >>
> >> There was an error reported on the above series. Why would it be=20
> >> applied?
> >=20
> > The error report at [0] complains about reg-names but I'm quite sure
> > that patch 2/3 resolves this error. Does your bot only apply one patch
> > at a time and run the check or apply all of them and then run it? It's
> > been a while but I'm fairly sure I ran all of the checks before sending
> > since I also documented some other patches in the cover letter there.
>
> You did it in cover letter, not in the patch, so there is no dependency
> for bots recorded.

I'm not aware how to put extra comments into a patch in a series with
b4, at least last time I checked I don't think it was possible? But I
also thought the cover letter was exactly there for giving some
background of the series and documenting any dependencies on other
patches.

>
> >=20
> > [0] https://lore.kernel.org/all/167241769341.1925758.178566816349494461=
14.robh@kernel.org/
>
> Your patch 2/3 could not be=C2=A0applied to any tree. 3/3 applied but wit=
hout
> previous one caused warnings.

Anyways, just resent the series as v4, maybe this time it can get picked
up... Should have enough reviews by now :)

Regards
Luca

>
>
>
>
> Best regards,
> Krzysztof

