From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb = ffff88006a338480
Date: Mon, 10 Nov 2008 15:18:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811101509040.2467-100000@iolanthe.rowland.org>
References: <20081110192403.GA605@ezra.hsd1.tn.comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35761 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751158AbYKJUSS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 15:18:18 -0500
In-Reply-To: <20081110192403.GA605@ezra.hsd1.tn.comcast.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian Kysela <brian.kysela@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 10 Nov 2008, Brian Kysela wrote:

> I tested with 2.6.27.5 and found that, although the process would hang as often
> as usual, it always recovered instead of needing to reboot. No kernel bug or
> system freeze, no climbing load avg, etc. Here is the usbmon output on a
> failed copy:
> 
> http://www.kysela.org/pub/4.mon.out
> 
> The syslog:
> 
> [ 1003.736201] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 1003.738949] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 1003.741886]  sdb1
> [ 1112.311917] end_request: I/O error, dev sdb, sector 667600
> [ 1112.311956] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.312038] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.312074] end_request: I/O error, dev sdb, sector 667840
> [ 1112.312121] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.312131] Buffer I/O error on device sdb1, logical block 512
> [ 1112.312137] lost page write due to I/O error on sdb1
> [ 1112.312159] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.312168] Buffer I/O error on device sdb1, logical block 576
> [ 1112.312172] lost page write due to I/O error on sdb1
> [ 1112.312181] Buffer I/O error on device sdb1, logical block 577
> [ 1112.312185] lost page write due to I/O error on sdb1
> [ 1112.312193] Buffer I/O error on device sdb1, logical block 578
> [ 1112.312198] lost page write due to I/O error on sdb1
> [ 1112.312211] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.312234] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.312247] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.379235] sd 6:0:0:0: rejecting I/O to offline device
> [ 1112.379640] FAT: unable to read inode block for updating (i_pos 9253)

This is essentially the same failure mechanism as before, but without
the timeout-related kernel bug.

There is a communications error during one of the reads.  It takes the
same form in both logs: A transfer receives only 4051 bytes when it
should get 4096.  Don't ask me why that happens; it's some sort of
hardware or firmware failure either in the drive or in your USB host
controller.

The kernel tries to recover, but it looks as though the drive is stuck 
trying to send the remaining bytes.  Resets don't help, so the drive 
is taken off-line.

You _might_ be able to prevent these problems by reducing the drive's 
max_sectors value, say to 128.  See

	http://www.linux-usb.org/FAQ.html#i5

No guarantees, though.

Alan Stern

