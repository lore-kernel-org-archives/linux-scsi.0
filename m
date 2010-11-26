From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] target: passthrough command removal
Date: Thu, 25 Nov 2010 23:14:28 -0800
Message-ID: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm28.bullet.mail.ne1.yahoo.com ([98.138.90.91]:40071 "HELO
	nm28.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752767Ab0KZHOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 02:14:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This is hch's series with my improvements to convert Target/pSCSI to
use scsi_execute_req() during backend se_subsystem_api->create_virtdevice()
in order to remove the legacy SCF_CMD_PASSTHROUGH I/O logic.  In modern
v4.0 target code this logic was only used during initial device setup
to extract INQUIRY, EVPD 0x80/0x83 INQUIRY, and READ_CAPACITY for target
mode infrastructure.

My changes to the original series include a fix in patch #2 to pscsi_get_blocks()
for IBLOCK -> TCM_Loop -> PSCSI which caused an OOPs during testing,
and in #3 to work with the underlying SCSI LLD -> SDF_FIRMWARE_VPD_UNIT_SERIAL
case to parse what EVPD identifers 'the underlying HW' actually gives us in
via /sys/kernel/config/target/core/$PSCSI_HBA/$DEV/wwn/vpd_*.

This patch also keeps the Linux/SCSI style standard INQUIRY parsing in
scsi_dump_inquiry() during transport_add_device_to_core_hba() which is
helpful for debugging with all different types of backends enabled..

Currently this series has been merged into lio-core-2.6.git/remove-passthrough,
but I think at this point with a few more days testing and review it will
be ready to merged into master and other lio-4.0 development branches.

Here is the special case of IBLOCK -> TCM_Loop -> pSCSI running on
.37-rc2 in order to test the TCM/pSCSI EVPD refactoring in patch #3

PSCSI: Allocated pdv: ece8b120 for tcm_loop_lun
Target_Core_ConfigFS: Allocated struct se_subsystem_dev: df57e030 se_dev_su_ptr: ece8b120
PSCSI[1]: Referencing SCSI Host ID: 5
PSCSI[1]: Referencing SCSI Channel ID: 0
PSCSI[1]: Referencing SCSI Target ID: 1
PSCSI[1]: Referencing SCSI LUN ID: 0
Target_Core_ConfigFS: pscsi_1/tcm_loop_lun set udev_path: /dev/sdg
pscsi: Using SPC_PASSTHROUGH, no reservation emulation
pscsi: Using SPC_ALUA_PASSTHROUGH, no ALUA emulation
  Vendor: LIO-ORG   Model: IBLOCK            Revision: 4.0 
  Type:   Direct-Access                      ANSI SCSI revision: 05
T10 VPD Identifer Length: 16
T10 VPD Identifier Association: addressed logical unit
T10 VPD Identifier Type: NAA
T10 VPD Binary Device Identifier: 36001405a97e4ce21c0711de829b000c2
T10 VPD Identifer Length: 48
T10 VPD Identifier Association: addressed logical unit
T10 VPD Identifier Type: T10 Vendor ID based
T10 VPD ASCII Device Identifier: LIO-ORG
T10 VPD Identifer Length: 4
T10 VPD Protocol Identifier: SAS Serial SCSI Protocol
T10 VPD Identifier Association: target port
T10 VPD Identifier Type: Relative target port identifier
T10 VPD Binary Device Identifier: 400000001
T10 VPD Identifer Length: 4
T10 VPD Protocol Identifier: SAS Serial SCSI Protocol
T10 VPD Identifier Association: target port
T10 VPD Identifier Type: Unsupported: 0x05
T10 VPD Identifer Length: 4
T10 VPD Identifier Association: addressed logical unit
T10 VPD Identifier Type: Unsupported: 0x06
T10 VPD Identifer Length: 32
T10 VPD Protocol Identifier: SAS Serial SCSI Protocol
T10 VPD Identifier Association: target port
T10 VPD Identifier Type: SCSI name string
T10 VPD UTF-8 Device Identifier: naa.60014051ff57aebc,t,0x0001
CORE_PSCSI[1] - Added TYPE_DISK for 5:0:1:0
Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: df5ad020

and from /sys/kernel/config/target/core/$PSCSI_HBA/$DEV/wwn/*

target:/sys/kernel/config/target/core/pscsi_1/tcm_loop_lun# cat wwn/vpd_*
T10 VPD Identifier Association: addressed logical unit
T10 VPD Identifier Type: NAA
T10 VPD Binary Device Identifier: 36001405a97e4ce21c0711de829b000c2
T10 VPD Identifier Association: addressed logical unit
T10 VPD Identifier Type: T10 Vendor ID based
T10 VPD ASCII Device Identifier: LIO-ORG
T10 VPD Identifier Association: target port
T10 VPD Identifier Type: Relative target port identifier
T10 VPD Binary Device Identifier: 400000001
T10 VPD Identifier Association: target port
T10 VPD Identifier Type: SCSI name string
T10 VPD UTF-8 Device Identifier: naa.60014051ff57aebc,t,0x0001
T10 VPD Protocol Identifier: SAS Serial SCSI Protocol
T10 VPD Protocol Identifier: SAS Serial SCSI Protocol
T10 VPD Unit Serial Number: a97e4ce21c0711de829b000c2943d57b

A big thanks again to Christoph for taking the time to do a proper
removeal of SCF_CMD_PASSTHROUGH, and dropping another ~400 LOC
from drivers/target  !!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Christoph Hellwig (4):
  target-pscsi: query tape blocksize using scsi_execute_req
  target: always get capacity from ->get_blocks
  target-pscsi: get inquiry data using scsi_execute_req
  target: remove passthrough support

 drivers/target/target_core_configfs.c  |    2 -
 drivers/target/target_core_pscsi.c     |  214 +++++++--
 drivers/target/target_core_tmr.c       |    5 +-
 drivers/target/target_core_transport.c |  819 +++++---------------------------
 include/target/target_core_base.h      |   38 +-
 include/target/target_core_transport.h |    9 +-
 6 files changed, 310 insertions(+), 777 deletions(-)

