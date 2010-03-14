From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] [TCM/PR]: Intra-fabric iSCSI/SAS/FCoE Persistent Reservations support
Date: Sun, 14 Mar 2010 01:17:38 -0800
Message-ID: <1268558258-10738-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:44386 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751800Ab0CNJL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2010 05:11:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.co>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Linux/SCSI folks,

This patch series to lio-core-2.6.git/master adds support for TCM v3.x >= Persistent
Reservation SPEC_I_PT=1 TransportID processing and REGISTER_AND_MOVE logic to safely
function in intra-fabric mode across all available TCM fabric modules using a new set
of demo-mode safe configfs dependency wrappers.

This means that the exhaustive (all SPC-4 defined feature bits) Persistent Reservation
support in TCM v3.x at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_pr.c;hb=HEAD

is now functioning not only in multi-fabric mode (processing PR ops across multiple
fabric modules), but also in intra-fabric mode (a single PR op spanning multiple fabrics)
for the SPEC_I_PT=1 TransportID processing and REGISTER_AND_MOVE op cases in both explict
ACL and demo-mode operation..

This patch has been tested using LIO-Target iSCSI Target Ports, TCM_Loop Virtual SAS
Target Ports, and tcm_fc OpenFCoE.org Target Ports from new code in lio-core-2.6.git/tcm_fc.
Below is the example usage of intra-fabric PR ops with APTPL=1 using SCSI ports from these
three independent (3) fabric modules.

Comments..?

--nab

Nicholas Bellinger (3):
  [TCM/PR]: Add TPG, NodeACL and MappedLUN wrappers for
    configfs_[un]depend_item()
  [TCM/PR]: Convert REGISTER_AND_MOVE use new configfs dependency
    wrappers
  [TCM/PR]: Add support for intra-fabric SPEC_I_PT=1 TransportID
    processing

 drivers/target/target_core_pr.c |  360 ++++++++++++++++++++++++++++-----------
 1 files changed, 260 insertions(+), 100 deletions(-)

*) Create PR registrations for iSCSI (iqn.1993-08.org.debian:01:2dadf92d0ef) and
   Virtual SAS (naa.60014051e4328f54) fabric from iSCSI port using SPEC_I_PT=1 and APTPL=0

 sg_persist -vvv --out --device /dev/sde --register --param-rk=0 --param-sark=0x1234ffff -T 5 -X 06,00,00,00,6E,61,61,2E,36,30,30,31,34,30,35,31,65,34,33,32,38,66,35,34,00
number of tranport-ids decoded from command line (or stdin): 1
  Decode given transport-ids:
      Transport Id of initiator:
        SAS address: 0x6e61612e36303031
open /dev/sde with flags=0x800
    inquiry cdb: 12 00 00 00 24 00 
      duration=0 ms
  LIO-ORG  IBLOCK  3.1
  Peripheral device type: disk
open /dev/sde with flags=0x802
    Persistent Reservation Out cmd: 5f 00 05 00 00 00 00 00 34 00 
    Persistent Reservation Out parameters:
 00     00 00 00 00 00 00 00 00  00 00 00 00 12 34 ff ff    .............4..
 10     00 00 00 00 08 00 00 00  00 00 00 18 06 00 00 00    ................
 20     6e 61 61 2e 36 30 30 31  34 30 35 31 65 34 33 32    naa.60014051e432
 30     38 66 35 34                                         8f54            
      duration=8 ms
PR out: command (Register) successful

*) Create PR Write Exclusive Registrants Only Reservation from Virtual SAS Port (naa.60014051e4328f54)

sg_persist -vvv --out --reserve -d /dev/sdg --param-rk=0x1234ffff -T 5
open /dev/sdg with flags=0x800
    inquiry cdb: 12 00 00 00 24 00 
      duration=0 ms
  LIO-ORG  IBLOCK  3.1
  Peripheral device type: disk
open /dev/sdg with flags=0x802
    Persistent Reservation Out cmd: 5f 01 05 00 00 00 00 00 18 00 
    Persistent Reservation Out parameters:
 00     00 00 00 00 12 34 ff ff  00 00 00 00 00 00 00 00    .....4..........
 10     00 00 00 00 00 00 00 00                             ........        
      duration=0 ms
PR out: command (Reserve) successful

*) Call REGISTER_AND_MOVE with APTPL=1 to transfer PR reservation from Virtual SAS Port (naa.60014051e4328f54)
   to a new registration on the FCoE Target port (20:00:50:41:4c:4f:3b:00)

