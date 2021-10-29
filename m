Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6903C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA93560F9B
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJ2Tpo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:45:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230176AbhJ2Tpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Oct 2021 15:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635536594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cvb2Lu7ABd8XKHFFnfk+1gwekG0jPxUARnB7VyneFgk=;
        b=Gmxi6qvfTfEcWLJAboIaQpnyfQPmdQl/EKB20akn3aeOLbOy8WbxODm9sGlgBaaJ8yzVTt
        sArVBQN2mY5YOwWD3RMZe1BT0PpxP0bFtq6sX5wQKAJrHA8uVKZr9mlKrB1I68qTX9n/SF
        Nwypf8uQW1aKzDtJiD7Mpbs9ZEgFaIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-NX5104FJNuq-PAz5P4m-EA-1; Fri, 29 Oct 2021 15:43:13 -0400
X-MC-Unique: NX5104FJNuq-PAz5P4m-EA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7027B18125C0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 19:43:12 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DF315FC13
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 19:43:12 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/2] Fix SCSI async abort handling when eh_deadline is active
Date:   Fri, 29 Oct 2021 15:43:09 -0400
Message-Id: <20211029194311.17504-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a code path in the SCSI async abort handling that can cause error
handling of subsequent scsi_cmnds to proceed immediately to host reset with no
other attempt at recovery.

This can be seen by the following:

    modprobe scsi_debug every_nth=10 opts=4
    echo 7 > /sys/module/scsi_mod/parameters/scsi_logging_level
    echo 10 > /sys/devices/pseudo_0/adapter0/host8/scsi_host/host<N>/eh_deadline

and performing I/O to the scsi_debug device, the host will get reset
because prior aborts succeeded, because ->last_reset does not get invalidated.

The patch series contains a fix, followed by a simplification
of the control flow to remove duplicate code.  Only the first patch
is Cc: stable as the second part doesn't qualify.  Yes, I know the
first patch is >100 lines, I couldn't make it smaller unfortunately.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>

v2:
    - Introduced scsi_eh_abort_cleanup() in patch 1/1 to factor out code
      (This is then removed in patch 2/2 since code refactoring results
       in only one place it is called though.)
    - Moved introduction of local "shost" to cleanup patch 2/2

Ewan D. Milne (2):
  scsi: core: avoid leaving shost->last_reset with stale value if EH
    does not run
  scsi: core: simplify control flow in scmd_eh_abort_handler()

 drivers/scsi/hosts.c      |  1 +
 drivers/scsi/scsi_error.c | 92 ++++++++++++++++++++++++++++++-----------------
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  |  2 +-
 include/scsi/scsi_host.h  |  1 +
 5 files changed, 63 insertions(+), 34 deletions(-)

-- 
2.1.0

