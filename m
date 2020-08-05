Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED115C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D449222B40
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBSPVHd1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgHEEAJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgHEEAI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:00:08 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C84CC06174A;
        Tue,  4 Aug 2020 21:00:08 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 3so4894841wmi.1;
        Tue, 04 Aug 2020 21:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j8kN1DrP7Q5xQD+mZ8jsVMJL4BPhkoW5dve/DUvVZCw=;
        b=aBSPVHd12XR/nwGpA9cLQCwrCmfh1YhgNJI6yZw0v4SaynoCPsEjDYfJ+XE56Tm/p/
         pzB6lDGguUwobYGx7Myamfy2ehSD69biHTAn26fXUjtEoc1VFDJC/bnxzGzA1M5kQ4WA
         4TM8d3pIR07w18ohcq/35Y9shEVUHOQNIA6aL8VVQnU30TQ544UGF3tTw+re3kDKM8gZ
         jNVSxaJ8sLSrFe4Pqj/vHAIa6QQg5z51rroFP83eJJZqPz/9FYRlYsDBpE/9Qr96c9yS
         fqh7zmP6ZYsWfKJPVrx4VWqfUicZ98Zabuvvofvp32fYvvL/k65hnjf587Zwv1P9LzsC
         DM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j8kN1DrP7Q5xQD+mZ8jsVMJL4BPhkoW5dve/DUvVZCw=;
        b=SLv6EadPB1Sr+hLaXeVnwZHh0/4d/t/WWhMKZ8UtzBEWubNlZYynbZlxk2/BuRccTg
         WPbe3oKu2M/N3QpW/TrfeEUY1LQbI6jbMahBd8RmBly0uv1Oe83UJgaaGm1faPU4UFEz
         ZKpk8dcA38C6RQTYJPW7AE+XJ11at3dKVSL0jTpU8+qZhQlhuRMFxrKz2HeliXTDf0KL
         bAcWU+AoBahDv6KDpQp0Eczq5UNI0DloxG1EZJ6CByPBKaJizWnt8sujj6AZD+P/6XVq
         IIi6UEmVuvHweQYWzZD82566GnPN4Xtvp/nhjIPTgi/ScAB6GREpSzEH0CdVdSRNF39K
         vKug==
X-Gm-Message-State: AOAM532Cj5pAo7Wj+m9LnAmr1hrBf4G0DUDaFo80FMTbhBb+p07xUyl1
        dL4V1l8uqA68csFjUdo5XAxPCU9mn6ZMtkToelA=
X-Google-Smtp-Source: ABdhPJyZYKNndT+VJFGzyauzfcbtgvntI1CGDlbTEVJpYr+AAsKOJTkaxcupY5AUo+v0Ea+Lqp0PEYXUB0GkmVr5dCc=
X-Received: by 2002:a1c:660a:: with SMTP id a10mr1245235wmc.115.1596600007030;
 Tue, 04 Aug 2020 21:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan> <20200804142123.GA4819@mtj.thefacebook.com>
 <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com>
In-Reply-To: <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Wed, 5 Aug 2020 11:59:55 +0800
Message-ID: <CACVXFVPVM-xU0d2nETztPrS_EpacMy8A4x8FbShhLYt2iV_ouw@mail.gmail.com>
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio controller
To:     James Smart <james.smart@broadcom.com>
Cc:     Tejun Heo <tj@kernel.org>, Daniel Wagner <dwagner@suse.de>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ewan Milne <emilne@redhat.com>, mkumar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 5, 2020 at 8:42 AM James Smart <james.smart@broadcom.com> wrote:
>
> On 8/4/2020 7:21 AM, Tejun Heo wrote:
> > Hello,
> >
> > On Tue, Aug 04, 2020 at 01:31:30PM +0200, Daniel Wagner wrote:
> >> Hi,
> >>
> >> [cc Tejun]
> >>
> >> On Tue, Aug 04, 2020 at 07:43:01AM +0530, Muneendra wrote:
> >>> This Patch added a unique application identifier i.e
> >>> blkio.app_identifier knob to  blkio controller which
> >>> allows identification of traffic sources at an
> >>> individual cgroup based Applications
> >>> (ex:virtual machine (VM))level in both host and
> >>> fabric infrastructure.
> > I'm not sure it makes sense to introduce custom IDs for these given that
> > there already are unique per-host cgroup IDs which aren't recycled.
> >
> > Thanks.
> >
>
> If the VM moves to a different host, does the per-host cgroup IDs
> migrate with the VM ?   If not, we need to have an identifier that moves
> with the VM and which is independent of what host the VM is residing on.

Hello James,

Is it possible to reuse VM's mac address or other unique ID for such purpose?


Thanks,
Ming Lei
