Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473CCC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 06:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiHCGfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 02:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiHCGfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 02:35:09 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124215724F
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 23:35:07 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 123so26955355ybv.7
        for <linux-scsi@vger.kernel.org>; Tue, 02 Aug 2022 23:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=drdaKm1rYuNx2R4KHfm7Yuhd8hot7Jil0OwecH2OJZo=;
        b=fA3tCgNA8/kv8khG6b3Xdam/7tcuG+JeJwmweOfpHzpztZAnDserPJvMqR2r2r/C/u
         X49qugF1JZZbrmhbU5EYIaMrcPuC/uhPzpYccgsscTQnftqdUQTDgaxEVpLDwdH6X0bh
         mAOTqV9zaajB6c+182EQqxsb1NVnGj70hK7/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=drdaKm1rYuNx2R4KHfm7Yuhd8hot7Jil0OwecH2OJZo=;
        b=SVbtp2lESxww+De9XwxPkTcf2BmN3/PKdP4cTEfYfBaeayY3MssW3rgX0Ctg+w9WRA
         2icK0edYm9Ug3hU8rhPRNWkux7CnV9ursICMsskucdpVMaMl4NrpSO8LHOClwZv5mbhJ
         4t5rUr7nbYiQkAFKu4c1wbNoPCmtMa11980JNTsxR1V0C2BYeGORuKW9cQLOwzsgz46Q
         MXgkbRDCWvNiJUKMQzp1x/QodV/Qq4fnS2PK4ggYO7qrw0Af5kyfMuoqAyp5EtXIBJ1L
         75DE2BVOOku6Qa5mJQdtYoWH/+t/1mvX5L8wa+rbX5cK/0D5XMau4eTUJZp9n/tomlgT
         LaCA==
X-Gm-Message-State: ACgBeo3nXxZGf2jHIGR2Qmyh8rtBEAhG3rKANvnW852K0RtPizZxyIO/
        w0aOiLGV6RjJkpn69qiSXSxJAEitWraEeLwf+AZN5A==
X-Google-Smtp-Source: AA6agR7dFKricjPxEoi6JyVu40+XkuE9ZHzhJkC86xfuVNHsey1GnmspDjZQ3n+eC17M2de7P8dtpd1WNS1Vahex1BI=
X-Received: by 2002:a25:c206:0:b0:67a:6ba0:98f5 with SMTP id
 s6-20020a25c206000000b0067a6ba098f5mr1253055ybf.507.1659508506351; Tue, 02
 Aug 2022 23:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220803074955.v6.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <YuoRuP2pxgSQ6c9E@kroah.com>
In-Reply-To: <YuoRuP2pxgSQ6c9E@kroah.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Wed, 3 Aug 2022 16:34:55 +1000
Message-ID: <CAONX=-f8kHWCEEyqUdpn5wsyMZKa4eJSSCLvPDn3R5mQF9FSMA@mail.gmail.com>
Subject: Re: [PATCH v6] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
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

> Why is this information not also in the Documentation/ABI/ entries as
> well?
How would you want me to word it in there? For each entry? There
will be more in the future, would we need to just copy it as a
boilerplate? Bart suggested it be added in the code, do you see
a good way to mention the same in the doc?
Thanks,
--Daniil
