Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AD7C64EC4
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 17:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjBHRoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjBHRn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 12:43:56 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3A556484;
        Wed,  8 Feb 2023 09:42:14 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3ABD72233E;
        Wed,  8 Feb 2023 17:40:59 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id F3C822C141;
        Wed,  8 Feb 2023 17:40:58 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 1C9BFCA184; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>
Subject: [RFC 0/9] Make iscsid-kernel communications namespace-aware
Date:   Wed,  8 Feb 2023 09:40:48 -0800
Message-Id: <cover.1675876731.git.lduncan@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

This is a request for comment on a set of patches that
modify the kernel iSCSI initiator communications so that
they are namespace-aware. The goal is to allow multiple
iSCSI daemon (iscsid) to run at once as long as they
are in separate namespaces, and so that iscsid can
run in containers.

Comments and suggestions are more than welcome. I do not
expect that this code is production-ready yet, and
networking isn't my strongest suit (yet).

These patches were originally posted in 2015 by Chris
Leech. There were some issues at the time about how
to handle namespaces going away. I hope to address
any issues raised with this patchset and then
to merge these changes upstream to address working
in working in containers.

My contribution thus far has been to update these patches
to work with the current upstream kernel.

Chris Leech/Lee Duncan (9):
  iscsi: create per-net iscsi netlink kernel sockets
  iscsi: associate endpoints with a host
  iscsi: sysfs filtering by network namespace
  iscsi: make all iSCSI netlink multicast namespace aware
  iscsi: set netns for iscsi_tcp hosts
  iscsi: check net namespace for all iscsi lookup
  iscsi: convert flashnode devices from bus to class
  iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
  iscsi: filter flashnode sysfs by net namespace

 drivers/infiniband/ulp/iser/iscsi_iser.c |   7 +-
 drivers/scsi/be2iscsi/be_iscsi.c         |   6 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |   6 +-
 drivers/scsi/cxgbi/libcxgbi.c            |   6 +-
 drivers/scsi/iscsi_tcp.c                 |   7 +
 drivers/scsi/qedi/qedi_iscsi.c           |   6 +-
 drivers/scsi/qla4xxx/ql4_os.c            |  64 +--
 drivers/scsi/scsi_transport_iscsi.c      | 625 ++++++++++++++++-------
 include/scsi/scsi_transport_iscsi.h      |  63 ++-
 9 files changed, 537 insertions(+), 253 deletions(-)

-- 
2.39.1

