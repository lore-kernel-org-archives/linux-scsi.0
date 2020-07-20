Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AF2C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B21B208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgGTC5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 22:57:53 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42946 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgGTC5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 22:57:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7246F204259;
        Mon, 20 Jul 2020 04:57:51 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6Q1UhgOr8jRE; Mon, 20 Jul 2020 04:57:45 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id D5AF320423F;
        Mon, 20 Jul 2020 04:57:44 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v5 0/9] scsi: use xarray for devices and targets
Date:   Sun, 19 Jul 2020 22:57:33 -0400
Message-Id: <20200720025742.349296-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset has bounced between my ownership and that of
Hannes Reinecke and now back again. The rationale remains
the same:
  - strengthen the SCSI mid-level object tree "glue" by
    retiring linked lists where practical, especially the
    redundant one. Use xarrays and the idr mechanism
    at the host level
  - make the various 'lookup' exported functions O(ln(n))
    rather than O(n).
  - lessen the reliance on the host_lock by making finer
    grain locks available (to be done)

Version 4 of this patchset was sent to the linux-scsi list on
20200602 by Hannes with a similar subject name. That was
against MKP's 5.8/scsi-queue branch.
It had 6 parts and they form the first 6 patches of this
patchset, with minor changes since it is now based on MKP's
5.9/scsi-queue branch. The last three patches have been
added by the author, the first two have previously been
sent to the Linux-scsi list in early June.

The last patch could change the subject (adding 'hosts')
but the subject line has been kept so former patchset
versions can be more easily found.

Douglas Gilbert (3):
  scsi: add starget_to_shost() specialization
  scsi: simplify scsi_target() inline
  scsi_host: switch ida to idr to hold shost ptr

Hannes Reinecke (6):
  scsi: convert target lookup to xarray
  target_core_pscsi: use __scsi_device_lookup()
  scsi: move target device list to xarray
  scsi: remove direct device lookup per host
  scsi_error: use xarray lookup instead of wrappers
  scsi: avoid pointless memory allocation in scsi_alloc_target()

 drivers/scsi/hosts.c               |  42 +++-----
 drivers/scsi/scsi.c                | 153 ++++++++++++++++++++++-------
 drivers/scsi/scsi_error.c          |  35 ++++---
 drivers/scsi/scsi_lib.c            |   9 +-
 drivers/scsi/scsi_priv.h           |   2 +
 drivers/scsi/scsi_scan.c           | 112 ++++++++++++---------
 drivers/scsi/scsi_sysfs.c          |  74 ++++++++++----
 drivers/target/target_core_pscsi.c |   8 +-
 include/scsi/scsi_device.h         |  44 ++++++---
 include/scsi/scsi_host.h           |   5 +-
 include/scsi/scsi_transport.h      |   2 +-
 11 files changed, 318 insertions(+), 168 deletions(-)

-- 
2.25.1

