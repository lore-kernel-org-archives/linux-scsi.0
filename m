Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8E7C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 13:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiI1Nhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiI1Nhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 09:37:34 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56DCA405A
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 06:37:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n10so19800358wrw.12
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 06:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aTP29VLwmHzF+BlZpTUnzV80oUgoBdNLoxbkZcqcm+0=;
        b=B0RBVRnQtl51Q2qfyZiLLH1R3o5D6GzH6b9vAeoJmsTSsCLNh7DWHspsYsdWq2LihA
         fOiPJ8bi5LKRkWibWDlPeXo6Xl1u/AF8RGFBnOq85/ClZbWA+T5CkvqRRvzJy3Lj/u4W
         diuYhtmTCPT8BlNyiECuVpYhm/MCYv2GE3OItMKnw169tDGEsp66YhEGr/QqgGo/o0IQ
         wJ8eNT+Qz0xh5ZE/oH7TFURtez0edU8TztxaQGwdp4+AkSnMh68ARrUpu4Y3lleyxFf3
         Xr4LZv0d9k7+/olq0osYrfFkF8aPz57BgHvuwFstEyQlsFR7607J+pdT/AMbXIE10uwI
         vSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aTP29VLwmHzF+BlZpTUnzV80oUgoBdNLoxbkZcqcm+0=;
        b=O6kH8FqXsr4TSod/ZngEyRN5TMPuybMZFIwVUByaJkFpT93stZANXs40fbLuQWHpvy
         M+hN85J6rdko1S4SLqRCYfe5KI7FEpVmlSA4IAtRgMPEDsUgaBcXk2CEyAYihw6YM3xL
         bXdUvrN2RQHYuL/FTU0/6wwzPElTEgFA7zbKl8oIpC5PwbXuQXoxMop+GqXm87oCaDMz
         2bZfG/2bUVNevRzfnGIJLIduqt37rew2/v6eXlJK/H/JFqEzqtRFXOO/R6RIOt+7xLgp
         kIO7dFupOeiL+cfESYDe0m6kCp9Cs3gZy1jykpOXUbgjudf3LJYoTEfL4vPz7peyNc0X
         m37w==
X-Gm-Message-State: ACrzQf0laS2J0yKm97s+9LyhEFXM812L8SCHsMXi9qcrnFQdeaPo6rA8
        aFjhinN1d7r2VfcEthhOtj8mh4TuBA==
X-Google-Smtp-Source: AMsMyM5+//wPAlKeYnSHXLgq+jsRUFX9zLHBxvDqxSFYWGm3zpejpMDCV72ktNjGcdKh0mKg+gS24A==
X-Received: by 2002:a05:6000:1f0c:b0:22c:c601:a824 with SMTP id bv12-20020a0560001f0c00b0022cc601a824mr3257355wrb.215.1664372251215;
        Wed, 28 Sep 2022 06:37:31 -0700 (PDT)
Received: from octinomon ([2a00:23c8:2f02:3b01:3ea1:40:8650:189])
        by smtp.gmail.com with ESMTPSA id o2-20020adfeac2000000b00228c375d81bsm4402616wrn.2.2022.09.28.06.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 06:37:30 -0700 (PDT)
Date:   Wed, 28 Sep 2022 14:37:29 +0100
From:   Jules Irenge <jbi.octave@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/7] scsi: Convert snprintf() to scnprintf()
Message-ID: <YzROGS934MbKlwxQ@octinomon>
References: <YzHyC191CIXZSfc5@fedora>
 <ea00dcab-e4f6-f672-e754-9ddec67da83d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea00dcab-e4f6-f672-e754-9ddec67da83d@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 26, 2022 at 12:14:05PM -0700, Bart Van Assche wrote:
> On 9/26/22 11:40, Jules Irenge wrote:
> > Coccinnelle reports a warning
> > Warning: Use scnprintf or sprintf
> > Adding to that, there has been a slow migration from snprintf to scnprintf.
> > This LWN article explains the rationale for this change
> > https: //lwn.net/Articles/69419/
> > Ie. snprintf() returns what *would* be the resulting length,
> > while scnprintf() returns the actual length.
> 
> Isn't using snprintf() or scnprintf() inside sysfs show callbacks considered
> deprecated?
> 
You are right.

sysfs_emit() is preferred here.
If I have the blessing of the maintainer, I will go ahead and send a
second version with those changes.

Thanks,
Jules
