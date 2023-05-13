Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D1BC77B7C
	for <linux-scsi@archiver.kernel.org>; Sat, 13 May 2023 15:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjEMP4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 May 2023 11:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjEMP4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 May 2023 11:56:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F5530E5
        for <linux-scsi@vger.kernel.org>; Sat, 13 May 2023 08:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683993364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=jl6ijkVNAAutG3fo6v1eLkmMFUDlC7JlhXWkMwI3qxU=;
        b=ZFq5EnbXw0uainJGkBzEVB5q3X2LPk777DyKRHH4eWjNWDsC7vTX1svSnTvwOuWHyh4MUn
        v+8atddkvo3wuvshqzcg9g9pvZRRGamF1tcplTT6g4o6/lks/o8oXrXStcuU2IBgzqLkvV
        ImAMMRcBX7vifVjdar+qLaJGp/wIWaU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-JBRI2ONsOP6JuPxS8bRn-Q-1; Sat, 13 May 2023 11:56:02 -0400
X-MC-Unique: JBRI2ONsOP6JuPxS8bRn-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 275C7857E60;
        Sat, 13 May 2023 15:56:02 +0000 (UTC)
Received: from ovpn-8-17.pek2.redhat.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3369C1121314;
        Sat, 13 May 2023 15:55:56 +0000 (UTC)
Date:   Sat, 13 May 2023 23:55:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     ming.lei@redhat.com, emilne@redhat.com, czhong@redhat.com,
        Wenchao Hao <haowenchao@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: SCSI: Consumer of scsi_devices->iorequest_cnt/iodone_cnt/ioerr_cnt
Message-ID: <ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Guys,

scsi_device->iorequest_cnt/iodone_cnt/ioerr_cnt are only inc/dec,
and exported to userspace via sysfs in kernel, and not see any kernel
consumers, so the exported counters are only for userspace, just be curious
which/how applications consume them?

These counters not only adds cost in fast path, but also causes kernel panic,
especially the "atomic_inc(&cmd->device->iorequest_cnt)" in
scsi_queue_rq(), because cmd->device may be freed after returning
from scsi_dispatch_cmd(), which is introduced by:

cfee29ffb45b ("scsi: core: Do not increase scsi_device's iorequest_cnt if dispatch failed")

If there aren't explicit applications which depend on these counters,
I'd suggest to kill the three since all are not in stable ABI. Otherwise
I think we need to revert cfee29ffb45b.



[1] [linux]$ git grep -n -E "iorequest_cnt|iodone_cnt|ioerr_cnt" ./
Documentation/scsi/st.rst:222:value as iodone_cnt at the device level. The tape statistics only count
drivers/scsi/scsi_error.c:362:  atomic_inc(&scmd->device->iodone_cnt);
drivers/scsi/scsi_lib.c:1428:   atomic_inc(&cmd->device->iodone_cnt);
drivers/scsi/scsi_lib.c:1430:           atomic_inc(&cmd->device->ioerr_cnt);
drivers/scsi/scsi_lib.c:1764:   atomic_inc(&cmd->device->iorequest_cnt);
drivers/scsi/scsi_sysfs.c:968:show_sdev_iostat(iorequest_cnt);
drivers/scsi/scsi_sysfs.c:969:show_sdev_iostat(iodone_cnt);
drivers/scsi/scsi_sysfs.c:970:show_sdev_iostat(ioerr_cnt);
drivers/scsi/scsi_sysfs.c:1288: &dev_attr_iorequest_cnt.attr,
drivers/scsi/scsi_sysfs.c:1289: &dev_attr_iodone_cnt.attr,
drivers/scsi/scsi_sysfs.c:1290: &dev_attr_ioerr_cnt.attr,
drivers/scsi/sd.c:3531: atomic_set(&sdkp->device->ioerr_cnt, 0);
include/scsi/scsi_device.h:234: atomic_t iorequest_cnt;
include/scsi/scsi_device.h:235: atomic_t iodone_cnt;
include/scsi/scsi_device.h:236: atomic_t ioerr_cnt;




Thanks,
Ming

