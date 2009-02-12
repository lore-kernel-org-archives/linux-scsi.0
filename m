From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ALUA]: Add group membership structure
	logic
Date: Wed, 11 Feb 2009 22:33:36 -0800
Message-ID: <1234420416.12375.512.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:32634 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751336AbZBLGiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2009 01:38:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>

Greetings all,

This patch series adds proper ALUA Logical Unit Group and Target Port Group membership
association to Target_Core_Mod/ConfigFS in a manner that can handle concurrent shutdown from
core/$HBA/$DEV/ <-> core/alua/lu_gps/$MY_LUN_GROUP and core/alua/tg_pt_gps/$MY_TG_PT_GROUP <->
$FABRIC_MOD/target_port/lun/$LUN/alua_tg_pt_gp.

This infrastructure is used as explict and implict ALUA group operations continue to come
online for Target_Core_Mod/ConfigFS v3.0.  This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/2] [Target_Core_Mod/ALUA]: Add t10_alua_lu_gp_member_t usage for Logical Unit Groups
[PATCH 2/2] [Target_Core_Mod/ALUA]: Add t10_alua_tg_pt_gp_member_t usage for Target Port Groups

>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating 07c4589..b4a9bf6
Fast forward
 drivers/lio-core/target_core_alua.c      |  478 +++++++++++++++++++++---------
 drivers/lio-core/target_core_alua.h      |   21 +-
 drivers/lio-core/target_core_base.h      |   36 ++-
 drivers/lio-core/target_core_configfs.c  |  106 +++++---
 drivers/lio-core/target_core_device.c    |   19 +-
 drivers/lio-core/target_core_transport.c |   57 +++-
 6 files changed, 497 insertions(+), 220 deletions(-)

--nab

