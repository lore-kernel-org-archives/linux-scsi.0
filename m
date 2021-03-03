Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B54C41519
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3FC64E02
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346416AbhCCMqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:46:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10585 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244236AbhCCDEk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 22:04:40 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210303023147epoutp022666e828c5b0e86dc06ff255a4216d89~otEyfO8Ld3125831258epoutp02K
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 02:31:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210303023147epoutp022666e828c5b0e86dc06ff255a4216d89~otEyfO8Ld3125831258epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614738707;
        bh=l6vq/WBBlvQg1WwwVK0qu86gyKgI6e+2OCjYuFyaH2s=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=V+ndImMJECzQ3hSha1k1jkYpFJI8Tvlv2qFHgiilZ7G+/mfxx9q7jnM/GyHv597u+
         HOY/novA/u3zQNDMb6D5yQdWGnd8Z7CrRAHYW7BUdd8bY9Qo0fL5N6ilUYu9VxTFYW
         kRnUmNMIlWGklTeFuXxRR/9N0qeyRxueNDiUf8FY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210303023146epcas2p2fed4fc2e5d474eec0720ffd8e2402cb1~otExnIdEn1646916469epcas2p2B;
        Wed,  3 Mar 2021 02:31:46 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DqygP22lgz4x9Q8; Wed,  3 Mar
        2021 02:31:45 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-ff-603ef5114ab9
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.99.56312.115FE306; Wed,  3 Mar 2021 11:31:45 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <f5cb5a04dd25984c4ddf7713ce0ffbbbbb969ea4.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210303023144epcms2p58b342049ed4aca3287beaedfcbcedf37@epcms2p5>
Date:   Wed, 03 Mar 2021 11:31:44 +0900
X-CMS-MailID: 20210303023144epcms2p58b342049ed4aca3287beaedfcbcedf37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmha7gV7sEgytz2CwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3gU0qPv6DjaL5cf/MVnc3sJlsXTrTUaLzulrWCwWLdzN4iDqcfmKt8flvl4m
        j52z7rJ7TFh0gNFj/9w17B4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFcEXl2GSkJqakFimk
        5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaikUJaYUwoUCkgsLlbS
        t7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L10vOz7UyNDAwMgWqTMjJ2LXxFXPBYYmK
        li93mBoYLwt0MXJySAiYSNz+sIKpi5GLQ0hgB6PE2zOPGLsYOTh4BQQl/u4QBqkRFrCX+Hi2
        nxHEFhJQklh/cRY7RFxP4tbDNWBxNgEdiekn7rODzBERWMoiMeX4MmYQh1ngF5PEiccfGCG2
        8UrMaH/KAmFLS2xfvhUszingLrFz9iWoGg2JH8t6mSFsUYmbq9+yw9jvj82HqhGRaL13FqpG
        UOLBz91QcUmJY7s/MEHY9RJb7/xiBDlCQqCHUeLwzlusEAl9iWsdG8GO4BXwldi6fjHYAhYB
        VYn3Kx8yg3wvIeAisbVVHiTMLCAvsf3tHLAws4CmxPpd+hAVyhJHbrHAfNWw8Tc7OptZgE+i
        4/BfuPiOeU+gLlOTWPdzPdMERuVZiJCehWTXLIRdCxiZVzGKpRYU56anFhsVGCFH7iZGcGrX
        ctvBOOXtB71DjEwcjIcYJTiYlUR4xV/aJgjxpiRWVqUW5ccXleakFh9iNAV6ciKzlGhyPjC7
        5JXEG5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C6WPi4JRqYJp0XaZJ5Oudawyu
        bc9M919/uX/r/d2xR4JNZ831alFaHiC1z9pKXydYuV/vF6OsVs/amyXf7mgmq0YeUDGNPcEZ
        z9QbsqXR63/pjk8GVafjp2wR375wrcFjF6YPjd3uLNaaMYv7HOXiLpgvq9dpmRj85OTMq0mv
        q3l9JHs+feNJ2qZUf/hvD4PE3TVL9gbIbgmeclpYKPZE9c9tDpuFP0t3Kz+QnLBn+rzZPUmK
        iv/Tdq7JLgiI0jEMORchbGe1ZWHM7elXI3w9/57YnZ0yUWqSuerq8xpdP6dts7p3flKMrk++
        lOOK35sz+blT3qWY2kjcWf3ZXJWhoGfeAuHi3ZOlvf/4rJln1Jp1d29bqxJLcUaioRZzUXEi
        ALIfA6R2BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210226073233epcms2p80fca2dffabea03143a9414838f757633
