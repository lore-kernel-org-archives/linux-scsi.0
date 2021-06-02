Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D57FC4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66058613D6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhFBNc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:32:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhFBNc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 09:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622640642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P7COfmJbanOYtxmL7dgrBviZjSAZNluVHODA4Ep/EEY=;
        b=XgMJL77jV7Uk7SgHxTQTlCqrXBCGMIXOQMkF7qYW92Ovs54xxI/Cd3OJhApuR/j+hIlyIL
        /IUM28tKZ5BmmPSNw4UrI2aytlQ03TCvtkCIWatTCUDayg8Uue+DcVubyfJA25pYwfDZ1v
        LNK/N2mabRNIm1rgYcISS7p7Cztx8Kk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-bHj-CbY3PjWMzxx6ewTEdQ-1; Wed, 02 Jun 2021 09:30:39 -0400
X-MC-Unique: bHj-CbY3PjWMzxx6ewTEdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B4D3107ACF7;
        Wed,  2 Jun 2021 13:30:38 +0000 (UTC)
Received: from localhost (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 158485D9DE;
        Wed,  2 Jun 2021 13:30:33 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] scsi: fix failure handling of alloc/add host
Date:   Wed,  2 Jun 2021 21:30:25 +0800
Message-Id: <20210602133029.2864069-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin,

Fix failure handling of alloc/add host code, and related device release
handling.


Ming Lei (4):
  scsi: core: fix error handling of scsi_host_alloc
  scsi: core: fix failure handling of scsi_add_host_with_dma
  scsi: core: put .shost_dev in failure path if host state becomes
    running
  scsi: core: only put parent device if host state isn't in
    SHOST_CREATED

 drivers/scsi/hosts.c | 47 ++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>

-- 
2.29.2

