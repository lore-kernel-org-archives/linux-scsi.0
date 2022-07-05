Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1845C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 15:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiGEPcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 11:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiGEPc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 11:32:29 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9D471A395;
        Tue,  5 Jul 2022 08:32:28 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5104920DDCA4;
        Tue,  5 Jul 2022 08:32:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5104920DDCA4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1657035148;
        bh=kRnoCHsq+1Sa5DgsBfsbWeS+ACKGf2Fi6AFtFXIBaLs=;
        h=From:To:Subject:Date:From;
        b=pcGtDY6o/ZdZZ4/bmKzzdbHbBafbP4CgJR90LqZKqx4RuMS2A1BcxwKiK2nK41nO9
         4IuBGt62IZmb8PpN6GSAdfdSmbRB5ABIqHX6mHjfMceWDJpPvEnlXpfIsMLXFxDuMZ
         5kDXz9G1EsmuIVEeAzfhaLt4FV/Fe84GxJfxmp9I=
From:   Saurabh Sengar <ssengar@linux.microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-hyperv@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ssengar@microsoft.com, mikelley@microsoft.com
Subject: [PATCH] scsi: storvsc: Prevent running tasklet for long
Date:   Tue,  5 Jul 2022 08:32:21 -0700
Message-Id: <1657035141-2132-1-git-send-email-ssengar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There can be scenarios where packets in ring buffer are continuously
getting queued from upper layer and dequeued from storvsc interrupt
handler, such scenarios can hold the foreach_vmbus_pkt loop (which is
executing as a tasklet) for a long duration. Theoretically its possible
that this loop executes forever. Add a condition to limit execution of
this tasklet for finite amount of time to avoid such hazardous scenarios.

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fe000da..0c428cb 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -60,6 +60,9 @@
 #define VMSTOR_PROTO_VERSION_WIN8_1	VMSTOR_PROTO_VERSION(6, 0)
 #define VMSTOR_PROTO_VERSION_WIN10	VMSTOR_PROTO_VERSION(6, 2)
 
+/* channel callback timeout in ms */
+#define CALLBACK_TIMEOUT		5
+
 /*  Packet structure describing virtual storage requests. */
 enum vstor_packet_operation {
 	VSTOR_OPERATION_COMPLETE_IO		= 1,
@@ -1204,6 +1207,7 @@ static void storvsc_on_channel_callback(void *context)
 	struct hv_device *device;
 	struct storvsc_device *stor_device;
 	struct Scsi_Host *shost;
+	unsigned long expire = jiffies + msecs_to_jiffies(CALLBACK_TIMEOUT);
 
 	if (channel->primary_channel != NULL)
 		device = channel->primary_channel->device_obj;
@@ -1224,6 +1228,9 @@ static void storvsc_on_channel_callback(void *context)
 		u32 minlen = rqst_id ? sizeof(struct vstor_packet) :
 			sizeof(enum vstor_packet_operation);
 
+		if (time_after(jiffies, expire))
+			break;
+
 		if (pktlen < minlen) {
 			dev_err(&device->device,
 				"Invalid pkt: id=%llu, len=%u, minlen=%u\n",
-- 
1.8.3.1

