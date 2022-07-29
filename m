Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C96CC00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 08:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiG2I36 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 04:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiG2I35 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 04:29:57 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E55193CB
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 01:29:56 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3238de26fb1so25494397b3.8
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 01:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3yGNw5Pw6Un/Uy9wnY0+CD/KjLBxNn7T2gy4eWMRDQ=;
        b=Y365AcNCH/EjT++/AOeD7Uflr2DeWivY8WxyHS2Bgc48yTSVS5EtFvhF3geZSAT+KO
         r4zvCwh2zxZhnZEKsVYvFPs2Dn22uDzwXph/GpiVOlf3f6jXtkyNFGB8+OewDjf/uacQ
         6EKjpqLeu4QUxoT705CthQqPgoKp1A3N5RtyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3yGNw5Pw6Un/Uy9wnY0+CD/KjLBxNn7T2gy4eWMRDQ=;
        b=IKqr/0bOG+ufDDNcr9y2ocb1CTHErcYieKvXCgZklAp45qCIjRydPbMJIiNXfhAryd
         uzwOcH4NDKlaBC9jdkKqzS3j71+z+TaIhFXbiDDLM1Lm9fg6sgZ5X6ZF1C9RboQljOUe
         yk1Wx0SMeuZTpKbq8KT6xtvTyeyg5XZtF/ui7AVSVjkWZRLnuPVZ15TSUXcZY09pRas9
         AEck7Dot2ZB8DrQe6WhuKRXkqAdG+NPh22QVnDPwNrusuikq8ixR5GwTw41XxLLMCrC+
         4E9V/dl33o89Cu/NzrNLBZWpSf5R4VAv9qk6fSGBGJfSmMbmdgyCugwU62nHDmtcQF2V
         4VMg==
X-Gm-Message-State: ACgBeo2fUig5k338J6V4RpUh+gi63hXl/G+IWEYWTtQ5SBlff0xVQZzb
        RlNUKvdnYxZkal/kT/pIpvNnmPv7MJgnhLxYNIgdE4KFDAM=
X-Google-Smtp-Source: AA6agR59qG5dD7t/w6jafCVMWrGkaI/L0XhPq5RnedoW5TLTXfaIWVgD+iMkQzGf33GT9VEeWsWnbKSNwbxhs3QBOF8=
X-Received: by 2002:a81:342:0:b0:323:51dd:8277 with SMTP id
 63-20020a810342000000b0032351dd8277mr2170952ywd.420.1659083396148; Fri, 29
 Jul 2022 01:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220729020508.4147751-1-dlunev@chromium.org> <20220729120216.v3.2.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <YuOWV5uLVV2JYP1c@kroah.com>
In-Reply-To: <YuOWV5uLVV2JYP1c@kroah.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Fri, 29 Jul 2022 18:29:45 +1000
Message-ID: <CAONX=-cy_abLBw1uAEYk6pxmyuQQ4qeQRftZVi7byNuYnEsA+w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ufs: core: print UFSHCD capabilities in
 controller's sysfs node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >
> > +What:                /sys/bus/platform/drivers/ufshcd/*/capabilities/clock_scaling
>
> This shouldn't be linked to as a driver file, it's a device file.  So no
> need for this line.
>
> > +What:                /sys/bus/platform/devices/*.ufs/capabilities/clock_scaling
>
> Since when are all ufs devices platform devices?  Do we not have UFS
> controllers on other types of busses?

I have pretty much copped the structure of the entries across this file. Nearly
all of the entries link both device and driver paths and nearly all of
the entries
mention the platform-based path (which you correctly mentioned is not
factually correct, since we do have controllers on the pci bus). Please advise
if it is ok to keep it like this for consistency or what would be the
appropriate
way to adjust the documentation?
--Daniil
