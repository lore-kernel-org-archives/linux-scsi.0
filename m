Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA2E329395
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601418; cv=none; b=gOWsrUBKzHb0rqunxRrxx9LBV7vApVQl2tWZx27/MN4Mft0DDV6spmR1117JAQCFlCaxcfhP3sb0nPw/qgnoCAzXNMboxataitsLethgmRkzH5+TABRIyZXtaiCMeqi3Qrvx/6TWV9pcakqdjfVCPCtaLso3VwlZ6NyLt8XE1nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601418; c=relaxed/simple;
	bh=S9cU9rMSKLAHqC3C9VUi030/VnGNztyhDP4UPj+0Vaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnAfe0MA4aiB/Du08m4v7UvNSuyMbUUUn+9d59OAppoiCDFrxSLO8s/IUitU4R5lsrun+zm3SkOhDH0HEr5CcvLjM7/x5xQ+K2BHCz2EX06lUcnCIuqXr0bEd/k5LjQvnx0HR/BjjKbRzTzaWg9vFbf02YK41mQIohZTWVDUJHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DObQ1Wju; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=J5VSpuzC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DObQ1Wju";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5VSpuzC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TvLvTQPEJKAtkqGovGo2GHeF0+EOLKvEuwFpv+PiquM=;
	b=DObQ1WjuRpWScNuAi70c6Z3ZI7/IJ6pT2ZpVxF3/1L61WkR06wT1jZm/Gqxd7H+oKYbLNX
	OA65CF2Vm33IyQKdUPGB7kbjn3c7f3yB7w4gU1Y0PGrJxnL72+8bMin9bLRtuiGjYPf09j
	SQP1SEuKoIw7EFLI1a/9i3QfoFU5eKA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-O2aCHR0yOIKvs2Lns0XaRQ-1; Mon, 05 Jan 2026 03:23:34 -0500
X-MC-Unique: O2aCHR0yOIKvs2Lns0XaRQ-1
X-Mimecast-MFC-AGG-ID: O2aCHR0yOIKvs2Lns0XaRQ_1767601414
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-430f57cd2caso12513517f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601413; x=1768206213; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TvLvTQPEJKAtkqGovGo2GHeF0+EOLKvEuwFpv+PiquM=;
        b=J5VSpuzCfEHaaV0PfngwJ/PAHynoUlG+tVufyQ1It+kh+BWnkL/pDXkLquPvP8PhaE
         RTkkg+5x8fqgihaCUpJZpFJAgqYL8ICnp+FRHSEDIQLIBoTaVdSxtFHlzGdXIjRLvKiI
         LOw9l3ILo5anD1bPQovJIXG3YH8o2P0bPOoK0hsSplrw49jxfi5FpRHrZHiCVfRMNwBi
         bhgwMNhrGDrYP7Q37rAK8EfOwEfopGXHftivLnRz67hPRVFHp/LlhvCihl50f1fsorSk
         rbPD/iAw1E//M4PMcKsOljyg/HT+Z+5LJXzBzFwgUXasV50sdG6MMsj8Yz+vjiVysoUX
         D6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601413; x=1768206213;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvLvTQPEJKAtkqGovGo2GHeF0+EOLKvEuwFpv+PiquM=;
        b=f93/cF+bX2mqwme1/cd2g0Ig1sxLL/QF/rpNPUSHqPuDVHKH9juHIhZEQLKUyKWPpJ
         eGVi1QAGadJeIjRnPay/R4Y6AbHg7/u6JwjhizpSELJfic2Kf/saUpuMROMOC6UPtlHk
         5vQQ2kDxSflbsYJUMu6dt/ImsXyjoiepu8dmzNySNCRlEXxrDHXSMOhO9To5hIaphyw4
         snwC1Tf96wrCpRlq5zxPXUzGExyoyRBSrlTA/HIIWo6hwGvapWnxoffJUWqdLAmM6XcB
         aNo+GQB1sXoqz4OZfl/n2vZAmPjeL3iEvZXk5iT6wruSdWrsG87X238qua3g2UGq3XjP
         PvDg==
X-Forwarded-Encrypted: i=1; AJvYcCVSsYlGDI8jQ9qooL0v7xqjaAcZERAjExQQLgYR0BWDjEsjNbHOGxqVxQLTkqkoanwJYSMrG9qTyEnO@vger.kernel.org
X-Gm-Message-State: AOJu0YxUw3ZAe4skKfMZO9H5W22Zx9RTIXFsoKyyMvOwbedNVZA9nHs8
	cKlEI2ijWgDzq9FvrGEpIRqNS7rjko4pR9hmNsZm0TX95VrwWZuPX2y3ajv1Z/sS3HCPIhZPGQv
	778As1+pbbU0lx/W57jkrmr760g0QcRj65aJNfCmNNmmfVdjQz4E9eEbVxQY1YOM=
