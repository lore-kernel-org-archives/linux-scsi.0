Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75486C47089
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 01:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D175613BF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 01:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhE1BUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 21:20:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233887AbhE1BUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 21:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622164736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jrgS+Fe6PV7I1SvpzKAW8Q9nMW4fO9TwwWLjjj+isUc=;
        b=ThgY0F3VhlM8YBVjFU21GzEMH2FKrFxYYi8OJn/ZvxwNTbRXFWrK6nvFvUJ4RRmNAPmkzm
        0+uMBuRoOdBgplIOPkol5p8N9XejMt0WeZnkZKpjOKjrL+q//vK89cFnz4Rdx0z5o+fRaf
        TwYpeLnKkGl6nHo1IHWDJoROBRc/dhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-D86eS7STPAa6o4gfu4weUA-1; Thu, 27 May 2021 21:18:54 -0400
X-MC-Unique: D86eS7STPAa6o4gfu4weUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0ED8D107ACCA;
        Fri, 28 May 2021 01:18:53 +0000 (UTC)
Received: from localhost (ovpn-12-72.pek2.redhat.com [10.72.12.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F27C5D9C6;
        Fri, 28 May 2021 01:18:48 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V2 0/2] scsi: two fixes in scsi_add_host_with_dma
Date:   Fri, 28 May 2021 09:18:36 +0800
Message-Id: <20210528011838.2122559-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin,

The 1st patch fixes one double free in failure path of adding host.

The 2nd patch fixes one host device leak in failure path of adding host.

V2:
	- add patch 2 for addressing shost leak in case of adding host
	  failure, reported by John Garry.


Ming Lei (2):
  scsi: core: fix failure handling of scsi_add_host_with_dma
  scsi: core: put shost->shost_gendev in failure handling path

 drivers/scsi/hosts.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>


-- 
2.29.2

