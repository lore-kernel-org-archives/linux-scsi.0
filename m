From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] [Target_Core_Mod] Add explict/implict ALUA transition
	for primary/secondary access states
Date: Tue, 18 Aug 2009 16:15:37 -0700
Message-ID: <1250637337.27590.64.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n22a.bullet.mail.mud.yahoo.com ([68.142.207.188]:25684 "HELO
	n22a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750800AbZHRXVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 19:21:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alasdair G Kergon <agk@redhat.com>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

Greetings folks,

This patch series adds complete fabric level support for Asymmetric
Logical Unit Assignment (ALUA) explict (w/ remote SET_TARGET_PORT_GROUPS
in-band method) and implict (w/ local configfs method) with all SPC-4
defined ALUA primary and secondary access states, as well as the full
ALUA logical unit group abstraction to the lio-core-2.6.git tree.

This patch series has been tested on v2.6.31-rc5 x86 KVM using sg_stpg
for the explict transition case from Open-iSCSI Initiator, and using
lio-utils.git CLI ops for the implict case.  The userspace commits to
make it go can be found here:

http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=481916be1c568fbab505ade534527d60b33bbb8a
http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=7e3e2134397145ce75aba2cbd1725abe761bb8bd

Here are the patches:

[PATCH 1/4] [Target_Core_Mod/ALUA]: Add support for explict/implict ALUA primary/secondary state transition
[PATCH 2/4] [Target_Core_Mod/ConfigFS]: Add implict ALUA attributes and move tg_pt_gp list
[PATCH 3/4] [LIO-Target]: Add ALUA Active/NonOptimized state check
[PATCH 4/4] [LIO-Target/ConfigFS]: Add attribute for ALUA secondary port access state

Any comments from the SCSI and multipath folks would be apperciated,

Many thanks for your most valuable of time,

--nab

Here is what it looks like in action with Open-iSCSI Initiators using scsi_dh_alua + multipath:

*) A single TCM storage object (iblock/lvm_test0) has two non default ALUA target port groups
created for itself, lio_alua_west and lio_alua_east.  Each of these two ALUA target port groups
has a diSCSI target port/LUN active from different iSCSI target endpoints:

   target:~# tcm_node --listaluatpgs iblock_0/lvm_test0
   \------> lio_alua_west  Target Port Group ID: 1
            Active ALUA Access Type(s): Implict and Explict
            Primary Access State: Active/Optimized
            Primary Access Status: None
            Preferred Bit: 0
            Active/NonOptimized Delay in milliseconds: 100
            \------> TG Port Group Members
                iSCSI/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun_0
   \------> lio_alua_east  Target Port Group ID: 2
            Active ALUA Access Type(s): Implict and Explict
            Primary Access State: Active/Optimized
            Primary Access Status: None
            Preferred Bit: 0
            Active/NonOptimized Delay in milliseconds: 100
            \------> TG Port Group Members
                iSCSI/iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd/tpgt_1/lun_0
   <SNIP>

*) On the Initiator side, two sessions are created to each iSCSI target endpoint:

   [  877.235778] sd 4:0:0:0: Attached scsi generic sg8 type 0
   [  877.669556] sd 4:0:0:0: alua: supports implicit and explicit TPGS
   [  877.676442] sd 4:0:0:0: alua: port group 01 rel port 02
   [  877.681561] sd 4:0:0:0: alua: port group 01 state A supports TOUSNA
   [  877.726035] sd 4:0:0:0: alua: port group 01 state A supports TOUSNA
   [  877.746897] sd 3:0:0:0: alua: supports implicit and explicit TPGS
   [  877.755445] sd 3:0:0:0: alua: port group 01 rel port 01
   [  877.760968] sd 3:0:0:0: alua: port group 01 state A supports TOUSNA

The two iSCSI Target port/LUNs appear as /dev/sde and /dev/sdi on the initiator under mpath4:

    mpath4 (36001405a97e4ce21c0711de829b000c2) dm-2 LIO-ORG,IBLOCK
    [size=500M][features=0][hwhandler=1 alua]
    \_ round-robin 0 [prio=100][enabled]
     \_ 3:0:0:0 sde 8:64  [active][ready]
     \_ 4:0:0:0 sdi 8:128 [active][ready]

*) Next using explict ALUA from the initiator, change TG_PT_GP_ID=1 (lio_alua_west) to Active/NonOptimized:

   initiator# sg_stpg -vvv -a /dev/sdi --tp 1
   open /dev/sdi with flags=0x802
       set target port groups cdb: a4 0a 00 00 00 00 00 00 00 08 00 00 
       set target port groups parameter list:
           00 00 00 00 01 00 00 01                             
         duration=8 ms

