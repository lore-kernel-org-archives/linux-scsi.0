From: Tomas Ebenlendr <ebik@jyxo.com>
Subject: Problems with aic94xx (AIC9410W onboard)
Date: Wed, 04 Jun 2008 11:31:45 +0200
Message-ID: <48466101.70509@jyxo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xmlcz.jyxo.com ([195.122.208.206]:37449 "EHLO mail1.jyxo.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750959AbYFDHfv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2008 03:35:51 -0400
Received: from [192.168.0.29] (235-105-207-85.bluetone.cz [85.207.105.235])
	by mail1.jyxo.com (Postfix) with ESMTP id AB7D71810862
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2008 09:25:38 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

We use software raid with two SAS controllers, 8 drives per each.  These drives
are in RAID1 by pairs, each pair has one drive controlled by one controller and
one by the other.  The controllers are LSI SAS1068 PCI-X card and the other is
Adaptec AIC9410 onboard (Motherboard SuperMicro X7DB3). We have problems with
the later.  Raid says that one of the drives behind Adaptec failed, but at same
time all raids 'freeze' for long period of time (nearly half an hour last
time) and no data can be read nor written on no logical drive.  It seems that
the Adaptec controller is somehow frozen.  After such a long time kernel
manages to do the recovery of the hardware and all drives but the one that
failed continues the operation.  The failed drive cannot be brought back to
life by scsi reset, but it is o.k.  after reboot.  The situation occurs under
heavy load, it repeats once in few days, and random drive behind the adaptec
driver fails.  We tried to replace cables, drives e.t.c.  Our backplane is
SuperMicro 836TQ, which seems to have no expander on it.

Our hardware is following:
04:02.0 Serial Attached SCSI controller: Adaptec AIC-9410W SAS (Razor ASIC non-RAID) (rev 09)
05:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01)
processor: 2x Xeon E5345
motherboard: Supermicro X7DB8
memory: 8x 2GB ECC module

We tried without success with kernel versions: 2.6.22.10, 2.6.23.1, 2.6.25.2 and 2.6.25.4
At first the computer totally freezed, now, since 2.6.25, it behaves little bit better,
as described above.
The log is from 2.6.25.4.

The problem starts at Jun  3 08:09:47 with following piece of /var/log/messages:
Note that there is the 'sending hard reset to 3:5' (the drive that failed according
to software raid), but we don't know if this is source or consequence of the fact
that the drive remains failed until reboot.

Jun  3 08:09:47: sas: command 0xee97b800, task 0xf3ae5480, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xea6a8680, task 0xf3b62e80, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xeb49eb40, task 0xf3b62ac0, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xee954bc0, task 0xed4d0800, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xf6abf2c0, task 0xf664ed40, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xee97b380, task 0xf3ae5d40, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xf2d0d780, task 0xed4d0e40, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xee97b980, task 0xdf2acac0, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xea23eec0, task 0xed4d0d00, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xf46ac200, task 0xf3b62980, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xeb342a40, task 0xf3ae50c0, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xf46ac440, task 0xf2fbb940, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xf27c2e00, task 0xefa79580, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xf2d0d3c0, task 0xf3ae5980, timed out: EH_NOT_HANDLED
Jun  3 08:09:47: sas: command 0xee954200, task 0xf3ae5340, timed out: EH_NOT_HANDLED
Jun  3 08:09:48: sas: command 0xf5b73180, task 0xefcf65c0, timed out: EH_NOT_HANDLED
Jun  3 08:09:50: sas: command 0xea5d5740, task 0xee131080, timed out: EH_NOT_HANDLED
Jun  3 08:09:51: sas: command 0xea6a8e00, task 0xed4d01c0, timed out: EH_NOT_HANDLED
Jun  3 08:09:52: sas: command 0xf6abfbc0, task 0xde9dae40, timed out: EH_NOT_HANDLED
Jun  3 08:09:57: sas: command 0xd73848c0, task 0xf3b620c0, timed out: EH_NOT_HANDLED
Jun  3 08:09:58: sas: command 0xf27c2440, task 0xf3842580, timed out: EH_NOT_HANDLED
Jun  3 08:09:58: sas: command 0xf23a29c0, task 0xee131440, timed out: EH_NOT_HANDLED
Jun  3 08:09:59: sas: command 0xea677840, task 0xf6505840, timed out: EH_NOT_HANDLED
Jun  3 08:10:27: sas: command 0xf46acec0, task 0xf6505d40, timed out: EH_NOT_HANDLED
Jun  3 08:10:27: sas: command 0xd7384d40, task 0xf664e5c0, timed out: EH_NOT_HANDLED
Jun  3 08:10:27: sas: command 0xea6a8080, task 0xf6505200, timed out: EH_NOT_HANDLED
Jun  3 08:10:27: sas: command 0xf23a2480, task 0xf3ae5700, timed out: EH_NOT_HANDLED
Jun  3 08:10:27: sas: command 0xea677d80, task 0xe0767e40, timed out: EH_NOT_HANDLED
Jun  3 08:10:27: sas: Enter sas_scsi_recover_host
Jun  3 08:10:27: sas: trying to find task 0xf3ae5480
Jun  3 08:10:27: sas: sas_scsi_find_task: aborting task 0xf3ae5480
Jun  3 08:10:27: aic94xx: tmf timed out
Jun  3 08:10:27: aic94xx: tmf came back
Jun  3 08:10:27: aic94xx: task 0xf3ae5480 aborted, res: 0x5
Jun  3 08:10:27: sas: sas_scsi_find_task: querying task 0xf3ae5480
Jun  3 08:10:27: aic94xx: tmf tasklet complete
Jun  3 08:10:27: sas: sas_scsi_find_task: task 0xf3ae5480 not at LU
Jun  3 08:10:27: sas: task 0xf3ae5480 is not at LU: I_T recover
Jun  3 08:10:27: sas: I_T nexus reset for dev 5000c5000704c79d
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: PRE
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: POST
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
Jun  3 08:10:27: aic94xx: task 0xefa79580 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3ae5980 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3ae5340 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xefcf65c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xee131080 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xed4d01c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xde9dae40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3b620c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3842580 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xee131440 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf6505840 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf6505d40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf664e5c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf6505200 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3ae5700 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xe0767e40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: asd_clear_nexus_tasklet_complete: here
Jun  3 08:10:27: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Jun  3 08:10:27: aic94xx: sending hard reset to phy-3:5
Jun  3 08:10:27: aic94xx: control_phy_tasklet_complete: phy5: sub_func:0x81
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: PRE
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: POST
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
Jun  3 08:10:27: aic94xx: task 0xed4d0e40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3b62980 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf664ed40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3ae5d40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xdf2acac0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xed4d0d00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3b62e80 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf2fbb940 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xed4d0800 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3ae50c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: task 0xf3b62ac0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Jun  3 08:10:27: aic94xx: asd_clear_nexus_timedout: here
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: PRE
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: POST
Jun  3 08:10:27: aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
Jun  3 08:10:27: aic94xx: asd_clear_nexus_tasklet_complete: here
Jun  3 08:10:27: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
Jun  3 08:10:27: sas: I_T 5000c5000704c79d recovered
Jun  3 08:10:27: sas: --- Exit sas_scsi_recover_host

