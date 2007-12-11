From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: FC-LTO4 tape drive: Sense Key : Illegal Request
Date: Tue, 11 Dec 2007 17:23:23 +0100
Message-ID: <xfk63z5ci9w.fsf@uxkm53.drewag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.drewag.de ([212.111.238.29]:42516 "EHLO
	miranda.drewag.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbXLKQoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 11:44:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a strange problem with writing to a fiberchannel LTO-4 tape
drive. First my environment:

>From /proc/scsi/scsi:

  Host: scsi8 Channel: 00 Id: 00 Lun: 00
    Vendor: IBM      Model: ULTRIUM-TD4      Rev: 74H4
    Type:   Sequential-Access                ANSI  SCSI revision: 03
  Host: scsi8 Channel: 00 Id: 00 Lun: 01
    Vendor: ADIC     Model: Scalar i500      Rev: 400G
    Type:   Medium Changer                   ANSI  SCSI revision: 03
  

>From /var/log/dmesg:

  ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 16 (level, low) -> IRQ 16
  PCI: Setting latency timer of device 0000:09:00.0 to 64
  scsi8 :  on PCI bus 09 device 00 irq 16
  st 7:0:0:0: st2: try direct i/o: yes (alignment 512 B)
  st 7:0:0:0: Attached scsi generic sg36 type 1
  lpfc 0000:09:00.0: 2:1303 Link Up Event x1 received Data: x1 x1 x10 x2
  lpfc 0000:09:00.0: 2:(0):0108 No retry ELS command x4 to remote NPORT xfffffe Retried:3 Error:x3/18
  scsi 8:0:0:0: Sequential-Access IBM      ULTRIUM-TD4      74H4 PQ: 0 ANSI: 3
  ACPI: PCI Interrupt 0000:09:00.1[B] -> <5>st 8:0:0:0: Attached scsi tape st3
  st 8:0:0:0: st3: try direct i/o: yes (alignment 512 B)
  st 8:0:0:0: Attached scsi generic sg37 type 1
  GSI 17 (level, low) -> IRQ 17
  scsi 8:0:0:1: Medium Changer    ADIC     Scalar i500      400G PQ: 0 ANSI: 3
  scsi 8:0:0:1: Attached scsi generic sg38 type 8
  PCI: Setting latency timer of device 0000:09:00.1 to 64

The tape drive is directly attached to the Emulex Lightpulse FC
controller. It is part of a Quantum (ADIC) i500 library, the library
control interface is provided via LUN 1. Changing media works fine.

I use the backup system Amanda (<http://www.amanda.org>), it
worked/works fine with other tape drives (DLT-IV, SDLT-I and SDLT-II
(sometimes called SDLT220 and SDLT600) and DLT-S4). Amanda acesses the
tape drives via the non-rewinding device (/dev/nst0 etc.) As far as I
know it does nothing special. The only reason I mention Amanda is that
I was not able to reproduce the following problem with basic tools (dd
and mt).


The problem: While writing to the tape an error is returned. The
kernel reports the following (the message appears in
/var/log/messages):

  Dec 11 16:26:37 uxrs74 kernel: st3: Sense Key : Illegal Request [current] 
  Dec 11 16:26:37 uxrs74 kernel: st3: Add. Sense: Invalid message error

I have no idea what this means and which steps I should take.

The amanda log file (/var/log/amanda/WeeklySet1/amflush) shows this:

  taper: r: switching to next holding chunk '/var/spool/amanda/server._.0.144'
  taper: r: switching to next holding chunk '/var/spool/amanda/server._.0.145'
  taper: reader-side: got label Set1-5-04 filenum 1
  driver: state time 1556.183 free kps: 60000 space: 5075004836 taper: writing idle-dumpers: 12 qlen tapeq: 3 runq: 0 roomq: 0 wakeup: 0 driver-idle: not-idle
  driver: interface-state time 1556.183 if default: free 60000
  driver: hdisk-state time 1556.183 hdisk 0: free 700190684 dumpers 0 hdisk 1: fre 950492456 dumpers 0 hdisk 2: free 950492460 dumpers 0 hdisk 3: free 798084516 dumpers 0 hdisk 4: free 530198076 dumpers 0 hdisk 5: free 530870476 dumpers 0 hdisk 6: free 614676168 dumpers 0
  driver: result time 1556.183 from taper: DONE 00-00001 Set1-5-04 1 "[sec 1468.628 kb 152807296 kps 104047.6 {wr: writers 4775229 rdwait 444.006 wrwait 1007.537 filemark 4.438}]"
  driver: finished-cmd time 1831.009 taper wrote server:/
  driver: send-cmd time 1831.009 to taper: FILE-WRITE 00-00002 /var/spool/amanda/anotherserver._.0 anotherserver UNKNOWNFEATURE / 0 20071209 0
  driver: startaflush: LARGESTFIT anotherserver / 45242148 615188062
  taper: writing end marker. [Set1-5-04 ERR kb 152822528 fm 2]

Some explanation: It writes out 1 GB chunks to tape, and then the data
for "server" is written out. And at the end it starts writing out the
data for "anotherserver", and then the error arrives.

>From an Amanda perspective this looks normal; just like if there were
a media error while writing to tape. Above example suggests that this
problem might be due to some control command when finishing or
starting a new data blob (they are separated by so-called file marks
(terminology as used in the mt manual page)). But I believe I have
seen the same problem in the middle of data blobs too, but right now I
do not find the right log file.

And an only partially related problem, discussing this could be
off-topic on linux-scsi: I tried to strace the taper process that
writes to the tape. (I hoped to see some magic control command sent to
the tape.)  But strace instantly returned:

  ~# strace -p 9488 -fF
  Process 9488 attached - interrupt to quit
  --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
  --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
  restart_syscall(<... resuming interrupted call ...>) = 32768
  read(4, ptrace: umoven: Input/output error
  0xffffffff, 1690719488)         = 0
  _exit(64)                               = ?
  Process 9488 detached

An Internet search for "ptrace: umoven" gave some hits, but none
explained what it means and what the potential reasons are. If you
have an idea please contact me.


So thats everything I tried. Next step might be to contact Quantum,
but I'd like to give them a more specific problem description. Ideas
to reproduce this with mt/dd would be helpful too.

	Sven

