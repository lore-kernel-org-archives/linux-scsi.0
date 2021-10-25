Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A54CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 14:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 341DB60F46
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 14:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhJYOmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 10:42:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229727AbhJYOmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 10:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635172795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WUwIocy4Zq5z3rtGiYtkg4ndMTXRknS5wQX84i/+Cuo=;
        b=b2/2EYuEw26jQZvTSB6nJAyOhQUMvlNCq1cwWBCojEsc2fCYCal//I8m0a/DM0z5/oyaX7
        GdnSpQ+A5ILiuH8W5tVYACtHOLC6r5UisIDHLHU2AlALOP4L0vSiI74d7c+jyF+tMNq41V
        Xo7Zbg5rsN17dEYxC4E1OxNvqWJkKlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-QsDv3bkyPc6RAa0qVhzcxw-1; Mon, 25 Oct 2021 10:39:54 -0400
X-MC-Unique: QsDv3bkyPc6RAa0qVhzcxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34A4BBBEE6
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 14:39:53 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03F145D9D5
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 14:39:52 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] Fix SCSI async abort handling when eh_deadline is active
Date:   Mon, 25 Oct 2021 10:39:50 -0400
Message-Id: <20211025143952.17128-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

and performing I/O to the scsi_debug device, the host will get reset immediately
when prior aborts succeeded, because ->last_reset does not get invalidated.

The patch series contains a fix, followed by a simplification
of the control flow to remove duplicate code.  Only the first patch
is Cc: stable as the second part doesn't qualify.  Yes, I know the
first patch is >100 lines, I couldn't make it smaller unfortunately.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Ewan D. Milne (2):
  scsi: core: avoid leaving shost->last_reset with stale value if EH
    does not run
  scsi: core: simplify control flow in scmd_eh_abort_handler

 drivers/scsi/hosts.c      |  1 +
 drivers/scsi/scsi_error.c | 92 ++++++++++++++++++++++++++++++-----------------
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  |  2 +-
 include/scsi/scsi_host.h  |  1 +
 5 files changed, 63 insertions(+), 34 deletions(-)

-- 
2.1.0

