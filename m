From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/6] bfa: cleanups and fixes
Date: Mon, 18 Oct 2010 17:06:55 -0700
Message-ID: <1287446815-25367-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43379 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933526Ab0JSAHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 20:07:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch set continues to clean up bfa driver by replacing the OS
wrapper functions and macros with linux native ones. We also provide fixes
for the following issue reported by Randy Dunlap (randy.dunlap@oracle.com):
1) compile warning of frame size over 1024 in gcc 4.4.
2) commments blocks that begin with /**.

Jing Huang (6):
  bfa: remove os wrapper and unused functions
  bfa: replace endian swap macros with the ones provided by linux
  bfa: remove os wrapper functions and macros
  bfa: fix frame size over 1024 compile warning
  bfa: fix comments for header files
  bfa: fix comments for c files

 drivers/scsi/bfa/bfa.h           |   48 ++--
 drivers/scsi/bfa/bfa_cb_ioim.h   |   22 +-
 drivers/scsi/bfa/bfa_core.c      |  178 +++++++-------
 drivers/scsi/bfa/bfa_cs.h        |   24 +-
 drivers/scsi/bfa/bfa_defs.h      |   54 ++--
 drivers/scsi/bfa/bfa_defs_fcs.h  |   48 ++--
 drivers/scsi/bfa/bfa_defs_svc.h  |   82 +++---
 drivers/scsi/bfa/bfa_drv.c       |    6 +-
 drivers/scsi/bfa/bfa_fc.h        |   30 ++--
 drivers/scsi/bfa/bfa_fcbuild.c   |  196 ++++++++--------
 drivers/scsi/bfa/bfa_fcpim.c     |  351 +++++++++++++-------------
 drivers/scsi/bfa/bfa_fcpim.h     |   18 +-
 drivers/scsi/bfa/bfa_fcs.c       |  335 ++++++--------------------
 drivers/scsi/bfa/bfa_fcs.h       |   43 ++--
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   34 ++--
 drivers/scsi/bfa/bfa_fcs_lport.c |  468 +++++++++++++++--------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |  198 ++++++++--------
 drivers/scsi/bfa/bfa_hw_cb.c     |   16 +-
 drivers/scsi/bfa/bfa_hw_ct.c     |   22 +-
 drivers/scsi/bfa/bfa_ioc.c       |  397 +++++++++++++++---------------
 drivers/scsi/bfa/bfa_ioc.h       |  108 ++++----
 drivers/scsi/bfa/bfa_ioc_cb.c    |   90 ++++----
 drivers/scsi/bfa/bfa_ioc_ct.c    |  167 ++++++-------
 drivers/scsi/bfa/bfa_modules.h   |    6 +-
 drivers/scsi/bfa/bfa_os_inc.h    |   82 +------
 drivers/scsi/bfa/bfa_port.c      |   40 ++--
 drivers/scsi/bfa/bfa_svc.c       |  504 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfa_svc.h       |   41 ++--
 drivers/scsi/bfa/bfad.c          |   73 ++-----
 drivers/scsi/bfa/bfad_attr.c     |   38 ++--
 drivers/scsi/bfa/bfad_debugfs.c  |    4 +-
 drivers/scsi/bfa/bfad_drv.h      |    5 +-
 drivers/scsi/bfa/bfad_im.c       |   71 +++---
 drivers/scsi/bfa/bfi.h           |   58 +++---
 drivers/scsi/bfa/bfi_ms.h        |   50 ++--
 35 files changed, 1755 insertions(+), 2152 deletions(-)

