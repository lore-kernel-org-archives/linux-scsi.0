Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9895C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 22:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89CFB61040
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 22:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJ2Whe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 18:37:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33451 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ2Whe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 18:37:34 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211029223503epoutp046c7e48ed52632857ccad46fdfb4b8e02~yoT4rCtUf1740717407epoutp04E
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 22:35:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211029223503epoutp046c7e48ed52632857ccad46fdfb4b8e02~yoT4rCtUf1740717407epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635546903;
        bh=hy7AFC4W265SDo8nviZEasmF4BSTyYkkCmu+yF93+Wo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=BZe9YQB12j93f2msc29uf40FS62zumqLXlqeRUvQOuphlgntKqqbd+GFhKlaJVIrz
         4P9adOnnUcHGTTFqIcYv8m7lXcSfESsN1otK1xv4REnAkqmkA90PrvHzsbRufaxAU5
         jasnR29YMh5Hfec04Zu+equFytdPTU/mCBroOCsQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20211029223502epcas3p2acacfc3bcd77f6589f9673739dd775db~yoT35i_9L2346223462epcas3p2c;
        Fri, 29 Oct 2021 22:35:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4Hgy121NjWz4x9Q1; Fri, 29 Oct 2021 22:35:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v2] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20211029193002.4187-1-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01635546902168.JavaMail.epsvc@epcpadp3>
Date:   Sat, 30 Oct 2021 07:30:07 +0900
X-CMS-MailID: 20211029223007epcms2p100026018a238d5066d0946320c992056
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211029193014epcas2p10300c03ccf0337f9dd3653f29e2057d1
References: <20211029193002.4187-1-avri.altman@wdc.com>
        <CGME20211029193014epcas2p10300c03ccf0337f9dd3653f29e2057d1@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,
 
> @@ -1841,13 +1575,7 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
>          u32 entries_per_rgn;
>          u64 rgn_mem_size, tmp;
>  
> -        /* for pre_req */
> -        hpb->pre_req_min_tr_len = hpb_dev_info->max_hpb_single_cmd + 1;
> -
> -        if (ufshpb_is_legacy(hba))
> -                hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
> -        else
> -                hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
> +        hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;

They are should be not changed, because it makes ufshpb_is_supported_chunk()
determine to non-HPB READ when the its size is bigger than 4KB.

>  
>          hpb->cur_read_id = 0;
>  
> @@ -2858,8 +2586,7 @@ void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf)
>  void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
>  {
>          struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
> -        int version, ret;
> -        u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
> +        int version;
>  
>          hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
>  
> @@ -2875,13 +2602,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
>          if (version == HPB_SUPPORT_LEGACY_VERSION)
>                  hpb_dev_info->is_legacy = true;
>  
> -        ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> -                QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
> -        if (ret)
> -                dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
> -                        __func__);
> -        hpb_dev_info->max_hpb_single_cmd = max_hpb_single_cmd;
> -
>          /*
>           * Get the number of user logical unit to check whether all
>           * scsi_device finish initialization
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index a79e07398970..a4e7e33d451e 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -31,8 +31,6 @@
>  
>  /* hpb support chunk size */
>  #define HPB_LEGACY_CHUNK_HIGH                        1
> -#define HPB_MULTI_CHUNK_LOW                        7
> -#define HPB_MULTI_CHUNK_HIGH                        255

Because of above issue, they should be remained.

Thanks,
Daejun
