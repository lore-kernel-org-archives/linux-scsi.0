Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B545C432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 03:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1BA3206E0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 03:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=blockbridge-com.20150623.gappssmtp.com header.i=@blockbridge-com.20150623.gappssmtp.com header.b="K2rskJEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLCDEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 22:04:32 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41336 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLCDEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 22:04:32 -0500
Received: by mail-ot1-f68.google.com with SMTP id r27so1609315otc.8
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2019 19:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blockbridge-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2jnaclaqfzAkmDR3Cu1ofNJy4AR7awuVd0ddciKZbp4=;
        b=K2rskJEvIWjUrD7kECs4sxJuVEJ0IrqrDPEJmivCsLKd2q61VRzZ4iOf/cLlWWLYtu
         bStH58lVwxcAXOqcDri8Ynx0a0OjZ5cErIxedqGkcd0sG+L7kaGYe16tBlYcyqmHZKXz
         plGezh+ql6k/rQz9nO+1RH9/JPEupNQuauMba+CYjm3G1OtuvI0hjlPWLVgcpErX/M0y
         bHBqvGh5og5wXYw36GrBe2bDxanWqR4x7bPNraTpfAyfRLbYt08Fc03m4uN0M7Gh5Xjf
         ma7xw37wsoHIczYOhProLlTLlWsy03ts2m7sM7mGbSyv0eO4UJl1nJLHQ4oTjYoJgjey
         Z3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2jnaclaqfzAkmDR3Cu1ofNJy4AR7awuVd0ddciKZbp4=;
        b=Qs3/nvftQAE9SkVvV/7PGD/juvIe/7D4bHpsYkr9IdjBOHtbUIIgh4rC6WOKRiK0gG
         iBxBz8g4jVmArdEcE4RaKLvpK4ggQMh41geeC5zmabuG0ObOy4BJH3sblvPCY1gAO1s7
         l1odzk4F1ZjOIgO3Q+Ky+/4jD4JKSypylm58kGLBUqcNfC1q1r7DAX0QA732LgxtwtCH
         wpu8xxuX07GhBVSInEWLiZj0wfXw4nILSnhtzQpAhK6AiV0lwboAk763Wv23t2pCt2CH
         /M16cY7/20exFwzM8XaTI4LR2lA8YLjFt7oRFwYzqsXftl5adlLWvBN19/dHCXl184T/
         8WMQ==
X-Gm-Message-State: APjAAAUuDwdEeoCG4BfoxTIytNTUBP6ekhoG/HhcXSYneCbKiOv3Ijmz
        JBejV0durr7+EzeE9XXd7egUKT0YLaf3HpNh18Qotg==
X-Google-Smtp-Source: APXvYqxNlSvg3UaFUbLQWR0iK/r3j7Gv5v3hDDaubdyjaqiiJPDkc5/m2Wnctz7S8wlPdCcPH9M+N/idA6WzQ2daIGU=
X-Received: by 2002:a05:6830:4b9:: with SMTP id l25mr1808096otd.266.1575342271203;
 Mon, 02 Dec 2019 19:04:31 -0800 (PST)
MIME-Version: 1.0
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p> <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p> <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p> <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
In-Reply-To: <20191203005849.GB25002@ming.t460p>
From:   Stephen Rust <srust@blockbridge.com>
Date:   Mon, 2 Dec 2019 22:04:20 -0500
Message-ID: <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Rob Townley <rob.townley@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

The log you requested with the (arg4 & 512 != 0) predicate did not
match anything. However, I checked specifically for the offset of "76"
and came up with the following stack traces:

# /usr/share/bcc/tools/trace -K 'bio_add_page ((arg4 == 76)) "%d %d",
arg3, arg4 '
PID     TID     COMM            FUNC             -
7782    7782    kworker/19:1H   bio_add_page     512 76
        bio_add_page+0x1 [kernel]
        sbc_execute_rw+0x28 [kernel]
        __target_execute_cmd+0x2e [kernel]
        target_execute_cmd+0x1c1 [kernel]
        iscsit_execute_cmd+0x1e7 [kernel]
        iscsit_sequence_cmd+0xdc [kernel]
        isert_recv_done+0x780 [kernel]
        __ib_process_cq+0x78 [kernel]
        ib_cq_poll_work+0x29 [kernel]
        process_one_work+0x179 [kernel]
        worker_thread+0x4f [kernel]
        kthread+0x105 [kernel]
        ret_from_fork+0x1f [kernel]

14475   14475   kworker/13:1H   bio_add_page     4096 76
        bio_add_page+0x1 [kernel]
        sbc_execute_rw+0x28 [kernel]
        __target_execute_cmd+0x2e [kernel]
        target_execute_cmd+0x1c1 [kernel]
        iscsit_execute_cmd+0x1e7 [kernel]
        iscsit_sequence_cmd+0xdc [kernel]
        isert_recv_done+0x780 [kernel]
        __ib_process_cq+0x78 [kernel]
        ib_cq_poll_work+0x29 [kernel]
        process_one_work+0x179 [kernel]
        worker_thread+0x4f [kernel]
        kthread+0x105 [kernel]
        ret_from_fork+0x1f [kernel]

Thanks,
Steve

On Mon, Dec 2, 2019 at 7:59 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Mon, Dec 02, 2019 at 01:42:15PM -0500, Stephen Rust wrote:
> > Hi Ming,
> >
> > > I may get one machine with Mellanox NIC, is it easy to setup & reproduce
> > > just in the local machine(both host and target are setup on same machine)?
> >
> > Yes, I have reproduced locally on one machine (using the IP address of
> > the Mellanox NIC as the target IP), with iser enabled on the target,
> > and iscsiadm connected via iser.
> >
> > e.g.:
> > target:
> > /iscsi/iqn.20.../0.0.0.0:3260> enable_iser true
> > iSER enable now: True
> >
> >   | |   o- portals
> > ....................................................................................................
> > [Portals: 1]
> >   | |     o- 0.0.0.0:3260
> > ...................................................................................................
> > [iser]
> >
> > client:
> > # iscsiadm -m node -o update --targetname <target> -n
> > iface.transport_name -v iser
> > # iscsiadm -m node --targetname <target> --login
> > # iscsiadm -m session
> > iser: [3] 172.16.XX.XX:3260,1
> > iqn.2003-01.org.linux-iscsi.x8664:sn.c46c084919b0 (non-flash)
> >
> > > Please try to trace bio_add_page() a bit via 'bpftrace ./ilo.bt'.
> >
> > Here is the output of this trace from a failed run:
> >
> > # bpftrace lio.bt
> > modprobe: FATAL: Module kheaders not found.
> > Attaching 3 probes...
> > 512 76
> > 4096 0
> > 4096 0
> > 4096 0
> > 4096 76
>
> The above buffer might be the reason, 4096 is length, and 76 is the
> offset, that means the added buffer crosses two pages, meantime the
> buffer isn't aligned.
>
> We need to figure out why the magic 76 offset is passed from target or
> driver.
>
> Please install bcc and collect the following log:
>
> /usr/share/bcc/tools/trace -K 'bio_add_page ((arg4 & 512) != 0) "%d %d", arg3, arg4 '
>
>
> Thanks,
> Ming
>
