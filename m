From: Greg Patten <greg@iconsult.com.au>
Subject: Tape (STT8000N) stopped working
Date: Wed, 13 Nov 2002 18:32:10 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2077.1037172730@iconsult.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I've done a fairly exhaustive look over the list and haven't seen
anything so I was wondering whether one of you might be able to help
me (even tho' my kernel's really old - 2.2.21).

This drive has been working for years but I *think* stopped after a
recentish kernel upgrade (tho' I'm not entirely convinced).

The tape unit is recognised:

(scsi0) <Adaptec AHA-294X SCSI host adapter> found at PCI 0/12/0
(scsi0) Narrow Channel, SCSI ID=7, 16/255 SCBs
(scsi0) Downloading sequencer code... 415 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.1.33/3.2.4
       <Adaptec AHA-294X SCSI host adapter>
scsi : 1 host.
  Vendor: FUJITSU   Model: M1606S-512        Rev: 6236
  Type:   Direct-Access                      ANSI SCSI revision: 02
Detected scsi disk sda at scsi0, channel 0, id 0, lun 0
(scsi0:0:0:1) Synchronous at 10.0 Mbyte/sec, offset 15.
  Vendor: QUANTUM   Model: FIREBALL1280S     Rev: 630C
  Type:   Direct-Access                      ANSI SCSI revision: 02
Detected scsi disk sdb at scsi0, channel 0, id 1, lun 0
(scsi0:0:1:1) Synchronous at 10.0 Mbyte/sec, offset 8.
  Vendor: Seagate   Model: STT8000N          Rev: 4.11
  Type:   Sequential-Access                  ANSI SCSI revision: 02
Detected scsi tape st0 at scsi0, channel 0, id 4, lun 0
(scsi0:0:4:1) Synchronous at 10.0 Mbyte/sec, offset 15.
scsi : detected 1 SCSI tape 2 SCSI disks total.

However if I try and do antything I get an error eg.

root@loose 58 ~#mt -f /dev/st0 rewind
/dev/st0: I/O error

With no tape in the drive I get somewhat encouraging results (however
I don't know how to interpret status bits).

root@loose 59 ~#mt -f /dev/st0 status
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (50000):
 DR_OPEN IM_REP_EN

but with a tape in the unit I get

root@loose 60 ~#mt -f /dev/st0 status
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (10000):
 IM_REP_EN

The unit sounds like it can't access the tape somehow: When I stick a
tape in it whirs away for some time with LED flashing (indicates tape
is not at 0) before just stopping.

Can anyone give me an idea of what might be happening? I'm feeling
like the transport's gone or something.

Many thanks in advance and sorry for the newbie Q.

Cheers,
Greg
