From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] [Target_Core_Mod/Persistent_Reservations]: Add implict
	release and PROUT CLEAR SA
Date: Thu, 19 Mar 2009 01:55:27 -0700
Message-ID: <1237452927.4138.35.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:21727 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754390AbZCSIzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 04:55:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>

Greetings all,

This first patch series adds implict release of PR reservations/registrations when
a $FABRIC_MOD logical unit ACL is being released through target_core_mod/ConfigFS.
The second patch adds support for the PROUT CLEAR service action that allows a registered
I_T nexus (eg: initiator port) to release PR reservations/registrations.  This is one of
the PROUT service actions that various client side cluster code / SCSI subsystem initiators
use with SCSI persistent reservations for fencing of failed nodes.

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29-rc8 x86 32-bit HVM using sg_persist from sg3_utils.  The lio-core-2.6.git tree
can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add implict PR RELEASE+UNREGISTER for LUN acl removal
[PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Add PROUT CLEAR service action

 drivers/lio-core/target_core_base.h   |    1 +
 drivers/lio-core/target_core_device.c |   14 ++-
 drivers/lio-core/target_core_pr.c     |  288 ++++++++++++++++++++++++++-------
 drivers/lio-core/target_core_pr.h     |    2 +
 4 files changed, 239 insertions(+), 66 deletions(-)

--nab


