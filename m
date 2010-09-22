From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm/pscsi: Add support for BIDI-COMMAND passthrough
Date: Tue, 21 Sep 2010 23:08:34 -0700
Message-ID: <1285135714-8308-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.ne1.yahoo.com ([98.138.84.215]:30106 "HELO
	smtp104.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751338Ab0IVGIj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2010 02:08:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Boaz and Co,

This patch series adds proper support to TCM Core for XDWRITEREAD_32 and
XDWRITEREAD_10 to allow for TCM/pSCSI plugin -> SCSI ML via struct request.

This first patch adds the necessary pieces to TCM Core for handling the
transparent memory mapping using the new struct se_task->task_sg_bidi[],
and other necessary bits for the underlying per new se_task BIDI context
into TCM/pSCSI.

The second patch adds support in TCM/pSCSI plugin code to handle the
extra struct request allocation, setup and release for the additional
BIDI SCSI READ SCSI READ payload going into struct se_task->task_sg_bidi[]
memory.

And the third patch adds the same passthrough option as above with TCM/pSCSI
for XDWRITEREAD_10 CDBs in TCM Core.

So far this has been tested with TCM_Loop -> TCM_core -> TCM/pSCSI ->
scsi_debug on v2.6.36-rc4 in x86 HVM.

Many thanks to Boaz for his comments with BIDI-COMMANDs and > 16 byte CDBs!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Add support for BIDI-COMMAND passthrough
  tcm/pscsi: Add proper BIDI-COMMAND passthrough to SCSI MidLayer
  tcm: Add XDWRITEREAD_10 passthrough support

 drivers/target/target_core_pscsi.c     |  111 ++++++++++++++++++++++++-------
 drivers/target/target_core_pscsi.h     |    1 +
 drivers/target/target_core_transport.c |  112 ++++++++++++++++++++++++++++----
 include/target/target_core_base.h      |    1 +
 4 files changed, 185 insertions(+), 40 deletions(-)

