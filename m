From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] scsi: fix computation of the full size of the device
Date: Tue, 14 Oct 2008 11:34:20 -0700
Message-ID: <1224009261-31247-1-git-send-email-hpa@zytor.com>
References: <48F4DF3E.2050903@zytor.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:37616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYJNSeY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 14:34:24 -0400
In-Reply-To: <48F4DF3E.2050903@zytor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hpa@zytor.com

When computing the full size of the device, we need to cast
sdkp->capacity before shifting, since in some configurations sector_t
can be a 32-bit number.

Also, change ffz(~x) to the more idiomatic ilog2(x).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a7b53be..151fc68 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1438,7 +1438,7 @@ got_data:
 
 	{
 		char cap_str_2[10], cap_str_10[10];
-		u64 sz = sdkp->capacity << ffz(~sector_size);
+		u64 sz = (u64)sdkp->capacity << ilog2(sector_size);
 
 		string_get_size(sz, STRING_UNITS_2, cap_str_2,
 				sizeof(cap_str_2));
-- 
1.6.0.2

