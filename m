From: "Thakkar, Vishal" <Vishal.Thakkar@lsi.com>
Subject: RE: MD sets failing under heavy load in a DRBD/Pacemaker Cluster
Date: Tue, 4 Oct 2011 20:58:26 +0530
Message-ID: <7863850E8C98C748980632D9D3B7C199119038463C@inbmail02.lsi.com>
References: <CAKFseUPKzcEx94axosagf9wnMJfhr8TRvu3BUm4vDESj9Z_Dgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUPKzcEx94axosagf9wnMJfhr8TRvu3BUm4vDESj9Z_Dgg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>, General Linux-HA mailing list <linux-ha@lists.linux-ha.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Hi Caspar,

What is the version of the FW on the LSI 3081E-R HBA? This is printed a=
s a debug message when the driver loads. If the version is old, you may=
 want to try updating it from http://www.lsi.com/channel/products/stora=
gecomponents/Pages/HBAs.aspx=20

On your question - "Is there a known issue when both controllers are us=
ed in the same machine?" - We aren't aware of any such known issues wit=
h the latest versions of the driver and HBA FW.

Thanks,
Vishal

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Caspar Smit
Sent: Tuesday, October 04, 2011 5:31 PM
To: General Linux-HA mailing list; linux-scsi@vger.kernel.org; drbd-use=
r@lists.linbit.com; iscsitarget-devel@lists.sourceforge.net; Support; l=
inux-raid@vger.kernel.org
Subject: MD sets failing under heavy load in a DRBD/Pacemaker Cluster

Hi all,

We are having a major problem with one of our clusters.

Here's a description of the setup:

2 supermicro servers containing the following hardware:

Chassis: SC846E1-R1200B
Mainboard: X8DTH-6F rev 2.01 (onboard LSI2008 controller disabled throu=
gh jumper)
CPU: Intel Xeon E5606 @ 2.13Ghz, 4 cores
Memory: 4x KVR1333D3D4R9S/4G (16Gb)
Backplane: SAS846EL1 rev 1.1
Ethernet: 2x Intel Pro/1000 PT Quad Port Low Profile SAS/SATA Controlle=
r: LSI 3081E-R (P20, BIOS: 6.34.00.00, Firmware 1.32.00.00-IT) SAS/SATA=
 JBOD Controller: LSI 3801E (P20, BIOS: 6.34.00.00, Firmware
1.32.00.00-IT)
OS Disk: 30Gb SSD
Harddisks: 24x Western Digital 2TB 7200RPM RE4-GP (WD2002FYPS)

Both machines have debian lenny 5 installed, here are the versions of t=
he packages involved:

drbd/heartbeat/pacemaker are installed from the backports repository.

linux-image-2.6.26-2-amd64   2.6.26-26lenny3
mdadm                                2.6.7.2-3
drbd8-2.6.26-2-amd64           2:8.3.7-1~bpo50+1+2.6.26-26lenny3
drbd8-source                        2:8.3.7-1~bpo50+1
drbd8-utils                            2:8.3.7-1~bpo50+1
heartbeat                             1:3.0.3-2~bpo50+1
pacemaker                           1.0.9.1+hg15626-1~bpo50+1
iscsitarget                            1.4.20.2 (compiled from tar.gz)


We created 4 MD sets out of the 24 harddisks (/dev/md0 through /dev/md3=
)

Each is a RAID5 of 5 disks and 1 hotspare (8TB netto per MD), metadata =
version of the MD sets is 0.90

=46or each MD we created a DRBD device to the second node. (/dev/drbd4 =
through /dev/drbd7) (0 through 3 were used by disks from a JBOD which w=
as disconnected, read below) (see attached drbd.conf.txt, these are the=
 individual *.res files combined)

Each drbd device has its own dedicated 1GbE NIC port.

Each drbd device is then exported through iSCSI using iet in pacemaker =
(see attached crm-config.txt for the full pacemaker config)


Now for the symptoms we are having:

After a number of days (sometimes weeks) the disks from the MD sets sta=
rt failing subsequently.

See the attached syslog.txt for details but here are the main entries:

It starts with:

Oct  2 11:01:59 node03 kernel: [7370143.421999] mptbase: ioc0:
LogInfo(0x31110b00): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)=
 cb_idx mptbase_reply Oct  2 11:01:59 node03 kernel: [7370143.435220] m=
