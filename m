Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A36C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 10:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AE3020856
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 10:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="Tu38d6k7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKKKqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 05:46:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40159 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfKKKqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 05:46:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id i10so14049061wrs.7
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 02:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yxRDzZD0x5jD7UV3+6FgosgP6nkWD8N7G9X6bEPt3Ko=;
        b=Tu38d6k7Kks+jbAkbbo/OmauYHik4AILQ5Y/vMGRYIxYmJXSBQUMT31+rWKpB8n5C+
         tzW7pQ2VBLpQr7W/IRcsXy2+2ofxFz49LK4wk4TIKJwTnqGExvFmjQ6x5NwmR2GsgVE/
         OhEKZ6KCX4TNbqXG3Zk0Y7ijGbW5Wtodg5sBNY/HxvUat1oMQlLr9n8jw60jFI3TATxV
         KAPF7mE/JMtDxDlQOzIXD76pvW+iVkurq16aOnThc/JVc3OyfyjWso0irPU8djwKiPh+
         nrg/srnzANwefFwC2rqwpa5/9jhzkRGsNSMNRnVae66vvTWuLmNQIc0ac7Y8RWOS0laK
         tjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yxRDzZD0x5jD7UV3+6FgosgP6nkWD8N7G9X6bEPt3Ko=;
        b=Nb8fTmtE4ifaaVK+PaWV56X9TbyhkuZo3k7HCEFPcPc/mBo9uCh5IiCt+6VUaQEGGo
         6K3qGuIBNqiSfYHui1NlgxGnzU6ZSft7m5Zi2rylyYoXEvUqLyjVycfNegCHD1L/6A5x
         jcSXDPDuCogquyBlGKmq6k3qDM4KE6uIO6y1L9ekaYHSr2OP5Gbg95bg2s1NHq7GQCg7
         1pFynFVp0UxWTpWL9HphRnv+7VOABkzk/AS3XosOZvF4Dkqz2p58xgFObsBaQH+pGMJ7
         xv9oPkTOIq8OOj9+CMMSnhIeAbYqFLaEmyMQn1JqL26/5qP2N7dLNFv+zozPsk9n+XW9
         rrUA==
X-Gm-Message-State: APjAAAXmOtox7ngDx9/kqktvvohBhhBTng0NQxHmxCIL5Fun7nJSSsOd
        bL7rCMwZODPxdbnR04gpTfQ9UA==
X-Google-Smtp-Source: APXvYqxqlbmvGsUuWvUwKyWh56kj/hB+AZN1goluANcijZ7NQ7eKypL+NIUquzFnIJw7f56MBUSAmw==
X-Received: by 2002:a5d:4585:: with SMTP id p5mr20987500wrq.134.1573469173805;
        Mon, 11 Nov 2019 02:46:13 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id w18sm14288552wrl.2.2019.11.11.02.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 02:46:13 -0800 (PST)
Message-ID: <83c6176bf08d52bf71a4635d62a1c2c4ad97a88d.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date:   Mon, 11 Nov 2019 11:46:12 +0100
In-Reply-To: <72fc7fd1-cf86-969c-d1ed-36201cf9510a@kernel.dk>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
         <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
         <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
         <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
         <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
         <BYAPR04MB5816ECD4302AD94338CB9072E77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
         <72fc7fd1-cf86-969c-d1ed-36201cf9510a@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno ven, 08/11/2019 alle 07.33 -0700, Jens Axboe ha scritto:
> On 11/8/19 1:42 AM, Damien Le Moal wrote:
> > On 2019/11/08 4:00, Andrea Vai wrote:
> >> [Sorry for the duplicate message, it didn't reach the lists due
> to
> >> html formatting]
> >> Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal
> >> <Damien.LeMoal@wdc.com> ha scritto:
> >>>
> >>> On 2019/11/07 16:04, Andrea Vai wrote:
> >>>> Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha
> scritto:
> >>>>>
> >>>>>
> >>>>> Please simply try your write tests after doing this:
> >>>>>
> >>>>> echo mq-deadline > /sys/block/<name of your USB
> >>>>> disk>/queue/scheduler
> >>>>>
> >>>>> And confirm that mq-deadline is selected with:
> >>>>>
> >>>>> cat /sys/block/<name of your USB disk>/queue/scheduler
> >>>>> [mq-deadline] kyber bfq none
> >>>>
> >>>> ok, which kernel should I test with this: the fresh git cloned,
> or the
> >>>> one just patched with Alan's patch, or doesn't matter which
> one?
> >>>
> >>> Probably all of them to see if there are any differences.
> >>
> >> with both kernels, the output of
> >> cat /sys/block/sdh/queue/schedule
> >>
> >> already contains [mq-deadline]: is it correct to assume that the
> echo
> >> command and the subsequent testing is useless? What to do now?
> > 
> > Probably, yes. Have you obtained a blktrace of the workload during
> these
> > tests ? Any significant difference in the IO pattern (IO size and
> > randomness) and IO timing (any device idle time where the device
> has no
> > command to process) ? Asking because the problem may be above the
> block
> > layer, with the file system for instance.
> 
> blktrace would indeed be super useful, especially if you can do that
> with a kernel that's fast for you, and one with the current kernel
> where it's slow.
> 
> Given that your device is sdh, you simply do:
> 
> # blktrace /dev/sdh
> 
> and then run the test, then ctrl-c the blktrace. Then do:
> 
> # blkparse sdh > output
> 
> and save that output file. Do both runs, and bzip2 them up. The
> shorter
> the run you can reproduce with the better, to cut down on the size
> of
> the traces.

Sorry, the next message from Ming...

-----
You may get the IO pattern via the previous trace 
https://lore.kernel.org/linux-usb/20190710024439.GA2621@ming.t460p/

IMO, if it is related write order, one possibility could be that
the queue lock is killed in .make_request_fn().
-----

...made me wonder if I should really do the blkparse trace test, or
not. So please confirm if it's needed (testing is quite time-consuming 
, so I'd like to do it if it's needed).

Thanks, and bye,
Andrea

