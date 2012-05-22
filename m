From: Francesco Santagata <francesco.santagata@foosoft.it>
Subject: Multipath failing path when mpt2sas report an aborted command and sd
 report hostbyte=DID_SOFT_ERROR
Date: Tue, 22 May 2012 19:57:33 +0200
Message-ID: <CAJ9D7cDcT+hDWbXyFytHVyc1ZJYAa+gAy==Bpr66HDRLg=_PaA@mail.gmail.com>
References: <CAJ9D7cBXzJuzCQtQn3YzbdnjVhCEXRbJXPLHEUVtqgrEAydYuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58273 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2EVR5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 13:57:34 -0400
Received: by yenm10 with SMTP id m10so5655076yen.19
        for <linux-scsi@vger.kernel.org>; Tue, 22 May 2012 10:57:33 -0700 (PDT)
In-Reply-To: <CAJ9D7cBXzJuzCQtQn3YzbdnjVhCEXRbJXPLHEUVtqgrEAydYuw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello linux-scsi,

I'm reporting a problem with multipath in conjunction with SAS2 HBA,
mpt2sas, SAS2Expander and SATA disks without multiplexer.

OS:=A0=A0=A0=A0=A0 =A0=A0 RedHat 6.2
Kernel:=A0=A0=A0 2.6.32-220.17.1.el6.x86_64
HBA:=A0=A0=A0=A0=A0=A0 LSI 9205-8e
mpt2sas=A0 13.00.00.00
=46W Ver=A0=A0 13.00.57.00
BIOS=A0=A0=A0=A0=A0=A0 07.25.00.00
DISK=A0=A0=A0=A0=A0=A0 Hitachi HDS723020BLA642
JBOD=A0=A0=A0=A0=A0 NEWISYS=A0 NDS-4600-JD=A0 Firmware:0501
N-Disk=A0=A0=A0=A0 60
MultiPath device-mapper-multipath.x86_64 0.4.9

I'm using sata drives directly attached to the JBOD without any sataMux=
=2E
I'm using multipath even if I can see drives attached to only only
scsi address; this is because of the architecture of the software i'm
building on top of the hardware.

An example:

mpathak (35000cca369e6df1b) dm-50 ATA,Hitachi HDS72302
size=3D1.8T features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
=A0 `- 9:0:51:0 sday 67:32=A0 active ready running
mpathr (35000cca369e7a662) dm-21 ATA,Hitachi HDS72302
size=3D1.8T features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
=A0 `- 9:0:22:0 sdv=A0 65:80=A0 active ready running



When I'm doing heavy reads (dd with bs=3D65536) on all 60 disks i'm
experiencing this problem:

May 14 15:48:42 localhost multipathd: 67:0: mark as failed
May 14 15:48:42 localhost multipathd: mpathbg: remaining active paths: =
0
May 14 15:48:47 localhost multipathd: mpathbg: sdaw - serial checker
reports path is up
May 14 15:48:47 localhost multipathd: 67:0: reinstated
May 14 15:48:47 localhost multipathd: mpathbg: remaining active paths: =
1

and if I look into kernel messages this is what I see:


