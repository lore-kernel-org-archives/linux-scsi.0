From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] [TCM]: SPC-3 defined compatible reservation handling (CRH=1)
Date: Mon,  8 Mar 2010 11:50:53 -0800
Message-ID: <1268077853-19711-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:33623 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755086Ab0CHTu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 14:50:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings SCSI folks

This patch series adds proper support for >= SPC-3 defined compatible reservation handling (CRH=1)
within lio-core-2.6.git/drivers/target/target_core_pr.c.  It also adds the necessary checks to handle
when >= SPC-3 PR and legacy SPC-2 reservation logic is intermixed and RESERVATION_CONFLICT status
should be returned.

The patch logic is following spc4r17 for CRH=1 and spc2r20 for PR <-> Legacy Reservation interaction,
but it would be great if any other SCSI folks would have a look and verify.

Also, in order to test the >= SPC-3 PR + legacy SPC-2 intermixed RESERVATION_CONFLICT cases, I ended up
adding simple legacy RESERVE/RELEASE support to sg_persist.

Doug, would you be willing to accept a patch so that sg3_utils can have this test case..?

Best,

--nab

Nicholas Bellinger (3):
  [TCM/PR]: Add support for compatible reservation handling (CRH=1)
  [TCM]: Make legacy RESERVE_* and RELEASE_* use
    se_cmd_t->transport_emulate_cdb()
  [TCM]: Release legacy SPC-2 reservation during TMR LUN_RESET

 drivers/target/target_core_pr.c        |  176 +++++++++++++++++++++++--------
 drivers/target/target_core_tmr.c       |   12 ++
 drivers/target/target_core_transport.c |   25 +++--
 include/target/target_core_base.h      |    2 -
 include/target/target_core_pr.h        |    1 +
 5 files changed, 158 insertions(+), 58 deletions(-)

