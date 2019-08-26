Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3033CC3A59F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 16:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D5D020874
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 16:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732170AbfHZQdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 12:33:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41108 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727261AbfHZQdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 12:33:22 -0400
Received: (qmail 5153 invoked by uid 2102); 26 Aug 2019 12:33:21 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 26 Aug 2019 12:33:21 -0400
Date:   Mon, 26 Aug 2019 12:33:21 -0400 (EDT)
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
In-Reply-To: <ba1d4fe53258c7a710174723c99e002a4d9eecb0.camel@unipv.it>
Message-ID: <Pine.LNX.4.44L0.1908261219060.1662-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 26 Aug 2019, Andrea Vai wrote:

> ok, so you can grab them at
> 
> http://fisica.unipv.it/transfer/usbmon_logs.zip
> 
> (they will be automatically removed from there in a couple of weeks).
> 
> For each size there is a .txt file (which contains the terminal
> output) and 10 bad.mon.out_.... trace files. The file suffix "NonCanc"
> means there has not been file deletion before copy; while "Canc" means
> the opposite.
> 
> Each trace file name is identified by a timestamp that is also
> referenced inside the txt, so if you want to get i.e. the 39-sec trial
> for the 10MB filesize you have to open the ...10MB....txt, search for
> the 39 seconds total time string ("Dopo stop trace: 39"), look at the
> beginning of that trial, a dozen rows before, take note of the
> timestamp, and open the corresponding bad.mon.out file (of course, if
> there are more trials with the same time, you have to identify it by
> counting its position (7th in the example above)).
> 
> To make it more simple:
> 
> $ seconds=39; size=10MB; grep -B14 "Dopo stop trace: $seconds" log_10trials_"$size"_NonCanc.txt
> 
> should show you more straightly the part(s) you need.
> 
> > Odd that the delays never occur when you're writing a new file.  (If
> > nothing else, that gives you a way to work around the problem!) 
> 
> Thank you, didn't realize that :-) I will try it.

In fact, even the traces where the file doesn't exist beforehand show 
some delays.  Just not as many delays as the traces where the file does 
exist.  And again, each delay is in the middle of a write command, not 
between commands.

I suppose changes to the upper software layers could affect which
blocks are assigned when a new file is written.  Perhaps one kernel
re-uses the same old blocks that had been previously occupied and the
other kernel allocates a completely new set of blocks.  That might
change the drive's behavior.  The quick way to tell is to record two
usbmon traces, one under the "good" kernel and one under the "bad"  
kernel, where each test involves writing over a file that already
exists (say, 50 MB) -- the same file for both tests.  The block numbers
will appear in the traces.

Also, I wonder if the changing the size of the data transfers would
make any difference.  This is easy to try; just write "64" to
/sys/block/sd?/queue/max_sectors_kb (where the ? is the appropriate
drive letter) after the drive is plugged in but before the test starts.

Alan Stern