*) Send a REPORT_TARGET_PORT_GROUPS from the initiator to one of the iSCSI LUNs:

   initiator# sg_rtpg --decode /dev/sde
   Report target port groups:
   <SNIP>
     target port group id : 0x2 , Pref=0
       target port group asymmetric access state : 0x00 (active/optimized)
       T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
       status code : 0x00 (no status available)
       vendor unique status : 0x00
       target port count : 01
       Relative target port ids:
         0x02
     target port group id : 0x1 , Pref=0
       target port group asymmetric access state : 0x01 (active/non optimized)
       T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
       status code : 0x01 (target port asym. state changed by SET TARGET PORT GROUPS command)
       vendor unique status : 0x00
       target port count : 01
       Relative target port ids:
         0x01

*) Then, using implict ALUA via configfs, change lio_alua_east (TG_PT_GP_ID=2) to Standby:

   target:~# tcm_node --setaluastate iblock_0/lvm_test0 lio_alua_east s
   Successfully set primary ALUA access state for TG PT Group: lio_alua_east to Standby

and then check the status again to see the updated Primary Access State and Status for lio_alua_east:

   target:~# tcm_node --listaluatpgs iblock_0/lvm_test0
   \------> lio_alua_west  Target Port Group ID: 1
            Active ALUA Access Type(s): Implict and Explict
            Primary Access State: Active/NonOptimized
            Primary Access Status: Altered by Explict STPG
            Preferred Bit: 0
            Active/NonOptimized Delay in milliseconds: 100
            \------> TG Port Group Members
                iSCSI/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun_0
   \------> lio_alua_east  Target Port Group ID: 2
            Active ALUA Access Type(s): Implict and Explict
            Primary Access State: Standby
            Primary Access Status: Altered by Implict ALUA
            Preferred Bit: 0
            Active/NonOptimized Delay in milliseconds: 100
            \------> TG Port Group Members
                iSCSI/iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd/tpgt_1/lun_0
   <SNIP>

*) On the initiator side, check multipath status for lio_alua_east (TG_PT_GP_ID=2) going into Standby:

   mpath4 (36001405a97e4ce21c0711de829b000c2) dm-2 LIO-ORG,IBLOCK
   [size=500M][features=0][hwhandler=1 alua]
   \_ round-robin 0 [prio=10][enabled]
    \_ 3:0:0:0 sde 8:64  [active][ready] 
    \_ 4:0:0:0 sdi 8:128 [active][faulty]

*) Using implict ALUA via configfs, set lio_alua_east (TG_PT_GP_ID=2) back to Active/Optimized:

   target:~# tcm_node --setaluastate iblock_0/lvm_test0 lio_alua_east o
   Successfully set primary ALUA access state for TG PT Group: lio_alua_east to Active/Optimized

*) Set the preferred bit for lio_alua_east (TG_PT_GP_ID=2)

   target:~# tcm_node --setaluapref iblock_0/lvm_test0 lio_alua_east
   Successfully enabled PREFERRED bit for TG Pt Group: lio_alua_east

*) Issue REPORT_TARGET_PORT_GROUPS again from the initiator side to see the updated status:

   initiator# sg_rtpg --decode /dev/sde
   Report target port groups:
   <SNIP>
     target port group id : 0x2 , Pref=1
       target port group asymmetric access state : 0x00 (active/optimized)
       T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
       status code : 0x02 (target port asym. state changed by implicit lu behaviour)
       vendor unique status : 0x00
       target port count : 01
       Relative target port ids:
         0x02
     target port group id : 0x1 , Pref=0
       target port group asymmetric access state : 0x01 (active/non optimized)
       T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
       status code : 0x01 (target port asym. state changed by SET TARGET PORT GROUPS command)
       vendor unique status : 0x00
       target port count : 01
       Relative target port ids:
         0x01

*) And check the multipath status again from the initiator to see the updates status:

   mpath4 (36001405a97e4ce21c0711de829b000c2) dm-2 LIO-ORG,IBLOCK
   [size=500M][features=0][hwhandler=1 alua]
   \_ round-robin 0 [prio=60][enabled]
    \_ 3:0:0:0 sde 8:64  [active][ready]
    \_ 4:0:0:0 sdi 8:128 [active][ready]


*) And finally, the output for the above sequence from dmesg on the target side showing the
   explict/implict ALUA state transitions and the allocated UNIT ATTENTIONs to notify SCSI Initiator
   Ports of the transitions:

   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   Successful explict ALUA transition TG PT Group: lio_alua_west ID: 1 from primary access state: Active/Optimized to Active/NonOptimized
   [iSCSI]: Releasing UNIT ATTENTION condition with INTLCK_CTRL: 0, mapped LUN: 0, got CDB: 0x00 reported ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   Successful implict ALUA transition TG PT Group: lio_alua_east ID: 2 from primary access state: Active/Optimized to Standby
   [iSCSI]: Releasing UNIT ATTENTION condition with INTLCK_CTRL: 0, mapped LUN: 0, got CDB: 0x00 reported ASC: 0x2a, ASCQ: 0x06
   [iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x06
   Successful implict ALUA transition TG PT Group: lio_alua_east ID: 2 from primary access state: Standby to Active/Optimized
   [iSCSI]: Releasing UNIT ATTENTION condition with INTLCK_CTRL: 0, mapped LUN: 0, got CDB: 0x00 reported ASC: 0x2a, ASCQ: 0x06















