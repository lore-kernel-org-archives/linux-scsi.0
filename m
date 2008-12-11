From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Wed, 10 Dec 2008 19:14:31 -0800
Message-ID: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:28415 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752993AbYLKDOe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 22:14:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

Greetings all,

I recently patch-bombed the LIO-devel list with two different series of
patches against my work in the lio-core-2.6.git tree on kernel.org.  Not
wanting to spam the kernel lists with these patches (not yet anyways :-)
I am posting the links to the patch series so that interested parties
could have a look at the current progress.  The code is currently
running on v2.6.28-rc7 and will continue to be tracking linux-2.6.git.  

Things are moving quickly for Target_Core_Mod/ConfigFS and LIO-Target
v3.0 development, and I invite folks to have a look at the code.  To
dive into the rest of the v3.0 code via git-web, check out:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core

They are made against against lio-core-2.6.git/master and tested on
v2.6.28-rc7.

For Target_Core_Mod/ConfigFS:

 drivers/lio-core/target_core_base.h       |  165 +++++-
 drivers/lio-core/target_core_device.c     |  122 ++++-
 drivers/lio-core/target_core_device.h     |    1 +
 drivers/lio-core/target_core_fabric_ops.h |   17 +-
 drivers/lio-core/target_core_file.c       |   20 +-
 drivers/lio-core/target_core_iblock.c     |   16 +-
 drivers/lio-core/target_core_pscsi.c      |   15 +-
 drivers/lio-core/target_core_rd.c         |   26 +-
 drivers/lio-core/target_core_rd.h         |    4 +-
 drivers/lio-core/target_core_reportluns.c |  340 +++++++++
 drivers/lio-core/target_core_reportluns.h |   55 ++
 drivers/lio-core/target_core_seobj.c      |   20 +-
 drivers/lio-core/target_core_seobj.h      |   12 +-
 drivers/lio-core/target_core_transport.c  | 1067
++++++++++++++++------------
 drivers/lio-core/target_core_transport.h  |  124 ++--
 15 files changed, 1411 insertions(+), 593 deletions(-)
 create mode 100644 drivers/lio-core/target_core_reportluns.c
 create mode 100644 drivers/lio-core/target_core_reportluns.h

[Target_Core_Mod 1/11]: Add se_* prefixed structures and definitons for generic target core
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/aee873be39d7f32f#
[Target_Core_Mod 2/11]: Add generic transport_get_lun_for_cmd()
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/60b00363b7cd6669#
[Target_Core_Mod 3/11]: Convert dev seobj code to se_cmd_t
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/bf0571ba8d98d6f5#
[Target_Core_Mod 4/11]: Make REPORT_LUNS generic to all $FABRIC_MODs
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/32f02a0ba13a5385#
[Target_Core_Mod 5/11]: Update struct target_core_fabric_ops
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/c0fadc6d4db25e2b#
[Target_Core_Mod 6/11]: Convert core engine to use generic CMD_TFO() callers
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/9ca8cc44af8cbba7#
[Target_Core_Mod 7/11]: Remove iSCSI dependent code from generic write pending codepath
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/f6b6931413a20976#
[Target_Core_Mod/PSCSI 8/11]: Remove iscsi_cmd code from PSCSI subsystem plugins
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/b4aea9852b2eab0a#
[Target_Core_Mod/IBLOCK 9/11]: Remove iscsi_cmd code from IBLOCK subsystem plugins
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/609aaad0b1a761e3#
[Target_Core_Mod/FILEIO 10/11]: Remove iscsi_cmd code from FILEIO subsystem plugins
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/de03d303f5a27d83#
[Target_Core_Mod/RAMDISK 11/11]:  Remove iscsi_cmd code from RAMDISK_* subsystem plugins
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/1921518c262dbbac#

and for LIO-Target v3.0:

 drivers/lio-core/Makefile                  |    2 +-
 drivers/lio-core/iscsi_target.c            |  333 ++++++++++++++++----------
 drivers/lio-core/iscsi_target.h            |    9 +
 drivers/lio-core/iscsi_target_configfs.c   |   17 +-
 drivers/lio-core/iscsi_target_core.h       |  100 ++-------
 drivers/lio-core/iscsi_target_device.c     |  115 ++--------
 drivers/lio-core/iscsi_target_device.h     |    2 +-
 drivers/lio-core/iscsi_target_erl1.c       |   29 ++-
 drivers/lio-core/iscsi_target_erl2.c       |   53 +++--
 drivers/lio-core/iscsi_target_reportluns.c |  351 ----------------------------
 drivers/lio-core/iscsi_target_reportluns.h |   52 ----
 drivers/lio-core/iscsi_target_tmr.c        |   19 ++-
 drivers/lio-core/iscsi_target_util.c       |  142 +++++++-----
 drivers/lio-core/iscsi_target_util.h       |   11 +-
 14 files changed, 429 insertions(+), 806 deletions(-)
 delete mode 100644 drivers/lio-core/iscsi_target_reportluns.c
 delete mode 100644 drivers/lio-core/iscsi_target_reportluns.h

[LIO-Target 1/10]: Remove iSCSI REPORT_LUNS code
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/42132a2f99f3f1b2#
[LIO-Target 2/10]: Move generic code from iscsi_get_lun_for_cmd()
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/f6ae8deb036f93ed#
[LIO-Target 3/10]: Convert ErrorRecoveryLevel=1 code to use se_cmd_t
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/ebb8e185a2e67d06#
[LIO-Target 4/10]: Convert ErrorRecoveryLevel=2 code to use se_cmd_t
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/df0043bc3fd75323#
[LIO-Target 5/10]: Convert iSCSI Task Management code to use se_cmd_t
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/f1aa66b411d259c4#
[LIO-Target 6/10]: Add iscsi_allocate_se_cmd() and se_cmd_t usage
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/fa304b123df19b4f#
[LIO-Target 7/10]: Updates for iscsi_target_core.h
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/dbb209036ac78ef2#
[LIO-Target 8/10] Update iSCSI Target to use se_cmd_t structure and macros
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/fb39db1f12ede911#
[Target_Core_Mod/LIO-Target 9/10] Update Makefile for target_core_reportluns.o
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/be40736f783b53e7#
[LIO-Target/ConfigFS 10/10]: Update struct target_core_fabric_ops for iscsi_target_mod
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/8f9248905df3d217#

--nab

