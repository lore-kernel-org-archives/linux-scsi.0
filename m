From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED
	OPERATION CODES
Date: Sun, 22 Dec 2013 12:26:56 +0100
Message-ID: <20131222122656.0ac04715@stein>
References: <20121125184525.0b7967c4@stein>
	<yq18v9nsz3q.fsf@sermon.lab.mkp.net>
	<20121202191654.59117ac2@stein> <20131215155238.6016b038@stein>
	<52AF1154.1020509@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <52AF1154.1020509@interlog.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: dgilbert@interlog.com, linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Dec 16 Douglas Gilbert wrote:
> On 13-12-15 09:52 AM, Stefan Richter wrote:
> > On Dec 02 2012 Stefan Richter wrote:
> >> Of course it remains to be seen what happens with ATA TRIM enabled SSDs
> >> behind the newer SPC-3 compliant bridges, but at this time the risk with
> >> those seems low.
> >
> > I now tested
> >    - ONNTO dataTale RSM4QO (OXUF936QSE) with two Samsung 840 Pro in RAID 0,
> >    - ONNTO dataTale RSM4QO (OXUF936QSE) with two Samsung 840 Pro in RAID 1,
> >    - IOI FWBU2-DSATA12 (OXUF934DSB) with one Samsung 840 Pro
> > and kernel 3.9.
> >
> > $ grep . /sys/class/scsi_disk/42\:0\:0\:0/*prov*
> > /sys/class/scsi_disk/42:0:0:0/provisioning_mode:full
> > /sys/class/scsi_disk/42:0:0:0/thin_provisioning:0
> > # sg_opcodes /dev/sdg
> >    Ext Hard   Disk
> >    Peripheral device type: disk
> > Report supported operation codes: operation not supported
> > # sg_write_same --10 --lba=1 /dev/sdg
> > Write same(10) command not supported
> > # sg_write_same --16 --lba=1 /dev/sdg
> > Write same(16) command not supported
> > # sg_write_same --32 --lba=1 /dev/sdg
> > Write same: pass through os error: Invalid argument
> > Write same(32) command failed
> 
> The sg driver does not support SCSI commands of greater
> than 16 bytes. That is the reason for the "pass-through
> os error" on your '--32' variant above. For now you need
> to send the '--32' variant to the bsg driver instead.
> 
> I have presented a patch to relax the 16 byte cdb limit
> on the sg driver:
>    http://www.spinics.net/lists/linux-scsi/msg70283.html
> Like most of my patches that one seems to be residing
> in James' /dev/null file for later consideration.

Ah, thanks for the pointer.  Plus, I now looked back into the code and saw
that while SBP-2 (the encapsulation protocol) does not impose any limit on
CDB length, firewire-sbp2 (the driver) does.  This implementation limit was
last changed by https://git.kernel.org/linus/af2719415a5c.  It could be
lifted though, should a need arise.

  # sg_write_same --16 --lba=1 /dev/bsg/79\:0\:0\:0 
  Write same(16) command not supported
  # sg_write_same --32 --lba=1 /dev/bsg/79\:0\:0\:0 
  Write same: transport: Host_status=0x05 [DID_ABORT]
  Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]
  
  Write same(32) command failed

I only tested the OXUF934DSB this time.  Like in the previous tests, the
target firmware keeps working properly after it rejected WRITE SAME 10 or 16
without or with UNMAP bit.

PS:
For those who wonder about older and buggier SBP-2 targets than those which
I tested here:  Due to the check for sdev->scsi_level of at least SCSI_SPC_3
in drivers/scsi/scsi.c::scsi_report_opcode(), and subsequent use of this
function by sd.c to determine support of WRITE SAME 10 and/or 16, the kernel
will never send these opcodes to those targets unless userland explicitly
tells it to do so.  Those kinds of SBP-2 targets all show themselves with a
lower scsi_level.

PPS:
Reminder to self:  Apropos commit af2719415a5c, I need to fix up struct
sbp2_command_orb for better portability of dma_map_single(..., &orb->request,
...) and to obey the target's Unit_Characteristics.ORB_size.
-- 
Stefan Richter
-=====-===-= ==-- =-==-
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Rapidly troubleshoot problems before they affect your business. Most IT 
organizations don't have a clear picture of how application performance 
affects their revenue. With AppDynamics, you get 100% visibility into your 
Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.clktrk
