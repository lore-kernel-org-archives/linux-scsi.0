Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7F6C6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 23:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCBXof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 18:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjCBXoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 18:44:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F6E17154
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 15:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677800623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/RBGe+BxqDDzkis4FHuR20K5OrQxToAnleMnNh4//h4=;
        b=AIMMjcTlyYqaIbQs9r+94Jj0Uxg4SNnayeFbfDYRbxcaomUJD9NnilBMvwUimShIJ2jGVv
        Lcn1aFFSf9VqprUucusjhx6q+HqETc4z8dNf4iYiMugelY1kmBYEjfdaIXwtjbbnY6ofED
        4/PWXosUbOrCGOOQTYFwj2ATcdEERx4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-Yxscwc3QMb2T4RGyOXivyg-1; Thu, 02 Mar 2023 18:43:38 -0500
X-MC-Unique: Yxscwc3QMb2T4RGyOXivyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FB1080352D;
        Thu,  2 Mar 2023 23:43:38 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78085140EBF6;
        Thu,  2 Mar 2023 23:43:37 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH v2 0/6] scsi: mpi3mr: fix few resource leaks
Date:   Fri,  3 Mar 2023 00:43:30 +0100
Message-Id: <20230302234336.25456-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The series applies on
[PATCH 00/15] mpi3mr: Few Enhancements and minor fixes
from 2/24 posted by Ranjan.

V2 - fixed a bug in [PATCH 5/6]


 drivers/scsi/mpi3mr/mpi3mr.h           |  2 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c        | 50 ++++++++++++++++----------
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 24 +++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  5 +--
 4 files changed, 58 insertions(+), 23 deletions(-)

-- 
2.39.1

