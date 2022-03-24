Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF22C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Mar 2022 09:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349162AbiCXJS0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Mar 2022 05:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbiCXJSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2022 05:18:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF5269E9C1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2022 02:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648113413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxIA+CLFwcc8TqwMm37/uOtvk1/QQRU8QzWc86/Fkpw=;
        b=btK12bY2jl4/6vuzmF5dCGfLBnhuAmcp2SRc/0+JB0MG/w8BIYqmxBmD8z8p8F3S3hwgTT
        vedmBj40JMuFuJ0j9GgdsCQ0HlBe0W0obxPfyRlVVZSOwyxZxxMMznfUCaSKqXNh0GNs3q
        nUT8SKz47ojTpxOe2Ska0r2xaXsCNSo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-LUQhrbZgOFe5H5F8ssxHOg-1; Thu, 24 Mar 2022 05:16:50 -0400
X-MC-Unique: LUQhrbZgOFe5H5F8ssxHOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4B79805A30;
        Thu, 24 Mar 2022 09:16:49 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 384BA112132C;
        Thu, 24 Mar 2022 09:16:41 +0000 (UTC)
Date:   Thu, 24 Mar 2022 17:16:36 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-mm@kvack.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        xuyu@linux.alibaba.com, bostroesser@gmail.com
Subject: Re: [RFC 2/3] mm: export zap_page_range()
Message-ID: <Yjw29HcA2JL41aA6@T590>
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <20220318095531.15479-3-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318095531.15479-3-xiaoguang.wang@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 18, 2022 at 05:55:30PM +0800, Xiaoguang Wang wrote:
> Module target_core_user will use it to implement zero copy feature.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  mm/memory.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 1f745e4d11c2..9974d0406dad 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1664,6 +1664,7 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_finish_mmu(&tlb);
>  }
> +EXPORT_SYMBOL_GPL(zap_page_range);

BTW, what is the counter part api of remap_pfn_range() for serving the
unmap? Or does it really need to unmap the vm space for this zero-copy
case?

If it isn't necessary to unmap, maybe remap_pfn_range() is faster than
vm_insert_page(s)_mkspecial + zap_page_range() since zap_page_range()
looks a bit heavy.


Thanks,
Ming

