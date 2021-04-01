Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9A8C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08F86105A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhDAHAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:00:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22778 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhDAHAI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 03:00:08 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210401070005epoutp015613bfeef430713e06cd0bdfb9549e63~xqcVHRnlF2396223962epoutp01I
        for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2021 07:00:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210401070005epoutp015613bfeef430713e06cd0bdfb9549e63~xqcVHRnlF2396223962epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617260406;
        bh=g0U3OpuHF1CVQo7od+Tsso7DBc2pL/976ROK5+ymkx4=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=UiSbICbKQsVXTBMDDlSPs3UJHRTSkoVfu+lQRZOoN42xuLmk1hXlMx7otEX2qEHyL
         8+og2PV9ofsFAXpXdM+vOstUVMKRKlWZE5EEJndBeacO7/wXoOsCw4rdywHoIEFJzn
         kl7HJGLLCSe6esnCqcSdd2qszJXFLZKpfCxfdRqs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210401070002epcas3p3c736459ea4bf7e83c35bc17b974bfcb1~xqcRubRCO0642806428epcas3p3E;
        Thu,  1 Apr 2021 07:00:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4F9vFZ1rHWz4x9Pp; Thu,  1 Apr 2021 07:00:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4 2/2] scsi: ufs: Fix wrong Task Tag used in task
 management request UPIUs
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "sthumma@codeaurora.org" <sthumma@codeaurora.org>,
        "vinholikatti@gmail.com" <vinholikatti@gmail.com>,
        "ygardi@codeaurora.org" <ygardi@codeaurora.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01617260402234.JavaMail.epsvc@epcpadp3>
Date:   Thu, 01 Apr 2021 15:44:19 +0900
X-CMS-MailID: 20210401064419epcms2p6b289c9ba573d15883e3e92ddcd233e11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210401064419epcms2p6b289c9ba573d15883e3e92ddcd233e11
References: <CGME20210401064419epcms2p6b289c9ba573d15883e3e92ddcd233e11@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can Guo

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
...
>  
>  	req->end_io_data = &wait;
> -	free_slot = req->tag;
>  	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
I think this line should be removed.

Thanks,
Daejun

