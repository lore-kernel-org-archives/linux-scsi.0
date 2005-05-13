From: Garnet Ulrich <garnet.ulrich@gmx.net>
Subject: bugs in 2.6 scsi
Date: Fri, 13 May 2005 08:52:50 -0400
Message-ID: <1115988771.5281.27.camel@garnetd600>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts10.bellnexxia.net ([209.226.175.54]:27039 "EHLO
	tomts10-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S262353AbVEMMww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 08:52:52 -0400
Received: from [10.10.10.100] ([199.243.73.69])
          by tomts10-srv.bellnexxia.net
          (InterMail vM.5.01.06.10 201-253-122-130-110-20040306) with ESMTP
          id <20050513125251.KLLX26102.tomts10-srv.bellnexxia.net@[10.10.10.100]>
          for <linux-scsi@vger.kernel.org>; Fri, 13 May 2005 08:52:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am experiencing problems due to at least two bugs in linux scsi and am
hoping someone could advise me as to whether this is the correct forum
to outline the problems and maybe someone will be interested in fixing
them.  These are 100% reproducible.

I have opened bugzilla entries with redhat as these problems are on an
FC3 system but they really seem to be scsi problems.  In short:

Problem 1: My LG 5120d DVD burner that works flawlessly in RH9/2.4 has
some kind of scsi problem in FC3/2.6.  Burner and cable work great on
RH9 or windows.

Problem 2: When problem 1 occurs with the DVD burner USB attached, my
1394 hard drive starts reporting scsi errors.  I would expect that a
problem with my USB device should not cause scsi errors on my firewire
device, correct?

I am not a coder so I can not fix this myself but am willing to go to
great lengths to do/test whatever someone else needs to fix this problem
with scsi in 2.6 kernels.

I'll provide a little output here in case anyone has any hints or there
are already some known patches that may help.

bugzilla reference: https://bugzilla.redhat.com/bugzilla/show_bug.cgi?
id=157311

I start by running with the firewire hard drive error free for days.
Then turn on the usb attached DVD burner and try burning a CD or DVD.
The firewire hard drive starts generating scsi errors immediately and
eventually gets offlined.

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: DMI      Model: SAMSUNG SV0602H  Rev: 4.38
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GSA-5120D Rev: A115
  Type:   CD-ROM                           ANSI SCSI revision: 02
# uname -r
2.6.11-1.14_FC3
# lsusb
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 004: ID 0d62:001c Darfon Electronics Corp.
Bus 002 Device 003: ID 046d:c016 Logitech, Inc.
Bus 002 Device 002: ID 05e3:0604 Genesys Logic, Inc.
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 003: ID 152e:e001
Bus 001 Device 001: ID 0000:0000

note: the 1394 hard drive was scsi1 when the output below was generated:
May 10 09:33:58 garnetd600 kernel: ieee1394: sbp2: aborting sbp2 command
May 10 09:33:58 garnetd600 kernel: Test Unit Ready 00 00 00 00 00 00
May 10 09:34:08 garnetd600 kernel: ieee1394: sbp2: aborting sbp2 command
May 10 09:34:08 garnetd600 kernel: Test Unit Ready 00 00 00 00 00 00
May 10 09:34:18 garnetd600 kernel: ieee1394: sbp2: aborting sbp2 command
May 10 09:34:18 garnetd600 kernel: Test Unit Ready 00 00 00 00 00 00
May 10 09:34:28 garnetd600 kernel: ieee1394: sbp2: aborting sbp2 command
May 10 09:34:28 garnetd600 kernel: Test Unit Ready 00 00 00 00 00 00
May 10 09:34:38 garnetd600 kernel: ieee1394: sbp2: aborting sbp2 command
May 10 09:34:38 garnetd600 kernel: Test Unit Ready 00 00 00 00 00 00
May 10 09:34:38 garnetd600 kernel: scsi: Device offlined - not ready after error
recovery: host 1 channel 0 id 0 lun 0
May 10 09:34:38 garnetd600 last message repeated 7 times
May 10 09:34:38 garnetd600 kernel: SCSI error : <1 0 0 0> return code = 0x50000
May 10 09:34:38 garnetd600 kernel: end_request: I/O error, dev sda, sector 9684799
May 10 09:34:38 garnetd600 kernel: scsi1 (0:0): rejecting I/O to offline device
May 10 09:34:38 garnetd600 last message repeated 5 times
May 10 09:34:38 garnetd600 kernel: Buffer I/O error on device sda1, logical
block 6657142
May 10 09:34:38 garnetd600 kernel: lost page write due to I/O error on sda1
May 10 09:34:38 garnetd600 kernel: scsi1 (0:0): rejecting I/O to offline device
May 10 09:34:38 garnetd600 kernel: scsi1 (0:0): rejecting I/O to offline device
May 10 09:34:38 garnetd600 kernel: Buffer I/O error on device sda1, logical
block 6688828

At this point, cat /proc/scsi/scsi will lock up and reboot is required.
I know there is a patch for this lockup but as I read it, this won't
really solve the real problems I'm having (burner having scsi problem
and usb based scsi problem causing hosing of firewire drive).  

Help anyone?





