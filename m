Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A60C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 10:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3F8611AC
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 10:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhFGKSH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 06:18:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22274 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhFGKSH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 06:18:07 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210607101614epoutp0105c82d8c0900cc54d440267aae62ef34~GRVtgwaLV2455024550epoutp01M
        for <linux-scsi@vger.kernel.org>; Mon,  7 Jun 2021 10:16:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210607101614epoutp0105c82d8c0900cc54d440267aae62ef34~GRVtgwaLV2455024550epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623060974;
        bh=bE9zcyEnTp8w/rwfszgmU80V2rXo0gTRP0lnTfh49uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0Aqz5Awt112MuYerz1ebHa5DayRmCX9ULsAHyaU21wosgxYwAoyZqIqLMUktzvNE
         f7Wiz6GVsKA0LBAa60/Y71f492nPvgVBMJvFFuAVLuzgpfIvMZX9wHOB4wcnNPuWGW
         aJBH9cMi+KwLCd0t7l2mas91iCnSQayct4RfuiXg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210607101613epcas1p4092cb9e9f634854999ee6909ca6c3fda~GRVsY1Zmk1836418364epcas1p4Z;
        Mon,  7 Jun 2021 10:16:13 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.163]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Fz8Qx6rPMz4x9Q3; Mon,  7 Jun
        2021 10:16:09 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.33.10258.9E1FDB06; Mon,  7 Jun 2021 19:16:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210607101609epcas1p392324f6d215e329d632a615c4b1adf4c~GRVorpnUp1861918619epcas1p3z;
        Mon,  7 Jun 2021 10:16:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210607101609epsmtrp24b6ff4c4821db2d26e3b81cba3919886~GRVoqRd400034300343epsmtrp2K;
        Mon,  7 Jun 2021 10:16:09 +0000 (GMT)
X-AuditID: b6c32a38-42fff70000002812-4e-60bdf1e969a1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.C6.08637.9E1FDB06; Mon,  7 Jun 2021 19:16:09 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210607101608epsmtip121b83c11f8d79fd546f0ac9dff3e0a4e~GRVoRYTYE3115431154epsmtip1O;
        Mon,  7 Jun 2021 10:16:08 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     bvanassche@acm.org
