Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED932EE4993
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 08:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbjHWIkf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 04:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbjHWIiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 04:38:08 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0641FC4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 01:36:38 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230823083636epoutp03af8e85719a80401faca1efec74e3c95f~99kGLdqhK1316013160epoutp03I
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 08:36:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230823083636epoutp03af8e85719a80401faca1efec74e3c95f~99kGLdqhK1316013160epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692779796;
        bh=ESu4nDtgY24wjzpsjVdzrkqnUaBAw3M2WxLUuVFiqIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hTJj5HGK6FUsRxA6XlcS7ZWTIBlrBXB+hLtOf3mIh0Nwq3CpIKRP6h9EF72xfiyEc
         JgY9Qp/6+ggO89lJz61vvwCpmCWnYEhQeUbM8vbO4s9VSUw2AuvhKxxC29F/IAp7cu
         PaKKy2hARV0b0Yam1jlInn1WJkbXL3jzwz+RK7vY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230823083635epcas5p17634551504b8af061c0be5bc982ab9a3~99kFw0ATs1884318843epcas5p1F;
        Wed, 23 Aug 2023 08:36:35 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RW01Z1kh2z4x9Q0; Wed, 23 Aug
        2023 08:36:34 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.1E.57354.215C5E46; Wed, 23 Aug 2023 17:36:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230823082642epcas5p4ed07cdc043b208f2efff460cf023b264~99bddHknF3262332623epcas5p4B;
        Wed, 23 Aug 2023 08:26:42 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230823082642epsmtrp10097a49e0ccedfc814376a4e81ccc637~99bdcaLPm3071430714epsmtrp1K;
        Wed, 23 Aug 2023 08:26:42 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-ac-64e5c5126885
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.5B.14748.2C2C5E46; Wed, 23 Aug 2023 17:26:42 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230823082641epsmtip1695cb3b9d6583bf32c6aa11a6e647912~99bcIWKsD2682726827epsmtip1j;
        Wed, 23 Aug 2023 08:26:41 +0000 (GMT)
Date:   Wed, 23 Aug 2023 13:53:23 +0530
From:   Nitesh Shetty <nj.shetty@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v11 03/16] block/mq-deadline: Only use zone locking if
 necessary
