From: Otto Solares <solca@guug.org>
Subject: aacraid, seagate and adaptec issues [Was: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/Di Container goes offline]
Date: Wed, 10 Nov 2004 11:43:46 -0600
Message-ID: <20041110174346.GA8047@guug.org>
References: <20041028005302.753a2d52.akpm@osdl.org> <418138B6.2010104@brutsche.us> <1100031774.24635.157.camel@ryan2.internal.autoweb.net> <20041109213215.GA4047@guug.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from guug.org ([168.234.203.30]:2126 "EHLO guug.org")
	by vger.kernel.org with ESMTP id S262022AbUKJRns (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 12:43:48 -0500
Received: from solca by guug.org with local (Exim 3.36 #1 (Debian))
	id 1CRwVX-000273-00
	for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2004 11:43:47 -0600
Content-Disposition: inline
In-Reply-To: <20041109213215.GA4047@guug.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FYI again:

There is a recent KernelTrap thread showing more datails:

http://kerneltrap.org/node/view/3778

Investigating I found 2 more things I'll check:

A seagate time-out issue with exactly my disks:

http://www.seagate.com/support/disc/u320_firmware.html

Unfortunately adaptec will not give me directly the firmware
and Dell does not respond to my support mail queries.  I'm really
impressed with Dell support, they suck so badly, at least
those updates must appear in their download area.  I am pretty
sure my next servers will not come from Dell.

Does anybody have this seagate firmware updates?

And the other issue is a different driver from adaptec:

http://www.adaptec.com/worldwide/support/driverdetail.jsp?sess=no&language=English+US&cat=%2FOperating+System%2FLinux+Driver+Source+Code&filekey=aacraid-src_1.1.5.tgz

Diffing the adaptec and latest 2.6 kernel show they come from
the same base but it seems more complete the Adaptec one,
does somebody knows the difference?  The important thing is
which is better for heavy I/O servers?  Why two drivers?

Thanks.

-otto

On Tue, Nov 09, 2004 at 03:32:15PM -0600, Otto Solares wrote:
> JFYI
> 
> I have exactly this same problem on 3 brand new Dell PE2650
> machines with Perc3/Di controllers, my other new Dell servers
> with the Perc4/Di controller have never fail.
> 
> Dell customer support sucks, they would not help me as I am
> not running a supported distro/kernel.
> 
> The faulty servers have the latest BIOS, Perc3/Di firmware (6092),
> latest ERA/RAC firmware, latest debian sarge, kernel 2.6.10-rc1-bk7.
> Both 2.4 and 2.6 hangs the controller.
> 
> The problem appears when too many IO is happening, the kernel
> don't die, as if I have a ssh session I could execute some
> cached binaries like ps, bash, etc.  Everything in memory runs
> fine until it touches sda that is offlined as you can see
> from this kernel messages:
> 
> Nov  5 14:53:30 saruman kernel: aacraid: Host adapter reset request. SCSI hang ? 
> Nov  5 14:54:33 saruman kernel: aacraid: SCSI bus appears hung 
> Nov  5 14:54:34 saruman kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0 
> Nov  5 14:54:34 saruman kernel: Device sda not ready. 
> Nov  5 14:54:34 saruman kernel: end_request: I/O error, dev sda, sector 127952537 
> Nov  5 14:54:34 saruman kernel: scsi0 (0:0): rejecting I/O to offline device 
> Nov  5 14:54:34 saruman kernel: scsi0 (0:0): rejecting I/O to offline device 
> Nov  5 14:54:34 saruman kernel: EXT3-fs error (device sda4): ext3_find_entry: reading directory #13880243 offset 0 
> Nov  5 14:54:34 saruman kernel:  
> Nov  5 14:54:34 saruman kernel: Remounting filesystem read-only
> 
> -otto
