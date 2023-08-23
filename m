Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8374EEE4993
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 08:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbjHWIkk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 04:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbjHWIiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 04:38:08 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9871FC2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 01:36:35 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230823083633epoutp01043a4b79f01f66ac24df42ff162d91c2~99kDzCe_Y3186031860epoutp01F
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 08:36:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230823083633epoutp01043a4b79f01f66ac24df42ff162d91c2~99kDzCe_Y3186031860epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692779793;
        bh=a8tqca0kcrzm8r/KJktDPGP+qh4VKMacXwGLktdVDYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BaLoa8YBtH47R6/yS9nh5iIaiFk2erJxNKbRe5ge4F2un1n56Dj1cHw6wfNeOlBtK
         veeQg1JlUzpYIGb6SEkT7rV+OmX83V5VaH7grEq0eyMUjAiKhni2ToE6lwqbzWIJHu
         n4EPAr92lu+CSVD2yrj1OOZv8zZq0FsJcxg469LI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230823083633epcas5p1eae6e11b6ba401f5be945affa66efdbc~99kDZoBUr0862308623epcas5p1J;
        Wed, 23 Aug 2023 08:36:33 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RW01W3NnTz4x9Q7; Wed, 23 Aug
        2023 08:36:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.1E.57354.F05C5E46; Wed, 23 Aug 2023 17:36:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230823081251epcas5p16545cf117a351f29bb71db2340e17621~99PXR0OnP2485724857epcas5p1V;
        Wed, 23 Aug 2023 08:12:51 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230823081251epsmtrp2995d804ad39c64196c4794dd4df591ec~99PXMfk-i0375403754epsmtrp2w;
        Wed, 23 Aug 2023 08:12:51 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-a1-64e5c50f977b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.5D.64355.38FB5E46; Wed, 23 Aug 2023 17:12:51 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230823081250epsmtip1f661078e2f458457afa9927c7eb64a9b~99PV9TyIU2121921219epsmtip1o;
        Wed, 23 Aug 2023 08:12:50 +0000 (GMT)
