From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: strange ide-cd MODE_SENSE response [2.6.8.1]
Date: Tue, 17 Aug 2004 16:35:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BC28D5D0-F09D-11D8-81F9-00039398BB5E@ieee.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:44745 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266819AbUHQWe7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 18:34:59 -0400
Received: from royntex01.iomegacorp.com (edison [10.1.1.82])
	by email.iomega.com (Postfix) with ESMTP id 225D72230
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2004 16:34:58 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

// In short:

Me too.

I find PATAPI in Linux opaque here, not transparent.

// At length ...

 > Subject: strange ide-cd MODE_SENSE response [2.6.8.1]

Yes a device that fails without providing auto sense has spoken rudely 
to the host.

 > a MODE_SENSE (6 byte variant) ...
 > sent to an "ide-cd" device (e.g. /dev/hdc)
 > "CONDITION MET" SCSI status and no sense buffer.

Analogously, my more naive parse of ioctl SG_IO results yielded ...

... a check condition without intelligible sense and also a complaint 
of positive residue i.e. less data bytes copied than requested for the 
CDB.

Like you, I have devices that identify themselves as implementing SFF 
SCSI = MMC yet also in fact for compatibility choosing to implement the 
option of ANSI SCSI.  My devices are Iomega REV drives.  Contrasting 
what I get from the same device via USB or via ATAPI, I see:

  $ # usb-storage USB copies in data and good status
  $ uname -msr
  Linux 2.6.8.1 i686
  $
  $ sudo plscsi /dev/scd0 --please -i 4 -x "1A 3F:00:00 04 00" -v
  x 00000000 1A 3F:00:00 04 00 .. .. .. .. .. .. .. .. .. .. "Z?@@D@"
  x 00000000 07:70:00:00 .. .. .. .. .. .. .. .. .. .. .. .. "Gp@@"
  // 0 = plscsi.main exit int
  $

  $ # ide-cd PATAPI loses the data, and provides no auto sense, but 
reports the data loss as positive residue
  $ sudo plscsi /dev/hdc --please -i 4 -x "1A 3F:00:00 04 00" -v
  x 00000000 1A 3F:00:00 04 00 .. .. .. .. .. .. .. .. .. .. "Z?@@D@"
  x 00000000 00:00:00:00 .. .. .. .. .. .. .. .. .. .. .. .. "@@@@"
  // -x0102 = -258 = plscsi.main exit int
  $

  $ # ide-cd PATAPI can provide auto sense data when it likes
  $ sudo plscsi /dev/hdc -x "00 00:00:00 00 00" -v
  x 00000000 00 00:00:00 00 00 .. .. .. .. .. .. .. .. .. .. "@@@@@@"
  x 00000000 70:00:02:00 00:00:00:18 00:00:00:00 3A:00 .. .. 
"p@B@@@@X@@@@:@"
  // x 2 3A sense
  // -x0002 = -2 = plscsi.main exit int
  $

Pat LaVarre

