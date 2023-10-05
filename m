Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E051E92706
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbjJEOrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjJEOp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:45:28 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E104FAF9C6
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 07:27:08 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231005120018epoutp015f67d0adb7600729e35c53cae393ddb6~LNFOptVep1803418034epoutp01g
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 12:00:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231005120018epoutp015f67d0adb7600729e35c53cae393ddb6~LNFOptVep1803418034epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1696507218;
        bh=uwteFW0DaOlIakpzFXHA0/5P3vxF2wtNdbYYi28BWLc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Pms02vQM4S+73QCppcTkTM2O5C1k6i7pYh9qgWd/R1cIit+yWbb1xejXwwmEjqZAy
         586IduVUYoujzzAO+vRF26My/5WNBjH7rULN6TlhBAWcq5yotJgpp7GimjqSEbpRzr
         aQXCQXicVwYLjcR2Wu/LHotN5IttEllrsq5j5y74=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20231005120017epcas2p304ed0ce1d2e84f0027e2bb6810a11239~LNFODX5tj1386913869epcas2p30;
        Thu,  5 Oct 2023 12:00:17 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.70]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4S1VVn26Qwz4x9Q0; Thu,  5 Oct
        2023 12:00:17 +0000 (GMT)
X-AuditID: b6c32a47-afdff700000025bc-5b-651ea5510b01
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.A0.09660.155AE156; Thu,  5 Oct 2023 21:00:17 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH 06/13] scsi_proto: Add struct io_group_descriptor
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Jorn Lee <lunar.lee@samsung.com>,
        Seokhwan Kim <sukka.kim@samsung.com>,
        Yonggil Song <yonggil.song@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20230920191442.3701673-7-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20231005115916epcms2p82a8532bcba586355ceb9aa0ad9a50584@epcms2p8>
Date:   Thu, 05 Oct 2023 20:59:16 +0900
X-CMS-MailID: 20231005115916epcms2p82a8532bcba586355ceb9aa0ad9a50584
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmmW7gUrlUg62tvBar7/azWUz78JPZ
        4uUhTYtVD8ItVq4+ymSx6MY2Jou9t7Qt9uw9yWLRfX0Hm8XJFS9YLJYf/8dksapjLqPF1PNH
        mBx4PS5f8fa4fLbUY8KiA4weu282sHl8fHqLxaNvyypGj8+b5ALYo7JtMlITU1KLFFLzkvNT
        MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVVIoS8wpBQoFJBYXK+nb2RTl
        l5akKmTkF5fYKqUWpOQUmBfoFSfmFpfmpevlpZZYGRoYGJkCFSZkZ+y4185csIGpouviVeYG
        xtlMXYycHBICJhJ7dv1l7GLk4hAS2MEosW5uJ2sXIwcHr4CgxN8dwiA1wgKuEv8/H2YDsYUE
        lCTWX5zFDhHXk7j1cA0jiM0moCMx/cR9sLiIgJtEw9VdbCAzmQUeMkusP9/BDrGMV2JG+1MW
        CFtaYvvyrWDNnAJWEs3vD0DVaEj8WNbLDGGLStxc/ZYdxn5/bD4jhC0i0XrvLFSNoMSDn7uh
        4pISt+dugqrPl/h/ZTmUXSOx7cA8KFtf4lrHRhaIH30ltr4OBQmzCKhK7Dj0AhomLhL7tl8B
        s5kFtCWWLXzNDFLOLKApsX6XPogpIaAsceQWC0QFn0TH4b9wDzZs/I2VvWPeE6jpahLrfq5n
        msCoPAsRzrOQ7JqFsGsBI/MqRrHUguLc9NRiowJjeNQm5+duYgQnWS33HYwz3n7QO8TIxMF4
        iFGCg1lJhDe9QSZViDclsbIqtSg/vqg0J7X4EKMp0JcTmaVEk/OBaT6vJN7QxNLAxMzM0NzI
        1MBcSZz3XuvcFCGB9MSS1OzU1ILUIpg+Jg5OqQam0BebVjMfXrR9Y47YiuPZsWnu8+d72i14
        XLz72fY397slLEq4LEsWCs/WT0ufe6t2cpWD7WGtR4amPNH7/asrK7O8Eh1kuEV/5hn+7N30
        QKa1yulv4d7Lkkt9vjQUvVzWxHxLKipj3ZzAXKuNX/lea1/k1//ewDEh0V77VafHnblsO/gW
        Vgo0BNqv5nQo6s8MM1wQf9yt8imr80P/ag5WFTHdS28+uB71mpKQ77EjfLf8Bu+YVs/QxDnm
        jtcip11aUi2/M+bw3KjIhNnywR2hUWzVW3N+cFnHvH61tOlk91eF5Htatx1qM9cJ3941VVqX
        /YmsSMXkhUl/K2wif+kXennd+X1zy9L3cVs+LFRiKc5INNRiLipOBAAGKhRJOwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920191554epcas2p2280a25d6b2a7fa81563bd6cf1e75549d
References: <20230920191442.3701673-7-bvanassche@acm.org>
        <20230920191442.3701673-1-bvanassche@acm.org>
        <CGME20230920191554epcas2p2280a25d6b2a7fa81563bd6cf1e75549d@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Prepare for adding code that will fill in and parse this data structure.
>=C2=A0=0D=0A>=20Cc:=20Martin=20K.=20Petersen=20<martin.petersen=40oracle.c=
om>=0D=0A>=20Signed-off-by:=20Bart=20Van=20Assche=20<bvanassche=40acm.org>=
=0D=0A=0D=0AReviewed-by:=20Daejun=20Park=20<daejun7.park=40samsung.com>