sg_persist -vvv --out --register-move --relative-target-port 3 -Z -d /dev/sdg --param-rk=0x1234ffff --param-sark=0xabcdffff -X 00,00,00,00,00,00,00,00,32,30,3A,30,30,3A,35,30,3A,34,31,3A,34,63,3A,34,66,3A,33,62,3A,30,30,00
number of tranport-ids decoded from command line (or stdin): 1
  Decode given transport-ids:
      Transport Id of initiator:
        FCP-2 World Wide Name:
 00     32 30 3a 30 30 3a 35 30                             20:00:50        
      Transport Id of initiator:
        SAS address: 0x3a30300000000000
        [Unexpected format code: 1]
open /dev/sdg with flags=0x800
    inquiry cdb: 12 00 00 00 24 00 
      duration=0 ms
  LIO-ORG  IBLOCK  3.1
  Peripheral device type: disk
open /dev/sdg with flags=0x802
    Persistent Reservation Out cmd: 5f 07 08 00 00 00 00 00 38 00 
    Persistent Reservation Out parameters:
 00     00 00 00 00 12 34 ff ff  00 00 00 00 ab cd ff ff    .....4..........
 10     00 01 00 03 00 00 00 20  00 00 00 00 00 00 00 00    ....... ........
 20     32 30 3a 30 30 3a 35 30  3a 34 31 3a 34 63 3a 34    20:00:50:41:4c:4
 30     66 3a 33 62 3a 30 30 00                             f:3b:00.        
      duration=8 ms
PR out: 'register and move' command successful

*) Display PERSISTENT_RESERVE_IN READ_FULL_STATUS

sg_persist --in -s -d /dev/sdg  LIO-ORG  IBLOCK  3.1
  Peripheral device type: disk
  PR generation=0x3
    Key=0x1234ffff
      All target ports bit clear
      Relative port address: 0x2
      not reservation holder
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef
    Key=0x1234ffff
      All target ports bit clear
      Relative port address: 0x4
      not reservation holder
      Transport Id of initiator:
        SAS address: 0x60014051e4328f54
    Key=0xabcdffff
      All target ports bit clear
      Relative port address: 0x3
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive, registrants only
      Transport Id of initiator:
        FCP-2 World Wide Name:
 00     20 00 50 41 4c 4f 3b 00                              .PALO;.     

*) kernel ring buffer output, note that virtual SAS ports appear as 'loopback'

SPC-3 PR SPEC_I_PT: Located loopback Node: naa.60014051e4328f54 Port RTPI: 4
SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234ffff PRgeneration: 0x00000000  APTPL: 0
SPC-3 PR [iSCSI] SPEC_I_PT: Successfully registered Transport ID for Node: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: 0
SPC-3 PR [loopback] Service Action: REGISTER Initiator Node: naa.60014051e4328f54
SPC-3 PR [loopback] for SINGLE TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [loopback] SA Res Key: 0x000000001234ffff PRgeneration: 0x00000001  APTPL: 0
SPC-3 PR [loopback] SPEC_I_PT: Successfully registered Transport ID for Node: naa.60014051e4328f54 Mapped LUN: 0
SPC-3 PR: Set APTPL Bit Deactivated for REGISTER
SPC-3 PR [loopback] Service Action: RESERVE created new reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 0
SPC-3 PR [loopback] RESERVE Node: naa.60014051e4328f54
SPC-3 PR [fc] Extracted initiator device identifier: 20:00:50:41:4c:4f:3b:00 
SPC-3 PR [fc] Service Action: REGISTER_AND_MOVE Initiator Node: 20:00:50:41:4c:4f:3b:00
SPC-3 PR [fc] for SINGLE TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [fc] SA Res Key: 0x00000000abcdffff PRgeneration: 0x00000002  APTPL: 1
SPC-3 PR [loopback] Service Action: implict RELEASE cleared reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 0
SPC-3 PR [loopback] RELEASE Node: naa.60014051e4328f54
SPC-3 PR [fc] Service Action: REGISTER_AND_MOVE created new reservation holder TYPE: Write Exclusive Access, Registrants Only on object RTPI: 3  PRGeneration: 0x00000002
SPC-3 PR Successfully moved reservation from loopback Fabric Node: naa.60014051e4328f54 -> fc Fabric Node: 20:00:50:41:4c:4f:3b:00 
SPC-3 PR: Set APTPL Bit Activated for REGISTER_AND_MOVE

*) lsmod output

lsmod
Module                  Size  Used by
tcm_loop               12593  5 
tcm_fc                 21107  6 
libfc                  71025  1 tcm_fc
iscsi_target_mod      201832  54 
target_core_mod       233736  92 tcm_loop,tcm_fc,iscsi_target_mod
scsi_tgt                8646  1 target_core_mod
configfs               20592  5 tcm_loop,tcm_fc,iscsi_target_mod,target_core_mod
