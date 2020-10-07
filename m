Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF0FC4363D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 14:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B34C721531
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 14:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpYVr8C3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgJGOxw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728571AbgJGOxv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 10:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602082431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gJ/9v3J0x6FY0RJ8LARc2nFvYIJclUKo1qVrQtbh2kw=;
        b=CpYVr8C3B4rSCDNLsrQdD917ID0urNHcJAzhJojdsX0Z8TjcZHb8OjH/Su9fGq1Fgx8PgV
        N79Ht2TkZnE/pXupissrpjWRUR03WQfI/KcI2NVHHoeMLJqHQHDnlNsBRs3eCoOFvi5gRi
        A4ROHO5zHfwxjqwJixgY8zNQr7WL57k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-jebWaZ9INMmLHjdX2dp_fg-1; Wed, 07 Oct 2020 10:53:49 -0400
X-MC-Unique: jebWaZ9INMmLHjdX2dp_fg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82D2F19080D8;
        Wed,  7 Oct 2020 14:53:29 +0000 (UTC)
Received: from nangaparbat.redhat.com (unknown [10.35.206.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A3A760BF3;
        Wed,  7 Oct 2020 14:53:27 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org, michael.christie@oracle.com
Subject: [PATCH 0/2] fix race conditions with task aborts
Date:   Wed,  7 Oct 2020 16:53:24 +0200
Message-Id: <20201007145326.56850-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset fixes some possible race conditions when
2 threads call iscsit_free_cmd()/__iscsit_free_cmd() at
the same time.

Maurizio Lombardi (2):
  target: iscsi: prevent a race condition in iscsit_unmap_cmd()
  target: iscsi: fix a race condition when aborting a task

 drivers/target/iscsi/iscsi_target_login.c | 1 +
 drivers/target/iscsi/iscsi_target_util.c  | 7 ++++---
 include/target/iscsi/iscsi_target_core.h  | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.26.2

