Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D4FC77B75
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 23:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjEFXak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 19:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjEFXaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 19:30:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D817D40C0
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 16:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683415794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VPtwiHRcbAtbIWptlNsxTdMycjSDQHYcwJb296c1nk0=;
        b=VnhRHt9UzVql5B/GHrQfdhHcLFMYoSPolwGehSUiGcswo4N2+51YK3E6EKHTsyN/JsnQ9K
        ypQ3MISyy1WYdvN1NX3pBJvZmkIeXoKAY6aYKbduLDWvKXrMiuzg17tqwkkRjr4+CQzn9J
        Va1AtSVgKyPrO1tU9Afid+uRKfDa4LQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-MQrfL2ArNjiUACkwMXTBEg-1; Sat, 06 May 2023 19:29:53 -0400
X-MC-Unique: MQrfL2ArNjiUACkwMXTBEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F14B129ABA00;
        Sat,  6 May 2023 23:29:52 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66FCD440BC;
        Sat,  6 May 2023 23:29:52 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Chris Leech <cleech@redhat.com>
Subject: [PATCH v2 00/11] Make iscsid-kernel communications namespace-aware
Date:   Sat,  6 May 2023 16:29:19 -0700
Message-Id: <20230506232930.195451-1-cleech@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This set of patches modifies the kernel iSCSI initiator communications
so that they are namespace-aware. The goal is to allow multiple iSCSI
daemon (iscsid) to run at once as long as they are in separate
namespaces, and so that iscsid can run in containers.

Container runtime environments seem to want to containerize their own
components, and there have been complaints about the need to run iscsid
from the host network namespace. There are still priviledged
capabilities needed for iscsid, but these changes address the namespace
issue.

I've tested with iscsi_tcp and iser over rxe with an unmodified iscsid
running in a podman container.

Note that with iscsi_tcp, the connected socket will keep the network
namespace alive after container exit. The namespace will exit once the
connection terminates, and I'd recommend running with a iSCSI
noop_out_timeout set to error out the connection after the routing has
been removed.

v2: Changes from Lee's last RFC posting
- Minor changes to patches 2 & 3 to not break iSER

- Large changes in patch 6, merging in patches posted to the previous
  discussion. Use of current when setting the netns on an iscsi_tcp
  session has been removed, instead an unbound (from a host) session
  creation with an explicit netns interface has been added. Similar
  changes for iSER endpoints have been added, and iSER support for
  non-default network namespaces was enabled.

- The addition of patches 10 & 11 from the previous discussions to force
  removal of sessions on namespace exit.

Chris Leech, Lee Duncan (11):
  iscsi: create per-net iscsi netlink kernel sockets
  iscsi: associate endpoints with a host
  iscsi: sysfs filtering by network namespace
  iscsi: make all iSCSI netlink multicast namespace aware
  iscsi: check net namespace for all iscsi lookup
  iscsi: set netns for tcp and iser hosts
  iscsi: convert flashnode devices from bus to class
  iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
  iscsi: filter flashnode sysfs by net namespace
  iscsi: make session and connection lists per-net
  iscsi: force destroy sesions when a network namespace exits

 drivers/infiniband/ulp/iser/iscsi_iser.c |  61 +-
 drivers/scsi/be2iscsi/be_iscsi.c         |   6 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |   6 +-
 drivers/scsi/cxgbi/libcxgbi.c            |   6 +-
 drivers/scsi/iscsi_tcp.c                 |  15 +-
 drivers/scsi/libiscsi.c                  |  16 +
 drivers/scsi/qedi/qedi_iscsi.c           |   6 +-
 drivers/scsi/qla4xxx/ql4_os.c            |  64 +-
 drivers/scsi/scsi_transport_iscsi.c      | 790 ++++++++++++++++-------
 include/scsi/libiscsi.h                  |   4 +
 include/scsi/scsi_transport_iscsi.h      |  75 ++-
 11 files changed, 725 insertions(+), 324 deletions(-)

-- 
2.39.2

