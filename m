Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C21C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 18:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA1C322D08
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 18:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407620AbhARSaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 13:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436796AbhARS3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 13:29:37 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065A6C0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2021 10:28:57 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id c7so19547080qke.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2021 10:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V6OfwHc1CUnuze+sIKYDwiSSMcP1Mnt94yrNdzONXMc=;
        b=I70gxMCGa6VXFTdCUVqIrxDoriChErMWEhWVmnDCztvFEV9K/n3ElBkgmgrtpg1BjL
         JCXkgxdsL9K9xEv/0cEKuSXqiuiK5Zk061N68H4RaQ/56J+SpmBKSe2uRjtgWjwu3Ec2
         NX5qA1+NkpWXw70tjWcvipfP7S9DA4dn6/H9GgFqdazctTtrzJX/fPCeqUHTo0gTwJrl
         82xJGfkL9mF0QqRezQdtrPfNLCQiTjrXcwyRcZ80pnlFank7cK6kcJoxYmfKzIbst7lK
         bXFmYGu0MlcKlzYwaIe7d3MvE0MsWb4ucMN22I1k2+G6PbJMn+J79JLr8bQ/Z26005lm
         dhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6OfwHc1CUnuze+sIKYDwiSSMcP1Mnt94yrNdzONXMc=;
        b=VBiwTbxTVrytXR7yNd4hgoIB2QRWFpVm53i6xXIIGhMcHgNcI9r/HgBqZ318aBWBvP
         acpxxMJUXrr6t9QIiSCaWXDFI36izOd8MZAXKV603nglIstzLFCw6LdYYXNYH6GIVr2R
         oaO23gkUFSiXYWTiTU5MqjGIxFqMuo0C9NxEt31PIqeDOarBZzVJvsdE3Vl2eOwliWN6
         1O9Ulz1L4XRTlIJi5HpdwjzIXX9ZJadGMbckYuCnX1Rhd4EmE1/PxJMo9tlF6qKY6id7
         bHfRPk1zr7PVr3rab0HcbRyHF2q5LGCaX6AnjECoyzabw1h+4HG4coU/OYIRaVBntmfa
         9wzw==
X-Gm-Message-State: AOAM5329Dt+8/vbf5o6SoRflk9Bw4n9GJfWvIMnt3FStkqKZ6tSIl6A+
        yqo6B/YlAhQONuVbdGlXqTtBOQ==
X-Google-Smtp-Source: ABdhPJyoVuq3nY/icnfkE0mrabkzzFBuuTfwE9NxFbO6a8QayKjQV5IZB1bxXI2yG/S0i+cPYI2Vfw==
X-Received: by 2002:a37:6846:: with SMTP id d67mr840329qkc.219.1610994535549;
        Mon, 18 Jan 2021 10:28:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id u5sm11368459qka.86.2021.01.18.10.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 10:28:54 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l1ZGo-0031bp-7D; Mon, 18 Jan 2021 14:28:54 -0400
Date:   Mon, 18 Jan 2021 14:28:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        target-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, bostroesser@gmail.com, ddiss@suse.de,
        bvanassche@acm.org
Subject: Re: [PATCH v6 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free()
 warning
Message-ID: <20210118182854.GJ4605@ziepe.ca>
References: <20210118163006.61659-1-dgilbert@interlog.com>
 <20210118163006.61659-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118163006.61659-2-dgilbert@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 18, 2021 at 11:30:03AM -0500, Douglas Gilbert wrote:

> After several flawed attempts to detect overflow, take the fastest
> route by stating as a pre-condition that the 'order' function argument
> cannot exceed 16 (2^16 * 4k = 256 MiB).

That doesn't help, the point of the overflow check is similar to
overflow checks in kcalloc: to prevent the routine from allocating
less memory than the caller might assume.

For instance ipr_store_update_fw() uses request_firmware() (which is
controlled by userspace) to drive the length argument to
sgl_alloc_order(). If userpace gives too large a value this will
corrupt kernel memory.

So this math:

  	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);

Needs to be checked, add a precondition to order does not help. I
already proposed a straightforward algorithm you can use.

Jason
