From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 9734] New: I/O error when inserting a second firewire	sata
	disk
Date: Sun, 13 Jan 2008 10:06:32 +0100
Message-ID: <4789D498.5070103@s5r6.in-berlin.de>
References: <bug-9734-11613@http.bugzilla.kernel.org/>
	<1200186705.3656.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1200186705.3656.83.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kristian Hoegsberg <krh@bitplanet.net>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Firewire list cc'd

It's indeed a problem in the firewire stack.

...
>> now we attach another sata disk to the second port of the pci firewire B
>> controller:
>>
>> Jan 12 16:50:49 x3400 kernel: firewire_sbp2: orb reply timed out, rcode=0x11
>> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
>> driverbyte=DRIVER_OK,SUGGEST_OK
> 
> Best I can tell, this is the source of the problem.  The sbp2 driver is
> replying DID_BUS_BUSY until that gets sorted out, which seems to be
> never.

When something was plugged in or out at the same bus, fw-sbp2 has to
reconnect == renew the login to each logical unit.  The syslog in the
report is inconclusive whether that happened or failed.  There should be
one of
	"reconnected to ... LUN ... (... retries)"
or	"failed to reconnect to ..."
logged eventually.  As long as the reconnect didn't succeed, fw-sbp2
quits newly enqueued commands with DID_BUS_BUSY.

I need a bit spare time and a way to reproduce this or similar things to
get to the cause of this.  (I had random reconnect problems with fw-sbp2
now and then, but not yet 100% reproducible ones like the reporter has.)

The last tested kernel in the report, 2.6.24-rc7, already contains the
latest and greatest firewire code as far as problem at hand is concerned.

> So, first pass analysis indicates the error to be in the firewire
> subsystem.  I'm guessing from the message that it's actually
> drivers/firewire, not drivers iee1934?

Yes.

As a side note, the old sbp2 driver does not quit commands with
DID_BUS_BUSY between bus reset and reconnect.  Instead it blocks the
Scsi_Host in order to not receive commands during that time at all.

The time from bus reset to successful reconnect is typically circa a
second, on bigger buses with lots of protocol activity after bus reset
perhaps a few seconds.  (Could IMO still be optimized, in both of the
drivers/ieee1394 and drivers/firewire implementations.)
-- 
Stefan Richter
-=====-==--- ---= -==-=
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
