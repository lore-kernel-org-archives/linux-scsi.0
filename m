From: "Andrew Kinney" <andykinney@advantagecom.net>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/Di Container goes offline
Date: Tue, 09 Nov 2004 15:49:14 -0800
Message-ID: <4190E6FA.22033.8B6089D3@localhost>
References: <1100031774.24635.157.camel@ryan2.internal.autoweb.net>
Reply-To: andykinney@advantagecom.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.advantagecom.net ([65.103.151.155]:10474 "EHLO
	mail.advantagecom.net") by vger.kernel.org with ESMTP
	id S261784AbUKIXs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Nov 2004 18:48:27 -0500
In-reply-to: <20041109213215.GA4047@guug.org>
Content-description: Mail message body
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Otto Solares <solca@guug.org>
Cc: Phil Brutsche <phil@brutsche.us>, linux-scsi@vger.kernel.org

FWIW, we had the same problems on two identically configured Dell 
PE2500 machines with PERC3/DI controllers.  They were purchased about 
two years ago.  The problem surfaced when we moved to a 2.4.20 kernel 
from an older kernel and our disk system loads increased.  It seemed 
that a combination of seeking through large numbers of files spread 
all over the array (12 million or so), a sequential read of a largish 
log file (200MB or more), and a lot of random writes all over the 
array caused a single drive to become unresponsive in the array.  
When the drive became unresponsive, the upper layer drivers offlined 
the container when they gave up waiting for the controller kernel to 
finish marking the drive as dead (this is an interpretation of our 
NVRAM controller logs) and continue servicing requests to the array.

The end result is that a single misbehaving drive, cable, or 
connector can cause the entire array to be taken offline by the OS.  
Obviously, this isn't the intended operation, so there is still 
something that isn't happening correctly, but it could be that the 
controller just needs to offline the bad disk faster.

At any rate, our solution (covered by Dell warranties) was to replace 
the drive, replace the controller, replace the cables, and replace 
the SCSI backplane.  We also reinitialized the arrays with a 64KB 
stripe size instead of a 32KB stripe size to reduce the physical I/O 
overhead associated with many small files. This fixed the problem for 
us (so far).  

It's tough to say what exactly was the fix since we took a shotgun 
approach to the problem, but my guess is that the drive itself wasn't 
responding quickly enough.  Replacing the drive with a drive of the 
same RPM and capacity but designed for U320 operation instead of U160 
operation is what I suspect resolved the trouble for us.  The logic 
chips on the U320 drive appear to process commands faster than those 
on the U160 drive, thus limiting the possibility of getting jammed 
with commands.  Of course, the drive is also a different brand than 
the other drives in the array, so that could have been related.

Hopefully that information was useful to you and others on this list. 
 Unfortunately, I'm not a kernel programmer nor do I have time to 
contribute code, so I'm unable to offer anything other than what 
solved the issue for us.

Andrew

On 9 Nov 2004 at 15:32, Otto Solares wrote:

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
> Nov  5 14:53:30 saruman kernel: aacraid: Host adapter reset request.
> SCSI hang ? Nov  5 14:54:33 saruman kernel: aacraid: SCSI bus appears
> hung Nov  5 14:54:34 saruman kernel: scsi: Device offlined - not ready
> after error recovery: host 0 channel 0 id 0 lun 0 Nov  5 14:54:34
> saruman kernel: Device sda not ready. Nov  5 14:54:34 saruman kernel:
> end_request: I/O error, dev sda, sector 127952537 Nov  5 14:54:34
> saruman kernel: scsi0 (0:0): rejecting I/O to offline device Nov  5
> 14:54:34 saruman kernel: scsi0 (0:0): rejecting I/O to offline device
> Nov  5 14:54:34 saruman kernel: EXT3-fs error (device sda4):
> ext3_find_entry: reading directory #13880243 offset 0 Nov  5 14:54:34
> saruman kernel:  Nov  5 14:54:34 saruman kernel: Remounting filesystem
> read-only
> 
> -otto
> 
> On Tue, Nov 09, 2004 at 03:22:54PM -0500, Ryan Anderson wrote:
> > On Thu, 2004-10-28 at 14:21, Phil Brutsche wrote:
> > > Andrew Morton wrote:
> > > > Distribution: Debian Sarge
> > > > Hardware Environment: Dell Poweredge 4600, 5 Disks each 146GB in
> > > > a Raid 5 in one container, 8 GB RAM, Dual Xenon 2GHz. The Perc
> > > > 3/Di Controller is on Firmware version 2.80 Build 6092 Software
> > > > Environment: aacraid
> > 
> > I have a Dell 2650, 3 disks, RAID 5, 72GB drives (Fujitsu drives) 4
> > GB Ram, dual 2.4GHz Xeon
> > 
> > dmesg tells me I have this specific firmware:
> > AAC0: kernel 2.8.4 build 6092
> > AAC0: monitor 2.8.4 build 6092
> > AAC0: bios 2.8.0 build 6092
> > AAC0: serial 83ac41d3fafaf001
> > scsi0 : percraid
> >   Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> >   Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0 Type:  
> >   Direct-Access                      ANSI SCSI revision: 02
> > 
> > 
> > Currently I have 2.6.8 on this machine.  (I believe it's actually
> > 2.6.8.1, Debian sometimes blurs things a little bit in terms of
> > backporting a patch.)
> > 
> > > > Problem Description: 
> > > > The Container on the PERC 3/Di Controller goes offline on heavy
> > > > I/O Load with the following error message:
> > > > 
> > > > SCSI:0 (0:0): rejecting I/O to offline device
> > > > Buffer I/O error due to I/O error on sda8
> > 
> > That's what I'm seeing.  It's rather hard to capture because the
> > only disks on this machine are in the RAID container that keeps
> > going offline.
> > 
> > > > Steps to reproduce:
> > > > 
> > > > I am using bonnie++ to produce I/O load on the only Volume on
> > > > the Perc 3/Di Controller with the following parameters bonnie++
> > > > -d /var/lib/postgres/test -s 16000 -n 150 -r 8000 -u
> > > > nobody:nogroup
> > > 
> > > FYI, I have been seeing this as well.
> > > 
> > > I can trigger this card lockup at will with mkfs.ext3; for other
> > > filesystems, I may need to extract a kernel source .tar.gz in
> > > order to cause a lockup.
> > > 
> > > aacraid: Host adapter reset request. SCSI hang ?
> > > aacraid: Host adapter appears dead
> > > Device offlined - not ready after error recovery: host 1 channel 0
> > > id 0 lun 0 SCSI error : <1 0 0 0> return code = 0x6000000
> > > end_request: I/O error, dev sdb, sector 1667007 Buffer I/O error
> > > on device sdb1, logical block 208368 lost page write due to I/O
> > > error on sdb1 scsi1 (0:0): rejecting I/O to offline device Buffer
> > > I/O error on device sdb1, logical block 208369
> > > 
> > > I am using an Adaptec 2120S with a RAID5 of Seagate U320 drives -
> > > yes, I know about the Seagate firmware timeout problem, these
> > > drives are brand new with firmware rev 0006 and thus aren't
> > > affected.
> > > 
> > > This hardware has no problems with kernel 2.4.x.
> > 
> > I had similar, but not nearly as bad, problems with 2.4.x.
> > Under 2.4.x, this machine would become unavailable for approximately
> > 20 minutes, and then would recover.  The load would be around 20
> > when it came back, and would rapidly drop off.
> > 
> > This was with 2.4.20, using a config modeled off the Debian
> > 2.4.18-bf2.4 config.
> > 
> > Due to this problem, my machine is no longer a production machine,
> > so I can do whatever testing is necessary to fix this.
> > 
> > I have gone through the hardware diagnostics process with Dell, with
> > the exception of completing the Elite HD diagnostics on the Fujitsu
> > drives. (The program filled the boot floppy with the log, and I
> > haven't gotten around to rerunning it yet.)
> > 
> > I can debug and attempt to reproduce as much as is necessary at this
> > point, if anyone can give me a place to start and/or a patch to
> > apply.
> > 
> > 
> > -- 
> > 
> > Ryan Anderson                
> > AutoWeb Communications, Inc. 
> > email: ryan@autoweb.net 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
> 


Sincerely,
Andrew Kinney
President and
Chief Technology Officer
Advantagecom Networks, Inc.
http://www.advantagecom.net



