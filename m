Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B182C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 07:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244184AbiCHHCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 02:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiCHHCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 02:02:04 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A9C25C46
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 23:01:01 -0800 (PST)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220308070054epoutp049c563e184bc0cd1767ff2e47dc9da4ac~aVbY1EQSF0422704227epoutp04F
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 07:00:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220308070054epoutp049c563e184bc0cd1767ff2e47dc9da4ac~aVbY1EQSF0422704227epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646722854;
        bh=xIxthiEqn9FQ9jBzamiuJhFSF1jJomIQrv/+lcC8Nu4=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=pwRAuJvESEeXMc4WxIk3dmAPFMjga6jS3x/0DgWX5hnyNLOeLLb7Ai8tGOmogN6pv
         MDpVkWbK6sZJMSIuNNy4IHudR+5HIyISSqJKY/AC8pCfwPwLigj9y8N486LkqCliKv
         +QEhP5/GDaFYdNtRuYZx4Hm5RIAl/KkTFnaTND6U=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20220308070054epcas2p1b1ac2b195e35ae863404fb09e2469175~aVbYPWpHe0737807378epcas2p1c;
        Tue,  8 Mar 2022 07:00:54 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.91]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KCR785167z4x9Q1; Tue,  8 Mar
        2022 07:00:52 +0000 (GMT)
X-AuditID: b6c32a46-da1ff70000018941-ce-6226fc5adb68
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.0B.35137.A5CF6226; Tue,  8 Mar 2022 15:48:58 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [RFC PATCH 1/4] scsi: Allow drivers to set BLK_MQ_F_BLOCKING
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20220308003957.123312-2-michael.christie@oracle.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220308070049epcms2p78d9e9b9bacd3fb6b52de8eb1eaedb623@epcms2p7>
Date:   Tue, 08 Mar 2022 16:00:49 +0900
X-CMS-MailID: 20220308070049epcms2p78d9e9b9bacd3fb6b52de8eb1eaedb623
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmhW7UH7Ukg6dL5C2mffjJbPGsYzGz
        xctDmhYb+zks3pw/xGTRfX0Hm8Xy4/+YLP5OusFqcWhyM5MDp8flK94e0yadYvP4+PQWi8f7
        fVfZPPq2rGL0WL/lKovH501yAexR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
        Sgp5ibmptkouPgG6bpk5QHcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMC/SK
        E3OLS/PS9fJSS6wMDQyMTIEKE7IzZrwTLfjLUrH1eV0D4zXmLkZODgkBE4kFayeD2UICOxgl
        JjbrdjFycPAKCEr83SEMEhYW8JTouXeHDaJESWL9xVnsEHE9iVsP1zCC2GwCOhLTT9wHinNx
        iAisYpboe/+JDWI+r8SM9qcsELa0xPblW8EaOAWcJFat28MEEdeQ+LGsF+oeUYmbq9+yw9jv
        j81nhLBFJFrvnYWqEZR48HM3VFxS4uWbG1Bz8iX+X1kO1Vsjse3APChbX+Jax0YWiL98JfY/
        KAQxWQRUJS618UFUuEj8Xb8ObDqzgLzE9rdzmEFKmAU0Jdbv0gcxJQSUJY7cYoH5qWHjb3Z0
        NrMAn0TH4b9w8R3znkDdpSax7ud6JogxMhK35jFOYFSahQjlWUjWzkJYu4CReRWjWGpBcW56
        arFRgRE8VpPzczcxgtOmltsOxilvP+gdYmTiYDzEKMHBrCTCe/+8SpIQb0piZVVqUX58UWlO
        avEhRlOgfycyS4km5wMTd15JvKGJpYGJmZmhuZGpgbmSOK9XyoZEIYH0xJLU7NTUgtQimD4m
        Dk6pBqYeVWfTTweu+E9naPDTWj3ty/zGHa+nZyd67mpxOGEwdc7tnG6ZNMGrUqyv9kccXNB9
        9fa+hxN3b5wXmTxR7/KOB/faHRL8beqPJtpWHcm+1Hrn5oZwfqGLER81xCs3/1UT9ZT1ujil
        8dJks9NHOCUm7Cndt+bgnjM/NRZJHop85XTuxtL7RuorRBZ8qHTZ8vyocJD6l8gA/u63LauE
        dwc9iFsvGBUwybrqBv/ZdRNXuHxJWmtVpab/bLZJ/v67tsaajx74M5/4s8f0yyVRDcmNghHW
        L3yX8QSsext3Vmf984DXTPZBgnVnmzbsuyKupLSh9vlynuSvc267rkizVm9uc5KY8Irtlsfl
        6MZ7T9uNlFiKMxINtZiLihMBMa4/LyQEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308004023epcas2p12ebd497c14d32f36d0aa6682c0b9d0db
References: <20220308003957.123312-2-michael.christie@oracle.com>
        <20220308003957.123312-1-michael.christie@oracle.com>
        <CGME20220308004023epcas2p12ebd497c14d32f36d0aa6682c0b9d0db@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike, 

>@@ -2952,8 +2954,8 @@ scsi_host_block(struct Scsi_Host *shost)
>         }
> 
>         /*
>-         * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
>-         * calling synchronize_rcu() once is enough.
>+         * Drivers that use this helper enable blk-mq's BLK_MQ_F_BLOCKING flag
>+         * so calling synchronize_rcu() once is enough.
>          */
>         WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
Should we keep this line?

And I think scsi_host_block() should call synchronize_srcu() rather than
synchronize_rcu(), if the BLK_MQ_F_BLOCKING flag is used.

Thanks,
Daejun
