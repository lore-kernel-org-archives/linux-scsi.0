Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1296DC54EED
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 10:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbjA3KOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 05:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235761AbjA3KOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 05:14:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ACD15557
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 02:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675073601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l2nDG/CvtTA6UKKdKXFMdKptXT7uzbYwh7+TcK/Vgc8=;
        b=bufu6ssK/RvSC6/5D4RAt0QzlR1N4bIdk7m7UOKXPzZhsC0cxviq7pnzyn5Ly5p30/MQ9o
        FM1HfgaW3X1C7jbEjO+yeVeAnJ44UxiHDznt1dP/6AfkqXMOniep1VPijbwyGGfkrjute0
        9DS0rjGK/l4An8eR7RMgFV/bwywN2GM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-QDB4v8pkM5CRNTuhHszw3w-1; Mon, 30 Jan 2023 05:13:18 -0500
X-MC-Unique: QDB4v8pkM5CRNTuhHszw3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C6443C0DDBA
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 10:13:18 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-193-84.brq.redhat.com [10.40.193.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 312EA1121314
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 10:13:18 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH 0/4] ses: prevent from out of bounds accesses 
Date:   Mon, 30 Jan 2023 11:13:13 +0100
Message-Id: <20230130101317.4862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

First patch fixes a KASAN reported problem
Second patch fixes other possible places in ses_enclosure_data_process
where the max_desc_len might access memory out of bounds.
3/4 does the same for desc_ptr in ses_enclosure_data_process.
The last patch fixes another KASAN report in ses_intf_remove.


Tomas Henzl (4):
  ses: fix slab-out-of-bounds reported by KASAN in ses_enclosure_data_process
  ses: fix possible addl_desc_ptr out-of-bounds accesses in ses_enclosure_data_process
  ses: fix possible desc_ptr out-of-bounds accesses in ses_enclosure_data_process
  ses: fix slab-out-of-bounds reported by KASAN in ses_intf_remove 

 drivers/scsi/ses.c | 58 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 17 deletions(-)

-- 
2.38.1

