Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6DEC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 21:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 176586023E
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 21:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhJ1VXN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:23:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51415 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhJ1VXI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 17:23:08 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211028212038epoutp0176927788baab87c0bade5395732b2d0f~yTpoxAOaj2949929499epoutp01n
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 21:20:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211028212038epoutp0176927788baab87c0bade5395732b2d0f~yTpoxAOaj2949929499epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635456038;
        bh=/EjSMhYGEm/nCsr4I+KeyH40YJhIhGSu1lbsTf35ye8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=MxT4e2IXzncwnAy8TW3eieJKu/39Rb3bpVpmVGOeycRz3ZDVs0CSSRi0bxn6oGMaJ
         AZIYw0Pdw/wM0SPnySqiuGw76fNj51YSzN8C/dAV3GW3M895s4wiZMzXeGOlytmYNV
         tCU+vzTcryysNWs1L91c4RrRic5rnaQHUgpmzMp0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211028212038epcas2p209d36abeb5a729b6cf660e20b0ce7c48~yTpoPtwaV0419104191epcas2p2u;
        Thu, 28 Oct 2021 21:20:38 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.102]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HgJPb1LdMz4x9Pp; Thu, 28 Oct
        2021 21:20:35 +0000 (GMT)
X-AuditID: b6c32a48-d73ff70000002f6d-54-617b14228eb7
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.BF.12141.2241B716; Fri, 29 Oct 2021 06:20:34 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1d7c1faf6b6fa71599b5157ae95fc48ce479b722.camel@linux.ibm.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211028212034epcms2p82a6b0527e18ab6e3208e37a6188bf203@epcms2p8>
Date:   Fri, 29 Oct 2021 06:20:34 +0900
X-CMS-MailID: 20211028212034epcms2p82a6b0527e18ab6e3208e37a6188bf203
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJsWRmVeSWpSXmKPExsWy7bCmua6SSHWiwYTnlhYP5m1js3j58yqb
        xeq7/WwW0z78ZLZ4eUjTYtWDcIuVq48yWcw528BksejGNiaL4yffMVrsvaVtcXnXHDaL7us7
        2CyWH//H5MDncfmKt8fOWXfZPS6fLfWYsOgAo8fumw1sHh+f3mLx6NuyitHj8yY5j/YD3UwB
        nFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhysp
        lCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswL9IoTc4tL89L18lJLrAwNDIxMgQoT
        sjN+L2tgKvjDXfHp0Xf2BsbNnF2MnBwSAiYSt5cdYOti5OIQEtjBKDGl4RZLFyMHB6+AoMTf
        HcIgNcICbhLLV01iBLGFBJQk1l+cxQ4R15O49XANWJxNQEdi+on77CBzRASeM0ncWrudFcRh
        FvjLKPHlywoWiG28EjPan0LZ0hLbl28F6+YU8JY4ua4dKq4h8WNZLzOELSpxc/Vbdhj7/bH5
        jBC2iETrvbNQNYISD37uhopLShzb/YEJwq6X2HrnFyPIERICPYwSh3feYoVI6Etc69gItoxX
        wFdi8sGDYM0sAqoS23d/ZoOocZFY23MSrIZZQF5i+9s5zKBQYRbQlFi/Sx/ElBBQljhyC+6t
        ho2/2dHZzAJ8Eh2H/8LFd8x7AnWamsS6n+uZJjAqz0IE9Swku2Yh7FrAyLyKUSy1oDg3PbXY
        qMAEHrvJ+bmbGMGJWMtjB+Pstx/0DjEycTAeYpTgYFYS4b08rzxRiDclsbIqtSg/vqg0J7X4
        EKMp0JcTmaVEk/OBuSCvJN7QxNLAxMzM0NzI1MBcSZzXUjQ7UUggPbEkNTs1tSC1CKaPiYNT
        qoEp8kG545LriyU+WvKeMOpa3nrq5HaleyFbF2x576vTLnXK9fLXxYe9uebzbFuiWdp+vcNA
        6tevyzrbPK9Hfp6ycfNppw+/19gxbbp7lFVP9Krsly8/pnHa/2A6/YeJWTZhRrXd1S2CT/Ty
        TWxWr9zl2Nl5b7vCvltCun+iWnztPx1k5tW7/sHsjpiIVeLlNdvO8Pb6OT6u+M7tp7l2odyL
        Dzfb9qhcztqyk/+UpJE244NU7v2WLq79jmLqK/eZGqefKYrka5U/J/lTeoYy4/ry+WodDuXL
        p9aJnDZ7tIC1SaHZoDreKynfZdH36ZsnBfnkrE7flXaaM+PNs5IXsyfsitNvu73oL5eh5GL1
        l2GblFiKMxINtZiLihMBEeq3pE0EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff
References: <1d7c1faf6b6fa71599b5157ae95fc48ce479b722.camel@linux.ibm.com>
        <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
        <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
        <0d66b6d0-26c6-573f-e2a0-022e22c47b52@acm.org>
        <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

> On Thu, 2021-10-28 at 08:59 -0700, Bart Van Assche wrote:
> > On 10/28/21 7:28 AM, James Bottomley wrote:
> > > If the block people are happy with this, then I'm OK with it, but
> > > it
> > > doesn't look like you've solved the fanout deadlock problem because
> > > this new mechanism is still going to allocate a new tag.
> > 
> > (+Jens, Christoph and linux-block)
> > 
> > Hi James,
> > 
> > My understanding is that the UFS HPB code makes ufshcd_queuecommand()
> > return SCSI_MLQUEUE_HOST_BUSY if the pool with pre-allocated requests
> > is exhausted. This will make the SCSI core reissue a SCSI command
> > until completion of another command has freed up one of the pre-
> > allocated requests. This is not the most efficient approach but
> > should not trigger a deadlock.
>  
> I think the deadlock is triggered if the system is down to its last
> reserved request on the memory clearing device and the next entry in
> the queue for this device is one which does a fanout so we can't
> service it with the single reserved request we have left for the
> purposes of making forward progress.  Sending it back doesn't help,
> assuming this is the only memory clearing path, because retrying it
> won't help ... we have to succeed with a request on this path to move
> forward with clearing memory.
The above approach can retry several times (before the HPB timeout) but, it
gives up to allocate pre-request and it sends as just READ. So deadlock can
be avoided.

Thanks,
Daejun
