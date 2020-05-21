Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063B3C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 19:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D751520829
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 19:57:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="Oz9GsFMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgEUT5D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 15:57:03 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17071 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbgEUT5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 15:57:02 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec6dc7d0003>; Thu, 21 May 2020 12:54:37 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 21 May 2020 12:57:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 21 May 2020 12:57:02 -0700
Received: from [10.2.48.182] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 May
 2020 19:57:02 +0000
Subject: Re: [PATCH] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
To:     Bart Van Assche <bvanassche@acm.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <20200519045525.2446851-1-jhubbard@nvidia.com>
 <494478b6-9a8c-5271-fc9f-fd758af850c0@acm.org>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <2fa00c72-5ffb-9bc6-df25-a87a863a6d62@nvidia.com>
Date:   Thu, 21 May 2020 12:57:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <494478b6-9a8c-5271-fc9f-fd758af850c0@acm.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590090878; bh=7cEuukJFvnz/9s6hpg5DMIacgnLOUaLP+0TTObIGU0E=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Oz9GsFMn6PDszwZOpTHP8j0on3bP6QhuGuI5OfQ1/usrvgl/0ZltkNhRDvZlsuX7e
         +bAew0LRexR2r3tx+KqUK2NTqK8ZAfqdYLv3fSwlhAYX9TxnGDO7AyX37kM4FpPQ8C
         WZ/jP32uAcF828jC/kiHHhTwd/ter9jtVF2qHk1H12MnTdFj2uBBLnlah8uqX/uMnj
         C7ze0nRYN4iv0ayhjZMYdKZS4eoPOOPEv9epeYagx2WrJeLiAktdWLuya1+zwutagg
         sMRHyq0voBxMMHf+7jBkWrl4v52YrdcQgmZNRst1vVUOA6Cjl1C8XagQvzWAx+XrIf
         gjSncIN+F7GUg==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-21 12:47, Bart Van Assche wrote:
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
>>      https://lwn.net/Articles/807108/
>>
>> [3] https://lore.kernel.org/r/20190723153640.GB720@lst.de
> 
> Kai, why is the st driver calling get_user_pages_fast() directly instead
> of calling blk_rq_map_user()? blk_rq_map_user() is already used in
> st_scsi_execute(). I think that the blk_rq_map_user() implementation is
> also based on get_user_pages_fast(). See also iov_iter_get_pages_alloc()
> in lib/iov_iter.c.
> 
> John, why are the get_user_pages_fast() calls in the st driver modified
> but not the blk_rq_map_user() call? Are you sure that the modified code
> is a "case 2" scenario and not a "case 1" scenario?
> 

No, I am not sure. I thought this was a DMA case (I'm not a SCSI Tape user,
so it *seemed* reasonable that a DMA engine was involved), but if it's really
direct IO, then we need to just drop this patch entirely. Because: I need to
convert the block/biovec code, including iov_iter_get_pages_alloc() and
friends, in order to handle direct IO. I'm working on that but it's not
ready yet.

(I was trying to get the smaller, non-direct-IO cases converted first.)

Thanks for spotting the discrepancy, and apologies for the confusion on this
end.

Also, I doubt if it's worth it, but do you want a patch to change SetPageDirty()
to set_page_dirty_lock(), meanwhile? It seems like if that's never come up, then
it's mostly a theoretical bug.

thanks,
-- 
John Hubbard
NVIDIA
