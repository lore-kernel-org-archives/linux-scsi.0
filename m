Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA82EE4993
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 08:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjHWIkW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbjHWIiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 04:38:08 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6354B10EB
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 01:36:34 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230823083630epoutp0291f82df363d7bda1fa86b7426602ccbb~99kBBWQAE0455304553epoutp02A
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 08:36:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230823083630epoutp0291f82df363d7bda1fa86b7426602ccbb~99kBBWQAE0455304553epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692779790;
        bh=Ii8WoNaCJtIXgM9alRAZ493rkok15OWS8yABytABtw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tZk+p5viTTr0UFoefZH2SthLeIegIE+Um+bpCc9XmSr9Or13VOc79o9KSeeX7+9h7
         6y2r05d9Gxlt4GvyWUIb4lex9Vs3GzT7FLvmGUXqnaBBVJ1r0VVrvMjNOVEGaT6lG6
         bfwkrv604qiCRG2I60dDv9FyBKdjfEOso3GKHb3U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230823083630epcas5p3c12027568fa9c178f92dd0a35fba72ee~99kAr_OwI3073130731epcas5p3t;
        Wed, 23 Aug 2023 08:36:30 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RW01S3lwgz4x9Q2; Wed, 23 Aug
        2023 08:36:28 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.ED.44250.C05C5E46; Wed, 23 Aug 2023 17:36:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230823081141epcas5p334bc13e48a06ee3b518be9a33bc105d9~99OVs24XB2582625826epcas5p3Y;
        Wed, 23 Aug 2023 08:11:41 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230823081141epsmtrp2c794a1110177027b69a56b07425e22f7~99OVrPeGM0327903279epsmtrp2b;
        Wed, 23 Aug 2023 08:11:41 +0000 (GMT)
X-AuditID: b6c32a4a-c4fff7000000acda-ba-64e5c50cb73f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.4D.64355.C3FB5E46; Wed, 23 Aug 2023 17:11:41 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230823081139epsmtip1a5ef02a6acc827de23eee7c88be2d01e~99OUEEUX32123121231epsmtip1j;
        Wed, 23 Aug 2023 08:11:39 +0000 (GMT)
Date:   Wed, 23 Aug 2023 13:38:20 +0530
From:   Nitesh Shetty <nj.shetty@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v11 01/16] block: Introduce more member variables
 related to zone write locking
