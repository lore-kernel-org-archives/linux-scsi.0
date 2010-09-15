From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] tcm/tcm_loop: Add BIDI support and XDWRITE_READ_10 emulation
Date: Wed, 15 Sep 2010 05:06:34 -0700
Message-ID: <1284552394-30525-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.207]:38606 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752560Ab0IOMGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 08:06:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Boaz, Tomo-san and Co,

This series adds initial support for functional bidirectional CDBs into TCM_Core
and the TCM_Loop fabric module.  So far this is limited to XDWRITE_READ_10 emulation
following scsi_debug.c, but everything appears to now be functioning as expected.

This first patch adds support for BIDI operations and XDWRITE_READ_10 emulation
into TCM_Core for the individual I/O descriptor setup, memory mapping, callback
and release codepaths.

The second patch enables BIDI operations with the TCM_Loop Virtual SCSI LLD
fabric module using the updated callers.

So far this has been lightly tested on v2.6.36-rc3 HVM using custom userspace BSG
code to issue XDWRITE_READ_10 I/O into TCM_Loop LUNs using FILEIO backstores.
Support for BIDI CDBs will also extend to LIO-Target and other TCM fabric modules
in the near future.

Comments are welcome!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  tcm: Add support for BIDI operation and XDWRITE_READ_10 emulation
  tcm_loop: Add DMA_BIDIRECTIONAL CDB support

 drivers/target/target_core_transport.c         |  282 +++++++++++++++++++++---
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   48 +++-
 include/target/target_core_base.h              |    9 +-
 include/target/target_core_transport.h         |   10 +-
 4 files changed, 297 insertions(+), 52 deletions(-)

