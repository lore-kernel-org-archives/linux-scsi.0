From: Otto Solares <solca@guug.org>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 16:58:58 -0600
Message-ID: <20041123225858.GC1401@guug.org>
References: <20041028005302.753a2d52.akpm@osdl.org> <1101246101.26294.76.camel@ryan2.internal.autoweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from guug.org ([168.234.203.30]:26459 "EHLO guug.org")
	by vger.kernel.org with ESMTP id S261517AbUKWW7j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 17:59:39 -0500
Content-Disposition: inline
In-Reply-To: <1101246101.26294.76.camel@ryan2.internal.autoweb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Anderson <ryan@autoweb.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Tue, Nov 23, 2004 at 04:41:41PM -0500, Ryan Anderson wrote:
> On Thu, 2004-10-28 at 00:53 -0700, Andrew Morton wrote:
> > Subject: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/Di Container goes offline
> > 
> > 
> > http://bugme.osdl.org/show_bug.cgi?id=3651
> > 
> >            Summary: dell poweredge 4600 aacraid PERC 3/Di Container goes
> >                     offline
> >     Kernel Version: 2.6.10-rc1, 2.6.9, 2.6.8, 2.6.7, 2.6.6
> >             Status: NEW
> >           Severity: high
> >              Owner: andmike@us.ibm.com
> >          Submitter: oliver.polterauer@ewave.at
> >                 CC: oliver.polterauer@ewave.at
> 
> Is there any update on this problem?
> To reiterate my particular hardware involved that can trigger this
> problem:
> 
> Dell 2650, Dual 2.4Ghz Xeon processors (hyperthreading no, though the
> problem occured in 2.4.20 without hyperthreading disabled via "noht")
> 
> 4 GB of ram
> Only load is PostgreSQL related (i.e, network queries, plus twice daily
> dumps of the database to a NFS store, and a rsync back to the server for
> a second copy)
> 
> Under load, I repeatedly saw containers go offline.
> 
> Dell's recommended hardware diagnostics do not turn up anything (at
> all!)
> 
> The harddrive are Fujitsu drives, so the Seagate Firmware issue should
> not affect them.
> 
> I have since taken this server out of production.  Unfortunately, this
> makes the error much harder to trigger (i.e, I have failed so far to
> trigger it, even with multiple bonnie++ runs)
> 
> Suggestions, diagnostics, etc, would be greatly appreciated.

I used to have this very same problem with exactly the same hardware as you:

2 x 2.4GHz Xeon processor
4GB RAM
PERC 3/Di
4 x Fujitsu MAP3147NC Rev 5608 10K RPMs disks.

I tried all kernels on earth (2.4/2.6) and the controller always dies with
container offline (search this list for the past 15 days and you'll find
my problem).

Currently I'm running 2.6.10-rc1-bk20-adaptec-1.1.5-2370 _WITHOUT_ANY_
problems (ACPI on, HT enabled), my controller:

Red Hat/Adaptec aacraid driver (1.1-5[2370])
ACPI: PCI interrupt 0000:04:08.1[A] -> GSI 30 (level, low) -> IRQ 201
AAC0: kernel 2.8-0[6092] 
AAC0: monitor 2.8-0[6092]
AAC0: bios 2.8-0[6092]
AAC0: serial 3520a1d3
aacraid_setup("")
nondasd=-1 dacmode=-1 commit=-1 coalescethreshold=16 acbsize=-1
scsi0 : percraid
  Vendor: DELL      Model: PERC RAID5        Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 860149632 512-byte hdwr sectors (440397 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0

uptime:

 16:48:22 up 13 days, 29 min,  2 users,  load average: 1.15, 1.27, 1.31

I know 13 days is not much for a server but this server dies in the
1-2 day frame time so it is a huge improvement.

You should try that driver, it works for me.

I had to thank Mark Salyzyn from Adaptec for the updated driver, is my
opinion that this "enhanced driver" should make it in Linus' kernel.

-otto
