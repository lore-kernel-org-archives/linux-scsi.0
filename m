From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] 2.6.0-test1: random errors for USB disk
Date: Thu, 17 Jul 2003 12:58:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F16FFD0.9070905@pacbell.net>
References: <Pine.LNX.4.44L0.0307171520390.1251-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta4.rcsntx.swbell.net ([151.164.30.28]:24246 "EHLO
	mta4.rcsntx.swbell.net") by vger.kernel.org with ESMTP
	id S268822AbTGQTky (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 15:40:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.0307171520390.1251-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Harald Dunkel <harri@synopsys.COM>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:

> The information in your system logs is very clear.  Your USB drive worked 
> just great until it received a big data transfer.
> 
> Under 2.4, the largest WRITE transfer was 130048 bytes and it worked fine.  
> Under 2.6, the largest attempted WRITE transfer was 524288 bytes and it
> crashed the drive.  The two commands were otherwise identical.

Just to clarify:  there's another difference, and that's that 2.4 does
doing that smaller write one page at a time (write, wait, write, wait,...)
while 2.6 does it all at once (write, write, write, write, ... wait).

That difference is how I've seen usb-storage top 30 MByte/sec on USB
with 2.6 kernels, when 2.4 may not reach 10 MB/sec on the same hardware.

- Dave


> Presumably differences in the block I/O systems account for the difference
> in buffer sizes.  But I don't know of any way to tell Linux that the drive
> is unable to accept data transfers larger than some fixed limit.
> 
> Can anyone else suggest a way to solve this?
> 
> Alan Stern
> 
> 


