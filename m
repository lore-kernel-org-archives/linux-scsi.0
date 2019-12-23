Return-Path: <SRS0=rNN+=2N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB22C2D0D0
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Dec 2019 22:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00E552053B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Dec 2019 22:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8T4vGB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLWW4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 17:56:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727008AbfLWW4P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Dec 2019 17:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577141774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vefL+wod3IF0bm304mueY4QtPGsIHZR1kZjIDWRhJoA=;
        b=J8T4vGB3laak1GMUsSYraWjRqDcHYcVzlJsgrNd7gw7JFnEIrf+tbo1dy4qK02Pogc7IVq
        jo12Q/KM2RI9DpxSm8UiZJhIoJQBuF2NvsEWlJmIHUCxv54zoVZax5t+jixdgHnxNyr0r/
        gKZIqzCVuehW0HHmO780VyOvHwad0vI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-GdshT3QoN1GGMMTcbOwoxA-1; Mon, 23 Dec 2019 17:56:13 -0500
X-MC-Unique: GdshT3QoN1GGMMTcbOwoxA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15643801E74;
        Mon, 23 Dec 2019 22:56:12 +0000 (UTC)
Received: from sulaco.redhat.com (ovpn-112-13.rdu2.redhat.com [10.10.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2558260BE2;
        Mon, 23 Dec 2019 22:56:10 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC 9/9] __xfs_printk: Add durable name to output
Date:   Mon, 23 Dec 2019 16:55:58 -0600
Message-Id: <20191223225558.19242-10-tasleson@redhat.com>
In-Reply-To: <20191223225558.19242-1-tasleson@redhat.com>
References: <20191223225558.19242-1-tasleson@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add persistent durable name to xfs messages so we can
correlate them with other messages for the same block
device.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 fs/xfs/xfs_message.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..8447cdd985b4 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -20,6 +20,23 @@ __xfs_printk(
 	const struct xfs_mount	*mp,
 	struct va_format	*vaf)
 {
+	char dict[128];
+	int dict_len =3D 0;
+
+	if (mp && mp->m_super && mp->m_super->s_bdev &&
+		mp->m_super->s_bdev->bd_disk) {
+		dict_len =3D dev_durable_name(
+			disk_to_dev(mp->m_super->s_bdev->bd_disk)->parent,
+			dict,
+			sizeof(dict));
+		if (dict_len) {
+			printk_emit(
+				0, level[1] - '0', dict, dict_len,
+				"XFS (%s): %pV\n",  mp->m_fsname, vaf);
+			return;
+		}
+	}
+
 	if (mp && mp->m_fsname) {
 		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
 		return;
--=20
2.21.0

