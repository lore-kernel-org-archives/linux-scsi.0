From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for September 4
Date: Sat, 06 Sep 2008 08:42:10 -0500
Message-ID: <1220708530.3430.8.camel@localhost.localdomain>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
	 <200809051256.36257.rjw@sisk.pl>
	 <20080905113042.0f6d5850.akpm@linux-foundation.org>
	 <200809061325.20924.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200809061325.20924.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-09-06 at 13:25 +0200, Rafael J. Wysocki wrote:
> On Friday, 5 of September 2008, Andrew Morton wrote:
> > On Fri, 5 Sep 2008 12:56:35 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Friday, 5 of September 2008, Andrew Morton wrote:
> > > > On Thu, 4 Sep 2008 19:36:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > 
> > > > > I have created today's linux-next tree at
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > > > 
> > > > The infamous Vaio hasn't finished catching up with you guys yet. 
> > > > Something in linux-next broke suspend-to-RAM.
> > > > 
> > > > An `echo mem > /sys/power/state' causes "Freezing of tasks failed after
> > > > 20.00 seconds (1 tasks refusing to freeze):"
> > > > 
> > > > dmesg: http://userweb.kernel.org/~akpm/dmesg-sony-suspend.txt
> > > > config: http://userweb.kernel.org/~akpm/config-sony.txt
> > > > 
> > > > This only happens after the X server has been started.
> > > > 
> > > > Mainline is OK.
> > > 
> > > According to your dmesg the process that refused to freeze was
> > > 
> > > hald-addon-stor
> > > 
> > > which got stuck in ... getnstimeofday (???) (can you check what
> > > source code corresponds to getnstimeofday+0x37/0xbc pls?):
> > > 
> > > hald-addon-st D 00000046     0  2322   2282
> > >        f4de5b74 00000046 f4de5b54 00000046 f4de5b5c c0135f56 f6b96e44 f4deaf40 
> > >        f4deb0bc f5580948 f4de5bb0 f4de5b6c c013336e f6aa77c8 f6aa77c8 f6aa77a0 
> > >        f4de5bb0 f4de5b7c c0331f09 f4de5bd0 c01f4205 00000000 00000000 00000000 
> > > Call Trace:
> > >  [<c0135f56>] ? getnstimeofday+0x37/0xbc
> > >  [<c013336e>] ? ktime_get_ts+0x40/0x44
> > >  [<c0331f09>] io_schedule+0x39/0x6c
> > >  [<c01f4205>] get_request_wait+0x80/0xcd
> > > ...
> > 
> > (gdb) x/60i getnstimeofday
> > 0xc0135d63 <getnstimeofday>:    push   %ebp
> > 0xc0135d64 <getnstimeofday+1>:  mov    %esp,%ebp
> > 0xc0135d66 <getnstimeofday+3>:  push   %edi
> > 0xc0135d67 <getnstimeofday+4>:  push   %esi
> > 0xc0135d68 <getnstimeofday+5>:  push   %ebx
> > 0xc0135d69 <getnstimeofday+6>:  sub    $0x8,%esp
> > 0xc0135d6c <getnstimeofday+9>:  mov    %eax,0xffffffec(%ebp)
> > 0xc0135d6f <getnstimeofday+12>: mov    0xc045a2c0,%eax
> > 0xc0135d74 <getnstimeofday+17>: mov    %eax,0xfffffff0(%ebp)
> > 0xc0135d77 <getnstimeofday+20>: test   $0x1,%al
> > 0xc0135d79 <getnstimeofday+22>: je     0xc0135d7f <getnstimeofday+28>
> > 0xc0135d7b <getnstimeofday+24>: pause  
> > 0xc0135d7d <getnstimeofday+26>: jmp    0xc0135d6f <getnstimeofday+12>
> > 0xc0135d7f <getnstimeofday+28>: mov    0xffffffec(%ebp),%ecx
> > 0xc0135d82 <getnstimeofday+31>: mov    0xc05db920,%eax
> > 0xc0135d87 <getnstimeofday+36>: mov    0xc05db924,%edx
> > 0xc0135d8d <getnstimeofday+42>: mov    %eax,(%ecx)
> > 0xc0135d8f <getnstimeofday+44>: mov    %edx,0x4(%ecx)
> > 0xc0135d92 <getnstimeofday+47>: mov    0xc05db938,%eax
> > 0xc0135d97 <getnstimeofday+52>: call   *0x10(%eax)
> > 0xc0135d9a <getnstimeofday+55>: mov    0xc05db938,%esi
> > 0xc0135da0 <getnstimeofday+61>: mov    0x1c(%esi),%ecx
> > 0xc0135da3 <getnstimeofday+64>: sub    0x48(%esi),%eax
> > 0xc0135da6 <getnstimeofday+67>: sbb    0x4c(%esi),%edx
> > 0xc0135da9 <getnstimeofday+70>: and    0x14(%esi),%eax
> > 0xc0135dac <getnstimeofday+73>: and    0x18(%esi),%edx
> > 0xc0135daf <getnstimeofday+76>: mov    %edx,%edi
> > 0xc0135db1 <getnstimeofday+78>: imul   %ecx,%edi
> > 0xc0135db4 <getnstimeofday+81>: mul    %ecx
> > 0xc0135db6 <getnstimeofday+83>: mov    0x24(%esi),%ecx
> > 0xc0135db9 <getnstimeofday+86>: lea    (%edi,%edx,1),%edx
> > 0xc0135dbc <getnstimeofday+89>: mov    %eax,%ebx
> > 0xc0135dbe <getnstimeofday+91>: mov    %edx,%esi
> > 0xc0135dc0 <getnstimeofday+93>: xor    %edi,%edi
> > 0xc0135dc2 <getnstimeofday+95>: shrd   %cl,%edx,%ebx
> > 0xc0135dc5 <getnstimeofday+98>: shr    %cl,%esi
> > 0xc0135dc7 <getnstimeofday+100>:        test   $0x20,%cl
> > 0xc0135dca <getnstimeofday+103>:        cmovne %esi,%ebx
> > 0xc0135dcd <getnstimeofday+106>:        cmovne %edi,%esi
> > 0xc0135dd0 <getnstimeofday+109>:        mov    %ebx,%edx
> > 
> > (gdb) l *0xc0135d9a
> > 0xc0135d9a is in getnstimeofday (kernel/time/timekeeping.c:104).
> > 99      
> > 100                     /* read clocksource: */
> > 101                     cycle_now = clocksource_read(clock);
> > 102     
> > 103                     /* calculate the delta since the last update_wall_time: */
> > 104                     cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> > 105     
> > 106                     /* convert to nanoseconds: */
> > 107                     nsecs = cyc2ns(clock, cycle_delta);
> > 108     
> > 
> > Which implies that someone mucked up xtime_lock.
> > 
> > But I don't think any of that is correct.  The getnstimeofday is just
> > stack gunk.  hald is in D state and is asleep in get_request_wait().
> 
> Right.  It looks like there was a media change in the CD drive and hald was
> waiting for the device in sr_test_unit_ready() forever.  Apparently, the device
> could not get ready.
> 
> It looks like a SATA/ATA (whatever the CD-ROM is attached to) issue or sr_mod
> breakage.

Um, I don't see how that follows.

get_request_wait() is the first thing the block layer does to try to get
a request structure for the queue.  If it's stuck there it means that
block was out of requests and is waiting for some memory to free up.  If
we're stuck there, nothing went down to the CD.

However, being stuck here really isn't good news.  These things are
mempool backed to prevent writeout deadlock ... we shouldn't be running
out of them.  What does 

/sys/block/<dev>/queue/nr_reqeusts

and

/sys/block/<dev>/stat

say for this device?

James


