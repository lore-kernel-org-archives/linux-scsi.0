Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833E7C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5342E22C7B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgLUBgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 20:36:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22034 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgLUBgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 20:36:19 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201221013536epoutp020740c441c56e1bba2c981294dad967eb~Sl3LZI_s-0695506955epoutp02B
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 01:35:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201221013536epoutp020740c441c56e1bba2c981294dad967eb~Sl3LZI_s-0695506955epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608514536;
        bh=DGn9mfuzKfjMDOes+F23JeIMeFdsAehHUmA8kf9J5Dk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=q9EXUSYPw8KtcDOCjjrlTHkyuVoOK02TdynE1DX+xtUre0L3Lv9hah4OcQMgXU/Q7
         zaTa+NFjvMpNS3bqJwR5kTAdv6cHyJof2eSPOuZ2Ak0597vA/UMSD5LfSWKtTrTdUx
         aIG47WgiuXoOn03UsC4kzljITZgLdRUkttxDiVls=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201221013535epcas2p47fc613b61a7501e9dcb1cd3a63614d6c~Sl3KcVDdH0233802338epcas2p4o;
        Mon, 21 Dec 2020 01:35:35 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Czhqm64g8zMqYkZ; Mon, 21 Dec
        2020 01:35:32 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.16.05262.4EBFFDF5; Mon, 21 Dec 2020 10:35:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201221013532epcas2p4cfd78329e4d56e3ac5317ae23c27bc8c~Sl3HeskTs2806228062epcas2p4W;
        Mon, 21 Dec 2020 01:35:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201221013532epsmtrp230a0a61a6a71cd1214478a4d1a60f46a~Sl3HdpXI93056930569epsmtrp2a;
        Mon, 21 Dec 2020 01:35:32 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-2a-5fdffbe40283
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.33.08745.4EBFFDF5; Mon, 21 Dec 2020 10:35:32 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201221013531epsmtip2da6520da483ad3bb1a6a6ccf4a70cbd0~Sl3HNzTFO2619426194epsmtip2F;
        Mon, 21 Dec 2020 01:35:31 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 0/2] permit vendor specific values of unipro timeouts
Date:   Mon, 21 Dec 2020 10:24:39 +0900
Message-Id: <cover.1608513782.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTXPfJ7/vxBhum61g8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk7H/507mgqMsFe/7lzE1MJ5j7mLk5JAQMJF4+/k4kM3FISSwg1Fi95YbUM4nRonr
        DVehnM+MEh/3rmXtYuQAa7m8qRCkW0hgF6PE8s3SEDU/GCWWLtzEApJgE9CUeHpzKhNIQkTg
        DJPEtdazrCAJZgF1iV0TTjCB2MICHhITW7+C2SwCqhJrPn0HW8ArYCGx4ZoMxHlyEjfPdYId
        ISHQyCGx/N8nRoiEi8TZs8fYIWxhiVfHt0DZUhKf3+1lg7DrJfZNbWCFaO5hlHi67x9Us7HE
        rGftjCDLmIEuXb9LH+IxZYkjt1ggzuST6Dj8lx0izCvR0SYE0ags8WvSZKghkhIzb96B2uoh
        cWvVcVZImMRKfJ80k30Co+wshPkLGBlXMYqlFhTnpqcWGxUYI8fRJkZwetRy38E44+0HvUOM
        TByMhxglOJiVRHjNpO7HC/GmJFZWpRblxxeV5qQWH2I0BQbXRGYp0eR8YILOK4k3NDUyMzOw
        NLUwNTOyUBLnDV3ZFy8kkJ5YkpqdmlqQWgTTx8TBKdXAlF/nI6W/PMWf/b3GLH5Jn9r1Me4m
        JhtVVn7nsV+zb51vmNoJ6Y2y3O/efr5/1TZlGsv7zMxzAdy3g/Zemxd2ONszKC/36V4+Ibf9
        O1+7qnL22Vo9NTkqenSRjKZnQvff1o2Cu7v/3nY/V9JwY9r8ibsXuS2zz0jN1d3f/e/ctChh
        fhW5Bx2uMfqnnwu1Si+WdTzqeW32R8WwgIDw/jl3T+/VP/agXlqv5P/MMLujiYKr+16lpd/2
        clmc5FX9WenFFzvW3TNTAqqeHryg4uHpmR304j2LloBkdfpK14t8yytnusx1afp17nXIgVtJ
        ISXqIu4zZ6ZEXFrtWbuubaeTkqdvg1rJsmsMD/9UX7ikxFKckWioxVxUnAgAxFnzDBgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSvO6T3/fjDfrvclg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4MrY/3Mnc8FRlor3/cuYGhjPMXcxcnBICJhIXN5U2MXIxSEk
        sINR4n/PZfYuRk6guKTEiZ3PGSFsYYn7LUdYIYq+MUo0/XnEBJJgE9CUeHpzKhNIQkTgHpPE
        pQlzmUESzALqErsmnAArEhbwkJjY+hXMZhFQlVjz6TsryGZeAQuJDddkIBbISdw818k8gZFn
        ASPDKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4IDV0trBuGfVB71DjEwcjIcYJTiY
        lUR4zaTuxwvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA
        NKHw0wppqVeh34LOGXZXBHWwbjPyTYuW21hw4EnwvqMdrRzs3Zwtj/95LWvbK1JndbLd7cWv
        iY3/9ZZq9DwMTfqVtjWzoSaN44hy4naOdZ12usUX12SJnShjD7Oomr9g2dfmqVqT62TUNm0+
        seeEkl50+AHea8JG2wU7myUTPxnfPTc1YaNMiu3Ms492xEc80vy/QWu1rqf1W4deD/vc29ue
        b5VqnjjLti/aZeKzn2s/GxeldUtMtJ1qK9x9fZl9duSB8MlTZmTULrQ4/P4Hryon77tpy6Ps
        Cux3qsYorfhcknRH592Pb85RP33r+6/XT3Qt4/0kNG8dX59Uxrwrs+fqzEy+YP9g+wHGtT0z
        lFiKMxINtZiLihMBym3RrccCAAA=
X-CMS-MailID: 20201221013532epcas2p4cfd78329e4d56e3ac5317ae23c27bc8c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201221013532epcas2p4cfd78329e4d56e3ac5317ae23c27bc8c
References: <CGME20201221013532epcas2p4cfd78329e4d56e3ac5317ae23c27bc8c@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3: remove change ids
v1 -> v2: change some comments and rename the quirk

There are some attribute settings before power mode change in ufshcd.c
that should have been variant per vendor.

Kiwoong Kim (2):
  ufs: add a quirk not to use default unipro timeout values
  ufs: ufs-exynos: apply vendor specifics for three timeouts

 drivers/scsi/ufs/ufs-exynos.c |  8 +++++++-
 drivers/scsi/ufs/ufshcd.c     | 40 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h     |  6 ++++++
 3 files changed, 34 insertions(+), 20 deletions(-)

-- 
2.7.4