ptbase: ioc0:
LogInfo(0x31181000): Originator=3D{PL}, Code=3D{IO Cancelled Due to Rec=
ieve Error}, SubCode(0x1000) cb_idx mptbase_reply Oct  2 11:01:59 node0=
3 kernel: [7370143.442141] mptbase: ioc0:
LogInfo(0x31112000): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x2000)=
 cb_idx mptbase_reply Oct  2 11:01:59 node03 kernel: [7370143.442783] e=
nd_request: I/O error, dev sdf, sector 3907028992 Oct  2 11:01:59 node0=
3 kernel: [7370143.442783] md: super_written gets error=3D-5, uptodate=3D=
0 Oct  2 11:01:59 node03 kernel: [7370143.442783] raid5: Disk failure o=
n sdf, disabling device.
Oct  2 11:01:59 node03 kernel: [7370143.442783] raid5: Operation contin=
uing on 4 devices.
Oct  2 11:01:59 node03 kernel: [7370143.442820] end_request: I/O error,=
 dev sdb, sector 3907028992 Oct  2 11:01:59 node03 kernel: [7370143.442=
820] md: super_written gets error=3D-5, uptodate=3D0 Oct  2 11:01:59 no=
de03 kernel: [7370143.442820] raid5: Disk failure on sdb, disabling dev=
ice.
Oct  2 11:01:59 node03 kernel: [7370143.442820] raid5: Operation contin=
uing on 3 devices.
Oct  2 11:01:59 node03 kernel: [7370143.442820] end_request: I/O error,=
 dev sdd, sector 3907028992 Oct  2 11:01:59 node03 kernel: [7370143.442=
820] md: super_written gets error=3D-5, uptodate=3D0 Oct  2 11:01:59 no=
de03 kernel: [7370143.442820] raid5: Disk failure on sdd, disabling dev=
ice.
Oct  2 11:01:59 node03 kernel: [7370143.442820] raid5: Operation contin=
uing on 2 devices.
Oct  2 11:01:59 node03 kernel: [7370143.470791] mptbase: ioc0:
LogInfo(0x31110b00): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)=
 cb_idx mptbase_reply <snip> Oct  2 11:02:00 node03 kernel: [7370143.96=
8976] Buffer I/O error on device drbd4, logical block 1651581030 Oct  2=
 11:02:00 node03 kernel: [7370143.969056] block drbd4: p write: error=3D=
