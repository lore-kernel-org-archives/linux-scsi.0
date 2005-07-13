From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Wed, 13 Jul 2005 23:09:03 +0200
Message-ID: <42D582EF.3060701@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>	 <20050710033431.GB13883@havoc.gtf.org>	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>	 <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave>	 <42D18171.8050207@s5r6.in-berlin.de>	 <20050710202734.GI14956@phunnypharm.org>	 <42D191F7.8030506@s5r6.in-berlin.de> <42D19BF8.9080507@s5r6.in-berlin.de>	 <42D1A1EF.1060006@s5r6.in-berlin.de> <1121090241.5045.3.camel@mulgrave>	 <42D571F3.1070105@s5r6.in-berlin.de> <1121285524.5049.53.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <1121285524.5049.53.camel@mulgrave>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2005-07-13 at 21:56 +0200, Stefan Richter wrote:
>>If I only new where the done() is taken from. Seems to come
>>from scsi.c.
> 
> I think it happens in sbp2scsi_complete_command.

OK, I will move scsi_print_sense just in front of the call to
->done().

>>Here is the log with all the old conversions active in sbp2.
>>I put scsi_print_command() into sbp2scsi_queuecommand() and
>>scsi_print_sense() into scsi_done().
> 
> Actually, I'm afraid I need the command trace for the failing case to
> see if I can fix it (i.e. without the sbp2 translations put back in).

Here is sbp2 without its conversions. That's what the syslog file
caught and what was written on disk before the machine rebooted:

Jul 13 22:31:41 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
Jul 13 22:31:42 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
Jul 13 22:31:42 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 22:31:42 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
Jul 13 22:31:42 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 22:31:42 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 22:32:40 shuttle syslogd 1.4.1: restart.

But there was more than the inquiry going on. We already know that the
inquiry actually succeeds and the disk is recognized as TYPE_DISK.

Just before that attempt I tried to insert msleep()s after the debug
printk to get more out to disk. Of course I managed to put these
right into interrupt context. But at least there was a bit more left
in the syslog file after reboot:

Jul 13 22:24:06 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
Jul 13 22:24:07 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
Jul 13 22:24:07 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 22:24:07 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
Jul 13 22:24:07 shuttle kernel: ...sleep 2s...<3>scheduling while atomic: modprobe/0x00000001/6408
Jul 13 22:24:07 shuttle kernel:  [schedule+1425/1632] schedule+0x591/0x660
[...bla bla...]
Jul 13 22:24:08 shuttle kernel:  [<c0102edb>] sysenter_past_esp+0x54/0x75
Jul 13 22:24:09 shuttle scsi.agent: disk at /devices/pci0000:00/0000:00:0c.0/fw-host1/00101003b80001e0/00101003b80001e0-0/host0/target0:0:0/0:0:0:0
Jul 13 22:24:09 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 22:24:09 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 22:24:09 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 22:24:09 shuttle kernel:   Vendor: Initio    Model: IC25N080ATMR04-0  Rev: 2.18
Jul 13 22:24:09 shuttle kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jul 13 22:24:09 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 22:24:09 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Jul 13 22:24:09 shuttle kernel: ...sleep 2s...<3>scheduling while atomic: modprobe/0x00000001/6496
Jul 13 22:24:09 shuttle kernel:  [schedule+1425/1632] schedule+0x591/0x660
[...got it now...]
Jul 13 22:24:10 shuttle kernel:  [<c0102edb>] sysenter_past_esp+0x54/0x75
Jul 13 22:24:11 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 22:24:11 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 22:24:11 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 22:24:11 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 22:24:11 shuttle kernel:         command: Read Capacity (10): 25 00 00 00 00 00 00 00 00 00
Jul 13 22:24:11 shuttle kernel: ...sleep 2s...<3>scheduling while atomic: modprobe/0x00000001/6496
Jul 13 22:24:11 shuttle kernel:  [schedule+1425/1632] schedule+0x591/0x660
[...]
Jul 13 22:24:12 shuttle kernel:  [<c0102edb>] sysenter_past_esp+0x54/0x75
Jul 13 22:24:13 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 22:24:13 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 22:24:13 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 22:24:13 shuttle kernel: SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Jul 13 22:24:13 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 22:24:13 shuttle kernel:         command: Mode Sense (10): 5a 00 08 00 00 00 00 00 08 00
Jul 13 22:24:13 shuttle kernel: ...sleep 2s...<3>scheduling while atomic: modprobe/0x00000001/6496
Jul 13 22:24:13 shuttle kernel:  [schedule+1425/1632] schedule+0x591/0x660
[...]
Jul 13 22:24:14 shuttle kernel:  [<c0102edb>] sysenter_past_esp+0x54/0x75
Jul 13 22:25:12 shuttle syslogd 1.4.1: restart.

I'll try to get some more info.
-- 
Stefan Richter
-=====-=-=-= -=== -==-=
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
