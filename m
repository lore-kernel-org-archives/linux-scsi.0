From: Douglas Gilbert <dougg@torque.net>
Subject: USB multi card reader == SCSI multi lun target
Date: Tue, 02 Sep 2003 10:31:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F53E4FF.80401@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:32203 "EHLO 202.147.124.17")
	by vger.kernel.org with ESMTP id S263386AbTIBAdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2003 20:33:18 -0400
Received: from torque.net (dm1-10.triode.net.au [202.147.125.10])
	by 202.147.124.17 (8.12.8/8.12.7) with ESMTP id h820Wdm4031327
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2003 10:32:41 +1000
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is probably old news to USB folks but those
nifty little USB multi card readers (e.g. CF, SD,
MMC, SMC cards etc) appear in Linux as multi lun
targets.

Most distros only scan for lun 0 **. So to see
luns > 0, commands like these are needed:

echo "scsi add-single-device 1 0 0 1" > /proc/scsi/scsi
echo "scsi add-single-device 1 0 0 2" > /proc/scsi/scsi
echo "scsi add-single-device 1 0 0 3" > /proc/scsi/scsi

The above sequence was needed for a 4 slot multi card reader.
Following is some /proc/scsi/scsi output after an
"scsi add-single-device 1 0 0 1" in a 2 slot multi card reader.
Notice the end of the model string tells you what type of
card is read at that lun.

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 02 Lun: 00
   Vendor: hp       Model: scanjet 7400c    Rev: 0.8A
   Type:   Scanner                          ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: Generic  Model: USB Storage-SMC  Rev: 0090
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 01
   Vendor: Generic  Model: USB Storage-CFC  Rev: 0090
   Type:   Direct-Access                    ANSI SCSI revision: 02


** Most distros don't set CONFIG_SCSI_MULTI_LUN because some
"scsi" devices answer all luns. I think that bug in ide-scsi
has been fixed in lk 2.4.22 (I've sent patches to this list
for 2.4 and 2.5 to fix this). A scipt may be useful to scan
the output of /proc/scsi/scsi for this class of device and if
found manually scan for luns > 0.

Doug Gilbert