References: <f5cb5a04dd25984c4ddf7713ce0ffbbbbb969ea4.camel@gmail.com>
        <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
        <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
        <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > 
> >  static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
> >                                    struct ufshpb_region *rgn)
> >  {
> > @@ -1209,6 +1579,16 @@ static void ufshpb_lu_parameter_init(struct
> > ufs_hba *hba,
> >          u32 entries_per_rgn;
> >          u64 rgn_mem_size, tmp;
> >  
> > +        /* for pre_req */
> > +        if (hpb_dev_info->max_hpb_single_cmd)
> > +                hpb->pre_req_min_tr_len = hpb_dev_info-
> > >max_hpb_single_cmd;
> > +        else
> > +                hpb->pre_req_min_tr_len = HPB_MULTI_CHUNK_LOW;
>  
>  
> Here is not correct. according to Spec:
>  
> The size is calculated as ( bMAX_DATA_SIZE_FOR_HPB_SINGLE_CMD +1 )*4KB.
> 00h: 4KB
> 01h: 8KB
> 02h: 12KB
> 03h: 16KB
> ...
> FEh: 1020KB
> FFh: 1024KB
>  
> so, here if hpb_dev_info->max_hpb_single_cmd is 0x00, means 4KB, not
> 36KB.

OK,
 
> > +        hpb->pre_req_max_tr_len = max(HPB_MULTI_CHUNK_HIGH,
> > +                                      hpb->pre_req_min_tr_len);
> > +
> > 
> >  out:
> >          /* All LUs are initialized */
> >          if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
> > @@ -1812,8 +2307,9 @@ void ufshpb_get_geo_info(struct ufs_hba *hba,
> > u8 *geo_buf)
> >  void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
> >  {
> >          struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
> > -        int version;
> > +        int version, ret;
> >          u8 hpb_mode;
> > +        u32 max_hpb_sigle_cmd = 0;
> >  
> >          hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
> >          if (hpb_mode == HPB_HOST_CONTROL) {
> > @@ -1824,13 +2320,27 @@ void ufshpb_get_dev_info(struct ufs_hba *hba,
> > u8 *desc_buf)
> >          }
> >  
> >          version = get_unaligned_be16(desc_buf +
> > DEVICE_DESC_PARAM_HPB_VER);
> > -        if (version != HPB_SUPPORT_VERSION) {
> > +        if ((version != HPB_SUPPORT_VERSION) &&
> > +            (version != HPB_SUPPORT_LEGACY_VERSION)) {
> >                  dev_err(hba->dev, "%s: HPB %x version is not
> > supported.\n",
> >                          __func__, version);
> >                  hpb_dev_info->hpb_disabled = true;
> >                  return;
> >          }
> >  
> > +        if (version == HPB_SUPPORT_LEGACY_VERSION)
> > +                hpb_dev_info->is_legacy = true;
> > +
> > +        pm_runtime_get_sync(hba->dev);
> > +        ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> > +                QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0,
> > &max_hpb_sigle_cmd);
> > +        pm_runtime_put_sync(hba->dev);
> > +
> > +        if (ret)
> > +                dev_err(hba->dev, "%s: idn: read max size of single hpb
> > cmd query request failed",
> > +                        __func__);
> > +        hpb_dev_info->max_hpb_single_cmd = max_hpb_sigle_cmd;
> > +
>  
> Here you didn't add 1, if you read out the
> QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD == 7, means device can support
> maximum HPB Data size for using single HPB command is 7+1
> ((7+1)*4=32KB), not 7.

OK, Done.

Thanks,
Daejun
