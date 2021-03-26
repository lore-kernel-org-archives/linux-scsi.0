Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DDAC433C1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBEDD61999
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCZR0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 13:26:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhCZR0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Mar 2021 13:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616779560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eSimQk1UkQd/npdHzS0kNqGjrmQbWu2DRS90FhXwa8s=;
        b=gYkcXIc5tODNiXjomVHxQU+ED0NZSWIuz9UtID9Te3ujPe9dTa3V1gl8YquLPWnWKlWB9M
        6fz6oM2fEcnN0nKZd3iA4Rqz6xK6Y/Ew/1cupURY8ZyaibqoA8N7RVBAaOOYbbxg5YvZN8
        rpEmOO/95PdD2Ffz250hmUOSck84LMY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-vEy5bvU1OWKpuh0DX59MRA-1; Fri, 26 Mar 2021 13:25:28 -0400
X-MC-Unique: vEy5bvU1OWKpuh0DX59MRA-1
Received: by mail-qt1-f200.google.com with SMTP id m11so5575379qtx.19
        for <linux-scsi@vger.kernel.org>; Fri, 26 Mar 2021 10:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eSimQk1UkQd/npdHzS0kNqGjrmQbWu2DRS90FhXwa8s=;
        b=DWjdXdVP2CLFagoXxHTTne3SLs40Z3USTjd/kMuiPBdfuk99ZxemQakr4yu5us3lg/
         FiJyYZNwcE3CuKgp/9UzPB2ggn+05nF6rSCzluP6xKmgQTeT7eVeaFgVUncBOb60Ld1q
         miicRXAji1dbkDYXKRTM9wqJt7CCwbCK+L7yvc5/7ujRfcNds+Q+WhOWERd9IIBO7o8J
         zQqVDZguJPo831RFeUs9kF8VksMGLK6/gLP8xwvVaBR2+X7DNmpGbn6JqNWJE64Qf7of
         W6v3lpq73e8hit/Tmk4XdsyWumEbwCTOegPA3iiGNOPV7AByHwJyeTuGANnE2amgTq5S
         RqVw==
X-Gm-Message-State: AOAM5327PGwhP+jWI1r1lrHJ/UmygL4uXBW1GtFJF2GRMpJ4+50SJJm4
        d5C3goNVkZI5h1EwjPs+AJte36Iu/0CvLcIVREBDULuBkUI6Edjra99PttYMncCQEtgY8z4CH28
        IDu29/zDgE+UixJAoDqsOew==
X-Received: by 2002:a0c:f6cd:: with SMTP id d13mr14127155qvo.20.1616779528008;
        Fri, 26 Mar 2021 10:25:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpoiuFdx+xNnHMeUC06rzOWX6ZxKm00bLQ0K8CaP1my1XsXTcHxTv5Huk9DnkxTOloKdrKew==
X-Received: by 2002:a0c:f6cd:: with SMTP id d13mr14127124qvo.20.1616779527664;
        Fri, 26 Mar 2021 10:25:27 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id j6sm7047582qkm.81.2021.03.26.10.25.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:25:27 -0700 (PDT)
Message-ID: <1db1cb3630afceb6656bbd1141ece3b249f74150.camel@redhat.com>
Subject: Re: Isssues with very large LUN count servers and booting becoming
 more and more of a problem
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>,
        "Van Assche, Bart" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>
Date:   Fri, 26 Mar 2021 13:25:26 -0400
In-Reply-To: <582d9b45-0d4b-d888-d648-9a59263e633d@suse.de>
References: <fa08c1edd1aeede6d5c8109b8a473120cca5e35b.camel@redhat.com>
         <0d042d7604e57b8cdd3fe4a0a6914e6ab1d7c85c.camel@redhat.com>
         <582d9b45-0d4b-d888-d648-9a59263e633d@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-03-26 at 16:08 +0100, Hannes Reinecke wrote:
