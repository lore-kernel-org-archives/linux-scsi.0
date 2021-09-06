Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EFFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 15:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96ABB60F6E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 15:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbhIFPTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 11:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243120AbhIFPTT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 11:19:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630941494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CZleRDKrUpzSsDU4fREJDddYFjBD7XjhXgtX80VA+J8=;
        b=DTCohil2LvstnmTehw1eKfJkozmkWE2fcAiah0JeStlCNegTLHB4RKIuxIzXDp24PPRK02
        5glUYT8jXXGP34H/+km9o/gkkZ2pLjtEY1ZG15ZDm9PPQyk7BCVhP2nvtHqFOJ+bN4QOjo
        sTUBz1YevysIifdBqJKoly7JoGPQMiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-URvw4wVQM3ey6klIHN6SIg-1; Mon, 06 Sep 2021 11:18:12 -0400
X-MC-Unique: URvw4wVQM3ey6klIHN6SIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6CA7107ACE3;
        Mon,  6 Sep 2021 15:18:11 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.40.193.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 346766A902;
        Mon,  6 Sep 2021 15:18:10 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     bostroesser@gmail.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH V2] target: fix the pgr/alua_support_store functions
Date:   Mon,  6 Sep 2021 17:18:09 +0200
Message-Id: <20210906151809.52811-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and
alua_support attributes writable")
introduced support for changeable alua_support and pgr_support
target attributes. They can only be changed
if the backstore is user-backed, otherwise the kernel returns -EINVAL.

This triggers a warning in the targetcli/rtslib code when performing
a target restore that includes non-userbacked backstores:

#targetctl restore
Storage Object block/storage1: Cannot set attribute alua_support:
[Errno 22] Invalid argument, skipped
Storage Object block/storage1: Cannot set attribute pgr_support:
[Errno 22] Invalid argument, skipped

Fix this warning by returning an error code only if we are really
going to flip the PGR/ALUA bit in the transport_flags field,
otherwise we'll do nothing and return success.

Return ENOSYS instead of EINVAL if the pgr/alua attributes
can't be changed, this way it'll be possible for userspace to understand
if the operation failed because an invalid value has been passed
to strtobool() or because the attributes are fixed.

Fixes: 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and alua_support attributes writable")

v2: replace EOPNOTSUPP with ENOSYS

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_configfs.c | 32 +++++++++++++++++----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 102ec644bc8a..023bd4516a68 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1110,20 +1110,24 @@ static ssize_t alua_support_store(struct config_item *item,
 {
 	struct se_dev_attrib *da = to_attrib(item);
 	struct se_device *dev = da->da_dev;
-	bool flag;
+	bool flag, oldflag;
 	int ret;
 
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	oldflag = !(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA);
+	if (flag == oldflag)
+		return count;
+
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_ALUA)) {
 		pr_err("dev[%p]: Unable to change SE Device alua_support:"
 			" alua_support has fixed value\n", dev);
-		return -EINVAL;
+		return -ENOSYS;
 	}
 
-	ret = strtobool(page, &flag);
-	if (ret < 0)
-		return ret;
-
 	if (flag)
 		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_ALUA;
 	else
@@ -1145,20 +1149,24 @@ static ssize_t pgr_support_store(struct config_item *item,
 {
 	struct se_dev_attrib *da = to_attrib(item);
 	struct se_device *dev = da->da_dev;
-	bool flag;
+	bool flag, oldflag;
 	int ret;
 
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	oldflag = !(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR);
+	if (flag == oldflag)
+		return count;
+
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
 		pr_err("dev[%p]: Unable to change SE Device pgr_support:"
 			" pgr_support has fixed value\n", dev);
-		return -EINVAL;
+		return -ENOSYS;
 	}
 
-	ret = strtobool(page, &flag);
-	if (ret < 0)
-		return ret;
-
 	if (flag)
 		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_PGR;
 	else
-- 
2.27.0

