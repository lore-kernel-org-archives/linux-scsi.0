From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: S3 with pata_via fails to resume, ide_via82Cxxx works
Date: Tue, 30 Dec 2008 18:50:37 +0100
Message-ID: <20081230185037.7ec94e94@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp-111-10.adsl.restena.lu ([158.64.111.10]:34543 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751634AbYL3SAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2008 13:00:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi,

On a system (Commell LE365) with VIA CX700M chipset I experience
varying resume results:

When built with IDE subsystem and VIA82CXXX driver the system suspends
and resumes properly [2.6.28].
-----
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_BLK_DEV_IDEDMA_SFF=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_ATA is not set
-----
When built with ATA subsystem and PATA_VIA driver the system suspends
but hangs during resume (HDD LED remains active) [2.6.28] though it
manages to resume when the CompactFlash card is disconnected [2.6.27].
-----
# CONFIG_IDE is not set
CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_SFF=y
CONFIG_SATA_VIA=y
CONFIG_PATA_VIA=y
-----

Is there some known bigger difference between behavior of both drivers?
I might start comparing behavior of both drivers and try to adjust
PATA_VIA to successfully resume the system, though any hint/suggestion
is welcome!

- SATA HDD with system partition  [seen as IDE Primary master]
- CompactFlash card               [seen as IDE Secondary slave]

lspci output:
00:00.0 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:0324] (rev 03)
00:00.1 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:1324]
00:00.2 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:2324]
00:00.3 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:3324]
00:00.4 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:4324]
00:00.7 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:7324]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8237 PCI Bridge [1106:b198]
00:0f.0 IDE interface [0101]: VIA Technologies, Inc. Device [1106:0581]
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.4 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 90)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. CX700 PCI to ISA Bridge [1106:8324]
00:11.7 Host bridge [0600]: VIA Technologies, Inc. CX700 Internal Module Bus [1106:324e]
00:13.0 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:324b]
00:13.1 PCI bridge [0604]: VIA Technologies, Inc. CX700 PCI to PCI Bridge [1106:324a]
01:00.0 VGA compatible controller [0300]: VIA Technologies, Inc. CX700M2 UniChrome PRO II Graphics [1106:3157] (rev 03)
02:08.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet [10ec:8169] (rev 10)
80:01.0 Audio device [0403]: VIA Technologies, Inc. VIA High Definition Audio Controller [1106:3288] (rev 10)




Secondary note, with ATA subsystem it is possible to discover hot-plugged
second SATA drive with issuing
  echo '- - -' > host0/scsi_host/host0/scan
though the same action causes the access to first SATA drive to fail after
removing second drive. (unfortunately BIOS does only allows configuring
the chipset in IDE mode - so not possible to use SATA_VIA or AHCI).
I guess this is caused by some incorrect detection of speed settings.

What is the way to ask driver to rescan with IDE driver?

Bruno
