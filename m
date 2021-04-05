Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44596C433B4
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 09:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14F0561381
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 09:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhDEJuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Apr 2021 05:50:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43333 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhDEJuK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2021 05:50:10 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210405095002epoutp0246bd6dd80f0da8abe2e8b3c69d9b9292~y7V2f48_Y2522725227epoutp02H
        for <linux-scsi@vger.kernel.org>; Mon,  5 Apr 2021 09:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210405095002epoutp0246bd6dd80f0da8abe2e8b3c69d9b9292~y7V2f48_Y2522725227epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617616202;
        bh=1PMaMXD8DunwBAE3oS7QwUwYsC3fXmu8ojzljQqoA9U=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=cbYp5ACp1cfwQGsvUmlgiuPqw0c2UTf0wfTkiMDhss83vP086hPPs9P7LnBmeaOlB
         vII+hlBjFc6aj3YVausvlXDPwkcWrGb42u28pBXl+NILQTQs1WH+WxjLOKjpyxF5bu
         83TtPoAyhnsapahDsqPw0cpd2PQJjH4bk2jhbFCs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210405095001epcas3p1e89f0f9432ee012c9d5de1062fa8d1b5~y7V16hUKB1490214902epcas3p1A;
        Mon,  5 Apr 2021 09:50:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4FDQqs6CsCz4x9Q8; Mon,  5 Apr 2021 09:50:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v7 00/11] Add Host control mode to HPB
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01617616201846.JavaMail.epsvc@epcpadp3>
Date:   Mon, 05 Apr 2021 18:29:23 +0900
X-CMS-MailID: 20210405092923epcms2p60e202f0b795f1bc6630dc69cd5887209
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210331074004epcas2p3e6d0b2d1bf0f43708902b2d5583069c4
References: <20210331073952.102162-1-avri.altman@wdc.com>
        <CGME20210331074004epcas2p3e6d0b2d1bf0f43708902b2d5583069c4@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The HPB spec defines 2 control modes - device control mode and host
> control mode. In oppose to device control mode, in which the host obey
> to whatever recommendation received from the device - In host control
> mode, the host uses its own algorithms to decide which regions should
> be activated or inactivated.
>  
> We kept the host managed heuristic simple and concise.
>  
> Aside from adding a by-spec functionality, host control mode entails
> some further potential benefits: makes the hpb logic transparent and
> readable, while allow tuning / scaling its various parameters, and
> utilize system-wide info to optimize HPB potential.
>  
> This series is based on Samsung's V32 device-control HPB2.0 driver
>  
> This version was tested on Galaxy S20, and Xiaomi Mi10 pro.
> Your meticulous review and testing is mostly welcome and appreciated.
>  
> Thanks,
> Avri
>  
>  
> Avri Altman (11):
>   scsi: ufshpb: Cache HPB Control mode on init
>   scsi: ufshpb: Add host control mode support to rsp_upiu
>   scsi: ufshpb: Transform set_dirty to iterate_rgn
>   scsi: ufshpb: Add reads counter
>   scsi: ufshpb: Make eviction depends on region's reads
>   scsi: ufshpb: Region inactivation in host mode
>   scsi: ufshpb: Add hpb dev reset response
>   scsi: ufshpb: Add "Cold" regions timer
>   scsi: ufshpb: Limit the number of inflight map requests
>   scsi: ufshpb: Add support for host control mode
>   scsi: ufshpb: Make host mode parameters configurable
>  
>  Documentation/ABI/testing/sysfs-driver-ufs |  84 ++-
>  drivers/scsi/ufs/ufshcd.h                  |   2 +
>  drivers/scsi/ufs/ufshpb.c                  | 568 ++++++++++++++++++++-
>  drivers/scsi/ufs/ufshpb.h                  |  44 ++
>  4 files changed, 663 insertions(+), 35 deletions(-)
>  

The patches in this series look good to me.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
