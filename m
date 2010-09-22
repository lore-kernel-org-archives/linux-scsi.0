From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] scsi/scsi_debug: Add missing scsi.h defs and XDWRITEREAD_32 support
Date: Tue, 21 Sep 2010 22:50:40 -0700
Message-ID: <1285134640-7720-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.ne1.yahoo.com ([98.138.84.212]:31562 "HELO
	smtp101.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752326Ab0IVFuo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2010 01:50:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Doug and James,

Attached are two patches for Linux/SCSI that I ended up needing to allow the
simple XDWRITEREAD_32 passthrough into TCM/pSCSI -> struct request -> SCSI Midlayer
in recent lio-core-2.6.git/lio-4.0 commits.

The first adds some missing SPC-4 CDB and MAINTENANCE_[IN,OUT] +
VARIABLE_LENGTH_CMD service actions to include/scsi/scsi.h.  These
are used by TCM Core code and pieces of this patch have been posted
here for the RFC before:

http://marc.info/?l=linux-scsi&m=128316041105964&w=2

The second adds XDWRITEREAD_32 emulation to scsi_debug, which
is pretty quite simple because everything we need is already
handled by XDWRITEREAD_10.  8-)

This has been tested using 'sgv4_xdwriteread -e' with TCM_Loop ->
TCM/pSCSI -> scsi_debug 32-byte BIDI-COMMAND CDB passthrough on
v2.6.36-rc4.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  scsi: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] and
    VARIABLE_LENGTH_CMD service actions
  scsi_debug: Add XDWRITEREAD_32 support

 drivers/scsi/scsi_debug.c |    3 +++
 include/scsi/scsi.h       |   28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

-- 
1.7.3