And now it more or less repeats, insterresting is that from 'Jun  3 08:10:27'
on, log occurs every 30 seconds, ending in 'Jun  3 08:45:27', where problem
disapears. At that time we observed that raids came back to life.

Thank for your help.
Tomas Ebenlendr, Jyxo s.r.o., Czech Republic

==========================================================================
Full log. I compressed the full log according to folowing rules:

commands:
$C01 == 0xee97b800, $C02 == 0xea6a8680, $C03 == 0xeb49eb40, $C04 == 0xee954bc0,
$C05 == 0xf6abf2c0, $C06 == 0xee97b380, $C07 == 0xf2d0d780, $C08 == 0xee97b980,
$C09 == 0xea23eec0, $C10 == 0xf46ac200, $C11 == 0xeb342a40, $C12 == 0xf46ac440,
$C13 == 0xf27c2e00, $C14 == 0xf2d0d3c0, $C15 == 0xee954200, $C16 == 0xf5b73180,
$C17 == 0xea5d5740, $C18 == 0xea6a8e00, $C19 == 0xf6abfbc0, $C20 == 0xd73848c0,
$C21 == 0xf27c2440, $C22 == 0xf23a29c0, $C23 == 0xea677840, $C24 == 0xf46acec0,
$C25 == 0xd7384d40, $C26 == 0xea6a8080, $C27 == 0xf23a2480, $C28 == 0xea677d80,
$C29 == 0xf687b380, $C30 == 0xde6ea8c0, $C31 == 0xea677cc0, $C32 == 0xea677300,
$C33 == 0xf76b4a80, $C34 == 0xf76b43c0, $C35 == 0xf76b4f00, $C36 == 0xeb49e240,
$C37 == 0xf687b680, $C38 == 0xea6a8200, $C39 == 0xf76b4480, $C40 == 0xf76b4840,
$C41 == 0xeb49e0c0, $C42 == 0xeb49e480, $C43 == 0xea6a8440, $C44 == 0xea6a85c0,
$C45 == 0xea6a8bc0, $C46 == 0xea6a8ec0, $C47 == 0xea6a8500, $C48 == 0xeb49e6c0,
$C49 == 0xf6abf800,

tasks:
$T01 == 0xf3ae5480, $T02 == 0xf3b62e80, $T03 == 0xf3b62ac0, $T04 == 0xed4d0800,
$T05 == 0xf664ed40, $T06 == 0xf3ae5d40, $T07 == 0xed4d0e40, $T08 == 0xdf2acac0,
$T09 == 0xed4d0d00, $T10 == 0xf3b62980, $T11 == 0xf3ae50c0, $T12 == 0xf2fbb940,
$T13 == 0xefa79580, $T14 == 0xf3ae5980, $T15 == 0xf3ae5340, $T16 == 0xefcf65c0,
$T17 == 0xee131080, $T18 == 0xed4d01c0, $T19 == 0xde9dae40, $T20 == 0xf3b620c0,
$T21 == 0xf3842580, $T22 == 0xee131440, $T23 == 0xf6505840, $T24 == 0xf6505d40,
$T25 == 0xf664e5c0, $T26 == 0xf6505200, $T27 == 0xf3ae5700, $T28 == 0xe0767e40,
$T29 == 0xf6505700, $T30 == 0xf6505ac0, $T31 == 0xf6505e80, $T32 == 0xf6505980,
$T33 == 0xf6505c00, $T34 == 0xf65055c0, $T35 == 0xf664e0c0, $T36 == 0xf664e700,
$T37 == 0xf664e340, $T38 == 0xdddd0ac0, $T39 == 0xdddd05c0, $T40 == 0xdddd0480,
$T41 == 0xdddd0840, $T42 == 0xdddd0d40, $T43 == 0xdddd0340, $T44 == 0xdddd0e80,
$T45 == 0xdddd0c00, $T46 == 0xdddd0700, $T47 == 0xf6505480, $T48 == 0xe6e5a1c0,
$T49 == 0xe6e5a940, $T50 == 0xe6e5a440, $T51 == 0xe6e5aa80, $T52 == 0xe6e5a300,
$T53 == 0xec75f300, $T54 == 0xec75fbc0, $T55 == 0xec75f1c0,

