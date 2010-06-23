From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Wed, 23 Jun 2010 07:26:50 GMT
Message-ID: <201006230726.o5N7Qo1Z002345@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32774 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0FWH0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2010 03:26:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5N7Qo3u002346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2010 07:26:50 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275





--- Comment #3 from Pawel Staszewski <pstaszewski@artcom.pl>  2010-06-23 07:26:47 ---
i have no scsi in my system.
here is lspci:
 lspci
00:00.0 Host bridge: Intel Corporation 5100 Chipset Memory Controller Hub (rev
90)
00:02.0 PCI bridge: Intel Corporation 5100 Chipset PCI Express x8 Port 2-3 (rev
90)
00:04.0 PCI bridge: Intel Corporation 5100 Chipset PCI Express x16 Port 4-7
(rev 90)
00:08.0 System peripheral: Intel Corporation 5100 Chipset DMA Engine (rev 90)
00:10.0 Host bridge: Intel Corporation 5100 Chipset FSB Registers (rev 90)
00:10.1 Host bridge: Intel Corporation 5100 Chipset FSB Registers (rev 90)
00:10.2 Host bridge: Intel Corporation 5100 Chipset FSB Registers (rev 90)
00:11.0 Host bridge: Intel Corporation 5100 Chipset Reserved Registers (rev 90)
00:13.0 Host bridge: Intel Corporation 5100 Chipset Reserved Registers (rev 90)
00:15.0 Host bridge: Intel Corporation 5100 Chipset DDR Channel 0 Registers
(rev 90)
00:16.0 Host bridge: Intel Corporation 5100 Chipset DDR Channel 1 Registers
(rev 90)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1
(rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5
(rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6
(rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface Controller
(rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port
SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
01:00.0 Ethernet controller: Intel Corporation 82598EB 10 Gigabit AT CX4
Network Connection (rev 01)
04:00.0 Ethernet controller: Intel Corporation 82573E Gigabit Ethernet
Controller (Copper) (rev 03)
05:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet
Controller
06:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

And .config
cat .config | grep SCSI
# SCSI device support
CONFIG_SCSI_MOD=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set
# SCSI support type (disk, tape, CD-ROM)
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m
# SCSI Transports
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
