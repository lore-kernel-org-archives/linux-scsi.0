From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 9734] New: I/O error when inserting a second firewire	sata
	disk
Date: Sun, 03 Feb 2008 03:10:12 +0100
Message-ID: <47A52284.1080907@s5r6.in-berlin.de>
References: <bug-9734-11613@http.bugzilla.kernel.org/>
	<1200186705.3656.83.camel@localhost.localdomain>
	<4789D498.5070103@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4789D498.5070103@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kristian Hoegsberg <krh@bitplanet.net>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

I wrote on 2008-01-13:
> James Bottomley wrote:
>> Firewire list cc'd
>>> Jan 12 16:50:49 x3400 kernel: firewire_sbp2: orb reply timed out, rcode=0x11
>>> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
>>> driverbyte=DRIVER_OK,SUGGEST_OK
>> Best I can tell, this is the source of the problem.  The sbp2 driver is
>> replying DID_BUS_BUSY until that gets sorted out, which seems to be
>> never.
> 
> When something was plugged in or out at the same bus, fw-sbp2 has to
> reconnect == renew the login to each logical unit.  The syslog in the
> report is inconclusive whether that happened or failed.

In any case, there are frequently commands retried or newly enqueued
while fw-sbp2 waits to get the login renewed.  (And fw-sbp2 continues to
complete them with DID_BUS_BUSY until the reconnection didn't succeed.

Whoever caused that I/O, e.g. dd like in the reporter's and my own
tests, will quickly fail.

> As a side note, the old sbp2 driver does not quit commands with
> DID_BUS_BUSY between bus reset and reconnect.  Instead it blocks the
> Scsi_Host in order to not receive commands during that time at all.

I experimented with this yesterday.  First I tried
scsi_internal_device_block() because we
  - want to block logical units individually if possible,
  - need to block from within atomic context (softirq context).
However, this failed miserably with all sorts of lock inversion bug
backtraces (alleged ones or real ones, I don't know) and with occasional
kernel lock-ups (so it were probably real lock inversions).  These
locking issues cannot be solved easily because block layer and scsi_lib
play nauseating games with their locks.

So, I switched over to scsi_block_requests(), i.e. blocking the whole
host like the old sbp2 driver does.  This doesn't seem to have
scsi_internal_device_block()'s locking issues.  However, the sbp2 driver
has one Scsi_Host for each logical unit while the new fw-sbp2 driver
however has one Scsi_Host for each target.  Hence there are difficulties
with targets with multiple logical units, but I probably got them sorted
out now.

There remain frequent problems with reconnection + re-login failures
though.  These failures don't happen with exactly the same bus topology
if I don't run I/O during the bus resets.  I have an idea though what to
try next...
-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
