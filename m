From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: scsi_wait_scan not working (2.6.30.5)
Date: Tue, 25 Aug 2009 21:24:22 +0200
Message-ID: <200908252124.22562.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40661 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZHYTYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 15:24:30 -0400
Received: by bwz19 with SMTP id 19so2108102bwz.37
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 12:24:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

What could be the reason for scsi_wait_scan not waiting untill all disk=
s are=20
found?

I'm testing 2.6.30.5 on hardware with LSI Logic / Symbios Logic MegaRAI=
D 530=20
SCSI 320-0X RAID controller and modprobe scsi_wait_scan finishes earlie=
r than=20
disks are found.

My initrd (romfs) does:
insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_mod.ko
insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_=
mm.ko
insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_=
mbox.ko
insmod /lib/modules/2.6.30.5-0.3/kernel/lib/crc-t10dif.ko
insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/sd_mod.ko
insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_wait_scan.ko
insmod /lib/modules/2.6.30.5-0.3/kernel/fs/exportfs/exportfs.ko
insmod /lib/modules/2.6.30.5-0.3/kernel/fs/xfs/xfs.ko
if [ "${ROOT##/dev/}" !=3D "${ROOT}" ]; then
rootnr=3D"$(busybox awk -v rootnode=3D"${ROOT##/dev/}" '$4 =3D=3D rootn=
ode { print 256=20
* $1 + $2 }' /proc/partitions)"
if [ -n "$rootnr" ]; then
echo "$rootnr" > /proc/sys/kernel/real-root-dev
fi


Now if I add sleep few seconds or /bin/sh at the end of this initrd, th=
en boot=20
and then disks are detected properly and rootfs is mounted properly (af=
ter I=20
exit from sh in case when /bin/sh is used).

The question remains - why scsi_wait_scan doesn't wait?

[root@rhea ~]# zgrep SCSI /proc/config.gz                              =
                                                                       =
             =20
CONFIG_CISS_SCSI_TAPE=3Dy                                              =
                                                                       =
               =20
# SCSI device support                                                  =
                                                                       =
             =20
CONFIG_SCSI=3Dm                                                        =
                                                                       =
               =20
CONFIG_SCSI_DMA=3Dy                                                    =
                                                                       =
               =20
CONFIG_SCSI_TGT=3Dm                                                    =
                                                                       =
               =20
CONFIG_SCSI_NETLINK=3Dy                                                =
                                                                       =
               =20
CONFIG_SCSI_PROC_FS=3Dy                                                =
                                                                       =
               =20
# SCSI support type (disk, tape, CD-ROM)                               =
                                                                       =
             =20
CONFIG_SCSI_ENCLOSURE=3Dm                                              =
                                                                       =
               =20
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs            =
                                                                       =
             =20
CONFIG_SCSI_MULTI_LUN=3Dy                                              =
                                                                       =
               =20
# CONFIG_SCSI_CONSTANTS is not set                                     =
                                                                       =
             =20
CONFIG_SCSI_LOGGING=3Dy                                                =
                                                                       =
               =20
CONFIG_SCSI_SCAN_ASYNC=3Dy                                             =
                                                                       =
               =20
CONFIG_SCSI_WAIT_SCAN=3Dm                                              =
                                                                       =
               =20
# SCSI Transports                                                      =
                                                                       =
             =20
CONFIG_SCSI_SPI_ATTRS=3Dm                                              =
                                                                       =
               =20
CONFIG_SCSI_FC_ATTRS=3Dm                                               =
                                                                       =
               =20
CONFIG_SCSI_FC_TGT_ATTRS=3Dy                                           =
                                                                       =
               =20
CONFIG_SCSI_ISCSI_ATTRS=3Dm                                            =
                                                                       =
               =20
CONFIG_SCSI_SAS_ATTRS=3Dm                                              =
                                                                       =
               =20
CONFIG_SCSI_SAS_LIBSAS=3Dm                                             =
                                                                       =
               =20
CONFIG_SCSI_SAS_ATA=3Dy                                                =
                                                                       =
               =20
CONFIG_SCSI_SAS_HOST_SMP=3Dy                                           =
                                                                       =
               =20
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set                              =
                                                                       =
             =20
CONFIG_SCSI_SRP_ATTRS=3Dm                                              =
                                                                       =
               =20
CONFIG_SCSI_SRP_TGT_ATTRS=3Dy                                          =
                                                                       =
               =20
CONFIG_SCSI_LOWLEVEL=3Dy                                               =
                                                                       =
               =20
CONFIG_ISCSI_TCP=3Dm                                                   =
                                                                       =
               =20
CONFIG_SCSI_CXGB3_ISCSI=3Dm                                            =
                                                                       =
               =20
CONFIG_SCSI_3W_9XXX=3Dm                                                =
                                                                       =
               =20
CONFIG_SCSI_ACARD=3Dm                                                  =
                                                                       =
               =20
CONFIG_SCSI_AACRAID=3Dm                                                =
                                                                       =
               =20
CONFIG_SCSI_AIC7XXX=3Dm                                                =
                                                                       =
               =20
CONFIG_SCSI_AIC7XXX_OLD=3Dm                                            =
                                                                       =
               =20
CONFIG_SCSI_AIC79XX=3Dm                                                =
                                                                       =
               =20
CONFIG_SCSI_AIC94XX=3Dm                                                =
                                                                       =
               =20
CONFIG_SCSI_DPT_I2O=3Dm                                                =
                                                                       =
               =20
CONFIG_SCSI_ADVANSYS=3Dm                                               =
                                                                       =
               =20
CONFIG_SCSI_ARCMSR=3Dm                                                 =
                                                                       =
               =20
CONFIG_SCSI_ARCMSR_AER=3Dy                                             =
                                                                       =
               =20
CONFIG_SCSI_MPT2SAS=3Dm                                                =
                                                                       =
               =20
CONFIG_SCSI_MPT2SAS_MAX_SGE=3D128                                      =
                                                                       =
               =20
CONFIG_SCSI_MPT2SAS_LOGGING=3Dy                                        =
                                                                       =
               =20
CONFIG_SCSI_HPTIOP=3Dm                                                 =
                                                                       =
               =20
CONFIG_SCSI_BUSLOGIC=3Dm                                               =
                                                                       =
               =20
CONFIG_SCSI_DMX3191D=3Dm                                               =
                                                                       =
               =20
CONFIG_SCSI_EATA=3Dm                                                   =
                                                                       =
               =20
CONFIG_SCSI_EATA_TAGGED_QUEUE=3Dy                                      =
                                                                       =
               =20
CONFIG_SCSI_EATA_LINKED_COMMANDS=3Dy                                   =
                                                                       =
               =20
CONFIG_SCSI_EATA_MAX_TAGS=3D62                                         =
                                                                       =
               =20
CONFIG_SCSI_FUTURE_DOMAIN=3Dm                                          =
                                                                       =
               =20
CONFIG_SCSI_GDTH=3Dm                                                   =
                                                                       =
               =20
CONFIG_SCSI_IPS=3Dm                                                    =
                                                                       =
               =20
CONFIG_SCSI_INITIO=3Dm
CONFIG_SCSI_INIA100=3Dm
CONFIG_SCSI_PPA=3Dm
CONFIG_SCSI_IMM=3Dm
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_MVSAS=3Dm
CONFIG_SCSI_STEX=3Dm
CONFIG_SCSI_SYM53C8XX_2=3Dm
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D256
CONFIG_SCSI_SYM53C8XX_MMIO=3Dy
CONFIG_SCSI_IPR=3Dm
CONFIG_SCSI_IPR_TRACE=3Dy
CONFIG_SCSI_IPR_DUMP=3Dy
CONFIG_SCSI_QLOGIC_1280=3Dm
CONFIG_SCSI_QLA_FC=3Dm
CONFIG_SCSI_QLA_ISCSI=3Dm
CONFIG_SCSI_LPFC=3Dm
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=3Dm
CONFIG_SCSI_DC390T=3Dm
CONFIG_SCSI_DEBUG=3Dm
CONFIG_SCSI_SRP=3Dm
CONFIG_SCSI_LOWLEVEL_PCMCIA=3Dy
CONFIG_SCSI_DH=3Dm
CONFIG_SCSI_DH_RDAC=3Dm
CONFIG_SCSI_DH_HP_SW=3Dm
CONFIG_SCSI_DH_EMC=3Dm
CONFIG_SCSI_DH_ALUA=3Dm
CONFIG_SCSI_OSD_INITIATOR=3Dm
CONFIG_SCSI_OSD_ULD=3Dm
CONFIG_SCSI_OSD_DPRINT_SENSE=3D1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_I2O_SCSI=3Dm
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
CONFIG_ISCSI_IBFT_FIND=3Dy
CONFIG_ISCSI_IBFT=3Dm


--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
