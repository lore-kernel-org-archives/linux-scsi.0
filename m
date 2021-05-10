Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C7BC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 17:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1566112F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 17:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhEJRvy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 13:51:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:28486 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhEJRvy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 May 2021 13:51:54 -0400
IronPort-SDR: 18qVZ0lCYCHbbzYPW+5kOTHMfcYyAyhkFsT0nZygK6ZP/jSWyn5c+UcZmfrp3igIrI6Z4yIfJt
 +O6sgKr1vXoQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="179516645"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="179516645"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 10:50:47 -0700
IronPort-SDR: QXWSnJu/a4K4F33jQl+R2YMiw/7332eq0c9/dcWqpA6weLblSIdXEXiuw2KenWcrSqrICMIbv0
 6Q2zWQ9Th36w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="391062983"
Received: from lkp-server01.sh.intel.com (HELO f375d57c4ed4) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 10 May 2021 10:50:44 -0700
Received: from kbuild by f375d57c4ed4 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lgA3H-0000J3-Gr; Mon, 10 May 2021 17:50:43 +0000
Date:   Tue, 11 May 2021 01:50:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, hch@lst.de,
        m.szyprowski@samsung.com
Cc:     kbuild-all@lists.01.org, iommu@lists.linux-foundation.org,
        baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: [RFC PATCH] iova: __init_iova_domain can be static
Message-ID: <20210510175026.GA46391@b09f4beb6d7e>
References: <1620656249-68890-10-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620656249-68890-10-git-send-email-john.garry@huawei.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

drivers/iommu/iova.c:50:1: warning: symbol '__init_iova_domain' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 iova.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 273a689006c36..ae4901073a98a 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -46,7 +46,7 @@ static struct iova *to_iova(struct rb_node *node)
 	return rb_entry(node, struct iova, node);
 }
 
-void
+static void
 __init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	unsigned long start_pfn, unsigned long iova_len)
 {
