From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] [Target_Core_Mod] Add new EVPD 0x83 identifers and
	RELATIVE TARGET PORT IDENTIFIER usage
Date: Sun, 01 Feb 2009 21:58:30 -0800
Message-ID: <1233554310.12375.37.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753825AbZBBF76@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Zhang <blackmagic02881@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

This patch series adds EVPD 0x83 Relative target port identifer and SCSI Name string
identifier usage in a $FABRIC_MOD independent manner within Target_Core_Mod v3.0.
This has been tested with LIO-Target v3.0 using iSCSI Target Ports using Doug Gilbert's
excellent sg_inq tool from sg3_utils for formatting the INQUIRY EVPD Response Payloads.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/4] [Target_Core_Mod]: Move core se_port_t logic to target_core_device.c
[PATCH 2/4] [Target_Core_Mod/PERSISTENT_RESERVATIONS]: Fix RELATIVE TARGET PORT IDENTIFIER usage
[PATCH 3/4] [Target_Core_Mod]: Add support for EVPD 0x83 Relative target port identifer and SCSI Name string
[PATCH 4/4] [LIO-Target]: Add iscsi_get_fabric_proto_ident() for EVPD PIV=1 usage

 drivers/lio-core/iscsi_target.c           |    9 ++
 drivers/lio-core/iscsi_target.h           |    1 +
 drivers/lio-core/iscsi_target_configfs.c  |    1 +
 drivers/lio-core/target_core_base.h       |    4 +-
 drivers/lio-core/target_core_configfs.c   |    8 +-
 drivers/lio-core/target_core_device.c     |   66 +++++++++++
 drivers/lio-core/target_core_device.h     |    3 +
 drivers/lio-core/target_core_fabric_ops.h |    1 +
 drivers/lio-core/target_core_mib.h        |    1 -
 drivers/lio-core/target_core_pr.c         |    8 +-
 drivers/lio-core/target_core_seobj.c      |   33 +-----
 drivers/lio-core/target_core_transport.c  |  180 +++++++++++++++++++++++++----
 12 files changed, 258 insertions(+), 57 deletions(-)

--nab
