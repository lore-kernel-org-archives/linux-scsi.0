Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B4FC00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 21:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiHAVbN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 17:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiHAVae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 17:30:34 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9B922B24
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 14:29:30 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-324ec5a9e97so38290617b3.7
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2022 14:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJhneIs24eJv4ukierhtqacrrE32PmvIZRJVAVZL+KU=;
        b=i7PDO41unYnFJQoVscy3Nu89f90rGxroCFDcTvi/H7u+L9k1OuxQYEpW8vJALQy9sb
         DWLoIfoVnuCby8ibe6ZxfCqBNW7NE84+9VadRx+x8hOA2ZjDaEJZocgRkX1SNVS/i/IQ
         /bp7FrkWXo7dKxoBcEPFJuCjYG8G+Dse+pQjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJhneIs24eJv4ukierhtqacrrE32PmvIZRJVAVZL+KU=;
        b=fMpJBXHHTKtLnxXjwiBcn7W5uJDLVyewcDJpQOWHt6GECnlLPqrDlBJ5SwJ34TZB8P
         LKOdfOnC2fZP5OLx1hUBOTzUfqvy3DdXbcytxEey/o1Ww7dZqGpIl+0Zye1D4tvglShC
         gjvVAkM+PQkuNUiD+9Esc9u6U8jW6MWESd3c+UYE/7VnGBvsmFu9bsTCRVGI9b7mm5MO
         XqHjzm8DkxgCD903mmSU4kD4uwz2BoEMog1NN54vIVhtNetUbMdaRzcnBd6SEzl7U2Cq
         3A19JaNyeZ3HoWjPpSnsf1WfUuAmsMeDBnFCtNFm/qZat4vL378FqwX6PnOVAoLUUmoK
         y9aw==
X-Gm-Message-State: ACgBeo3VGIwFW0QfRQVJAQExqT7tcrRM20fkKiRXGqBbJHYS1vu2D2EZ
        Ucs7KDVpbPlVzJKTS9qIkYeYzHn9AUf3F9OVWHtjpQ==
X-Google-Smtp-Source: AA6agR6WmFz3ErZkaFdpehjCddleiWEdMhQ6+XEtTrZxM9pG0247rhhM7LZWBLuBSKnW1ZHSCYb+K6Up5wrjjCV/7ew=
X-Received: by 2002:a0d:cb0b:0:b0:322:6f04:9262 with SMTP id
 n11-20020a0dcb0b000000b003226f049262mr14681907ywd.224.1659389369472; Mon, 01
 Aug 2022 14:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220729151301.v4.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <1ca16b27-21e5-3537-400a-25cdae52396e@acm.org>
In-Reply-To: <1ca16b27-21e5-3537-400a-25cdae52396e@acm.org>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Tue, 2 Aug 2022 07:29:18 +1000
Message-ID: <CAONX=-eknyxTsM21gW6ruaCoov3oJB12g871Wmiq+ibDm4QZCA@mail.gmail.com>
Subject: Re: [PATCH v4] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

HI Bart
> The above sentence is not complete. Did you perhaps want to write "are
> supported by the host controller" instead of "status"?
Will fix it in the next version.

> I don't think the above documentation is correct. My understanding is
> that the UFSHCD_CAP_CLK_SCALING flag indicates whether or not the host
> controller supports clock scaling. It does not indicate whether or not
> clock scaling is enabled.
Ah, right, there is a control for it in sysfs, it is just hidden in
ufshcd.c I was under
a wrong impression that it is like the writebooster capability that
has quite a bit of
conditions for staying present. WIll fix it in the next version.

> Please change "can not / can be enabled" into "is not supported by the
> host controller / is supported by the host controller".
That would be incorrect. The "caps" variable semantics is a bit weird
in the sense
that it is used at times to convey "active" capabilities, not just
supported one. For
example, for the writebooster capability to be present in caps, first
controller driver
should indicate it is ready to support it, then the part that is
attached to the host
controller has to indicate support in the device descriptor, then WB has to be
configured and its lifetime should not be exhausted. If any of those parameters
are not satisfied, the capability will be removed from the set despite generally
being supported. I am not sure how to properly word it, but just
saying "controller
supports it" would becounter-factual (especially since the controller
doesn't really
knows anything about writebooster per-ce, it is part's functionality).
What would
be suggested wording in that case?

--Daniil
