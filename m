From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 06/48] hpsa: adjust RAID-1, RAID-1ADM, and RAID-6 names
Date: Wed, 14 Jan 2015 16:00:05 -0600
Message-ID: <20150114220005.21325.17021.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55208 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbbANWAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:00:52 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id AAFEA4526
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:00:52 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
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

