From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
Date: Sun,  6 Jun 2010 20:50:15 -0700
Message-ID: <1275882615-5354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greeting STGT folks,

This is the third round of patches for adding proper LUN passthrough support into STGT
using struct scsi_lu->cmd_perform() and struct scsi_lu->cmd_done() callers with existing
SG_IO and the new BSG v4 backstores.

Following Tomo-san's input, the changelog between v2 -> v3 is as follows:

1) Add struct device_type_template sg_template for SG_IO and BSG in usr/bs_sg.c instead
   of making changes to usr/sbc.c

2) Add struct backingstore_template->bs_passthrough member of type int for SG_IO and BSG.

3) In usr/target.c:tgt_device_create() pass bst->bs_passthrough into device_type_lookup()
   and for passthrough case use the new device_type_passthrough() to locate
   struct device_type_template sg_template.

4) Remove unnecessary post_cmd_done() from usr/target.c:__cmd_done_passthrough()

This patch series has been tested with STGT/iSCSI using 'sg'+'bsg' and 'rdwr' for non
passthrough mode backstores into TCM_Loop LLD emulated iSCSI target ports.

Best,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org

Nicholas Bellinger (3):
  [tgt]: Add proper STGT LUN backstore passthrough support (rev 3)
  [tgt]: Add bs_sg struct device_type_template sg_template and struct
    backingstore_template->bs_init()
  [tgt]: Add BSG v4 backstore support to usr/bs_sg.c

 usr/bs_sg.c     |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 usr/scsi_cmnd.h |    7 ++
 usr/target.c    |  113 +++++++++++++++++++++++---
 usr/tgtd.h      |   16 ++++
 4 files changed, 362 insertions(+), 21 deletions(-)
