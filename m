From: Sancho Dauskardt <sancho@dauskardt.de>
Subject: Multiple CDRW's on one bus blocking each other
Date: Thu, 02 May 2002 16:16:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.0.2.1.2.20020502145414.0354c230@pop.puretec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.227.126.155] (helo=mrvdomng2.kundenserver.de)
	by moutvdomng0.schlund.de with esmtp (Exim 3.22 #2)
	id 173HKA-0007Le-00
	for linux-scsi@vger.kernel.org; Thu, 02 May 2002 16:12:46 +0200
Received: from [62.157.32.96] (helo=steel.black.de)
	by mrvdomng2.kundenserver.de with esmtp (Exim 3.22 #2)
	id 173HK7-0003oF-00
	for linux-scsi@vger.kernel.org; Thu, 02 May 2002 16:12:45 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

  following setup: 6 CDRW's on 3 busses:

aic7860 #0:
	Host: scsi0 Channel: 00 Id: 00 Lun: 00 ()
	  Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01
	Host: scsi0 Channel: 00 Id: 01 Lun: 00
	  Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01
	Host: scsi0 Channel: 00 Id: 02 Lun: 00
	  Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01

aic7860 #1:
	Host: scsi1 Channel: 00 Id: 03 Lun: 00
	  Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01

IEEE1394 sbp2 (on via ohci cotroller)
	Host: scsi2 Channel: 00 Id: 00 Lun: 00
	  Vendor: _NEC     Model: NR-7800B         Rev: 1.00
	Host: scsi2 Channel: 00 Id: 01 Lun: 00
	  Vendor: _NEC     Model: NR-7800B         Rev: 1.00

My problem is that all CDRW's sitting on the same bus somehow block each 
other when sending eject tray / load tray commands to the drive:

dfs1:/home/sda # eject /dev/sr0 & eject /dev/sr1
--> both tray's are opened simultaineously.

whereas:
dfs1:/home/sda # eject -t /dev/sr0 & eject -t /dev/sr1
--> first closes sr0's tray and then sr1's tray:

Doing the same thing with sr1 & sr2 doesn't show any interference (CDRW's 
being on different SCSI busses).
Now the 2 FireWire drives, one the same logical SCSI bus (and same FireWire 
bus), don't interfere with each other.
If I switch on sbp2_serialize_io, ofcourse, BOTH the eject and load 
commands are done after each other.

Where should I look for this stupid behavoiur ? In the aic7xxx driver ? I'd 
figure that it can't be in the upper SCSI layer, as it works for FireWire 
connected drives.

This tray eject/load problem isn't too bad, but I'm seeing similar 
behaivour when sending other commands to the CDRW's which take longer 
(blank disc, fixate cdr, etc).  In that case reading from one CDR blocks 
while fixating the other (see scripts).

_read_sr0's time by itself:	
  ~ 17 sec
_read_sr0's time plus _eject_dev /dev/sr1 running:
  ~ 20 sec
_read_sr0's time plus _eject_dev /dev/sr1 and _eject_dev /dev/sr2  running:
  ~ 23 sec
_read_sr0's time plus _eject_dev /dev/sr1 and _eject_dev /dev/sr2 and 
_eject_dev /dev/sr3   running:
  ~ 23 sec

Machine setup. 2x SMP, vanilla 2.4.18 kernel, 2x Adaptec 7860, 1x via 6303 
OHIC FireWire.
I'll try to test this on a totally different SCSI controller.

- sda

_read_sr0
	while true;
	do
	        mount /dev/sr0 /mnt/sr0
	        time cat /mnt/sr0/dcim/100nikon/* >/dev/null
	        umount /dev/sr0
	done;

_eject_dev
	while true;
	do
	        echo :$1:
	        eject $1
	        eject -t $1
	done;


also possibly of interrest:
dfs1:/home/sda # time eject /dev/sr3
real    0m1.849s
user    0m0.000s
sys     0m0.020s

dfs1:/home/sda # time eject -t /dev/sr3
real    0m1.375s
user    0m0.000s
sys     0m0.010s

