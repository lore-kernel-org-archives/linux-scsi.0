Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D727C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 22:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F1160F35
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 22:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhGWWJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 18:09:10 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:52945 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhGWWJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2021 18:09:08 -0400
Received: by mail-pj1-f45.google.com with SMTP id m1so4253072pjv.2
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jul 2021 15:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6/cdYAUSMQxmdXNLa3YVrA7Ym4sXfqmzHi1j49qauX0=;
        b=pczJCw81Ei2FJH87LHR/VLOza79WYJoeGixhqu2zVMgQsHwNLwzhOX0Lc8lX6a7Uou
         txJuGDS+9olTt4xdIhUVPHvbq5+PlXupqC1N84F/WPCFKAV1yuo0Lzely7UArT8DLO6f
         CmfJUDaP+w2z+e1L3EDWm8ND7kRyl566XOeP9mnxNReOeznyfbYwDI9JWRWXeIAbXliK
         BcpDXafKR5GZD99nKQUp/hxf8GhPrXJM4Mt9uJYwdPu96qPM0f41Kn3IeIVtkTVPuFdD
         cPceEn2BUBZvuB5Eaice8wzTbt6AHiSF2kdDmsejtThu9AfhG59JTVj3YwyATPhiP0EP
         pZlg==
X-Gm-Message-State: AOAM533iUWZEB9onp/+fOVNXmYaVRFv/iP98sayaiBfZEj3dWMNUuPcz
        brgRaUA3x3Y2wBYe2Tt+yRY=
X-Google-Smtp-Source: ABdhPJxKO7SFdhPk9kkJDv9May2ZH1OE80IjKVjH3MMbXKUze6a03HbCxaEXMZa1WQI9x3LRx52Cbg==
X-Received: by 2002:a17:902:b188:b029:11b:1549:da31 with SMTP id s8-20020a170902b188b029011b1549da31mr5419628plr.7.1627080581537;
        Fri, 23 Jul 2021 15:49:41 -0700 (PDT)
Received: from garbanzo ([191.96.121.239])
        by smtp.gmail.com with ESMTPSA id c7sm37631134pgq.22.2021.07.23.15.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 15:49:40 -0700 (PDT)
Date:   Fri, 23 Jul 2021 15:49:38 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de
Subject: Re: [PATCH] scsi_debug: address races following module load
Message-ID: <20210723224938.l3j6ow3gzya4g4bu@garbanzo>
References: <20210508230745.27923-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508230745.27923-1-dgilbert@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, May 08, 2021 at 07:07:45PM -0400, Douglas Gilbert wrote:
> When scsi_debug is loaded as a module with many (simulated) hosts,
> targets, and devices (LUs), modprobe can take a long time to return.
> Only a small amount of this time is spent in the scsi_debug_init();
> the rest is other parts of the kernel reacting to to the appearance
> of new storage devices. As soon as scsi_debug_init() has completed
> the user space may call 'rmmod scsi_debug' and this was found to
> cause race problems as outlined here:
>     https://bugzilla.kernel.org/show_bug.cgi?id=212337
> 
> To reliably generate this race a sysfs parameter called rm_all_hosts
> was added and the code was strengthened in this area. The main
> change was to make the count of scsi_debug hosts present an atomic.
> Then it was found that the handling of the existing add_host
> parameter needed the same strengthening. Further:
>    echo -9999 > /sys/bus/pseudo/drivers/scsi_debug/add_host
> has the same effect as rm_all_hosts so rm_all_hosts was not needed.
> 
> To inhibit a race between two invocations of writes to add_host
> a mutex was added.
> 
> The logic to remove (all) hosts is rather crude: it works backwards
> down a linked lists of hosts. Any pending requests are terminated
> with DID_NO_CONNECT as are any new requests. In the case where not
> all hosts are being removed, the ones that remain may have lost
> requests as just outlined. The lowest numbered host (id) hosts will
> remain.
> 
> To distinguish between resets sent by the SCSI mid-level error
> handling and newly introduced devices (LUs), this Unit Attention:
>    power on, reset, or bus reset occurred [0x29,0x0]
> has been subdivided into that UA for the reset case and this new UA:
>    power on occurred [0x29,0x1]
> for the new device (LU) case. This makes debug a little easier to
> follow when it is turned on (e.g. 'echo 0x1 > opts').
> 
> 
> This patch should apply to lk 5.13.0-rc1 due out tomorrow unless some
> other patches have been applied to this driver that I'm unaware of.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

This is a lot of changes and it still does not address the issues on
the bugzilla bug report. For starts a loop on modprobe and rmmod fails.

We need udevadm settle (when availble) in between loads, and then the
removal simply needs to be patient. I'll be posting patches to fstests
which demonstrates this quite clearly.

I believe that... this is the way.

  Luis
