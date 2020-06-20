Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FFDC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC79923A1D
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:39:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eK9Kf+Kb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgFTHjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:39:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27460 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFTHjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 03:39:20 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200620073916epoutp026a4fcf0fee9150d38a79ad0bac59037b~aMILP-RX_1625016250epoutp028
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 07:39:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200620073916epoutp026a4fcf0fee9150d38a79ad0bac59037b~aMILP-RX_1625016250epoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592638756;
        bh=MjQA8Hx9evtEYCe2FJyZF0c05ipnaXdFeRTj/wrqVoQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=eK9Kf+KbqYDKe8hnjvHM3EWREENpcqdon/aqNeGSpuVJ4L3nPB4v7an+Zx8Qw8UPv
         GmeVhRkDBtBy7+WT8jirGYMzg4vhQC6ideVxY20zCdPNyYAL7Xdhi1/Urv2sNgL62E
         tdKyVTIa7b5R+blXp7ue7TO6dotlMS3lS+n3GIg8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200620073915epcas2p1b33a44f78aaa0e96675f78a490a07063~aMIJ-cCCB1577115771epcas2p1G;
        Sat, 20 Jun 2020 07:39:15 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49pncK3rK8zMqYkV; Sat, 20 Jun
        2020 07:39:13 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.A4.27013.12DBDEE5; Sat, 20 Jun 2020 16:39:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200620073912epcas2p469d0082af35ff54a8e84793feed2ab6d~aMIHo1rJ50538705387epcas2p4f;
        Sat, 20 Jun 2020 07:39:12 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200620073912epsmtrp1760f77fe85755dbcac689122a070fadc~aMIHoC19-0771907719epsmtrp1-;
        Sat, 20 Jun 2020 07:39:12 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-50-5eedbd210b0c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.D6.08303.02DBDEE5; Sat, 20 Jun 2020 16:39:12 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200620073912epsmtip2216a64c8e033d412c75aa5ea29a5879b~aMIHXPjYg1780717807epsmtip2R;
        Sat, 20 Jun 2020 07:39:12 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 0/2] support various values per device
Date:   Sat, 20 Jun 2020 16:31:35 +0900
Message-Id: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmua7i3rdxBt23JCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ+Pr9QXMBf9YKlZcfMnawPiPuYuR
        g0NCwERi5kHbLkYuDiGBHYwSj3fdZYVwPjFKrNnexwbhfGaUWD1/IztMx6flihDxXYwSTb8n
        MEM4PxglHvZdZuxi5ORgE9CUeHpzKhNIQkTgBqPEnObDrCAJZgF1iV0TTjCB2MICthK7tj4G
        i7MIqEqsv7EDLM4r4CrRtv4lM4gtISAncfNcJ9gGCYFb7BJnt/9nhEi4SOzZvBDKFpZ4dXwL
        O4QtJfGyvw3KrpfYN7WBFaK5h1Hi6b5/UA3GErOetTOC/MMMdOr6XfoQrylLHLnFAnEnn0TH
        4b9QH/NKdLQJQTQqS/yaNBlqiKTEzJt3oDZ5SPx+fQnsFSGBWIkvO7sZJzDKzkKYv4CRcRWj
        WGpBcW56arFRgQlyJG1iBKc7LY8djLPfftA7xMjEwXiIUYKDWUmE9/D7N3FCvCmJlVWpRfnx
        RaU5qcWHGE2B4TWRWUo0OR+YcPNK4g1NjczMDCxNLUzNjCyUxHnfWV2IExJITyxJzU5NLUgt
        gulj4uCUamDK+jBt1d4zsWasmxn3MWa3Pkqf75qyWLtDe3XABSvDS1vm57b928alID0nWznn
        bG6/auvlnsKPbzSya1LdFHb1TK26vyPgyc9NgplF11p1J+3Wjwg8o+dv8zdskk2a5/E7J/Sy
        VrA2RwvOfdGqbfNbfk+UXtXdexUZSx4pBCqy/wo4bHnC1o83491q36Ag3U0ph1UWRjJ8W/6w
        58fCtPQ9b5kt/5bNcnjD4rr3YvLPrqOTT+4+eG/GW+3re2e2+TF1rub677nnrfbxpTYhh+9/
        7ohKk3t/YOY/+WU29puvnS00uDNZXURB9Wl8dH//xLMPs7PlXNYw1Tiwspgf2DO9pstl4oq/
        XTFCsXIx/g1KLMUZiYZazEXFiQAMCdLfAAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsWy7bCSvK7C3rdxBs3PlS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJXx9foC5oJ/
        LBUrLr5kbWD8x9zFyMEhIWAi8Wm5YhcjF4eQwA5GiY5rs4HinEBxSYkTO58zQtjCEvdbjrBC
        FH1jlFi+4iBYEZuApsTTm1OZQBIiAo8YJX7P7GQHSTALqEvsmnCCCcQWFrCV2LX1MSuIzSKg
        KrH+xg6wOK+Aq0Tb+pdQ2+Qkbp7rZJ7AyLOAkWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpe
        cn7uJkZwAGpp7WDcs+qD3iFGJg7GQ4wSHMxKIryH37+JE+JNSaysSi3Kjy8qzUktPsQozcGi
        JM77ddbCOCGB9MSS1OzU1ILUIpgsEwenVAPT9DjtgwZauqUHD4WrprQzrnELitw8feYOu68H
        xHYnCey4dXpbqsq1Jz2nf+/mTd29/qVXLb9yvLtve15QZ6eVpo7XtVWRdr6cmQK5kTHNbVXi
        JTMk57qG8dStMPNZ2qn1fYP9nBC/dXpvLQy3PcyRZ7jC9tIhbKXj7ycflspEvMmx1jybz7DQ
        6IlbyPVD521mKb6uYHzQtIjh57PADU93b9nmo7SjlE9KZY7D1mcbUhsvBlyRs7GUDHy4ybPi
        Kjv/ozXxnp6C/v+t2E+t6F2yXVmcRXKTzcHcC9dicpmPXs5Ouc05WemFtceyawWcbe7n63d4
        T5e4dau7ap38t74klpsaO05KnP3UxXf1vaoSS3FGoqEWc1FxIgDF4q6grwIAAA==
X-CMS-MailID: 20200620073912epcas2p469d0082af35ff54a8e84793feed2ab6d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620073912epcas2p469d0082af35ff54a8e84793feed2ab6d
References: <CGME20200620073912epcas2p469d0082af35ff54a8e84793feed2ab6d@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Respective UFS devices have their own characteristics and
many of them could be a form of numbers, such as timeout
and a number of retires. This introduces the way to set
those things per specific device vendor or specific device.

I wrote this like the style of ufs_fixups stuffs.

Kiwoong Kim (2):
  ufs: support various values per device
  ufs: change the way to complete fDeviceInit

 drivers/scsi/ufs/ufs_quirks.h | 20 +++++++++++++
 drivers/scsi/ufs/ufshcd.c     | 70 +++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 82 insertions(+), 9 deletions(-)

-- 
2.7.4

