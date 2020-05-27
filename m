Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5707C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 09:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA6E2084C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 09:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uVCPv3Iv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgE0JPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 05:15:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22939 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE0JPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 05:15:04 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200527091503epoutp02536ff6d9e6849f1818c397d96174d6ab~S188kNEwh0218202182epoutp02B
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2020 09:15:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200527091503epoutp02536ff6d9e6849f1818c397d96174d6ab~S188kNEwh0218202182epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590570903;
        bh=Dm3JG1JFIBm92Ne8ZPoNhZSsC2dbIoAQEZ/k9FavCTg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=uVCPv3Iv1/QfhOj13XaqxIv1jaxjgNCc3r0bNtz54cHXd/QLUN4xchO64XOZ2n/aI
         ByTiD67uOzPy9y+Dx4SrxLZI8NnYi3dTAd/QNJQYa8qLBirCBI0jVUKZ7uz083YBBI
         IX3PxzvvsPRBGLzhLi7yHCC1fPFmwA/0QxnInLk4=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200527091502epcas1p192c155d38ef4f98613a989b482a1aad4~S188EUuYj2923029230epcas1p1c;
        Wed, 27 May 2020 09:15:02 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: Another approach of UFSHPB
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
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
        Sung-Jun Park <sungjun07.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <fd8c4336-8528-19d9-b1fe-1f74baf6b483@acm.org>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01590570902533.JavaMail.epsvc@epcpadp1>
Date:   Wed, 27 May 2020 18:11:06 +0900
X-CMS-MailID: 20200527091106epcms2p34428c8cbcda670e0a77cf6eab36ffcb4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200516171420epcas2p108c570904c5117c3654d71e0a2842faa
References: <fd8c4336-8528-19d9-b1fe-1f74baf6b483@acm.org>
        <aaf130c2-27bd-977b-55df-e97859f4c097@acm.org>
        <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
        <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
        <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
        <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
        <231786897.01590385382061.JavaMail.epsvc@epcpadp2>
        <6eec7c64-d4c1-c76e-5c14-7904a8792275@acm.org>
        <SN6PR04MB46400AED930A3DC5B94AED25FCB00@SN6PR04MB4640.namprd04.prod.outlook.com>
        <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-26 Bart Van Assche wrote:
>On 2020-05-25 23:15, Avri Altman wrote:
>>> On 2020-05-24 22:40, Daejun Park wrote:
>>>> The HPB driver is close to the UFS core function, but it is not essential
>>>> for operating UFS device. With reference to this article
>>>> (https://lwn.net/Articles/645810/), we implemented extended UFS-feature
>>>> as bus model. Because the HPB driver consumes the user's main memory, it
>>> should
>>>> support bind / unbind functionality as needed. We implemented the HPB
>>> driver
>>>> can be unbind / unload on runtime.
>>>
>>> I do not agree that the bus model is the best choice for freeing cache
>>> memory if it is no longer needed. A shrinker is probably a much better
>>> choice because the callback functions in a shrinker get invoked when a
>>> system is under memory pressure. See also register_shrinker(),
>>> unregister_shrinker() and struct shrinker in include/linux/shrinker.h.
>>
>> Since this discussion is closely related to cache allocation,
>> What is your opinion about allocating the pages dynamically as the regions
>> Are being activated/deactivated, in oppose of how it is done today - 
>> Statically on init for the entire max-active-subregions?

> Memory that is statically allocated cannot be used for any other purpose
> (e.g. page cache) without triggering the associated shrinker. As far as
> I know shrinkers are only triggered when (close to) out of memory. So
> dynamically allocating memory as needed is probably a better strategy
> than statically allocating the entire region at initialization time.

To improve UFS device performance using the HPB driver, 
the number of active-subregions above a certain threshold is essential.
If the number of active-subregions is lower than the threshold, 
the performance improvement by using HPB will be reduced. 
Also, due to frequent and active/inactive protocol overhead, 
performance may be worse than when the HPB feature is not used.

Therefore, it is better to unbind/unload HPB driver than 
to reduce the number of active subregions below the threshold. 
We designed the HPB driver to make the UFS device work 
even when the module is unloaded.

Thanks,

Daejun
