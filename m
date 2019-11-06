Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99EAC5DF64
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 16:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E622067B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 16:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfKFQDx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 11:03:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35414 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727028AbfKFQDx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 11:03:53 -0500
Received: (qmail 2942 invoked by uid 2102); 6 Nov 2019 11:03:52 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 6 Nov 2019 11:03:52 -0500
Date:   Wed, 6 Nov 2019 11:03:52 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Jens Axboe <axboe@kernel.dk>
cc:     Andrea Vai <andrea.vai@unipv.it>,
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
In-Reply-To: <61033407-731e-8cf5-8590-b07e2567693a@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 Nov 2019, Jens Axboe wrote:

> On 11/5/19 11:31 AM, Alan Stern wrote:
> > On Tue, 5 Nov 2019, Andrea Vai wrote:
> > 
> >> Il giorno lun, 04/11/2019 alle 13.20 -0500, Alan Stern ha scritto:
> > 
> >>> You should be able to do something like this:
> >>>
> >>>          cd linux
> >>>          patch -p1 </path/to/patch2
> >>>
> >>> and that should work with no errors.  You don't need to use git to
> >>> apply a patch.
> >>>
> >>> In case that patch2 file was mangled somewhere along the way, I
> >>> have
> >>> attached a copy to this message.
> >>
> >> Ok, so the "patch" command worked, the kernel compiled and ran, but
> >> the test still failed (273, 108, 104, 260, 177, 236, 179, 1123, 289,
> >> 873 seconds to copy a 500MB file, vs. ~30 seconds with the "good"
> >> kernel).
> >>
> >> Let me know what else could I do,
> > 
> > I'm out of suggestions.  If anyone else knows how to make a kernel with
> > no legacy queuing support -- only multiqueue -- issue I/O requests
> > sequentially, please speak up.
> 
> Do we know for a fact that the device needs strictly serialized requests
> to not stall?

Not exactly, but that is far and away the most likely explanation for
the device's behavior.  We tried making a bunch of changes, some of
which helped a little bit, but all of them left a very large
performance gap.  I/O monitoring showed that the only noticeable
difference in the kernel-device interaction caused by the $SUBJECT
commit was the non-sequential access pattern.

> And writes in particular?

Andrea has tested only the write behavior.  Possibly reading will be
affected too, but my guess is that it won't be.

> I won't comment on how broken
> that is, just trying to establish this as the problem that's making this
> particular device be slow?

It seems reasonable that the access pattern could make a significant
difference.  The device's behavior suggests that it buffers incoming
data and pauses from time to time to write the accumulated data into
non-volatile storage.  If its algorithm for allocating, erasing, and
writing data blocks is optimized for the sequential case, you can
easily imagine that non-sequential accesses would cause it to pause
more often and for longer times -- which is exactly what we observed.
These extra pauses are what resulted in the overall performance 
decrease.

So far we have had no way to perform a direct test.  That is, we don't
know of any setting that would change a single kernel between
sequential and non-sequential access.  If you can suggest a simple way
to force a kernel without the $SUBJECT commit to do non-sequential
writes, I'm sure Andrea will be happy to try it out and see if it
causes a slowdown.

> I've lost track of this thread, but has mq-deadline been tried as the
> IO scheduler? We do have support for strictly serialized (writes)
> since that's required for zoned device, wouldn't be hard at all to make
> this cover a blacklisted device like this one.

Please spell out the exact procedure in detail so that Andrea can try 
it.  He's not a kernel hacker, and I know very little about the block 
layer.

Alan Stern

