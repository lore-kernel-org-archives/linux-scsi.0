Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126F3C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CECA0208A9
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:25:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="s9iB4hk7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHMCZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 22:25:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12741 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgHMCZG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 22:25:06 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200813022504epoutp01a6b020825e4beda5298fea8ed49f8721~qsrQGF0m50623606236epoutp01O
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 02:25:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200813022504epoutp01a6b020825e4beda5298fea8ed49f8721~qsrQGF0m50623606236epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597285504;
        bh=bBoSIYfYUVBe91z7Hl3yBvlXhwhzlVC2LnJY5UtikfE=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=s9iB4hk7yXizxTQtC9T5ImjEwFr9TW4T2/lS/JSMaBdzdD5eOBD9xlGIrt1BJ8zqV
         p2Jfh2rCP8flZAu1TCPibyLeG4lxsl9S/DYn6o7UQ6lJTAONAldAFartLdm4zDKWZ4
         fMuF2k11XzVUzUOxpfO1rkPVmVRlOvgAg1wv14PU=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200813022503epcas1p1d9386e2dfbde1e0d35e9c397f0670723~qsrPo9Klz3219232192epcas1p1K;
        Thu, 13 Aug 2020 02:25:03 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v8 2/4] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <4a91d02c-488c-86cd-325c-5e0ad9addd0b@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1239183618.61597285503620.JavaMail.epsvc@epcpadp1>
Date:   Thu, 13 Aug 2020 11:13:09 +0900
X-CMS-MailID: 20200813021309epcms2p3d87ce0c4c54389cc3d30b876684936d0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d
References: <4a91d02c-488c-86cd-325c-5e0ad9addd0b@acm.org>
        <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
        <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-08-06 02:11, Daejun Park wrote:
> > +static void ufshpb_issue_hpb_reset_query(struct ufs_hba *hba)
> > +{
> > +    int err;
> > +    int retries;
> > +
> > +    for (retries = 0; retries < HPB_RESET_REQ_RETRIES; retries++) {
> > +        err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> > +                QUERY_FLAG_IDN_HPB_RESET, 0, NULL);
> > +        if (err)
> > +            dev_dbg(hba->dev,
> > +                "%s: failed with error %d, retries %d\n",
> > +                __func__, err, retries);
> > +        else
> > +            break;
> > +    }
> > +
> > +    if (err) {
> > +        dev_err(hba->dev,
> > +            "%s setting fHpbReset flag failed with error %d\n",
> > +            __func__, err);
> > +        return;
> > +    }
> > +}
> 
> Please change the "break" into an early return, remove the last
> occurrence "if (err)" and remove the final return statement.

OK, I will.

> 
> > +static void ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
> > +{
> > +    int err;
> > +    bool flag_res = true;
> > +    int try = 0;
> > +
> > +    /* wait for the device to complete HPB reset query */
> > +    do {
> > +        if (++try == HPB_RESET_REQ_RETRIES)
> > +            break;
> > +
> > +        dev_info(hba->dev,
> > +            "%s start flag reset polling %d times\n",
> > +            __func__, try);
> > +
> > +        /* Poll fHpbReset flag to be cleared */
> > +        err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> > +                QUERY_FLAG_IDN_HPB_RESET, 0, &flag_res);
> > +        usleep_range(1000, 1100);
> > +    } while (flag_res);
> > +
> > +    if (err) {
> > +        dev_err(hba->dev,
> > +            "%s reading fHpbReset flag failed with error %d\n",
> > +            __func__, err);
> > +        return;
> > +    }
> > +
> > +    if (flag_res) {
> > +        dev_err(hba->dev,
> > +            "%s fHpbReset was not cleared by the device\n",
> > +            __func__);
> > +    }
> > +}
> 
> Should "polling %d times" perhaps be changed into "attempt %d"?

I will change it.

> The "if (err)" statement may be reached without "err" having been
> initialized. Please fix.

OK, I will initialize err to 0.

> Additionally, please change the do-while loop into a for-loop, e.g. as
> follows:
> 
>     for (try = 0; try < HPB_RESET_REQ_RETRIES; try++)
>         ...

OK, I will change do-while to for-loop.

Thanks,

Daejun
