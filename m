From: Vlado Koutny <vlado@element.ksp.sk>
Subject: HP Scanjet 4p & HP's ncr53c400a scsi adapter
Date: Sat, 15 Feb 2003 15:56:56 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.21.0302151509160.4103-100000@element.ksp.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: sane-devel@www.mostang.com, linux-scsi@vger.kernel.org

Hello,

  I'm trying to get HP ScanJet 4p working with supplied ncr53c400a scsi
adapter under 2.4.20 linux kernel. As suggested in
http://www.mostang.com/pipermail/sane-devel/2002-May/014280.html (HP
ScanJet 4p (SCSI ncr53c400a) Solution), I've added wake-up sequence into
g_NCR5380.

The card is initialized OK, either without IRQ as well as with ncr_irq=9
(the one usualy used under windows). /proc/scsi etc. lists the card as
well as the scanner, so everything seems to be ok. The outputs here were
generated using scsi error logging, echo "scsi log token #N" >
/proc/scsi/scsi.

configuration:
  Celeron 366, 128MB memory, disk/cdrom on IDE
  Debian 3.0 woody
  2.4.20 kernel
  HP ScanJet 4p + HP-supplied interface card ncr53c400a (no other
    scsi-anything)
  scsi subsystem as module, sg, g_NCR5380, verbose errors, logging 
  g_NCR5380 patched as described above
  
used commands:
  modprobe scsi_mod
  echo "scsi log error 7" > /proc/scsi/scsi
  echo "scsi log timeout 7" > /proc/scsi/scsi
  echo "scsi log scan 7" > /proc/scsi/scsi
  modprobe g_NCR5380 ncr_53c400a=1 ncr_addr=0x280 [ncr_irq=9]

After this, sane-find-scanner reports the scanner correctly.


What happens next:
  * when using IRQ: when I start scanimage -d hp:/dev/sg0 -h, nothing
      happens, just some scsi logs... ending with "Open returning 
      1" sveral times; it can be ctrl-breaked, and after several (like 3) 
      retries I got the following error message:

      NCR5380 core release=7     Generic5380 release 1
      Base Addr: 0x00000     io_port: 0280    IRQ: 9
      NCR5380: coroutine isn't running
      scsi0: no currently connected command
      scsi0: issue_queue
      scsi0: disconnected_queue
      scsi0 : destination target=3, lun=0
              command = 10 (0x0a)00 00 00 02 00

      and the system hangs completly (SysRq can reboot, cannot
      sync/umount). Between the tries, cat /proc/interrupts shows
      zero count for IRQ 9. Tested also as IRQ 12, IRQ 5 - exactly the
      same result.

  * when not using IRQ: the scanner partialy works, I can scan something
      correctly; but it is VERY slow - scanimage -d hp:/dev/sg0 -h
      identifies all available options correctly, but it takes about 2
      minutes to finish, and the same delay is present before each scan
      (because scanimage always queries the scanner for its capabilities).
      Additionaly, the scanning is also quite slow, but I don't claim
      it is slower than under windows (actually I saw it working under 
      windows very long time ago, so I cannot compare, but I remember that
      the scanner head used to move in "steps", probably because of
      interface speed) -- this could be avoided by patching SANE not to
      perform the query each time.

      But, sometimes, the scanning just freezes, together with the whole
      system, not even SysRq works.

      After some debugging, it seems that it is not SANE problem, but SCSI
      problem. Following is the syslog output on the console after the
      system freezes:

      sg_poll: dev=0, res=0x145
      sg_read: dev=0, count=64
      sg_read_xfer: num_xfer=32768, iovec_count=0, k_use_sg=0
      sg_finish_rem_req: res_used=0
      sg_remove_scat: k_use_sg=0
      sg_free: buff=0xc22d0000, size=32768
      sg_write: dev=0, count=64

      Open returning 1
      sg_common_write: scsi opcode=0x08, cmd_size=6
      sg_start_req: dxfer_len=32758
      sg_build_indi: buff_size=32768, blk_size=32768
      sg_malloc: size=32768, ms=1, ret=0xc0720000
      Adding timer for command c28a1200 at 6000 (ca948370)
      sg_poll: dev=0, res=0x104
      Clearing timer for command c2bb2600 1
      sg...bh: dev=9, pack_id=3683, res=0x00 
 
      -- nothing more, just hanged-up system

      After this probably should follow about the same lines as in the
      begining of supplied log, i.e. sg_poll: dev=0. res=0x145 and so on.

      /var/log/kern.log says during the initialization:
	scsi0 : interrupts not enabled. for better interactive performance,                  
	scsi0 : please jumper the board for a free IRQ.                                      
	scsi0 : at port 0x280 interrupts disabled options CAN_QUEUE=16 \
		CMD_PER_LUN=2 release=1 generic options AUTOPROBE_IRQ\ 
		AUTOSENSE PSEUDO DMA USLEEP, USLEEP_POLL=1 USLEEP_SLEEP=20\ 
		generic release=7   
	scsi0 : Generic NCR5380/53C400 Driver


So, any ideas of what's the problem with that?


thanks
  vlado koutny


btw: I've found some quesses what is the jumper on the 53c400a card good
for... The HP manual says: "If you have an IBM PS/1 computer, move the
wait state jumper to cover pins 3 and 2 as shown below." followed by an
illustration of jumper position: IBM PS/1 (2-3) and Normal (1-2).

