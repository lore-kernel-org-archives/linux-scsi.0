Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E70DC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 05:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D071960F91
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 05:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhG1FnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 01:43:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39645 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhG1FnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 01:43:05 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210728054303epoutp0273ad8989daa732dfd7ef3ffd0d8f985e~V3gvqN17W2096320963epoutp02V
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 05:43:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210728054303epoutp0273ad8989daa732dfd7ef3ffd0d8f985e~V3gvqN17W2096320963epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627450983;
        bh=evLbZQmnWSYds85XDS8YxQQPRr+aceNo1PP5/vPEgmQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=rFWHprDEqlIeudfQIQhwyEsqPBc2dXc2gFZ5s6pHevg5a304Knw7/N7HNew4kz1Ak
         AhgUN0kwA+N3ctc6E5p3w0tY8p9tK4fWbe7tIYkWPmuNkfFsXEallfgZFlZv9LSj3d
         wFWoO1Cn3ZZoWuDLosv9cKTr1jIlBpS1sauo0pBY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210728054302epcas3p2a02c08b1979b1ab6e337cfe7c8d71399~V3gu4U4fl2857528575epcas3p2y;
        Wed, 28 Jul 2021 05:43:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GZMyG1m0lz4x9QL; Wed, 28 Jul 2021 05:43:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 2/3] scsi: ufs: Map the correct size to the rpmb unit
 descriptor
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210727123546.17228-3-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21627450982237.JavaMail.epsvc@epcpadp4>
Date:   Wed, 28 Jul 2021 14:06:39 +0900
X-CMS-MailID: 20210728050639epcms2p7d9d9973d58c5ee7a23046462ee983796
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210727123637epcas2p23457bd807cee66ec4c4e487a3a15ef33
References: <20210727123546.17228-3-avri.altman@wdc.com>
        <20210727123546.17228-1-avri.altman@wdc.com>
        <CGME20210727123637epcas2p23457bd807cee66ec4c4e487a3a15ef33@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 579cf6f9e7a1..d0be8d4c8091 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -167,6 +167,7 @@ enum desc_idn {
>          QUERY_DESC_IDN_GEOMETRY                = 0x7,
>          QUERY_DESC_IDN_POWER                = 0x8,
>          QUERY_DESC_IDN_HEALTH           = 0x9,
> +        QUERY_DESC_IDN_UNIT_RPMB        = 0xA,
>          QUERY_DESC_IDN_MAX,

By adding QUERY_DESC_IDN_UNIT_RPMB, the value of QUERY_DESC_IDN_MAX is
changed to 0xB.
...

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 74ccfd2b80ce..eec1bc95391b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3319,11 +3319,13 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
>   * @desc_len: mapped desc length (out)
>   */
>  void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
> -                                  int *desc_len)
> +                                  int desc_index, int *desc_len)
>  {
>          if (desc_id >= QUERY_DESC_IDN_MAX || desc_id == QUERY_DESC_IDN_RFU_0 ||
>              desc_id == QUERY_DESC_IDN_RFU_1)
>                  *desc_len = 0;

So, if user sending desc_id as 0xA, it can not be detected as invalid descriptor.

> +        else if (desc_index == UFS_UPIU_RPMB_WLUN)
> +                *desc_len = hba->desc_size[QUERY_DESC_IDN_UNIT_RPMB];
>          else
>                  *desc_len = hba->desc_size[desc_id];
>  }

Thanks,
Daejun
