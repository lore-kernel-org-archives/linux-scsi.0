Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E054C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 08:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D79736135C
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 08:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhEUIOd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 04:14:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14802 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhEUIOc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 04:14:32 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210521081307epoutp0140040ff806e19d6b85c6e7e12cd318d6~BBsXEyIM21059610596epoutp01p
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 08:13:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210521081307epoutp0140040ff806e19d6b85c6e7e12cd318d6~BBsXEyIM21059610596epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621584787;
        bh=oLATn9iM4wIMKYl3x4+8ERAYHMUVpCqKFCJByrenAcY=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=oD2WlRN5mz4Xdi8pdGNM6N1ye723kF+j+TZR+ep99FyyPpoFmFlYKbagjEme9YUdL
         ljAQ1mYVlJ90fOu53OhTVO4dhKoJvKvZm37p+2JCh4TMX2dd+a01HiHaypz2+eFsAX
         NtYP0tqqLEZuxxin4vWMkhfrz5IEeBWZ1jL22PHs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210521081306epcas2p180a06718eec1fe8610b2245c3798f0d9~BBsWBx2DN0947909479epcas2p1D;
        Fri, 21 May 2021 08:13:06 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FmfVm6lWRz4x9Q6; Fri, 21 May
        2021 08:13:04 +0000 (GMT)
X-AuditID: b6c32a47-f4bff700000024d9-bc-60a76b8f716a
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.9F.09433.F8B67A06; Fri, 21 May 2021 17:13:03 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v34 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB65755AE3D9217FA3C0C3455AFC2A9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210521081302epcms2p45e2a734f7f14046d6caab2ab16a2d94c@epcms2p4>
Date:   Fri, 21 May 2021 17:13:02 +0900
X-CMS-MailID: 20210521081302epcms2p45e2a734f7f14046d6caab2ab16a2d94c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJsWRmVeSWpSXmKPExsWy7bCmuW5/9vIEgy/LlSwezNvGZrG37QS7
        xcufV9kspn34yWzxaf0yVouXhzQtdh08yGax6kG4RfPi9WwWc842MFn09m9ls9h8cAOzxeM7
        n9ktFt3YxmTR/6+dxWLbZ0GL4yffMVpc3jWHzaL7+g42i+XH/zFZLN16k9Gic/oaFgcxj8tX
        vD0u9/UyeeycdZfdY8KiA4we++euYfdoObmfxePj01ssHn1bVjF6fN4k59F+oJspgCsqxyYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6E0lhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxox9
        LxkLvrNWnOufxNjAOIGli5GTQ0LARGLa1qNsILaQwA5Gic2HA7oYOTh4BQQl/u4QBgkLC9hL
        7O0/yAxRoiSx/uIsdoi4nsSth2sYQWw2AR2J6SfuA8W5OEQEHrJL9M9uYYOYzysxo/0p1C5p
        ie3Lt4I1cArESsx5vAIqriHxY1kvM4QtKnFz9Vt2GPv9sfmMELaIROu9s1A1ghIPfu6GiktK
        HNv9gQnCrpfYeucXI8gREgI9jBKHd95ihUjoS1zr2Ai2jFfAV2L+m3Vgx7EIqEpsP/8M6ggX
        iRdfPoINZRaQl9j+dg4zKCCYBTQl1u/SBzElBJQljtxigXmrYeNvdnQ2swCfRMfhv3DxHfOe
        QJ2mJrHu53omiDEyErfmMU5gVJqFCOhZSNbOQli7gJF5FaNYakFxbnpqsVGBMXLUbmIEJ3gt
        9x2MM95+0DvEyMTBeIhRgoNZSYSX23F5ghBvSmJlVWpRfnxRaU5q8SFGU6CHJzJLiSbnA3NM
        Xkm8oamRmZmBpamFqZmRhZI478/UugQhgfTEktTs1NSC1CKYPiYOTqkGpr2WKpvc1naY79nl
        w/+w8MBVJjuHiyYvzz+d4jVry/+2qrn2d9ZVMfgFnv98TUTA6cLTz0bdTJpb6pXK1n0JLf+g
        93D3ZuU7oiriU7UqHq0JCJ3EY5h2ZK3J0TP/uw9uEg975rW16/+rKRELtW4rfJFVrOtcLO/1
        xWaJ576DubO/hl90W/VoEucKufTniXd9zzoGTF7R9e70v/WZUp2Rh/79qlS3v75zeXL9pR0H
        GnboNTczcqwVZ/n0Yu4X88UZBcvDX7benHRUJGrvvJunJMqmz5a1Nj5aU/TfhWOeD0cUd62g
        oEZk6HOzxYITd1hKzT3Z2+Skmrcy1LlLP/KxylSp/blXOI3ee7K37N3R9EOJpTgj0VCLuag4
        EQAkHyjNeQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb
References: <DM6PR04MB65755AE3D9217FA3C0C3455AFC2A9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
        <20210428232534epcms2p4830e22a86cc78c3319075059fa223540@epcms2p4>
        <CGME20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

>> +       /* for pre_req */
>> +       hpb->pre_req_min_tr_len = hpb_dev_info->max_hpb_single_cmd + 1;
>> +
>> +       if (ufshpb_is_legacy(hba))
>> +               hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
>> +       else
>> +               hpb->pre_req_max_tr_len = max(HPB_MULTI_CHUNK_HIGH,
>> +                                             hpb->pre_req_min_tr_len);
>I think this should only be
>else
>        hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
> 
>where HPB_MULTI_CHUNK_HIGH should fit into a single byte,
>regardless of bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD,
>which being an attribute (u32) can be significantly larger.

I will fix it as suggested.

Thank you.

> 
>Thanks,
>Avri
> 
> 
> 
> 
>  
