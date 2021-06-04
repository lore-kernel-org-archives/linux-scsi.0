Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C644CC47083
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 09:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF53B61402
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 09:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFDJoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 05:44:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55182 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhFDJoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 05:44:00 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210604094213epoutp0173fd4090c8d3b3f53c84faafeb34ad9d~FV8Jl7Ern3208132081epoutp01C
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 09:42:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210604094213epoutp0173fd4090c8d3b3f53c84faafeb34ad9d~FV8Jl7Ern3208132081epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622799733;
        bh=+LAP7teJNDknqS6ftC22tN7MZDtvBE0k4gNVcrZZTk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdrIZMea1AOYgneHuv8+cLNkvrbWZHtzt8Q4cCwJNOKe3mAP6fBzfxEPy/AgGttCA
         wxqyRWulPaoJ54+tH7umHCt207V2yPS2FGJN4oditmYqdlXRtqx03L8PFoppbgldEs
         BeZBXmPgNOwEHUP+RckDBVPTpA4nwaW97g9tkWd8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210604094211epcas1p1155241a9c3c2e7ce9e15a4ea2827faaf~FV8IX-qDq2988429884epcas1p1H;
        Fri,  4 Jun 2021 09:42:11 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.165]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FxHq62dNbz4x9Pv; Fri,  4 Jun
        2021 09:42:10 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.C3.09578.275F9B06; Fri,  4 Jun 2021 18:42:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210604094209epcas1p26368dd18011bb2761529432cf2656a9f~FV8FwZDaD1204012040epcas1p2U;
        Fri,  4 Jun 2021 09:42:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210604094209epsmtrp16485696be5628c8be84393c87511a674~FV8FvD_U12961329613epsmtrp13;
        Fri,  4 Jun 2021 09:42:09 +0000 (GMT)
X-AuditID: b6c32a35-fb9ff7000000256a-37-60b9f572e55a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.90.08637.075F9B06; Fri,  4 Jun 2021 18:42:08 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210604094208epsmtip2126455b09c5325e991f11f0db571c258~FV8FZ0v3W0959909599epsmtip2B;
        Fri,  4 Jun 2021 09:42:08 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     damien.lemoal@wdc.com
Cc:     Avri.Altman@wdc.com, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, alim.akhtar@samsung.com,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        bvanassche@acm.org, cang@codeaurora.org,
        gregkh@linuxfoundation.org, hch@infradead.org, jaegeuk@kernel.org,
        jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        mj0123.lee@samsung.com, nanich.lee@samsung.com, osandov@fb.com,
        patchwork-bot@kernel.org, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, tj@kernel.org, tom.leiming@gmail.com,
        woosung2.lee@samsung.com, yi.zhang@redhat.com,
        yt0928.kim@samsung.com
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Date:   Fri,  4 Jun 2021 18:23:35 +0900
Message-Id: <20210604092335.29705-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <DM6PR04MB70811B0A9F77D8F774ED11BEE73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTP19vetrCOO177RDZqRQxvSi1820CNMLgLLmNixoYZ0MENEEqp
        vYU5jYuhDMZjPIYBgfIYAm4MhwGFQiwydDN2zDERizheAySAgsJAUXGjXMj47/c73++c3znn
        y+Fhlpe4drwEhZpSKWRyEW7Gbr3q7OmuWmqP9mqaskA//dXIRaOVrTjSNrQCNL3Sj6Mfh/Jx
        1PFnFUDFj1YwtNBUz0FfZS6zkOZsE45+K6hhoYmmMgzVDLSyUO5EGgetZg+z0NIYjfSDrqiv
        Q4ujHKMOR+euv2Sh7iINC5W0aDF0Z6SHi64O97PRWG0hhm7eWOCgyvH96Nm5XwCaf2rkIoOu
        CEPGm8U4atKv4PuFZN/tELIv7xsWWaiZ45LtZUNcsuV7F7Lv9xSyuSELJwtqugB5paKRSz6e
        HGST8539OJl3sQGQi81vkpldOSyyu7seC7WIkPvFU7JYSiWkFDHJsQmKOH9RSFhUQJTUx0vs
        Ln4L+YqEClkS5S8KPBjqHpQgX9uXSJgqk6eshUJlNC3y3OunSk5RU8L4ZFrtL6KUsXKl2Evp
        QcuS6BRFnEdMctLbYi8vb+maMloer9HJlDOCY0t/1HFPgXTzbMDnQWIPNMzWYdnAjGdJ6AD8
        oejeBlkAcLpfu0GWATR0pnM3U1pXBrjMgx7A099p2QxZBHBkpQ03qXDCDeY9HFzH1sQ2aJj+
        Zx1jxAwHdhrsTNiK8IGnhyrWknk8NrELDp4PNkEB8Q4syXJgvBzgi5FczIT5xKewoLyIY8IC
        4jV4o3SCzVR0gJpL5Rijv8+HmcP7GBwIRwcKOQy2gjPXL270bwen8zPW+4dEDoCajCrAkAIA
        a6fqWYxKAhcWF4GpIYxwhk0dnkx4B2x/XgEY41fh3FIuxySBhAB+nWHJSBxhT/oItuk1db59
        oyIJz1wo5zCrugBg8/MhbgEQlm2Zp2zLPGX/O1cDrAHYUko6KY6ixUrx1g9uBuv34yLVgcKH
        jzy6AYsHugHkYSJrwWUnXbSlIFb2xXFKlRylSpFTdDeQru26ELOziUleO0CFOkos9ZZIJGiP
        j6+PVCJ6XRAXcCLakoiTqalEilJSqs08Fo9vd4qFSUIfZH3wa6LZ7N/6FPWOPPq998c5heF4
        fvzEEfNo8WJw8b7J4G8zjuRkyk4aDBr3A4c/ks9FnuA3fmYx1lZbF/F5YrG93tZoGyS/H9Fu
        d2hnV6+jqOva5dIPJVMhqdaLbm0HnQaevQi3tzfq/nWtcrsX8eX20dsFVom9Vccmd+t5t9oy
        nrasvty5y7+yVfOJ9/6qVFKSqugkMKlTvFlCtaNHs4qc3G5euXtZerfsltl4WlhAeHVwnGJe
        63v4jNe7AXeOcg8NP3bOOPpGaU/kwCtBKpufaz7uLSmhw6pdI1ejBy3qJp6kGXMwvPFKGv+s
        n7Hv7vFtNvrAFf7eB9dmT/o+OSBi0/EysQumomX/Ad2jsMzIBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsWy7bCSvG7B150JBhc3mlqsu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBnNOxILXvFWfD2/lL2BsYW7i5GT
        Q0LARGLbzxvsXYxcHEICuxkljj19yAaRkJI4fuItaxcjB5AtLHH4cDFEzUdGia5XH9lBatgE
        dCT63t4CqxcRkJQ49fILG0gRs8AkNokDPVNYQBLCAmYSU+7OZQEZxCKgKnFrrTuIyStgLTG9
        Ux5ilbzEn/s9zCA2p0CsxITZk1lBbCGBGImT29aA2bwCghInZz4Bm8gMVN+8dTbzBEaBWUhS
        s5CkFjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECE4RWpo7GLev+qB3iJGJg/EQ
        owQHs5II7x61HQlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJx
        cEo1MFmbrnhwQDSp3LXf9OAXvwVt6/a9cs+prs2uChEL6XUt4a8TFjnEXLfyzctJHOsbdhT/
        ybvn82DxIncj3+xPc4MnTbCq1D13R/xb6cLwNJM9Z34mvS38yP7v7i4bf4838yf+d97waUsK
        2+sz7exqtecWShxMnnL74fILO58vFYuV37NEQqKZbcHRbqdpSnfNzn5Zvyp4tdmZuFXub5pN
        31Tlbpt7U+ODuvGNHwJHAsTWqb4SX9XNqute53qmK5FRXTD7a+eVYMZfkyum/pVT/mYV/0ek
        5MKK278kuLOiF9UcXRa9Y3/WcrssUYYte6xrGPJYY1TW61eWnVUIyzbPUaxPMz6XbC9e8rH9
        YrG2uxJLcUaioRZzUXEiAIEORgqAAwAA
