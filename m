From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: [AIC7xxx] tree things to report
Date: Wed, 23 May 2007 23:35:11 +0200
Message-ID: <JIIJYN$4007EF66C88A841232E7570743EF6535@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.16]:61400 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbXEWVz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 17:55:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.fr>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

After one year of rest, I resurrect my old computer, install a
2.6.21 kernel and updated my Debian distro.

Tree things to repport:

=46irst, a cosmetic thing: I have two scsi sync devices and two
async devices. For the first ones, domain validation return
the negociated speed and mode. For the second ones, domain
validation return nothing. I expect it is just a 'missing
feature' but that all went ok. I am right ?

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2940 Ultra2 SCSI adapter>
        aic7890/91: Ultra2 Wide Channel A, SCSI Id=3D7, 32/253 SCBs

scsi 0:0:0:0: Direct-Access     IBM      DMVS18V         02B0
PQ: 0 ANSI: 3
scsi0:A:0:0: Tagged Queuing enabled.  Depth 8=20
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25ns, offset 31)
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
scsi 0:0:3:0: CD-ROM            YAMAHA   CRW6416S         1.0d
PQ: 0 ANSI: 2
 target0:0:3: Beginning Domain Validation
 target0:0:3: FAST-10 SCSI 10.0 MB/s ST (100 ns,offset 15)
 target0:0:3: Domain Validation skipping write tests
 target0:0:3: Ending Domain Validation
scsi 0:0:4:0: CD-ROM            TOSHIBA  CD-ROM XM-3501TA 1875
PQ: 0 ANSI: 2
 target0:0:4: Beginning Domain Validation
 target0:0:4: Domain Validation skipping write tests
 target0:0:4: Ending Domain Validation
scsi 0:0:6:0: Sequential-Access WANGTEK  5525ES SCSI REV7 0W=20
 PQ: 0 ANSI: 1
 target0:0:6: Beginning Domain Validation
 target0:0:6: Ending Domain Validation

Secondly, It seems that something is doing weird things with
my old CD-ROM reader (XM-3501TA). At some point in time (not
really regular), I get this in my logs:
May 23 00:45:44 rafale kernel: (scsi0:A:4:0): No or incomplete
CDB sent to device.
May 23 00:45:44 rafale kernel: (scsi0:A:4:0): Protocol
violation in Message-in phase.  Attempting to abort.
May 23 00:45:44 rafale kernel: (scsi0:A:4:0): Abort Message Sent
May 23 00:45:44 rafale kernel: (scsi0:A:4:0): SCB 11 - Abort
Completed.
And sometimes (but seem related to problems with my cable):
May 23 04:32:49 rafale kernel: (scsi0:A:4:0): parity error
detected in Status phase. SEQADDR(0xad) SCSIRATE(0x0)
May 23 05:13:03 rafale kernel: (scsi0:A:4:0): parity error
detected in Status phase. SEQADDR(0xac) SCSIRATE(0x0)

There is no scsi bus freeze, and the device work perfectly
without generating other errors. DV problem ? Bad hal daemon
interaction ? Defect in the driver trigged by bad hal daemon
behavior ?=20

Last thing, a now two years problem:
cdrwtools -d /dev/sr0 -q still instantly crash the
scsibus/cdwriter and the driver never recover.
I did not have a new log because of the complete bus crash.
Have you new ideas about this problem ??
I will try:
- to get a log on a usb key
- to port patch from Bugzilla Bug 5921 to current kernel. With
the previous ones, the driver recover. (but i was experiencing
=46S corruption but it seems it was not related).
- to identify exactly what cdrwtools send to the kernel/driver
which cause the crash.
If some scsi experts have a clue, I am taking.

Thank you all,
Best regards,
Emmanuel.
=20
---

Cr=E9ez votre adresse =E9lectronique prenom.nom@laposte.net=20
1 Go d'espace de stockage, anti-spam et anti-virus int=E9gr=E9s.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
