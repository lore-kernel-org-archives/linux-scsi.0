Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BFBC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 05:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2612207DA
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 05:43:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Lg6rvz4M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgEYFnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 01:43:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15921 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729486AbgEYFnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2020 01:43:05 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200525054302epoutp0349d62cdc5e51d399caf1c2c2521c8538~SLxROPbXg2310423104epoutp03e
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2020 05:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200525054302epoutp0349d62cdc5e51d399caf1c2c2521c8538~SLxROPbXg2310423104epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590385382;
        bh=aiJ8u16FFam67RdS2KQbXUp7l+s/rlvVGh5bfftCGEk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Lg6rvz4Mw6ddLtY0jVPspn0NSARm7T1ARu+T5TvVFTrYxVgiJ2YUU6KmUpA8/yJkd
         x6yQCuZDAWrwrSQzwXvK8J3i0NdmC9yDvqvZ1nliIK1Oi9gno7SneNFj6rw/CPF/Kz
         kKArY1GgTxHWkAFqs7lTAX63nNTKKk0PcXUWyDBk=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200525054302epcas1p34ede270a299c8448dc29c0d1e1c61f99~SLxQqIPPO3256032560epcas1p3j;
        Mon, 25 May 2020 05:43:02 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: Another approach of UFSHPB
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <aaf130c2-27bd-977b-55df-e97859f4c097@acm.org>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01590385382061.JavaMail.epsvc@epcpadp2>
Date:   Mon, 25 May 2020 14:40:53 +0900
X-CMS-MailID: 20200525054053epcms2p490f99d5a07c9166e09fd28c0d6f1f1bb
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200516171420epcas2p108c570904c5117c3654d71e0a2842faa
References: <aaf130c2-27bd-977b-55df-e97859f4c097@acm.org>
        <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
        <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
        <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
        <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
        <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I am Daejun Park who is working to patch HPB driver.
Thank you for your comment, and the following is our answer.

> Splitting the UFS driver into multiple modules would be great if the
> interface between these modules can be kept small and elegant. However,
> I'm not sure that this approach should be based on Linux device driver
> bus concept. Devices can be unbound at any time from their driver by
> writing into the "unbind" sysfs attribute. I don't think we want the UFS
> core functionality ever to be unbound while any other UFS functionality
> is still active. Has it been considered to implement each feature as a
> loadable module without relying on the bus model? The existing kernel
> module infrastructure already prevents to unload modules (e.g. the UFS
> core) that are in use by a kernel module that depends on it (e.g. UFS HPB).

The HPB driver is close to the UFS core function, but it is not essential
for operating UFS device. With reference to this article
(https://lwn.net/Articles/645810/), we implemented extended UFS-feature
as bus model. Because the HPB driver consumes the user's main memory, it should
support bind / unbind functionality as needed. We implemented the HPB driver 
can be unbind / unload on runtime.

> What will happen if a feature module is unloaded (e.g. HPB) while I/O is
> ongoing that relies on HPB?

In the HPB driver, it checks whether the HPB can be unload / unbind through
the reference counter. Therefore, there is no problem that the driver is 
unloaded / unbind when there is I/O related to HPB.

> Should these parameters be per module or per UFS device?

I think it is necessary to take parameters for each module. 
This is because each extended UFS-feature module has different functions
and may require different parameters.

Thanks,

Daejun Park.
