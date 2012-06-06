From: Denny Schierz <linuxmail@4lin.net>
Subject: 3.3.0/3.4.1 | 53c1030 PCI-X Fusion-MPT | mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
Date: Wed, 6 Jun 2012 13:07:14 +0200
Message-ID: <DE50C1A5-85F6-4B84-B77F-BCED651D2EB5@4lin.net>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.4lin.net ([46.4.210.97]:41313 "EHLO mail.4lin.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2FFLQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 07:16:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.4lin.net (Postfix) with ESMTP id 995213903C
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jun 2012 13:12:13 +0200 (CEST)
Received: from mail.4lin.net ([127.0.0.1])
	by localhost (mail.4lin.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7GW00yzK2Udf for <linux-scsi@vger.kernel.org>;
	Wed,  6 Jun 2012 13:12:09 +0200 (CEST)
Received: from pcdenny.rbg.informatik.tu-darmstadt.de (pcdenny.rbg.informatik.tu-darmstadt.de [130.83.160.152])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.4lin.net (Postfix) with ESMTPSA id 7FF9B20249
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jun 2012 13:12:09 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi,

I try to get an older JBOD (Infrotrend A16U-G242) working with a 53c1030 PCI-X Controller (from Sun) as spooldisk for Bacula, but it fails:

[...]
Jun  6 12:02:08 ext-backup kernel: [ 1710.355096] sd 6:0:0:0: [sdc] Unhandled error code
Jun  6 12:02:08 ext-backup kernel: [ 1710.355101] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun  6 12:02:08 ext-backup kernel: [ 1710.355107] sd 6:0:0:0: [sdc] CDB: Write(10): 2a 00 80 00 20 40 00 04 00 00
Jun  6 12:02:08 ext-backup kernel: [ 1710.355120] end_request: I/O error, dev sdc, sector 2147491904
[...]
Jun  6 12:02:10 ext-backup kernel: [ 1712.352461] end_request: I/O error, dev sdc, sector 2147500096
Jun  6 12:02:10 ext-backup kernel: [ 1712.352598] Buffer I/O error on device sdc, logical block 268436488
Jun  6 12:02:10 ext-backup kernel: [ 1712.352715] lost page write due to I/O error on sdc
Jun  6 12:02:10 ext-backup kernel: [ 1712.352718] Buffer I/O error on device sdc, logical block 268436489
Jun  6 12:02:10 ext-backup kernel: [ 1712.352835] lost page write due to I/O error on sdc
Jun  6 12:02:10 ext-backup kernel: [ 1712.352837] Buffer I/O error on device sdc, logical block 268436490
[...]
Jun  6 12:02:10 ext-backup kernel: [ 1712.361984] mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
Jun  6 12:02:11 ext-backup kernel: [ 1712.886390] mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
Jun  6 12:02:11 ext-backup kernel: [ 1712.886399] mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
Jun  6 12:02:11 ext-backup kernel: [ 1712.886405] mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
Jun  6 12:02:11 ext-backup kernel: [ 1712.886411] mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
Jun  6 12:02:11 ext-backup kernel: [ 1712.886417] mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
[...]

everytime, after Bacula written some Megabytes on the Jbod disks (from 35-100MB). I tried the kernel 3.3.0 and today with 3.4.1.

If I let Bacula write over the same controller to our autochanger, there is no problem (using the local SATA disks as spooldrive). I've search also for a newer firmware, but there was no one available on the LSI website.

Some informations:

lspci:

02:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
02:08.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)

lsscsi:

[0:0:0:0]    disk    ATA      WDC WD2502ABYS-0 02.0  /dev/sda
[2:0:0:0]    disk    ATA      WDC WD2502ABYS-0 02.0  /dev/sdb
[3:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GH22NS50  TN02  /dev/sr0
[6:0:0:0]    disk    ADVUNI   OXYGENRAID 416U  347J  /dev/sdc
[6:0:0:1]    disk    ADVUNI   OXYGENRAID 416U  347J  /dev/sdd
[7:0:1:0]    tape    HP       Ultrium 3-SCSI   G33H  /dev/st0
[7:0:2:0]    tape    HP       Ultrium 3-SCSI   G33H  /dev/st1
[7:0:4:0]    mediumx OVERLAND NEO Series       0602  -  

cat /proc/mpt/summary 
ioc0: LSI53C1030 C0, FwRev=01033400h, Ports=1, MaxQ=255, IRQ=16
ioc1: LSI53C1030 C0, FwRev=01033400h, Ports=1, MaxQ=255, IRQ=17

cat /proc/mpt/version 
mptlinux-3.04.20
  Fusion MPT base driver
  Fusion MPT SPI host driver
  Fusion MPT FC host driver
  Fusion MPT SAS host driver
  Fusion MPT ioctl driver

cat /proc/mpt/version 
mptlinux-3.04.20
  Fusion MPT base driver
  Fusion MPT SPI host driver
  Fusion MPT FC host driver
  Fusion MPT SAS host driver
  Fusion MPT ioctl driver


root@EXT-BACKUP:~# cat /proc/mpt/ioc0/info 
ioc0:
  ProductID = 0x0202 (LSI53C1030 C0)
  FWVersion = 0x01033400 (fw_size=41156)
  MsgVersion = 0x0102
  FirstWhoInit = 0x00
  EventState = 0x00
  CurrentHostMfaHighAddr = 0x00000001
  CurrentSenseBufferHighAddr = 0x00000001
  MaxChainDepth = 0x30 frames
  MinBlockSize = 0x20 bytes
  RequestFrames @ 0xffff880157902800 (Dma @ 0x0000000157902800)
    {CurReqSz=96} x {CurReqDepth=255} = 24480 bytes ^= 0x7000
    {MaxReqSz=96}   {MaxReqDepth=255}
  Frames   @ 0xffff880157900000 (Dma @ 0x0000000157900000)
    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
    {MaxRepSz=80}   {MaxRepDepth=255}
  MaxDevices = 16
  MaxBuses = 1
  PortNumber = 1 (of 1)

cat /proc/mpt/ioc1/info 
ioc1:
  ProductID = 0x0202 (LSI53C1030 C0)
  FWVersion = 0x01033400 (fw_size=41156)
  MsgVersion = 0x0102
  FirstWhoInit = 0x00
  EventState = 0x00
  CurrentHostMfaHighAddr = 0x00000001
  CurrentSenseBufferHighAddr = 0x00000001
  MaxChainDepth = 0x30 frames
  MinBlockSize = 0x20 bytes
  RequestFrames @ 0xffff880157982800 (Dma @ 0x0000000157982800)
    {CurReqSz=96} x {CurReqDepth=255} = 24480 bytes ^= 0x7000
    {MaxReqSz=96}   {MaxReqDepth=255}
  Frames   @ 0xffff880157980000 (Dma @ 0x0000000157980000)
    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
    {MaxRepSz=128}   {MaxRepDepth=255}
  MaxDevices = 16
  MaxBuses = 1
  PortNumber = 1 (of 1)


zless /proc/config.gz

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y

CONFIG_ISCSI_TCP=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m


CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
CONFIG_VMWARE_PVSCSI=y


# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
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
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set

CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y


What could be the problem?

cu denny