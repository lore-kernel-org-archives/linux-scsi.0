Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D889C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 01:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC4F62312F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 01:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbhAMBhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 20:37:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57219 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbhAMBhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 20:37:21 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210113013636epoutp01a97bb6ce3301e72eba7b98ca125001f1~ZptnxYRtt2847428474epoutp01l
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2021 01:36:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210113013636epoutp01a97bb6ce3301e72eba7b98ca125001f1~ZptnxYRtt2847428474epoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610501796;
        bh=i60jqufl/+QsJPjiXupuapwad2yXKwzNnWbdSGptqx4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=btpvWd5o9E3947LeWAp1ViiSlDKsjiYIRsO19iFa6cfPf95UXij9UYs0YiVD0wv4U
         A/QYUI/fCMRhDJacjSLc/lHmFHgrPmlr0cglSlhBzdnxQPQ3iKU3OIJqMsTKpSbHU9
         aQFgnpq/oibNQtwPavIYA5Es6EVPqguRJ03n/AKU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210113013635epcas2p2853a2c20874d171f695519df17640888~Zptm2FBWB0602406024epcas2p2m;
        Wed, 13 Jan 2021 01:36:35 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DFqmL44yrz4x9Pp; Wed, 13 Jan
        2021 01:36:34 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-e4-5ffe4ea147f9
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.B4.10621.1AE4EFF5; Wed, 13 Jan 2021 10:36:33 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v18 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e9b2479d0371e3cbe8aeb6c90ffb5d72@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210113013633epcms2p60b9dccaa405ff568a18d28b94089665b@epcms2p6>
Date:   Wed, 13 Jan 2021 10:36:33 +0900
X-CMS-MailID: 20210113013633epcms2p60b9dccaa405ff568a18d28b94089665b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLsWRmVeSWpSXmKPExsWy7bCmqe5Cv3/xBrt7VS023n3FavFg3jY2
        i71tJ9gtXv68ymZx+PY7dotpH34yW3xav4zV4uUhTYtVD8ItmhevZ7OYc7aByaK3fyubxaIb
        25gsLu+aw2bRfX0Hm8Xy4/+YLG5v4bJYuvUmo0Xn9DUsFosW7mZxEPG4fMXb43JfL5PHzll3
        2T0mLDrA6LF/7hp2j5aT+1k8Pj69xeLRt2UVo8fnTXIe7Qe6mQK4ohoYbRKLkjMyy1IVUvOS
        81My89JtlUJD3HQtlBQy8otLbJWiDS2M9AwtTfVMLPWMzGOtDA0MjEyVFPISc1NtlSp0obqV
        FIqSC4CqS1KLS4pSk1OBQkUOxSWJ6al6xYm5xaV56XrJ+blKCmWJOaVAfUr6djYZqYkpqUUK
        CU8YM3p2X2ArOMZa8f9/fAPjJpYuRk4OCQETiXtnLzF3MXJxCAnsYJS4sXI+excjBwevgKDE
        3x3CIKawQIjEzj2BIOVCAkoS6y/OYgexhQX0JG49XMMIYrMJ6EhMP3EfLC4i4CnxdfJqVpCR
        zAKL2SQm/DzIBrGLV2JG+1OovdIS25dvBWvmFLCT6Dv+mB0iriHxY1kvM4QtKnFz9Vt2GPv9
        sfmMELaIROu9s1A1ghIPfu6GiktKHNv9gQnCrpfYeucXI8gREgI9jBKHd95ihUjoS1zr2Ah2
        BK+Ar8TWDT1gx7EIqErs6VsMdZyLxJZ5E8DqmQXkJba/ncMMCghmAU2J9bv0QUwJAWWJI7dY
        YN5q2PibHZ3NLMAn0XH4L1x8x7wnUKepSaz7uZ5pAqPyLERAz0KyaxbCrgWMzKsYxVILinPT
        U4uNCgyRo3kTIzjxa7nuYJz89oPeIUYmDsZDjBIczEoivEXdf+OFeFMSK6tSi/Lji0pzUosP
        MVYBfTmRWUo0OR+Ye/JK4g3NDIzMTI1NjI1NTUzJFjY1MjMzsDS1MDUzslAS5y02eBAvJJCe
        WJKanZpakFoEs5yJg1OqgSnWJtVBcI9VSByD1NuXv2TifLRZz2bMujfp5fUVxsIZx6X8jDib
        cviE7SrS62JbBSX3Tgu/EvSy9K9zTFnsvZ5LWY7bLwTbe//oaLf5JPb114+N7JNrfEKuv+Rv
        D3zPUMY2VfTEwpyo3jSTFEOvI5s/baqJKokwvRe6d+qSXEaezPv2zNknpnZHVyXP/VUn+v2+
        04RltsJ3H0h/Px838aoyz+Lri5UUDxWvWmbrr35MJljEeHMQX1tqHPfkJ6anFi2/w6l9yu9w
        IdvX24UM1/Q/Z2isOPSpvPRV0YLva1MFL4jfnGZZ5Hf8123hFPu1rLfF3zMu3escOln0xQ2W
        WHuuTxMOrunZmWJ+ZlP/TiWW4oxEQy3mouJEAOs62rDKBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222015704epcms2p643f0c5011064a7ce56b08331811a8509
References: <e9b2479d0371e3cbe8aeb6c90ffb5d72@codeaurora.org>
        <20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
        <20201222015854epcms2p1bdc30b8fab8ef01502451b75e7fbaf49@epcms2p1>
        <CGME20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,

> > +static void
> > +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb 
> > *lrbp,
> > +				  u32 lpn, u64 ppn,  unsigned int transfer_len)
> > +{
> > +	unsigned char *cdb = lrbp->ucd_req_ptr->sc.cdb;
> > +
> > +	cdb[0] = UFSHPB_READ;
> 
> You are only replacing opcode in cdb[0], but ufshcd_add_command_trace() 
> is
> counting on lrbp->cmd->cmnd. This will lead to wrong opcode recorded by 
> UFS ftrace.
> 
You're comment is good point for improving this patch. But there is no "case" for HPB read (0xF8) in ufshcd_add_command_trace().
So I will add codes to support tracing HPB read command in ufshcd_add_command_trace() on next patch.

Thanks,
Daejun
