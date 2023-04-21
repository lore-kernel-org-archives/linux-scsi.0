Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB475C7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 05:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjDUFGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 01:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDUFGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 01:06:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4833630DF
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 22:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682053557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0q9oxwPDsSiWxgEq0uCvInxnqKmFGfsxHg50UrYoaWY=;
        b=jT8LgWnI/YxV9ToHQa5dgc3ZIiM541P5i+jS9zfW6L+iOsgUyQGK0uGlRu1+oRa5R1zh+X
        hyUuWjHgiEUAZe7VbJj4mUPcsVBLPM+S1eYsW3Abb9gWNLtfTW8VddCkbSbIu5dd4hhAXW
        GoZsSJU9vwXYN+bI1qDaDbfLb5B3PCE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-QL6K3lDeOVaIDaN80H9LAw-1; Fri, 21 Apr 2023 01:05:53 -0400
X-MC-Unique: QL6K3lDeOVaIDaN80H9LAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 552721C05EC3;
        Fri, 21 Apr 2023 05:05:53 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.2.16.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEC074020BED;
        Fri, 21 Apr 2023 05:05:52 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: Re: [RFC PATCH 2/9] iscsi: associate endpoints with a host
Date:   Thu, 20 Apr 2023 22:05:18 -0700
Message-Id: <20230421050521.49903-1-cleech@redhat.com>
In-Reply-To: <20230420164232.GA27885@localhost>
References: <20230420164232.GA27885@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I managed to fix the iSER endpoint issue by making endpoints created
without a host valid again. Once I had iSER working, I went ahead and
made it network namespace aware as well.

Only tested with software roce (rxe) against the kernel target.

I think the net_exit code might need to do a bit more with iSER.
I'm going to look into that, then I'll merge some of these patches that
fix earlier patches together, and get a new clean version of the set
posted.

Chris Leech (3):
  iscsi iser: fix iser, allow virtual endpoints again
  iscsi iser: direct network namespace support for endpoints
  iscsi iser: enable network namespace awareness in iser

 drivers/infiniband/ulp/iser/iscsi_iser.c | 13 ++++---
 drivers/scsi/iscsi_tcp.c                 | 10 ++----
 drivers/scsi/iscsi_tcp.h                 |  1 -
 drivers/scsi/libiscsi.c                  | 12 +++++++
 drivers/scsi/scsi_transport_iscsi.c      | 45 +++++++++++++++++++-----
 include/scsi/libiscsi.h                  |  4 +++
 include/scsi/scsi_transport_iscsi.h      |  9 ++++-
 7 files changed, 71 insertions(+), 23 deletions(-)

-- 
2.39.2

