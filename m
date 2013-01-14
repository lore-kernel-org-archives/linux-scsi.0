From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: xhci problem
Date: Mon, 14 Jan 2013 13:37:26 -0800
Message-ID: <20130114213726.GA7735@xanatos>
References: <1354670910.2610.7.camel@66-152-109-61.tvc-ip.com>
 <20121205172451.GA5324@xanatos>
 <1358087698.27952.7.camel@66-152-109-61.tvc-ip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54656 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab3ANVh0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2013 16:37:26 -0500
Content-Disposition: inline
In-Reply-To: <1358087698.27952.7.camel@66-152-109-61.tvc-ip.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allan Dennis <aldennis@rogers.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Sun, Jan 13, 2013 at 09:34:58AM -0500, Allan Dennis wrote:
> I left this problem for awhile, then finally got back to it. I upgraded
> the gentoo kernel to 3.6.11 and was partially successful: the 3TB drive
> mounted ok, but then had some serious trouble transferring files and I
> believe that linux force-unmounted it as a result.
> Then upgrading to 3.7.1 fixed the problem completely. Here is the dmesg
> output now:

Good to hear that upgrading helped.

It would be nice to know which commit fixed your issue, so that we can
make sure any Linux distributions include it in their stable releases.
Do you have time to git bisect the changes between 3.6 and 3.7?

Sarah Sharp

> [    4.787051] scsi 7:0:0:0: Direct-Access     ST330006 51AS
> CC45 PQ: 0 ANSI: 0
> [    4.787176] sd 7:0:0:0: Attached scsi generic sg2 type 0
> [    4.787416] sd 7:0:0:0: [sdc] Very big device. Trying to use READ
> CAPACITY(16).
> [    4.787998] sd 7:0:0:0: [sdc] 5860533168 512-byte logical blocks:
> (3.00 TB/2.72 TiB)
> [    4.788405] sd 7:0:0:0: [sdc] Write Protect is off
> [    4.788408] sd 7:0:0:0: [sdc] Mode Sense: 03 00 00 00
> [    4.788886] sd 7:0:0:0: [sdc] No Caching mode page present
> [    4.788888] sd 7:0:0:0: [sdc] Assuming drive cache: write through
> [    4.789246] sd 7:0:0:0: [sdc] Very big device. Trying to use READ
> CAPACITY(16).
> [    4.790420] sd 7:0:0:0: [sdc] No Caching mode page present
> [    4.790424] sd 7:0:0:0: [sdc] Assuming drive cache: write through
> [    4.841399]  sdc: sdc1
> [    4.841883] sd 7:0:0:0: [sdc] Very big device. Trying to use READ
> CAPACITY(16).
> [    4.843331] sd 7:0:0:0: [sdc] No Caching mode page present
> [    4.843334] sd 7:0:0:0: [sdc] Assuming drive cache: write through
> [    4.843336] sd 7:0:0:0: [sdc] Attached SCSI disk
> 
> Thanks for your help!
> 
> On Wed, 2012-12-05 at 09:24 -0800, Sarah Sharp wrote:
> > On Tue, Dec 04, 2012 at 08:28:30PM -0500, Allan Dennis wrote:
> > > I hope you won't be annoyed by my question... here goes:
> > 
> > It's my job to answer questions, so fire away. :)
> > 
> > > I have 2TB and 3TB SATA drives, both connected to my Intense PC (Ivy
> > > Bridge tiny PC) on separate external drive enclosures on USB 3 cables. I
> > > have gentoo linux, and was running kernel 3.4.9 where both drives
> > > weren't recognized properly. Now I updated to 3.5.7 and the 2TB is good
> > > to go (yay!) but the 3TB guy is still giving me problems. Here is the
> > > dmesg output as I plugged in the 3TB (sdc) after the 2TB (sdb) was
> > > successful, with debug enabled in the kernel config. Is this a known
> > > issue? Can I help you figure out what's going wrong here by providing
> > > logs or whatnot?
> > 
> > I can't see anything wrong on the xHCI side, so I suspect the problem
> > might be that the SCSI layer doesn't like some response the hard drive is
> > sending.  I would suggest you take a usbmon trace, following the
> > directions here:
> > 
> > http://lxr.linux.no/#linux/Documentation/usb/usbmon.txt
> > 
> > Please hit 'reply-all' when you send the trace, since I've Cced the
> > linux-usb and usb-storage mailing lists.
> > 
> > Sarah Sharp
> 
