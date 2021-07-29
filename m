Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032C1C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D09E26103E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhG2AxH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:53:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57862 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhG2AxG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 20:53:06 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210729005303epoutp02bb29231f75226ba6b72cd8f2889c1719~WHM08dPXW2917829178epoutp02X
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:53:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210729005303epoutp02bb29231f75226ba6b72cd8f2889c1719~WHM08dPXW2917829178epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627519983;
        bh=TsrHTWhu5orVlLBKn8sKkW9yTTM+HqYvYE5BZpdCRoM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=dbFcVP6NiXnk8YW0bELWiT/Y3BwpevWYE1ju+juuayn9Q/m2d0CZtGTJ8u4Ce9QGN
         m3y+Kj9COMNN/D/xsI5zhyDoIKYKetNE+VEOkFnDDG5XXG+LwHsZietjLSwYEXRc+5
         WOhVc0UMvFzQattAe3ske06IP03lABgRzcXV0Fr4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210729005302epcas3p40f30f166e4ac5985e2c5025f9d2e6ee7~WHM0TwxZp0722207222epcas3p4S;
        Thu, 29 Jul 2021 00:53:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GZsTB33J5z4x9Q8; Thu, 29 Jul 2021 00:53:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE:(2) [PATCH v3 06/18] scsi: ufs: Remove ufshcd_valid_tag()
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Daejun Park <daejun7.park@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2f95ca58-8f9d-c756-cb08-44c0bbc297aa@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01627519982380.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 09:26:35 +0900
X-CMS-MailID: 20210729002635epcms2p7713353bdd740da8e800bc36008137200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033524epcas2p31e41c1db6883aaa644edf23bbe8a1ca2
References: <2f95ca58-8f9d-c756-cb08-44c0bbc297aa@acm.org>
        <20210722033439.26550-7-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <2038148563.21627455482667.JavaMail.epsvc@epcpadp4>
        <CGME20210722033524epcas2p31e41c1db6883aaa644edf23bbe8a1ca2@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>On 7/27/21 11:48 PM, Daejun Park wrote:
>>> @@ -6979,24 +6966,15 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>>>    */
>>>   static int ufshcd_abort(struct scsi_cmnd *cmd)
>>>   {
>>> -        struct Scsi_Host *host;
>>> -        struct ufs_hba *hba;
>>> +        struct Scsi_Host *host = cmd->device->host;
>>> +        struct ufs_hba *hba = shost_priv(host);
>>> +        unsigned int tag = cmd->request->tag;
>>> +        struct ufshcd_lrb *lrbp = &hba->lrb[tag];
>> 
>> If tag < 0, lrbp will be assigned incorrect pointer.
> 
>That shouldn't hurt since lrbp is only used after it has been verified 
>that tag >= 0.
OK, I got it.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
> 
>Thanks,
> 
>Bart.
> 
> 
> 
