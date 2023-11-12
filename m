Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8729CC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Nov 2023 09:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjKLJmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Nov 2023 04:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjKLJmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Nov 2023 04:42:24 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2624273E
        for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2023 01:42:21 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5bf58204b7aso35821107b3.3
        for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2023 01:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699782141; x=1700386941; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/gQnjtXtOK9khUR53/ZBYv8JGqjz6phP1BfsulQpeWM=;
        b=Kxp0dc6aTercNIFdp6K0o5OXjrN3NTBGH56Trd0aHSZ2EBSUzRpHxkS/bKOEW4Dnvb
         0KTBt+DyJs9eAYaI2/MW7VyBPHRv2WDqzgmE3mFg2rpKvOKht/xnhDACl3Pm8Lx4sojd
         W7SRk4Sl7myOfPSh3s9jyukWoyaB9OFmNaTnIv0yFyg6AV5nSa7jJKWSddOqEwkL1hFC
         yEDFBrdCOJ+sVc8ZSX+nKbp757b69yRwQ1RuMT86fYKZ+aYQba5zBZ5k0Pl/WBKsdjp3
         jDO/xUNecJAcdMo6qWkCWZx4CWYJZSNa4GatTqdqgaRaebm89LnjJIYsTVUIFuDbGrGp
         0rog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699782141; x=1700386941;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/gQnjtXtOK9khUR53/ZBYv8JGqjz6phP1BfsulQpeWM=;
        b=R+P6npHd45ABtLbdOX2hlYS7JkHjQfCPCcjy053hUehV+Hdunq6gpaJXl0j0zhWT7X
         wAZLPcTcYAQcVFFAU+/8IRj0sg8YRLifuzIplrVw/S7lU6GaNDu7sF5SOseyA8zucwbL
         cLxbpBCzQv98nNS+1DgqCJZr+ZyiSmuIHnxz12B/HPxMBY9ZZwrvradCR+dL7shIkqmy
         as7kj31aC2+MovHausQ5FSpBjeVooizZ39gKOb2LVoaTtBaDRj+LgNJzrFlJT06IyZ8A
         wj7QZPxKDeLurLikZXBDlIDt7lnBRsZHDbvqdVg7+Rl34ooSSzEe3piFwKBFeDvkQFOr
         +/0g==
X-Gm-Message-State: AOJu0Ywqrp0FqmsQs5WW35vWoxqip43aRgjPNd91HZVgvRdWyeLC8/Np
        FzWwxSH3+Tz75IeuQLxA4P7W8aoOBSzUkTuZzzrqTpsDy5M=
X-Google-Smtp-Source: AGHT+IEYNj8LRog3XuhHjRukEfbew4d3Y55BQ3FNCo1URS7LYVSh/50b7yoNZM9Yu1nM6L3PwTeCnPxUBV555jNWfQ4=
X-Received: by 2002:a0d:f347:0:b0:5a7:d997:cc7b with SMTP id
 c68-20020a0df347000000b005a7d997cc7bmr4480460ywf.23.1699782140782; Sun, 12
 Nov 2023 01:42:20 -0800 (PST)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 12 Nov 2023 17:42:10 +0800
Message-ID: <CAGnHSE=pipa-zi-kxWyPoow0wU04-N_eUopOaZWFftTsfLjEQQ@mail.gmail.com>
Subject: [BUG] write_cache sysfs file broken for WCE setting
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

So I notice that the write_cache sysfs file seems to be broken for WCE
(SBC) setting.

First of all, "write back" gets rejected as "Invalid argument".

On the other hand, while "write through" can be written to the file,
it does not seem to actually change the WCE bit (as per sdparm
reports). There's no new cache setting reporting kernel log either.
However, reading the file after the write does give "write through".

Nevertheless, the file does change accordingly when I set WCE to 0 or
1 with sdparm.

I am reproducing this on 6.6.1. It seems that it at least affects the
6.1.x LTS branch as well though. (I can't tell for sure since for the
latter I am using the raspberrypi tree.)

Regards,
Tom
