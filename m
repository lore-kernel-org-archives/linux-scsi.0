Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163ACC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 10:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347912AbiDLKF2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380839AbiDLIWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 04:22:43 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED69C4F462
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 00:51:43 -0700 (PDT)
X-UUID: 7a848ed315a6432a9cc4ded1bb433ab4-20220412
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:1ef5052d-7089-44d8-be8d-449538440eb3,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-20,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:-20
X-CID-META: VersionHash:faefae9,CLOUDID:cc01dfa8-d103-4e36-82b9-b0e86991b3df,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,File:nil,QS:0,BEC:nil
X-UUID: 7a848ed315a6432a9cc4ded1bb433ab4-20220412
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1523113766; Tue, 12 Apr 2022 15:51:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 12 Apr 2022 15:51:36 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Apr 2022 15:51:36 +0800
Message-ID: <4a13e84b5085c03f092a46ebac41690bd57bef3a.camel@mediatek.com>
Subject: Re: Please check ufshpb init flow
From:   Po-Wen Kao <powen.kao@mediatek.com>
To:     "=?UTF-8?Q?=EC=A0=95=EC=9A=94=ED=95=9C=28JOUNG?= YOHAN) Mobile SE" 
        <yohan.joung@sk.com>, Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "=?UTF-8?Q?=EC=B5=9C=EC=9E=AC=EC=98=81=28CHOI?= JAE YOUNG) Mobile SE" 
        <jaeyoung21.choi@sk.com>,
        "=?UTF-8?Q?=EA=B3=BD=ED=83=9C=EC=88=98=28KWAK?= TAESU) Mobile SE" 
        <taesu.kwak@sk.com>
Date:   Tue, 12 Apr 2022 15:51:36 +0800
In-Reply-To: <4d2331ea33a246c78fcabaf1ca4e0b10@sk.com>
References: <e092e35414844175bf76868b820d907f@sk.com>
         <b06d9a87232a6d4e90fe635384a83c48586652e9.camel@gmail.com>
         <4d2331ea33a246c78fcabaf1ca4e0b10@sk.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Yohan and Bean,

I have propose a patch to remove ufshpb_issue_umap_all_req as we also
consider this a redundant operation.

Please refer to topic "[PATCH 1/1] scsi: ufs: remove redundant HPB
unmap". Feel free to leave comments there. 
Thanks~
Po-Wen
 
On Tue, 2021-11-23 at 05:19 +0000, 정요한(JOUNG YOHAN) Mobile SE wrote:
> > it's for "Inactivating all HPB regions" after reboot
> > 
> > scsi_add_lun()...>ufshpb_issue_umap_all_req(hpb);
> > 
> > if it is a cold reboot on both host side and UFS device side, it is
> > not
> > necessary to issue this write buffer.
> 
> According to you, is ufshpb_issue_umap_all_req used only for host
> reset?
> During boottime, the problem is that the hpb is set to the last LUN,
> write buffer command is sent before sd_probe completes.
> so, instead of performing unmap, UAC is returned. 
> If ufshpb_issue_umap_all_req is not needed in cold boot, it seems
> necessary to move it to an appropriate location or remove
> > 
> > 
> > On Fri, 2021-11-19 at 02:31 +0000, 정요한(JOUNG YOHAN) Mobile SE
> > wrote:
> > > Hi daejun
> > > 
> > > Please check ufshpb init flow.
> > > sending write buffer(0x03) seems spec violation (JESD220 Commands
> > > for
> > > exceptional behavior on UAC, SAM 5r05) before UAC clear
> > > (sd_probe).
> > > Anyway hpb reset query(ufshpb_check_hpb_reset_query) seems
> > > sufficient.
> > > Why do we need to send write buffer?
> > > 
> > > void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device
> > > *sdev)
> > > {
> > > out:
> > >     /* All LUs are initialized */
> > >     if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
> > > 	There seems to be a problem with this logic.
> > > 	If hpb is set on the last LUN, write buffer command is sent
> > > before
> > > sd_probe completes.
> > >         ufshpb_hpb_lu_prepared(hba);
> > > }
> > > 
> > > static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba) {
> > > 
> > >     init_success = !ufshpb_check_hpb_reset_query(hba);
> > > 
> > >     shost_for_each_device(sdev, hba->host) {
> > >         hpb = ufshpb_get_hpb_data(sdev);
> > >         if (!hpb)
> > >             continue;
> > > 
> > >         if (init_success) {
> > >             ufshpb_set_state(hpb, HPB_PRESENT);
> > >             if ((hpb->lu_pinned_end - hpb->lu_pinned_start) > 0)
> > >                 queue_work(ufshpb_wq, &hpb->map_work);
> > >             if (!hpb->is_hcm)
> > >                 ufshpb_issue_umap_all_req(hpb);
> > > 		This seems unnecessary.
> > > 
> > >         } else {
> > > 
> > > Thanks
> > > yohan
> 
> 

