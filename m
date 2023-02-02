Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B3AC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 16:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBBQZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 11:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBBQZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 11:25:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29E8279BD
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 08:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675355096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rAUZ3BSKgRm16d85D54D0X/p8+OwG+r13Dd/SUuu6vU=;
        b=LPpTl6lX1eN64ZNPI8I0hebNvP0XKUIXiZQ+FW66kAFN7d/fPp24x+P6T2P8JR2oD87h00
        W9etUxoeQ70KmnfUo0ZSxkjQP1mtyGswjIq/jJYzwwKh0QX2CiJNDm3wMmV6w4KdEqRpWv
        lw6p6FvubK++nfJtrxoWbyKvPiFnYYs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-Rr-NFDu2PBmWcLdsqAgNDA-1; Thu, 02 Feb 2023 11:24:52 -0500
X-MC-Unique: Rr-NFDu2PBmWcLdsqAgNDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81733857D07;
        Thu,  2 Feb 2023 16:24:52 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-192-75.brq.redhat.com [10.40.192.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0830A404BEC1;
        Thu,  2 Feb 2023 16:24:51 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     mikoxyzzz@gmail.com
Subject: [PATCH v2 0/4] ses: prevent from out of bounds accesses 
Date:   Thu,  2 Feb 2023 17:24:47 +0100
Message-Id: <20230202162451.15346-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

First patch fixes a KASAN reported problem
Second patch fixes other possible places in ses_enclosure_data_process
where the max_desc_len might access memory out of bounds.
3/4 does the same for desc_ptr in ses_enclosure_data_process.
The last patch fixes another KASAN report in ses_intf_remove.

Changes:
v1: cc-ed stable@vger.kernel.org

Tomas Henzl (4):
  ses: fix slab-out-of-bounds reported by KASAN in ses_enclosure_data_process
  ses: fix possible addl_desc_ptr out-of-bounds accesses in ses_enclosure_data_process
  ses: fix possible desc_ptr out-of-bounds accesses in ses_enclosure_data_process
  ses: fix slab-out-of-bounds reported by KASAN in ses_intf_remove 

 drivers/scsi/ses.c | 58 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 17 deletions(-)

-- 
2.38.1

