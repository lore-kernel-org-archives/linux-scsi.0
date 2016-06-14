From: Fab Stz <fabstmail@gmail.com>
Subject: Re: Partitions not detected with firewire - 36 bytes offset - PL-3507
Date: Tue, 14 Jun 2016 09:05:35 +0200
Message-ID: <1777209.O0WHVKuHCq@debian>
References: <4379835.Lnu4rjdqZg@debian> <20160607151554.5b33bc0c@kant>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart29918607.CpE1kX3DtP"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35885 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcFNHFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 03:05:47 -0400
Received: by mail-wm0-f66.google.com with SMTP id m124so19895924wme.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2016 00:05:46 -0700 (PDT)
In-Reply-To: <20160607151554.5b33bc0c@kant>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart29918607.CpE1kX3DtP
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

(sent again from another email because rejected from linux-scsi)

Thanks for your detailed answer

Le mardi 7 juin 2016 15:15:54, vous avez =E9crit :
> One example would be that userland sends another INQUIRY request.  Wh=
ich
> would be perfectly standards conforming but is highly dangerous for
> PL-3507.
>=20
> The 36 bytes offset which you observed happens to be the same number =
of
> bytes as the length of a typical INQUIRY response buffer.  Coincidenc=
e?
>=20
> So,
>   - the SCSI layer and block layer of the Linux kerne could issue com=
mands
>     which the PL-3507's firmware cannot handle, but this can be influ=
enced
>     to some degree by specifying quirk flags to SCSI core.  (I don't
>     remember right now how to do that precisely.)
>   - Or Linux userland could issue commands which crash the firmware.
>=20
> To investigate the latter possibility, you could boot into a minimal
> single-user command line and try to use the disk from there.  Consult=
 your
> distribution's documentation on how to get into single-user mode.  If=
 that
> works, then there is some sort of device probing going on in your reg=
ular
> userland which upsets the firmware.  E.g. the mentioned double INQUIR=
Y.

For single-user I booted on recovery-mode in debian (having the "single=
"=20
option on the kernel line). The problem is the same.

However, based on you explanations I tried a few things and noticed thi=
s=20
behaviour :

 * If I run "sg_readcap /deb/sdb" then, the offset doesn't exist anymor=
e and=20
when I run cfdisk /dev/sdb the partition table is correctly displayed.=20=

However, after closure of cfdisk, the offset is there again and cfdisk =
doesn't=20
display the partition table anymore.
 * If I run "sg_readcap" followed by "sg_inq", sg_inq makes the offset =
appear=20
again.
 * If I run "sdparm /dev/sdb", there isn't an offset anymore and cfdisk=
=20
displays the partition table
 * If I run "sdparm -i /dev/sdb" the offset appears again

So it seems "cfdisk", "sg_inq" and "sdparm -i" send a command that make=
s the=20
offset appear again, while "sdparm" and "sg_readcap" 'fix' the offset i=
ssue.

Output of "sdparm -i /dev/sdb"
    /dev/sdb: SAMSUNG   SP0842N                 [simplified direct acce=
ss=20
device]
malformed VPD response, VPD pages probably not supported


Output of "sdparm -a /dev/sdb" is attached (and displays also a few war=
ings)


