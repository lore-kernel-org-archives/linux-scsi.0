Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E587C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A5A520639
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N1re7Zin"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgHMDSH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 23:18:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11541 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgHMDSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 23:18:06 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200813031803epoutp02d5f95cbe2595ff11bf3e95ef3a3d6a1b~qtZhiKagx0591305913epoutp02N
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 03:18:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200813031803epoutp02d5f95cbe2595ff11bf3e95ef3a3d6a1b~qtZhiKagx0591305913epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597288683;
        bh=HLhlMCrzJldkYU0pohTAFN2CsR5VsqyD7Nzjck6qsfs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=N1re7ZinjFx7TNcq5w/zX2dUiw0FVncK65LwtCf+huXtzaY9QSyafEgJhRTg+j/hA
         PbvQR2KNke1r6ZBOlPzAypCeFs2YRqR69NKXmKFW/zlWMYwmTMIOBXW8Y5be0S2RHr
         F7y284za+YdZwLeb4eWKf7Va3HLjUwbIsioVQvdA=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200813031803epcas1p38673e33d4c6fdc05398577e525a77161~qtZhKun-71816918169epcas1p3j;
        Thu, 13 Aug 2020 03:18:03 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v8 3/4] scsi: ufs: L2P map management for HPB read
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
In-Reply-To: <86a04d4f-bb6f-9bc8-cb64-a50b0ed2fdb7@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <336371513.41597288683542.JavaMail.epsvc@epcpadp2>
Date:   Thu, 13 Aug 2020 12:13:43 +0900
X-CMS-MailID: 20200813031343epcms2p2dfe9192d11110a80454c6daac69ecdc7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d
References: <86a04d4f-bb6f-9bc8-cb64-a50b0ed2fdb7@acm.org>
        <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
        <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <336371513.41596705485601.JavaMail.epsvc@epcpadp2>
        <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-06 02:15, Daejun Park wrote:
> > +    req->end_io_data = (void *)map_req;
> 
> Please leave the (void *) cast out since explicit casts from a non-void
> to a void pointer are not necessary in C.

OK, I will fix it.
 
> > +static inline struct
> > +ufshpb_rsp_field *ufshpb_get_hpb_rsp(struct ufshcd_lrb *lrbp)
> > +{
> > +    return (struct ufshpb_rsp_field *)&lrbp->ucd_rsp_ptr->sr.sense_data_len;
> > +}
> 
> Please introduce a union in struct utp_cmd_rsp instead of using casts
> to reinterpret a part of a data structure.

OK. I will introduce a union in struct utp_cmd_rsp and use it.

> > +/* routine : isr (ufs) */
> 
> The above comment looks very cryptic. Should it perhaps be expanded?
> 
> > +struct ufshpb_active_field {
> > +    __be16 active_rgn;
> > +    __be16 active_srgn;
> > +} __packed;
> 
> Since "__packed" is not necessary for the above data structure, please
> remove it. Note: a typical approach in the Linux kernel to verify that
> the compiler has not inserted any padding bytes is to add a BUILD_BUG_ON()
> statement in an initialization function that verifies the size of ABI data
> structures. See also the output of the following command:
> 
> git grep -nH 'BUILD_BUG_ON.sizeof.*!='

OK, I didn't know about it. Thanks.

> > +struct ufshpb_rsp_field {
> > +    __be16 sense_data_len;
> > +    u8 desc_type;
> > +    u8 additional_len;
> > +    u8 hpb_type;
> > +    u8 reserved;
> > +    u8 active_rgn_cnt;
> > +    u8 inactive_rgn_cnt;
> > +    struct ufshpb_active_field hpb_active_field[2];
> > +    __be16 hpb_inactive_field[2];
> > +} __packed;
> 
> I think the above __packed statement should also be left out.

OK, I will remove it.

Thanks,
Daejun
