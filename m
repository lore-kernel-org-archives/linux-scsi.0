Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556F1C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 19:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13CDF20842
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 19:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdzJi/1q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHET3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 15:29:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728555AbgHERKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 13:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XBRZHl7JCJFhcfupZL8iAhY/apUMRtB5oC1LWGAgU4A=;
        b=BdzJi/1qxsjYplX9UHJnssT/2ipPnfKLyXNtuqAX0EdvC5yBvGeOWH0tkFtWUfQZRVCCP7
        t4glj4Ud13UVyITwsXvJLny6e170e6e9PebDU5jGr+Qi+T1Y/H0X2Zm0Ty6w90ouiGlr+H
        UgNupPu+ZtSu7YxmEUkQp5NZPSsBQx0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-BLY19M1LO4-lPDkv-Pp1VQ-1; Wed, 05 Aug 2020 09:44:03 -0400
X-MC-Unique: BLY19M1LO4-lPDkv-Pp1VQ-1
Received: by mail-wm1-f71.google.com with SMTP id z10so2725745wmi.8
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 06:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XBRZHl7JCJFhcfupZL8iAhY/apUMRtB5oC1LWGAgU4A=;
        b=WzKCKukKVA0qwL/sCxuBg41e9ndgVU1kLaW4b2w9PQjVhYxSa8LxdVD/K2TQ/1t3xa
         X0AUh+bieYsn8HsOhEhARClUmB6cboUVCRiEFLYDBMyQMhCIy4cAPSNFfTa6OaLT14HZ
         BLPwp1m1PfsesceiQXznZbJ+ysmPsRL4QQMUWJXecGOz/fs2CVXD6wzpSdeQgI3j+o7k
         ANEY5IeR2+6ugJbD9/v6B2mfhsd1lqhf6eaZ/8iJj2hC3AZRD3YFVGDrdxuI7aPNeQAx
         zJG04BZqLlOrt+hnBq2Fuxw5GyWjAAgV1Q5wUDWjqUDWIzkQePhJEJQJTC6skKLJS3dh
         X+LA==
X-Gm-Message-State: AOAM532AxB7fugUP2/Ntq3xFZQOHJTX+LqINxtrDr9ryB6Nt4R46HVsV
        tfNenfDhOQYYV7vuqGSVsvA1W7NxSFXqvtGwtY+s77npeB3sjhCtgYUQ5rVUA1UQZUQ+nfQ0YoW
        lqkBb9Rzrg1SWyGfqn4VuDg==
X-Received: by 2002:a7b:ca57:: with SMTP id m23mr3291805wml.35.1596635042169;
        Wed, 05 Aug 2020 06:44:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDiytpas+5HWe7CFND1zqnudLwtNEfOy8SdQ5eObOxwbDWWrns+xYAUPDW5UZJfGlbiTGXfw==
X-Received: by 2002:a7b:ca57:: with SMTP id m23mr3291789wml.35.1596635041995;
        Wed, 05 Aug 2020 06:44:01 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id x2sm3035450wrg.73.2020.08.05.06.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 06:44:01 -0700 (PDT)
Date:   Wed, 5 Aug 2020 09:43:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v3 16/38] virtio_scsi: correct tags for config space fields
Message-ID: <20200805134226.1106164-17-mst@redhat.com>
References: <20200805134226.1106164-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805134226.1106164-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tag config space fields as having virtio endian-ness.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/scsi/virtio_scsi.c       |  4 ++--
 include/uapi/linux/virtio_scsi.h | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0e0910c5b942..c36aeb9a1330 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -746,14 +746,14 @@ static struct scsi_host_template virtscsi_host_template = {
 
 #define virtscsi_config_get(vdev, fld) \
 	({ \
-		typeof(((struct virtio_scsi_config *)0)->fld) __val; \
+		__virtio_native_type(struct virtio_scsi_config, fld) __val; \
 		virtio_cread(vdev, struct virtio_scsi_config, fld, &__val); \
 		__val; \
 	})
 
 #define virtscsi_config_set(vdev, fld, val) \
 	do { \
-		typeof(((struct virtio_scsi_config *)0)->fld) __val = (val); \
+		__virtio_native_type(struct virtio_scsi_config, fld) __val = (val); \
 		virtio_cwrite(vdev, struct virtio_scsi_config, fld, &__val); \
 	} while(0)
 
diff --git a/include/uapi/linux/virtio_scsi.h b/include/uapi/linux/virtio_scsi.h
index cc18ef8825c0..0abaae4027c0 100644
--- a/include/uapi/linux/virtio_scsi.h
+++ b/include/uapi/linux/virtio_scsi.h
@@ -103,16 +103,16 @@ struct virtio_scsi_event {
 } __attribute__((packed));
 
 struct virtio_scsi_config {
-	__u32 num_queues;
-	__u32 seg_max;
-	__u32 max_sectors;
-	__u32 cmd_per_lun;
-	__u32 event_info_size;
-	__u32 sense_size;
-	__u32 cdb_size;
-	__u16 max_channel;
-	__u16 max_target;
-	__u32 max_lun;
+	__virtio32 num_queues;
+	__virtio32 seg_max;
+	__virtio32 max_sectors;
+	__virtio32 cmd_per_lun;
+	__virtio32 event_info_size;
+	__virtio32 sense_size;
+	__virtio32 cdb_size;
+	__virtio16 max_channel;
+	__virtio16 max_target;
+	__virtio32 max_lun;
 } __attribute__((packed));
 
 /* Feature Bits */
-- 
MST

