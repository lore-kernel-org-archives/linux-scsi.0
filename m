From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] [Target_Core_Mod]: Add EVPD information to ConfigFS
Date: Thu, 15 Jan 2009 23:51:45 -0800
Message-ID: <1232092305.1274.171.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45741 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755958AbZAPHwK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 02:52:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>

Greetings all,

This patch adds T10/SCSI WWN / Extended Vital Production Desciptor pages
(EVPD) information into Target_Core_Mod/ConfigFS.  These ConfigFS
attributs are defined as READ-WRITE, but currently only implement
READ-ONLY and return -ENOSYS (this will be changing soon).

This patch adds the following INQUIRY EVPD=1 protocol information to
ConfigFS:

*) Protocol Identifier
*) Association
*) Identifier Type
*) Identifier Binary, ASCII, and UTF-8 encoding

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Here is what the layout looks like with some Parallel SCSI (pscsi_1/sdb)
and Serial SCSI (pscsi_2/sdc and pscsi_2/sdd):

/sys/kernel/config
`-- target
    |-- core
    |   |-- pscsi_1
    |   |   |-- hba_info
    |   |   `-- sdb
    |   |       |-- attrib
    |   |       |   |-- hw_max_sectors
    |   |       |   |-- hw_queue_depth
    |   |       |   |-- max_sectors
    |   |       |   |-- queue_depth
    |   |       |   |-- status_thread
    |   |       |   |-- status_thread_tur
    |   |       |   `-- task_timeout
    |   |       |-- control
    |   |       |-- enable
    |   |       |-- fd
    |   |       |-- info
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial
    |   |-- pscsi_2
    |   |   |-- hba_info
    |   |   |-- sdc
    |   |   |   |-- attrib
    |   |   |   |   |-- hw_max_sectors
    |   |   |   |   |-- hw_queue_depth
    |   |   |   |   |-- max_sectors
    |   |   |   |   |-- queue_depth
    |   |   |   |   |-- status_thread
    |   |   |   |   |-- status_thread_tur
    |   |   |   |   `-- task_timeout
    |   |   |   |-- control
    |   |   |   |-- enable
    |   |   |   |-- fd
    |   |   |   |-- info
    |   |   |   `-- wwn
    |   |   |       |-- evpd_assoc_logical_unit
    |   |   |       |-- evpd_assoc_scsi_target_device
    |   |   |       |-- evpd_assoc_target_port
    |   |   |       |-- evpd_protocol_identifier
    |   |   |       `-- evpd_unit_serial
    |   |   `-- sdd
    |   |       |-- attrib
    |   |       |   |-- hw_max_sectors
    |   |       |   |-- hw_queue_depth
    |   |       |   |-- max_sectors
    |   |       |   |-- queue_depth
    |   |       |   |-- status_thread
    |   |       |   |-- status_thread_tur
    |   |       |   `-- task_timeout
    |   |       |-- control
    |   |       |-- enable
    |   |       |-- fd
    |   |       |-- info
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial

<SNIP>

>From the Parallel SCSI device at pscsi_1/sdb:

target-core:/sys/kernel/config/target/core/pscsi_1/sdb/wwn# cat *
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: EUI-64 based
T10 EVPD Binary Device Identifier: 20010b9fe9f4b0200
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: T10 Vendor ID based
T10 EVPD ASCII Device Identifier: MAXTOR  C40464HK    
T10 EVPD Unit Serial Number:: C40464HK

>From the Serial SCSI device at pscsi_2/sdd:

target-core:/sys/kernel/config/target/core/pscsi_2/sdd/wwn# cat *
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: NAA
T10 EVPD Binary Device Identifier: 350010b90000292df
T10 EVPD Identifier Association: SCSI target device
T10 EVPD Identifier Type: SCSI name string
T10 EVPD UTF-8 Device Identifier: naa.50010B90000292DC
T10 EVPD Identifier Association: target port
T10 EVPD Identifier Type: NAA
T10 EVPD Binary Device Identifier: 350010b90000292de
T10 EVPD Identifier Association: target port
T10 EVPD Identifier Type: Relative target port identifier
T10 EVPD Binary Device Identifier: 400000002
T10 EVPD Protocol Identifier: SAS Serial SCSI Protocol
T10 EVPD Protocol Identifier: SAS Serial SCSI Protocol
T10 EVPD Unit Serial Number:: E20HY72K

Comments..?

--nab

[PATCH 1/2] [Target_Core_Mod]: Move 10_wwn_t to se_subsystem_dev_t->t10_wwn
[PATCH 2/2] [Target_Core_Mod/ConfigFS]: Add T10 EVPD / WWN storage object attributes

 drivers/lio-core/target_core_base.h      |    6 +-
 drivers/lio-core/target_core_configfs.c  |  212 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_device.c    |    8 +-
 drivers/lio-core/target_core_mib.c       |   30 ++--
 drivers/lio-core/target_core_seobj.c     |    2 +-
 drivers/lio-core/target_core_transport.c |   19 ++-
 drivers/lio-core/target_core_transport.h |    4 +
 7 files changed, 251 insertions(+), 30 deletions(-)




