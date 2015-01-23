From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 06/48] hpsa: adjust RAID-1, RAID-1ADM, and RAID-6 names
Date: Fri, 23 Jan 2015 16:41:35 -0600
Message-ID: <20150123224135.14919.90878.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34229 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbbAWWm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:29 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

HP now uses RAID-6 rather than RAID-ADG (Advanced Data Guarding)
as the marketing name for our implementation of RAID-6.

The driver considers RAID-1 and RAID-1+0 to be the same level, and
considers RAID-1ADM and RAID-1+0ADM to be the same level.  Parenthesis
can be used to reflect the optional +0 portion of both those RAID levels.

Rename: RAID-ADG to RAID-6
	RAID-1(1+0) to RAID-1(+0)
	RAID-1(ADM) to RAID-1(+0)ADM

Also, add another const after the pointer type as suggested
by checkpatch.pl so the array is:
	static const char * const raid_label[]

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7dfe829..4252b63 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -507,8 +507,8 @@ static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 	return (scsi3addr[3] & 0xC0) == 0x40;
 }
 
-static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
-	"1(ADM)", "UNKNOWN"
+static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
+	"1(+0)ADM", "UNKNOWN"
 };
 #define HPSA_RAID_0	0
 #define HPSA_RAID_4	1

