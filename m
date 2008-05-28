From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10810] New: Performance regression on DAC960
	and kernel 2.6.24+
Date: Wed, 28 May 2008 13:34:40 -0500
Message-ID: <1211999681.3445.67.camel@localhost.localdomain>
References: <bug-10810-10286@http.bugzilla.kernel.org/>
	 <20080528105810.3912c2a1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43804 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196AbYE1Sep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 14:34:45 -0400
In-Reply-To: <20080528105810.3912c2a1.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alex@nibbles.it, bugme-daemon@bugzilla.kernel.org, Jens Axboe <axboe@kernel.dk>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-scsi@vger.kernel.org

On Wed, 2008-05-28 at 10:58 -0700, Andrew Morton wrote:
> On Wed, 28 May 2008 03:52:37 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=10810
> > 
> >            Summary: Performance regression on DAC960 and kernel 2.6.24+
> >            Product: IO/Storage
> >            Version: 2.5
> >      KernelVersion: 2.6.24, 2.6.25
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: high
> >           Priority: P1
> >          Component: Block Layer
> >         AssignedTo: axboe@kernel.dk
> >         ReportedBy: alex@nibbles.it
> > 
> > 
> > Latest working kernel version:
> > 2.6.23
> > 
> > Earliest failing kernel version:
> > 2.6.24
> > 
> > Distribution:
> > Debian
> > 
> > Hardware Environment:
> > 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
> > 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
> > 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
> > 00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
> > 00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
> > 00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
> > 00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
> > 00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
> > 00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
> > 00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
> > 00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
> > 00:05.0 VGA compatible controller: nVidia Corporation C51G [GeForce 6100] (rev
> > a2)
> > 00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
> > 00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a2)
> > 00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a2)
> > 00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a2)
> > 00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a2)
> > 00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
> > 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
> > 00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
> > 00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)
> > 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > HyperTransport Technology Configuration
> > 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address
> > Map
> > 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM
> > Controller
> > 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > Miscellaneous Control
> > 04:08.0 RAID bus controller: Mylex Corporation AcceleRAID 352/170/160 support
> > Device (rev 02)
> > 
> > Software Environment:
> > Debian Lenny 64bit
> > 
> > Problem Description:
> > I/O Access is very slow on some condition, for example samba users can't write
> > more than a few KB/sec on the shares.
> > Also tomcat is veeeery slow to startup (at least 3 times the normal time).
> > 
> > Steps to reproduce:
> > Simply boot with the new kernel
> 
> Oh dear.
> 
> There's been only one change to DAC960.c in that timeframe:
> 
> commit 0156c2547e92df559d5592aad9535838ef459615
> Author: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Date:   Tue Dec 11 17:43:15 2007 -0500
> 
>     blk_end_request: changing DAC960 (take 4)
>     
>     This patch converts DAC960 to use blk_end_request interfaces.
>     Related 'UpToDate' arguments are converted to 'Error'.
>     
>     Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
>     Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> :100644 100644 9030c37... cd03473... M  drivers/block/DAC960.c
> 
> commit 117636092a87a28a013a4acb5de5492645ed620f
> Author: Ralf Baechle <ralf@linux-mips.org>
> Date:   Tue Oct 23 20:42:11 2007 +0200
> 
>     [PATCH] Fix breakage after SG cleanups
> 
> and I don't see how it could cause this.  The breakage is probably
> external to the driver.
> 
> I don't know what it could be and I don't know anyone who can be asked
> to look into it.
> 
> If you have time, the only way I can think of getting to the bottom of
> this is if you were to run a git bisection search as per
> http://www.kernel.org/doc/local/git-quick.html.  Sorry.  

Well, the DAC960 is very old.  It has a trick we escaped from in SCSI
where if it gets an error in the request it resubmits it a sector at a
time.  It sounds very much like it's doing that for every request if the
I/O speed is down to a few k/s.

So, could you try this patch?  It won't fix anything, but if the message
spews all over the console, we know the 1 sector at a time retry is
causing the problems.  If not we'll try to think of something else ...

James

---

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index cd03473..6e2c0e1 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -3410,6 +3410,10 @@ static void DAC960_queue_partial_rw(DAC960_Command_T *Command)
   struct request *Request = Command->Request;
   struct request_queue *req_q = Controller->RequestQueue[Command->LogicalDriveNumber];
 
+  if (printk_ratelimit())
+	  printk(KERN_ERR "DAC960 rety in single sector chunks, %llu:%lu\n",
+		 (u64)Request->sector, Request->nr_sectors);
+
   if (Command->DmaDirection == PCI_DMA_FROMDEVICE)
     Command->CommandType = DAC960_ReadRetryCommand;
   else


