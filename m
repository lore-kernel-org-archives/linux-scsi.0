Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5C2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D02613A7
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346416AbhI3FWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 01:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233588AbhI3FWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 01:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632979271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Dz+qCsoc48LipRhHm4trgLssdzpozJ8ns9MbHfNQxF8=;
        b=BwBhuyEIDAgC/iBshymXPxCTbE7voL9kFWoxPvWLH7DMQxQE3ue6LC1en30SIwyIvkxJLZ
        GNQKVMW8ypKL4jab7yMhdW/kZPr/uEfnfAK57jfzB0DIMK5Bliz7FUwTbJXiRNpCgpekOZ
        GHR5Gb8wTyUwg0AmF6/3tGtr7J3Rs+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-N3Zyp2naN02OQTybRwmxqw-1; Thu, 30 Sep 2021 01:21:10 -0400
X-MC-Unique: N3Zyp2naN02OQTybRwmxqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EDFF362FB;
        Thu, 30 Sep 2021 05:21:09 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8685160E1C;
        Thu, 30 Sep 2021 05:20:37 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Changhui Zhong <czhong@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/2] SCSI: fix race between releasing shost and unloading LLD module
Date:   Thu, 30 Sep 2021 13:20:26 +0800
Message-Id: <20210930052028.934747-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Patch 1 allows put_device() to return if the device is really released.

Patch 2 fixes one race between releasing shost and unloading LLD module
by making sure that LLD module refcnt is dropped after the scsi device
is released.

Fix the kernel panic of 'BUG: unable to handle page fault for address'
reported by Changhui and Yi.


Ming Lei (2):
  driver core: tell caller if the device/kboject is really released
  scsi: core: put LLD module refcnt after SCSI device is released

 drivers/base/core.c        |  5 +++--
 drivers/scsi/scsi.c        | 14 ++++++++++++--
 drivers/scsi/scsi_sysfs.c  |  8 ++++++++
 include/linux/device.h     |  2 +-
 include/linux/kobject.h    |  2 +-
 include/scsi/scsi_device.h |  1 +
 lib/kobject.c              |  5 +++--
 7 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.31.1

