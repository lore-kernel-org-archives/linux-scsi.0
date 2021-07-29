Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F7DC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20BD56101C
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhG2A6J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:58:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28308 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhG2A6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 20:58:08 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210729005804epoutp033a5d2d7bae83598f5db205ff7b36420c~WHRNY-wxD0146501465epoutp03Q
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210729005804epoutp033a5d2d7bae83598f5db205ff7b36420c~WHRNY-wxD0146501465epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627520284;
        bh=9wDBDaonJnjihyl38hInlp4SeZJwmet42/Kfv1+YiRo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=teor421nsEU94EYi63A/sAB8unDUVRPfX2wxwncMkjGJo/8hCQvvuOXHK5OuzHT3s
         UpntLbKZF06gR/dM+RBw1l/fMyNfhUgu+xELzq4o9f7mATVt1GSuLzgkx4LiR28/kW
         iGdSMlzHfmVwBq53KBQBrRpSUWZqfxC8FCO6wwUk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210729005803epcas3p18f7d644272ba0b04e618b9318ded8db8~WHRM5DVWj0828608286epcas3p1V;
        Thu, 29 Jul 2021 00:58:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4GZsZz5097z4x9QB; Thu, 29 Jul 2021 00:58:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 01/18] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-2-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <878274034.81627520283675.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 09:56:40 +0900
X-CMS-MailID: 20210729005640epcms2p5116a5684f2cdf75d8109f5583969c421
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033504epcas2p1cc3c6f61e81814004c36b89c7c9e3dd5
References: <20210722033439.26550-2-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033504epcas2p1cc3c6f61e81814004c36b89c7c9e3dd5@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>If param_offset > buff_len then the memcpy() statement in
>ufshcd_read_desc_param() corrupts memory since it copies
>256 + buff_len - param_offset bytes into a buffer with size buff_len.
>Since param_offset < 256 this results in writing past the bound of the
>output buffer.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
