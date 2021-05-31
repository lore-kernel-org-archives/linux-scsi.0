Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3B5C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77B9610C8
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhEaFJU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 01:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhEaFJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 01:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622437660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kov/nqrCmTdVB2xO79Lc70CEUlicI06NV3/G+aK6HIw=;
        b=GWwwjNhWeLZUuInMQz8dVwWea42k3wdV0gK8ooCDlF1OlKwnnHnjw52hcGZuzOxRp/qHl0
        oqYl5gk1Lg/PoR0MvA74xEN3jH48BTaPJCjUhjys4BkC03FVm9Unh7amK9IYDDzqJdYKYg
        qw4jrdEnWy8vCyqjQDHNA4pUMZJb+Yk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-RiNJuTZAN-C93KuGcILosg-1; Mon, 31 May 2021 01:07:38 -0400
X-MC-Unique: RiNJuTZAN-C93KuGcILosg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2DD0801B13;
        Mon, 31 May 2021 05:07:36 +0000 (UTC)
Received: from localhost (ovpn-12-235.pek2.redhat.com [10.72.12.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2E632C270;
        Mon, 31 May 2021 05:07:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V3 0/3] scsi: two fixes in scsi_add_host_with_dma
Date:   Mon, 31 May 2021 13:07:24 +0800
Message-Id: <20210531050727.2353973-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin,


Fix two memory leaks and one double free issue in alloc/add host
code path.


V3:
	- fix memory leak caused in scsi_host_alloc
	- comment typo suggested by John

V2:
	- add patch 2 for addressing shost leak in case of adding host
	  failure, reported by John Garry.

Ming Lei (3):
  scsi: core: use put_device() to release host
  scsi: core: fix failure handling of scsi_add_host_with_dma
  scsi: core: put ->shost_gendev.parent in failure handling path

 drivers/scsi/hosts.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>

-- 
2.29.2