ay 14 15:48:42 localhost kernel: mpt2sas1:
enclosure_logical_id(0x500093d000421000), slot(21)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 handle(0x003d),
ioc_status(scsi ioc terminated)(0x004b), smid(315)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 request_len(16384=
),
underflow(16384), resid(16384)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 tag(4),
transfer_count(0), sc->result(0x000b0000)
May 14 15:48:42 localhost kernel: mpt2sas1:
scsi_status(good)(0x00), scsi_state( )(0x00)
May 14 15:48:42 localhost kernel: mpt2sas1: log_info(0x31080000):
originator(PL), code(0x08), sub_code(0x0000)
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Done: SUCCESS
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 25 18 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Unhandled error =
code
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 25 18 00 00 20 00
May 14 15:48:42 localhost kernel: end_request: I/O error, dev sdaw,
sector 672867608
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 33 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:10:0: [sdj] CDB: Read(10):
28 00 28 d9 7e d8 00 00 f0 00
May 14 15:48:42 localhost kernel: sd 11:0:11:0: [sdk] CDB: Read(10):
28 00 21 56 33 98 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:57:0: [sdbe] CDB: Read(10):
28 00 26 aa 3e a8 00 00 68 00
May 14 15:48:42 localhost kernel: sd 11:0:10:0: [sdj] CDB: Read(10):
28 00 28 d9 92 68 00 00 08 00
May 14 15:48:42 localhost kernel: sd 11:0:12:0: [sdl] CDB: Read(10):
28 00 21 56 33 98 00 00 a0 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 23 c8 00 00 60 00
May 14 15:48:42 localhost kernel: mpt2sas1:
sas_address(0x500093d000421090), phy(16)
May 14 15:48:42 localhost kernel: mpt2sas1:
enclosure_logical_id(0x500093d000421000), slot(21)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 handle(0x003d),
ioc_status(success)(0x0000), smid(525)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 request_len(49152=
),
underflow(49152), resid(49152)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 tag(0),
transfer_count(0), sc->result(0x00000002)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 scsi_status(check
condition)(0x02), scsi_state(autosense valid )(0x01)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 [sense_key,asc,as=
cq]:
[0x03,0x11,0x00], count(18)
May 14 15:48:42 localhost kernel: sd 11:0:44:0: [sdar] CDB: Read(10):
28 00 28 d9 7e d8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:3:0: [sdd] CDB: Read(10): 28
00 27 e9 30 10 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:7:0: [sdg] CDB: Read(10): 28
00 21 56 34 18 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 33 f8 00 00 40 00
May 14 15:48:42 localhost kernel: sd 11:0:48:0: [sdav] CDB: Read(10):
28 00 27 c7 f1 08 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:37:0: [sdak] CDB: Read(10):
28 00 28 d9 7e f8 00 00 c8 00
May 14 15:48:42 localhost kernel: sd 11:0:19:0: [sds] CDB: Read(10):
28 00 28 d9 7e d8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:38:0: [sdal] CDB: Read(10):
28 00 28 d9 7e d8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 24 d0 00 00 20 00
May 14 15:48:42 localhost kernel: mpt2sas1:
sas_address(0x500093d000421090), phy(16)
May 14 15:48:42 localhost kernel: mpt2sas1:
enclosure_logical_id(0x500093d000421000), slot(21)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 handle(0x003d),
ioc_status(scsi ioc terminated)(0x004b), smid(495)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 request_len(16384=
),
underflow(16384), resid(16384)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 tag(2),
transfer_count(0), sc->result(0x000b0000)
May 14 15:48:42 localhost kernel: mpt2sas1:
scsi_status(good)(0x00), scsi_state( )(0x00)
May 14 15:48:42 localhost kernel: mpt2sas1: log_info(0x31080000):
originator(PL), code(0x08), sub_code(0x0000)
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 26 88 00 00 20 00
May 14 15:48:42 localhost kernel: mpt2sas1:
sas_address(0x500093d000421090), phy(16)
May 14 15:48:42 localhost kernel: mpt2sas1:
enclosure_logical_id(0x500093d000421000), slot(21)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 handle(0x003d),
ioc_status(scsi ioc terminated)(0x004b), smid(27)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 request_len(16384=
),
underflow(16384), resid(16384)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 tag(3),
transfer_count(0), sc->result(0x000b0000)
May 14 15:48:42 localhost kernel: mpt2sas1:
scsi_status(good)(0x00), scsi_state( )(0x00)
May 14 15:48:42 localhost kernel: mpt2sas1: log_info(0x31080000):
originator(PL), code(0x08), sub_code(0x0000)
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 25 38 00 00 80 00
May 14 15:48:42 localhost kernel: mpt2sas1:
sas_address(0x500093d000421090), phy(16)
May 14 15:48:42 localhost kernel: mpt2sas1:
enclosure_logical_id(0x500093d000421000), slot(21)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 handle(0x003d),
ioc_status(scsi ioc terminated)(0x004b), smid(446)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 request_len(65536=
),
underflow(65536), resid(65536)
May 14 15:48:42 localhost kernel: mpt2sas1: =A0=A0=A0 tag(5),
transfer_count(0), sc->result(0x000b0000)
May 14 15:48:42 localhost kernel: mpt2sas1:
scsi_status(good)(0x00), scsi_state( )(0x00)
May 14 15:48:42 localhost kernel: sd 11:0:19:0: [sds] CDB:
May 14 15:48:42 localhost kernel: mpt2sas1: log_info(0x31080000):
originator(PL), code(0x08), sub_code(0x0000)
May 14 15:48:42 localhost kernel: Read(10): 28 00 48 09 3b 50 00 00 08 =
00
May 14 15:48:42 localhost kernel: sd 11:0:34:0: [sdah] CDB: Read(10):
28 00 21 56 33 98 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:39:0: [sdam] CDB: Read(10):
28 00 28 d9 7e d8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:27:0: [sdaa] CDB: Read(10):
28 00 26 aa 3e a8 00 00 60 00
May 14 15:48:42 localhost kernel: sd 11:0:50:0: [sdax] CDB: Read(10):
28 00 21 56 33 98 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:37:0: [sdak] CDB: Read(10):
28 00 28 d9 92 68 00 00 08 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Done: SUCCESS
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Result:
hostbyte=3Dinvalid driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: sd 11:0:18:0: [sdr] CDB:
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB:
Read(10)Read(10):: 28 28 00 00 27 28 c7 1b f0 23 80 c8 00 00 00 e8 00
00
May 14 15:48:42 localhost kernel: 60 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Sense Key :
Medium Error [current]
May 14 15:48:42 localhost kernel: sd 11:0:13:0: [sdm] CDB: Info fld=3D0=
x281b23f2
May 14 15:48:42 localhost kernel: Read(10): 28
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw]=A0 00 26 aa
3eAdd. Sense: Unrecovered read error a8
May 14 15:48:42 localhost kernel: 00 00 68 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Unhandled sense =
code
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Result:
hostbyte=3Dinvalid driverbyte=3DDRIVER_SENSE
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Sense Key :
Medium Error [current]
May 14 15:48:42 localhost kernel: Info fld=3D0x281b23f2
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Add. Sense:
Unrecovered read error
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 23 c8 00 00 60 00
May 14 15:48:42 localhost kernel: end_request: critical target error,
dev sdaw, sector 672867314
May 14 15:48:42 localhost kernel: end_request: I/O error, dev dm-48,
sector 672868344
May 14 15:48:42 localhost kernel: sd 11:0:6:0: [sdf] CDB: Read(10): 28
00 21 56 33 90 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:23:0: [sdw] CDB: Read(10):
28 00 21 56 33 90 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:13:0: [sdm] CDB: Read(10):
28 00 26 aa 3f 98 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:0:0: [sda] CDB: Read(10): 28
00 28 d9 7e d8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:44:0: [sdar] CDB: Read(10):
28 00 28 d9 7f e8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:60:0: [sdbh] CDB: Read(10):
28 00 26 aa 3e b0 00 00 60 00
May 14 15:48:42 localhost kernel: sd 11:0:39:0: [sdam] CDB: Read(10):
28 00 48 09 3b 50 00 00 08 00
May 14 15:48:42 localhost kernel: sd 11:0:26:0: [sdz] CDB: Read(10):
28 00 21 56 34 20 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:32:0: [sdaf] CDB: Read(10):
28 00 26 aa
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Done:=A0 3fSUCCE=
SS
May 14 15:48:42 localhost kernel: 10
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw]=A0 00Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB:=A0 20Read(1=
0) 00:
May 14 15:48:42 localhost kernel: 28 00 28 1b 26 88 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Unhandled error =
code
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 26 88 00 00
May 14 15:48:42 localhost kernel: sd 11:0:32:0: [sdaf] CDB:=A0 20Read(1=
0) 00:
May 14 15:48:42 localhost kernel: 28
May 14 15:48:42 localhost kernel: end_request: I/O error, dev sdaw,
sector 672867976
May 14 15:48:42 localhost kernel: 00 26 aa 3e 08 00 01 08 00
May 14 15:48:42 localhost kernel: sd 11:0:27:0: [sdaa] CDB: Read(10):
28 00 26 aa 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:36:0: [sdaj] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:9:0: [sdi] CDB: Read(10): 28
00 27 c7 f0 e0 00 00 c8 00
May 14 15:48:42 localhost kernel: sd 11:0:38:0: [sdal] CDB: Read(10):
28 00 28 d9 7f e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:37:0: [sdak] CDB: Read(10):
28 00 28 d9 7f e8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:9:0: [sdi] CDB: Read(10): 28
00 27 c7 f1 d0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:59:0: [sdbg] CDB: Read(10):
28 00 28 d9 7e d8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:28:0: [sdab] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:24:0: [sdx] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:33:0: [sdag] CDB: Read(10):
28 00 28 d9 7e f8 00 00 c8 00
May 14 15:48:42 localhost kernel: sd 11:0:33:0: [sdag] CDB: Read(10):
28 00 28 d9 7f e8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:33:0: [sdag] CDB: Read(10):
28 00 28 d9 92 68 00 00 08 00
May 14 15:48:42 localhost kernel: sd 11:0:10:0: [sdj] CDB: Read(10):
28 00 28 d9 7f e8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:27:0: [sdaa] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:55:0: [sdbc] CDB: Read(10):
28 00 27 c7 f1 70 00 00 80 00
May 14 15:48:42 localhost kernel: sd 11:0:55:0: [sdbc] CDB: Read(10):
28 00 27 c7 f0 80 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Done: SUCCESS
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 25 38 00 00 80 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Unhandled error =
code
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB: Read(10):
28 00 28 1b 25 38 00 00 80 00
May 14 15:48:42 localhost kernel: end_request: I/O error, dev sdaw,
sector 672867640
May 14 15:48:42 localhost kernel: sd 11:0:60:0: [sdbh] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:19:0: [sds] CDB: Read(10):
28 00 28 d9 7f e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:25:0: [sdy] CDB: Read(10):
28 00 27 c7 f1 68 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:18:0: [sdr] CDB: Read(10):
28 00 27 c7 f1 70 00 00 80 00
May 14 15:48:42 localhost kernel: sd 11:0:25:0: [sdy] CDB: Read(10):
28 00 27 c7 f0 80 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:17:0: [sdq] CDB: Read(10):
28 00 21 56 34 20 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:22:0: [sdv] CDB: Read(10):
28 00 28 d9 7e d0 00 00 f0 00
May 14 15:48:42 localhost kernel: end_request: I/O error, dev dm-48,
sector 672867976
May 14 15:48:42 localhost kernel: sd 11:0:59:0: [sdbg] CDB: Read(10):
28 00 28 d9 7f e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:43:0: [sdaq] CDB: Read(10):
28 00 27 c7 f0 78 00 01 70 00
May 14 15:48:42 localhost kernel: sd 11:0:8:0: [sdh] CDB: Read(10): 28
00 27 c7 f1 68 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:8:0: [sdh] CDB: Read(10): 28
00 27 c7 f0 80 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:39:0: [sdam] CDB: Read(10):
28 00 28 d9 7f e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 30 e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:40:0: [sdan] CDB: Read(10):
28 00 27 e9 30 a0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 30 e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:16:0: [sdp] CDB: Read(10):
28 00 27 e9 30 a0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:42:0: [sdap] CDB: Read(10):
28 00 27 e9 30 e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 31 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:53:0: [sdba] CDB: Read(10):
28 00 27 e9 30 98 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:29:0: [sdac] CDB: Read(10):
28 00 27 e9 30 e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 30 98 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 31 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:47:0: [sdau] CDB: Read(10):
28 00 27 c7 f0 80 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:29:0: [sdac] CDB: Read(10):
28 00 27 e9 30 38 00 00 40 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 30 98 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:42:0: [sdap] CDB: Read(10):
28 00 27 e9 31 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:47:0: [sdau] CDB: Read(10):
28 00 27 c7 f1 68 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:16:0: [sdp] CDB: Read(10):
28 00 27 e9 30 e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:42:0: [sdap] CDB: Read(10):
28 00 27 e9 30 98 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:16:0: [sdp] CDB: Read(10):
28 00 27 e9 31 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 30 d8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:59:0: [sdbg] CDB: Read(10):
28 00 48 09 3b 50 00 00 08 00
May 14 15:48:42 localhost kernel: sd 11:0:16:0: [sdp] CDB: Read(10):
28 00 27 e9 31 48 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 31 40 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:35:0: [sdai] CDB: Read(10):
28 00 26 aa 3e a8 00 00 60 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 30 f8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 30 d8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:41:0: [sdao] CDB: Read(10):
28 00 26 aa 3e b0 00 00 60 00
May 14 15:48:42 localhost kernel: sd 11:0:41:0: [sdao] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:36:0: [sdaj] CDB: Read(10):
28 00 26 aa 3f 38 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:6:0: [sdf] CDB: Read(10): 28
00 21 56 34 60 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 34 60 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:32:0: [sdaf] CDB: Read(10):
28 00 26 aa 3f 30 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:13:0: [sdm] CDB: Read(10):
28 00 26 aa 3f 10 00 00 40 00
May 14 15:48:42 localhost kernel: sd 11:0:7:0: [sdg] CDB: Read(10): 28
00 21 56 34 60 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:7:0: [sdg] CDB: Read(10): 28
00 21 56 34 40 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:11:0: [sdk] CDB: Read(10):
28 00 21 56 34 60 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:34:0: [sdah] CDB: Read(10):
28 00 21 56 34 40 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:23:0: [sdw] CDB: Read(10):
28 00 21 56 34 58 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:6:0: [sdf] CDB: Read(10): 28
00 21 56 34 38 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:38:0: [sdal] CDB: Read(10):
28 00 28 d9 7f c0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:17:0: [sdq] CDB: Read(10):
28 00 21 56 34 40 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:5:0: [sde] CDB: Read(10): 28
00 27 c7 f0 80 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:5:0: [sde] CDB: Read(10): 28
00 27 c7 f1 68 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:53:0: [sdba] CDB: Read(10):
28 00 27 e9 30 d8 00 00 40 00
May 14 15:48:42 localhost kernel: sd 11:0:3:0: [sdd] CDB: Read(10): 28
00 27 e9 30 98 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:35:0: [sdai] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:53:0: [sdba] CDB: Read(10):
28 00 27 e9 31 20 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 34 38 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:40:0: [sdan] CDB: Read(10):
28 00 27 e9 30 e0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:40:0: [sdan] CDB:
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Done: Read(10)SU=
CCESS
May 14 15:48:42 localhost kernel: :
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw]=A0 28Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB:
27Read(10) e9: 31 28 48 00 00 28 00 1b 20 24 00 d0
May 14 15:48:42 localhost kernel: 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Unhandled error =
code
May 14 15:48:42 localhost kernel: sd 11:0:60:0: [sdbh] CDB:
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] Read(10)Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 14 15:48:42 localhost kernel: :
May 14 15:48:42 localhost kernel: sd 11:0:49:0: [sdaw] CDB:
28Read(10) 00: 26 28 aa 00 3f 28 30 1b 00 24 00 d0 20 00 00 00
May 14 15:48:42 localhost kernel: 20 00
May 14 15:48:42 localhost kernel: end_request: I/O error, dev sdaw,
sector 672867536
May 14 15:48:42 localhost kernel: sd 11:0:11:0: [sdk] CDB: Read(10):
28 00 21 56 34 40 00 00 80 00
May 14 15:48:42 localhost kernel: sd 11:0:40:0: [sdan] CDB: Read(10):
28 00 27 e9 31 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:0:0: [sda] CDB: Read(10): 28
00 28 d9 7f e8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:29:0: [sdac] CDB: Read(10):
28 00 27 e9 31 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:42:0: [sdap] CDB: Read(10):
28 00 27 e9 30 c0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 31 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 31 60 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 30 98 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:59:0: [sdbg] CDB: Read(10):
28 00 28 d9 7f c0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 30 98 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 31 60 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:0:0: [sda] CDB: Read(10): 28
00 28 d9 7f c0 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:11:0: [sdk] CDB: Read(10):
28 00 21 56 34 c8 00 00 40 00
May 14 15:48:42 localhost kernel: sd 11:0:17:0: [sdq] CDB: Read(10):
28 00 21 56 34 c8 00 00 40 00
May 14 15:48:42 localhost kernel: sd 11:0:44:0: [sdar] CDB: Read(10):
28 00 28 d9 80 08 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:38:0: [sdal] CDB: Read(10):
28 00 28 d9 80 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 34 c0 00 00 40 00
May 14 15:48:42 localhost kernel: end_request: I/O error, dev dm-48,
sector 672867640
May 14 15:48:42 localhost kernel: sd 11:0:10:0: [sdj] CDB: Read(10):
28 00 28 d9 7f c8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 31 20 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:41:0: [sdao] CDB: Read(10):
28 00 26 aa 3f 38 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:12:0: [sdl] CDB: Read(10):
28 00 21 56 34 40 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:35:0: [sdai] CDB: Read(10):
28 00 26 aa 3f 30 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:11:0: [sdk] CDB: Read(10):
28 00 21 56 35 08 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:27:0: [sdaa] CDB: Read(10):
28 00 26 aa 3f 30 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:19:0: [sds] CDB: Read(10):
28 00 28 d9 7f c0 00 00 68 00
May 14 15:48:42 localhost kernel: sd 11:0:3:0: [sdd] CDB: Read(10): 28
00 27 e9 31 80 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:39:0: [sdam] CDB: Read(10):
28 00 28 d9 7f c0 00 00 68 00
May 14 15:48:42 localhost kernel: sd 11:0:3:0: [sdd] CDB: Read(10): 28
00 27 e9 30 b8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:59:0: [sdbg] CDB: Read(10):
28 00 28 d9 80 00 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 30 b8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:40:0: [sdan] CDB: Read(10):
28 00 27 e9 30 c0 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 30 b8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:53:0: [sdba] CDB: Read(10):
28 00 27 e9 30 b8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:20:0: [sdt] CDB: Read(10):
28 00 27 c7 f0 78 00 00 f0 00
May 14 15:48:42 localhost kernel: sd 11:0:20:0: [sdt] CDB: Read(10):
28 00 27 c7 f1 68 00 00 80 00
May 14 15:48:42 localhost kernel: sd 11:0:16:0: [sdp] CDB: Read(10):
28 00 27 e9 30 c0 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:57:0: [sdbe] CDB: Read(10):
28 00 26 aa 3f 10 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:42:0: [sdap] CDB: Read(10):
28 00 27 e9 31 20 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 30 b8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 30 b8 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:6:0: [sdf] CDB: Read(10): 28
00 21 56 34 80 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 35 08 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 31 c8 00 00 c8 00
May 14 15:48:42 localhost kernel: sd 11:0:24:0: [sdx] CDB: Read(10):
28 00 26 aa 3f 30 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:34:0: [sdah] CDB: Read(10):
28 00 21 56 34 80 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:17:0: [sdq] CDB: Read(10):
28 00 21 56 35 08 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:50:0: [sdax] CDB: Read(10):
28 00 21 56 34 40 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:33:0: [sdag] CDB: Read(10):
28 00 28 d9 7f c8 00 00 60 00
May 14 15:48:42 localhost kernel: sd 11:0:7:0: [sdg] CDB: Read(10): 28
00 21 56 34 80 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:22:0: [sdv] CDB: Read(10):
28 00 28 d9 7f c0 00 00 40 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 31 20 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:23:0: [sdw] CDB: Read(10):
28 00 21 56 34 38 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 31 20 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:40:0: [sdan] CDB: Read(10):
28 00 27 e9 31 a8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 32 08 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:40:0: [sdan] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:16:0: [sdp] CDB: Read(10):
28 00 27 e9 31 a8 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:16:0: [sdp] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:42:0: [sdap] CDB: Read(10):
28 00 27 e9 32 10 00 00 80 00
May 14 15:48:42 localhost kernel: sd 11:0:42:0: [sdap] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:38:0: [sdal] CDB: Read(10):
28 00 28 d9 80 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:53:0: [sdba] CDB: Read(10):
28 00 27 e9 31 40 00 01 50 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 32 08 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:37:0: [sdak] CDB: Read(10):
28 00 28 d9 7f c8 00 00 60 00
May 14 15:48:42 localhost kernel: sd 11:0:53:0: [sdba] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:59:0: [sdbg] CDB: Read(10):
28 00 28 d9 80 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:0:0: [sda] CDB: Read(10): 28
00 28 d9 80 08 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:29:0: [sdac] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:0:0: [sda] CDB: Read(10): 28
00 28 d9 80 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:3:0: [sdd] CDB: Read(10): 28
00 27 e9 31 e8 00 00 a8 00
May 14 15:48:42 localhost kernel: sd 11:0:3:0: [sdd] CDB: Read(10): 28
00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:29:0: [sdac] CDB: Read(10):
28 00 27 e9 32 70 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:29:0: [sdac] CDB: Read(10):
28 00 27 e9 30 98 00 01 b8 00
May 14 15:48:42 localhost kernel: sd 11:0:6:0: [sdf] CDB: Read(10): 28
00 21 56 35 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 31 20 00 00 e8 00
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 35 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 32 08 00 00 88 00
May 14 15:48:42 localhost kernel: sd 11:0:34:0: [sdah] CDB: Read(10):
28 00 21 56 35 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:56:0: [sdbd] CDB: Read(10):
28 00 27 e9 3f 90 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:17:0: [sdq] CDB: Read(10):
28 00 21 56 35 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:10:0: [sdj] CDB: Read(10):
28 00 28 d9 80 08 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:44:0: [sdar] CDB: Read(10):
28 00 28 d9 80 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:7:0: [sdg] CDB: Read(10): 28
00 21 56 35 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:12:0: [sdl] CDB: Read(10):
28 00 21 56 35 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:33:0: [sdag] CDB: Read(10):
28 00 28 d9 80 28 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:57:0: [sdbe] CDB: Read(10):
28 00 26 aa 3f 30 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:17:0: [sdq] CDB: Read(10):
28 00 21 56 35 50 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:6:0: [sdf] CDB: Read(10): 28
00 21 56 35 48 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:46:0: [sdat] CDB: Read(10):
28 00 27 e9 32 50 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:45:0: [sdas] CDB: Read(10):
28 00 21 56 35 48 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:58:0: [sdbf] CDB: Read(10):
28 00 27 e9 32 50 00 00 20 00
May 14 15:48:42 localhost kernel: sd 11:0:51:0: [sday] CDB: Read(10):
28 00 27 e9 32 50 00 00 20 00
May 14 15:48:42 localhost kernel: end_request: critical target error,
dev dm-48, sector 672867272


