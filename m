Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68643C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 01:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41CD061076
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 01:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhJYBqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 21:46:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229604AbhJYBqc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Oct 2021 21:46:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635126250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N+DIrvZXbcAkXJ/OchXf+lha18HEJRfjUfzTN2XxsYY=;
        b=FKyndxWp+sbASCdTad6q/t5VpyYTOOA/8NB0GaEiKVIFksrhtQj8noyErj2/DPeOk/n1+L
        4sQhm5R0TNoX/8mZsFy8VWns4NIrD9XqSv2S3aOjnZLhnhgmOzlDmWz4RNB0hBo2JhQnd7
        sqgZ9TXT8yT3tBhi0L8tEyfLHmwPBOU=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-4EApigEQMLuFn5nX1vUjQg-1; Sun, 24 Oct 2021 21:44:09 -0400
X-MC-Unique: 4EApigEQMLuFn5nX1vUjQg-1
Received: by mail-yb1-f199.google.com with SMTP id f92-20020a25a465000000b005bea37bc0baso15247712ybi.5
        for <linux-scsi@vger.kernel.org>; Sun, 24 Oct 2021 18:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N+DIrvZXbcAkXJ/OchXf+lha18HEJRfjUfzTN2XxsYY=;
        b=Emah7LVoEImOIbpx2x3f8osTb60uCzx/M4/uSL/rPvWvZjkyoFbn9UF6mNK3StLR8s
         wSg9a9i3w6cCZccTCzAARZZwWjIf9Wbm9lkP5fGqRJjFxjcVKKSMCcGaig36jhixQg1E
         NE5r2YYYlMbK6Rx6D03AzuBkFK5al4rVIexquvOHZJCDe22cMAMQ7cJJCNQ9COtzrExU
         VDhyCC5DXfBt1zJ5zR/sivvlm/pgSicQ662SnW6MWlrDKGz9Wll4HXC+rS8QN/YX/tNQ
         VCBVojPX6+om+X8NqtJUCfxtckgInkonSQJiY85QPY64MCpMYxMIOEVzq8Go/yLivCsr
         WIfg==
X-Gm-Message-State: AOAM530L2iU6v1JdrzAH1hiKqblQQV8l1BvcbL7a0F5F2Ku6RFRACP6O
        q4oQbKDBh+OH8xqN52aWOKD24nIQQ/SJJswWTHfH87WBdGvJ+TvlTfbbt3MAQSChO1mFDUrCVdU
        nf7By3tDHibpvo/r1b5M1/0wwpWon6kzhZLNLBA==
X-Received: by 2002:a5b:18c:: with SMTP id r12mr14527340ybl.308.1635126248668;
        Sun, 24 Oct 2021 18:44:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXgAebb5EiOX8n3xGCGi7pF2GMyeviasxkrMIBZ4FLVtuGqvIhRrxVJyTEMj3M5GvFesVhioiqCJC2jL6JZ2s=
X-Received: by 2002:a5b:18c:: with SMTP id r12mr14527331ybl.308.1635126248542;
 Sun, 24 Oct 2021 18:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211021145918.2691762-1-ming.lei@redhat.com>
In-Reply-To: <20211021145918.2691762-1-ming.lei@redhat.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Mon, 25 Oct 2021 09:43:57 +0800
Message-ID: <CAHj4cs8QB7QCc7t+bweesdZPOLmAXrwrj8yEnAtJPk80L_v1kQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] block: keep quiesce & unquiesce balanced for scsi/dm
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Verified with the blktests srp/, thanks Ming.

Tested-by: Yi Zhang <yi.zhang@redhat.com>

On Thu, Oct 21, 2021 at 11:00 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> Hello Jens,
>
> Recently we merge the patch of e70feb8b3e68 ("blk-mq: support concurrent queue
> quiesce/unquiesce") for fixing race between driver and block layer wrt.
> queue quiesce.
>
> Yi reported that srp/002 is broken with this patch, turns out scsi and
> dm don't keep the two balanced actually.
>
> So fix dm and scsi and make srp/002 pass again.
>
>
> Ming Lei (3):
>   scsi: avoid to quiesce sdev->request_queue two times
>   scsi: make sure that request queue queiesce and unquiesce balanced
>   dm: don't stop request queue after the dm device is suspended
>
>  drivers/md/dm.c            | 10 ------
>  drivers/scsi/scsi_lib.c    | 70 ++++++++++++++++++++++++++------------
>  include/scsi/scsi_device.h |  1 +
>  3 files changed, 49 insertions(+), 32 deletions(-)
>
> --
> 2.31.1
>


-- 
Best Regards,
  Yi Zhang

