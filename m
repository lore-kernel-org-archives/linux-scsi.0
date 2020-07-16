Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4F1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 07:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4987E2067D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 07:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DQGZmtUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgGPHQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 03:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGPHQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 03:16:33 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F00C061755
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 00:16:33 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k6so5898797wrn.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 00:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9TnnQvnYMsBS0vFfEzAxKLwtEZGAGG6CcdplbZMdhCc=;
        b=DQGZmtUd5D7DGrgYJg5d4qjzrMV8zzQUHs5k8iiQhVG7EQahFIFd4b+6MWW7KKJWXu
         9hd+xCe0GFilk2D2+1oO6Xrd62fWTRKbGiv4QaDfAGvIcQxBxjySgKNhXR6OWiaFl8eu
         R56mw+/K0MT18pFd4LniG1zIn3O2fsZiCJx25K/lLK4cv+2FILM1yK3OtcBuxcoPyf61
         mp3aP9AXAbBHaXdttvMF40HnC0cOLYD7c8LI8/ZflrdHOwaG8bJzk1T8STgHsPAHSmPU
         HayfvrAoWtPv7nRMH0pBn04iWkZB0ci+xItt1xNg/E2Xmr7BSIRpq0bf3HQ00q6/RiYP
         PCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9TnnQvnYMsBS0vFfEzAxKLwtEZGAGG6CcdplbZMdhCc=;
        b=mA+d8X3sTcKNHwaIq68Yf8WwyeDarAfzlyUC3n35ktDnsT5X6LAZXyGsa2ujWbRd+f
         tQGB8LlqXjUf5MEbTSzrYVMPHbXW1QdxJF57oorGe84oDJkFVwSQ13O6UjRUvZcUrGzK
         4RMEx/UJBkmCbiuF3ZMJX97veP94TKkppmZl4J4OvW6Rm6XqV+PijZuq/UOfkmfI3EMH
         KaC8pmV9tyV/IqRxJlWUBo0z8VHPdaxndXx2+YYDkYAh/Jw9u1rYVVruWE3jNAx/5AZK
         QQqHJF8gnUwOMcstCxlKWNJTcDqtNB8YKK1SA3OfH9uI99XYaRqKUa/aP/Z/SLGaTG00
         8Zzw==
X-Gm-Message-State: AOAM530Eq6h+9LX2flTuHCjH3ThEanrxttehFM6GVjbp6oMxBFXCGAUF
        amNKvX3b7AZMGCCp9nTLvLD+lg==
X-Google-Smtp-Source: ABdhPJwde/Sm7IwZvWeaenQ6ChaPiZppJbMc8dn7sEBf5jP2JUN5dQczjgShnCejDNri1Dt1sSyOuA==
X-Received: by 2002:adf:e850:: with SMTP id d16mr3761655wrn.426.1594883791687;
        Thu, 16 Jul 2020 00:16:31 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id g82sm6810915wma.37.2020.07.16.00.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 00:16:31 -0700 (PDT)
Date:   Thu, 16 Jul 2020 08:16:29 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/24] Set 3: Fix another set of SCSI related W=1
 warnings
Message-ID: <20200716071629.GL3165313@dell>
References: <20200713080001.128044-1-lee.jones@linaro.org>
 <159484884355.21107.3732344826044180939.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <159484884355.21107.3732344826044180939.b4-ty@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Jul 2020, Martin K. Petersen wrote:

> On Mon, 13 Jul 2020 08:59:37 +0100, Lee Jones wrote:
> 
> > This set is part of a larger effort attempting to clean-up W=1
> > kernel builds, which are currently overwhelmingly riddled with
> > niggly little warnings.
> > 
> > Slowly working through the SCSI related ones.  There are many.
> > 
> > This brings the total of W=1 SCSI wanings from 1690 in v5.8-rc1 to 1109.
> > 
> > [...]
> 
> [01/24] scsi: aacraid: Repair two kerneldoc headers
>         https://git.kernel.org/mkp/scsi/c/b115958d91f5
> [02/24] scsi: aacraid: Fix a few kerneldoc issues
>         https://git.kernel.org/mkp/scsi/c/cf93fffac261
> [03/24] scsi: aacraid: Fix logical bug when !DBG
>         https://git.kernel.org/mkp/scsi/c/2fee77e5b820
> [04/24] scsi: aacraid: Remove unused variable 'status'
>         https://git.kernel.org/mkp/scsi/c/0123c7c62d6c
> [05/24] scsi: aacraid: Demote partially documented function header
>         https://git.kernel.org/mkp/scsi/c/71aa4d3e0e78
> [06/24] scsi: aic94xx: Document 'lseq' and repair asd_update_port_links() header
>         https://git.kernel.org/mkp/scsi/c/966fdadf6fea
> [07/24] scsi: aacraid: Fix a bunch of function header issues
>         https://git.kernel.org/mkp/scsi/c/f1134f0eb184
> [08/24] scsi: aic94xx: Fix a couple of formatting and bitrot issues
>         https://git.kernel.org/mkp/scsi/c/d2e510505006
> [09/24] scsi: aacraid: Fill in the very parameter descriptions for rx_sync_cmd()
>         https://git.kernel.org/mkp/scsi/c/ae272a95133a
> [10/24] scsi: pm8001: Provide descriptions for the many undocumented 'attr's
>         https://git.kernel.org/mkp/scsi/c/e1c3e0f8a2ae
> [11/24] scsi: ipr: Fix a mountain of kerneldoc misdemeanours
>         https://git.kernel.org/mkp/scsi/c/a96099e2c164
> [12/24] scsi: virtio_scsi: Demote seemingly unintentional kerneldoc header
>         https://git.kernel.org/mkp/scsi/c/e31f2661ff41
> [13/24] scsi: ipr: Remove a bunch of set but checked variables
>         https://git.kernel.org/mkp/scsi/c/4dc833999e37
> [14/24] scsi: ipr: Fix struct packed-not-aligned issues
>         https://git.kernel.org/mkp/scsi/c/f3bdc59f9b11
> [15/24] scsi: myrs: Demote obvious misuse of kerneldoc to standard comment blocks
>         https://git.kernel.org/mkp/scsi/c/8a692fdb1d04

Something wrong with [16/24]?

> [17/24] scsi: be2iscsi: Fix API/documentation slip
>         https://git.kernel.org/mkp/scsi/c/abad069ef0da
> [18/24] scsi: be2iscsi: Fix misdocumentation of 'pcontext'
>         https://git.kernel.org/mkp/scsi/c/dbc019a48f97
> [19/24] scsi: be2iscsi: Add missing function parameter description
>         https://git.kernel.org/mkp/scsi/c/7405edfdfb96
> [20/24] scsi: lpfc: Correct some pretty obvious misdocumentation
>         https://git.kernel.org/mkp/scsi/c/09d99705b5d2
> [21/24] scsi: aic7xxx: Remove unused variable 'ahd'
>         https://git.kernel.org/mkp/scsi/c/91b6e191c4dc
> [22/24] scsi: aic7xxx: Remove unused variables 'wait' and 'paused'
>         https://git.kernel.org/mkp/scsi/c/532d56c631f1
> [23/24] scsi: aic7xxx: Fix 'amount_xferred' set but not used issue
>         https://git.kernel.org/mkp/scsi/c/42b840bcfc16
> 

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
