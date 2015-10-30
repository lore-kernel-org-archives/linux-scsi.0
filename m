From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH] sd: Clear PS bit before Mode Select.
Date: Fri, 30 Oct 2015 16:04:43 -0200
Message-ID: <1446228283-32627-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:45505 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149AbbJ3SEy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 14:04:54 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 16:04:50 -0200
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id A333D352007F
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 14:03:37 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UI5Hpo4915264
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 16:05:17 -0200
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UI4kim022166
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 16:04:47 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, JBottomley@odin.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

According to SPC-4, in a Mode Select, the PS bit in Mode Pages is
reserved and must be set to 0 by the driver.  In the sd implementation,
function cache_type_store does a Mode Sense, which might set the PS bit
on the read buffer, followed by a Mode Select, which receives the same
buffer, without explicitly clearing the PS bit.  So, in cases where
target supports saving the Mode Page to a non-volatile location, we end
up doing a Mode Select with the PS bit set, which could cause an illegal
request error if the target is checking this.

This was observed on a new firmware change, which was subsequently
reverted, but this changes sd.c to be more compliant with SPC-4.

This patch clears the PS bit in the buffer returned by Mode Select,
right before it is used in the Mode Select command.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f37022..f724777 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -204,6 +204,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	buffer_data[2] &= ~0x05;
 	buffer_data[2] |= wce << 2 | rcd;
 	sp = buffer_data[0] & 0x80 ? 1 : 0;
+	buffer_data[0] &= ~0x80;
 
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
 			     SD_MAX_RETRIES, &data, &sshdr)) {
-- 
2.1.0

