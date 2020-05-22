Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB032C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B986C206C3
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgEVIsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 04:48:42 -0400
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:24064 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728959AbgEVIsm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 May 2020 04:48:42 -0400
Received: from imac.makisara.private (85-131-115-176.bb.dnainternet.fi [85.131.115.176])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
        id ca2c9ed3-9c06-11ea-ba22-005056bd6ce9;
        Fri, 22 May 2020 11:32:36 +0300 (EEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <494478b6-9a8c-5271-fc9f-fd758af850c0@acm.org>
Date:   Fri, 22 May 2020 11:32:36 +0300
Cc:     John Hubbard <jhubbard@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C1CFE522-CEA6-4130-9433-73243BC00782@kolumbus.fi>
References: <20200519045525.2446851-1-jhubbard@nvidia.com>
 <494478b6-9a8c-5271-fc9f-fd758af850c0@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 21. May 2020, at 22.47, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> On 2020-05-18 21:55, John Hubbard wrote:
>> This code was using get_user_pages*(), in a "Case 2" scenario
>> (DMA/RDMA), using the categorization from [1]. That means that it's
>> time to convert the get_user_pages*() + put_page() calls to
>> pin_user_pages*() + unpin_user_pages() calls.
>> 
>> There is some helpful background in [2]: basically, this is a small
>> part of fixing a long-standing disconnect between pinning pages, and
>> file systems' use of those pages.
>> 
>> Note that this effectively changes the code's behavior as well: it now
>> ultimately calls set_page_dirty_lock(), instead of SetPageDirty().This
>> is probably more accurate.
>> 
>> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
>> dealing with a file backed page where we have reference on the inode it
>> hangs off." [3]
>> 
>> Also, this deletes one of the two FIXME comments (about refcounting),
>> because there is nothing wrong with the refcounting at this point.
>> 
>> [1] Documentation/core-api/pin_user_pages.rst
>> 
>> [2] "Explicit pinning of user-space pages":
>>    https://lwn.net/Articles/807108/
>> 
>> [3] https://lore.kernel.org/r/20190723153640.GB720@lst.de
> 
> Kai, why is the st driver calling get_user_pages_fast() directly instead
> of calling blk_rq_map_user()? blk_rq_map_user() is already used in
> st_scsi_execute(). I think that the blk_rq_map_user() implementation is
> also based on get_user_pages_fast(). See also iov_iter_get_pages_alloc()
> in lib/iov_iter.c.
> 
The reason is that the blk_ functions were not available when that part
of the code was done. Nobody has converted that to use the more
modern functions because the old method still works.

Thanks,
Kai