Cc:     Johannes.Thumshirn@wdc.com, alex_y_xu@yahoo.ca,
        alim.akhtar@samsung.com, asml.silence@gmail.com,
        avri.altman@wdc.com, axboe@kernel.dk, bgoncalv@redhat.com,
        cang@codeaurora.org, damien.lemoal@wdc.com,
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
Subject: Re: [PATCH v12 0/3] bio: control bio max size
Date:   Mon,  7 Jun 2021 18:57:32 +0900
Message-Id: <20210607095732.16896-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <9e1c43a8-1c6d-95c6-ce4c-34ac194b9022@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1CTdRzH7/s827PBHfUEpF850jHCAmRsjB9fAzw6LJ8LujhKNC+CBU/A
        Oba5DY2oOwwFBOJHEiaCBPLDJkQNmIyLpBGHGEIdP1YoEAqnUAzYkESF2njg8r/Pj9f7877P
        53tfLu6o57hwU2RqWimTSPmEPUvX7SnwmV3qjBde/94PfXu7kYP+vKgjUIVGB9Ds6giBrowX
        EajjtyqAyhZXcWRurmej0zkrGMq61EygX4prMDTdXI6jmt91GCqY/oyN1vImMPRgSoU6x7zR
        UEcFgfKN7QRq6F3HkOFsFobOtVTgaHSyn4O6J0ZYaKq2BEcDfWY2ung3DD1q6AFo4aGRg260
        n8WRcaCMQM2dq0QYjxoajqCGCj/HqJIsE4fSl49zqJbLXtTQzTRKqzlDUMU1XYC6VtnIoZZm
        xljUwo8jBFXYqgGURbuTyunKxyiDoR6PevaINCSZliTSSh4tS5AnpsiSQvkRb8eFxwUECkU+
        or0oiM+TSVLpUP7+yCif11Ok1nvxeccl0jRrKUqiUvF994Uo5WlqmpcsV6lD+bQiUaoQCRUC
        lSRVlSZLEiTIU18RCYV+AVYyXpr8qGgAV+jsPyr8x8zJBFe4ecCOC0l/eCn3C5AH7LmOZDuA
        Oe1LLCYxA1hVXYrZKEdyBcCfvlRuKQbWbhEM1AngOeP6psICYNfcH7iNIsg9sHB+jLDFzuQ2
        OLS8suGBk/Ns+F1/EbA1nMhAmGkY4NhiFukB++e1G3YOZDA8rz3JYex2wSeTBRtD7az1uvke
        NsM8B/vOT7NsMW5lstou4DYDSM7ZwamOCRYj3g//1s3gTOwE53pbN4e6QIupk2AE+QBmZVcB
        JikGsPZePcZQYmi2WKwNrtXCEzZ3+DJlN6h/XAkY52eg6UEB24ZA0gHmZjsyyIuw/9QkvuV1
        r0m/OZGCJ6s0bOZchQAaBxtBMeCVP7VQ+VMLlf/v/DXANWAbrVClJtEqkcL/6UfWgo0/5IXa
        QeX8osAAMC4wAMjF+c4Ob7j+EO/okChJ/5hWyuOUaVJaZQAB1nOX4C7PJ8itn1CmjhMF+InF
        YuQfGBQYIOZvd0gKz4h3JJMkavooTSto5ZYO49q5ZGJO3bqGQ1/terfB/n122PJdyym/xJkY
        YQj0yJ6+j5O5EYpv8gTsf6/HCE4YW06vHt7dd1mjr91e/pJ+gNcWPXXtRmQF73BDcCkr9er4
        gRNvNd2MEfeUBUaELWcfSR+vHB9Oioisexh64MPFoNgU8PIdU+yIf8KK0i1gh+vs49Zj4bde
        4PxaSnoPJngK6gbdqVGtqfZMt3NGRt+h+rSRT3dLR1ue/LVi+eR4lP/Bq8G1xnRuac3E+gfJ
        3tHhwc1rTWrX2LmfNW/ehjtUOQtt2tf47Or31u+7H6w3z1V77Tu699U9xcGlrhNouPZOZ767
        yVfYSBrdLvQuejTqundGH3sHazEE8lmqZInIC1eqJP8B8VAEs8wEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWy7bCSnO7Lj3sTDFo3s1isu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBm/+s8xF2zjquj7/om9gXE1Rxcj
        J4eEgInEub+32boYuTiEBHYzSix8tIYFIiElcfzEW9YuRg4gW1ji8OFiiJqPjBKfp/1lB6lh
        E9CR6Ht7iw3EFhEQk7j85RsjSBGzwFQ2iVnPzzCBJIQFzCQaDp0Da2ARUJU483YTWJxXwFpi
        5qZGdohl8hJ/7vcwg9icQPGlb4+ygthCAlYSK1sXM0PUC0qcnPkE7DhmoPrmrbOZJzAKzEKS
        moUktYCRaRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnCi0NLcwbh91Qe9Q4xMHIyH
        GCU4mJVEeL1k9iQI8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvE
        wSnVwBTaGu+fvd9458dldyOl3vHMquqz+GexfeGt0J6dAp8YNLP+rF36Zu+errZ1MT2Hoiez
        mTcu3LTgzMEDfq0+F3+a85b9mc7przzNsfqG0IdpfS/6Nh4/e8Pk7Ly+h0kJQak31u2L0Nfc
        0GX58rK3j+z9DRd6O8p32z88YfBgYtGlZ4xc+ckNn8yW9NxccaLwcWiv8BG3ztlV18xehP+Q
        TdivMzewa4GzmsRm/t0LOeXLFt97p+rIF33u4zPXa/1nmMztTpmZhDb9LHSbeMs6f43lxRi5
        PvaD8wR28Xx2jK3h3Lq6f8+EE37Ht1/JL2Nc9iP/W/Bppcqip7JJPAyMn7PtPk7u5bmQFdE0
        r07MfpUSS3FGoqEWc1FxIgAdekm4gwMAAA==
X-CMS-MailID: 20210607101609epcas1p392324f6d215e329d632a615c4b1adf4c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210607101609epcas1p392324f6d215e329d632a615c4b1adf4c
References: <9e1c43a8-1c6d-95c6-ce4c-34ac194b9022@acm.org>
        <CGME20210607101609epcas1p392324f6d215e329d632a615c4b1adf4c@epcas1p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 6/3/21 10:03 PM, Changheun Lee wrote:
> > bio size can grow up to 4GB after muli-page bvec has been enabled.
> > But sometimes large size of bio would lead to inefficient behaviors.
> > Control of bio max size will be helpful to improve inefficiency.
> > 
> > blk_queue_max_bio_bytes() is added to enable be set the max_bio_bytes in
> > each driver layer. And max_bio_bytes sysfs is added to show current
> > max_bio_bytes for each request queue.
> > bio size can be controlled via max_bio_bytes.
> 
> Where is the version history for this patch series?

Sorry. I didn't know about it. I'll do next. Thank you for advise.

> 
> Has this patch series been tested in combination with dm-crypt?

This patch has been tested in android device. And dm-crypt on the top of scsi
has tested with below scsi modification in VM too.

@@ -1837,6 +1837,8 @@  void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
	blk_queue_virt_boundary(q, shost->virt_boundary_mask);
	dma_set_max_seg_size(dev, queue_max_segment_size(q));
			 
+	blk_queue_max_bio_bytes(q, queue_max_sectors(q) << SECTOR_SHIFT);
+
	/*
	 * Set a reasonable default alignment:  The larger of 32-byte (dword),
	 * which is a common minimum for HBAs, and the minimum DMA alignment,

> 
> Bart.
> 

Thank you,
Changheun Lee