X-Gm-Gg: AY/fxX6qHxvQjotHbbT9hwyy0MbD0jM8Jlc2la5TuKRjST435iiARkR/k9Ztbv5+T1R
	zRZwSMpjGFz2s6anlZVDw7HYUBVIQT8+INJuqCUbAVbkd57JrOqngnBbeCqOzwbMNAtwAVMT3vu
	bsOIqFiZfgjEsH06uEa8G29cinTMUcWCANeqLvwlkupFeq+JDHuRnO808nFGa61UU+dRA0mCGHa
	xS6W4PC6a8nWyfX3/xDkb8UfrhbCNVnIb9qvnGpAul0CALgFTk1HUVOuHprPaKbhkKazV4U7398
	bg1+kChoxw5Gu0Oqr9RiAT34ttwWFoM6WGA+m17IhQCVieC/mBgEuGdDGSEApGrS4BnuD6NfOcG
	SA9KL6QCWVMZZ3IE/ZzHAtQx+tNXZZNm1HQ==
X-Received: by 2002:adf:eb04:0:b0:432:84ef:841f with SMTP id ffacd0b85a97d-43284ef8d0cmr31362901f8f.38.1767601413471;
        Mon, 05 Jan 2026 00:23:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFx7eWbROO38mdjmsXsZ8eTRhzoo1KnfbPFeP9XiXzVU5+PKMGQRYrz1a7izR0YG2kvu7gW1Q==
X-Received: by 2002:adf:eb04:0:b0:432:84ef:841f with SMTP id ffacd0b85a97d-43284ef8d0cmr31362856f8f.38.1767601412963;
        Mon, 05 Jan 2026 00:23:32 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa2beasm98160481f8f.33.2026.01.05.00.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:32 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:29 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 10/15] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Current struct virtio_scsi_event_node layout has two problems:

The event (DMA_FROM_DEVICE) and work (CPU-written via
INIT_WORK/queue_work) fields share a cacheline.
On non-cache-coherent platforms, CPU writes to work can
corrupt device-written event data.

If ARCH_DMA_MINALIGN is large enough, the 8 events in event_list share
cachelines, triggering CONFIG_DMA_API_DEBUG warnings.

Fix the corruption by moving event buffers to a separate array and
aligning using __dma_from_device_group_begin()/end().

Suppress the (now spurious) DMA debug warnings using
virtqueue_add_inbuf_cache_clean().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 96a69edddbe5..6ff53fc8adb0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -29,6 +29,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_devinfo.h>
 #include <linux/seqlock.h>
+#include <linux/dma-mapping.h>
 
 #include "sd.h"
 
@@ -61,7 +62,7 @@ struct virtio_scsi_cmd {
 
 struct virtio_scsi_event_node {
 	struct virtio_scsi *vscsi;
-	struct virtio_scsi_event event;
+	struct virtio_scsi_event *event;
 	struct work_struct work;
 };
 
@@ -89,6 +90,11 @@ struct virtio_scsi {
 
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
+
+	__dma_from_device_group_begin();
+	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
+	__dma_from_device_group_end();
+
 	struct virtio_scsi_vq req_vqs[];
 };
 
@@ -237,12 +243,12 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	unsigned long flags;
 
 	INIT_WORK(&event_node->work, virtscsi_handle_event);
-	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
+	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 
-	err = virtqueue_add_inbuf(vscsi->event_vq.vq, &sg, 1, event_node,
-				  GFP_ATOMIC);
+	err = virtqueue_add_inbuf_cache_clean(vscsi->event_vq.vq, &sg, 1, event_node,
+					      GFP_ATOMIC);
 	if (!err)
 		virtqueue_kick(vscsi->event_vq.vq);
 
@@ -257,6 +263,7 @@ static int virtscsi_kick_event_all(struct virtio_scsi *vscsi)
 
 	for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++) {
 		vscsi->event_list[i].vscsi = vscsi;
+		vscsi->event_list[i].event = &vscsi->events[i];
 		virtscsi_kick_event(vscsi, &vscsi->event_list[i]);
 	}
 
@@ -380,7 +387,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 	struct virtio_scsi_event_node *event_node =
 		container_of(work, struct virtio_scsi_event_node, work);
 	struct virtio_scsi *vscsi = event_node->vscsi;
-	struct virtio_scsi_event *event = &event_node->event;
+	struct virtio_scsi_event *event = event_node->event;
 
 	if (event->event &
 	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
-- 
MST

