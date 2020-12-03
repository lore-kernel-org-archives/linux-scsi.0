Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2603EC64E8A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF05C22245
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgLCMcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 07:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgLCMcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 07:32:24 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A65CC061A51;
        Thu,  3 Dec 2020 04:31:44 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b2so1907456edm.3;
        Thu, 03 Dec 2020 04:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G7EMVCQFdO/l7+xXFqfNviq49dXz5V317P0jmeOaabc=;
        b=H7ytE7HHdtRggQc+72AxsSmd1kZOtSSvRS6MJuSFSSmMiFbASHNy00x4wpAB8SQ9pG
         oL4ttJdLKcWwRWEXu8pGz08keZ1cz//0wcUlmdDQGB1an6AUHMhZ0Jc0F6Z1tGCnEWeu
         22c/ovfRNLLSNsR+hex8NffNI/O+kqtvrBK4Hth+rgjFJ+8hqn3yGRA3TcCp1BVkzqLp
         vvWjrvgZder3og/LqMLnRRyrbXiGIRYtEQH936a/29lXq+5xn2h1BAwOqRrqrNybMi/X
         Gj7lwenhLK8CrEMSQMpoK4REb5XHl/0RL4WnJCdqGZfnArrLGJLXsaNFjnrFNt21emEW
         U0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G7EMVCQFdO/l7+xXFqfNviq49dXz5V317P0jmeOaabc=;
        b=cQbwleKmcMnAL/+vkR/GRsvtTAi0Ib52MB0XWcyZzQN1luC0qIOXG5Sf+3mBBxsbVT
         L+UWXoeI2TGtWIBwbuQ8uwmMl1LbAEoZ87AG4Nx8iHZOMLaVpraxg6DjSbjorvuC2qRj
         UJU+VUCNxBgEPEBv7ZpFnh1tk+MpYXcDvvCX5aJSI2PEoncl2Q2xA42pV0y6ZvfCHBoK
         D9AUZqZM1azaggdNNp4v+PKm1+crHg30WFFAOEBpV7EJDyn+5dSES8+JZ12VdgWLg/2y
         N690JoqTUkcUQk8IFX3B9u3H98tqCHoUVCr0VPPnE5ZOTL3A5DP7++bl4cBADpsmXZi+
         pq8A==
X-Gm-Message-State: AOAM5318Q7ce7mBZAZ7Q3FST4bgDp8xB1toNXL4YsMI6BB3i3q41ubvV
        RcRgNxB9MttJm28S69lOWoQ=
X-Google-Smtp-Source: ABdhPJwOALp/xW4Bo9XnK7hnDAPuWILbFvpEfHsztYVMnOcAvD+OA5kELXPpzfyGIf3Y3rWgVKtz1A==
X-Received: by 2002:a50:e688:: with SMTP id z8mr2658883edm.129.1606998702824;
        Thu, 03 Dec 2020 04:31:42 -0800 (PST)
Received: from ubuntu-laptop ([2a01:598:b905:79de:6c3d:3b27:f281:55d5])
        by smtp.googlemail.com with ESMTPSA id e19sm1069738edr.61.2020.12.03.04.31.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Dec 2020 04:31:42 -0800 (PST)
Message-ID: <5b26c234d357512c0bffccf733d6ed8c5dd3a517.camel@gmail.com>
Subject: Re: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 03 Dec 2020 13:31:40 +0100
In-Reply-To: <DM6PR04MB65750B6EF8B374476E255FA7FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-3-huobean@gmail.com>
         <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
         <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
         <2dafb87ff450776c0406311bb7e235e9816f6ecf.camel@gmail.com>
         <DM6PR04MB657551290696C7EBD8339328FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
         <2578a5fa2323f46b29dc8808b948ed5eaea6fbca.camel@gmail.com>
         <DM6PR04MB65750B6EF8B374476E255FA7FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-03 at 12:15 +0000, Avri Altman wrote:
> > so, you agree the possiblity of failure  exists.
> 
> I was more relating to the lottery part.
It doesn't matter. even the possibility of winning a lottery is very
low, but still there is.
> > 
> > > Hence we need-not any extra logic protecting device management
> > > command failures.
> > 
> > what extra logic?
> > 
> > > 
> > > if reading the configuration pass correctly, and UFSHCD_CAP_WB_EN
> > > is
> > > set,
> > 
> > 
> > UFSHCD_CAP_WB_EN set is DRAM level. still in the cache.
> > 
> > > one should expect that any other functionality would work.
> > > 
> > 
> > No,  The programming will consume more power than reading, the
> > later setting will more possbile fail than reading.
> > 
> > > Otherwise, any non-standard behavior should be added with a
> > > quirk.
> > > 
> > 
> > NO, this is not what is standard or non-standard. This is
> > independent
> > of UFS device/controller. It is a software design. IMO, we didn't
> > deal
> > with programming status that is a potential bug. If having to
> > impose to
> > a component, do you think should be controller or device? Instead
> > of
> > addin a quirk, I prefer dropping this patch.
> 
> It seems you are adding some special treatment in case some device
> management command failed,
> A vanishingly unlikely event but a one that has significant impact
> over power consumption.

again, there is nothing with device. Obviously, you didn't do system
reliability testing in harsh environment. you don't believe this is WB
driver bug. I will send my next version patch with a fix-tag. even It
cannot merge. but I want to highlight it is a bug.

Thanks,
Bean


