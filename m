Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF9FC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 10:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C9E214E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 10:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="dL1SG9/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKKKuy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 05:50:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36906 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKKux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 05:50:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id t1so14090439wrv.4
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 02:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Ulc0hnxpi87Lr8FUalzRyArJnedsSnF+Woyt7C2r5m4=;
        b=dL1SG9/9kP2mYzkV0eX8bDgfamaptCdSzbkQDOjY1N4J1lsclv9eKhS7uGgia6dIrw
         H/2V0ytIa59J7Kw2PBWz7aCcertcLxEfQImQ7YG/PCJaC0GrRTS9Y5TenUgz3gIoZDnF
         MZquTjxYbZphx0xK/1xMP9sAsCGfUnoPOJsJREP1895MNR/0nIWVfuex33PNK0FFaLdb
         KBPMFro0y7Tl0cx3nnUWBK6TMibiWL40JJuBvhUipEuF2iDLu/sqqO9LQsak5N+Z50MC
         gb1pvFLJ6WiE0rrmFVTug6CLYnGv+8gSmTnx2YNPdhz68eLf59KswFUI4D8ESd6rpb1b
         0XpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ulc0hnxpi87Lr8FUalzRyArJnedsSnF+Woyt7C2r5m4=;
        b=nfl/vA7xt4xUg+qz7xv5jCC4OAa5SfncT/rEkFz11v77XcgBFcOUy4guHTKfDM6mdQ
         nGF7Tq/j7io6/xL34OAq9oZ+Ipf2jDQv9moiwAkkOo8fu8ugyGkCQSdm9PblbUosG/3z
         IQS/LvJW5e9Kmg9KkgHeABDrbdXD2afKzDY1rKdsY+H5khCP3GGbQGKAb5eXzSbMix9G
         Wx+mcL7HreD0xa10Z/p/aaZiCQgEUZL0awpp+BbYsaHEmRcJX5SKV13nvg4ls8THbwSu
         P8t/4TMudUSSnWTz+4uqh+Va8hIXBuXqBFz9jVwlH4qkMChfEKv2fSFVHktaBpSMIzp/
         nHuQ==
X-Gm-Message-State: APjAAAVLISB3MVUsWDIudYDbTkd9M6QcGRpTRCUBpeIJdvbK5sTl05/i
        3SOUKsBwd5RKRaS1/SBJZnruSw==
X-Google-Smtp-Source: APXvYqwd16qITK7vEC/cIM3b3k0B7X8qNl/glbkK7P3XYLe5913+TW9S1vMEcras3KGvOjxutAUi7A==
X-Received: by 2002:adf:e78c:: with SMTP id n12mr18721260wrm.94.1573469451440;
        Mon, 11 Nov 2019 02:50:51 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id p1sm7108872wmc.38.2019.11.11.02.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 02:50:50 -0800 (PST)
Message-ID: <928d17b00c66caeef30410cf5a472056ae3722d4.camel@unipv.it>
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
Date:   Mon, 11 Nov 2019 11:50:49 +0100
In-Reply-To: <20191109222828.GA30568@ming.t460p>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
         <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
         <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
         <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
         <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
         <20191109222828.GA30568@ming.t460p>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno dom, 10/11/2019 alle 06.28 +0800, Ming Lei ha scritto:
> On Thu, Nov 07, 2019 at 07:59:44PM +0100, Andrea Vai wrote:
> > [Sorry for the duplicate message, it didn't reach the lists due to
> > html formatting]
> > Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal
> > <Damien.LeMoal@wdc.com> ha scritto:
> > >
> > > On 2019/11/07 16:04, Andrea Vai wrote:
> > > > Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha
> scritto:
> > > >>
> > > >>
> > > >> Please simply try your write tests after doing this:
> > > >>
> > > >> echo mq-deadline > /sys/block/<name of your USB
> > > >> disk>/queue/scheduler
> > > >>
> > > >> And confirm that mq-deadline is selected with:
> > > >>
> > > >> cat /sys/block/<name of your USB disk>/queue/scheduler
> > > >> [mq-deadline] kyber bfq none
> > > >
> > > > ok, which kernel should I test with this: the fresh git
> cloned, or the
> > > > one just patched with Alan's patch, or doesn't matter which
> one?
> > >
> > > Probably all of them to see if there are any differences.
> > 
> > with both kernels, the output of
> > cat /sys/block/sdh/queue/schedule
> > 
> > already contains [mq-deadline]: is it correct to assume that the
> echo
> > command and the subsequent testing is useless? What to do now?
> 
> Another thing we could try is to use 'none' via the following
> command:
> 
>  echo none > /sys/block/sdh/queue/scheduler  #suppose 'sdh' points
> to the usb storage disk
> 
> Because USB storage HBA is single hw queue, which depth is 1. This
> way
> should change to dispatch IO in the order of bio submission.
> 
> Andrea, could you switch io scheduler to none and update us if
> difference
> can be made?

Of course I would to it, but I see that with the "good" kernel the
output of "cat /sys/block/sdf/queue/scheduler" (yes, now it's sdf) is

noop deadline [cfq]

, i.e. it doesn't show "none". Does it matter? (sorry if it's a silly
question)

Thanks, and bye
Andrea


