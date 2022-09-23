Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C99CC6FA82
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 15:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiIWPN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 11:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiIWPNe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 11:13:34 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B29F13571C
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 08:13:26 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220923151324euoutp018fcbb611c5bf4667bf9f3acf890d0e12~XhhMh2xeC3240132401euoutp01i
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 15:13:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220923151324euoutp018fcbb611c5bf4667bf9f3acf890d0e12~XhhMh2xeC3240132401euoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663946004;
        bh=PbaKVH+mq65Axg6jk4sDVyJCePjLdPZHFFHJqJEkjcc=;
        h=Date:Subject:To:CC:From:In-Reply-To:References:From;
        b=NEfKNNk8NvcLHFjfDfAJZH6kCBQ399MRKhfWaw7oVyWD+TAz6pgdzzR8RcJ+baNNg
         ByBabXD67M3w70CgiAhl18QpCsQXD6JvL55MU3ug5gKJ/fl+XC1u3BysNpCcsMgY+U
         ehSx2l657TNyQfg8w7xenGJGZ3a1uXGu2jI4V/nE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220923151323eucas1p2c3c02010f5d671894c4050c21e665e18~XhhMTRtld1569215692eucas1p2W;
        Fri, 23 Sep 2022 15:13:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 8B.21.29727.31DCD236; Fri, 23
        Sep 2022 16:13:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220923151323eucas1p2b38577ffa0c445120d086e5eb5c4b306~XhhLpt7Mo2402124021eucas1p26;
        Fri, 23 Sep 2022 15:13:23 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220923151323eusmtrp22258127ff30a888aafae215e8136c5e6~XhhLo5p_Y2350823508eusmtrp2k;
        Fri, 23 Sep 2022 15:13:23 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-c3-632dcd13ebde
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 87.DF.07473.21DCD236; Fri, 23
        Sep 2022 16:13:22 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220923151322eusmtip186acab0d3c79ccf624463b80d53dead2~XhhLbpa6q1469214692eusmtip1g;
        Fri, 23 Sep 2022 15:13:22 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.168) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Fri, 23 Sep 2022 16:13:20 +0100
Message-ID: <c7b76fa1-f7e3-3ac6-c92d-35baa0d9a40a@samsung.com>
Date:   Fri, 23 Sep 2022 17:13:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
        Thunderbird/91.11.0
Subject: Re: [PATCH 1/5] block: enable batched allocation for
 blk_mq_alloc_request()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <joshi.k@samsung.com>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>
From:   Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220923145236.pr7ssckko4okklo2@quentin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [106.210.248.168]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsWy7djP87rCZ3WTDX526VmsvtvPZjHtw09m
        i99nzzNb7L2lbTF/2VN2i+7rO9gs1tx8yuLA7nH5irfHzll3gYyzpR6bl9R77Gy9z+rxeZNc
        AFsUl01Kak5mWWqRvl0CV8aPfetZCqYKVvQs+cXawHiLt4uRk0NCwESiY9lL5i5GLg4hgRWM
        EttmNLOCJIQEvjBK7FtYBJH4zChxYvISVpiO/Q9Os0MkljNK/Jq5ghGu6tLS+1CzdjNKdHz8
        wwTSwitgJ3Gj9SoziM0ioCrxZ+8GZoi4oMTJmU9YQGxRgUiJNbvPsoPYwgJhEvvfrwXrZRYQ
        l7j1ZD6YLSIQKnGn6TkbyAJmgeOMEvfPXQW6iYODTUBLorETrJdTwEziwvWjLBC9mhKt23+z
        Q9jyEtvfzmGGeEFZYvnpmVB2rcTaY2fA3pEQaOaUaD34gR0i4SJx9d0hqJ+FJV4d3wIVl5H4
        vxPiIAmBaomnN34zQzS3MEr071zPBnKQhIC1RN+ZHIgaR4n++zOhwnwSN94KQtzDJzFp23Tm
        CYyqs5CCYhaSl2cheWEWkhcWMLKsYhRPLS3OTU8tNsxLLdcrTswtLs1L10vOz93ECExFp/8d
        /7SDce6rj3qHGJk4GA8xSnAwK4nwzr6jmSzEm5JYWZValB9fVJqTWnyIUZqDRUmcl22GVrKQ
        QHpiSWp2ampBahFMlomDU6qBSXe5WJLcJOFVDN6/12YoL+piPvM1mcHzX4Zyb7iu5fSadsnV
        B/44rJu40yWcWXOVwZ6bXdNjBZp3ZWtv+VI44ZdizlSeleo3nueGaV2cl3uv4WyggdOls5OL
        Npaz2KYvDntXzfBDd9YCu4jlZTrCneXcMg73uv5MPL075pJ+3grnkO38Qn+bFM3WFL0Jem0u
        0u9U9Ozz1+fzH1xhnNX48ZlFvbwp56tMBldHnn9dBfd+5ceHObq132ZyOsZ9ee/zjVtq/sgV
        P23ReVB34diKXr+l9TOYj3DGzroxZen+ua8P3FTtqT3NICPep/K7P3niBpZ5uXVTNJ9K6mUw
        3zWT2R7xmWPeKqYsjzD5zRr3lFiKMxINtZiLihMBVgfjqrQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t/xu7pCZ3WTDXY9sbFYfbefzWLah5/M
        Fr/Pnme22HtL22L+sqfsFt3Xd7BZrLn5lMWB3ePyFW+PnbPuAhlnSz02L6n32Nl6n9Xj8ya5
        ALYoPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsEvYwf
        +9azFEwVrOhZ8ou1gfEWbxcjJ4eEgInE/gen2bsYuTiEBJYySrSd3sICkZCR+HTlIzuELSzx
        51oXG0TRR0aJz1s3skA4uxklDh78B9bBK2AncaP1KjOIzSKgKvFn7wZmiLigxMmZT8BqRAUi
        JR4ua2ICsYUFwiT2v18LZjMLiEvcejIfzBYRCJW40/QcbBuzwHFGifvnrrKCJIQE7jNKtO9x
        6GLk4GAT0JJo7AS7jlPATOLC9aMsEHM0JVq3/2aHsOUltr+dwwzxgbLE8tMzoexaiVf3dzNO
        YBSdheS8WUjOmIVk1CwkoxYwsqxiFEktLc5Nzy021CtOzC0uzUvXS87P3cQIjOBtx35u3sE4
        79VHvUOMTByMhxglOJiVRHhn39FMFuJNSaysSi3Kjy8qzUktPsRoCgyjicxSosn5wBSSVxJv
        aGZgamhiZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXAxPV3d91Oj5MNqWofH+hL
        5d40YmWZUsretL5ouozOKVW9O2tK2xxWqTme05mw5cwv2Z/SB+0X7+iws5741JdhyWL+C1Gm
        vVETvjsVVrKduH3mQduvb1t3sbswe/IdDk58OWvj15CkK47sajGR7jsOrPZuS0uYv35b7rH3
        XFHLly19mrlVbKHB229X0wTNQ63yTA4cnyXT0p9UvSZGYPX2r+cuPUz4KLW96P+kmadCHcoy
        Lpe6r9lb3Vryq9q9RvPlZe/TVk4uRQJXpCI7XmSu7k7eXRtx/bTXnLt/5aaYKXNIJKrPcXn6
        4tFJZzmzQr7JS64v6pmsZrgwt7ZYbaXR0X+TdSP3T68JuWR9b6+zlRJLcUaioRZzUXEiACXE
        TSNpAwAA
