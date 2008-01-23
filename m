From: Joaquim Duran <joaquinduran@adtelecom.es>
Subject: File operation on removed USB memory stick
Date: Wed, 23 Jan 2008 11:17:35 +0100
Message-ID: <4797143F.8000400@adtelecom.es>
Reply-To: joaquinduran@adtelecom.es
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from correo11.acens.net ([217.116.0.29]:39741 "EHLO
	correo11.acens.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYAWJak (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 04:30:40 -0500
Received: from unknown (HELO [194.179.62.51]) (joaquinduran.adtelecom.es@[213.98.202.183])
          (envelope-sender <joaquinduran@adtelecom.es>)
          by correo11.acens.net (qmail-ldap-1.03) with SMTP
          for <linux-scsi@vger.kernel.org>; 23 Jan 2008 09:23:58 -0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all,

I'm new to this e-mail list. My name is Joaquim Duran.

I've detected a behavior of the SCSI system that could be improved when
accessing to a removed USB memory stick.

That is, I was playing musing from a mounted USB stick, then I removed
it while the program was still running. The program stopped with an
error after few seconds. I checked the message log file and saw that the
I/O operations to a file of the memory stick were done 3 times before
notify the fault to the application. The logs:

Jan 23 09:36:47 adlab127 sdf: sdf1
Jan 23 09:36:47 adlab127 sd 2:0:0:0: [sdf] Attached SCSI removable disk
Jan 23 09:36:47 adlab127 sd 2:0:0:0: Attached scsi generic sg4 type 0
Jan 23 09:36:47 adlab127 usb-storage: device scan complete
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 127) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 128) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 129) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 130) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 131) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 132) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 133) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 134) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 127) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 128) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 129) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 130) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 131) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 132) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 133) failed
Jan 23 09:36:47 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:47 adlab127 FAT: Directory bread(block 134) failed
Jan 23 09:36:58 adlab127 scsi 1:0:0:0: rejecting I/O to dead device
Jan 23 09:36:58 adlab127 FAT: unable to read inode block for updating
(i_pos 7582155)

If the memory stick has been removed, a more severe error could be
notified to the application avoiding the repetition of the operations.

In general IMHO, the behavior to this situation would be:

1 - Move all cache blocks of the removed memory USB stick to the free list.

2 - Any operation relating to the removed device be notified as a severe
error avoiding repetitions.

because if the USB stick is removed in inserted once again it will be
mounted as a different device that the current one, because as still
there is files in use, the device could not be unmounted from system.

Thanks and Best Regards,
Joaquim Duran
