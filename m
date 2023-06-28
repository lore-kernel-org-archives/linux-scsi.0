Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6550EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 07:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjF1HyQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 03:54:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30750 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjF1HxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 03:53:05 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230628075303epoutp01ccc4ede803fbeaef91d406758def04b7~sw2FgBIrG1102711027epoutp011
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 07:53:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230628075303epoutp01ccc4ede803fbeaef91d406758def04b7~sw2FgBIrG1102711027epoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1687938783;
        bh=5SJIduEkFWdgL+ozheqVl55Lzfi6QsqQ1cTudgwrAj0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=tm3E6I5GoAfADBPAZ55WIzJ/K6aFsMsT5jp3h5S/8q8uGAf7+JZU0wQUY1MafZGBs
         D8NGhoeVPmpJcKYySjEhDdQKYzNzZgefNXBeBT2WSgmoZIZd+bLxTWHZklyyWFcZsd
         v1pRoMLKwFZiYVjNez3UA5kv2oJI29uK38pGOBeQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230628075302epcas2p17dcae74542f6c644b66de11ecce18cc8~sw2E0FFei0440704407epcas2p1l;
        Wed, 28 Jun 2023 07:53:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4QrYjB42cgz4x9Q7; Wed, 28 Jun 2023 07:53:02 +0000
        (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230628074407epcas2p3ca6b907004b46ef392f62dd5b8200c59~swuSbs7An3234232342epcas2p3Y;
        Wed, 28 Jun 2023 07:44:07 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230628074407epsmtrp1bbd2171fd4b3d06e73b225084be51b6e~swuSYQveH3251632516epsmtrp1Z;
        Wed, 28 Jun 2023 07:44:07 +0000 (GMT)
X-AuditID: b6c32a52-fb1ff7000004fb63-d9-649be4c79245
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.4F.64355.7C4EB946; Wed, 28 Jun 2023 16:44:07 +0900 (KST)
Received: from KORCO118546 (unknown [10.229.38.108]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230628074407epsmtip2d36d70886b92bab38121ab6431551f79~swuSK_oRg2290422904epsmtip2p;
        Wed, 28 Jun 2023 07:44:07 +0000 (GMT)
From:   "hoyoung seo" <hy50.seo@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>
Cc:     <Arthur.Simchaev@wdc.com>, <JBottomley@Parallels.com>,
        <adrian.hunter@intel.com>, <athierry@redhat.com>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>, <jaegeuk@kernel.org>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <quic_asutoshd@quicinc.com>,
        <quic_ziqichen@quicinc.com>, <santoshsy@gmail.com>,
        <stanley.chu@mediatek.com>, <cpgs@samsung.com>,
        <sc.suh@samsung.com>, <kwmad.kim@samsung.com>,
        <kwangwon.min@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <c8bc7bde-ebdc-aea1-b875-0966e48c29ee@acm.org>
Subject: RE: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
Date:   Wed, 28 Jun 2023 16:44:06 +0900
Message-ID: <1296674576.21687938782544.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHRpLxm1iCTSI3Fh/XOpsori/TDRwMTjQvmAYHxJtyviyPrMA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf1CLcRzH+z7Ps2drjMcavvKjzHVHkZxf3/zscqfn6g7HHzrnsNseY221
        2+TY+ZGFWvkxJHqSS6kotWRNpaOFmyk61FllEhvXMSruNI5Y467/Xvd5/7j3Hx8eLvxEBPN2
        J+9hNMkSpZjkE5b74pB5Nle+LOqGVYTsrhskMpwp5aBes5uD+rwdJLL2GgiU2+/FUV/zHOQy
        sTh6fvIqBxU5LBiqddQTqNP8kEDZL+tIVGb7jaErmQUE+vn97N9oQSsXZTkdAJX89hCopLYT
        xIjoF+0JdD3r5NLFjX0YXVNuIGljUROgj9rvEfR3UyZJD7i7CNp+2UvSZxoP0V/udpD0KXM5
        oL/WzKAzmrKxDeO28FfIGOXuvYxm/qod/F2t+g+Yunr8vpzrLSANtI/NAoE8SC2Cw7YH3CzA
        5wmp2wDmlhzB/AKEw8X6fxwEe44+4PhNHwDU918EPoGkwuFpj5n0sYiaC02VdtxnwikDAa3t
        A7g/0QRgwevukapAajlkjV24j4OoGFhdN8TxMUGFwbbrxSN3ARUNy695gJ8nQHuei/AxTkXA
        k73HgJ9D4G3PJdw/LxR63aUc/4pYmP6j+59fBPMNx3EjCGJHVbGjqthRVeyoSCEgysFERq1V
        yVVS9YJIrUSlTU2WR0pTVDVg5CHCN9aBUtOvyGaA8UAzgDxcLBJMGrogEwpkkv06RpOyXZOq
        ZLTNYCqPEE8WzFIaZEJKLtnDJDGMmtH8VzFeYHAaFq8T9t+ULwbegJb+d0ekFR1rp+u5hdZj
        +UHjKi6aBVvOpWfEXm7LjF6apHjsTHVFhz6il1VaxuQ19ESvVpdFboiAISs8AV8CvlE2ftSB
        OzvlA3mmqxXpnJ1ln9A6Y8qhudSTh1W2ZbPVA3G5toyqFF1wfYDU0Thtfe3BqCI1WPhmyiBb
        PTRT97RQ/9QiDs4Zjt9mTOv5pYnf/HHN4txb+mmKWA7XNDFxeolZReie2bLeckUbuZsGJ48J
        /1H9/vNmp4TdZ+juSgx7nJ69pGIO17oyrvJCqULhbLC4LStXmdmP0sOZDa9iZzsSahU7EpcP
        ejZNbY04sbXTfb7tuTImTkxod0kWhOMareQPEyrHDn8DAAA=
X-CMS-MailID: 20230628074407epcas2p3ca6b907004b46ef392f62dd5b8200c59
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20230627012659epcas2p1961cc5bf75bf1a324f6f4fdebd7f897c
References: <CGME20230627012659epcas2p1961cc5bf75bf1a324f6f4fdebd7f897c@epcas2p1.samsung.com>
        <1891546521.01687833901791.JavaMail.epsvc@epcpadp3>
        <c8bc7bde-ebdc-aea1-b875-0966e48c29ee@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Wednesday, June 28, 2023 4:54 AM
> To: hoyoung seo <hy50.seo@samsung.com>
> Cc: Arthur.Simchaev@wdc.com; JBottomley@Parallels.com;
> adrian.hunter@intel.com; athierry@redhat.com; avri.altman@wdc.com;
> beanhuo@micron.com; jaegeuk@kernel.org; jejb@linux.ibm.com; linux-
> scsi@vger.kernel.org; martin.petersen@oracle.com;
> quic_asutoshd@quicinc.com; quic_ziqichen@quicinc.com; santoshsy@gmail.com;
> stanley.chu@mediatek.com; cpgs@samsung.com; sc.suh@samsung.com;
> kwmad.kim@samsung.com; kwangwon.min@samsung.com; sh425.lee@samsung.com
> Subject: Re: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
> 
> On 6/26/23 18:26, hoyoung seo wrote:
> > @@ -5408,7 +5406,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba
> *hba,
> >   	struct scsi_cmnd *cmd = lrbp->cmd;
> >
> >   	scsi_dma_unmap(cmd);
> > -	lrbp->cmd = NULL;	/* Mark the command as completed. */
> >   	ufshcd_release(hba);
> >   	ufshcd_clk_scaling_update_busy(hba);
> >   }
> >
> > Hi,
> > Is there any reason to delete "lrbp->cmd = NULL"?
> > As far as I know, clear to NULL to indicate that cmd is completed.
> >
> > When the UFS MCQ mode is activated, check that lrbp->cmd is NULL to
> check the completion of the command.
> > https://lore.kernel.org/linux-scsi/f0d923ee1f009f171a55c258d044e814ec0
> > 917ab.1685396241.git.quic_nguyenb@quicinc.com/
> >
> > If there is no special reason, why don't you add "lrb->cmd = NULL" again?
> 
> The lrbp->cmd = NULL assignment has been removed because if it would be
> kept the SCSI error handler would crash if it reuses a SCSI command. See
> also the
> scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() callers. The MCQ code
> should still work because it uses blk_mq_request_started() to check
> whether or not a request is still active.
> 
> Bart.

Hi,

Thank you for your kind reply.
Let me take a closer look at the code of the scsi layer

Seo.


