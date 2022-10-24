Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1316FA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 13:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiJXNbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 09:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbiJXN1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 09:27:49 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A62CA9263
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 05:31:38 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q71so8545048pgq.8
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 05:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u0tDptCglh3aCeJHm8NhQH6aRaJBh3iGlRSTZIkHGmM=;
        b=DmtqFLxOmGWQMbYObhUv1Tvb/wkADSmrfdEgtgqpqcDpmE83P5ubITAqIBxsgQYuhV
         eGb62gBg0FQcxRgKiaxQ+BYIiY7FHO5Tiu6plzSvgMLCbqB81tILEKh2AS4cSTCZXM/4
         GdzP/Ze1HfY2AERTmvYQYBS5m5ZkDi9qa9JJ+ZD/ZUnTaH97gViCxd+j1/Rmy3pHq+ux
         XbkFTvpi7KYXz/M590IbmLmsUiK/Y//a6MSHw5p8IqdK32s1HYaYVqcNw3yRH6vpnCWm
         JadeqQ1L05eQRxUQ4d/BKKxxkNhoqzlY6n6W2goNmJH3w/lG2K0aHg0IkVuAicsowRYt
         1Smg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0tDptCglh3aCeJHm8NhQH6aRaJBh3iGlRSTZIkHGmM=;
        b=YjEbUSf69FK1c3v19/0oxBzdP2P7UrTdxVdrh4iRWXjdF3kFXEDZzMNgY1DKwJJ/j3
         BjHkQ2xqIWLWnQKgwmI1CIXyPJd2smC1wI1xFZwBLjJY7Y7ft6e3iIJn3PO91a5yXZgu
         iVrjV0TIhFZDidPJfWlDk5beyZXrPCysCKl8miPo0X3/E5ih7W427z1f22vGBH1W8ETC
         +tq/N+7gLhOAchOEHuyoBaDT+QOk3g3aDCmVb4BykNrgPxlYrT7RXa5FMQTSpPWYsTa6
         BJekih47qLTZC9Rxf9+X1K3H0tUMFLXKETl9xgocmLPBu/g2QxSITJbPYA+GjYAN02E1
         zRqQ==
X-Gm-Message-State: ACrzQf1xCa+K6UA8bVQDqQ66EWsFt5/C3abndcvO+EjE96Cu+C8h2Xol
        d6gOKl9kYAGEp8DU6krQxR/VVYtZbJZkxw==
X-Google-Smtp-Source: AMsMyM5h2t5DUR0hPXTeGR1mtm1ZDy0a3mJtPv20GtvoCzxX+YTElKDhYcgycqbYp/gfDSf2Z04wuA==
X-Received: by 2002:a0c:9c85:0:b0:4b1:a7b6:5485 with SMTP id i5-20020a0c9c85000000b004b1a7b65485mr27438028qvf.56.1666614084863;
        Mon, 24 Oct 2022 05:21:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id z21-20020ac84555000000b00398df095cf5sm12613654qtn.34.2022.10.24.05.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:21:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1omwSJ-00DRet-HK;
        Mon, 24 Oct 2022 09:21:23 -0300
Date:   Mon, 24 Oct 2022 09:21:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
Message-ID: <Y1aDQznakNaWD8kd@ziepe.ca>
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024010244.9522-2-dgilbert@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Oct 23, 2022 at 09:02:40PM -0400, Douglas Gilbert wrote:
> This patch fixes a check done by sgl_alloc_order() before it starts
> any allocations. The comment in the original said: "Check for integer
> overflow" but the right hand side of the expression in the condition
> is resolved as u32 so it can not exceed UINT32_MAX (4 GiB) which
> means 'length' can not exceed that value.
> 
> This function may be used to replace vmalloc(unsigned long) for a
> large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
> it seems unreasonable that sgl_alloc_order() whose length type is
> unsigned long long should be limited to 4 GB.
> 
> Solutions to this issue were discussed by Jason Gunthorpe
> <jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com>. This
> version is base on a linux-scsi post by Jason titled: "Re:
> [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit" dated 20220201.

You should link to lore here..

I think I prefer we just fix this so it doesn't have a problem in the
first place - nothing needs the weird unsigned long long argument type:

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c8c3d675845c37..c39e19fa174bca 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -595,19 +595,17 @@ EXPORT_SYMBOL(sg_alloc_table_from_pages_segment);
  *
  * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
  */
-struct scatterlist *sgl_alloc_order(unsigned long long length,
-				    unsigned int order, bool chainable,
-				    gfp_t gfp, unsigned int *nent_p)
+struct scatterlist *sgl_alloc_order(size_t length, unsigned int order,
+				    bool chainable, gfp_t gfp, size_t *nent_p)
 {
 	struct scatterlist *sgl, *sg;
 	struct page *page;
-	unsigned int nent, nalloc;
+	size_t nent, nalloc;
 	u32 elem_len;
 
-	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
-	/* Check for integer overflow */
-	if (length > (nent << (PAGE_SHIFT + order)))
-		return NULL;
+	nent = length >> (PAGE_SHIFT + order);
+	if (length % (1 << (PAGE_SHIFT + order)))
+		nent++;
 	nalloc = nent;
 	if (chainable) {
 		/* Check for integer overflow */
@@ -649,8 +647,7 @@ EXPORT_SYMBOL(sgl_alloc_order);
  *
  * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
  */
-struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
-			      unsigned int *nent_p)
+struct scatterlist *sgl_alloc(size_t length, gfp_t gfp, size_t *nent_p)
 {
 	return sgl_alloc_order(length, 0, false, gfp, nent_p);
 }

Jason
