Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED36C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jan 2022 05:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348615AbiAUFeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:34:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25466 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348580AbiAUFeS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jan 2022 00:34:18 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220121053416epoutp0460e88cc3f48cc908954d762d954c840f~MMknWZe-I0581605816epoutp04d
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2022 05:34:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220121053416epoutp0460e88cc3f48cc908954d762d954c840f~MMknWZe-I0581605816epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1642743256;
        bh=Eeg6HqAJ+oBEx3jyvq2mnIkbW6NlswFD/O5NBc93PCI=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=ii3Aaakdz1GrVRGHGoDQE3dODgMZWVfneHQv2x4IkhlBNu3gfh+rioCt2L3h+D4nO
         ef1iRyzMLFHh2oZWEhjyYbYEMf27TsUbyJadL7NEXvLZYWrYJUltEnAhR4+zegFNYL
         anVziRkCmdngUHdYilp8mb6xezGG1XzVdLXDK58c=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20220121053416epcas2p4955e1517248d8493a6562e171bc9d1d2~MMkmwnBK22470724707epcas2p4E;
        Fri, 21 Jan 2022 05:34:16 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Jg7NP4RTSz4x9QB; Fri, 21 Jan
        2022 05:34:13 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.3D.51767.2D54AE16; Fri, 21 Jan 2022 14:34:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20220121053410epcas2p1f44c47d71604272824439cdfda4b5038~MMkh1Ek_O0185901859epcas2p1w;
        Fri, 21 Jan 2022 05:34:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220121053410epsmtrp13bd7707000994a0706a7d904e5089a97~MMkh0Nv7l1944419444epsmtrp1K;
        Fri, 21 Jan 2022 05:34:10 +0000 (GMT)
X-AuditID: b6c32a45-447ff7000000ca37-03-61ea45d2da19
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        14.8A.08738.1D54AE16; Fri, 21 Jan 2022 14:34:09 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220121053410epsmtip2075877adbd8fac1c20c9f74d5b7b5ae8~MMkho07iu2969129691epsmtip2F;
        Fri, 21 Jan 2022 05:34:10 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>, <vkumar.1997@samsung.com>
In-Reply-To: <cbd41ae3-2b31-381a-6f07-58603a318961@acm.org>
Subject: RE: [PATCH v1] scsi: ufs: use an generic error code in
 ufshcd_set_dev_pwr_mode