then some other end_request: I/O error, dev dm-48.

This one I'm reporting is one of the worst case I found because=A0 Sens=
e
Key is reporting a=A0 Medium Error.
I managed to replicate the same scenario even with other Sense Key
like [sense_key,asc,ascq]: [0x0b,0x47,0x03] which seems to be a iuCRC
error.
This happens to a lot of disks, not always to the same one.
And, oh, about the disk sdaw ->=A0 dm-48,=A0 it's fully working, I've
managed to read with dd all the sectors that caused the read error.
The error anyway where logged by smart:

SMART Error Log Version: 1
ATA Error Count: 1
=A0=A0=A0 CR =3D Command Register [HEX]
=A0=A0=A0 FR =3D Features Register [HEX]
=A0=A0=A0 SC =3D Sector Count Register [HEX]
=A0=A0=A0 SN =3D Sector Number Register [HEX]
=A0=A0=A0 CL =3D Cylinder Low Register [HEX]
=A0=A0=A0 CH =3D Cylinder High Register [HEX]
=A0=A0=A0 DH =3D Device/Head Register [HEX]
=A0=A0=A0 DC =3D Device Command Register [HEX]
=A0=A0=A0 ER =3D Error register [HEX]
=A0=A0=A0 ST =3D Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 1 occurred at disk power-on lifetime: 2260 hours (94 days + 4 hou=
rs)
=A0 When the command that caused the error occurred, the device was
active or idle.

