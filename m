From: "Kit Gerrits" <kit@gerritsacc.nl>
Subject: DLT "sense key Aborted Command" "sense key Medium Error " "Error on write filemark"
Date: Thu, 10 Feb 2005 00:03:22 +0100
Message-ID: <20050209225848.97287EE@frisbee.gerritsacc.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from www.gerritsaa.nl ([82.168.101.83]:47163 "EHLO
	frisbee.gerritsacc.nl") by vger.kernel.org with ESMTP
	id S261961AbVBIXCw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 18:02:52 -0500
Received: from localhost (localhost [127.0.0.1])
	by frisbee.gerritsacc.nl (Postfix) with ESMTP id D7F00818
	for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2005 23:58:55 +0100 (CET)
Received: from frisbee.gerritsacc.nl ([127.0.0.1])
 by localhost (Frisbee [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 27929-09 for <linux-scsi@vger.kernel.org>;
 Wed,  9 Feb 2005 23:58:48 +0100 (CET)
Received: from kaglapxp (unknown [10.2.1.104])
	by frisbee.gerritsacc.nl (Postfix) with ESMTP id 97287EE
	for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2005 23:58:48 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 
I seem to be getting a backup error every week.

I am using a PowerEDGE 2400, with all the usual built-in SCSI and PERC2/Si
goodness, DLTIV tapedrive (the double 5-1/4 version) and RedHat Enterprise
Linux ES 3.

Seeing as I use a daily tape and 4 rotating Friday tapes, I think the tape
itself is dead.

Upon looking around I found a lot of different tips (disable UW negotiation,
forcing blocksize).
Aside from ditching the tape, should I change anything for better
performance?
Right now I'm simply using tar with its default values.


Error from the backup script:
Checking tape drive...
Tape detected, proceeding with backup
tar: Removing leading `/' from member names
tar: /data/gerrits/Accountantskantoor Gerrits/Drukwerk/Deur
bij-geen-gehoor/A6.psd: file changed as we read it
tar: /dev/tape: Wrote only 0 of 10240 bytes
tar: Error is not recoverable: exiting now

Error from messages:
Feb  8 06:33:55 RedHat01 kernel: st0: Error with sense data: Info fld=0x0,
Deferred st09:00: sense key Medium Error Feb  8 06:33:55 RedHat01 kernel:
st0: Error with sense data: Info fld=0x0, Deferred st09:00: sense key
Aborted Command Feb  8 06:33:55 RedHat01 kernel: st0: Error on write
filemark.
Feb  8 06:33:55 RedHat01 kernel: st0: Error with sense data: Info fld=0xc,
Deferred st09:00: sense key Aborted Command

Tape status:
[12:40:22][root@RedHat01:~]$ mt status
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 0 bytes. Density code 0x19 (DLT 10GB).
Soft error count since last status=0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN

Dmesg on the SCSI controller / tapedrive
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec 2940 Ultra2 SCSI adapter>
        aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
blk: queue c1fc1e14, I/O limit 4095Mb (mask 0xffffffff)
(scsi1:A:6): 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
  Vendor: QUANTUM   Model: DLT7000           Rev: 2561
  Type:   Sequential-Access                  ANSI SCSI revision: 02
st: Version 20030406, bufsize 32768, max init. bufs 4, s/g segs 16 Attached
scsi tape st0 at scsi1, channel 0, id 6, lun 0

All tape errors:
Dec 22 07:09:00 RedHat01 kernel: st0: Error with sense data: Info
fld=0x27ff, Deferred st09:00: sense key Medium Error Dec 22 07:09:00
RedHat01 kernel: st0: Error with sense data: Info fld=0x0, Deferred st09:00:
sense key Aborted Command Dec 22 07:09:00 RedHat01 kernel: st0: Error on
write filemark.
Dec 22 07:09:00 RedHat01 kernel: st0: Error with sense data: Info fld=0x1,
Deferred st09:00: sense key Aborted Command Dec 29 03:39:52 RedHat01 kernel:
st0: Error with sense data: Info fld=0x0, Deferred st09:00: sense key Medium
Error Dec 29 03:39:52 RedHat01 kernel: st0: Error with sense data: Info
fld=0x27ff, Deferred st09:00: sense key Aborted Command Dec 29 03:39:52
RedHat01 kernel: st0: Error on write filemark.
Dec 29 03:39:52 RedHat01 kernel: st0: Error with sense data: Info fld=0xc,
Deferred st09:00: sense key Aborted Command Feb  8 06:33:55 RedHat01 kernel:
st0: Error with sense data: Info fld=0x0, Deferred st09:00: sense key Medium
Error Feb  8 06:33:55 RedHat01 kernel: st0: Error with sense data: Info
fld=0x0, Deferred st09:00: sense key Aborted Command Feb  8 06:33:55
RedHat01 kernel: st0: Error on write filemark.
Feb  8 06:33:55 RedHat01 kernel: st0: Error with sense data: Info fld=0xc,
Deferred st09:00: sense key Aborted Command

Backup Script:
echo "Checking tape drive..."
if [ `/bin/mt status |grep -c ONLINE` ]
then
  echo "Tape detected, proceeding with backup"
  echo "Daily Backup started on" >  /var/log/tape/`date '+%d-%B-%Y'`.log

  #Daily backup script for user files and group shares

  # Log date and time
  date -R >>  /var/log/tape/`date '+%d-%B-%Y'`.log

  # Backp up Data dir and dereference (write files) for /home
  # tar cpvfh /dev/tape --label=" Daily backup created on `date
'+%d-%B-%Y'`."       --directory /data .>> /var/log/tape/`date
'+%d-%B-%Y'`.log
  tar cpvf /dev/tape -T /etc/tape.daily \
   --label="Daily backup created on `date '+%d-%B-%Y'`." \
   >> /var/log/tape/`date '+%d-%B-%Y'`.log

  # Clean up
  echo "Backup finished at">>  /var/log/tape/`date '+%d-%B-%Y'`.log
  date -R >>  /var/log/tape/`date '+%d-%B-%Y'`.log
  # Log date and time (shows runtime)
  mt -f /dev/tape rewind
  mt -f /dev/tape offline
  # Rewind & Eject tape
else
  echo "No tape detected!!!"
  echo "Aborting backup!"
fi