> On 3/25/21 1:28 AM, Laurence Oberman wrote:
> > On Mon, 2021-03-22 at 17:02 -0400, Laurence Oberman wrote:
> > > Hello
> > > We have been struggling with this for years.
> > > Systems are getting so large now that a system with multi-
> > > terabyte
> > > memory and 1000's of device paths is becoming common.
> > > 
> > > For example, customers are seeing 16 paths and with a 1000 LUNS
> > > thats
> > > 16000 multiline console log discovery etc.
> > > 
> > > We land up in Emergency mode and various incatanations of "cant
> > > boot"
> > > due to console putput slowdown that (while worse on serial
> > > consoles)
> > > is
> > > still huge overhead that can even require us to use
> > > watchdog_thresh
> > > on
> > > the kernel line to prevent the NMI's
> > > 
> > > I started thinking about a new parameter for scsi_mod that could
> > > be
> > > used by sd and the scsi_dh_alua probing / discovery messaging
> > > (that
> > > is
> > > so noisy), to quieten it down.
> > > 
> > > Before I even put efort into this, I wanted to see if you folks
> > > have
> > > an
> > > appetite for this.
> > > 
> > > We have been blacklisting HBA drivers and using verious printk
> > > masks
> > > etc to overcome this but a way to mask this within sd.c and
> > > scsi_dh_alua.c I think could work better.
> > > It would not be the default of course but an option to be added
> > > for
> > > these huge customers.
> > > I would look do do the minimal logging for a device discovery,
> > > just
> > > so
> > > some messaging is there for debug etc and I think it will help.
> > > 
> > > If this is a crazy idea, let me know and I wont pursue it, but I
> > > decided to just put it out there.
> > > 
> > > Best Regards
> > > Laurence Oberman
> > > 
> > 
> > Replying to my own thread with more information
> > 
> > RFE: Introduce two new macros to manage the crazy amount of boot
> > logging we get with the large LUN count systems
> > 
> > sd_printk_boot_control
> > sdev_printk_boot_control
> > 
> > These macros have an extra parameter boot_log_enable and if its
> > default
> > (1) then logs are printed
> > adding scsi_mod.scsi_alua_boot_logging=0 will quiet down the
> > logging
> > for these huge systems
> > 
> > With no parameter (default) nothing changes in the logging
> > 
> > With boot log control and regular console
> > 134s to boot and 1987 lines with 80 devices and 2 paths
> > 
> > With no boot control (default) and regular console
> > 170s to boot and about 4000 lines of logging
> > 
> > The patch inline is not final so I did not send with git given this
> > is
> > an RFE.
> > t is included to show the changes I was thinking about.
> > 
> 
> Well, _actually_ it's not just the SCSI drivers; it's just that the
> scsi 
> driver exhibits these issues nicely.
> 
> The hope I had was that we can resolve this issue by making printk 
> asynchrounous, such that each call to printk() wouldn't block.
> 
> The really should give us most what we want; the only issue is what
> to 
> do with those messages which are spooled (but not printed).
> For graphical UI this probably doesn't matter as the user will end
> up 
> with a graphical interface sooner or later.
> 
> For text console things become tricky; we will need the console to
> get 
> our prompt, but it might still be busy printing out stuff.
> 
> Can't we have a 'low priority' output of these messages, and stop 
> printing them to the console once 'getty' starts?
> 
> Thing is, once 'getty' is up and running the user _can_ log in, so
> he 
> can any debugging he likes from the system console; there the
> message 
> log on the console is less important as the user can get the system
> log 
> via other means.
> It only gets important once getty is _not_ up, but then it's less
> time 
> critical as there's nothing the user _can_ do.
> 
> Thoughts?
> 
> Cheers,
> 
> Hannes

Hi Hannes

Indeed I use scsi as the example because for these Enterprise
Production environments, that is the single biggest consumer of the
messaging.
That and the alua messages.

We have two issues.
1. systems stopping in emergency mode because LVM times out during all
the discovery, and in cases device-mapper-multipath devices also not
coming ready.

2. Hard lockups due to both the serial and VGA slow consolw code where
the logging and discovery is writing to console. has a lock and then
the lock ownership access exceeds the watchdog_thresh 

If we could prevent the logging until all the switchroot stuff happens
and the systems have scanned and onlined the LVM and device-mapper
stuff etc., then changing the priority may work. 

The problem only delaying the output is that it wont solve the hard
lockup due to the console code slowing down tasks writing to it so they
exceeds the 10s default for watchdog_thresh. I had to use 30 or 60 in
certain cases even with a VGA console and still hit the hard lockup.
Using modprpbe after boot the systems are up  one at a time for say
qla2xxx and lpfc we seem to handle the logging without triggering the
watchdog.

Of course the question then becomes what are we missing for debugging
with the silence. In the patch I showed as an example, I was selective
about what I left out but I do log the disk being attached for example.

Its a tough problem to solve. The console code is not going to be fixed
to make it scale better for some time, although I know folks are
working on it.

I sent a patch some time back that we use quite often now to increase
the watchdog_thresh on the kernel line but my DL980 and these other
Giant HPE Superdomes etc. still see hardlockups not only during boot
but sometimes just in error recovery when rports leave and a giant log
storm happens when they recover.

I just figured what I am doing is the lowest risk and could be re-
enabled once up witha simple echo command so we dont miss anything
after boot.

I will think about this some more 
I do appreciate the comments and discussion.

Regards
Laurence

