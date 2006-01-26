From: Tore Anderson <tore@linpro.no>
Subject: In-kernel QLE2462 driver LU enumeration bug?
Date: Thu, 26 Jan 2006 13:49:01 +0100
Message-ID: <1138279741.1318.76.camel@echo.e.linpro.no>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-bs/g8H9M8aTCz9VLIoZH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from head.linpro.no ([80.232.36.1]:29928 "EHLO head.linpro.no")
	by vger.kernel.org with ESMTP id S932311AbWAZMtF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 07:49:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-bs/g8H9M8aTCz9VLIoZH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi.  I've had large problems making a setup where I'm using a QLE2462
 card in order to connect to an EMC CLARiiON AX100.  Port 1 of the HBA
 is connected to Storage Processor A ("SPA") of the AX100, while port 2
 is connected to SPB.

  There are two RAIDs on the AX100, one containing five LU's of 230 GB
 each, containing EXT3 file systems labeled "data{1,2,3,4,5}".  SPB is
 the designated controller for all these LUs.  The other RAID contains
 only one LU of 10GB, containing an EXT3 file system labeled "postgres".
 This LU is normally controlled by SPA.

  Now, when I use kernel 2.6.12 with driver 8.01.01 from QLogic[1],
 everything works just nice.  I see a total of 12 LUs representing the
 two paths to each LU, the postres one being available through the first
 SCSI host the module registers, with a "ghost" LU being visible on the
 second SCSI host, and vice verca for the data LUs.  All as expected.
 I load the qla2xxx module using ql2xfailover=0, as the driver to the
 best of my knowledge are unable to send the necessary EMC-specific
 "trespass" command to the ghost LU before actually using it.

  For proper failover I need dm-multipath, but this didn't run stable
 for me on 2.6.12.  I believe this situation has improved in 2.6.15, so
 I wanted to try upgrading.  Now, the 8.01.01 version of the driver
 doesn't compile against 2.6.15 (complains about struct Scsi_Host not
 having members named "eh_active" and "state"), so I thought I'd try the
 in-kernel one.  I downloaded the firmware from QLogic[2], and loaded
 the driver.  It went in fine, found the AX100, created 12 SCSI LUs...
 But it seems all the different LUs created on the server corresponded
 with just /one/ of the LUs that are actually on the AX100.  All of the
 twelve LUs are listed in /proc/partitions as 230GB, and all six
 connected to SCSI host 1 are ghost paths, while all six connected to
 host 2 are active.  When dumping the EXT3 superblock of all those, I
 see that all of them actually acess just one of the LUs on the AX100
 (data5).

  After hours of debugging without getting anywhere (including upgrading
 to the QLogic-driver from todays pull of Linus' git tree), I can't
 think of another explanation than this being a bug in the QLogic
 driver.

  To aid debugging I've attached logs from both 2.6.12 and 2.6.15
 (suitable for diffing).  If there's anything more I can help with
 just let me know.

  [1] http://download.qlogic.com/drivers/32415/qla2xxx-v8.01.01-dist.tgz
  [2] ftp://ftp.qlogic.com/outgoing/linux/firmware/ql2400_fw.bin

Regards
-- 
Tore Anderson

--=-bs/g8H9M8aTCz9VLIoZH
Content-Disposition: attachment; filename=2.6.12-log.gz
Content-Type: application/x-gzip; name=2.6.12-log.gz
Content-Transfer-Encoding: base64

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
dEk9AAA=


--=-bs/g8H9M8aTCz9VLIoZH
Content-Disposition: attachment; filename=2.6.15-log.gz
Content-Type: application/x-gzip; name=2.6.15-log.gz
Content-Transfer-Encoding: base64

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


--=-bs/g8H9M8aTCz9VLIoZH
Content-Disposition: attachment; filename=test.sh
Content-Type: application/x-shellscript; name=test.sh
Content-Transfer-Encoding: 7bit

#! /bin/sh

for lu in sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm; do
	echo -n "[$lu] Device node:          "
	ls -l /dev/$lu
	echo -n "[$lu] SCSI unique ID:       "
	scsi_id -g -u -s /block/$lu
	echo -n "[$lu] SCSI Test Unit Ready: "
	output=`sg_turs /dev/$lu 2>/dev/null`
	echo $output
	if [ x"$output" = x"Completed 1 Test Unit Ready commands with 0 errors" ]; then
		echo -n "[$lu] EXT3 volume label:    "
		dumpe2fs -h /dev/$lu 2>/dev/null | sed -n 's/Filesystem volume name: *//p'
	fi
	echo
done

--=-bs/g8H9M8aTCz9VLIoZH--

