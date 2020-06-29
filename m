Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93198C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71AAE206A1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="avl8gdJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403839AbgF2Vg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:36:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64985 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgF2Skj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:40:39 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200629102347epoutp01d0b8404c931d9ff780505973c3290881~c-LZGv6XE1660516605epoutp01l
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:23:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200629102347epoutp01d0b8404c931d9ff780505973c3290881~c-LZGv6XE1660516605epoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593426228;
        bh=r7kUX4UcXe7HMc73nzVqAyFro9BjYsB6qngfu6nQ/Ks=;
        h=From:To:Cc:Subject:Date:References:From;
        b=avl8gdJ2lPwXEioyCRL1Mh30ABrntVYOT2s5tpUP0smV1ABESNAbuLFjXOkw4cfZc
         +C+A6Z4yNJDBoWGlRcmQp07WZ8nd5MlDYIUKn6jbGzw1//UgGJGKMptpAydh1EOdQV
         Hie1VNVF8gEFWHhsmttQAjA4wX6Opy9R4LPxT2/o=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200629102347epcas2p185ffd7c263dcf8decbcd48add87136c4~c-LYkj_kn0131501315epcas2p1e;
        Mon, 29 Jun 2020 10:23:47 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49wNr13CjTzMqYlt; Mon, 29 Jun
        2020 10:23:45 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.C9.19322.F21C9FE5; Mon, 29 Jun 2020 19:23:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200629102343epcas2p4d8f4d92c18c5e692038c7e360ab2d819~c-LVCEN8I2016820168epcas2p4a;
        Mon, 29 Jun 2020 10:23:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629102343epsmtrp2b2f4bd76299209c168eb1fb37e43a307~c-LVBdps20157301573epsmtrp2B;
        Mon, 29 Jun 2020 10:23:43 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-3c-5ef9c12f41e0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.84.08303.F21C9FE5; Mon, 29 Jun 2020 19:23:43 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200629102343epsmtip2598d52d1782dc99969fdce0a81eb2081~c-LU2fXB70997309973epsmtip2D;
        Mon, 29 Jun 2020 10:23:43 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v2 0/2] ufs: support various values per device
Date:   Mon, 29 Jun 2020 19:15:54 +0900
Message-Id: <cover.1593412974.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsWy7bCmqa7+wZ9xBjPfWFvc3HKUxaL7+g42
        ByaPvi2rGD0+b5ILYIrKsclITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
        VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L
        10vOz7UyNDAwMgWqTMjJ+Nc0h6ngKEvF/7l72BsYLzJ3MXJySAiYSJxcN4mpi5GLQ0hgB6PE
        qiULGSGcT4wSn9qeskI4nxkl5m06xgrTsuLSNDYQW0hgF6PErW51iKIfjBJ3f01nB0mwCWhK
        PL05lQnEFhGQk9i8/CsLiM0soC6xa8IJsLiwgJPExX+rgOIcHCwCqhI397uDhHkFLCT+7N4F
        dZ6cxM1zncwg8yUEPrNJLPx4mBEi4SLRv2YFC4QtLPHq+BZ2CFtK4vO7vWwQdr3EvqkNrBDN
        PYwST/f9g2o2lpj1rJ0RZDEz0KHrd+mDmBICyhJHbkGdySfRcfgvO0SYV6KjTQiiUVni16TJ
        UEMkJWbevANV4iHRN9EbEiKxEpMO9LJPYJSdhTB+ASPjKkax1ILi3PTUYqMCQ+Qo2sQITjBa
        rjsYJ7/9oHeIkYmD8RCjBAezkgjvZ+tvcUK8KYmVValF+fFFpTmpxYcYTYGhNZFZSjQ5H5ji
        8kriDU2NzMwMLE0tTM2MLJTEeXMVL8QJCaQnlqRmp6YWpBbB9DFxcEo1MC0L/rZq36Xcrbtu
        vbh43Wvy9PcC9W010Yfdta5WT58b9vTkpMJvObX7F/jpztB99HFL9f/O5ebv/93urDpxw/Tb
        qrse+9/nXY8IuXnuRuHj+IBTsqFuc3/luJvOSqpnufj4RQl7s8nvF8wi32/+6/dRMP+y0Kgv
        cGXDwsytNYqrV4jetyp8efJc+42TJ1on8v1rasjcrnng3g6nipP10zv/ZfRYr7HYEJxtvizH
        NEmpq33yzWPLZ5idtD20rv32tJsGW6IsOT/FalwL6ixeGeOnEM/7UEnB4aDC4rUcLbYhR2t5
        S9/mOzlciinwPK23psHQbErJVyX+dcy7934Lvbth1nqloJ03js56IudhcktJiaU4I9FQi7mo
        OBEAmqBberkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsWy7bCSvK7+wZ9xBu+mKljc3HKUxaL7+g42
        ByaPvi2rGD0+b5ILYIrisklJzcksSy3St0vgyvjXNIep4ChLxf+5e9gbGC8ydzFyckgImEis
        uDSNrYuRi0NIYAejxMNj9xkhEpISJ3Y+h7KFJe63HGGFKPrGKDF1eQ8bSIJNQFPi6c2pTCC2
        iICcxOblX1lAbGYBdYldE06AxYUFnCQu/lsFFOfgYBFQlbi53x0kzCtgIfFn9y6oI+Qkbp7r
        ZJ7AyLOAkWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkaw17W0djDuWfVB7xAjEwfj
        IUYJDmYlEd7P1t/ihHhTEiurUovy44tKc1KLDzFKc7AoifN+nbUwTkggPbEkNTs1tSC1CCbL
        xMEp1cCkttv1xx6b7K9PeLZctb78cKnXoRVs6mcVBP7o5b0Ra5zvNMEl2uT2jlULHdcI8QRo
        7VksVPuvoLfG//zh2jUtb/cFiR659VLhV53e4p0KfcbLXx85s9dKvVYjPn9C6B6dVz/VeWcu
        1rutz+F58nCRpn2x1A7Xs1uYUy6bdsqlH77gfqrN4gJvwCzZL+U+LMKu0yd4ml+t0BBgnrk9
        Z7XB/Z01PBdYT3tU3z+YW5Qzaw3PyvMTKqZysP4zmyS9XXLtyrmfMnWfHHvrJHw/aamtReX/
        ncf7+w60MRV11s2fLmF96vv/iMe3n8/almzJ8215snnwl8bPy/aYLDtbk3pq5nYPth/ba9uv
        Zx5VZ3ybq8RSnJFoqMVcVJwIAIIJDUZpAgAA
X-CMS-MailID: 20200629102343epcas2p4d8f4d92c18c5e692038c7e360ab2d819
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200629102343epcas2p4d8f4d92c18c5e692038c7e360ab2d819
References: <CGME20200629102343epcas2p4d8f4d92c18c5e692038c7e360ab2d819@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Respective UFS devices have their own characteristics and
many of them could be a form of numbers, such as timeout
and a number of retires. This introduces the way to set
those things per specific device vendor or specific device.

Kiwoong Kim (2):
  ufs: support various values per device
  ufs: change the way to complete fDeviceInit

 drivers/scsi/ufs/ufs_quirks.h | 13 ++++++++
 drivers/scsi/ufs/ufshcd.c     | 75 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 77 insertions(+), 12 deletions(-)

-- 
2.7.4

