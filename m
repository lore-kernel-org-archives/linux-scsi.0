From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] scsi/libiscsi.c: return -errno rather than errno
Date: Tue, 27 May 2008 15:58:46 +0800
Message-ID: <483BBF36.80500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbYE0IAL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2008 04:00:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: michaelc@cs.wisc.edu, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

iscsi_prep_scsi_cmd_pdu() returns EIO in a failing path,
but returns -errno in other paths.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b43bf1d..d380f46 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -307,7 +307,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	hdr->hlength = hdrlength & 0xFF;
 
 	if (conn->session->tt->init_cmd_task(conn->ctask))
-		return EIO;
+		return -EIO;
 
 	conn->scsicmd_pdus_cnt++;
 	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x "
-- 1.5.4.rc3