Message-ID: <20230823082323.grcj3iqoi2r5c5nx@green245>
MIME-Version: 1.0
In-Reply-To: <20230822191822.337080-4-bvanassche@acm.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmpq7Q0acpBl1NPBar7/azWUz78JPZ
        4sF+e4uVq48yWey9pW3RfX0Hm8Xy4/+YLA5NbmZy4PC4fMXb4/LZUo9NqzrZPHbfbGDz+Pj0
        FovH+31X2Tw+b5ILYI/KtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
        VXLxCdB1y8wBukhJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeu
        l5daYmVoYGBkClSYkJ0xa0s3e8EaropNZ3exNjC+4Ohi5OSQEDCRmH3xPDuILSSwm1Fi/v+y
        LkYuIPsTo8TyaUeYIZxvjBI3X0xi7GLkAOtYNY0XIr6XUWLF1bNMEM4zRonJHX1sIKNYBFQl
        TnbdZwdpYBPQljj9H2ybiICGxLcHy1lA6pkFfjBKLNzwjwUkISwQJvHtw1RWEJtXwExi1e3F
        7BC2oMTJmU/AajgFLCVmv3rICGKLCshIzFj6Few6CYGJHBKnl05igvjHRaJh0VlWCFtY4tXx
        LewQtpTEy/42KLtcYuWUFWwQzS2MErOuz2KESNhLtJ7qZwaxmQUyJJ48vcgCEZeVmHpqHRNE
        nE+i9/cTqGW8EjvmwdjKEmvWL2CDsCUlrn1vhLI9JDYduA4NR2AAv1h5j3kCo/wsJN/NQrIP
        wraS6PzQxDoLGHrMAtISy/9xQJiaEut36S9gZF3FKJlaUJybnppsWmCYl1oOj/Hk/NxNjOAU
        q+Wyg/HG/H96hxiZOBgPMUpwMCuJ8Ep/f5gixJuSWFmVWpQfX1Sak1p8iNEUGFsTmaVEk/OB
        ST6vJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB9MSS1OzU1ILUIpg+Jg5OqQYmfTPXJe78Qfcj
        FzGVKL3JTdV79atZ78b+7jnPd/hXyhw3UZc5G+Arf3eylFVf6TL2VYa3F9UGfQ9QfOkWdS00
        TZR5y/TaVXuXnkuOmHrKLjZPlWeD3uTIw69MT62pvezDefKMh9qP4h9H0j9tSPQOaflgEd+3
        POb5Nd2YEBOZYn3ee8/DLZZfvrGjh+Gi5iQdG5WI9W8Dtq8U+n6dyW2p5Co+HndN0cnXlm2f
        Inj6/fWN5rsr7zM4q564GPt3RsaJeec/vXCXtZ2lm7Yqcs915eiZmn7zhAUeN/AXbxVYvdTw
        Z/Ge+y6XFzMtDrT19+3K4Fu4/qeQqoz0DXP58vTIm39WaDbynrqbv/DoIvnvSizFGYmGWsxF
        xYkA8DbkrjoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnO6hQ09TDOb+1bVYfbefzWLah5/M
        Fg/221usXH2UyWLvLW2L7us72CyWH//HZHFocjOTA4fH5SveHpfPlnpsWtXJ5rH7ZgObx8en
        t1g83u+7yubxeZNcAHsUl01Kak5mWWqRvl0CV8b2l1YF99grTv9rYWxg3MLWxcjBISFgIrFq
        Gm8XIxeHkMBuRok/xxeydzFyAsUlJZb9PcIMYQtLrPz3HCwuJPCEUeL0HAsQm0VAVeJk1312
        kDlsAtoSp/9zgIRFBDQkvj1YzgIyk1ngF6PEnL/zGEESwgJhEt8+TGUFsXkFzCRW3V4M1isk
        kC7R/LkOIiwocXLmExYQmxmoZN7mh8wgJcwC0hLL/4GN5xSwlJj96iHYRFEBGYkZS78yT2AU
        nIWkexaS7lkI3QsYmVcxSqYWFOem5yYbFhjmpZbrFSfmFpfmpesl5+duYgRHhJbGDsZ78//p
        HWJk4mA8xCjBwawkwiv9/WGKEG9KYmVValF+fFFpTmrxIUZpDhYlcV7DGbNTgD5ILEnNTk0t
        SC2CyTJxcEo1MDU/rbf/KJKusCZL3eByzWHpifMKq/sqDxstt72v3P5u2ax/a+7l3T9hsfFB
        /JUPqR/iddytI4PW1nz4zTZzv+HWxesMnkT2bv5o2+rR/M3sXDXbjIMO3zz2KWb9yPilvbbs
        W4zq3uLJJ/Z4JHy02ab0LSm0b/abdEODJR0bJLk4MxfMrJpVNzvk3cSuNTEnv5Yd4Hb+dW3B
        JfX1jUJVCqHJPkbf93g8/T7jbkdWWLv87yKrjNyQJyV86Xvs5zUFHwjm0Nmr7DM/sXDWqXkX
        hFds8N5+w1NRU9Po9b2WpdzHA+4n1pg/384qE2v2ZHNxhFH1rhUvF07nrJ2zx6rrmJWfxeHf
        R5JFOndf37boxzolluKMREMt5qLiRAD9U1n+9wIAAA==
X-CMS-MailID: 20230823082642epcas5p4ed07cdc043b208f2efff460cf023b264
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----gE6680ZNUinvX0c6ClraybDZwn8mhhmyVsG0uFNlX7QT91ZL=_80af9_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230823082642epcas5p4ed07cdc043b208f2efff460cf023b264
References: <20230822191822.337080-1-bvanassche@acm.org>
        <20230822191822.337080-4-bvanassche@acm.org>
        <CGME20230823082642epcas5p4ed07cdc043b208f2efff460cf023b264@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

------gE6680ZNUinvX0c6ClraybDZwn8mhhmyVsG0uFNlX7QT91ZL=_80af9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/08/22 12:16PM, Bart Van Assche wrote:
>Measurements have shown that limiting the queue depth to one per zone for
>zoned writes has a significant negative performance impact on zoned UFS
>devices. Hence this patch that disables zone locking by the mq-deadline
>scheduler if the storage controller preserves the command order. This
>patch is based on the following assumptions:
>- It happens infrequently that zoned write requests are reordered by the
>  block layer.
>- The I/O priority of all write requests is the same per zone.
>- Either no I/O scheduler is used or an I/O scheduler is used that
>  serializes write requests per zone.
>
>Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>Cc: Christoph Hellwig <hch@lst.de>
>Cc: Ming Lei <ming.lei@redhat.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
> block/mq-deadline.c | 11 ++++++-----
> 1 file changed, 6 insertions(+), 5 deletions(-)
>

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------gE6680ZNUinvX0c6ClraybDZwn8mhhmyVsG0uFNlX7QT91ZL=_80af9_
Content-Type: text/plain; charset="utf-8"


------gE6680ZNUinvX0c6ClraybDZwn8mhhmyVsG0uFNlX7QT91ZL=_80af9_--
