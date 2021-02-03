Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77252C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 11:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D81164DD4
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 11:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhBCLPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:15:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234047AbhBCLPr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 06:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612350861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oy4LdHHhpcx8PkVqXHlcQAPSxvy9bZPhze5Lo5BjGU4=;
        b=Ft0GBJJzDkIi54nnsWV4sE0gurqm+YgHoWSSB+HY29YT8EXGagMM947wffdrqMDpddz1Jf
        e5KAQb6r6qjo+ObCBSsXs/l8mIwOuGXnLn9BujhbQRiEvuNS7MLVTC5n3mQsqeNUDUPMKW
        QbXfktq0BlMRLsNXLOvscdIkahxi2zM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-fHbtCcwgNbitdbPL1jypsg-1; Wed, 03 Feb 2021 06:14:18 -0500
X-MC-Unique: fHbtCcwgNbitdbPL1jypsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AA47DF8A7;
        Wed,  3 Feb 2021 11:14:16 +0000 (UTC)
Received: from T590 (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1ECC93828;
        Wed,  3 Feb 2021 11:14:07 +0000 (UTC)
Date:   Wed, 3 Feb 2021 19:14:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V7 00/13] blk-mq/scsi: tracking device queue depth via
 sbitmap
Message-ID: <20210203111402.GA1065845@T590>
References: <20210122023317.687987-1-ming.lei@redhat.com>
 <yq1a6sr1v87.fsf@ca-mkp.ca.oracle.com>
 <20210131115245.GA1979183@T590>
 <yq1im7bwiif.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1im7bwiif.fsf@ca-mkp.ca.oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Mon, Feb 01, 2021 at 05:33:52PM -0500, Martin K. Petersen wrote:
> 
> Ming,
> 
> > BTW, which tree are you based for applying this patchset?
> 
> 5.12/scsi-queue
> 
> > I apply the patchset against for-5.12/block, and run it on kvm with
> > 'megasas' device(LSI MegaRAID SAS 1078), looks it works well, and not
> > see the hang issue.
> 
> I tried with for-5.12/block and it still breaks for me. Things work fine
> up until:
> 
> scsi: core: Replace sdev->device_busy with sbitmap
> 
> After that patch is applied no disks are discovered on my SAS/FC hosts.

I think the following patch should fix the issue, care to give a test?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d9171e05b58..65807cac6228 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1266,7 +1266,10 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 
 	token = sbitmap_get(&sdev->budget_map);
 	if (atomic_read(&sdev->device_blocked)) {
-		if (token >= 0)
+		if (token < 0)
+			goto out;
+
+		if (scsi_device_busy(sdev) > 1)
 			goto out_dec;
 
 		/*
@@ -1282,6 +1285,7 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 out_dec:
 	if (token >= 0)
 		sbitmap_put(&sdev->budget_map, token);
+out:
 	return -1;
 }
 

-- 
Ming

