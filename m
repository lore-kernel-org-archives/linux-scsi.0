Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AC1C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 11:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B2EB21783
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 11:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="kQInzmaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfKKLNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 06:13:09 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36795 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKLNJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 06:13:09 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so14174725wrx.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 03:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=huepVau9eYwtL+cGD72B7PJ62OYK8YHlVG/n0gyRX58=;
        b=kQInzmaKutNdAOJ/yrXdo642ND2z7EloykAYSkti3D4LAnjAltx+u5SceqN4I8yY8Z
         jGhRGn8kJJjVIMq79PqkJYbh3ap2k6Zd2Ur96I0kqpplJChBY8b4377VdIquRxkb9vQ8
         Y0yTEVqNAN5kPhbZBIYghehhBRKLqEu0qvrSMs8rBlqYRz/80srP9L+kmpGkg732Vn7F
         YsISrjZgHuJR38wd8+QEq3iKsBDR04HZEBNAvg0QB4ukyuSbSk6DsK3OYO+OHazWh1z+
         2WQkIEXY1eb2zBzS8fWaJ0bqykiNz+nfA56MqBZi3ormWtr684df5jmAOnFOi8fqmjCE
         KWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=huepVau9eYwtL+cGD72B7PJ62OYK8YHlVG/n0gyRX58=;
        b=DvP9RgEvUNaWA734ivmIgNrYi9f90TCr6Az4zsDTLgg2VUy5Tyi94DvvYR2fcY3P9N
         JgI2a4Uro7KHPxzUCxOIVtnm9HBKBAEs/K/C6syqW/CORCxji/+fgiWbdFoMUhWBiaU2
         OgwYdCxCl04tKirBkwF1tx0cilUxmlAUoMlogRDYvrgcEKZaMoGspsDpSgVaHbK8Q22S
         40ODe+YuBytaVnN0tCToS+n2voDBfp6KAu484TfoBnMtMQVRqWZZ63I8pnt+pzrr3h16
         4q8CTW3Qc5HkKJJByJuOmJcAOKKeGgQ0Ef8q1EuC/0Xsrcjv2VCLZUJ0gEmnjVhsSVpq
         1mtA==
X-Gm-Message-State: APjAAAUtUhrxEgSU5sBpJdkG5obm0GZUmvagdjGatSAHH3eaQ6m2DmpZ
        HZ5fSEGXpPZ4L94XHDr+GHz5WQ==
X-Google-Smtp-Source: APXvYqygK+ckQKVRF2PLnKNkKlloC6R8mN1s4qRfqcce/aZc014V+/SiN6BmIrzM0xXUP0+liR+VmQ==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr5315860wrw.357.1573470785783;
        Mon, 11 Nov 2019 03:13:05 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id h205sm18230112wmf.35.2019.11.11.03.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 03:13:05 -0800 (PST)
Message-ID: <6732099548daec7b69afddb04887c5dba4af851d.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date:   Mon, 11 Nov 2019 12:13:04 +0100
In-Reply-To: <20191111110558.GA22228@ming.t460p>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
         <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
         <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
         <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
         <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
         <20191109222828.GA30568@ming.t460p>
         <928d17b00c66caeef30410cf5a472056ae3722d4.camel@unipv.it>
         <20191111110558.GA22228@ming.t460p>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno lun, 11/11/2019 alle 19.05 +0800, Ming Lei ha scritto:
> On Mon, Nov 11, 2019 at 11:50:49AM +0100, Andrea Vai wrote:
> > Il giorno dom, 10/11/2019 alle 06.28 +0800, Ming Lei ha scritto:
> > > On Thu, Nov 07, 2019 at 07:59:44PM +0100, Andrea Vai wrote:
> > > > [Sorry for the duplicate message, it didn't reach the lists
> due to
> > > > html formatting]
> > > > Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal
> > > > <Damien.LeMoal@wdc.com> ha scritto:
> > > > >
> > > > > On 2019/11/07 16:04, Andrea Vai wrote:
> > > > > > Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal
> ha
> > > scritto:
> > > > > >>
> > > > > >>
> > > > > >> Please simply try your write tests after doing this:
> > > > > >>
> > > > > >> echo mq-deadline > /sys/block/<name of your USB
> > > > > >> disk>/queue/scheduler
> > > > > >>
> > > > > >> And confirm that mq-deadline is selected with:
> > > > > >>
> > > > > >> cat /sys/block/<name of your USB disk>/queue/scheduler
> > > > > >> [mq-deadline] kyber bfq none
> > > > > >
> > > > > > ok, which kernel should I test with this: the fresh git
> > > cloned, or the
> > > > > > one just patched with Alan's patch, or doesn't matter
> which
> > > one?
> > > > >
> > > > > Probably all of them to see if there are any differences.
> > > > 
> > > > with both kernels, the output of
> > > > cat /sys/block/sdh/queue/schedule
> > > > 
> > > > already contains [mq-deadline]: is it correct to assume that
> the
> > > echo
> > > > command and the subsequent testing is useless? What to do now?
> > > 
> > > Another thing we could try is to use 'none' via the following
> > > command:
> > > 
> > >  echo none > /sys/block/sdh/queue/scheduler  #suppose 'sdh'
> points
> > > to the usb storage disk
> > > 
> > > Because USB storage HBA is single hw queue, which depth is 1.
> This
> > > way
> > > should change to dispatch IO in the order of bio submission.
> > > 
> > > Andrea, could you switch io scheduler to none and update us if
> > > difference
> > > can be made?
> > 
> > Of course I would to it, but I see that with the "good" kernel the
> > output of "cat /sys/block/sdf/queue/scheduler" (yes, now it's sdf)
> is
> > 
> > noop deadline [cfq]
> 
> Not sure if cfq makes a difference, and I guess you may get same
> result
> with noop or deadline. However, if you only see good write
> performance with
> cfq, you may try 'bfq' and see if it works as cfq.
> 
> > 
> > , i.e. it doesn't show "none". Does it matter? (sorry if it's a
> silly
> > question)
> 
> We are talking about new kernel in which there can't be 'noop
> deadline [cfq]'
> any more. And you should see the following output from
> '/sys/block/sdf/queue/scheduler'
> in the new kernel:
> 
> 	[mq-deadline] kyber bfq none
> 
> 

ok sorry I misunderstood, assumed you wanted me to compare the "none"
setting in the old kernel with the same setting in the new kernel. Now
it's clear to me that you want me to compare the different scheduler
settings in the new kernel.

Thanks, and bye
Andrea

