From: Michel Meyers <steltek@tcnnet.com>
Subject: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector
 blacklist
Date: Mon, 11 Apr 2016 10:43:36 +0200
Message-ID: <570B63B8.6080104@tcnnet.com>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smail.vo.lu ([80.90.45.96]:50113 "EHLO smail.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbcDKItN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2016 04:49:13 -0400
In-Reply-To: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

From: Michel Meyers <steltek@tcnnet.com>

SYNOLOGY iSCSI devices do not work with large I/O and SYNOLOGY changed
the identifier of the devices starting with version 6.0 of their OS
("DSM"). (The large I/O problem persists in that release.)

This patch adds the new identifier to the 1024 sector blacklist, the old
one having been added in commit 9055082fb100cc66e20c048251d05159f5f2cfba
"scsi: add Synology to 1024 sector blacklist".

Reported-by: Michel Meyers <steltek@tcnnet.com>
Signed-off-by: Michel Meyers <steltek@tcnnet.com>

---

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 3408578..46b5e2e 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -232,6 +232,7 @@ static struct {
        {"Promise", "", NULL, BLIST_SPARSELUN},
        {"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
        {"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
+       {"SYNOLOGY", "IBLOCK", NULL, BLIST_MAX_1024},
        {"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
        {"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
        {"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},


