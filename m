Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CB3C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B78E164EC3
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBVIRw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 03:17:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27678 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhBVIRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 03:17:46 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210222081702epoutp037f8db067646a414b6e92974c57618760~mA_qV5R0t0112701127epoutp03g
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2021 08:17:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210222081702epoutp037f8db067646a414b6e92974c57618760~mA_qV5R0t0112701127epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613981822;
        bh=RaZO9t9ohY1PMliAbeOJNK4HT74n3QKnCebIc+6OAPg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=s2dfT3CFYSu8TNvBChKbZSOEZobQ84cXoIQ6eG5V3UGLgQYwdfMv/p0PQTczcqoT3
         gEfsyEk+18lljGlWSdUALy5FLhZ43XpsMHpfKfi3QeC9SNQvgmYYhUwEDQiJBGSC77
         0Ci6TP+3V55fTks2An8r/xfUIjbs61LqfgW8+Xuk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210222081701epcas2p113f863ed909e1f861ff2c9f8099b02e2~mA_pdcg8E0770507705epcas2p1d;
        Mon, 22 Feb 2021 08:17:01 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DkZlv3FlKz4x9QH; Mon, 22 Feb
        2021 08:16:59 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-9f-6033687b93f5
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.65.05262.B7863306; Mon, 22 Feb 2021 17:16:59 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v21 2/4] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575F5244F17B022E6E78DC7FC829@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210222081658epcms2p4dcc6bfa0da7b6222cc4262a36374d3ad@epcms2p4>
Date:   Mon, 22 Feb 2021 17:16:58 +0900
X-CMS-MailID: 20210222081658epcms2p4dcc6bfa0da7b6222cc4262a36374d3ad
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmmW51hnGCwYaFYhYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWTy+85ndYtGN
        bUwW/f/aWSwu75rDZtF9fQebxfLj/5gsbm/hsli69SajRef0NSwWixbuZnEQ9bh8xdvjcl8v
        k8fOWXfZPSYsOsDosX/uGnaPlpP7WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgD5UUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbkZMx7vIyl4B5P
        xfRn35gaGJdwdDFyckgImEhc27uNrYuRi0NIYAejxJ77x1i7GDk4eAUEJf7uEAapERbwllix
        bT87iC0koCSx/uIsdoi4nsSth2sYQWw2AR2J6Sfus4PMERH4zSxx8e00VhCHWWAps8Tqpw3M
        ENt4JWa0P2WBsKUlti/fCtbNKRArMWPeRKi4hsSPZb1Q9aISN1e/ZYex3x+bzwhhi0i03jsL
        VSMo8eDnbqi4pMSx3R+YIOx6ia13fjGCHCEh0MMocXjnLVaIhL7EtY6NYMt4BXwlDj+/DjaI
        RUBV4n/3EjaIGheJfc0fwBYzC8hLbH87hxkUKswCmhLrd+mDmBICyhJHbrHAvNWw8Tc7OptZ
        gE+i4/BfuPiOeU+gTlOTWPdzPdMERuVZiKCehWTXLIRdCxiZVzGKpRYU56anFhsVGCPH7iZG
        cHLXct/BOOPtB71DjEwcjIcYJTiYlUR42e4aJQjxpiRWVqUW5ccXleakFh9iNAX6ciKzlGhy
        PjC/5JXEG5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C6WPi4JRqYOrTeDqf6+3D
        xms7og38T/kZ5jCG5DEUW1622hl99ae3LMf8x232kjEiqvbTHxSdP8Rrfe/W13jx3VvvLSkP
        9vk/xcGOb6t+9avnOw+tCOibNemoktaec6LNmjOTtaeH3XtneHL2ofiXzKf1zyuLRTlWX1O5
        vOLpe6XWk7P3nHxr99P2yPbr3h9zL//o+Gy9nvsa750k45Mbjq7xq6tZYX+mX7/401pBnWPL
        Tu8UV2A+dcQt6uGLJPl0hrO2aTxRs2Qs/mSZqf3aydxc/I19f03tJGuRpP7mQC/VyvCpXZNO
        2ddsrGj9XnZp8SfzPQuyQvoZlv244yJ+fENJdn3dGa+oHU+FeNXsJsY3HbRdFaTEUpyRaKjF
        XFScCAAPtVs0dwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210218090627epcms2p639c216ccebed773120121b1d53641d94
References: <DM6PR04MB6575F5244F17B022E6E78DC7FC829@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <20210218090747epcms2p8812c04126d57b789f471126055577ae8@epcms2p8>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
> > +                                        struct ufshcd_lrb *lrbp,
> > +                                        struct utp_hpb_rsp *rsp_field)
> > +{
> > +       if (be16_to_cpu(rsp_field->sense_data_len) != DEV_SENSE_SEG_LEN ||
> > +           rsp_field->desc_type != DEV_DES_TYPE ||
> > +           rsp_field->additional_len != DEV_ADDITIONAL_LEN ||
> > +           rsp_field->active_rgn_cnt > MAX_ACTIVE_NUM ||
> > +           rsp_field->inactive_rgn_cnt > MAX_INACTIVE_NUM ||
> > +           (rsp_field->hpb_op == HPB_RSP_REQ_REGION_UPDATE &&
> > +            !rsp_field->active_rgn_cnt && !rsp_field->inactive_rgn_cnt))
> > +               return false;
> > +
> > +       /* we cannot access HPB from other LU */
> > +       if (lrbp->lun != rsp_field->lun)
> > +               return false;
> Why not?
> Clearly this against the spec which allows to attach hpb sense crossed luns
>  
> > +
> > +       if (!ufshpb_is_general_lun(lrbp->lun)) {
> > +               dev_warn(hba->dev, "ufshpb: lun(%d) not supported\n",
> > +                        lrbp->lun);
> > +               return false;
> > +       }
> > +
> > +       return true;
> > +}
>  
>  
>  
>  
> > +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +{
> > +       struct ufshpb_lu *hpb = ufshpb_get_hpb_data(lrbp->cmd->device);
> > +       struct utp_hpb_rsp *rsp_field;
> > +       int data_seg_len;
> > +
> > +       if (!hpb)
> > +               return;
> Ditto

I fixed the code to support the crossed-hint.

Thanks,
Daejun
