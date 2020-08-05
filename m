Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF402C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 19:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 817162084D
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596655412;
	bh=/ZuawsNQY0tX3YVgdA0aqZY5ulz2qgAadTz05jYIb4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wuJamtwkSqTUzimSD4mBN/+coJ7yPvJ45Tpq5D84rJX88Cy7pjoKL9746U5m5VwFN
	 m7Cn0zKYAUqfXp3DRjIBkTQZCP180eti5z0v18BXzgVk9r1lOX4jcUCQRd6npAx50i
	 Uz0SGaBZ1Pd3mn/eNOxCWJ8RsKHfmWp9vT29124A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHETXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 15:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgHERcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 13:32:00 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FBAC061756;
        Wed,  5 Aug 2020 10:31:34 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id m7so10271855qki.12;
        Wed, 05 Aug 2020 10:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UWGxhCjzBeMfhRrfiK9S51lUCP77PLbSWogi2fzaHnM=;
        b=byBRoafuwLO4EDZyjJNZQXUe955RCe3v3sOOfAj5eM/IzaVZIWingJqcIMWKy9U1bq
         SP7+bDE8NIJMLU/IWu5+JJv6RLBHGwBC8bZ/tTYdBioZa+gn7yTlIjttYSjBtp4gM4kn
         5j6a6cQlQD0PEvlChyqlW6GnrzGYjHunfVUdKqjOcTR02LRHFljeEi6I8k330r8Mjq4S
         nGJzrrsabDfD6vX9I5bOx7T9dyXd117onufo4VUfLKGmaPLPwyhWHAh3ghTzSsmCYJE7
         ER7F+xJW0HCBNSfT0GciMAXwgvlOfqNy9DKLZ5NWX2A7gVJnRoTbX1TqVNK0YilPWQKZ
         bLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UWGxhCjzBeMfhRrfiK9S51lUCP77PLbSWogi2fzaHnM=;
        b=FTn4vg7KHrxU/HWrikQZtbQ+fB4A63LA8SjuvlQiFO4+B7x3sU9CIG6Q0VR/f3oJ2o
         fQEZQTRU2+WFZJzn+VBi2Uf24/hCs2iZW4bvZGjjXeNCbYsJ1jLOEaYbXB/DY1ydC6G9
         8poXkcg3za1wwIYITdwRmCnbhthEmUxGMd59lDqsY682zXOg2W5m0K6dVPtsx4nlC/JQ
         TjOjUBtYq5YYCOifZtggUIQelwT/VfJFN3pQNT59Cpu24QDGO4jKc6+W71B9Ce5lxtFY
         OtpSikQLQXq2ikoDCa0WOVjJxvXejUc/OujIc9ml9JsVP15XzLVjbdCc/iFd7b3UWxZ3
         LVTQ==
X-Gm-Message-State: AOAM530X2vVwBjqDDlwiLWucQgfSmRqpKQK9K01Jykxgx2Nae9erXO/u
        Iw88RHLK1TuwDh52YOgcbLg=
X-Google-Smtp-Source: ABdhPJwQtX8amUfGESNn3AgNmOlCCqSoI8O3N89faUpmUuDzoHBrEJXl4JoMuhQobp9YpfbhkJhQ0A==
X-Received: by 2002:a37:434a:: with SMTP id q71mr4044575qka.363.1596648692748;
        Wed, 05 Aug 2020 10:31:32 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2e8b])
        by smtp.gmail.com with ESMTPSA id 84sm2118251qkl.11.2020.08.05.10.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 10:31:31 -0700 (PDT)
Date:   Wed, 5 Aug 2020 13:31:30 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     Hannes Reinecke <hare@suse.de>, Ming Lei <tom.leiming@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ewan Milne <emilne@redhat.com>, mkumar@redhat.com
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio
 controller
Message-ID: <20200805173130.GA4520@mtj.thefacebook.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan>
 <20200804142123.GA4819@mtj.thefacebook.com>
 <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com>
 <CACVXFVPVM-xU0d2nETztPrS_EpacMy8A4x8FbShhLYt2iV_ouw@mail.gmail.com>
 <227c7f27-c6c7-5db1-59ac-2dd428f5a42a@suse.de>
 <20200805143913.GC4819@mtj.thefacebook.com>
 <c40bc34840566366177a84b0d8b7ae90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c40bc34840566366177a84b0d8b7ae90@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On Wed, Aug 05, 2020 at 10:44:56PM +0530, Muneendra Kumar M wrote:
> Our main requirement is to track the bio requests coming from different VM
> /container applications  at the blk device layer(fc,scsi,nvme).
> By the time IO request comes to the blk device layer, the context of the
> application is lost and we can't track whose IO this belongs.

I see.

> In our approach we used the block cgroup to achieve this requirement.
> Since Requests also have access to the block cgroup via
> bio->bi_blkg->blkcg, and from there we can get the VM UUID.
> Therefore we added the VM UUID(app_identifier) to struct blkcg and define
> the accessors in blkcg_files and blkcg_legacy_files.
>
> Could you please let me know is there any another way where we can get the
> VM UUID info with the help of blkcg.

Using blkcg for identification does make sense given that that's the finest
granularity which also covers buffered writes. However, the proposed is akin
to adding per-thread application ID to procfs if it were per-thread instead
of per-cgroup, which wouldn't fly well either given the specialized and (at
least for now) niche nature of the feature.

So, my vague suggestion is putting the interface so that it fits the usage
scope and is close to whatever ultimate feature you wanna expose. I don't
think I'm the right person to make concrete recommendations here given the
lack of detailed context.

Thanks.

-- 
tejun
