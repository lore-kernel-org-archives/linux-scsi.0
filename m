From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Wed, 13 Jul 2005 21:56:35 +0200
Message-ID: <42D571F3.1070105@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>	 <20050710033431.GB13883@havoc.gtf.org>	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>	 <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave>	 <42D18171.8050207@s5r6.in-berlin.de>	 <20050710202734.GI14956@phunnypharm.org>	 <42D191F7.8030506@s5r6.in-berlin.de> <42D19BF8.9080507@s5r6.in-berlin.de>	 <42D1A1EF.1060006@s5r6.in-berlin.de> <1121090241.5045.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <1121090241.5045.3.camel@mulgrave>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Could you get a trace of what's going on from the command response point
> of view?  Doing a scsi_print_command() in the queuecommand() routine and
> printing the return code and sense (with scsi_print_sense()) in the
> ->done() should be sufficient.

If I only new where the done() is taken from. Seems to come
from scsi.c.

Here is the log with all the old conversions active in sbp2.
I put scsi_print_command() into sbp2scsi_queuecommand() and
scsi_print_sense() into scsi_done().

Jul 13 21:53:20 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
Jul 13 21:53:21 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
Jul 13 21:53:21 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:21 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
Jul 13 21:53:21 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:21 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:21 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:21 shuttle kernel:   Vendor: Initio    Model: IC25N080ATMR04-0  Rev: 2.18
Jul 13 21:53:21 shuttle kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jul 13 21:53:21 shuttle scsi.agent: disk at /devices/pci0000:00/0000:00:0c.0/fw-host1/00101003b80001e0/00101003b80001e0-0/host0/target0:0:0/0:0:0:0
Jul 13 21:53:21 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:21 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Jul 13 21:53:21 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:21 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:21 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:21 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:22 shuttle kernel:         command: Read Capacity (10): 25 00 00 00 00 00 00 00 00 00
Jul 13 21:53:22 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:22 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:22 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:22 shuttle kernel: SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Jul 13 21:53:22 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:23 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda4
Jul 13 21:53:23 shuttle kernel:         command: Mode Sense (6): 1a 00 08 00 04 00
Jul 13 21:53:23 shuttle kernel: ieee1394: sbp2: Convert MODE_SENSE_6 to MODE_SENSE_10
Jul 13 21:53:23 shuttle kernel: ieee1394: sbp2: Modify mode sense response (10 byte version)
Jul 13 21:53:23 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:23 shuttle kernel:         command: Mode Sense (6): 1a 00 08 00 10 00
Jul 13 21:53:23 shuttle kernel: ieee1394: sbp2: Convert MODE_SENSE_6 to MODE_SENSE_10
Jul 13 21:53:23 shuttle kernel: ieee1394: sbp2: Modify mode sense response (10 byte version)
Jul 13 21:53:23 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel: sda: got wrong page
Jul 13 21:53:23 shuttle kernel: sda: assuming drive cache: write through
Jul 13 21:53:23 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:23 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:23 shuttle kernel:         command: Read Capacity (10): 25 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle kernel: SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Jul 13 21:53:23 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:23 shuttle kernel:         command: Mode Sense (6): 1a 00 08 00 04 00
Jul 13 21:53:23 shuttle kernel: ieee1394: sbp2: Convert MODE_SENSE_6 to MODE_SENSE_10
Jul 13 21:53:23 shuttle kernel: ieee1394: sbp2: Modify mode sense response (10 byte version)
Jul 13 21:53:23 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:24 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:24 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:24 shuttle kernel: scsi0 : destination target 0, lun 0
Jul 13 21:53:24 shuttle kernel:         command: Mode Sense (6): 1a 00 08 00 10 00
Jul 13 21:53:24 shuttle kernel: ieee1394: sbp2: Convert MODE_SENSE_6 to MODE_SENSE_10
Jul 13 21:53:24 shuttle kernel: ieee1394: sbp2: Modify mode sense response (10 byte version)
Jul 13 21:53:24 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:24 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:24 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda3
Jul 13 21:53:24 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:23 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda1
Jul 13 21:53:24 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda6
Jul 13 21:53:25 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda9
Jul 13 21:53:25 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda8
Jul 13 21:53:25 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda10
Jul 13 21:53:25 shuttle kernel: sda: got wrong page
Jul 13 21:53:25 shuttle kernel: sda: assuming drive cache: write through
Jul 13 21:53:25 shuttle kernel:  sda:scsi0 : destination target 0, lun 0
Jul 13 21:53:25 shuttle kernel:         command: Read (10): 28 00 00 00 00 00 00 00 08 00
Jul 13 21:53:25 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:25 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:25 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:25 shuttle kernel:  [mac] sda1 sda2 sda3 sda4 sda5 sda6 sda7scsi0 : destination target 0, lun 0
Jul 13 21:53:25 shuttle kernel:         command: Read (10): 28 00 00 00 00 08 00 00 08 00
Jul 13 21:53:25 shuttle kernel: Unrecognized sense data (in hex):
Jul 13 21:53:25 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:25 shuttle kernel:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jul 13 21:53:25 shuttle kernel:  sda8 sda9 sda10
Jul 13 21:53:25 shuttle kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Jul 13 21:53:25 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda7
Jul 13 21:53:26 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda5
Jul 13 21:53:26 shuttle perl: drakupdate_fstab called with --auto --add /dev/sda2

Next I will try the new sbp2 without conversion (the one that lets the
system reboot).
-- 
Stefan Richter
-=====-=-=-= -=== -==-=
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
