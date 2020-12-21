Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBAAC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450EE22B47
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgLUCfE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:35:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17830 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgLUCfD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:35:03 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201221023421epoutp03fe32c879e94faf400aae283ad336a7e1~SmqeO72Qx2276022760epoutp03I
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 02:34:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201221023421epoutp03fe32c879e94faf400aae283ad336a7e1~SmqeO72Qx2276022760epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608518061;
        bh=fp4gOiOqykL1GaKNYZ64zOTsAI/FgsMnXVzzo7HTXGM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=HH9GbKtlrpQpZ3ni46AsKS/sLD3VI9VIGeDMcBw/XjZExuj2gbylFj4iJzKKUVpsd
         hocLgd9yqYN/hI+K5TbN6N2rSSpDkL6cPmnlrNjcws4FDThdzUXCulHx66ldYYxrg4
         Y6IIpNUt3v57lRZ+sKw2+fjercS/9sVWzm0cjlnk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201221023413epcas2p2b762a4709dca3e78daefd59426cabb44~SmqXN_8Mg1103811038epcas2p2w;
        Mon, 21 Dec 2020 02:34:13 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Czk7S2m18zMqYkn; Mon, 21 Dec
        2020 02:34:12 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-7a-5fe009a3cc90
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.1F.05262.3A900EF5; Mon, 21 Dec 2020 11:34:11 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v16 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Avri Altman <Avri.Altman@wdc.com>
CC:     Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <X934OOlXSf5up8Rd@kroah.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201221023407epcms2p1e5aaaff4fffcee73a0ecf422b078e888@epcms2p1>
Date:   Mon, 21 Dec 2020 11:34:07 +0900
X-CMS-MailID: 20201221023407epcms2p1e5aaaff4fffcee73a0ecf422b078e888
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te1BUZRjG5zvncM4uzTKHa1/gBB0nE+O22NJHSOpotg40MZFTY2PrGTjD
        YntzL2ZbTIwk0BJIQwmzQ4ggWCuyAS6sIC6wiFQwqFTgCgIzUBBBSJgSSu0F0um/3zzzvu/z
        vN+Fh/uNksG8TIWWUytYGUN6E832cFFkNX9cEvPPFW/UMPqbFxqvaCZRe24vhWaWfyKR/dY8
        hU4uLONo0VzrhWa6wpFp/C2UU20mUXl/NoYKT1hIVDXcjKHB1nISFQxZSXT26iqGbl3wRjWW
        mwB9WlpHoKrTbcSOAPHgj0niwaJCTHzROEqJi6s6gNj2VR0l/uQ7GyG+M+UgxEUXTED8Z+PT
        4ryOAizFe79sm5Rj0zl1GKdIU6ZnKjISmaRUyS6JKC5GGCmMRy8yYQpWziUyu5NTIvdkypzL
        MWFHWJnOKaWwGg0T/fI2tVKn5cKkSo02keFU6TKVUKiK0rByjU6REZWmlL8kjImJFTkrD8qk
        3ZOHVKX8o3/dGCKywTxpAHwepF+A7UVf4wbgzfOjrQBOOxaAAfB4AtoXPrT6u2r86Z2wcWqJ
        crEfzUDzdSPl0aOgY6IOuJikI2Bp75hbD6CT4MhIKeGaidM1JDSX3KU8ZgJYljdFeDgEtpy1
        uJv5dDgs+sHg5dE3w/u1hbiHA+HNc3PUOv/Rcwp4OAAev92/VuMLx5fb1vSnYE/bAubhj6Fl
        5G/gCgHpzwC0X3SsGUTDn/Mb3CEE9GuwfnDK3UDQz0LLvb61obudQwfcjNOhsGWuHHcdCu4M
        am6NdiGkN8JuB7G+VnbDCvV/xmkfmG9/+J9urZhci7YJ1i+bsWKw0fjopI2PeRkfeVUC3ASC
        OJVGnsFpYlVbH7/bRuB+51tetYKyuYWoLoDxQBeAPJwJEMQFj0n8BOnsB3pOrZSodTJO0wVE
        zi0/x4MD05TOj6LQSoSi2Li4mHgREsXFIuZJwb5viiR+dAar5d7jOBWnXu/DePzgbCxi+NLe
        X1njm6cWj+lXA1mt/HxEb9bWynPxOtOdDFvJck/lM4z5yEzZiuHqge7ekdP6JemQOqu2YEgd
        MrmJent2Kneg9LDSt2929nd7t34xVT89cfJ86IMA/Y6xpvkz+fsPDVMmyeXZps1e49L4eOpo
        8nNaReH0vuJXbvvcb2sKufZ69fY68zud8rwN35oOt6wm5D+4zOTYW7WE7YYjuuTMhtyPnvfx
        T+74Aj5RjB2LhTVBCSfKdobf+77/feuHxEqjVTd03CK/lPDlLseS9Jft4EBW58G+6/Xvhtua
        bEF7r/kvNKRor+QY5ir2THTy7lJe8+0rqfwQqXJgPiKPq30jtI8hNFJWuAVXa9h/AfEup7Vw
        BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae
References: <X934OOlXSf5up8Rd@kroah.com>
        <20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p2>
        <20201219091847epcms2p7afeebd03c47eed0b65f89375a881233e@epcms2p7>
        <X93XuJ4lsQbBgnU+@kroah.com>
        <DM6PR04MB6575AC2A541FCAAB60E581FBFCC20@DM6PR04MB6575.namprd04.prod.outlook.com>
        <CGME20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Greg, Avri

> On Sat, Dec 19, 2020 at 12:48:31PM +0000, Avri Altman wrote:
> > > 
> > > 
> > > On Sat, Dec 19, 2020 at 06:18:47PM +0900, Daejun Park wrote:
> > > > +static int ufshpb_get_state(struct ufshpb_lu *hpb)
> > > > +{
> > > > +     return atomic_read(&hpb->hpb_state);
> > > > +}
> > > > +
> > > > +static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
> > > > +{
> > > > +     atomic_set(&hpb->hpb_state, state);
> > > > +}
> > > 
> > > You have a lock for the state, and yet the state is an atomic variable
> > > and you do not use the lock here at all.  You don't use the lock at all
> > > infact...
> > > 
> > > So either the lock needs to be dropped, or you need to use the lock and
> > > make the state a normal variable please.
> > hpb_state_lock is mainly protecting the list of active regions.
> > Just grep  lh_lru_rgn in patch 2/3.
> 
> Then why is the lock added in this patch if it is not used here?

I think it comes from that the name of the lock and related comment is
different from the actual usage.
I will modify the name and related comments, and introduce the lock to the
patch 2/3.

Thanks,
Daejun
