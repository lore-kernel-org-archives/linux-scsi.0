Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF375C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 02:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18D02245C
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 02:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3EBejV0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHFCW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 22:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgHFCW0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 22:22:26 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25AFC061574;
        Wed,  5 Aug 2020 19:22:25 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id 88so42439344wrh.3;
        Wed, 05 Aug 2020 19:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j9l6GEfncnC27tRQDJn054GgtzKPKFkbXc8CYwJP+4E=;
        b=O3EBejV06EP8wEAkjHSga3Ad6M7yT6+e5eez1JtRQmqZh+sEviqSZP9oDjWb+IlC9G
         +FDDKZuvTEuB+n5nJIEQ63uWptUH18S6WoF2GbuSsv9otjUejOP7HGS6jVnZ56Nkgz5i
         ij3jqn/ki7dKv4pl8xRO1Rnoj4JokijeIRCEh9xFuJ8uMFStkgxdaNBKx00Uyyk2kMrx
         5mnuDh5240qgpamUvy1LEp2kBW2ndYmSslWHITI0aF+nsMtC7/1OebWVsBKfZPs2xsfz
         /kzpvxPRKni2L1SpYfz72B3E6jMwkpee1O8bYeRhG+cjkw6X9zybSg8WO2sjCXvX3VL4
         HxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j9l6GEfncnC27tRQDJn054GgtzKPKFkbXc8CYwJP+4E=;
        b=eOoBcmy34WLyGYctC3ZkluI0+DvtY0fQXrw7PevZwzErIWxDt7vB9etPNgeQajZFav
         9UCXHf9on/ij4dDpzfcdIaybbnWMBPGGN2v3yCoY1K3s7dp5rPDxEALUzPKDmRbERmJZ
         msnwYDCs/+KI/JzlMPxYgy+3zoznjDA/3dtVJ3mw4q1oGicyrb5CGC48g3ZrC6MTAScs
         YrdUdYUKZEbTpTR6ZUqlHGlhEar94whbsItU2Wygw39WtqS5zCDOmLYIDWwhKOt+RtXy
         sUBNXfue1S8nGoVfZqPR7m7T3JapuW6nvwnmDkTCPVJXzpaO2xeHp6PR5Ttrfa9eipll
         qj3w==
X-Gm-Message-State: AOAM531CApdxiZ1PapL9dGbBK5lhWYU2rUZcUF54akTDaTH+Tqn0MClV
        wWxAR5UMiBlHyuCqMGCS0ocKpls373zgrW9xBZfz1ZDaWYM=
X-Google-Smtp-Source: ABdhPJyp0g2O7nlBzy3hTwdyRnUm2G85LCQymOTunXFZF5hTUwLBXyrkzIHn1xYUjHgfJAXibZLiBzWi0rxYh3tiuKI=
X-Received: by 2002:adf:90cb:: with SMTP id i69mr4875240wri.87.1596680544668;
 Wed, 05 Aug 2020 19:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan> <20200804142123.GA4819@mtj.thefacebook.com>
 <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com> <CACVXFVPVM-xU0d2nETztPrS_EpacMy8A4x8FbShhLYt2iV_ouw@mail.gmail.com>
 <227c7f27-c6c7-5db1-59ac-2dd428f5a42a@suse.de> <20200805143913.GC4819@mtj.thefacebook.com>
 <c40bc34840566366177a84b0d8b7ae90@mail.gmail.com>
In-Reply-To: <c40bc34840566366177a84b0d8b7ae90@mail.gmail.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Thu, 6 Aug 2020 10:22:13 +0800
Message-ID: <CACVXFVOYc9KAaLsQ1kPa_bW_MsUgcxhqec45f24pB62=r-KXPg@mail.gmail.com>
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio controller
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ewan Milne <emilne@redhat.com>, mkumar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 6, 2020 at 1:15 AM Muneendra Kumar M
<muneendra.kumar@broadcom.com> wrote:
>
> Hi Tejun,
> Our main requirement is to track the bio requests coming from different VM
> /container applications  at the blk device layer(fc,scsi,nvme).
> By the time IO request comes to the blk device layer, the context of the
> application is lost and we can't track whose IO this belongs.
>
> In our approach we used the block cgroup to achieve this requirement.
> Since Requests also have access to the block cgroup via
> bio->bi_blkg->blkcg, and from there we can get the VM UUID.
> Therefore we added the VM UUID(app_identifier) to struct blkcg and define
> the accessors in blkcg_files and blkcg_legacy_files.
>
> Could you please let me know is there any another way where we can get the
> VM UUID info with the help of blkcg.

As Tejun suggested, the mapping between bio->bi_blkg->blkcg and the
unique ID could be built in usage scope, such as fabric
infrastructure, something like
xarray/hash may help to do that without much difficulty.

Thanks,
Ming
