Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9E2C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B69461351
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhJCVKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 17:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhJCVKo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 17:10:44 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B2C0613EC
        for <linux-scsi@vger.kernel.org>; Sun,  3 Oct 2021 14:08:56 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g193-20020a1c20ca000000b0030d55f1d984so6139702wmg.3
        for <linux-scsi@vger.kernel.org>; Sun, 03 Oct 2021 14:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Zkct+sr5JjKjQY2htWpPc55s6StQEw5cLhC+v87JVcM=;
        b=ZbYFgMdfQ/gGBbeW+ooj6AwG4q3y5w/i5PJdPmL1XC062AX1WLLqMDAVr0Cmlitygf
         QSh0TtPFFnWn/gR+fDwTjOV4gYKpB7mAZm8RPU1KjnyvRwSJuNoujflAPDufaOi22mYk
         6c2fvxbjHZ+YHdOHgaL7dcIMOdp10HoysAU+tX9oe3PKznUqdkZLE4vj3YzueDcfSDPo
         YecNElUBgPJfejqG52ygJk1BkTOIim16hpuw20Ir+KckF12ur+phkb6SE/Vl6AwMy2AB
         XDxOKvDzTwwyoTxYvbt8y2zBl9Nl1cuwtUTZHvSlCHvJK+IN3p4WEjt+3w+Ut3gvfT/o
         n8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Zkct+sr5JjKjQY2htWpPc55s6StQEw5cLhC+v87JVcM=;
        b=FdgbR+sxz5/RuuKkIYzh2N5TTcSxznm3um7V8qe6ly1WgaCuuCn+qIr0frOE0Nzt1a
         uhO9J1eOUhIPaUZd1q9FTRUQg8F0cgUSX9tjQBNwDH/77is3ELQ8XAOkYEyv9L6qLSiK
         pfx77UwY3nOEAWTHZTS7T27y1yPZR8Fuip22S7Tz91+9eId0hgrwv78tr9TIqRH8VGcR
         Z6M7w50vaKz0KX08PF8Q6S2pNKYbo/lM6HlyLjZ6//b+m770esD8ZZw2En7u7F56s9ey
         cDez0SliAtF9VPPGMrF5UHsgSxPbK8fLcslp1A1nAPKMBqYbGcuxPTeaRht/BBr2XRTo
         seMw==
X-Gm-Message-State: AOAM530mpr6zDOx8/9/kDZn1TIhhMlCU6bzFay/eWpxjJ2DtjRni8NiJ
        ofEXII3AnLU+WTGLH3jzY+o=
X-Google-Smtp-Source: ABdhPJzaG0sAxPaIT2vIOwRvACf6xv3/TozgF6poymAXPPfk6PPXUOx+cthWg0PcqzdAuXmCjfXTQw==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr15598365wmk.51.1633295335070;
        Sun, 03 Oct 2021 14:08:55 -0700 (PDT)
Received: from p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de (p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de. [2003:e9:4717:cf64:8712:b27b:14e4:a39f])
        by smtp.googlemail.com with ESMTPSA id w5sm12324252wrq.86.2021.10.03.14.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 14:08:54 -0700 (PDT)
Message-ID: <d77f45c3f6cee99e71debc8297de4f0242268a61.camel@gmail.com>
Subject: Re: [PATCH v2 01/84] scsi: core: Use a member variable to track the
 SCSI command submitter
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Date:   Sun, 03 Oct 2021 23:08:53 +0200
In-Reply-To: <20210929220600.3509089-2-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
         <20210929220600.3509089-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-29 at 15:04 -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Use a member
> variable
> 
> to track the SCSI command submitter such that later patches can call
> 
> scsi_done(scmd) instead of scmd->scsi_done(scmd).
> 
> 
> 
> The asymmetric behavior that scsi_send_eh_cmnd() sets the submission
> 
> context to the SCSI error handler and that it does not restore the
> 
> submission context to the SCSI core is retained.
> 
> 
> 
> Cc: Hannes Reinecke <hare@suse.com>
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> 
> Cc: Christoph Hellwig <hch@lst.de>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

