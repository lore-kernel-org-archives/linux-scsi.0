Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF55C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A832B60EE6
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbhIFB7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:59:43 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22462 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbhIFB73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 21:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630893507; x=1662429507;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=J1tYS+iygHQFjaXc9OBffVjlnEZf9IlQ6OxAqTUysko=;
  b=DaAa9jBSw9RchGZbYU6pp0f0IznnlYEA82+jnNfFunJZZoueqc3/8blY
   h+Jd/jlaXx5FSR9w89AlnN3W8uaTf3En3fCSKXOopFk9JPOmLAnr0hrK9
   FAVsVg6dp1NW8tqbz0vG+k6lOLNv6Llnwkm7kJyAOJRslOXPHrKyHcVuo
   qeebMFghO0S+rbQXbFKlaTs85X70+vV9M1cXextsGdQt1E6h2zjfmkRVr
   m2o74zkLyO9097KZkNt8tT1bAeLHh2MDDb13Czr1esyxIIn2VW5LYBIZI
   08RWTcnXi0hp+EKgkUM9BhF7kQ46/uAslh+S7cfKRz2JhKxQi4UZWtult
   A==;
X-IronPort-AV: E=Sophos;i="5.85,271,1624291200"; 
   d="scan'208";a="179789036"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 09:58:21 +0800
IronPort-SDR: 8s25pJvWfyGafqjNMBz2vdJpqKqNYXo0VKYEL280uPLCWoUiyUiZYrKeKOwxFoVj/qE/2lakM3
 hCYlEp5da1xKqEBihIJQU6//E0hqJ+iJRNaD3nsyEtbffKPgC1d4Z7N3fwuIKBjYFgzWe5Wt6v
 YX6AoRnjVX4gy91aoIcburvj87H/rPk7usG7Bgg/LsGyS23y4/+bK7euGE95yP2uq6y77Y4Rh2
 zDNnG/bwEZvKDUd0TvGvH2nLOiw7zXCqiRMfI86chKJtrBbFlR6jmKCzhYXD6STT+z0Yk2aFnf
 A5EupfCS6nRNAxYSlpSsFh9z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:33:21 -0700
IronPort-SDR: h6LA6PWn3GtQrz4kfFCkDRnyVX2NfuwkplsMp9TNzETsL2XONR9gaPZBPS14YM0ZDfpfivavOE
 AtTOwwAq2BzzyRFUwnXYzjMhPAL0XH9L8FeQ15hbBunLJRCXUU18aKiO0ZWNJkgIBhs2UKkSNy
 /bYq8DDYrH+OBckhYKyf4WWeXzZUiQnM9eNZ7BTQiqj1rstriJ8fYx8k3bO0YY7oRCjKUU84tT
 zrApnz5LApCeC/uy8bBe5ct1KdAWCMZXAQ96OVTY43dvUZNOwQLbr6nrCLIE5Kze7Z7JebSNNh
 L7k=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Sep 2021 18:58:20 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v7 5/5] doc: Fix typo in request queue sysfs documentation
Date:   Mon,  6 Sep 2021 10:58:10 +0900
Message-Id: <20210906015810.732799-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210906015810.732799-1-damien.lemoal@wdc.com>
References: <20210906015810.732799-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a typo (are -> as) in the introduction paragraph of
Documentation/block/queue-sysfs.rst.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/queue-sysfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index b6e8983d8eda..e8c74306f70a 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -4,7 +4,7 @@ Queue sysfs files
 
 This text file will detail the queue files that are located in the sysfs tree
 for each block device. Note that stacked devices typically do not export
-any settings, since their queue merely functions are a remapping target.
+any settings, since their queue merely functions as a remapping target.
 These files are the ones found in the /sys/block/xxx/queue/ directory.
 
 Files denoted with a RO postfix are readonly and the RW postfix means
-- 
2.31.1