-5 Oct  2 11:02:00 node03 kernel: [7370143.969126] block drbd4: Local W=
RITE failed sec=3D21013680s size=3D4096 Oct  2 11:02:00 node03 kernel: =
[7370143.969203] block drbd4: disk( UpToDate -> Failed ) Oct  2 11:02:0=
0 node03 kernel: [7370143.969276] block drbd4: Local IO failed in __req=
_mod.Detaching...
Oct  2 11:02:00 node03 kernel: [7370143.969492] block drbd4: disk( Fail=
ed -> Diskless ) Oct  2 11:02:00 node03 kernel: [7370143.969492] block =
drbd4: Notified peer that my disk is broken.
Oct  2 11:02:00 node03 kernel: [7370143.970120] block drbd4: Should hav=
e called drbd_al_complete_io(, 21013680), but my Disk seems to have fai=
led :( Oct  2 11:02:00 node03 kernel: [7370144.003730] iscsi_trgt:
fileio_make_request(63) I/O error 4096, -5 Oct  2 11:02:00 node03 kerne=
l: [7370144.004931] iscsi_trgt:
fileio_make_request(63) I/O error 4096, -5 Oct  2 11:02:00 node03 kerne=
l: [7370144.006820] iscsi_trgt:
fileio_make_request(63) I/O error 4096, -5 Oct  2 11:02:01 node03 kerne=
l: [7370144.849344] mptbase: ioc0:
LogInfo(0x31110b00): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)=
 cb_idx mptscsih_io_done Oct  2 11:02:01 node03 kernel: [7370144.849451=
] mptbase: ioc0:
LogInfo(0x31110b00): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)=
 cb_idx mptscsih_io_done Oct  2 11:02:01 node03 kernel: [7370144.849709=
] mptbase: ioc0:
LogInfo(0x31110b00): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)=
 cb_idx mptscsih_io_done Oct  2 11:02:01 node03 kernel: [7370144.849814=
] mptbase: ioc0:
LogInfo(0x31110b00): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)=
 cb_idx mptscsih_io_done Oct  2 11:02:01 node03 kernel: [7370144.850077=
] mptbase: ioc0:
LogInfo(0x31110b00): Originator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)=
 cb_idx mptscsih_io_done <snip> Oct  2 11:02:07 node03 kernel: [7370150=
=2E918849] mptbase: ioc0: WARNING
- IOC is in FAULT state (7810h)!!!
Oct  2 11:02:07 node03 kernel: [7370150.918929] mptbase: ioc0: WARNING
- Issuing HardReset from mpt_fault_reset_work!!
Oct  2 11:02:07 node03 kernel: [7370150.919027] mptbase: ioc0:
Initiating recovery
Oct  2 11:02:07 node03 kernel: [7370150.919098] mptbase: ioc0: WARNING
- IOC is in FAULT state!!!
Oct  2 11:02:07 node03 kernel: [7370150.919171] mptbase: ioc0: WARNING
-            FAULT code =3D 7810h
Oct  2 11:02:10 node03 kernel: [7370154.041934] mptbase: ioc0:
Recovered from IOC FAULT
Oct  2 11:02:16 node03 cib: [5734]: WARN: send_ipc_message: IPC Channel=
 to 23559 is not connected Oct  2 11:02:21 node03 iSCSITarget[9060]: [9=
069]: WARNING:
Configuration parameter "portals" is not supported by the iSCSI impleme=
ntation and will be ignored.
Oct  2 11:02:22 node03 kernel: [7370166.353087] mptbase: ioc0: WARNING
- mpt_fault_reset_work: HardReset: success


This results in 3 MD's were all disks are failed [_____] and 1 MD survi=
ves that is rebuilding with its spare.
3 drbd devices are Diskless/UpToDate and the survivor is UpToDate/UpToD=
ate The weird thing of this all is that there is always 1 MD set that "=
survives" the FAULT state of the controller!
Luckily DRBD redirects all read/writes to the second node so there is n=
o downtime.


Our findings:

1) It seems to only happen on heavy load

2) It seems to only happen when DRBD is connected (we didn't have any f=
ailing MD's yet when DRBD was not connected luckily!)

3) It seems to only happen on the primary node

4) It does not look like a hardware problem because there is always one=
 MD that survives this, if this was hardware related I would expect ALL=
 disks/MD's too fail.
 Furthermore the disks are not broken because we can assemble the array=
 again after it happened and they resync just fine.

5) I see that there is a new kernel version (2.6.26-27) available and i=
f i look at the changelog it has a fair number of fixes related to MD, =
although the symptoms we are seeing are different from the described fi=
xes it could be related. Can anyone tell if these issues are related to=
 the fixes in the newest kernel image?

6) In the past we had a Dell MD1000 JBOD connected to the LSI 3801E con=
troller on both nodes and had the same problem when every disk (only fr=
om the JBOD) failed so we disconnected the JBOD. The controller stayed =
inside the server.


Things we tried so far:

1) We switched the LSI 3081E-R controller with another but to no avail =
(and we have another identical cluster suffering from this problem)

2) In stead of the stock lenny mptsas driver (version v3.04.06) we used=
 the latest official LSI mptsas driver (v4.26.00.00) from the LSI websi=
te using KB article 16387 (kb.lsi.com/KnowledgebaseArticle16387.aspx). =
Still to no avail, it happens with that driver too.


Things that might be related:

1) We are using the deadline IO scheduler as recommended by IETD.

2) We are suspecting that the LSI 3801E controller might interfere with=
 the LSI 3081E-R so we are planning to remove the unused LSI 3801E cont=
rollers.
Is there a known issue when both controllers are used in the same machi=
ne? They have the same firmware/bios version. The linux driver
(mptsas) is also the same for both controllers.

Kind regards,

Caspar Smit
Systemengineer
True Bit Resources B.V.
Amp=E8restraat 13E
1446 TP=A0 Purmerend

T: +31(0)299 410 475
=46: +31(0)299 410 476
@: c.smit@truebit.nl
W: www.truebit.nl
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