Date:   Wed, 23 Aug 2023 13:39:32 +0530
From:   Nitesh Shetty <nj.shetty@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v11 02/16] block: Only use write locking if necessary
Message-ID: <20230823080932.u2ctysyzchl23kog@green245>
MIME-Version: 1.0
In-Reply-To: <20230822191822.337080-3-bvanassche@acm.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmhi7/0acpBlOmSlqsvtvPZjHtw09m
        iwf77S1Wrj7KZLH3lrZF9/UdbBbLj/9jsjg0uZnJgcPj8hVvj8tnSz02repk89h9s4HN4+PT
        Wywe7/ddZfP4vEkugD0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
        VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66
        Xl5qiZWhgYGRKVBhQnbGtJdvWQom8FTsOPWNvYFxJ1cXIyeHhICJxIQJf5i7GLk4hAR2M0oc
        aO1ggXA+MUr8nj+PHaQKzLlxIQ+mY/LBT1BFOxkl3pzfygjhPGOUuL3jLCNIFYuAqkTXlU7W
        LkYODjYBbYnT/zlAwiICGhLfHiwHa2YW+MEosXDDPxaQGmEBT4nFsyVATF4BM4m7fTog5bwC
        ghInZz5hAbE5BSwlvm6cAzZdVEBGYsbSr2BXSwh0ckgsajjJCHGci8TS7j42CFtY4tXxLewQ
        tpTE53d7oeLlEiunrGCDaG5hlJh1fRZUs71E66l+ZpAjmAUyJHa8gqqXlZh6ah0TiM0swCfR
        +/sJE0ScV2LHPBhbWWLN+gVQ9ZIS1743QtkeEpfWgYIBGrxHdvxjncAoPwvJc7MQ1s0CW2El
        0fmhiRUiLC2x/B8HhKkpsX6X/gJG1lWMkqkFxbnpqcmmBYZ5qeXw6E7Oz93ECE6uWi47GG/M
        /6d3iJGJg/EQowQHs5IIr/T3hylCvCmJlVWpRfnxRaU5qcWHGE2BMTWRWUo0OR+Y3vNK4g1N
        LA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamC62O0Z9fELz87jfStKFl8S
        t3r/w2S7RK+2QbBTSbRek7Gajtjs3t8hJw/Pz54rEHD4/tIHT83DDH7G27ltyji10YTL33Fz
        s47x3hmTNe/66Ms2bLjRt62FxdTq5cazvMWVBt0fd724L7zDfbHM9hs+aepXVhm7r2mZ9uiH
        FLt+r+P3hzbGr8UUzzCeTuaYWftaMTNOb09BsEvzotNZz1yP7J45a79Az+NoiSuPKqulO3Nj
        m45eT3i9jPuZafHPey2H4+Rtth6ozHg5qfZPpt2PGFN/T9fZLyrWP1nMof8qYtHWOwvydxyf
        sfVK/4lUad2VqUd2Ll+elD+BR+FrwrE1zSuav5z95O6/weJ0ofw5JZbijERDLeai4kQADhk9
        aTcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnG7z/qcpBrs3SFusvtvPZjHtw09m
        iwf77S1Wrj7KZLH3lrZF9/UdbBbLj/9jsjg0uZnJgcPj8hVvj8tnSz02repk89h9s4HN4+PT
        Wywe7/ddZfP4vEkugD2KyyYlNSezLLVI3y6BK6P5xhu2gkOcFQ/2n2dpYGzl6GLk5JAQMJGY
        fPATSxcjF4eQwHZGiZe7TzBCJCQllv09wgxhC0us/PecHcQWEnjCKPHniAaIzSKgKtF1pZO1
        i5GDg01AW+L0f7CZIgIaEt8eLAebySzwi1Fizt95jCA1wgKeEotnS4CYvAJmEnf7dCAmpkv0
        vHnFBGLzCghKnJz5hAXEZgYqmbf5ITNIObOAtMTyf2DTOQUsJb5unAN2pKiAjMSMpV+ZJzAK
        zkLSPQtJ9yyE7gWMzKsYRVMLinPTc5MLDPWKE3OLS/PS9ZLzczcxgmNBK2gH47L1f/UOMTJx
        MB5ilOBgVhLhlf7+MEWINyWxsiq1KD++qDQntfgQozQHi5I4r3JOZwrQ+YklqdmpqQWpRTBZ
        Jg5OqQYm/pi3e38s51n4P/Mv06vfTxwCnk1lerv0e+zlnfVOF+afuOyrzBCy5H7wfMXA/V++
        zt5sd2/vvCXfn5+UYLVt9XhtfCflH4tnNU9ElPFhhbpvFuEZmW2XZJd9tnp9sPTSCst1s2r/
        NLH9yStV97Q2VS53y+Zdsjjh8dVov2t7Fdhun7g57Vnnc9k0j3cHt141nj5LRO7Oyylnpjsc
        ffVw8rq0FJeIjIlFWTN313cuk+neMSffLTHN29FMP/eEnLZf8HUxAYU1J3x1uSZrsGuXsxdI
        f3ns5ObpIFW67/3lOUzdabY+PfOq0642562czSXnXcH4MORc2e3fkjargpkVHy7Xv33neOjJ
        6lVTVY+uVmIpzkg01GIuKk4EACAM8ev0AgAA
X-CMS-MailID: 20230823081251epcas5p16545cf117a351f29bb71db2340e17621
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8085d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230823081251epcas5p16545cf117a351f29bb71db2340e17621
References: <20230822191822.337080-1-bvanassche@acm.org>
        <20230822191822.337080-3-bvanassche@acm.org>
        <CGME20230823081251epcas5p16545cf117a351f29bb71db2340e17621@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8085d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/08/22 12:16PM, Bart Van Assche wrote:
>Make blk_req_needs_zone_write_lock() return false if
>q->limits.use_zone_write_lock is false.
>
>Cc: Damien Le Moal <dlemoal@kernel.org>
>Cc: Christoph Hellwig <hch@lst.de>
>Cc: Ming Lei <ming.lei@redhat.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
> block/blk-zoned.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>index 112620985bff..d8a80cce832f 100644
>--- a/block/blk-zoned.c
>+++ b/block/blk-zoned.c
>@@ -53,11 +53,16 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond)
> EXPORT_SYMBOL_GPL(blk_zone_cond_str);
>
> /*
>- * Return true if a request is a write requests that needs zone write locking.
>+ * Return true if a request is a write request that needs zone write locking.
>  */
> bool blk_req_needs_zone_write_lock(struct request *rq)
> {
>-	if (!rq->q->disk->seq_zones_wlock)
>+	struct request_queue *q = rq->q;
>+
>+	if (!q->limits.use_zone_write_lock)
>+		return false;
>+
>+	if (!q->disk->seq_zones_wlock)
> 		return false;
>
> 	return blk_rq_is_seq_zoned_write(rq);

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8085d_
Content-Type: text/plain; charset="utf-8"


------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8085d_--
