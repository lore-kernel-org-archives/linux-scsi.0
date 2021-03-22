Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8738C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A514B61943
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhCVAuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 20:50:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19956 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVAuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 20:50:24 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210322005021epoutp04811c177c1473bb336e386a7114e4698c~ug8pZDT5M3090130901epoutp04N
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 00:50:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210322005021epoutp04811c177c1473bb336e386a7114e4698c~ug8pZDT5M3090130901epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616374221;
        bh=L/hkVWVKzZgrw24gfzg50jfNud1P1BWJRoRwzfTU8jI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=GMcpTgJ4fE4Vw06S1qkOmpJOZ+a6a1J0N224pi2nw98sepP+nHVmSLaweEKkEeTis
         TsarXg9MqOXdn73FtdP9PW/eUnjIBHpOCfvbrClKK0m1+qyhKOTgIbu/+crk3W9M6s
         YF5QClKVoOX8HB5h3m+t1nPVpSmY7I+4LH87e0mY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210322005020epcas2p2184e952c241f3a3f2691f9d3f3609c7f~ug8oZh-bR0196001960epcas2p2L;
        Mon, 22 Mar 2021 00:50:20 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4F3bWZ63Bpz4x9QX; Mon, 22 Mar
        2021 00:50:18 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-47-6057e9c87c1d
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.B6.10621.8C9E7506; Mon, 22 Mar 2021 09:50:16 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v29 4/4] scsi: ufs: Add HPB 2.0 support
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
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575DEC175CD1D3895F1AF2BFC669@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210322005016epcms2p189894f11a157ed783e086d4523b85016@epcms2p1>
Date:   Mon, 22 Mar 2021 09:50:16 +0900
X-CMS-MailID: 20210322005016epcms2p189894f11a157ed783e086d4523b85016
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmhe6Jl+EJBrc3mlo8mLeNzWJv2wl2
        i5c/r7JZHL79jt1i2oefzBaf1i9jtXh5SNNi1YNwi+bF69ks5pxtYLLo7d/KZvH4zmd2i0U3
        tjFZ9P9rZ7G4vGsOm0X39R1sFsuP/2OyuL2Fy2Lp1puMFp3T17A4iHhcvuLtcbmvl8lj56y7
        7B4TFh1g9Ng/dw27R8vJ/SweH5/eYvHo27KK0ePzJjmP9gPdTAFcUTk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjJ+nW5nKbgkXHHi8mSW
        BsY3PF2MnBwSAiYSjS8esnYxcnEICexglGi7uJWti5GDg1dAUOLvDmGQGmEBe4mVTRtYQWwh
        ASWJ9RdnsUPE9SRuPVzDCGKzCehITD9xnx1kjojAb2aJi2+ngQ1lFvjNJLH45H82iG28EjPa
        n7JA2NIS25dvBevmFIiVaD07CapGQ+LHsl5mCFtU4ubqt+ww9vtj8xkhbBGJ1ntnoWoEJR78
        3A0Vl5Q4tvsDE4RdL7H1zi9GkCMkBHoYJQ7vvMUKkdCXuNaxEewIXgFficUvl4MtZhFQlXj1
        eQvUcS4ST6/vBIszC8hLbH87hxkUKswCmhLrd+mDmBICyhJHbrHAvNWw8Tc7OptZgE+i4/Bf
        uPiOeU+gTlOTWPdzPdMERuVZiKCehWTXLIRdCxiZVzGKpRYU56anFhsVGCLH7iZGcErXct3B
        OPntB71DjEwcjIcYJTiYlUR4TySHJAjxpiRWVqUW5ccXleakFh9iNAX6ciKzlGhyPjCr5JXE
        G5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C6WPi4JRqYJpxYOnno/EiZiZ/D+/X
        KPM9vKz8EG8qa52xSeu0zTfMeWxZs662Z39ffELtGUuy34+IooPPVkR88+766SfZd98w5Wai
        3BeGtKsnvtU5BK/ncNc2z1v8X+Sn0bzYuBMihpKbpl8JNjc6HMD7Omnm2mX8OR+7z4Uf/3az
        gb9e+ppVEwPbs7aUc2ks+5PeHo6Jjv3WpBmSvYbp++QXbnUhDtXGUwXae9+fvcHcO/301dMK
        f9ubuRa2OzWp2rxu/q7Knc4gE/Nce/3Th61W+d3zZ369I+P2K+JL1+HMdKMFMUETvPw3vvdd
        evnCNCPPt3zRlTsdJKaIf9+3NSd9ZjhPr/XrfBsGARnGtv/Pg1g3KbEUZyQaajEXFScCAC2B
        ZtRyBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210315012850epcms2p361447b689e925561c48aa9ca54434eb5
References: <DM6PR04MB6575DEC175CD1D3895F1AF2BFC669@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
        <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
        <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

>> +static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
>> +                                  struct ufshpb_req *umap_req,
>> +                                  struct ufshpb_region *rgn)
>> +{
>> +       struct request *req;
>> +       struct scsi_request *rq;
>> +
>> +       req = umap_req->req;
>> +       req->timeout = 0;
>> +       req->end_io_data = (void *)umap_req;
>> +       rq = scsi_req(req);
>> +       ufshpb_set_unmap_cmd(rq->cmd, rgn);
>> +       rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
>> +
>> +       blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
>Typo? Forgot the struct request_queue *q?

The argument of q is removed after this patch.

https://lore.kernel.org/linux-scsi/1611550198-17142-1-git-send-email-guoqing.jiang@cloud.ionos.com/#r

Thanks,
Daejun

>> +
>> +       return 0;
>> +}
>> +
>>  static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
>>                                   struct ufshpb_req *map_req, bool last)
>>  {
>> @@ -533,12 +878,12 @@ static int ufshpb_execute_map_req(struct ufshpb_lu
>> *hpb,
>> 
>>         q = hpb->sdev_ufs_lu->request_queue;
>>         for (i = 0; i < hpb->pages_per_srgn; i++) {
>> -               ret = bio_add_pc_page(q, map_req->bio, map_req->mctx->m_page[i],
>> +               ret = bio_add_pc_page(q, map_req->bio, map_req->rb.mctx-
>> >m_page[i],
>>                                       PAGE_SIZE, 0);
>>                 if (ret != PAGE_SIZE) {
>>                         dev_err(&hpb->sdev_ufs_lu->sdev_dev,
>>                                    "bio_add_pc_page fail %d - %d\n",
>> -                                  map_req->rgn_idx, map_req->srgn_idx);
>> +                                  map_req->rb.rgn_idx, map_req->rb.srgn_idx);
>>                         return ret;
>>                 }
>>         }
>> @@ -554,8 +899,8 @@ static int ufshpb_execute_map_req(struct ufshpb_lu
>> *hpb,
>>         if (unlikely(last))
>>                 mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
>> 
>> -       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
>> -                               map_req->srgn_idx, mem_size);
>> +       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rb.rgn_idx,
>> +                               map_req->rb.srgn_idx, mem_size);
>>         rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
>> 
>>         blk_execute_rq_nowait(NULL, req, 1, ufshpb_map_req_compl_fn);
>Ditto
> 
> 
>Thanks,
>Avri
> 
> 
>  
