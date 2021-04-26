Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224A8C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 05:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2F35611C0
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 05:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhDZFsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 01:48:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35748 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhDZFsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 01:48:52 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210426054753epoutp0261c9a29ba9cc894ccb1ebf12940c5a77~5UlbIVMAN2656726567epoutp02h
        for <linux-scsi@vger.kernel.org>; Mon, 26 Apr 2021 05:47:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210426054753epoutp0261c9a29ba9cc894ccb1ebf12940c5a77~5UlbIVMAN2656726567epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619416073;
        bh=ery5TADE+Pj7trkb3ST3bPxP1uzavjjARXdNVI8qDdo=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=q81lY59E9rAgpJ2DnM/YL00MMwCiAOfdmrYT287Luxlb7bGEm0bUT4/hW9Rt9q7qU
         ZiwE4nrBzZ9TSBGDigSEulhG85Nv+A3J00SGxHEtJP5oR2tl3zP0w/0rncQOnUDbQu
         A8zTjm7dBUMrBvXr3dl7rd+ykLwGZHbSgqUVyTKE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210426054753epcas2p3f4d4e98e76fea409c669d7c35516d413~5Ulau8OrT0207802078epcas2p35;
        Mon, 26 Apr 2021 05:47:53 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FTDSm0ns4z4x9Q8; Mon, 26 Apr
        2021 05:47:52 +0000 (GMT)
X-AuditID: b6c32a45-db3ff70000002584-e8-608654076611
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.61.09604.70456806; Mon, 26 Apr 2021 14:47:51 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH v2 0/3] Three minor fixes w.r.t suspend/resume
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "ziqichen@codeaurora.org" <ziqichen@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210426054749epcms2p27a2f08f34d07a6754d62c03b125ed632@epcms2p2>
Date:   Mon, 26 Apr 2021 14:47:49 +0900
X-CMS-MailID: 20210426054749epcms2p27a2f08f34d07a6754d62c03b125ed632
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdljTXJc9pC3BoGG/hcXethPsFp/WL2O1
        eHlI0+L0s3fsFju2i1h0X9/BZvGxazajxdKbz9kdODy27d7G6nG5r5fJo2/LKkaPz5vkAlii
        cmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgI5QUihL
        zCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbk
        ZHzY0cFS0MhacerRb/YGxr/MXYycHBICJhK7pj0Gsrk4hAR2MEp8mfoJyOHg4BUQlPi7Qxik
        RljASeJQ/zuweiEBJYn1F2exQ8T1JG49XMMIYrMJ6EhMP3EfLC4i8JNJYvkSU4j5vBIz2p+y
        QNjSEtuXbwWr5xRwkdh0fjMbRFxD4seyXqh7RCVurn7LDmO/PzafEcIWkWi9dxaqRlDiwc/d
        UHFJiWO7PzBB2PUSW+/8YgT5RUKgh1Hi8M5brBAJfYlrHRvBjuAV8JWYt+YFWAOLgKrExZaT
        UENdJH5eWQ5WwywgL7H97RxwODALaEqs36UPYkoIKEscucUC81bDxt/s6GxmAT6JjsN/4eI7
        5j2BOk1NYt3P9UwQY2Qkbs1jnMCoNAsRzrOQrJ2FsHYBI/MqRrHUguLc9NRiowJD5KjdxAhO
        jlquOxgnv/2gd4iRiYPxEKMEB7OSCC/brtYEId6UxMqq1KL8+KLSnNTiQ4ymQA9PZJYSTc4H
        pue8knhDUyMzMwNLUwtTMyMLJXHen6l1CUIC6YklqdmpqQWpRTB9TBycUg1MR7uXsORMc9u4
        MafpsXPRLQfR5AilDX+kVXaf+h67uz+j7Vub7J9ohV33nZVj9ysmno9k0d0aJmOkNPX8lQPc
        pxwyIh/dE8lb2qsyV9xHw/r7K87iZa5ld/d6ZldH9yxcE6uzNDMzjUNWbmuk4+QXVSpPEy0k
        31vMnbNnnWv7p/gt67ZFVjfxtf8uTF8669xKiVlxlfueKk6+WD3p2eZsLvPs1e0TOc7mdUwN
        37PaiTX6aN3nI2tenVgSy/ag0/0956rMnZv2PUid2tukvufDNc/wHfNY67J//rFdeT5oX2Ov
        7rTkjjg1YBZoevhoclnZ6ch1y0+/Z4o+vjY16uKdLnOOje+jQ90ytlYX929RYinOSDTUYi4q
        TgQANfcSFxcEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210426034911epcas2p12dc728215c9a56e3dd2a7870f63e107b
References: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
        <CGME20210426034911epcas2p12dc728215c9a56e3dd2a7870f63e107b@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,

>1st change can fix a possible OCP issue when AH8 error happens.
>2nd and 3rd change can fix race conditions btw suspend/resume and other contexts.
> 
>Can Guo (3):
>  scsi: ufs: Do not put UFS power into LPM if link is broken
>  scsi: ufs: Cancel rpm_dev_flush_recheck_work during system suspend
>  scsi: ufs: Narrow down fast pass in system suspend path
> 
>Change since V1:
>- Incorporated Daejun's comment.
> 
> drivers/scsi/ufs/ufshcd.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
> 

This series looks good to me.
Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