block `B($T)' is following lines:
     sas: trying to find $T
     sas: sas_scsi_find_task: aborting $T
     aic94xx: $T done with opcode 0x1e resp 0x0 stat 0x8d but aborted by upper layer!
     aic94xx: tmf tasklet complete
     aic94xx: tmf came back
     aic94xx: asd_abort_task: $T done
     aic94xx: $T aborted, res: 0x0
     sas: sas_scsi_find_task: $T is done
     sas: sas_eh_handle_sas_errors: $T is done

line `H($C,$T)' is folling
     sas: $C, $T, timed out: EH_NOT_HANDLED

block `S()' is following lines
     sas: Enter sas_scsi_recover_host
     sas: --- Exit sas_scsi_recover_host

=========== Full log begin ==========

Jun  3 07:58:32 -- MARK --

Jun  3 08:09:47
H($C01,$T01) H($C02,$T02) H($C03,$T03) H($C04,$T04) H($C05,$T05) H($C06,$T06)
H($C07,$T07) H($C08,$T08) H($C09,$T09) H($C10,$T10) H($C11,$T11) H($C12,$T12)
H($C13,$T13) H($C14,$T14) H($C15,$T15)

Jun  3 08:09:48 H($C16,$T16)
Jun  3 08:09:50 H($C17,$T17)
Jun  3 08:09:51 H($C18,$T18)
Jun  3 08:09:52 H($C19,$T19)
Jun  3 08:09:57 H($C20,$T20)
Jun  3 08:09:58 H($C21,$T21) H($C22,$T22)
Jun  3 08:09:59 H($C23,$T23)

Jun  3 08:10:27
H($C24,$T24) H($C25,$T25) H($C26,$T26) H($C27,$T27) H($C28,$T28)
sas: Enter sas_scsi_recover_host
sas: trying to find $T01
sas: sas_scsi_find_task: aborting $T01
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: $T01 aborted, res: 0x5
sas: sas_scsi_find_task: querying $T01
aic94xx: tmf tasklet complete
sas: sas_scsi_find_task: $T01 not at LU
sas: $T01 is not at LU: I_T recover
sas: I_T nexus reset for dev 5000c5000704c79d
aic94xx: asd_clear_nexus_I_T: PRE
aic94xx: asd_clear_nexus_I_T: POST
aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
aic94xx: $T13 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T14 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T15 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T16 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T17 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T18 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T19 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T20 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T21 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T22 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T23 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T24 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T25 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T26 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T27 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T28 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: sending hard reset to phy-3:5
aic94xx: control_phy_tasklet_complete: phy5: sub_func:0x81
aic94xx: asd_clear_nexus_I_T: PRE
aic94xx: asd_clear_nexus_I_T: POST
aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
aic94xx: $T07 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T10 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T05 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T06 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T08 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T09 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T02 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T12 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T04 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T11 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: $T03 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_timedout: here
aic94xx: asd_clear_nexus_I_T: PRE
aic94xx: asd_clear_nexus_I_T: POST
aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
sas: I_T 5000c5000704c79d recovered
sas: --- Exit sas_scsi_recover_host

Jun  3 08:10:57
H($C28,$T23) H($C27,$T22) H($C26,$T21) H($C25,$T20) H($C24,$T19) H($C23,$T18)
H($C22,$T17) H($C21,$T16) H($C20,$T15) H($C19,$T14) H($C18,$T13) H($C17,$T12)
H($C16,$T11) H($C15,$T10) H($C14,$T09) H($C13,$T08) H($C12,$T07) H($C11,$T06)
H($C10,$T05) H($C09,$T04) H($C08,$T03) H($C07,$T02) H($C06,$T01) H($C05,$T29)
H($C04,$T30) H($C03,$T31) H($C02,$T32) H($C01,$T33) H($C29,$T34) H($C30,$T35)
H($C31,$T36) H($C32,$T37)
sas: Enter sas_scsi_recover_host
B($T23) B($T22) B($T21) B($T20) B($T19) B($T18) B($T17) B($T16) B($T15) B($T14)
B($T13) B($T12) B($T11) B($T10) B($T09) B($T08) B($T07) B($T06) B($T05) B($T04)
B($T03) B($T02) B($T01) B($T29) B($T30) B($T31) B($T32) B($T33) B($T34) B($T35)
B($T36) B($T37)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:11:27
H($C32,$T37) H($C31,$T36) H($C30,$T35) H($C29,$T34) H($C01,$T33) H($C02,$T32)
H($C03,$T31) H($C04,$T30) H($C05,$T29) H($C06,$T01) H($C07,$T02) H($C08,$T03)
H($C09,$T04) H($C10,$T05) H($C11,$T06) H($C12,$T07) H($C13,$T08) H($C14,$T09)
H($C15,$T10) H($C16,$T11) H($C17,$T12) H($C18,$T13) H($C19,$T14) H($C20,$T15)
H($C21,$T16) H($C22,$T17) H($C23,$T18) H($C24,$T19) H($C25,$T20) H($C26,$T21)
H($C27,$T22) H($C28,$T23)
sas: Enter sas_scsi_recover_host
B($T37) B($T36) B($T35) B($T34) B($T33) B($T32) B($T31) B($T30) B($T29) B($T01)
B($T02) B($T03) B($T04) B($T05) B($T06) B($T07) B($T08) B($T09) B($T10) B($T11)
B($T12) B($T13) B($T14) B($T15) B($T16) B($T17) B($T18) B($T19) B($T20) B($T21)
B($T22) B($T23)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:11:57
H($C28,$T23) H($C27,$T22) H($C26,$T21) H($C25,$T20) H($C24,$T19) H($C23,$T18)
H($C22,$T17) H($C21,$T16) H($C20,$T15) H($C19,$T14) H($C18,$T13) H($C17,$T12)
H($C16,$T11) H($C15,$T10) H($C14,$T09) H($C13,$T08) H($C12,$T07) H($C11,$T06)
H($C10,$T05) H($C09,$T04) H($C08,$T03) H($C07,$T02) H($C06,$T01) H($C05,$T29)
H($C04,$T30) H($C03,$T31) H($C02,$T32) H($C01,$T33) H($C29,$T34) H($C30,$T35)
H($C31,$T36) H($C32,$T37)
sas: Enter sas_scsi_recover_host
B($T23) B($T22) B($T21) B($T20) B($T19) B($T18) B($T17) B($T16) B($T15) B($T14)
B($T13) B($T12) B($T11) B($T10) B($T09) B($T08) B($T07) B($T06) B($T05) B($T04)
B($T03) B($T02) B($T01) B($T29) B($T30) B($T31) B($T32) B($T33) B($T34) B($T35)
B($T36) B($T37)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:12:27
H($C32,$T37) H($C31,$T36) H($C30,$T35) H($C29,$T34) H($C01,$T33) H($C02,$T32)
H($C03,$T31) H($C04,$T30) H($C05,$T29) H($C06,$T01) H($C07,$T02) H($C08,$T03)
H($C09,$T04) H($C10,$T05) H($C11,$T06) H($C12,$T07) H($C13,$T08) H($C14,$T09)
H($C15,$T10) H($C16,$T11) H($C17,$T12) H($C18,$T13) H($C19,$T14) H($C20,$T15)
H($C21,$T16) H($C22,$T17) H($C23,$T18) H($C24,$T19) H($C25,$T20) H($C26,$T21)
H($C27,$T22) H($C28,$T23)
sas: Enter sas_scsi_recover_host
B($T37) B($T36) B($T35) B($T34) B($T33) B($T32) B($T31) B($T30) B($T29) B($T01)
B($T02) B($T03) B($T04) B($T05) B($T06) B($T07) B($T08) B($T09) B($T10) B($T11)
B($T12) B($T13) B($T14) B($T15) B($T16) B($T17) B($T18) B($T19) B($T20) B($T21)
B($T22) B($T23)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:12:57
H($C28,$T23) H($C27,$T22) H($C26,$T21) H($C25,$T20) H($C24,$T19) H($C23,$T18)
H($C22,$T17) H($C21,$T16) H($C20,$T15) H($C19,$T14) H($C18,$T13) H($C17,$T12)
H($C16,$T11) H($C15,$T10) H($C14,$T09) H($C13,$T08) H($C12,$T07) H($C11,$T06)
H($C10,$T05) H($C09,$T04) H($C08,$T03) H($C07,$T02) H($C06,$T01) H($C05,$T29)
H($C04,$T30) H($C03,$T31) H($C02,$T32) H($C01,$T33) H($C29,$T34) H($C30,$T35)
H($C31,$T36) H($C32,$T37)
sas: Enter sas_scsi_recover_host
B($T23) B($T22) B($T21) B($T20) B($T19) B($T18) B($T17) B($T16) B($T15) B($T14)
B($T13) B($T12) B($T11) B($T10) B($T09) B($T08) B($T07) B($T06) B($T05) B($T04)
B($T03) B($T02) B($T01) B($T29) B($T30) B($T31) B($T32) B($T33) B($T34) B($T35)
B($T36) B($T37)

#### Here the raid reports it has some problems with /dev/sdn device (fifth
      drive on the controller)

sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
^IOperation continuing on 1 devices
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 26 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:13:27
H($C32,$T37) H($C31,$T36) H($C30,$T35) H($C29,$T34) H($C33,$T33) H($C01,$T32)
H($C02,$T31) H($C03,$T30) H($C04,$T29) H($C05,$T01) H($C06,$T02) H($C07,$T03)
H($C08,$T04) H($C09,$T05) H($C10,$T06) H($C11,$T07) H($C12,$T08) H($C13,$T09)
H($C14,$T10)
sas: Enter sas_scsi_recover_host
B($T37) B($T36) B($T35) B($T34) B($T33) B($T32) B($T31) B($T30) B($T29) B($T01)
B($T02) B($T03) B($T04) B($T05) B($T06) B($T07) B($T08) B($T09) B($T10)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
printk: 4 messages suppressed.
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 2 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:13:57
H($C14,$T10) H($C13,$T09) H($C12,$T08) H($C11,$T07) H($C10,$T06) H($C09,$T05)
H($C08,$T04) H($C07,$T03) H($C06,$T02) H($C05,$T01) H($C04,$T29) H($C03,$T30)
H($C02,$T31) H($C01,$T32) H($C33,$T33)
sas: Enter sas_scsi_recover_host
B($T10) B($T09) B($T08) B($T07) B($T06) B($T05) B($T04) B($T03) B($T02) B($T01)
B($T29) B($T30) B($T31) B($T32) B($T33)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:14:27
H($C33,$T33) H($C01,$T32) H($C02,$T31) H($C03,$T30) H($C04,$T29) H($C05,$T01)
H($C06,$T02) H($C07,$T03) H($C08,$T04) H($C09,$T05) H($C10,$T06) H($C11,$T07)
H($C12,$T08) H($C13,$T09) H($C14,$T10)
sas: Enter sas_scsi_recover_host
B($T33) B($T32) B($T31) B($T30) B($T29) B($T01) B($T02) B($T03) B($T04) B($T05)
B($T06) B($T07) B($T08) B($T09) B($T10)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:14:57
H($C14,$T10) H($C13,$T09) H($C12,$T08) H($C11,$T07) H($C10,$T06) H($C09,$T05)
H($C08,$T04) H($C07,$T03) H($C06,$T02) H($C05,$T01) H($C04,$T29) H($C03,$T30)
H($C02,$T31) H($C01,$T32) H($C33,$T33)
sas: Enter sas_scsi_recover_host
B($T10) B($T09) B($T08) B($T07) B($T06) B($T05) B($T04) B($T03) B($T02) B($T01)
B($T29) B($T30) B($T31) B($T32) B($T33)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:15:27
H($C33,$T33) H($C01,$T32) H($C02,$T31) H($C03,$T30) H($C04,$T29) H($C05,$T01)
H($C06,$T02) H($C07,$T03) H($C08,$T04) H($C09,$T05) H($C10,$T06) H($C11,$T07)
H($C12,$T08) H($C13,$T09) H($C14,$T10)
sas: Enter sas_scsi_recover_host
B($T33) B($T32) B($T31) B($T30) B($T29) B($T01) B($T02) B($T03) B($T04) B($T05)
B($T06) B($T07) B($T08) B($T09) B($T10)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:15:57
H($C14,$T10) H($C13,$T09) H($C12,$T08) H($C11,$T07) H($C10,$T06) H($C09,$T05)
H($C08,$T04) H($C07,$T03) H($C06,$T02) H($C05,$T01) H($C04,$T29) H($C03,$T30)
H($C02,$T31) H($C01,$T32) H($C33,$T33)
sas: Enter sas_scsi_recover_host
B($T10) B($T09) B($T08) B($T07) B($T06) B($T05) B($T04) B($T03) B($T02) B($T01)
B($T29) B($T30) B($T31) B($T32) B($T33)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 14 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:16:27
H($C33,$T33) H($C01,$T32) H($C02,$T31) H($C03,$T30)
sas: Enter sas_scsi_recover_host
B($T33) B($T32) B($T31) B($T30)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:16:57
H($C03,$T30) H($C02,$T31) H($C01,$T32) H($C33,$T33)
sas: Enter sas_scsi_recover_host
B($T30) B($T31) B($T32) B($T33)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:17:27
H($C33,$T33) H($C01,$T32) H($C02,$T31) H($C03,$T30)
sas: Enter sas_scsi_recover_host
B($T33) B($T32) B($T31) B($T30)

sas: --- Exit sas_scsi_recover_host
Jun  3 08:17:57
H($C03,$T30) H($C02,$T31) H($C01,$T32) H($C33,$T33)
sas: Enter sas_scsi_recover_host
B($T30) B($T31) B($T32) B($T33)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:18:27
H($C33,$T33) H($C01,$T32) H($C02,$T31) H($C03,$T30)
sas: Enter sas_scsi_recover_host
B($T33) B($T32) B($T31) B($T30)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:18:57
H($C03,$T30) H($C02,$T31) H($C01,$T32) H($C33,$T33)
sas: Enter sas_scsi_recover_host
B($T30) B($T31) B($T32) B($T33)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 3 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:19:27
H($C03,$T33) H($C33,$T32) H($C01,$T31) H($C02,$T30)
sas: Enter sas_scsi_recover_host
B($T33) B($T32) B($T31) B($T30)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:19:57
H($C02,$T30) H($C01,$T31) H($C33,$T32) H($C03,$T33) H($C34,$T38) H($C35,$T39)
H($C36,$T40) H($C37,$T41) H($C38,$T42) H($C39,$T43) H($C40,$T44) H($C41,$T45)
H($C42,$T46)
sas: Enter sas_scsi_recover_host
B($T30) B($T31) B($T32) B($T33) B($T38) B($T39) B($T40) B($T41) B($T42) B($T43)
B($T44) B($T45) B($T46)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:20:27
H($C42,$T46) H($C41,$T45) H($C40,$T44) H($C39,$T43) H($C38,$T42) H($C37,$T41)
H($C36,$T40) H($C35,$T39) H($C34,$T38) H($C03,$T33) H($C33,$T32) H($C01,$T31)
H($C02,$T30)
sas: Enter sas_scsi_recover_host
B($T46) B($T45) B($T44) B($T43) B($T42) B($T41) B($T40) B($T39) B($T38) B($T33)
B($T32) B($T31) B($T30)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:20:57
H($C02,$T30) H($C01,$T31) H($C33,$T32) H($C03,$T33) H($C34,$T38) H($C35,$T39)
H($C36,$T40) H($C37,$T41) H($C38,$T42) H($C39,$T43) H($C40,$T44) H($C41,$T45)
H($C42,$T46)
sas: Enter sas_scsi_recover_host
B($T30) B($T31) B($T32) B($T33) B($T38) B($T39) B($T40) B($T41) B($T42) B($T43)
B($T44) B($T45) B($T46)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:21:27
H($C42,$T46) H($C41,$T45) H($C40,$T44) H($C39,$T43) H($C38,$T42) H($C37,$T41)
H($C36,$T40) H($C35,$T39) H($C34,$T38) H($C03,$T33) H($C33,$T32) H($C01,$T31)
H($C02,$T30)
sas: Enter sas_scsi_recover_host
B($T46) B($T45) B($T44) B($T43) B($T42) B($T41) B($T40) B($T39) B($T38) B($T33)
B($T32) B($T31) B($T30)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:21:57
H($C02,$T30) H($C01,$T31) H($C33,$T32) H($C03,$T33) H($C34,$T38) H($C35,$T39)
H($C36,$T40) H($C37,$T41) H($C38,$T42) H($C39,$T43) H($C40,$T44) H($C41,$T45)
H($C42,$T46)
sas: Enter sas_scsi_recover_host
B($T30) B($T31) B($T32) B($T33) B($T38) B($T39) B($T40) B($T41) B($T42) B($T43)
B($T44) B($T45) B($T46)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 3 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:22:27
H($C42,$T46) H($C41,$T45) H($C40,$T44) H($C39,$T43) H($C38,$T42) H($C37,$T41)
H($C36,$T40) H($C35,$T39) H($C34,$T38)
sas: Enter sas_scsi_recover_host
B($T46) B($T45) B($T44) B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
printk: 5 messages suppressed.
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 7 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:22:57
H($C34,$T38) H($C35,$T39) H($C36,$T40) H($C37,$T41) H($C38,$T42) H($C39,$T43)
H($C40,$T44) H($C41,$T45) H($C42,$T46) H($C18,$T30) H($C43,$T23) H($C44,$T24)
H($C45,$T29) H($C02,$T47) H($C46,$T31) H($C47,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:23:27
H($C47,$T32) H($C46,$T31) H($C02,$T47) H($C45,$T29) H($C44,$T24) H($C43,$T23)
H($C18,$T30) H($C42,$T46) H($C41,$T45) H($C40,$T44) H($C39,$T43) H($C38,$T42)
H($C37,$T41) H($C36,$T40) H($C35,$T39) H($C34,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:23:57
H($C34,$T38) H($C35,$T39) H($C36,$T40) H($C37,$T41) H($C38,$T42) H($C39,$T43)
H($C40,$T44) H($C41,$T45) H($C42,$T46) H($C18,$T30) H($C43,$T23) H($C44,$T24)
H($C45,$T29) H($C02,$T47) H($C46,$T31) H($C47,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:24:27
H($C47,$T32) H($C46,$T31) H($C02,$T47) H($C45,$T29) H($C44,$T24) H($C43,$T23)
H($C18,$T30) H($C42,$T46) H($C41,$T45) H($C40,$T44) H($C39,$T43) H($C38,$T42)
H($C37,$T41) H($C36,$T40) H($C35,$T39) H($C34,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:24:57
H($C34,$T38) H($C35,$T39) H($C36,$T40) H($C37,$T41) H($C38,$T42) H($C39,$T43)
H($C40,$T44) H($C41,$T45) H($C42,$T46) H($C18,$T30) H($C43,$T23) H($C44,$T24)
H($C45,$T29) H($C02,$T47) H($C46,$T31) H($C47,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:25:27
H($C47,$T32) H($C46,$T31) H($C02,$T47) H($C45,$T29) H($C44,$T24) H($C43,$T23)
H($C18,$T30) H($C42,$T46) H($C41,$T45) H($C40,$T44) H($C39,$T43) H($C38,$T42)
H($C37,$T41) H($C36,$T40) H($C35,$T39) H($C34,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 15 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:25:57
H($C47,$T38) H($C34,$T39) H($C35,$T40) H($C36,$T41) H($C37,$T42) H($C38,$T43)
H($C39,$T44) H($C40,$T45) H($C41,$T46) H($C42,$T30) H($C18,$T23) H($C43,$T24)
H($C44,$T29) H($C45,$T47) H($C02,$T31) H($C46,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:26:27
H($C46,$T32) H($C02,$T31) H($C45,$T47) H($C44,$T29) H($C43,$T24) H($C18,$T23)
H($C42,$T30) H($C41,$T46) H($C40,$T45) H($C39,$T44) H($C38,$T43) H($C37,$T42)
H($C36,$T41) H($C35,$T40) H($C34,$T39) H($C47,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:26:57
H($C47,$T38) H($C34,$T39) H($C35,$T40) H($C36,$T41) H($C37,$T42) H($C38,$T43)
H($C39,$T44) H($C40,$T45) H($C41,$T46) H($C42,$T30) H($C18,$T23) H($C43,$T24)
H($C44,$T29) H($C45,$T47) H($C02,$T31) H($C46,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:27:27
H($C46,$T32) H($C02,$T31) H($C45,$T47) H($C44,$T29) H($C43,$T24) H($C18,$T23)
H($C42,$T30) H($C41,$T46) H($C40,$T45) H($C39,$T44) H($C38,$T43) H($C37,$T42)
H($C36,$T41) H($C35,$T40) H($C34,$T39) H($C47,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:27:57
H($C47,$T38) H($C34,$T39) H($C35,$T40) H($C36,$T41) H($C37,$T42) H($C38,$T43)
H($C39,$T44) H($C40,$T45) H($C41,$T46) H($C42,$T30) H($C18,$T23) H($C43,$T24)
H($C44,$T29) H($C45,$T47) H($C02,$T31) H($C46,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:28:27
H($C46,$T32) H($C02,$T31) H($C45,$T47) H($C44,$T29) H($C43,$T24) H($C18,$T23)
H($C42,$T30) H($C41,$T46) H($C40,$T45) H($C39,$T44) H($C38,$T43) H($C37,$T42)
H($C36,$T41) H($C35,$T40) H($C34,$T39) H($C47,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 15 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:28:57
H($C46,$T38) H($C47,$T39) H($C34,$T40) H($C35,$T41) H($C36,$T42) H($C37,$T43)
H($C38,$T44) H($C39,$T45) H($C40,$T46) H($C41,$T30) H($C42,$T23) H($C18,$T24)
H($C43,$T29) H($C44,$T47) H($C45,$T31) H($C02,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:29:27
H($C02,$T32) H($C45,$T31) H($C44,$T47) H($C43,$T29) H($C18,$T24) H($C42,$T23)
H($C41,$T30) H($C40,$T46) H($C39,$T45) H($C38,$T44) H($C37,$T43) H($C36,$T42)
H($C35,$T41) H($C34,$T40) H($C47,$T39) H($C46,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:29:57
H($C46,$T38) H($C47,$T39) H($C34,$T40) H($C35,$T41) H($C36,$T42) H($C37,$T43)
H($C38,$T44) H($C39,$T45) H($C40,$T46) H($C41,$T30) H($C42,$T23) H($C18,$T24)
H($C43,$T29) H($C44,$T47) H($C45,$T31) H($C02,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:30:27
H($C02,$T32) H($C45,$T31) H($C44,$T47) H($C43,$T29) H($C18,$T24) H($C42,$T23)
H($C41,$T30) H($C40,$T46) H($C39,$T45) H($C38,$T44) H($C37,$T43) H($C36,$T42)
H($C35,$T41) H($C34,$T40) H($C47,$T39) H($C46,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:30:57
H($C46,$T38) H($C47,$T39) H($C34,$T40) H($C35,$T41) H($C36,$T42) H($C37,$T43)
H($C38,$T44) H($C39,$T45) H($C40,$T46) H($C41,$T30) H($C42,$T23) H($C18,$T24)
H($C43,$T29) H($C44,$T47) H($C45,$T31) H($C02,$T32)
sas: Enter sas_scsi_recover_host
B($T38) B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30)
B($T23) B($T24) B($T29) B($T47) B($T31) B($T32)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:31:27
H($C02,$T32) H($C45,$T31) H($C44,$T47) H($C43,$T29) H($C18,$T24) H($C42,$T23)
H($C41,$T30) H($C40,$T46) H($C39,$T45) H($C38,$T44) H($C37,$T43) H($C36,$T42)
H($C35,$T41) H($C34,$T40) H($C47,$T39) H($C46,$T38)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T38)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 15 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:31:57
H($C02,$T39) H($C46,$T40) H($C47,$T41) H($C34,$T42) H($C35,$T43) H($C36,$T44)
H($C37,$T45) H($C38,$T46) H($C39,$T30) H($C40,$T23) H($C41,$T24) H($C42,$T29)
H($C18,$T47) H($C43,$T31) H($C44,$T32) H($C45,$T48)
sas: Enter sas_scsi_recover_host
B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30) B($T23)
B($T24) B($T29) B($T47) B($T31) B($T32) B($T48)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:32:27
H($C45,$T48) H($C44,$T32) H($C43,$T31) H($C18,$T47) H($C42,$T29) H($C41,$T24)
H($C40,$T23) H($C39,$T30) H($C38,$T46) H($C37,$T45) H($C36,$T44) H($C35,$T43)
H($C34,$T42) H($C47,$T41) H($C46,$T40) H($C02,$T39)
sas: Enter sas_scsi_recover_host
B($T48) B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45)
B($T44) B($T43) B($T42) B($T41) B($T40) B($T39)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:32:57
H($C02,$T39) H($C46,$T40) H($C47,$T41) H($C34,$T42) H($C35,$T43) H($C36,$T44)
H($C37,$T45) H($C38,$T46) H($C39,$T30) H($C40,$T23) H($C41,$T24) H($C42,$T29)
H($C18,$T47) H($C43,$T31) H($C44,$T32) H($C45,$T48)
sas: Enter sas_scsi_recover_host
B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30) B($T23)
B($T24) B($T29) B($T47) B($T31) B($T32) B($T48)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:33:27
H($C45,$T48) H($C44,$T32) H($C43,$T31) H($C18,$T47) H($C42,$T29) H($C41,$T24)
H($C40,$T23) H($C39,$T30) H($C38,$T46) H($C37,$T45) H($C36,$T44) H($C35,$T43)
H($C34,$T42) H($C47,$T41) H($C46,$T40) H($C02,$T39)
sas: Enter sas_scsi_recover_host
B($T48) B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45)
B($T44) B($T43) B($T42) B($T41) B($T40) B($T39)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:33:57
H($C02,$T39) H($C46,$T40) H($C47,$T41) H($C34,$T42) H($C35,$T43) H($C36,$T44)
H($C37,$T45) H($C38,$T46) H($C39,$T30) H($C40,$T23) H($C41,$T24) H($C42,$T29)
H($C18,$T47) H($C43,$T31) H($C44,$T32) H($C45,$T48)
sas: Enter sas_scsi_recover_host
B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30) B($T23)
B($T24) B($T29) B($T47) B($T31) B($T32) B($T48)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:34:27
H($C45,$T48) H($C44,$T32) H($C43,$T31) H($C18,$T47) H($C42,$T29) H($C41,$T24)
H($C40,$T23) H($C39,$T30) H($C38,$T46) H($C37,$T45) H($C36,$T44) H($C35,$T43)
H($C34,$T42) H($C47,$T41) H($C46,$T40) H($C02,$T39)
sas: Enter sas_scsi_recover_host
B($T48) B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45)
B($T44) B($T43) B($T42) B($T41) B($T40) B($T39)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 15 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:34:57
H($C45,$T39) H($C02,$T40) H($C46,$T41) H($C47,$T42) H($C34,$T43) H($C35,$T44)
H($C36,$T45) H($C37,$T46) H($C38,$T30) H($C39,$T23) H($C40,$T24) H($C41,$T29)
H($C42,$T47) H($C18,$T31) H($C43,$T32) H($C44,$T48)
sas: Enter sas_scsi_recover_host
B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30) B($T23)
B($T24) B($T29) B($T47) B($T31) B($T32) B($T48)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:35:27
H($C44,$T32) H($C43,$T31) H($C18,$T47) H($C42,$T29) H($C41,$T24) H($C40,$T23)
H($C39,$T30) H($C38,$T46) H($C37,$T45) H($C36,$T44) H($C35,$T43) H($C34,$T42)
H($C47,$T41) H($C46,$T40) H($C02,$T39) H($C45,$T49)
sas: Enter sas_scsi_recover_host
B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45) B($T44)
B($T43) B($T42) B($T41) B($T40) B($T39) B($T49)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:35:57
H($C45,$T39) H($C02,$T40) H($C46,$T41) H($C47,$T42) H($C34,$T43) H($C35,$T44)
H($C36,$T45) H($C37,$T46) H($C38,$T30) H($C39,$T23) H($C40,$T24) H($C41,$T29)
H($C42,$T47) H($C18,$T31) H($C43,$T32) H($C44,$T50)
sas: Enter sas_scsi_recover_host
B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30) B($T23)
B($T24) B($T29) B($T47) B($T31) B($T32) B($T50)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:36:07
md: cannot remove active disk sdn3 from md16 ...

Jun  3 08:36:27
sd 3:0:5:0: [sdn] Synchronizing SCSI cache
H($C44,$T50) H($C43,$T32) H($C18,$T31) H($C42,$T47) H($C41,$T29) H($C40,$T24)
H($C39,$T23) H($C38,$T30) H($C37,$T46) H($C36,$T45) H($C35,$T44) H($C34,$T43)
H($C47,$T42) H($C46,$T41) H($C02,$T40) H($C45,$T39)

Jun  3 08:36:57
H($C48,$T51)
sas: Enter sas_scsi_recover_host
B($T50) B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46) B($T45)
B($T44) B($T43) B($T42) B($T41) B($T40) B($T39) B($T51)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:37:22
^IOperation continuing on 1 devices
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:0, o:1, dev:sdg1
  disk 1, wo:1, o:0, dev:sdn1
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:0, o:1, dev:sdg1

Jun  3 08:37:27
H($C48,$T39) H($C45,$T40) H($C02,$T41) H($C46,$T42) H($C47,$T43) H($C34,$T44)
H($C35,$T45) H($C36,$T46) H($C37,$T30) H($C38,$T23) H($C39,$T24) H($C40,$T29)
H($C41,$T47) H($C42,$T31) H($C18,$T32) H($C43,$T50) H($C44,$T52)
sas: Enter sas_scsi_recover_host
B($T39) B($T40) B($T41) B($T42) B($T43) B($T44) B($T45) B($T46) B($T30) B($T23)
B($T24) B($T29) B($T47) B($T31) B($T32) B($T50) B($T52)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:37:57
H($C44,$T52) H($C43,$T50) H($C18,$T32) H($C42,$T31) H($C41,$T47) H($C40,$T29)
H($C39,$T24) H($C38,$T23) H($C37,$T30) H($C36,$T46) H($C35,$T45) H($C34,$T44)
H($C47,$T43) H($C46,$T42) H($C02,$T41) H($C45,$T40) H($C48,$T39)
sas: Enter sas_scsi_recover_host
B($T52) B($T50) B($T32) B($T31) B($T47) B($T29) B($T24) B($T23) B($T30) B($T46)
B($T45) B($T44) B($T43) B($T42) B($T41) B($T40) B($T39)
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
  last message repeated 15 times
sas: --- Exit sas_scsi_recover_host

Jun  3 08:37:58
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:0, o:1, dev:sdg3
  disk 1, wo:1, o:0, dev:sdn3
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:0, o:1, dev:sdg3

Jun  3 08:38:27
H($C48,$T39)
sas: Enter sas_scsi_recover_host
B($T39)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:38:57
H($C48,$T39)
sas: Enter sas_scsi_recover_host
B($T39)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:39:27
H($C48,$T39)
sas: Enter sas_scsi_recover_host
B($T39)
sas: --- Exit sas_scsi_recover_host
171 times S()

Jun  3 08:39:57
H($C49,$T53)
sas: Enter sas_scsi_recover_host
B($T53)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:40:27
H($C49,$T53)
sas: Enter sas_scsi_recover_host
B($T53)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:40:57
H($C49,$T53)
sas: Enter sas_scsi_recover_host
B($T53)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:41:27
H($C49,$T53)
sas: Enter sas_scsi_recover_host
B($T53)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:41:57
H($C49,$T53)
sas: Enter sas_scsi_recover_host
B($T53)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:42:27
H($C49,$T54)
sas: Enter sas_scsi_recover_host
B($T54)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:42:57
H($C40,$T54)
sas: Enter sas_scsi_recover_host
B($T54)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:43:27
H($C40,$T55)
sas: Enter sas_scsi_recover_host
B($T55)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:43:57
H($C40,$T55)
sas: Enter sas_scsi_recover_host
B($T55)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:44:27
H($C40,$T55)
sas: Enter sas_scsi_recover_host
B($T55)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:44:57
H($C40,$T55)
sas: Enter sas_scsi_recover_host
B($T55)
sas: --- Exit sas_scsi_recover_host

Jun  3 08:45:27
H($C40,$T55)
sas: Enter sas_scsi_recover_host
B($T55)
sas: --- Exit sas_scsi_recover_host
sd 3:0:5:0: [sdn] Result: hostbyte=0x05 driverbyte=0x00
174 times S()

Jun  3 08:58:57
  -- MARK --
