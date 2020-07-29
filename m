Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F04C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 19:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D132082E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 19:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfzi107G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgG2TsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 15:48:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22081 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbgG2TsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 15:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596052102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CgfetowmgmpIHlSMpqa8J/+66H7aoCSwd4gSByA73AQ=;
        b=hfzi107GV+6b+DwUeGTj/t25uvP7Tx9xFM6SpXvf6GKRfHFMYR0AmYtHI0sdtGHmCSHUMu
        vai1Okvl2eOMKu4oK22e2qWppwgguvgaOa6VFXjuJkXfHJcGUY3nIfWRbS71p9rfyRQ4sK
        RqC/I6EN/BdCDgQrSL5tegUuQQlxIpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-ykVM02ExOlS8Ew11TJ5Ddw-1; Wed, 29 Jul 2020 15:48:20 -0400
X-MC-Unique: ykVM02ExOlS8Ew11TJ5Ddw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40E478015CE;
        Wed, 29 Jul 2020 19:48:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 834385C6C0;
        Wed, 29 Jul 2020 19:48:16 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
        virtualization@lists.linux-foundation.org (open list:VIRTIO BLOCK AND
        SCSI DRIVERS), Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/1] scsi: virtio-scsi: handle correctly case when all LUNs were unplugged
Date:   Wed, 29 Jul 2020 22:48:06 +0300
Message-Id: <20200729194806.4933-2-mlevitsk@redhat.com>
In-Reply-To: <20200729194806.4933-1-mlevitsk@redhat.com>
References: <20200729194806.4933-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 5ff843721467 ("scsi: virtio_scsi: unplug LUNs when events missed"),
almost fixed the case of mass unpluging of LUNs, but it missed a
corner case in which all the LUNs are unplugged at the same time.

In this case INQUIRY ends with DID_BAD_TARGET.
Detect this and unplug the LUN.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0e0910c5b9424..c7f0c22b6f11d 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -351,6 +351,16 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 			/* PQ indicates the LUN is not attached */
 			scsi_remove_device(sdev);
 		}
+
+		else if (host_byte(result) == DID_BAD_TARGET) {
+			/*
+			 * if all LUNs of a virtio-scsi device are unplugged,
+			 * it will respond with BAD TARGET on any INQUIRY
+			 * command.
+			 * Remove the device in this case as well
+			 */
+			scsi_remove_device(sdev);
+		}
 	}
 
 	kfree(inq_result);
-- 
2.26.2

