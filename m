From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] [Target_Core_Mod/Persistent_Reservations]: Add
	SPEC_I_PT=1 support
Date: Sat, 08 Aug 2009 21:56:02 -0700
Message-ID: <1249793762.11105.233.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:45495 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751135AbZHIE4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2009 00:56:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>

Hello again SCSI folks,

Attached are two patches for implementing the Specify Initiator Port Capable (SPEC_I_PT=1)
feature bit for handling of fabric dependent TransportIDs with PROUT service action REGISTER.
This is done by walking the PROUT parameter list, and calling fabric module dependent code for
extracting the TransportIDs and lengths, and then doing a second loop performing atomic adding
of pre-registered registrations for the fabric Initiator Ports referenced by TransportIDs.

This has been been tested with TCM/IBLOCK with fabric LIO-Target ports on v2.6.31-rc5 x86
32-bit KVM, please have a look at Patch 1 for an example using sg_persist + SPEC_I_PT=1 with
this code.

--nab

[PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add Specify Initiator Port Capable (SPEC_I_PT=1) support
[PATCH 2/2] [LIO-Target]: Update iSCSI TransportID parser to return length

 drivers/lio-core/iscsi_target_tpg.c     |   26 ++-
 drivers/lio-core/iscsi_target_tpg.h     |    2 +-
 drivers/target/target_core_pr.c         |  445 +++++++++++++++++++++++++++++--
 include/target/target_core_fabric_ops.h |    2 +-
 4 files changed, 448 insertions(+), 27 deletions(-)


