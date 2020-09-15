Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEF7C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 00:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C8D208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 00:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GtRZmf1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIOAdJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 20:33:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21182 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOAdG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 20:33:06 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200915003303epoutp032b49625aad206d51757465cfda4d8951~0zb3-dvzX1873418734epoutp03l
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2020 00:33:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200915003303epoutp032b49625aad206d51757465cfda4d8951~0zb3-dvzX1873418734epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1600129983;
        bh=OD7RIDQdWwiTVt0yA9b6QOr6d9BgSQVF2k12nd063cw=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=GtRZmf1zgOzQO8zQlt1xvJqgbuXhAsNtlD8Vl/aGL54HN9FXcv+WNQjZElybDKc3v
         mbN6k+6OwlHRffhv09gpNDuYA8CSr8rGNum1RmF4F1/duSiyycCLaNdhRBMMulqyPH
         JRQ/D7VGgdzSGrxFVi+sa3+/q5psnJSKCzBh5Z2w=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200915003303epcas1p32fc0b2dce423db17d89c1e9a7a72316f~0zb3kgkh12332023320epcas1p3K;
        Tue, 15 Sep 2020 00:33:03 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: Fix NOP OUT timeout value
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     "avri.altman" <avri.altman@wdc.com>, jejb <jejb@linux.ibm.com>,
        "martin.petersen" <martin.petersen@oracle.com>,
        asutoshd <asutoshd@codeaurora.org>, beanhuo <beanhuo@micron.com>,
        "stanley.chu" <stanley.chu@mediatek.com>,
        cang <cang@codeaurora.org>, bvanassche <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21600129983068.JavaMail.epsvc@epcpadp2>
Date:   Tue, 15 Sep 2020 09:11:54 +0900
X-CMS-MailID: 20200915001154epcms2p877997a80b59356b19d17eee0c100c74e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200915001154epcms2p877997a80b59356b19d17eee0c100c74e
References: <CGME20200915001154epcms2p877997a80b59356b19d17eee0c100c74e@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> In some Samsung UFS devices, there is some booting fail issue with
> low-power UFS device. The reason of this issue is the UFS device has a
> little bit longer latency for NOP OUT response. It causes booting fail
> because NOP OUT command is issued during initialization to check whether
> the device transport protocol is ready or not. This issue is resolved by
> releasing NOP_OUT_TIMEOUT value.
> 
> NOP_OUT_TIMEOUT: 30ms -> 50ms
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 06e2439d523c..5cbd0e9e4ef8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -36,8 +36,8 @@
>  
>  /* NOP OUT retries waiting for NOP IN response */
>  #define NOP_OUT_RETRIES    10
> -/* Timeout after 30 msecs if NOP OUT hangs without response */
> -#define NOP_OUT_TIMEOUT    30 /* msecs */
> +/* Timeout after 50 msecs if NOP OUT hangs without response */
> +#define NOP_OUT_TIMEOUT    50 /* msecs */
>  
>  /* Query request retries */
>  #define QUERY_REQ_RETRIES 3
> -- 
> 2.17.1

Hello,

Just a gentle reminder that I'd like some feedback.
Any suggestions here?

Thanks,
Daejun
