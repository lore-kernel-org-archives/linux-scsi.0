Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B081FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 04:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8680761222
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 04:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhJDERH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 00:17:07 -0400
Received: from mail-yb1-f181.google.com ([209.85.219.181]:45695 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhJDERG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 00:17:06 -0400
Received: by mail-yb1-f181.google.com with SMTP id i84so34564090ybc.12
        for <linux-scsi@vger.kernel.org>; Sun, 03 Oct 2021 21:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PN1/vZAKWaiMpR8wDi1K6GGtq6tCgzRVr6sApbSUJj8=;
        b=PK2y/0szijFEMfT8+Ybvp+xN0puE93eUWZuqe3/+xKm3XhqD3MH+MZOCw8qzcLuYQU
         XcdNnUiF7Tu17X6DqzuSY9tqsbC8bBklPhwqr6yG8JtTXGUo14H+SbUQC7EIHSUQ1Dxd
         4hS9BDbp/JJdAzxTlAkH9Xu89x1LbHB4RaCzKS6m14rAAXg/19wY98mDI00fvHQdpkGp
         WjXOf7onW6gcwsUI8n6QVaAeVtmnd6elQumtnvh/soEVO1Wh8LazPwDr+KqrMyMzr8XC
         yP2gxgjGsT4OTFGaBVbkw1/JfW0FbbukRHStK3TvtxdAt2Oxz+giZ2bu0LDXVXIYSY5S
         Cq0g==
X-Gm-Message-State: AOAM533CgO96wvdgscXh3PZJ0yo2yGXYMqSq7eFJxPsWm/XIK4BqDZcY
        6lje3KVjPmKIOmx7o22p//KA2rwTTYcGCLoxK+w=
X-Google-Smtp-Source: ABdhPJzKKmmpwLgslxQbftmE1rF4LQIB+5ZnCIAA8J+cRpxAvZJWPIXBrx7q6RYrzNn73HKbR4OXMRPxB2QUodqeUUU=
X-Received: by 2002:a25:5084:: with SMTP id e126mr12426112ybb.475.1633320917481;
 Sun, 03 Oct 2021 21:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210929220600.3509089-1-bvanassche@acm.org> <20210929220600.3509089-58-bvanassche@acm.org>
In-Reply-To: <20210929220600.3509089-58-bvanassche@acm.org>
From:   Masanori Goto <gotom@debian.or.jp>
Date:   Mon, 4 Oct 2021 13:15:06 +0900
Message-ID: <CALZLnaGvqNujPZz4KOZ7-SRvoYc5EvPwM0u2i5iVe7=9yiV0kA@mail.gmail.com>
Subject: Re: [PATCH v2 57/84] nsp32: Call scsi_done() directly
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Indeed this is a no-op change, but in a different thread, one
interesting question raised was to remove scsi_done* in the argument
of queuecommand_lck, so that the change is much cleaner and generic.
Could you conduct a research on whether it's removal or not?  I'd like
to hear from the overall SCSI maintainer perspective too.
Also, I'm curious why the IOPS was improved - what kind of device
drives did you use?  Specifically, nsp32 was designed for PCI based
devices so it cannot handle millions of QPS - so this change has
unlikely an impact to the performance gain.  This comes back to the
first scsi_done question on whether this overall framework should be
changed or not.
