Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAD4C25B08
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 21:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiHIVRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiHIVQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 17:16:46 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F104C61A
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 14:16:45 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31f41584236so124443197b3.5
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2022 14:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oLnzvgiiApV3VWlzq6jRPE1yUvY8BFpXJK7uuRxPViY=;
        b=fayvEf5WdJjEIxnfSI2fgWunYKmTvDIRKtCzVSQkNKwFu8iJI+08U9BhoICiNt7cl4
         COv9Dx86ZsTmY1ghlFRFjOitQNyuyzZdaorSLwfGmQz1IYyEPHSPFNzosVnoGsXxujcG
         uB4Brcz2j+CfN+vXjtrM/9QS7wD7nd3789kOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oLnzvgiiApV3VWlzq6jRPE1yUvY8BFpXJK7uuRxPViY=;
        b=CDQscCB5/A8gKECx7fcR2u651xSgGak8qK1d8SnP2czibT2WVjbzD5QX3LxDA73Mst
         0EWI6KXMsQ6gg97kR2Wj4o2CPmFEk0X1AQTcatBECU6T95TwKfk7nIP8HEJUaZlz6SpZ
         7o069kGg0k0cnzxW+AGp0vQ+R42cMnYnqwSNQ2ozWoDCAEPkomKO1mIbOqWWEdGFq1vT
         w4oqhEIgIsUYqcU4yYQ6bKlojw1gnyEtTVzEmQmgj7i97x4BRM+/ePBa8C/PHid6DIjB
         V662lOT/tWo2TzRCM2S8MbKSxQObt1AL/TM+yGfEFiVJNclyq/CGOcCv/JbEZRofpf0Q
         NJpQ==
X-Gm-Message-State: ACgBeo1+fHfDrJ+QgUZCu1QV2UpRSetiqH1UxF1mtu0bmcZ28ZSMWvBt
        muNPIvTixVOM0rJVChCPgImsaH3YtWTamrSPb6cAEQ==
X-Google-Smtp-Source: AA6agR6qo0VuTK0himSt+FUyEOvT/ZelIHR1bqwnVqgzBc/13WFe04zeW+Up8BNE3369loXSWZ3IzSFjH9Qmynp4wuk=
X-Received: by 2002:a81:5d07:0:b0:329:8fb8:779 with SMTP id
 r7-20020a815d07000000b003298fb80779mr15696137ywb.77.1660079805095; Tue, 09
 Aug 2022 14:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220803074955.v6.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <YuoRuP2pxgSQ6c9E@kroah.com> <CAONX=-f8kHWCEEyqUdpn5wsyMZKa4eJSSCLvPDn3R5mQF9FSMA@mail.gmail.com>
In-Reply-To: <CAONX=-f8kHWCEEyqUdpn5wsyMZKa4eJSSCLvPDn3R5mQF9FSMA@mail.gmail.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Wed, 10 Aug 2022 07:16:34 +1000
Message-ID: <CAONX=-eL02see4m6wK74cX2D6rUXJXtZYSRiNhPQVDsS8kU27g@mail.gmail.com>
Subject: Re: [PATCH v6] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Are there any more amendments you would want me to make or is it good to go?

Thanks,
Daniil


On Wed, Aug 3, 2022 at 4:34 PM Daniil Lunev <dlunev@chromium.org> wrote:
>
> > Why is this information not also in the Documentation/ABI/ entries as
> > well?
> How would you want me to word it in there? For each entry? There
> will be more in the future, would we need to just copy it as a
> boilerplate? Bart suggested it be added in the code, do you see
> a good way to mention the same in the doc?
> Thanks,
> --Daniil
