Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F42C46466
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 14:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 548A821D43
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 14:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/lRCt6S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgJHOYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 10:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730582AbgJHOYg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 10:24:36 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFA0C061755;
        Thu,  8 Oct 2020 07:24:36 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e18so6819784wrw.9;
        Thu, 08 Oct 2020 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WsE6vlmD9PjpvVzoPnqJMKBuzypaiKtsmjNNqhDX95o=;
        b=q/lRCt6Ss8/vdI0hDNrUbNoiPMjEJRCygt9VTkjMe73GWTFfGT9/VDFg8j/7d6q9vP
         /2f7drWDk6NF6Q8bhw3blFG0QqDKQ4mWDf1jk+Q0G4X/Sc73XBpR2V5zwRyr0eNq7IZc
         9luh3Tvi0rxUNHOACa9y0iRUi5ALtOZVZtLDQFgl6SWhWaQG4C2kHEFdY6sG9QTXTGAg
         mc9b19i0ENGgSEm29dEMVJR/J9NakcEmZGvn32Y72CrT9JihNGLHZCkU7oDkT9r6uwBR
         7khEbO2/XxpygmBxuWFCC6Ry/XxB0h0Z5sUq6TMjxOhnE7ihI+6Af1cnUolQ1mDPqhJg
         UoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WsE6vlmD9PjpvVzoPnqJMKBuzypaiKtsmjNNqhDX95o=;
        b=ew6d7MAC87TWlJfntkO/vg2HA4rNPem5qPqoDcqZp66rECG9W1yoLa9fLFGjFJ/sJj
         ysR2gTlBg1p2qhtRz0LUUc2tZoXwo90sPur2njkYmPjXx4EnVHZLrmT2lDP3O3iyrZeN
         IhxsopuzsuRpDT3+zv4dPf7ZrpOgF8TyPteWRMG5UByU3v5n+JcfFFKb8KueIBuk65Qy
         jK4Z29oEunAjgGh7SMpM+XemIX9AKkjH4h74M4UATHpuaEXzVSI0C05I4WwXx4P6IUSU
         8YPTYTfJdvIHTCUtDUSXJDHwBLPHJW0Ehb4gfaq4LoA5ROHbYkWtXlO5t7RewrjUdlPb
         sIwA==
X-Gm-Message-State: AOAM533GOlLZRpRsiJ7/TC78HNXxVJUr64PFFHrVqYXmPRtR8pgSKSSN
        4Q/G46E3G4pDtoSQGcxGaQc=
X-Google-Smtp-Source: ABdhPJyXOLr+W/KVhxr9IQApyCne5Ztvl/cdLftPL+q6Y73tybqT+jd+ywZrZOVJCYmHeZcsMaTX6A==
X-Received: by 2002:adf:d849:: with SMTP id k9mr1036584wrl.332.1602167074799;
        Thu, 08 Oct 2020 07:24:34 -0700 (PDT)
Received: from ubuntu-laptop ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id t5sm7741882wrb.21.2020.10.08.07.24.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 08 Oct 2020 07:24:34 -0700 (PDT)
Message-ID: <ed80ba975eda3108b1230604211062028fd91c4b.camel@gmail.com>
Subject: Re: [PATCH] scsi: sd: Use UNMAP in case the device doesn't support
 WRITE_SAME
From:   Bean Huo <huobean@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>
Date:   Thu, 08 Oct 2020 16:24:31 +0200
In-Reply-To: <yq14kn5wgqf.fsf@ca-mkp.ca.oracle.com>
References: <20201007104220.8772-1-huobean@gmail.com>
         <yq14kn5wgqf.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-10-07 at 23:47 -0400, Martin K. Petersen wrote:
> > support WRITE_SAME. The problem is that WRITE SAME heuristics
> > doesn't work
> > for this kind of storage device since its block limits VPD page
> > doesn't
> > contain the LBP information. Currently we set its provisioning_mode
> > "writesame_16" and didn't check "no_write_same".
> 
> There is something odd with what your device is reporting.
> 
> We support WRITE SAME on a bunch of devices that predate the Logical
> Block Provisioning VPD page and the various Block Limits parameters
> being introduced to the spec. Consequently we set the provisioning
> mode
> to "writesame_16" if the device reports LBPME=1 in READ CAPACITY(16)
> and
> nothing relevant is reported in the VPD pages. That is by design.
> 
> > If we didn't manually change this default provisioning_mode to
> > "unmap"
> > through sysfs, provisioning_mode will be set to "disabled" after
> > the
> > first WRITE_SAME command with the following error occurs:
> 
> If your device supports UNMAP it *must* report it in the Logical
> Block
> Provisioning VPD by setting LBPU=1 and report MAXIMUM UNMAP LBA COUNT
> and MAXIMUM UNMAP BLOCK DESCRIPTOR COUNT in the Block Limits VPD.
> 
> Also, "no_write_same" disables attempting to use WRITE SAME to zero
> block ranges. That's orthogonal to the logic controlling which
> command
> to use for performing an unmap operation. An unfortunate choice of
> naming which can be attributed to the SCSI protocol using the WRITE
> SAME
> command for two completely different operations.
> 

Hi Martin
thanks very much for your above comments, very detailed. The case I
encountered is very strange to me as well. I will double check on the
product level.

thanks,
Bean


