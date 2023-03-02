Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0435C6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 15:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjCBPt0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCBPtW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 10:49:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2926D199FC
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 07:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+gh0Y/5d6g6hyIyi2RH1xKsza2fmNhMJKlwCANmmTyg=;
        b=fqUn64farYTI1LkNG5XCNM3fEOMOGb3VHeQG9uNOsuo2DPayqF1jW43450gG7/9gNTdG3D
        BMt1O1eFE2Hz7HqSFz3oOU7lO30DZbNGjQ/ogJJF0jO06gkXv4SuOKgSOlPEecghxeeahC
        /XshDWRSecXTsYWsrjlkmhayvuCmNg8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-3ltUibPKOM2EsUYkQHsk7w-1; Thu, 02 Mar 2023 10:48:29 -0500
X-MC-Unique: 3ltUibPKOM2EsUYkQHsk7w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D06FD1C0691E;
        Thu,  2 Mar 2023 15:48:27 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26E93492C3E;
        Thu,  2 Mar 2023 15:48:27 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH 0/6] scsi: mpi3mr: fix few resource leaks
Date:   Thu,  2 Mar 2023 16:48:20 +0100
Message-Id: <20230302154826.5862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The series applies on
[PATCH 00/15] mpi3mr: Few Enhancements and minor fixes
from 2/24 posted by Ranjan.

 drivers/scsi/mpi3mr/mpi3mr.h           |  2 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c        | 62 ++++++++++++++++----------
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 24 ++++++++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  5 +--
 4 files changed, 65 insertions(+), 28 deletions(-)

-- 
2.39.1

