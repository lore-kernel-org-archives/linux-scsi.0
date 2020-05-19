Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AA4C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 22:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C53E320674
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 22:50:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Lryi9r6/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgESWuF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 18:50:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56940 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgESWuF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 18:50:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200519225002epoutp028bb995b8db0c86d5c6a81f413eb4e36d~Qj6PfEsgG0283202832epoutp02Y
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 22:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200519225002epoutp028bb995b8db0c86d5c6a81f413eb4e36d~Qj6PfEsgG0283202832epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589928602;
        bh=f6oUHMjeeGH6CxpNcnFCX86gPJZvLN/8Xz/S+Wh9JKQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Lryi9r6/39QV5eNXPsWDhWdMCiOUizwo4VbYvgi6CXnyJQNXjfcq93fYhUmPAyuVj
         BiRuWw7NxPZpOfsINTpxs0Z5LCGrTUD7LrUrNjyVZN73JylVYyumIhH9h8vcfTh0ch
         MXGK8sM8cN3eQ60tGeGYD0/aIL5cC8BehpwSm0ms=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200519225001epcas1p1f7e926f25706108e8305b643c76531a0~Qj6OgBSSX1414714147epcas1p1L;
        Tue, 19 May 2020 22:50:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Another approach of UFSHPB
Reply-To: ymhungry.lee@samsung.com
From:   yongmyung lee <ymhungry.lee@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
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
In-Reply-To: <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
Date:   Wed, 20 May 2020 07:31:37 +0900
X-CMS-MailID: 20200519223137epcms2p7e5b43c255d6747080fce6beadfc14d49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200516171420epcas2p108c570904c5117c3654d71e0a2842faa
References: <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
        <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
        <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
        <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p7>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello, All!

I write this email that is my opinion regard to HPB.
This mail is very long. So, summary is ... :

[Summary]
1. HPB, Write Booster and other new UFS features would 
   be managed by ufs-extended feature layer (additional LLD layer)
2. Map table of HPB will be managed in LLD (UFS Driver)
3. Each ufs feature driver can be implemented as a loadable kernel module
4. Samsung prepares test environment based on QEMU also
5. We will push our patch as soon! Please review this.


This is body: 

I am Yongmyung Lee, who is one of the original authors of the HPB driver,
which was out-of-tree implementation from linux kernel mainline.

I have seen the works done by Bean Hou and Avri Altman, which are very impressive.
I also have some opinion on the driver 
and would like to consult with you about it and prepare a set of patches.

The basic idea of my approach is similar to Bean's work
of managing HPB map-data in LLD (UFS Driver).
As HPB Driver is closely related to the behavior of the
UFS Device, I think it would be nice if HPB Driver runs on the LLD layer.

HPB Driver is closely related to the behavior of the UFS Device. 
Thus I think it would be nice if HPB Driver works on additional feature layer on LLD. 

Of course, Avri's work makes sense.
I believe HPB's scheme can be a good alternative to HMB(Host Memory Buffer)of NVMe
for storage devices like eMMC or SATA SSD (may be DRAMless).
Once HPB-like scheme is applied, 
these storage devices could benefit from performance improvement
in read latency as well as throughput.

However, it would not be desirable to relocate 
the map table management to the upper layer such as scsi-dh
as there are no such specification supported for the moment.

When the similar specifications to HPB will be proposed in JEDEC or T13,
it would be a great chance to have a deep discussion on 
which layer to be the best fit for the map table management.

Before disclosing my opinion on the HPB driver development approach,
I would like to introduce the main characteristics of Extended UFS-Feature in progress: 

  * Providing extended functionality.
    That is, UFS device shall work well without extended UFS-Features.
    By using them, however, it will be more powerful in certain application scenarios.

  * Designed to suit the Embedded system (such as Android)
    Due to the characteristics of UFS device, 
    it is being utilized mainly as a mobile storage.
    We are mainly trying to improve performance in Android system. 

  * Closely connected to the UFS devices.
    The Extended UFS-Features use UFS query requests
    which are UFS private commands.
    In addition, other features are closely related with
    electrical and physical characteristics of UFS
   (such as Voltage, Gear-scaling and Runtime suspend/resume etc.,)
    and should be taken into consideration
 
Therefore, it is desirable to have those features managed 
separately from the original UFS driver.

Current extended UFS-Features which are approved by the JEDEC are as below:

  * UFS HPB
  * UFS WriteBooster

In addition to that, we are developing and testing various UFS-features
that would be beneficial in the Embedded system 
(At the moment, most of them would be Android system).
As we have already successfully provided enhanced features 
in cooperation with major Android Phone vendors,
now we willingly want to contribute our works to the Linux kernel mainline.
 

Currently, UFS driver (usually ufshcd.c) has become bulky and complex.
So, I would like to split these codes into layers 
like the works of Bean Huo and Avril Altman.
Especially, I suggest the UFS-Feature Driver model based on Linux Bus-Driver Model,
which is suitable to manage all Extended UFS-Feature drivers like the Figure as below:


UFS Driver data structure (struct ufs_hba)
   |
   |    -----------------------    -- ufshpb driver -- <- attach ufshpb device driver (it can be loadable)
   |---| ufs-ext feature layer |   -- ufs-wb driver -- <- attach ufswb device driver
   |   |                       |   -- ...           -- <- ...
   |    -----------------------    -- next ufs feature driver  -- <- attach ufs-next feature driver

* wb : write-booster
 

Each extended UFS-Feature Driver has a bus of ufs-ext feature type
and it is bound to the ufs-ext feature layer.
The ufs-ext feature layer manages common APIs used by each Extended UFS-Feature Driver.
The APIs consist of UFS Query request and 
UFS Vendor commands related to each ufs-ext feature driver. 


Furthermore, each ufs-ext feature driver will be written as a loadable kernel module.
Vendors (e.g., Android Phone manufacturer) could optionally load and remove each module.
Also they can customize the parameters of ufs-ext feature drivers
while each module is being loaded.
(For example, vendor would set the maximum memory size
 that can be reclaimed in the Host Control mode in HPB)


We are expecting that this kind of standardized and 
abstracted model will surely make it easier to manage the ufs-ext feature drivers.

I noticed that the ufs-wb (write-booster) patch was written by Asutosh Das and Stanley Chu. 
The basic idea of ufs-wb code is to proceed write boosting
in adjusting gear-scaling, which is a good idea that I did not think of.
I also would like to incorporate ufs-wb driver into the ufs-ext feature layer,
and in this way the footprint of UFS driver could be slimmed down likewise.

In brief, system vendors can optimize their system
by loading each ufs-ext feature driver selectively. 

As of now I am still working on the patch and
have it tested on the android phone with real UFS-HPB device on the stable androidzed kernel
as well as on a ufs-simulator based on QEMU to reflect latest kernel version with my team members. 

In addition, we plan to provide QEMU with UFS-simulator
for a test environment for UFS driver development.
I hope there will be a lot of comments on my idea
and patch set to be pushed in the near future
and I will willingly reflect every single opinion.

I will push up my patch set as soon as possible.

Thank you

