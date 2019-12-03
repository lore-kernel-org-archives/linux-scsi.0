Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483FAC43215
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 03:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2043B206DC
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 03:26:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=blockbridge-com.20150623.gappssmtp.com header.i=@blockbridge-com.20150623.gappssmtp.com header.b="uMRhepsM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLCD0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 22:26:40 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45605 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfLCD0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 22:26:39 -0500
Received: by mail-oi1-f196.google.com with SMTP id 14so1905097oir.12
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2019 19:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blockbridge-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LwpIDBucvKjpCN15l8CmiENKWiJ3fV7rlV+B6EGUY/Q=;
        b=uMRhepsMu54o9CknQNkBGlVn/d9qy8xO+eU0zmh4MITzbVKaCBeSRy+aJ/PP3/JOMQ
         n5zQiSfEKe35TPViuH2uRohl67uxsx9P1Z63dXSkXzveAEGVF3xEqnFY3reQYbHZJYB+
         5aGzLn+qzcY4WFFKjE9rRNtySBtfsawB08cY/e8Ajku/lxSAcuBkTvXYl6oRD5DcsB/x
         foQMpBqwsmXvd50oD3SNv8pgWLRUHRJxkNYN8+Arr6U3m++sENJzesJ54aDM9MWMYH+5
         XOrtAKD6WJhlLK9pU5XPW0pFlsZpN5E1C8XLc6mJTd8MG47+iMbtPDYjA1EdNeyToH26
         Xk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LwpIDBucvKjpCN15l8CmiENKWiJ3fV7rlV+B6EGUY/Q=;
        b=nVuQp+9eOSMGOhOE+znK+fJUer7lTERpFNKGqfktYvBnTCLAgGSS5fIM/Rc660kiqe
         cCmp8A2/wPnYrRHG+9neWwRZtIIEyjaL650RTQ2D9hEnClyFDmusrbztvJoRaJqEXci7
         hvRKXVwe3j7vFSQy0Wy7ecocyPKBYVf7qweDjsbUgBu2PqF+SeBJdSbVwUFyb/TEw/z+
         GDne84AJrzycCRDyjzeDakuDcP4+7TCXGPoVNiMfj6u370q2XSfDBIHNwr4geFZz8pFK
         kK2hjeAPmTVT3jDY5IhAvPDAGo5ly9EW5ulOz4Erg/x5LizGi7Qpj/Z2gvZXnuSiQKod
         jf+g==
X-Gm-Message-State: APjAAAWR5pKh36/25Bk5734ekPbF/gZe8UJ4QOXLGIBsqQ8NKicG8Q3b
        AY5OVqxSBbvf7ckiexQYF8pEzvffcQOjlRl6CdlFbA==
X-Google-Smtp-Source: APXvYqwz4mfuLXrSsp718O29itUq1yXjgDG5hOd8dyAdMUbt6utvr7bHWcM09Cww6W0Y6cXJadQ8xNl2lKC2MLvNsE0=
X-Received: by 2002:a05:6808:b2d:: with SMTP id t13mr2009175oij.83.1575343599018;
 Mon, 02 Dec 2019 19:26:39 -0800 (PST)
MIME-Version: 1.0
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p> <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p> <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p> <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p> <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p>
In-Reply-To: <20191203031444.GB6245@ming.t460p>
From:   Stephen Rust <srust@blockbridge.com>
Date:   Mon, 2 Dec 2019 22:26:28 -0500
Message-ID: <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
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

> oops, it should have been (arg4 & 511) != 0.

Yep, there they are:

# /usr/share/bcc/tools/trace -K 'bio_add_page ((arg4 & 511) != 0) "%d
%d", arg3, arg4'
PID     TID     COMM            FUNC             -
7411    7411    kworker/31:1H   bio_add_page     512 76
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

7753    7753    kworker/26:1H   bio_add_page     4096 76
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