> > * relevant messages from dmesg
> > [66693.391283] firewire_core 0000:02:00.0: phy config: new root=3Df=
fc1,
> > gap_count=3D5 [66697.227221] firewire_core 0000:02:00.0: phy config=
: new
> > root=3Dffc1, gap_count=3D5 [66697.666381] firewire_core 0000:02:00.=
0: created
> > device fw1: GUID 0000190e0000026e, S400 [66697.844315] scsi host5: =
SBP-2
> > IEEE-1394
> > [66697.844445] firewire_sbp2 fw1.0: workarounds 0x20 (firmware_revi=
sion
> > 0x012804, model_id 0x000001) [66698.044800] firewire_sbp2 fw1.0: lo=
gged
> > in to LUN 0000 (0 retries) [66698.045542] scsi 5:0:0:0: Direct-Acce=
ss-RBC
> > SAMSUNG  SP0842N               PQ: 0 ANSI: 4 [66698.045892] sd 5:0:=
0:0:
> > Attached scsi generic sg3 type 14
> > [66698.046476] sd 5:0:0:0: [sdc] 156301488 512-byte logical blocks:=
 (80.0
> > GB/74.5 GiB) [66698.046591] sd 5:0:0:0: [sdc] Write Protect is off
> > [66698.046596] sd 5:0:0:0: [sdc] Mode Sense: 11 00 00 00
> > [66698.046868] sd 5:0:0:0: [sdc] Write cache: enabled, read cache:
> > enabled, doesn't support DPO or FUA [66698.055440] sd 5:0:0:0: [sdc=
]
> > Attached SCSI disk
>=20
> Are there no further messages from the SCSI drivers or block layer dr=
ivers?

No, there are no further messages

--
Fab
--nextPart29918607.CpE1kX3DtP
Content-Disposition: attachment; filename="sdparm-a.out"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; name="sdparm-a.out"

    /dev/sdb: SAMSUNG   SP0842N                 [simplified direct access device]
Read write error recovery mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x01, but is 0x06; try '--flexible'
  AWRE        0  [cha: n, def:  0, sav:  0]
  ARRE        0  [cha: n, def:  0, sav:  0]
  TB          0  [cha: n, def:  0, sav:  0]
  RC          0  [cha: n, def:  0, sav:  0]
  EER         0  [cha: n, def:  0, sav:  0]
  PER         0  [cha: n, def:  0, sav:  0]
  DTE         0  [cha: n, def:  0, sav:  0]
  DCR         0  [cha: n, def:  0, sav:  0]
  RRC         2  [cha: y, def:  2, sav:  2]
  COR_S       0  [cha: n, def:  0, sav:  0]
  HOC         0  [cha: n, def:  0, sav:  0]
  DSOC        4  [cha: y, def:  4, sav:  4]
  WRC        21  [cha: y, def: 21, sav: 21]
Disconnect-reconnect (SPC + transports) mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x02, but is 0x06; try '--flexible'
  BFR         0  [cha: n, def:  0, sav:  0]
  BER         2  [cha: y, def:  2, sav:  2]
  BIL         0  [cha: n, def:  0, sav:  0]
  DTL       1227  [cha: y, def:1227, sav:1227]
  CTL       5568  [cha: y, def:5568, sav:5568]
  MBS         1  [cha: y, def:  1, sav:  1]
  EMDP        0  [cha: n, def:  0, sav:  0]
  FA          0  [cha: n, def:  0, sav:  0]
  DIMM        0  [cha: n, def:  0, sav:  0]
  DTDC        0  [cha: n, def:  0, sav:  0]
RBC device parameters (RBC) mode page:
  WCD         0  [cha: n, def:  0, sav:  0]
  LBS       512  [cha: y, def:512, sav:512]
  NLBS      0x4cb15c0  [cha: y, def:0x4cb15c0, sav:0x4cb15c0]
  P_P         0  [cha: n, def:  0, sav:  0]
  READD       0  [cha: n, def:  0, sav:  0]
  WRITED      0  [cha: n, def:  0, sav:  0]
  FORMATD     0  [cha: n, def:  0, sav:  0]
  LOCKD       1  [cha: y, def:  1, sav:  1]
Control mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x0a, but is 0x06; try '--flexible'
  TST         0  [cha: n, def:  0, sav:  0]
  TMF_ONLY    0  [cha: n, def:  0, sav:  0]
  DPICZ       0  [cha: n, def:  0, sav:  0]
  D_SENSE     0  [cha: n, def:  0, sav:  0]
  GLTSD       0  [cha: n, def:  0, sav:  0]
  RLEC        0  [cha: n, def:  0, sav:  0]
  QAM         0  [cha: n, def:  0, sav:  0]
  NUAR        0  [cha: n, def:  0, sav:  0]
  QERR        1  [cha: y, def:  1, sav:  1]
  RAC         0  [cha: n, def:  0, sav:  0]
  UA_INTLCK   0  [cha: n, def:  0, sav:  0]
  SWP         0  [cha: n, def:  0, sav:  0]
  ATO         0  [cha: n, def:  0, sav:  0]
  TAS         0  [cha: n, def:  0, sav:  0]
  ATMPE       0  [cha: n, def:  0, sav:  0]
  RWWP        0  [cha: n, def:  0, sav:  0]
  AUTOLOAD    0  [cha: n, def:  0, sav:  0]
  BTP       5568  [cha: y, def:5568, sav:5568]
  ESTCT       1  [cha: y, def:  1, sav:  1]
