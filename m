From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] yet another patch to limit mode sense usage
Date: Mon, 15 Sep 2003 13:25:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915132501.A9849@beaverton.ibm.com>
References: <20030915132330.A9823@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:27105 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261559AbTIOUZ6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 16:25:58 -0400
Content-Disposition: inline
In-Reply-To: <20030915132330.A9823@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Sep 15, 2003 at 01:23:30PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, linux-scsi@vger.kernel.org

Some sample output showing results of using the patch. As noted I have not
tested usb storage (or removable devices).

scsi scan logging is enabled (sysctl -w dev.scsi.logging_level=0x000001c0).

Before modifying any devinfo values, scan shows:

-----------------------------------------------------------------------
scsi_scan_host_selected: <6:6:9:0>
scsi_scan_host_selected: <6:0:9:0>
scsi scan: INQUIRY to host 6 channel 0 id 9 lun 0
scsi scan: 1st INQUIRY successful with code 0x0
scsi scan: 2nd INQUIRY successful with code 0x0
  Vendor: IBM       Model: DRVL09L  CLAR09   Rev: SQ00
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(6:0:9:0): Enabled tagged queuing, queue depth 64.
SCSI device sdg: 17783112 512-byte hdwr sectors (9105 MB)
SCSI device sdg: drive cache: write through
 sdg: sdg1 < sdg5 sdg6 sdg7 sdg8 sdg9 >
Attached scsi disk sdg at scsi6, channel 0, id 9, lun 0
scsi_scan_host_selected: <6:0:9:10>
scsi scan: INQUIRY to host 6 channel 0 id 9 lun 10
scsi scan: 1st INQUIRY failed with code 0x10000
scsi_scan_host_selected: <6:0:0:10>
scsi scan: INQUIRY to host 6 channel 0 id 0 lun 10
scsi scan: 1st INQUIRY successful with code 0x0
  Vendor: IBM       Model: 3542              Rev: 0520
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(6:0:0:10): Enabled tagged queuing, queue depth 64.
SCSI device sdh: 11087872 512-byte hdwr sectors (5677 MB)
SCSI device sdh: drive cache: write back
 sdh: unknown partition table
Attached scsi disk sdh at scsi6, channel 0, id 0, lun 10
Synchronizing SCSI cache for disk sdh: 
-----------------------------------------------------------------------

Notice - the 3542 above has "drive cache: write back"

After running:

echo "IBM:3542:0xe000" > /proc/scsi/device_info
echo "IBM:DRVL09L  CLAR09:0xe000" > /proc/scsi/device_info

Scanning now shows:
-----------------------------------------------------------------------
scsi_scan_host_selected: <6:0:9:0>
scsi scan: INQUIRY to host 6 channel 0 id 9 lun 0
scsi scan: 1st INQUIRY successful with code 0x0
scsi scan: 2nd INQUIRY successful with code 0x0
  Vendor: IBM       Model: DRVL09L  CLAR09   Rev: SQ00
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(6:0:9:0): Enabled tagged queuing, queue depth 64.
SCSI device sdg: 17783112 512-byte hdwr sectors (9105 MB)
sdg: assuming drive cache: write through
 sdg: sdg1 < sdg5 sdg6 sdg7 sdg8 sdg9 >
Attached scsi disk sdg at scsi6, channel 0, id 9, lun 0
scsi_scan_host_selected: <6:0:0:10>
scsi scan: INQUIRY to host 6 channel 0 id 0 lun 10
scsi scan: 1st INQUIRY successful with code 0x0
  Vendor: IBM       Model: 3542              Rev: 0520
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(6:0:0:10): Enabled tagged queuing, queue depth 64.
SCSI device sdh: 11087872 512-byte hdwr sectors (5677 MB)
sdh: assuming drive cache: write through
 sdh: unknown partition table
Attached scsi disk sdh at scsi6, channel 0, id 0, lun 10
-----------------------------------------------------------------------

Both the above now have "assuming drive cache: write through".

-- Patrick Mansfield