Date:   Fri, 21 Jan 2022 14:34:07 +0900
Message-ID: <010f01d80e88$83c422c0$8b4c6840$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQFcFW0MD/41ZuhWiwfo7q9IaGBfeAIxMRR3AZIYxmoBoB2QhALuwApJrSJUrSA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdljTQveS66tEg2c7zC2+Ln3GajHtw09m
        i9WLH7BYdF/fwWbRdfcGo8XSf29ZLO7c/8jiwO5x+Yq3R9+WVYwenzfJBTBHZdtkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRn9Oy+wFawjrni
        ysFtzA2MF5i6GDk5JARMJOZv38zaxcjFISSwg1Fi87RPTBDOJ0aJhqZtbCBVQgKfGSV27faE
        6Zh+aAI7RNEuRonmu2sYIZwXjBJv9q5gB6liE9CWmPZwN9hcEYHTjBK9C6+BJTgFrCV+3j8J
        NlZYIFLi2ZPXQN0cHCwCqhL/ZwuDhHkFLCXOLXjHBmELSpyc+YQFxGYWkJfY/nYOM8QVChI/
        ny5jhYiLSMzubAOLiwj4Sew4+o0NZK+EwE92ib8fu1khGlwk5rYcYYOwhSVeHd/CDmFLSbzs
        b2OHaGhmlNi5u5EZwpnCKLFk/weoKmOJWc/awS5lFtCUWL9LH8SUEFCWOHIL6jg+iY7Df9kh
        wrwSHW1CEI3KEr8mTWaEsCUlZt68AzXQQ+LUsnvsExgVZyF5cxaSN2cheW0Wwt4FjCyrGMVS
        C4pz01OLjQoM4bGdnJ+7iRGcLrVcdzBOfvtB7xAjEwfjIUYJDmYlEV6p+meJQrwpiZVVqUX5
        8UWlOanFhxhNgeE+kVlKNDkfmLDzSuINTSwNTMzMDM2NTA3MlcR5vVI2JAoJpCeWpGanphak
        FsH0MXFwSjUw2UxyOitgKKqRlvBp8rJJGgvWHk7O25CQosJTavPY6ejz1nWvT3CszCm7Z9Ka
        skTr7a/lPP57hfKs1m6f62Ek+2Up18XyXVs2HBVXNrrmVdLQPkdBqupK8beUEneZp47fszo7
        JS/bVifYptmzaTpJ6zP8N06KK7mw8fr1xZ17IyTPze2ZP/GnuL2ju2m7YYZIRN42Vhb570+/
        1DfrO8uf99gb/3bzjrW3xa9+mNOaceaIoNXGep7QGQKR7rc0m+oWhUgfOZRqffprzPU7zffK
        1SK/Lps0Taswxf6EkUbHiTvO5wNWzBX/l+/Zo5VgePfYNwYWtvRtTpeOWGYoTK7KOrD4XPzL
        1gV7N+goHJ6kxFKckWioxVxUnAgAvlOXLCAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvO5F11eJBo/+qlt8XfqM1WLah5/M
        FqsXP2Cx6L6+g82i6+4NRoul/96yWNy5/5HFgd3j8hVvj74tqxg9Pm+SC2CO4rJJSc3JLEst
        0rdL4Mro2X2BrWAdc8WVg9uYGxgvMHUxcnJICJhITD80gb2LkYtDSGAHo8Sxn63MEAlJiRM7
        nzNC2MIS91uOsILYQgLPGCVmQMTZBLQlpj3czQrSLCJwmVHidP8FqKIlTBIHe3hBbE4Ba4mf
        90+ygdjCAuESO7+fArI5OFgEVCX+zxYGCfMKWEqcW/CODcIWlDg58wkLiM0MNL/3YSsjhC0v
        sf3tHKjbFCR+Pl3GChEXkZjd2QYWFxHwk9hx9BvbBEahWUhGzUIyahaSUbOQtC9gZFnFKJla
        UJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcH1paOxj3rPqgd4iRiYPxEKMEB7OSCK9U/bNE
        Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGpiO6OUkP/7j
        PzdZQOGk4DtOluOfc16t7fF7P2v/XOFNbRcetnSw6ifkuzO8iptiEmZ6uWrWYuNLeyvm2Rnf
        uRvOtdc0YaW41cSNOsUi3T/39hxU39w69/T5QEO3R1UHHmt9+aqzvGh6n9b5eJOfWc7pd+bP
        cDrN5p+YO1G+Y+n1+av0JzwWOC52UUo71PnMJdFl1xl+tofu4FqcNe3bjZDcONW2M0cadfkF
        s0TkWTas9zlVs/xT7bFVbqEyx9asLqpX05D4sozB/nDmXtuV7+7PvzLP9dvhniMud2x5n6Xc
        Y4xTluZcrv0jOkF/aVib0fx7PLv/iJw23ei78oPVlcU7mrY+bNFcX9L/rT281/CYEktxRqKh
        FnNRcSIAcyRkvv4CAAA=
X-CMS-MailID: 20220121053410epcas2p1f44c47d71604272824439cdfda4b5038
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220117103107epcas2p3d7223ff63f6cb575316695cc8fb155a4
References: <CGME20220117103107epcas2p3d7223ff63f6cb575316695cc8fb155a4@epcas2p3.samsung.com>
        <1642415361-140388-1-git-send-email-kwmad.kim@samsung.com>
        <3bb0f5ad-2cea-2509-a9e1-d8ed159bd875@acm.org>
        <000001d80da8$9e987cd0$dbc97670$@samsung.com>
        <cbd41ae3-2b31-381a-6f07-58603a318961@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> I think that scsi_execute() can return a negative value. From
> __scsi_execute():
> 
> 	req = scsi_alloc_request(sdev->request_queue,
> 			data_direction == DMA_TO_DEVICE ?
> 			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
> 			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
> 	if (IS_ERR(req))
> 		return PTR_ERR(req);
> 
> As you probably know PTR_ERR() returns a negative error code if IS_ERR()
> returns true.

Right, Thanks.


