Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD12C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 17:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13AFF60F8F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 17:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhG0Rog (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 13:44:36 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:41503 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhG0Rof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 13:44:35 -0400
Received: by mail-pl1-f177.google.com with SMTP id e14so16655738plh.8
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 10:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VK0/9Ob3fBKoo4DvB8cBPNroKPlPPiQ2FfwX7Hps2Os=;
        b=AGPvSzWtw1IsLXNr7uh+OGQ2x34efmxbZUhM+wVilWnhz+DdiTu1Lb5UPpXlAjqj9s
         OTWGJlLtpUNLHXlFdxQWEuaHP2pZz3tGylv8jQwof6KbsX5R9l+TFE0QsEcxjsE9V8pT
         /Uh5ChuWFPtZp2cZm63AD9JNQFMdKJS6DjAkl7aRt/GKngUHrWsut9KvOWb9r8hEvQhj
         TJliGj05h22mBxyVXgGdpvl8tVvbKB505aB+1hto51CBT6o0A4AdggK6CCcUWslmd7qu
         oY+RH3htwWo3AXStwcxu2Ty49P8/mOTZnGtkLTS5Bo0Uum2u1rWninb9mT85pNO+c3+i
         +1Qw==
X-Gm-Message-State: AOAM530wgPOtYjs1pmU1MZwG5zaTTvQi1UsGVajR1QI5SEbvRiT2rFUw
        HxTBFKCSV66KaXum/UEfpWM=
X-Google-Smtp-Source: ABdhPJzRh96LrTidQgF/R3LrFYfEDnbRvkOm7RggCkaTZmdeVzKMBIOqgtni21X88OU+IY382cdBrg==
X-Received: by 2002:a65:6441:: with SMTP id s1mr24128897pgv.214.1627407873890;
        Tue, 27 Jul 2021 10:44:33 -0700 (PDT)
Received: from garbanzo ([191.96.121.85])
        by smtp.gmail.com with ESMTPSA id 123sm4371703pfz.24.2021.07.27.10.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:44:33 -0700 (PDT)
Date:   Tue, 27 Jul 2021 10:44:30 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        David Laight <David.Laight@aculab.com>,
        Jessica Yu <jeyu@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
Subject: Re: [PATCH] scsi_debug: address races following module load
Message-ID: <20210727174430.cpt3bzi7p5v4gsec@garbanzo>
References: <20210508230745.27923-1-dgilbert@interlog.com>
 <20210723224938.l3j6ow3gzya4g4bu@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723224938.l3j6ow3gzya4g4bu@garbanzo>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 23, 2021 at 03:49:41PM -0700, Luis Chamberlain wrote:
> On Sat, May 08, 2021 at 07:07:45PM -0400, Douglas Gilbert wrote:
> > When scsi_debug is loaded as a module with many (simulated) hosts,
> > targets, and devices (LUs), modprobe can take a long time to return.
> > Only a small amount of this time is spent in the scsi_debug_init();
> > the rest is other parts of the kernel reacting to to the appearance
> > of new storage devices. As soon as scsi_debug_init() has completed
> > the user space may call 'rmmod scsi_debug' and this was found to
> > cause race problems as outlined here:
> >     https://bugzilla.kernel.org/show_bug.cgi?id=212337
> > 
> > To reliably generate this race a sysfs parameter called rm_all_hosts
> > was added and the code was strengthened in this area. The main
> > change was to make the count of scsi_debug hosts present an atomic.
> > Then it was found that the handling of the existing add_host
> > parameter needed the same strengthening. Further:
> >    echo -9999 > /sys/bus/pseudo/drivers/scsi_debug/add_host
> > has the same effect as rm_all_hosts so rm_all_hosts was not needed.
> > 
> > To inhibit a race between two invocations of writes to add_host
> > a mutex was added.
> > 
> > The logic to remove (all) hosts is rather crude: it works backwards
> > down a linked lists of hosts. Any pending requests are terminated
> > with DID_NO_CONNECT as are any new requests. In the case where not
> > all hosts are being removed, the ones that remain may have lost
> > requests as just outlined. The lowest numbered host (id) hosts will
> > remain.
> > 
> > To distinguish between resets sent by the SCSI mid-level error
> > handling and newly introduced devices (LUs), this Unit Attention:
> >    power on, reset, or bus reset occurred [0x29,0x0]
> > has been subdivided into that UA for the reset case and this new UA:
> >    power on occurred [0x29,0x1]
> > for the new device (LU) case. This makes debug a little easier to
> > follow when it is turned on (e.g. 'echo 0x1 > opts').
> > 
> > 
> > This patch should apply to lk 5.13.0-rc1 due out tomorrow unless some
> > other patches have been applied to this driver that I'm unaware of.
> > 
> > Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> This is a lot of changes and it still does not address the issues on
> the bugzilla bug report. For starts a loop on modprobe and rmmod fails.
> 
> We need udevadm settle (when availble) in between loads, and then the
> removal simply needs to be patient.

This is a curious overstatement in my testing now but in subtle ways.
The skinny is that this helps *older* kernels when the refcnt is 0.

Turns out that although for linux-next your patch really rarely makes a
difference, on older kernels (by backporting it mysef, say a 5.3
kernel), I see the benefit to your patch when the module refcnt is 0 and
after fstests generic/108 on xfs. Without your patch even if refcnt is 0
you must wait over 6 seconds before you can issue an rmmod if you want
it to suceed with a failure rate of about 1/1026.

In cooking up my fstests patches then, what would be helpful is if you
modified your patch so that it introduces a u32 debugfs file which
userspace can then query if it exits. It would use this to tell if the
quiescing effort is present. Since, this is likely to get better over time,
perhaps have it reflect a version for improvements.

This way if this patch is *not* merged, we'd have to sleep for over 6
seconds if you want a higher failure rate on certain tests.

That said, looking at test generic/108 on v5.3 with xfs with the
xfs_nocrc_512 configuration (-m crc=0,reflink=0,rmapbt=0, -i sparse=0,
-b size=512) should give you an idea of what might be left to do, so
that delays before rmmod can be trimmed further.

To be clear: the delays *are not* needed on linux-next, but on older
kernels they are. This might be telling of some races possible on older
kernels where module removal is *not* possible even though the refcnt is 0.

I'll mention this on my fstests patches.

  Luis
