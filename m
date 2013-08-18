From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/2] iscsi/iser-target: Add per-cpu ida tag pre-allocation for v3.12
Date: Sun, 18 Aug 2013 02:47:29 +0000
Message-ID: <1376794051-9835-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64642 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3HRDDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Aug 2013 23:03:16 -0400
Received: by mail-oa0-f50.google.com with SMTP id i4so3816546oah.37
        for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2013 20:03:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tejun Heo <tj@kernel.org>, Nicholas Bellinger <nab@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

Hi folks,

This series adds tag pre-allocation support of iscsi_cmd descriptors with
iscsi/iser-target code, utilizing Kent's latest per-cpu ida bits posted
earlier here:

  [PATCH-v3 1/4] idr: Percpu ida
  http://marc.info/?l=linux-virtualization&m=137669883717043&w=2

and a slightly modified version of the associated target-core patch here:

  [PATCH-v3 2/4] target: Add transport_init_session_tags using per-cpu ida
  http://marc.info/?l=linux-virtualization&m=137669888117057&w=2

Please review as v3.12 material.

Thanks!

--nab

Nicholas Bellinger (2):
  iscsi/iser-target: Convert to command priv_size usage
  iscsi-target: Convert to per-cpu ida_alloc + ida_free command map

 drivers/infiniband/ulp/isert/ib_isert.c      |  114 +++++++++-----------------
 drivers/infiniband/ulp/isert/ib_isert.h      |    2 +-
 drivers/target/iscsi/iscsi_target.c          |   16 +----
 drivers/target/iscsi/iscsi_target.h          |    1 -
 drivers/target/iscsi/iscsi_target_configfs.c |    2 +-
 drivers/target/iscsi/iscsi_target_core.h     |    3 +-
 drivers/target/iscsi/iscsi_target_nego.c     |   22 +++++-
 drivers/target/iscsi/iscsi_target_util.c     |   41 +++++----
 include/target/iscsi/iscsi_transport.h       |    8 ++-
 9 files changed, 94 insertions(+), 115 deletions(-)

-- 
1.7.2.5

