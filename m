Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BB3C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 14:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DFF1208A9
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596550920;
	bh=nuDWiGLqSK4ajFwQHFNbVFvyJTuZkBAQo5NQjDOTtSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YDHCXm9DjU6uc7rdj199wNzKfyUk6gvYPYaLe05HkOyrSj0eiISX0px5gNqfoLGkL
	 INcCO/kE77MAlR48a2icGA21591EUQ6sJqf4HNC2rIo3B08NhoJAmkDV4Z4QIJuUH9
	 RgWiC7vzuny7LSgChTaVr5KeP2EUPsAyP7+Qja80=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgHDOV7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbgHDOV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 10:21:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185A4C06174A;
        Tue,  4 Aug 2020 07:21:26 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l6so38490054qkc.6;
        Tue, 04 Aug 2020 07:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/O9Z2m9NVf7Cq+pr83lCv6zvyjimEnbIiGFBd4diED8=;
        b=b3HNOH37/YGGErPa7cIf3CeUvQ3NwSaYogw+asj44Yyl+LHdnN9708DjcGf/+J/mI4
         7ddhkjVuWI+LqtOlmruIlRt2K0SxVYSMlcRitis+c9WT8JFjpGYByHDkD/daec1ohjsK
         gQB2U35oaWw+UaD4W4ZZ6GYTS/qSbU3H8HVB5pxZKES5FQIzgWsZZg0xN52B0ekhR24a
         TSoOkR1ZXmQMqm9W1HVc0ZBMoCRMDRqgFeNBDs3aohL/MAjjjKze/c53+4uJ3ghC3MPP
         5CBTE23ngN/Ai3lkJpdE8EpPt6ru7pGx4LhydPfCWTvrm3j5BaJ0vPj6eMrws7evMaec
         5Xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/O9Z2m9NVf7Cq+pr83lCv6zvyjimEnbIiGFBd4diED8=;
        b=O1KF8oq5Jv9BcZJXFPgTaji/frJVu2kfdZNx3kriMvmuW4S5ox5Qe6kbX5XN0l8ByR
         E7NPMZPwfVfF+HVzV2eLz+xMph7Ua8+dxTaJQBbyGqwGr+n8nrxmaqDYnb+WJwUE3UyJ
         x0Yh6ykDu/l/BAwpKrgqIYZL6hg/7jMDAHDAk8LFd0h7PDdteegMhvZZpJMEfJSCVD6P
         Buwq0Fi9tpa19P/qX7Y5k9y4FMRfLl6xgWRDE6KnYKkoAhLmbgBFAkkC0n5Us1osTKF8
         5mtBJX5VgcNFrjptcjxy/xQ9ivvIBKrEcK6+KwI06R6rkRvMSz22IPd3D66u5tmRl6qs
         KzdQ==
X-Gm-Message-State: AOAM530lPep6qr3FinS3Hmz35a8LCLHodh85tVQhl86F05lGJkZDPip3
        /Ak0W7r3xhYIYSB4E669VXDaJr5M
X-Google-Smtp-Source: ABdhPJwNwl/b42CwVnrnK5m+KFgnd6uk2qrPihS+gKLqbtK4a3g86uMLIDn2KxH2HORQPaL8pYDsPw==
X-Received: by 2002:a37:4ca:: with SMTP id 193mr21318549qke.198.1596550885183;
        Tue, 04 Aug 2020 07:21:25 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:d024])
        by smtp.gmail.com with ESMTPSA id e129sm18846554qkf.132.2020.08.04.07.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 07:21:24 -0700 (PDT)
Date:   Tue, 4 Aug 2020 10:21:23 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio
 controller
Message-ID: <20200804142123.GA4819@mtj.thefacebook.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804113130.qfi5agzilso3mlbp@beryllium.lan>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On Tue, Aug 04, 2020 at 01:31:30PM +0200, Daniel Wagner wrote:
> Hi,
> 
> [cc Tejun]
> 
> On Tue, Aug 04, 2020 at 07:43:01AM +0530, Muneendra wrote:
> > This Patch added a unique application identifier i.e
> > blkio.app_identifier knob to  blkio controller which
> > allows identification of traffic sources at an
> > individual cgroup based Applications
> > (ex:virtual machine (VM))level in both host and
> > fabric infrastructure.

I'm not sure it makes sense to introduce custom IDs for these given that
there already are unique per-host cgroup IDs which aren't recycled.

Thanks.

-- 
tejun
