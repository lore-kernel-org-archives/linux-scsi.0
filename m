Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E30C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 07:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E459F2070E
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 07:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hz0QixLz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgGPHOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 03:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgGPHOu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 03:14:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139ECC061755
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 00:14:50 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q5so5867847wru.6
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 00:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ikn6Iht1n6nTlmAa+XZKXI2O4te+krLCsk3CfmfKoRU=;
        b=Hz0QixLzMGwxc/77gOsuPYonN6p2Kbt3eZSAZkBDjIpfNnaLE9WuEtI3KqDgjpvQl6
         UgflkZQ3BiPM74X3BxhH4bZDxCU2yEWWxdfe6BUBLUKhKH4AKyC5iPsfBzhtN1v6kXj7
         Msl6x+I+cgaybF0YigfQiq4XzrNuy4fifk2j1xKnaj/ik9l4iWovKdL99rCpzFM77mZ8
         lR8PkApIvEvRE4erYnrk/uJB9av9URg/Fxh2bjIOXMn4gak4stXz1lKlqEpUx4Gcg6tx
         ui8CaBMv0J7IxePq+lkm8dSn+FR+6Qs7mgoDgGt94fM1nSDOwq7kz3ipS9w1kcug+UL/
         S0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ikn6Iht1n6nTlmAa+XZKXI2O4te+krLCsk3CfmfKoRU=;
        b=iMGerijlsYp6g3YmTo0CbKJ7jFA4OBrKMBhzl5B17RJnrcrhrUWpil0pyKbSG3yPQz
         0b7j05XczzzYpjkmdfxAU2nMHLjHvdQlHvAiXYpfI4UP3V/rhgJGq9m5v+kmSyGhiHXz
         mYozwrIeBmLdMNw/cJ4Xe31G1ZX5CQhHiZQA428IdKlGkgCketo5e2QbVjQJ+kM/IACh
         3DypYiXAfRTDydM5CU0TKgnKO00dEQyluzqiePMKsuJF6AJtIDe66DS7oOVRbT3ir6cZ
         j27RKFgZveRk/TMxRMZRrRO8HFnMqDHsEaXoW9qQnc3zl7vcu2Lm/z4xOmZugXZiqWBD
         7VBQ==
X-Gm-Message-State: AOAM533D76vGgjREA9p+nJfk390RMw2c8XO9LBk7auvjyvqvprNUQpvt
        Pp0W49H8qtI5C8PT1mEz2RRALQ==
X-Google-Smtp-Source: ABdhPJyq4EsPPKPnV3g5ZYqI+PKLq6NkIyfR8QPMz/7G+FePOwuqX5ZOgznKTdK1Dn65zbisPBqHKA==
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr3838486wrn.179.1594883688470;
        Thu, 16 Jul 2020 00:14:48 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id 1sm6731831wmf.21.2020.07.16.00.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 00:14:47 -0700 (PDT)
Date:   Thu, 16 Jul 2020 08:14:45 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/24] Set 3: Fix another set of SCSI related W=1
 warnings
Message-ID: <20200716071445.GK3165313@dell>
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
> Applied to 5.9/scsi-queue. Thanks for cleaning things up!
> 
> I do think that in general it makes little sense for low-level drivers
> to document internal functions using kerneldoc. As a general approach
> I would prefer to just switch drivers to '/*' or to remove stale
> comments instead of trying to keep up with the "docrot" warnings.
> 
> kerneldoc cleanups are great for functions that actually have more
> than one user (core code, libraries, common code used by multiple
> drivers, etc.). Whereas for driver internals I would much rather
> emphasize function arguments with well-chosen, descriptive names
> instead of a kerneldoc "@p: pointer to a foobar" comment that will
> inevitably become stale next time an interface changes.

I'm inclined to agree.

There is even a script to list the 'offenders':

 `scripts/find-unused-docs.sh`

An effort to demote all unused docs is likely to be somewhat more
controversial than one to re-sync the attribute/parameter
descriptions though.  I choose the path of least resistance for my
clean-up effort.  Nothing stopping us having another pass once they
are all re-synced.

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
