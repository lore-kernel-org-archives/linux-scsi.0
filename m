Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02960CA9EA4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 09:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9C7821897
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 09:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404365AbfJRJig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 05:38:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:51944 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727917AbfJRJig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 05:38:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 693F2B1D5;
        Fri, 18 Oct 2019 09:38:34 +0000 (UTC)
Date:   Fri, 18 Oct 2019 11:38:30 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Qian Cai <cai@lca.pw>
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>, don.brace@microsemi.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, esc.storagedev@microsemi.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH] iommu/amd: Check PM_LEVEL_SIZE() condition in locked section
Message-ID: <20191018093830.GA26328@suse.de>
References: <20191016225859.j3jq6pt73mn56chn@cantor>
 <577A2A6B-3012-4CDE-BE57-3E0D628572CB@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <577A2A6B-3012-4CDE-BE57-3E0D628572CB@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 17, 2019 at 07:36:51AM -0400, Qian Cai wrote:
> 
> 
> > On Oct 16, 2019, at 6:59 PM, Jerry Snitselaar <jsnitsel@redhat.com> wrote:
> > 
> > I guess the mode level 6 check is really for other potential callers
> > increase_address_space, none exist at the moment, and the condition
> > of the while loop in alloc_pte should fail if the mode level is 6.
> 
> Because there is no locking around iommu_map_page(), if there are
> several concurrent callers of it for the same domain, could it be that
> it silently corrupt data due to invalid access?

No, that can't happen because increase_address_space locks the domain
before actually doing anything. So the address space can't grow above
domain->mode == 6. But what can happen is that the WARN_ON_ONCE triggers
in there and that the address space is increased multiple times when
only one increase would be sufficient.

To fix this we just need to check the PM_LEVEL_SIZE() condition again
when we hold the lock:

From e930e792a998e89dfd4feef15fbbf289c45124dc Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Fri, 18 Oct 2019 11:34:22 +0200
Subject: [PATCH] iommu/amd: Check PM_LEVEL_SIZE() condition in locked section

The increase_address_space() function has to check the PM_LEVEL_SIZE()
condition again under the domain->lock to avoid a false trigger of the
WARN_ON_ONCE() and to avoid that the address space is increase more
often than necessary.

Reported-by: Qian Cai <cai@lca.pw>
Fixes: 754265bcab78 ("iommu/amd: Fix race in increase_address_space()")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 2369b8af81f3..a0639e511ffe 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1463,6 +1463,7 @@ static void free_pagetable(struct protection_domain *domain)
  * to 64 bits.
  */
 static bool increase_address_space(struct protection_domain *domain,
+				   unsigned long address,
 				   gfp_t gfp)
 {
 	unsigned long flags;
@@ -1471,8 +1472,8 @@ static bool increase_address_space(struct protection_domain *domain,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (WARN_ON_ONCE(domain->mode == PAGE_MODE_6_LEVEL))
-		/* address space already 64 bit large */
+	if (address <= PM_LEVEL_SIZE(domain->mode) ||
+	    WARN_ON_ONCE(domain->mode == PAGE_MODE_6_LEVEL))
 		goto out;
 
 	pte = (void *)get_zeroed_page(gfp);
@@ -1505,7 +1506,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 	BUG_ON(!is_power_of_2(page_size));
 
 	while (address > PM_LEVEL_SIZE(domain->mode))
-		*updated = increase_address_space(domain, gfp) || *updated;
+		*updated = increase_address_space(domain, address, gfp) || *updated;
 
 	level   = domain->mode - 1;
 	pte     = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
-- 
2.16.4

