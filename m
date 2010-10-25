From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH 2/2] libfc: fix mem leak in fc_tm_done()
Date: Mon, 25 Oct 2010 20:42:27 +0800
Message-ID: <AANLkTinS_uKvO2tQzgSOya8_UxvPawYkr+-1n8gg1cK1@mail.gmail.com>
References: <AANLkTinAOy9+WPuKGro09Cu=xiLF+QMQ+JkioHNZao9n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56920 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0JYMm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 08:42:28 -0400
Received: by wwe15 with SMTP id 15so3441477wwe.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 05:42:27 -0700 (PDT)
In-Reply-To: <AANLkTinAOy9+WPuKGro09Cu=xiLF+QMQ+JkioHNZao9n@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems fc_fcp_unlock_pkt should be issued against mem leak.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_fcp.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-10-25 20:32:18.000000000 +0800
@@ -1293,7 +1293,7 @@ static void fc_tm_done(struct fc_seq *se
 	 * raced with eh timeout handler.
 	 */
 	if (!fsp->seq_ptr || !fsp->wait_for_comp) {
-		spin_unlock_bh(&fsp->scsi_pkt_lock);
+		fc_fcp_unlock_pkt(fsp);
 		return;
 	}
