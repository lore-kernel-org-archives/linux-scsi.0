Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20A4C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 20:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 940302133F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 20:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389481AbfHWUmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 16:42:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39630 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2389217AbfHWUmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Aug 2019 16:42:09 -0400
Received: (qmail 5214 invoked by uid 2102); 23 Aug 2019 16:42:08 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 23 Aug 2019 16:42:08 -0400
Date:   Fri, 23 Aug 2019 16:42:08 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Andrea Vai <andrea.vai@unipv.it>
cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Slow I/O on USB media after commit f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <9b06f6f469ea535d336945992242e32b6524cb2b.camel@unipv.it>
Message-ID: <Pine.LNX.4.44L0.1908231449390.1628-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 23 Aug 2019, Andrea Vai wrote:

> Il giorno mar, 20/08/2019 alle 13.13 -0400, Alan Stern ha scritto:
> > On Mon, 19 Aug 2019, Andrea Vai wrote:
> > 
> > > Hi Alan,
> > >   I attach the two traces, collected as follows:
> > > 
> > > - start the trace;
> > > - wait 10 seconds;
> > > - plug the drive;
> > > - wait 5 seconds;
> > > - mount the drive;
> > > - wait 5 seconds;
> > > - copy a 500 byte file;
> > > - wait 5 seconds;
> > > - unmount the drive;
> > > - wait 5 seconds;
> > > - stop the trace.
> > 
> > Still no noticeable differences between the two traces.  They both 
> > include a 1.2 second delay shortly after the writing starts, and
> > the 
> > initialization sequences are the same.
> > 
> > I really don't know where to look for this.  The only thing I can
> > think
> > of at this point is to repeat this test, but using a file large
> > enough
> > for the difference in writing speed to show up plainly.
> > 
> > By the way, it would be best to run the tests with the smallest
> > possible number of other USB devices plugged in.  None at all, if
> > you
> > can arrange it.
> 
> Thanks, I went some steps further on this.
> The following considerations all apply to the "bad" kernel.
> 
> Increasing the filesize lead me to find out that using a file sized
> less than roughly 10MB the problem does not happen.
> 
> I found these results by making sets of 10 tries for each filesize,
> using a filesize of 1kB, 10kB, 100kB, 1MB, 10MB, 100MB, 500MB (so, we
> have 70 usbmon logs on these). If we define "fast" a copy that takes
> (roughly(*)) no more time to complete than all the other tries in its
> set, and "slow" elsewhere (=one or more tries in its set are
> (sensibly(*)) faster), I noticed that in each set with a filesize of
> 10MB or more the behavior can be very different: sometimes the copy is
> still "fast", sometimes is "slow". The frequency of the "slow" copies
> increases with the filesize. Also, among the "slow" copies in a set,
> the time can be very different.
> 
> Also, I found that if the file is not present on the target location
> (i.e. the USB pendrive), the problem does not happen (I have ten
> usbmon logs here, taken in the worst scenario (500MB filesize)).
> 
> Tell me which log(s) would you like me to send you: I can sum up here
> all the sets of tries, and the time their copies took to complete (in
> seconds):
> 
> 1kB: 26, 27, 26, 26, 27, 26, 26, 27, 26, 27
> 10kB: 27, 27, 26, 26, 27, 26, 27, 26, 27, 27
> 100kB: 26, 26, 26, 27, 26, 26, 26, 27, 27, 27
> 1MB: 26, 27, 27, 27, 27, 27, 27, 27, 27, 26
> 10MB: 27, 31, 37, 27, 38, 27, 39, 27, 30, 28
> 100MB: 32, 32, 144, 32, 145, 32, 123, 32, 153, 123
> 500MB: 56, 1396, 747, 131, 795, 764, 292, 1021, 807, 516
> 
> Also, note that the first copy is always "fast", because each file was
> initially not present on the pendrive. As said, I did one test of 10
> tries by deleting the file on the pendrive before copying it again,
> and the results are
> 
> 500MB: 56, 56, 57, 57, 56, 56, 60, 25***, 55, 56 (***Note the "fake"
> 25s, doesn't matter because I forgot to plug the pendrive :-/ )
> 
> I have made a script to semi-automate all the tests I have done. I
> attach the script here, so anyone interested could check it for any
> mistake (remember I am not very skilled so I may have wrote buggy
> code, done wrong assumptions, etc.). Please note that I decreased the
> time between the trace start and the drive plugging from 10s to 5s
> (simply to reduce the time needed to me to look at the countdown). Of
> course I can do again the test(s) you need with a bigger amount of
> $wait.
> 
> The script has been run with the command
> 
> # for k in {1..10}; do size=1000; ./test_usbmon $size && ping -a -c 5 8.8.8.8 ; done
> (example for 1kB filesize)
> 
> or, in the set of "delete before copy",
> 
> # for k in {1..10}; do size=500000000; ./cancellaTestFile $size && ./test_usbmon $size && ping -a -c 5 8.8.8.8 ; done
> 
> The ping command is there just to have a sound alarm when finished.
> 
> I also attach the script to delete the file ("cancellaTestFile").
> 
> I took care to plug the pendrive exactly at the end of the countdown,
> to keep the times in the logs more simple to detect and manage by you.
> 
> I have also logged all the terminal output log of the script.
> 
> Last note: I ran all the tests without any other USB device connected
> but the pendrive (well, actually there is a card reader connected to
> the internal USB connector, but on another bus. I didn't want to open
> the case and disconnect it but of course I can do it if needed).
> Thanks for pointing it out.
> 
> Thanks, and bye
> Andrea
> 
> (*) as an example, on a set that shows the total elapsed time in
> seconds being
> 
> 26, 27, 27, 27, 27, 27, 27, 27, 27, 26
> 
> I have assumed all of the copies to be "fast", while in the set
> 
> 32, 32, 144, 32, 145, 32, 123, 32, 153, 123
> 
> I have assumed 5 of the copies as "fast" (the ones that took 32
> seconds) and the other "slow". Not going to deepen in some standard
> deviation evaluation, etc., but if you'd like to I can provide some
> more scientific detailed data :-)

Wow, that sounds like a lot of work.

Let's start with the 39-second run for the 10-MB file.  If you can put 
the trace files on a server somewhere, available for downloading, that 
would avoid sending a lot of uninteresting data to the mailing list.

Odd that the delays never occur when you're writing a new file.  (If
nothing else, that gives you a way to work around the problem!)  It's
hard to say what it means, though.  Maybe the flash drive doesn't like 
overwriting used blocks.

Alan Stern