=A0 After command completion occurred, registers were:
=A0 ER ST SC SN CL CH DH
=A0 -- -- -- -- -- -- --
=A0 40 51 36 f2 23 1b 08

=A0 Commands leading to the command that caused the error were:
=A0 CR FR SC SN CL CH DH DC=A0=A0 Powered_Up_Time=A0 Command/Feature_Na=
me
=A0 -- -- -- -- -- -- -- --=A0 ----------------=A0 --------------------
=A0 60 80 28 38 25 1b 40 00=A0=A0 5d+00:18:26.240=A0 READ FPDMA QUEUED
=A0 60 20 20 18 25 1b 40 00=A0=A0 5d+00:18:26.237=A0 READ FPDMA QUEUED
=A0 60 20 18 88 26 1b 40 00=A0=A0 5d+00:18:26.235=A0 READ FPDMA QUEUED
=A0 60 20 10 d0 24 1b 40 00=A0=A0 5d+00:18:26.232=A0 READ FPDMA QUEUED
=A0 60 e8 08 28 24 1b 40 00=A0=A0 5d+00:18:26.230=A0 READ FPDMA QUEUED

SMART Self-test log structure revision number 1
No self-tests have been logged.=A0 [To run self-tests, use: smartctl -t=
]


SMART Selective self-test log data structure revision number 1
=A0SPAN=A0 MIN_LBA=A0 MAX_LBA=A0 CURRENT_TEST_STATUS
=A0=A0=A0 1=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0 Not_testin=
g
=A0=A0=A0 2=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0 Not_testin=
g
=A0=A0=A0 3=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0 Not_testin=
g
=A0=A0=A0 4=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0 Not_testin=
g
=A0=A0=A0 5=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0 Not_testin=
g
Selective self-test flags (0x0):
=A0 After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.


