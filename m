From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH Target_Core_Mod]: Add T10 EVPD Unit Serial Number Emulation
Date: Fri, 23 Jan 2009 17:55:42 -0800
Message-ID: <1232762142.24642.12.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23438 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753724AbZAXB4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 20:56:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>

Greetings all,

This patch series adds support for T10 EVPD Unit Serial Number emulation
via ConfigFS to target_core_mod/[pSCSI,IBLOCK,FILEIO,RAMDISK] subsystem plugins.
The Linux/SCSI passthrough with pSCSI has a special consideration for firmware or
Linux/SCSI LLD emulated EVPD information.  eg: it will not let you emulate if
Target_Core_Mod/pSCSI sees active EVPD information in INQUIRY Response payloads.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28 x86 32-bit HVM.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Comments folks..?

--nab

[PATCH 1/6] [Target_Core_Mod]: Add support for configurable EVPD Unit Serial Numbers
[PATCH 2/6] [Target_Core_Mod/RAMDISK]: Update transport_generic_emulate_inquiry() usage
[PATCH 3/6] [Target_Core_Mod/FILEIO): Update for EVPD and remove legacy parameter code
[PATCH 4/6] [Target_Core_Mod/IBLOCK): Update for EVPD and remove legacy parameter code
[PATCH 5/6] [Target_Core_Mod/pSCSI]: Update EVPD post processing logic
[PATCH 6/6] [Target_Core_Mod/ConfigFS]: Add support for $STORAGE_OBJECT EVPD Unit Serial Number emulation

remote: Counting objects: 47, done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 34 (delta 29), reused 0 (delta 0)
Unpacking objects: 100% (34/34), done.
>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating 18ebd43..a50c8a5
Fast forward
 drivers/lio-core/target_core_base.h      |    2 +
 drivers/lio-core/target_core_configfs.c  |   59 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_file.c      |   39 +-------------------
 drivers/lio-core/target_core_file.h      |    8 +---
 drivers/lio-core/target_core_iblock.c    |   45 ++---------------------
 drivers/lio-core/target_core_iblock.h    |   12 ++----
 drivers/lio-core/target_core_pscsi.c     |   34 +++++++++++++-----
 drivers/lio-core/target_core_rd.c        |    2 +-
 drivers/lio-core/target_core_transport.c |   20 ++++++-----
 drivers/lio-core/target_core_transport.h |   13 +++++--
 10 files changed, 117 insertions(+), 117 deletions(-)


