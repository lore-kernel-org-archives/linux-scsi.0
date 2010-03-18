From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 10/12] mptfusion: Event data alignment with 4 byte.
Date: Thu, 18 Mar 2010 19:24:20 +0530
Message-ID: <20100318135409.GK22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:50756 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab0CROZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:25:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

event_data needs to be 4 byte aligned to makes sure there is no unaligned
memory access take place.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index 953c2bf..7b249ed 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -110,7 +110,7 @@ struct fw_event_work {
 	MPT_ADAPTER	*ioc;
 	u32			event;
 	u8			retries;
-	u8			event_data[1];
+	u8			__attribute__((aligned(4))) event_data[1];
 };
 
 struct mptsas_discovery_event {