X-CMS-MailID: 20220923151323eucas1p2b38577ffa0c445120d086e5eb5c4b306
X-Msg-Generator: CA
X-RootMTR: 20220923145245eucas1p107655755f446bb1e1318539a3f82d301
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923145245eucas1p107655755f446bb1e1318539a3f82d301
References: <20220922182805.96173-1-axboe@kernel.dk>
        <20220922182805.96173-2-axboe@kernel.dk>
        <CGME20220923145245eucas1p107655755f446bb1e1318539a3f82d301@eucas1p1.samsung.com>
        <20220923145236.pr7ssckko4okklo2@quentin>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-09-23 16:52, Pankaj Raghav wrote:
> On Thu, Sep 22, 2022 at 12:28:01PM -0600, Jens Axboe wrote:
>> The filesystem IO path can take advantage of allocating batches of
>> requests, if the underlying submitter tells the block layer about it
>> through the blk_plug. For passthrough IO, the exported API is the
>> blk_mq_alloc_request() helper, and that one does not allow for
>> request caching.
>>
>> Wire up request caching for blk_mq_alloc_request(), which is generally
>> done without having a bio available upfront.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  block/blk-mq.c | 80 ++++++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 71 insertions(+), 9 deletions(-)
>>
> I think we need this patch to ensure correct behaviour for passthrough:
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c11949d66163..840541c1ab40 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1213,7 +1213,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
>         WARN_ON(!blk_rq_is_passthrough(rq));
>  
>         blk_account_io_start(rq);
> -       if (current->plug)
> +       if (blk_mq_plug(rq->bio))
>                 blk_add_rq_to_plug(current->plug, rq);
>         else
>                 blk_mq_sched_insert_request(rq, at_head, true, false);
> 
> As the passthrough path can now support request caching via blk_mq_alloc_request(),
> and it uses blk_execute_rq_nowait(), bad things can happen at least for zoned
> devices:
> 
> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
> {
> 	/* Zoned block device write operation case: do not plug the BIO */
> 	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
> 		return NULL;
> ..

Thinking more about it, even this will not fix it because op is
REQ_OP_DRV_OUT if it is a NVMe write for passthrough requests.

@Damien Should the condition in blk_mq_plug() be changed to:

static inline struct blk_plug *blk_mq_plug( struct bio *bio)
{
	/* Zoned block device write operation case: do not plug the BIO */
	if (bdev_is_zoned(bio->bi_bdev) && !op_is_read(bio_op(bio)))
		return NULL;
> 
> Am I missing something?