Message-ID: <20230823080820.oxgehloydemqg466@green245>
MIME-Version: 1.0
In-Reply-To: <20230822191822.337080-2-bvanassche@acm.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmli7P0acpBpM2ylisvtvPZjHtw09m
        iwf77S1Wrj7KZLH3lrZF9/UdbBbLj/9jsjg0uZnJgcPj8hVvj8tnSz02repk89h9s4HN4+PT
        Wywe7/ddZfP4vEkugD0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
        VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66
        Xl5qiZWhgYGRKVBhQnbGogvzWQvec1T8+XeNqYHxFnsXIweHhICJxL8J3l2MXBxCArsZJX5/
        /c0O4XxilOhY/JEZzlky8R1rFyMnWMeBJycYIRI7GSXW9j5ghXCeMUos/PCQHaSKRUBV4tC6
        Y2wgO9gEtCVO/+cACYsIaEh8e7CcBaSeWeAHUP2GfywgCWGBVIk/fT3MIDavgJnEh+9TmSBs
        QYmTM5+A1XAKWEpsbVvACGKLCshIzFj6Few8CYFeDonfm1pYIM5zkehe/R7qVGGJV8e3sEPY
        UhKf3+1lg7DLJVZOWcEG0dzCKDHr+ixGiIS9ROupfrArmAUyJC4ceAE1VFZi6ql1TBBxPone
        30+YIOK8EjvmwdjKEmvWL4BaIClx7XsjlO0h0XS2lxUexAc3NzJPYJSfheS7WUj2QdhWEp0f
        mlhnAUOPWUBaYvk/DghTU2L9Lv0FjKyrGCVTC4pz01OLTQuM8lLL4VGenJ+7iRGcZLW8djA+
        fPBB7xAjEwfjIUYJDmYlEV7p7w9ThHhTEiurUovy44tKc1KLDzGaAmNrIrOUaHI+MM3nlcQb
        mlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAtO5vgFH7ydsxE9pT0x5E
        OFxQvGdvGWszz6btF0tse+yhKco/At7mXZ/YPvvIlXPVc7pZVae9a2zO6D2lvO36wier26rm
        aX1w3m/Mk/DPdcHZfwZy0xjWr5efq9T6xv5FmN/VDDV1Ps2y2oXCP/5OjU0P8TBdbLCqvOwY
        l3Git8Klua9W8G4/fG5tE+defR2j5CssDNKeH8/fOXje4J/647C6xT+XKah8t0j/LWtvPmXR
        98mSqQk1l9qNWXOT9//uzSgOEbimOYd10v3cXK9JDJfDeqpM4kU8Eh6F5PDVeX8stDfNTJ3b
        eEE6u6QhNfVCzbwkU8bi46yHHGqFBDyrdPoVdSIu/hOX/PGYQ1+JpTgj0VCLuag4EQA3hScQ
        OwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSnK7t/qcpBncnMFqsvtvPZjHtw09m
        iwf77S1Wrj7KZLH3lrZF9/UdbBbLj/9jsjg0uZnJgcPj8hVvj8tnSz02repk89h9s4HN4+PT
        Wywe7/ddZfP4vEkugD2KyyYlNSezLLVI3y6BK2PmhQPMBQvZKk6c383WwLiMtYuRk0NCwETi
        wJMTjF2MXBxCAtsZJaa/OMEEkZCUWPb3CDOELSyx8t9zdhBbSOAJo8Ttu6EgNouAqsShdcfY
        uhg5ONgEtCVO/+cACYsIaEh8e7CcBWQms8AvRok5f+cxgiSEBVIlDm+YDDafV8BM4sP3qUwQ
        M9Ml5m1dygwRF5Q4OfMJC4jNDFQzb/NDZpD5zALSEsv/gc3nFLCU2Nq2AGykqICMxIylX5kn
        MArOQtI9C0n3LITuBYzMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGC40EraAfjsvV/9Q4x
        MnEwHmKU4GBWEuGV/v4wRYg3JbGyKrUoP76oNCe1+BCjNAeLkjivck5nCtD5iSWp2ampBalF
        MFkmDk6pBqapieHLz0WkFjs4bM2+wsjTaqm4fYHSDveHWtNLnDosZ1/jXnEtomAd756NRmd/
        WWv9/mycs/5UYMMbrdmbfhhxREx0WFH+4fLXRcGtqhx/GHO/Pha0emEa+tJy59E9MW8O2q6t
        +di7pmnG8a5NIVOmdi1+8H71Qvcnk0KePE90q9/iM/9BMnMT+/FHOe9y1klpyM0Wl2k5JTvv
        weeYzdkfwniKBZX4lqvtKwq/2bH289SvYQf0X8pGVa3dXzMt7OC2I/lPXmfEt3x18hJX+rf1
        XRCzWpK5bo9HqU/hp7QMy+8voth1nFiTbz1+I9Aq0/u9NmjZVCPOONuoQOa+WRP15peJlG6P
        2P5TRlGcb6ESS3FGoqEWc1FxIgCFL4Le9gIAAA==
X-CMS-MailID: 20230823081141epcas5p334bc13e48a06ee3b518be9a33bc105d9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8083f_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230823081141epcas5p334bc13e48a06ee3b518be9a33bc105d9
References: <20230822191822.337080-1-bvanassche@acm.org>
        <20230822191822.337080-2-bvanassche@acm.org>
        <CGME20230823081141epcas5p334bc13e48a06ee3b518be9a33bc105d9@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8083f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/08/22 12:16PM, Bart Van Assche wrote:
>Many but not all storage controllers require serialization of zoned writes.
>Introduce two new request queue limit member variables related to write
>serialization. 'driver_preserves_write_order' allows block drivers to
>indicate that the order of write commands is preserved and hence that
>serialization of writes per zone is not required. 'use_zone_write_lock' is
>set by disk_set_zoned() if and only if the block device has zones and if
>the block driver does not preserve the order of write requests.
>
>Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>Cc: Christoph Hellwig <hch@lst.de>
>Cc: Ming Lei <ming.lei@redhat.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8083f_
Content-Type: text/plain; charset="utf-8"


------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_8083f_--
