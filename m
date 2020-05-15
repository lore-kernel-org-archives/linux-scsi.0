Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFB2C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 05:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9858320671
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 05:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="E0e/KOs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgEOFs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 01:48:58 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:6596 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgEOFs6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 01:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589521737; x=1621057737;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JVTNramJd6UH75hUXFVFnIsVmUtuiM9n3ix3ETvWTag=;
  b=E0e/KOs3dKbFu3OWNafL2SmheIVXib+3O17rMtAAenWWb3bU6p9ezCwz
   sinahZTbG7HypohXRxhgaoAD6pNZgDz3uvBgxaParj9bD7eILRdkRa933
   CduBTeZymkfEfhYL7ofbr4kSFgW4cNuJsrsENZy85n+q+i9ckm6I4AaYs
   m/pCSbiPafYO9Tj1s3DVEo0oFRXUwcnGjCFv87BtuKaFdzxDhTEeUaXiA
   GI2cnxsAolh1Zv50wlNikldTdKMYQKQMrgwdYfvFaFjoz0h+nwP65SFA5
   4GlO6ZjRd/QupCZ+1ZeOhfgBHpOdsFhL9ee3rZVqXjAJ6vmj2aNaMSUHi
   A==;
IronPort-SDR: XViGg/AzqQ57D9/qQOhTtSWeri3WJkXrptjN7FRFP7IVCZ6h8M6J43C6yOWP18xGYArGi9iIsU
 WdyuLLRTPnZBgeDTOUbGouECvlmx0c/Y1vg0PGC9B11KTbhMwb7/JSuRFnra4eBlRyD1Ltp6iw
 Mt/4dFvpylzVZ/CrVRTRigvl7Z6OK8uBOtBKPt/oC2msDww4U4o12r5PkdZ8F/9TKtHtUp9C0w
 Ja0JGJq+HPPSO5V+PiPJfQc+++35DUWdaXiMMFI/yT7YRPorB5sTkF5KNwPWWfFy3SP8aLCSfa
 RsY=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="246715753"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 13:48:56 +0800
IronPort-SDR: iURhljWZybNjH5O/TAZ6UEdgbV+u0LSYqyqo3D9El+7ewoSYtu9n5byphBV7AxF1bKXfhOzDdQ
 ddUIST9Z4aPMSYpjXCHamWKFYfvkyT6wk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 22:39:09 -0700
IronPort-SDR: 9O1WGvN+bqfjlberimYhFP5hmCEAJ5X8kNilfF+WyIEVu5ONeVOkLgVOYzYX4PtDAxW7Tg0MgP
 gHv208OXg0RQ==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 14 May 2020 22:48:57 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Add zoned capabilities device attribute
Date:   Fri, 15 May 2020 14:48:56 +0900
Message-Id: <20200515054856.1408575-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export through sysfs as a scsi_disk attribute the zoned capabilities of
a disk ("zoned_cap" attribute file). This new attribute indicates in
human readable form (i.e. a string) the zoned block capabilities
implemented by the disk as found in the ZONED field of the disk block
device characteristics VPD page. The possible values are:
- "none": ZONED=00b (not reported), regular disk
- "host-aware": ZONED=01b, host-aware ZBC disk
- "drive-managed": ZONED=10b, drive-managed ZBC disk (regular disk
  interface)

For completness, also add the following value which is detected using
the device type rather than the ZONED field:
- "host-managed": device type = 0x14 (TYPE_ZBC), host-managed ZBC disk

This new sysfs attribute is purely informational and complementary to
the "zoned" device request queue sysfs attribute as it allows
applications and user daemons (e.g.  udev) to easily differentiate
regular disks from drive-managed SMR disks without the need for direct
access tools such as provided by sg3utils.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8929e178c6f8..1bc2a061efa9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -528,6 +528,21 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(max_write_same_blocks);
 
+static ssize_t
+zoned_cap_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	if (sdkp->device->type == TYPE_ZBC)
+		return sprintf(buf, "host-managed\n");
+	if (sdkp->zoned == 1)
+		return sprintf(buf, "host-aware\n");
+	if (sdkp->zoned == 2)
+		return sprintf(buf, "drive-managed\n");
+	return sprintf(buf, "none\n");
+}
+static DEVICE_ATTR_RO(zoned_cap);
+
 static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_cache_type.attr,
 	&dev_attr_FUA.attr,
@@ -541,6 +556,7 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_zeroing_mode.attr,
 	&dev_attr_max_write_same_blocks.attr,
 	&dev_attr_max_medium_access_timeouts.attr,
+	&dev_attr_zoned_cap.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sd_disk);
-- 
2.25.4

