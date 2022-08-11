Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E602C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 19:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiHKTct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 15:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiHKTcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 15:32:47 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD58E90C6E
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 12:32:46 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-31f445bd486so182378977b3.13
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 12:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KnZhSRmmnhV6NXnx60Qv/kbkELQWVsKuvSM9qoqa/sw=;
        b=a7cwYyQODPi/Md2tiwpSPJXrks/VkWThYOsbbcNH3vKWy3TnE/Gi0uAnM6KOBaxCS1
         aNCvVmKzPSxa++36Yb3m1kUEHJ6c9hN7l3SssTxDlXvllxy1XcWKcjWETCkwD+qTYFnD
         0sYuFBq8rOBdWiemISJeKUqTGOJY9Sy4b8Wvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KnZhSRmmnhV6NXnx60Qv/kbkELQWVsKuvSM9qoqa/sw=;
        b=7mO4u56mZXgyInyc07pkXs1Y+XRWQDxWpd60rtiMp5BjlkFTCz/iYjkOMx4aZeswrq
         kKaU/lnX9N2rT8bnwxO18cIH0vjjeAXWO9JDbaTVZP/oLDqGp4ouxjxweTZOyGK4GKZz
         ODcXuxnyyg6h4ENb6IokiFFeSK4Dd8OXSqHaAYXX89nU2A5fl7TLOeZ+/kAWzAUFIH5T
         vkedXNZ3xbnvN+kg7FFbLJRM0N4czYhrO0b8nxCt5Jp6SLOt/T62wzXh/haigSpOirTE
         fqQqojfvptVd7ezmPs0yyoMZXyIM9e6AXmpcdO9r/AOQ3o4tC68/3Z92i/5H3M20R+NC
         f56g==
X-Gm-Message-State: ACgBeo2BONWJ4CRBGC56/YgLeY4LsfI3EL1+YPsIMa1DiS2mq6QLNcxZ
        wMvxguvx4rZCIhQV9wBW7dGP2Ulaf1pXazYjJtWjfw==
X-Google-Smtp-Source: AA6agR7R+/ZJPUr5AS/wPDpISVd1svxGA8bRr4yB/uEMC/Y+fldKYatkUgIcEhXzoDH4sNQSFv90bVEw0Tk41/UnT5E=
X-Received: by 2002:a81:81c1:0:b0:31e:7378:960c with SMTP id
 r184-20020a8181c1000000b0031e7378960cmr820348ywf.266.1660246366132; Thu, 11
 Aug 2022 12:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220803074955.v6.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <YuoRuP2pxgSQ6c9E@kroah.com> <CAONX=-f8kHWCEEyqUdpn5wsyMZKa4eJSSCLvPDn3R5mQF9FSMA@mail.gmail.com>
 <YvSfjwCu69ivTGIZ@sol.localdomain>
In-Reply-To: <YvSfjwCu69ivTGIZ@sol.localdomain>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Fri, 12 Aug 2022 05:32:34 +1000
Message-ID: <CAONX=-dK3CA2Tp2z+HrSTrR8=VJQuiFPhgoqKQkLhrDU1JXG5A@mail.gmail.com>
Subject: Re: [PATCH v6] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
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

Hi Eric,
> This is describing the directory, so please include it in a documentation entry
> for the directory itself (/sys/bus/platform/drivers/ufshcd/*/capabilities/) just
> above the documentation entries for the files in the directory.

Should I keep the comment in this file as well, or remove it here when
adding to the documentation?

--Daniil
