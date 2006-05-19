From: Fo Loeng Wahidin <flw@zenucom.com>
Subject: Newbie - Help required on SAS driver for adp94xx for FC5
Date: Fri, 19 May 2006 18:43:00 +1000
Message-ID: <446D8514.4030401@zenucom.com>
Reply-To: flw@zenucom.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 146.041.dsl.syd.iprimus.net.au ([211.26.164.146]:11200 "EHLO
	zmail.zenucom.com") by vger.kernel.org with ESMTP id S932197AbWESInJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 04:43:09 -0400
Received: from [192.168.20.188] ([192.168.20.188])
	(authenticated bits=0)
	by zmail.zenucom.com (8.13.4/8.13.4) with ESMTP id k4J8bHVb023627
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 18:37:17 +1000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I am a newbie in kernel configuration.

I am posting on this m-list to get some help with an FC5 installation.

I have read some earlier discussion on
"Adaptec SAS integration notes" last December,
however I could not understand what needs to be done.

I got a IBM xseries 306m, with the Adaptec 9405 controller and
a 70 GB SAS drive, and I am trying to install FC5 on it.

I got some driver on the cdrom, however they are for Rhel4 and
it does not seems to recognize the disk during FC5 installation.

So I thought of recompiling the driver on other FC5 machine.

I installed another FC5 on a normal IDE drive machine and downloaded
the adp94xx-1.0.8-6.src.tgz from adaptec website.

I have also installed the kernel develpment rpm of the FC5.
It put the files in
/usr/src/kernels/2.6.15-1.2054_FC5-i686

I unpack the driver from adaptec and put it at
/usr/src/kernels/2.6.15-1.2054_FC5-i686/drivers/scsi/adp94xx
as instructed.

I then did a
make -C /usr/src/kernels/2.6.15-1.2054_FC5-i686 M=3D`pwd`
as mentioned by the readme

However I then got lots of error message.

Can somebody point me to the location a driver that I can use for FC5=20
please?

Thanks

=46o Loeng Wahidin

The content of the Makefile is as follow:
------------------------------------------------
#
# Makefile for the Linux adp94xx SAS driver.
#
# $Id: //depot/razor/linux/src/Makefile.2_6#10 $
#

EXTRA_CFLAGS +=3D -Idrivers/scsi -UASD_DEBUG -DSEQUENCER_UPDATE=20
-DSATA_SKIP_FIX -DCONCURRENT_SUPPORT

ifeq ($(CONFIG_SCSI_ADP94XX),)
        CONFIG_SCSI_ADP94XX=3Dm
endif

obj-$(CONFIG_SCSI_ADP94XX)      +=3D adp94xx.o

# OSM and HWI Specific Files
adp94xx-y                       +=3D adp94xx_osm.o        \
                                   adp94xx_hwi.o        \
                                   adp94xx_seq.o        \
                                   adp94xx_discover.o

# IOCTL Specific File
adp94xx-y                       +=3D adp94xx_ioctl.o

# SATA Specific File
adp94xx-y                       +=3D adp94xx_sata.o
------------------------------------------------

I have tried to do a symbolic link of
/usr/src/kernels/2.6.15-1.2054_FC5-i686 to /usr/src/linux
and re-run, and it is still giving error message.

The error message that I got is

[root@localhost /usr/src/linux/drivers/scsi/adp94xx]# make -C=20
/usr/src/linux M=3D`pwd`
make: Entering directory `/usr/src/kernels/2.6.15-1.2054_FC5-i686'
  LD      /usr/src/linux/drivers/scsi/adp94xx/built-in.o
  CC [M]  /usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.o
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:46:5: warning:=20
"KDB_ENABLE" is not defined
In file included from /usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c=
:49:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:77:18: error: scsi.h:=
=20
No such file or directory
In file included from /usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c=
:49:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:420: error: invalid=20
use of undefined type =E2struct scsi_cmnd=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:427: error: field=20
=E2scsi_cmd=E2 has incomplete type
In file included from /usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c=
:49:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:597: error: expected=20
specifier-qualifier-list before =E2Scsi_Device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1230: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1231: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1232: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1233: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1248: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1255: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1262: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1269: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1275: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.h:1306: error: expected=
=20
declaration specifiers or =E2...=E2 before =E2Scsi_Cmnd=E2
In file included from /usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c=
:53:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_inline.h: In function=20
=E2asd_next_device_to_run=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_inline.h:773: error: =E2str=
uct=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_inline.h: At top level:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_inline.h:904: error:=20
expected =E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_inline.h:905: error:=20
expected =E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_inline.h:993: error:=20
expected =E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_inline.h:1018: error:=20
expected =E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:59: error: expected=20
=E2=3D=E2, =E2,=E2, =E2;=E2, =E2asm=E2 or =E2__attribute__=E2 before =E2=
asd_sht=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:126: error: expected=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:128: error: expected=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:130: error: expected=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:135: error: expected=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:136: error: expected=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:137: error: expected=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_unmap_scb=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:400: error:=20
=E2Scsi_Cmnd=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:400: error: (Each=20
undeclared identifier is reported only once
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:400: error: for each=20
function it appears in.)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:400: error: =E2cmd=E2=
=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:401: warning: ISO C90=
=20
forbids mixed declarations and code
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_check_device_queue=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:429: error: =E2struct=
=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:432: error: =E2struct=
=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:705:5: warning:=20
"KDB_ENABLE" is not defined
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function =E2asd_i=
nit=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:709: warning: implici=
t=20
declaration of function =E2asd_detect=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:709: error: =E2asd_sh=
t=E2=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: At top level:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:956: error: expected=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_register_host=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1083: error: =E2asd_s=
ht=E2=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_alloc_device=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1208: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_free_device=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1245: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_flush_device_queue=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1360: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1373: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1398: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1400: warning:=20
implicit declaration of function =E2asd_cmd_set_host_status=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1400: error:=20
=E2DID_NO_CONNECT=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1404: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1408: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1423: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1424: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1432: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1467: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1472: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1496: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_dev_timed_unfreeze=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1574: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1586: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_timed_run_dev_queue=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1605: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1611: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1612: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_scb_done=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1629: error:=20
=E2Scsi_Cmnd=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1629: error: =E2cmd=E2=
=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1630: warning: ISO C9=
0=20
forbids mixed declarations and code
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1680: error: =E2DID_O=
K=E2=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1699: error:=20
=E2DID_ERROR=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1709: error:=20
=E2DID_ABORT=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1729: error:=20
=E2DID_NO_CONNECT=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1734: error:=20
=E2DID_SOFT_ERROR=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1774: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_handle_sas_status=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1875: error:=20
=E2Scsi_Cmnd=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1875: error: =E2cmd=E2=
=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1882: error:=20
=E2DID_ERROR=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1896: error:=20
=E2DID_SOFT_ERROR=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1924: warning:=20
implicit declaration of function =E2asd_cmd_set_driver_status=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1924: error:=20
=E2DRIVER_SENSE=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1930: error:=20
=E2UNIT_ATTENTION=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1938: error: =E2DID_O=
K=E2=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:1939: warning:=20
implicit declaration of function =E2asd_cmd_set_scsi_status=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2022: warning:=20
implicit declaration of function =E2asd_cmd_set_retry_status=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2041: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2041: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: At top level:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2073: error: expected=
=20
declaration specifiers or =E2...=E2 before =E2Scsi_Cmnd=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_setup_data=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2089: error: =E2cmd=E2=
=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_build_sas_scb=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2179: error:=20
=E2Scsi_Cmnd=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2179: error: =E2cmd=E2=
=20
undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2181: warning: ISO C9=
0=20
forbids mixed declarations and code
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2195: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2215: warning:=20
implicit declaration of function =E2scsi_populate_tag_msg=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2216: error:=20
=E2MSG_SIMPLE_TAG=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2223: error: too many=
=20
arguments to function =E2asd_setup_data=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_configure_target=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2616: warning:=20
implicit declaration of function =E2scsi_add_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_dev_intl_times_out=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2724: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_clear_device_io=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2769: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_destroy_device=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2804: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2820: error:=20
=E2DID_NO_CONNECT=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2824: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2833: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2851: warning:=20
implicit declaration of function =E2scsi_device_set_state=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2851: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2851: error:=20
=E2SDEV_OFFLINE=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2859: warning:=20
implicit declaration of function =E2scsi_remove_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:2859: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_get_os_platform_map_from_sasaddr=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:3153: error:=20
=E2Scsi_Device=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:3153: error:=20
=E2scsi_device=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:3154: warning: ISO C9=
0=20
forbids mixed declarations and code
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:3170: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_get_sas_addr_from_platform_map=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:3206: warning:=20
comparison is always false due to limited range of data type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_find_pending_scb_by_qtag=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:3247: error:=20
dereferencing pointer to incomplete type
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: At top level:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:4818: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5014: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5026: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5055: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_get_user_tagdepth=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5135: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5136: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_set_device_queue_depth=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5159: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5160: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5163: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5163: error: =E2struc=
t=20
asd_device=E2 has no member named =E2target=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: In function=20
=E2asd_set_tags=E2:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5229: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5232: warning:=20
implicit declaration of function =E2scsi_adjust_queue_depth=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5232: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5233: error:=20
=E2MSG_SIMPLE_TAG=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5237: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5238: error:=20
=E2MSG_ORDERED_TAG=E2 undeclared (first use in this function)
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5248: error: =E2struc=
t=20
asd_device=E2 has no member named =E2scsi_device=E2
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c: At top level:
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:5383: error: expected=
=20
=E2)=E2 before =E2*=E2 token
/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.c:6162: error: expected=
=20
=E2=3D=E2, =E2,=E2, =E2;=E2, =E2asm=E2 or =E2__attribute__=E2 before =E2=
asd_sht=E2
make[1]: *** [/usr/src/linux/drivers/scsi/adp94xx/adp94xx_osm.o] Error =
1
make: *** [_module_/usr/src/linux/drivers/scsi/adp94xx] Error 2
make: Leaving directory `/usr/src/kernels/2.6.15-1.2054_FC5-i686'



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
