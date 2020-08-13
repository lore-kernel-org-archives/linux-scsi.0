Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCC2C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 13:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA41B20791
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 13:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XFiEw0Bv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgHMNuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 09:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMNuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2020 09:50:12 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFC9C061757
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 06:50:12 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e11so4823472otk.4
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 06:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y74pox+pi6BwFcH3Q20saHWJoWHqw/c/bG383ZgGGVs=;
        b=XFiEw0BvqqMMy3nYQnac3uIHo7NwgyjSUhtYjK23wI7HopI4mbqvfSX3vOZgopd+Vr
         ZN28CnFv5ZXQMoV7rPklXAIIdbyxZkvLRv5tcxA/vM8439YGWGadDRXe4mejpaVfw7xw
         Ja59kA9lYzZN9q8fBGb5L46Lj4zdtOtUH0bQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y74pox+pi6BwFcH3Q20saHWJoWHqw/c/bG383ZgGGVs=;
        b=hLGIZZPyBW5aox07i12d2LcTIMu7JxAtPh7ECFVinNC70VwIfJwOV5y7NB4ticCVw/
         QYNiGLQVts7wwK9XrnzhepQZNzIsjhbLntvte2+hIpfGKuHOCmeE9o6vxoVQAZkUi6si
         mGRpDLx7Ilxy9u1alB68Z5ZRhv+FNtK5nPVoY521zK9uc+KlG959xMxtF+6WyNqmbcNO
         FKikB4TjVLTy5Hy8mgAZC9x+2Y4Nvt3hdrZt9Wiojm3hxfJj7BdnOQbrhoM3d97ezmzJ
         WQgC7ZfyraRRdQF+GhQ/S+Z9apR9mXhNJ7L93zrNR/K/21dNojorcY0sQFVwUStcEX0f
         naNQ==
X-Gm-Message-State: AOAM533YapNmbxgwVkitF6rA9C2atkvy02kzajASvEysc+9lOdjKTbbh
        EsfUefw59kGnN9++gt7ZaQAWKqhvKNqH2jh6XFIfiar3
X-Google-Smtp-Source: ABdhPJzIbqhn8vQPInd00NasQU2VPWTRn402fir2iDUQBaTqVcvA/5zqTU4tVsBchDUM47nl2EkfN3ME7VpfMIXflJI=
X-Received: by 2002:a05:6830:1612:: with SMTP id g18mr3992966otr.251.1597326611308;
 Thu, 13 Aug 2020 06:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200730082822.22343-1-sreekanth.reddy@broadcom.com> <yq1sgcri869.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1sgcri869.fsf@ca-mkp.ca.oracle.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Thu, 13 Aug 2020 19:19:59 +0530
Message-ID: <CAK=zhgomaVCySdriLy+V5+z9_k_gKK6GnHFkNO+3voNcVr9a2w@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Add support for Non-secure Aero and Sea PCI IDs
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 13, 2020 at 8:09 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Sreekanth,
>
> > Driver will throw an error message when a non-secure type controller
> > is detected. Purpose of this interface is to avoid interacting with
> > any firmware which is not secured/signed by Broadcom.
>
> Why not just print the warning?

Sure Martin, I will post the updated version patch with a warning message.

 Thanks,
Sreekanth
>
> --
> Martin K. Petersen      Oracle Linux Engineering
