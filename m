From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [BISECTED] v4.4-rc1 SCSI disk init crash
Date: Thu, 19 Nov 2015 22:29:54 +0200
Message-ID: <20151119202953.GE18138@blackmetal.musicnaut.iki.fi>
References: <20151119192135.GD18138@blackmetal.musicnaut.iki.fi>
 <564E28DE.6010200@sandisk.com>
 <1447963712.2234.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:48335 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934374AbbKSUai (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2015 15:30:38 -0500
Content-Disposition: inline
In-Reply-To: <1447963712.2234.31.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi,

On Thu, Nov 19, 2015 at 12:08:32PM -0800, James Bottomley wrote:
> On Thu, 2015-11-19 at 11:54 -0800, Bart Van Assche wrote:
> > On 11/19/2015 11:22 AM, Aaro Koskinen wrote:
> > > [    2.702105] scsi 0:0:0:0: Direct-Access     Ext Hard  Disk                 PQ: 0 ANSI: 5
> > > [    2.714214] sd 0:0:0:0: [sda] Spinning up disk...
> > > [    3.720503] ...
> > > [    6.674040] usb 1-1: USB disconnect, device number 2
> > > [    6.750508] .ready
> > > [    6.752558] sd 0:0:0:0: [sda] Read Capacity(10) failed: Result: hostbyte=0x00 driverbyte=0x04
> > > [    6.761112] sd 0:0:0:0: [sda] Sense not available.
> > > [    6.765918] sd 0:0:0:0: [sda] Write Protect is off
> > > [    6.770741] sd 0:0:0:0: [sda] Asking for cache data failed
> > > [    6.776236] sd 0:0:0:0: [sda] Assuming drive cache: write through
> > > [    6.782745] ------------[ cut here ]------------
> > > [    6.787383] WARNING: CPU: 1 PID: 15 at /home/aaro/git/linux/block/genhd.c:626 add_disk+0x41c/0x478()
>
> It's obviously caused by your patch ... look at the event sequence: it's
> a disconnect triggering removal on an in-process probe.

FYI, this sequence is 100% reproducible on my setup. The disk is in
Macally USB enclosure. On cold-boot it will stay on "Spinning up disk"
phase until I manually press the ON button. And that's when the disconnect
message appears, don't know why...

A.
