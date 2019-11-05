Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41A3C5DF62
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 18:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABA7F21925
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 18:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390626AbfKESbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 13:31:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45958 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2390482AbfKESbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 13:31:47 -0500
Received: (qmail 6231 invoked by uid 2102); 5 Nov 2019 13:31:46 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 5 Nov 2019 13:31:46 -0500
Date:   Tue, 5 Nov 2019 13:31:46 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Andrea Vai <andrea.vai@unipv.it>
cc:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
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
Subject: Re: Slow I/O on USB media after commit f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <0cd6ac36b7ab644576fc0f3f5bd4a880c33855d1.camel@unipv.it>
Message-ID: <Pine.LNX.4.44L0.1911051326040.1678-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 Nov 2019, Andrea Vai wrote:

> Il giorno lun, 04/11/2019 alle 13.20 -0500, Alan Stern ha scritto:

> > You should be able to do something like this:
> > 
> >         cd linux
> >         patch -p1 </path/to/patch2
> > 
> > and that should work with no errors.  You don't need to use git to 
> > apply a patch.
> > 
> > In case that patch2 file was mangled somewhere along the way, I
> > have 
> > attached a copy to this message.
> 
> Ok, so the "patch" command worked, the kernel compiled and ran, but
> the test still failed (273, 108, 104, 260, 177, 236, 179, 1123, 289,
> 873 seconds to copy a 500MB file, vs. ~30 seconds with the "good"
> kernel).
> 
> Let me know what else could I do,

I'm out of suggestions.  If anyone else knows how to make a kernel with 
no legacy queuing support -- only multiqueue -- issue I/O requests 
sequentially, please speak up.

In the absence of any responses, after a week or so I will submit a
patch to revert the f664a3cc17b7 ("scsi: kill off the legacy IO path")  
commit.

Alan Stern

