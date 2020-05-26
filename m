Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C28C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 18:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4486120849
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 18:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="LAG0RTcU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgEZSPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 14:15:31 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5247 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgEZSPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 14:15:31 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ecd5c6a0000>; Tue, 26 May 2020 11:14:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 26 May 2020 11:15:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 26 May 2020 11:15:31 -0700
Received: from [10.2.50.17] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 May
 2020 18:15:30 +0000
Subject: Re: [PATCH] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
To:     =?UTF-8?Q?Kai_M=c3=a4kisara_=28Kolumbus=29?= 
        <kai.makisara@kolumbus.fi>, Bart Van Assche <bvanassche@acm.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <20200519045525.2446851-1-jhubbard@nvidia.com>
 <494478b6-9a8c-5271-fc9f-fd758af850c0@acm.org>
 <C1CFE522-CEA6-4130-9433-73243BC00782@kolumbus.fi>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <53ba75b6-4be5-c7be-20dd-808bee4e2edc@nvidia.com>
Date:   Tue, 26 May 2020 11:15:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <C1CFE522-CEA6-4130-9433-73243BC00782@kolumbus.fi>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590516842; bh=ITrBk0mwFknMEnMyRIIkjye5WudIVKIIO8gi/LbyLRU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=LAG0RTcUUsqxn4QiFdC4v8bQJmj2Q7lY1QgJ1FMrFaQl3qWv5JsNyT1w4ULWiH6ba
         TBnnN6Vy7ErSTpnLEFWNIS20tZzw0IvHvUn0ei5VUkcRXwiAYy6J0mwjrb73W9/jBm
         cCfLGFpv/Yodc9Ykss6K2vpehWs+6OE0NIrTWRrrB12tDxxfqfUQIXUv4Ix1t1hpnW
         sfpUNT7PRHN9dlB0WxTLmjcc5yMYYAhreQCkVXnYVmSYEhzVN5bm1ikIH4ySr1O+af
         Ia4DPipNOdWxTwxqr003YrJ5baOeBls2Vavf7CUbGnB82VQ+ABVumZBUtExn1A4JoT
         /iZQHh9mv1yXA==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-22 01:32, "Kai M=C3=A4kisara (Kolumbus)" wrote:
>> On 21. May 2020, at 22.47, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 2020-05-18 21:55, John Hubbard wrote:
>>> This code was using get_user_pages*(), in a "Case 2" scenario
>>> (DMA/RDMA), using the categorization from [1]. That means that it's
>>> time to convert the get_user_pages*() + put_page() calls to
>>> pin_user_pages*() + unpin_user_pages() calls.
>>>
>>> There is some helpful background in [2]: basically, this is a small
>>> part of fixing a long-standing disconnect between pinning pages, and
>>> file systems' use of those pages.
>>>
>>> Note that this effectively changes the code's behavior as well: it now
>>> ultimately calls set_page_dirty_lock(), instead of SetPageDirty().This
>>> is probably more accurate.
>>>
>>> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
>>> dealing with a file backed page where we have reference on the inode it
>>> hangs off." [3]
>>>
>>> Also, this deletes one of the two FIXME comments (about refcounting),
>>> because there is nothing wrong with the refcounting at this point.
>>>
>>> [1] Documentation/core-api/pin_user_pages.rst
>>>
>>> [2] "Explicit pinning of user-space pages":
>>>     https://lwn.net/Articles/807108/
>>>
>>> [3] https://lore.kernel.org/r/20190723153640.GB720@lst.de
>>
>> Kai, why is the st driver calling get_user_pages_fast() directly instead
>> of calling blk_rq_map_user()? blk_rq_map_user() is already used in
>> st_scsi_execute(). I think that the blk_rq_map_user() implementation is
>> also based on get_user_pages_fast(). See also iov_iter_get_pages_alloc()
>> in lib/iov_iter.c.
>>
> The reason is that the blk_ functions were not available when that part
> of the code was done. Nobody has converted that to use the more
> modern functions because the old method still works.
>=20


Hi Kai, Bart,

Say, thinking about this some more, it seems like: as only sgl_unmap_user_p=
ages()
is allowed to release the pages that were pinned in sgl_map_user_pages(), t=
hen
this is a clear case of Direct IO (not DMA/RDMA, as I first thought) that n=
eeds
to be handled via pin_user_pages_fast().

I'll send a v2 with the commit log updated to refer to Direct IO, because t=
his
does still apply, after all.

thanks,
--=20
John Hubbard
NVIDIA