X-CMS-MailID: 20210604094209epcas1p26368dd18011bb2761529432cf2656a9f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210604094209epcas1p26368dd18011bb2761529432cf2656a9f
References: <DM6PR04MB70811B0A9F77D8F774ED11BEE73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
        <CGME20210604094209epcas1p26368dd18011bb2761529432cf2656a9f@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021/06/04 16:53, Changheun Lee wrote:
> >> On 2021/06/04 14:22, Changheun Lee wrote:
> >>> + * @q: the request queue for the device
> >>> + * @bytes : bio max bytes to be set
> >>> + *
> >>> + * Description:
> >>> + *    Set proper bio max size to optimize queue operating.
> >>> + **/
> >>> +void blk_queue_max_bio_bytes(struct request_queue *q, unsigned int bytes)
> >>> +{
> >>> +	struct queue_limits *limits = &q->limits;
> >>> +	unsigned int max_bio_bytes = round_up(bytes, PAGE_SIZE);
> >>> +
> >>> +	limits->max_bio_bytes = max_t(unsigned int, max_bio_bytes,
> >>> +				      BIO_MAX_VECS * PAGE_SIZE);
> >>> +}
> >>> +EXPORT_SYMBOL(blk_queue_max_bio_bytes);
> >>
> >> Setting of the stacked limits is still missing.
> > 
> > max_bio_bytes for stacked device is just default(UINT_MAX) in this patch.
> > Because blk_set_stacking_limits() call blk_set_default_limits().
> > I'll work continue for stacked device after this patchowork.
> 
> Why ? Without that added now, anybody using this performance fix will see no
> benefits if a device mapper is used. The stacking limit should be super simple.
> In blk_stack_limits(), just add:
> 
> t->max_bio_bytes = min(t->max_bio_bytes, b->max_bio_bytes);
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

I had tried like as your comment at first. But I got many feedbacks that
applying for all device is not good idea. So I'll try to control bio size
in each stacked driver like as setting max_bio_bytes in LLD as you
recommended. I'm trying to find some target stacked devices to contorl
bio size like as dm-crypt, dm-liner, ... etc. And I'll try to find some
method to control bio max size include using of blk_queue_max_bio_bytes().

Thank you,
Changheun Lee
