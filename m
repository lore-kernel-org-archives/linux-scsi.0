Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31065C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E180364ED6
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBVIQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 03:16:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39721 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhBVIQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 03:16:22 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210222081540epoutp016fe4c9d114d2c2cfc3d863049169ab2f~mA9do88jI1679416794epoutp012
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2021 08:15:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210222081540epoutp016fe4c9d114d2c2cfc3d863049169ab2f~mA9do88jI1679416794epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613981740;
        bh=yZ+s3MpgPT/FngOn6QtfjJgewjP5XWJxA/+2Vd9WU8Q=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=HXT4hft6eSwh7yREV5w7pwh4iIYSh+d1uO6CXaAfTzJ5xAkGz2IvCZVPuzwiea4IL
         6mmL5xh5dhSo+dJ3Mb63pF1zGr7dmAKf8eB7Q5v4NEkJ0fbyPvjEMAax8WbTWbBbNq
         y8mok6SXJXGgSlToLDrqhYG4ZseCOL9Pa6ix1sLg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210222081539epcas2p4869e9539da226f2d38ae6dea3aab9498~mA9coO_-E2148821488epcas2p4M;
        Mon, 22 Feb 2021 08:15:39 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DkZkK1WtQz4x9Px; Mon, 22 Feb
        2021 08:15:37 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-e0-603368276640
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.CD.10621.72863306; Mon, 22 Feb 2021 17:15:35 +0900 (KST)
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
In-Reply-To: <DM6PR04MB6575DFFA248FC9B5FD5BFBA4FC829@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210222081535epcms2p4429fd082538eb12ee0e763e62d5725a4@epcms2p4>
Date:   Mon, 22 Feb 2021 17:15:35 +0900
X-CMS-MailID: 20210222081535epcms2p4429fd082538eb12ee0e763e62d5725a4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmma56hnGCwesPshYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWTy+85ndYtGN
        bUwW/f/aWSwu75rDZtF9fQebxfLj/5gsbm/hsli69SajRef0NSwWixbuZnEQ9bh8xdvjcl8v
        k8fOWXfZPSYsOsDosX/uGnaPlpP7WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgD5UUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbkZLxb8oOtYA1r
        xeOVHxkbGE8zdzFyckgImEjsb5kPZHNxCAnsYJT4dO4jkMPBwSsgKPF3hzBIjbCAt8SKbfvZ
        QWwhASWJ9RdnsUPE9SRuPVzDCGKzCehITD9xnx1kjojAb2aJi2+nsYI4zAJLmSVWP22A2sYr
        MaP9KQuELS2xfflWsG5OgViJb3OOsEPENSR+LOuFqheVuLn6LTuM/f7YfEYIW0Si9d5ZqBpB
        iQc/d0PFJSWO7f7ABGHXS2y984sR5AgJgR5GicM7b7FCJPQlrnVsZIH40ldi4tFskDCLgKrE
        4TN9ULtcJF6eXA02n1lAXmL72zngQGEW0JRYv0sfxJQQUJY4cosF5quGjb/Z0dnMAnwSHYf/
        wsV3zHsCdZmaxLqf65kmMCrPQoT0LCS7ZiHsWsDIvIpRLLWgODc9tdiowBA5cjcxglO7lusO
        xslvP+gdYmTiYDzEKMHBrCTCy3bXKEGINyWxsiq1KD++qDQntfgQoynQlxOZpUST84HZJa8k
        3tDUyMzMwNLUwtTMyEJJnLfY4EG8kEB6YklqdmpqQWoRTB8TB6dUA9NZaQdBc5HvNil7gqYw
        J63iupvwwauqeVI+v/AcFrXLayqDC7kD6tQ0d/I9+jSVidHEsID14gUrV+fm/QlfnlsLl/y4
        sKmqVMXggSH/IpHH2nNLtopytybJsH8Jk3ubuqZijojF9P8Fn4Q+1U3eK5fhGxN6b9P0pV1N
        YlP/yyQcUOqulhH2Cp39c57gLYdSlbfvr1xq5p/6wzTbhu1SddSZlKncnR1KzYfkH5bFZe5h
        KL2x/a7gncx9199enly6eOM102d/k1/Yu54tfChv2c5zqKL0H/f83qMa0xbKzZgVf8W8dono
        AZdLf3T+brD4c10n8+xD2/+h6mJt/5TK5CQ92o0XT2CTFJibdmVejBJLcUaioRZzUXEiALMV
        Z+d2BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210218090627epcms2p639c216ccebed773120121b1d53641d94
References: <DM6PR04MB6575DFFA248FC9B5FD5BFBA4FC829@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <20210218090747epcms2p8812c04126d57b789f471126055577ae8@epcms2p8>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +{
> > +       struct ufshpb_lu *hpb = ufshpb_get_hpb_data(lrbp->cmd->device);
> > +       struct utp_hpb_rsp *rsp_field;
> > +       int data_seg_len;
> > +
> > +       if (!hpb)
> > +               return;
> > +
> > +       if (ufshpb_get_state(hpb) != HPB_PRESENT) {
> > +               dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> > +                          "%s: ufshpb state is not PRESENT\n", __func__);
> > +               return;
> > +       }
> Theoretically, SSU response upiu may carry hpb sense data, isn't it?
> 
I fixed code to add HPB hint with suspend state.

Thanks,
Daejun