please notice kernel: "28 1b 25 38" and smart: "28 38 25 1b", looks to
be the same sector...


What you can see in the logs is that "Result: hostbyte=3DDID_SOFT_ERROR
driverbyte=3DDRIVER_OK" make the multipath fail the only path, without
any retry.

I simulated the same scenario with a patch in scsi_debug.ko and I
verified that presenting to multipath the same scenario :


[sense_key,asc,ascq]: [0x0b,0x47,0x03
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK

the behaviour is different:


May 18 16:46:10 localhost kernel: scsi_debug: cmd 28 00 00 00 12 34 00 =
00 01 00
May 18 16:46:10 localhost kernel: FOO: simulating error:
sense_key,asc,ascq: 0x0b,0x47,0x03
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 [sense_key,asc,a=
scq]:
[0xb,0x47,0x3]
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 <25 0 0 0> non-z=
ero
result=3D0xb0000
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Done: RETRY
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] CDB: Read(10): 28
00 00 00 12 34 00 00 01 00
May 18 16:46:10 localhost kernel: scsi_debug: cmd 28 00 00 00 12 34 00 =
00 01 00
May 18 16:46:10 localhost kernel: FOO: simulating error:
sense_key,asc,ascq: 0x0b,0x47,0x03
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 [sense_key,asc,a=
scq]:
[0xb,0x47,0x3]
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 <25 0 0 0> non-z=
ero
result=3D0xb0000
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Done: RETRY
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] CDB: Read(10): 28
00 00 00 12 34 00 00 01 00
May 18 16:46:10 localhost kernel: scsi_debug: cmd 28 00 00 00 12 34 00 =
00 01 00
May 18 16:46:10 localhost kernel: FOO: simulating error:
sense_key,asc,ascq: 0x0b,0x47,0x03
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 [sense_key,asc,a=
scq]:
[0xb,0x47,0x3]
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 <25 0 0 0> non-z=
ero
result=3D0xb0000
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Done: RETRY
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] CDB: Read(10): 28
00 00 00 12 34 00 00 01 00
May 18 16:46:10 localhost kernel: scsi_debug: cmd 28 00 00 00 12 34 00 =
00 01 00
May 18 16:46:10 localhost kernel: FOO: simulating error:
sense_key,asc,ascq: 0x0b,0x47,0x03
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 [sense_key,asc,a=
scq]:
[0xb,0x47,0x3]
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 <25 0 0 0> non-z=
ero
result=3D0xb0000
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Done: RETRY
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] CDB: Read(10): 28
00 00 00 12 34 00 00 01 00
May 18 16:46:10 localhost kernel: scsi_debug: cmd 28 00 00 00 12 34 00 =
00 01 00
May 18 16:46:10 localhost kernel: FOO: simulating error:
sense_key,asc,ascq: 0x0b,0x47,0x03
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 [sense_key,asc,a=
scq]:
[0xb,0x47,0x3]
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 <25 0 0 0> non-z=
ero
result=3D0xb0000
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Done: RETRY
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] CDB: Read(10): 28
00 00 00 12 34 00 00 01 00
May 18 16:46:10 localhost kernel: scsi_debug: cmd 28 00 00 00 12 34 00 =
00 01 00
May 18 16:46:10 localhost kernel: FOO: simulating error:
sense_key,asc,ascq: 0x0b,0x47,0x03
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 [sense_key,asc,a=
scq]:
[0xb,0x47,0x3]
May 18 16:46:10 localhost kernel: scsi_debug:=A0=A0=A0 <25 0 0 0> non-z=
ero
result=3D0xb0000
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Done: SUCCESS
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] CDB: Read(10): 28
00 00 00 12 34 00 00 01 00
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Unhandled error co=
de
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
May 18 16:46:10 localhost kernel: sd 25:0:0:0: [sdb] CDB: Read(10): 28
00 00 00 12 34 00 00 01 00


with all the errors I've logged from mpt2sas in junction with
multipath I never managed to log a single "Done: RETRY",
it really looks like multipath kernel moduel is failing a path using
mpt2sas at a glance of an error, without even retrying once.

Is it the correct behaviour or am I missing something ?
Are the retries handled in a different manner between mpt2sas and scsi_=
debug ?

Please keep in mind that scsi_debug was coded to make fail forever
sector 0x1234 and after the last "Done: RETRY" multipath failed to
path to the device.
This is the behaviour that I would like to see when using mpt2sas.


Thank you

=46rancesco Santagata
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