Control extension mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x0a, but is 0x06; try '--flexible'
  TCMOS       0  [cha: n, def:  0, sav:  0]
  SCSIP       0  [cha: n, def:  0, sav:  0]
  IALUAE      0  [cha: n, def:  0, sav:  0]
  INIT_PR     0  [cha: n, def:  0, sav:  0]
  MSDL        4  [cha: y, def:  4, sav:  4]
SAT pATA control mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x0a, but is 0x06; try '--flexible'
  MWD2        0  [cha: n, def:  0, sav:  0]
  MWD1        0  [cha: n, def:  0, sav:  0]
  MWD0        0  [cha: n, def:  0, sav:  0]
  PIO4        0  [cha: n, def:  0, sav:  0]
  PIO3        0  [cha: n, def:  0, sav:  0]
  UDMA6       0  [cha: n, def:  0, sav:  0]
  UDMA5       0  [cha: n, def:  0, sav:  0]
  UDMA4       0  [cha: n, def:  0, sav:  0]
  UDMA3       0  [cha: n, def:  0, sav:  0]
  UDMA2       0  [cha: n, def:  0, sav:  0]
  UDMA1       0  [cha: n, def:  0, sav:  0]
  UDMA0       0  [cha: n, def:  0, sav:  0]
Protocol specific logical unit mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x18, but is 0x06; try '--flexible'
  LUPID       0  [cha: n, def:  0, sav:  0]
Protocol specific port mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x19, but is 0x06; try '--flexible'
  PPID        0  [cha: n, def:  0, sav:  0]
Power condition mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x1a, but is 0x06; try '--flexible'
  PM_BG       0  [cha: n, def:  0, sav:  0]
  STANDBY_Y   0  [cha: n, def:  0, sav:  0]
  IDLE_C      0  [cha: n, def:  0, sav:  0]
  IDLE_B      0  [cha: n, def:  0, sav:  0]
  IDLE        1  [cha: y, def:  1, sav:  1]
  STANDBY     0  [cha: n, def:  0, sav:  0]
  ICT       1227  [cha: y, def:1227, sav:1227]
  SCT       364904449  [cha: y, def:364904449, sav:364904449]
  IBCT        0  [cha: n, def:  0, sav:  0]
Power consumption mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x1a, but is 0x06; try '--flexible'
  ps_id     203  [cha: y, def:203, sav:203]
SAT ATA Power condition mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x1a, but is 0x06; try '--flexible'
  APMP        0  [cha: n, def:  0, sav:  0]
  APM         4  [cha: y, def:  4, sav:  4]
Informational exceptions control mode page:
>>> warning: mode page seems malformed
   The page number field should be 0x1c, but is 0x06; try '--flexible'
  PERF        0  [cha: n, def:  0, sav:  0]
  EBF         0  [cha: n, def:  0, sav:  0]
  EWASC       0  [cha: n, def:  0, sav:  0]
  DEXCPT      0  [cha: n, def:  0, sav:  0]
  TEST        0  [cha: n, def:  0, sav:  0]
  EBACKERR    0  [cha: n, def:  0, sav:  0]
  LOGERR      0  [cha: n, def:  0, sav:  0]
  MRIE        2  [cha: y, def:  2, sav:  2]
  INTT      1227  [cha: y, def:1227, sav:1227]
  REPC      364904449  [cha: y, def:364904449, sav:364904449]

--nextPart29918607.CpE1kX3DtP--

