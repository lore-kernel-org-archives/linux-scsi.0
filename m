From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: mptscsih errors talking to Areca based SCSI-attached unit
Date: Wed, 10 Mar 2010 14:19:53 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E1A7BCD@inbmail02.lsi.com>
References: <20100226125514.GA6649@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50749 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab0CJIuQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2010 03:50:16 -0500
In-Reply-To: <20100226125514.GA6649@brong.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bron Gondwana <brong@fastmail.fm>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bron,

See
https://bugzilla.novell.com/show_bug.cgi?id=554152

>From first look they might be similar issue or may be of same type of issue.

Some information I have shared with you which I have already received for novell bugzilla.

Can you do one experiment? 
Immediate after this issue do HBA reset using sg_reset and please share result of the experiment.

Which OS version and driver version this issue has been introduce?
I am interested to know is there any regression from driver point of view?


--Kashyap


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Bron Gondwana
> Sent: Friday, February 26, 2010 6:25 PM
> To: linux-scsi@vger.kernel.org
> Subject: mptscsih errors talking to Areca based SCSI-attached unit
> 
> Hi,
> 
> I've been spending a couple of days trying to track down some issues
> we're having with our SCSI attached storage units.  We have IBM servers
> with the following card:
> 
> 14:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-
> X Fusion-MPT Dual Ultra320 SCSI (rev 08)
> 14:08.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-
> X Fusion-MPT Dual Ultra320 SCSI (rev 08)
> 
> A dual channel LSI card.  Each channel has a cable going to a single
> external 12 drive unit - FT-1202-U3SA.  These are Areca based SATA
> units with a SCSI interface.
> 
> One machine has been having troubles, which we _think_ are down to
> timeout issues on the drive.  We've replaced the LSI card, the cable
> and the controller unit in the external RAID device - the problems
> still seem to be following one particular RAID1 pair of 300GB
> VelociRaptor drives: WDC WD3000HLFS-01G6U0.
> 
> Anyway - we suspect one of the drives may have issues causing it to
> take long timeouts trying to read from bad blocks.  We have seen
> similar behaviour on multiple servers - but particularly badly on this
> one - to the point where it's currently too unstable for production
> use.  We're running replica data on it, which means there's still
> enough IO to trigger an event every couple of hours.
> 
> We're running a 2.6.32.9 kernel with one tiny patch (to printk some
> tracing for every SIGKILL that occurs - trying to track down the
> culprit in another rare bug!)  I can post the config if anyone thinks
> it will help.
> 
> Here's the debug trace.  /proc/sys/dev/scsi/logging_level is 63.
> I start a couple of seconds before the event and go to a couple of
> seconds after:
> 
> [23332.504032] scsi_block_when_processing_errors: rtn: 1 [23332.504067]
> scsi_block_when_processing_errors: rtn: 1 [23334.504039]
> scsi_block_when_processing_errors: rtn: 1 [23334.504075]
> scsi_block_when_processing_errors: rtn: 1 [23335.820008] Waking error
> handler thread [23335.820039] Error handler scsi_eh_1 waking up
> [23335.820079] sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0,
> cancel: 64 [23335.820111] sd 1:0:0:2: scsi_eh_prt_fail_stats: cmds
> failed: 0, cancel: 16 [23335.820142] sd 1:0:0:3:
> scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2 [23335.820172] sd
> 1:0:0:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
> [23335.820202] sd 1:0:0:5: scsi_eh_prt_fail_stats: cmds failed: 0,
> cancel: 36 [23335.820236] sd 1:0:1:3: scsi_eh_prt_fail_stats: cmds
> failed: 0, cancel: 2 [23335.820266] sd 1:0:1:4: scsi_eh_prt_fail_stats:
> cmds failed: 0, cancel: 5 [23335.820297] Total of 127 commands on 7
> devices require eh work [23335.820325] scsi_eh_1: aborting
> cmd:0xffff8807a367f100 [23335.820352] mptscsih: ioc0: attempting task
> abort! (sc=ffff8807a367f100) [23335.820381] sd 1:0:0:0: [sdb] CDB:
> Read(10): 28 00 07 c6 3b 0e 00 00 08 00 [23336.194779] mptscsih: ioc0:
> task abort: SUCCESS (sc=ffff8807a367f100) [23336.195141] scsi_eh_done
> scmd: ffff8807a367f100 result: 0 [23336.195172] scsi_send_eh_cmnd:
> scmd: ffff8807a367f100, timeleft: 2500 [23336.195207]
> scsi_send_eh_cmnd: scsi_eh_completed_normally 2002 [23336.195233]
> scsi_eh_tur: scmd ffff8807a367f100 rtn 2002 [23336.195259] scsi_eh_1:
> aborting cmd:0xffff8807af46cb00 [23336.195285] mptscsih: ioc0:
> attempting task abort! (sc=ffff8807af46cb00) [23336.195313] sd 1:0:1:3:
> [sdk] CDB: Write(10): 2a 00 5a c2 57 fc 00 00 08 00 [23336.504026]
> scsi_block_when_processing_errors: rtn: 1 [23336.504053]
> scsi_block_when_processing_errors: rtn: 1
> 
> [.. snip heaps ..]
> 
> [23361.763530] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> [23361.763557] scsi_eh_tur: scmd ffff8807bea97b00 rtn 2002
> [23361.763583] scsi_eh_1: aborting cmd:0xffff8807a3610100
> [23361.763608] mptscsih: ioc0: attempting task abort!
> (sc=ffff8807a3610100) [23361.763637] sd 1:0:0:5: [sdg] CDB: Write(10):
> 2a 00 0c 6d 0e 07 00 00 08 00 [23361.902681] mptbase: ioc0:
> LogInfo(0x11010001): F/W: bug! MID not found [23362.427818] mptbase:
> ioc0: LogInfo(0x11010001): F/W: bug! MID not found [23362.427851]
> mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
> 
> [.. snip another 50 or so ..]
> 
> [23362.429522] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not
> found [23362.429552] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID
> not found [23362.429582] mptbase: ioc0: LogInfo(0x11010001): F/W: bug!
> MID not found [23362.430207] mptscsih: ioc0: task abort: SUCCESS
> (sc=ffff8807a3610100) [23362.430569] scsi_eh_done scmd:
> ffff8807a3610100 result: 0 [23362.430601] scsi_send_eh_cmnd: scmd:
> ffff8807a3610100, timeleft: 2500 [23362.430634] scsi_send_eh_cmnd:
> scsi_eh_completed_normally 2002 [23362.430661] scsi_eh_tur: scmd
> ffff8807a3610100 rtn 2002 [23362.430686] scsi_eh_1: aborting
> cmd:0xffff8807a3610b00 [23362.430712] mptscsih: ioc0: attempting task
> abort! (sc=ffff8807a3610b00) [23362.430741] sd 1:0:0:5: [sdg] CDB:
> Write(10): 2a 00 0d 0c 41 0f 00 00 08 00 [23362.430793] mptscsih: ioc0:
> task abort: SUCCESS (sc=ffff8807a3610b00) [23362.434200]
> scsi_send_eh_cmnd: scmd: ffff88072fd1b900, timeleft: 2500
> 
> [.. snip more ..]
> 
> [23362.463252] sd 1:0:0:3: [sde] CDB: Write(10): 2a 00 e6 20 96 a4 00
> 00 30 00 [23362.463323] mptscsih: ioc0: task abort: SUCCESS
> (sc=ffff880540767800) [23362.463500] scsi_eh_done scmd:
> ffff880540767800 result: 0 [23362.463531] scsi_send_eh_cmnd: scmd:
> ffff880540767800, timeleft: 2500 [23362.463559] scsi_send_eh_cmnd:
> scsi_eh_completed_normally 2002 [23362.463591] scsi_eh_tur: scmd
> ffff880540767800 rtn 2002 [23362.463627] scsi_eh_1: flush retry cmd:
> ffff8807a367f100 [23362.463665] scsi_eh_1: flush retry cmd:
> ffff8807af46cb00
> 
> [.. snip ..]
> 
> [23362.468745] scsi_eh_1: flush retry cmd: ffff8807a362c900
> [23362.468771] scsi_eh_1: flush retry cmd: ffff8807a3454c00
> [23362.468798] scsi_eh_1: flush retry cmd: ffff880540767800
> [23362.468828] scsi_restart_operations: waking up host to restart
> [23362.469052] Error handler scsi_eh_1 sleeping [23362.504058]
> scsi_block_when_processing_errors: rtn: 1 [23362.504098]
> scsi_block_when_processing_errors: rtn: 1
> 
> 
> The "block_when_processing_errors" lines happen every 2 seconds and
> seem to not be related to anything.
> 
> I'll attach the full log.  The interesting bit to me is that there are
> 127 outstanding items in the queue across all devices, pretty much all
> the time.  We're running reiserfs (v3) on all the devices.
> 
> The RAID layout looks like this:
> 
> Raid Set # 00	Ch01 	sata10a1m (0&1/0/0)	Normal	100.0GB
> 		Ch02 	sata10a2m (0&1/0/2)	Normal	100.0GB
>  	 		sata10a3m (0&1/0/4)	Normal	100.0GB
> Raid Set # 01	Ch07 	sata10b1m (0&1/1/0)	Normal	100.0GB
>  		Ch08 	sata10b2m (0&1/1/2)	Normal	100.0GB
>  	 		sata10b3m (0&1/1/4)	Normal	100.0GB
> Raid Set # 02	Ch03 	sata10a1d (0&1/0/1)	Normal	2000.0GB
>  		Ch04 	sata10a2d (0&1/0/3)	Normal	2000.0GB
>  		Ch05 	sata10a3d (0&1/0/5)	Normal	2000.0GB
>  		Ch06
> Raid Set # 03	Ch09 	sata10b1d (0&1/1/1)	Normal	2000.0GB
>  		Ch10 	sata10b2d (0&1/1/3)	Normal	2000.0GB
>  		Ch11 	sata10b3d (0&1/1/5)	Normal	2000.0GB
>  		Ch12
> 
> So each RAID1 (2 x 300GB drives) and each RAID5 (4 x 2TB drives) is
> split into three virtual "drives" to present to the SCSI connection,
> keeping us to the 2TB limit.  These are then further partitioned into 4
> x 25GB and 500GB partitions for separate filesystems so any one fsck
> doesn't take forever!
> 
> There's also a ServeRaid8k device onboard in the server with its own
> RAID1 that hosts the operating system and logs.  It's sda, so the first
> drive (sata10a1m) is sdb, sata10a1d is sdc, sata10a2m is sdd, etc.  So
> sdb, sdd and sdf are all actually the same physical disks.  These are
> our suspects.
> 
> My question (if you've read this far!  Thanks) is what's triggering
> this complete flush of ALL IO to the device, and also triggering a
> complete SCSI renegotiation the first time it happens (lost in the
> mists of dmesg now) - not only on this device but on the other unit
> which is attached to the other channel on the card.
> 
> Is this likely to be related to the 127 outstanding items (queue full)
> there?  I notice sd 1:0:0:0: (sdb) has a full 64 items in the queue as
> well, which is the maximum queue size according to the code.
> 
> Thanks,
> 
> Bron.
