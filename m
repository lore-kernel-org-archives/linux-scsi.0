Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D26C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 06:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF999600EF
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 06:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhG1G6I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 02:58:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60041 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbhG1G6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 02:58:06 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210728065803epoutp01d5addb9aa31162af1b6e9fb545bfa07a~V4iOyeuQ_1509615096epoutp01h
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 06:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210728065803epoutp01d5addb9aa31162af1b6e9fb545bfa07a~V4iOyeuQ_1509615096epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627455483;
        bh=H2o4m4pKd0K9U3wtLTLdqOwHzB37lZW8wBYjITgRe3U=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=qOyxVsLMU77kz9VYQ6rH3qI1bM7JaQIv3Ad0gsX62DfZ1S4K8zKGjt7UJNT0Lwa7b
         UhMyiUCF9BJ6p+hd7Gwit9q1mL5Cd4jnXN/UbxR9K60Z4vzo6+Q0S/ChpaZCMjOAfM
         qmDwUgiTVW8GFNJs9V9VrQcW4JqEGIq0WVW+INsM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210728065802epcas3p2c765b5a5bf016ce1649de7d2288bc64d~V4iOOaTNF1541415414epcas3p2J;
        Wed, 28 Jul 2021 06:58:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GZPcp4m8Fz4x9Py; Wed, 28 Jul 2021 06:58:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 06/18] scsi: ufs: Remove ufshcd_valid_tag()
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-7-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21627455482667.JavaMail.epsvc@epcpadp4>
Date:   Wed, 28 Jul 2021 15:48:16 +0900
X-CMS-MailID: 20210728064816epcms2p4dbbf9b7182422ed2ee53b4b64aa4e9da
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033524epcas2p31e41c1db6883aaa644edf23bbe8a1ca2
References: <20210722033439.26550-7-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033524epcas2p31e41c1db6883aaa644edf23bbe8a1ca2@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> @@ -6979,24 +6966,15 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>   */
>  static int ufshcd_abort(struct scsi_cmnd *cmd)
>  {
> -        struct Scsi_Host *host;
> -        struct ufs_hba *hba;
> +        struct Scsi_Host *host = cmd->device->host;
> +        struct ufs_hba *hba = shost_priv(host);
> +        unsigned int tag = cmd->request->tag;
> +        struct ufshcd_lrb *lrbp = &hba->lrb[tag];

If tag < 0, lrbp will be assigned incorrect pointer.

>          unsigned long flags;
> -        unsigned int tag;
>          int err = 0;
> -        struct ufshcd_lrb *lrbp;
>          u32 reg;
>  
> -        host = cmd->device->host;
> -        hba = shost_priv(host);
> -        tag = cmd->request->tag;
> -        lrbp = &hba->lrb[tag];
> -        if (!ufshcd_valid_tag(hba, tag)) {
> -                dev_err(hba->dev,
> -                        "%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
> -                        __func__, tag, cmd, cmd->request);
> -                BUG();
> -        }
> +        WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>  
>          ufshcd_hold(hba, false);
>          reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);

Thanks,
Daejun
