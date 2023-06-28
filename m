Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFEDEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 09:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjF1J1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjF1H5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 03:57:39 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAB8358D
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 00:56:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3fa96fd79feso36348265e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 00:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687938964; x=1690530964;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGESXMqxdx0Zv+bAFNoo8XDOiS0wv8ydMIUjJi5DqTY=;
        b=D9S8nykC3kWe1LCpXewQE5enSca1u6oixzsmhR1MM0oZT644Bc4dslkt1SNIyCR7qJ
         QNxoPZyQbt21U+KMFhDRDX36joqttupH4Gdw3mf6X58Oa3L5+w8SYEnnbOW37QooyDhb
         yulW8nj51GiTg6OfKC8IcmQ6QXTU1sPNDWJpBP5ayBlnOJxe3oz+PydYxUCD9JUOdhJv
         +t+NJWlLZVVPvOzJ+fAepIjyr9rwEczVbIoKv5rACe1fihiqT+3kkEQMFjtBf6gv0KzG
         81rpOxd5PwKQEMK5p8uvMFryeeGmuLUVRrtuHMdMAF1KWjHsU3kZhutVC26oxU+aKx8p
         69cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687938964; x=1690530964;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oGESXMqxdx0Zv+bAFNoo8XDOiS0wv8ydMIUjJi5DqTY=;
        b=i/EB8W0nZyin4J6lTNRGoZVPojnyB6/eKipEkXfzwOAk3Nr9rl5YBE3bkoYeMb+ao/
         oB5M2qV2V5uu//mUWYP1qhXDKnY0sU/RFPY5xXdIliziP781hab/libKv810dm3wNR3v
         EofyaqYybgNOv+a/rhQsaVlGwKt1+4kVCkfnvBSTIIW8VCSHBMowuTDvXDU1/vq2gwT4
         xNFmiezVM0BeSegzvy0bhBcYbUTtvoudB0tql7EU01JtVHGbd9YsZtlJGcmwjsgmqMLT
         5yTtPzMvarrbbfgjMlchw8GNZ5Sk9VlqEnNJqso8B5P1xMFb98PtjHSBb4ReXkEMDch4
         7QxQ==
X-Gm-Message-State: AC+VfDyhoRwBuxh6GHhYgjSshUavc/KpuBxBPVgYsIQg8QaJv37Ou3Ad
        cYS0g3H9/miv1cQxsQz9lp97mG25s3Q2hrleZZfy9A==
X-Google-Smtp-Source: ACHHUZ7gMB9TdATmziELOylooF5UzD9PmwT9Be5LPd834t2aGs/kkjckH0xBz/KPhpyVg2PoFJtO9Q==
X-Received: by 2002:a17:907:3f88:b0:992:566b:7d57 with SMTP id hr8-20020a1709073f8800b00992566b7d57mr2009072ejc.61.1687934997372;
        Tue, 27 Jun 2023 23:49:57 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id lc1-20020a170906f90100b00988e953a586sm5401785ejb.61.2023.06.27.23.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 23:49:56 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 28 Jun 2023 08:49:56 +0200
Message-Id: <CTO30OAFFNFB.18YWUN5KFZVTA@otso>
Cc:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Abel Vesa" <abel.vesa@linaro.org>,
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
To:     "Rob Herring" <robh@kernel.org>
X-Mailer: aerc 0.15.1
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
 <20230623113009.2512206-6-abel.vesa@linaro.org>
 <cd84b8c6-fac7-ecef-26be-792a1b04a102@linaro.org>
 <CTK1AI4TVYRZ.F77OZB62YYC0@otso> <20230623211746.GA1128583-robh@kernel.org>
 <CTMDIQGOYMKD.1BP88GSB03U54@otso>
 <d3970163-b8e8-9665-3761-8942c28adaa8@linaro.org>
 <CTMFNWKMSCJP.DBPZEW25594L@otso> <20230627151842.GB1918927-robh@kernel.org>
In-Reply-To: <20230627151842.GB1918927-robh@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue Jun 27, 2023 at 5:18 PM CEST, Rob Herring wrote:
> On Mon, Jun 26, 2023 at 10:19:09AM +0200, Luca Weiss wrote:
> > On Mon Jun 26, 2023 at 9:41 AM CEST, Krzysztof Kozlowski wrote:
> > > On 26/06/2023 08:38, Luca Weiss wrote:
> > > >>>> but I guess no resends and it can be superseded.
> > > >>>
> > > >>> Right, the patches got reviews but was never applied... I really =
need to
> > > >>> find a strategy to keep track of sent patches until they're appli=
ed with
> > > >>> my work mailbox, it's not the first time that a patch has gotten
> > > >>> forgotten.
> > > >>
> > > >> There was an error reported on the above series. Why would it be=
=20
> > > >> applied?
> > > >=20
> > > > The error report at [0] complains about reg-names but I'm quite sur=
e
> > > > that patch 2/3 resolves this error. Does your bot only apply one pa=
tch
> > > > at a time and run the check or apply all of them and then run it? I=
t's
> > > > been a while but I'm fairly sure I ran all of the checks before sen=
ding
> > > > since I also documented some other patches in the cover letter ther=
e.
> > >
> > > You did it in cover letter, not in the patch, so there is no dependen=
cy
> > > for bots recorded.
> >=20
> > I'm not aware how to put extra comments into a patch in a series with
> > b4, at least last time I checked I don't think it was possible? But I
> > also thought the cover letter was exactly there for giving some
> > background of the series and documenting any dependencies on other
> > patches.
>
> I just put a '---' line and comments after that in the commit messages.=
=20
> That works fine unless your git branch is going upstream directly (i.e.=
=20
> via a pull request). Even when I apply my own patches, I get them from=20
> lore and apply so the comments are dropped.

Ah, didn't know this was possible/supported. In the past with git
send-email directly I'd edit the patch file and add some text under the
"---" manually but wasn't aware you can put it directly in the commit
message. But I guess if it produces the same output either way it makes
sense.

I won't have a problem with pull requests since I'm just a normal patch
submitter ;)

Thanks for the advice!

Regards
Luca

>
> Rob

