Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D31C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7C064E02
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhBWJwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 04:52:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27720 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhBWJub (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 04:50:31 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210223094943epoutp044595fe0e5ce03f799ee218bc19fe1b73~mV431e7US1025010250epoutp04Z
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 09:49:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210223094943epoutp044595fe0e5ce03f799ee218bc19fe1b73~mV431e7US1025010250epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614073783;
        bh=Ubs1kZZFPa5xRlLuSmHTmEfG00R7cgtV0QxxSb4lGmM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=rSFF91WTpPISwajyYYdiCt3dDSnKZrXiUdWHQcGVdplA1MtT6QoTpNzz+jIN+5vp6
         aGEhjAyYVu3x2kHMn+WfqzPwan/UFFq3MUU0Ocdo693hg/gd7EtCm/2szTXJ0HxpLZ
         pcKPQFFRaLAJB4/H3FOGWEkErqkoOJYYlB0K36f8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210223094942epcas2p15a36958919c80a66aabfc9cf48e2f6c9~mV43C6Q9h1111811118epcas2p1Z;
        Tue, 23 Feb 2021 09:49:42 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DlDmP5B8bz4x9Px; Tue, 23 Feb
        2021 09:49:41 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-f3-6034cfb5fff0
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.78.05262.5BFC4306; Tue, 23 Feb 2021 18:49:41 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
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
In-Reply-To: <d5393d50a2d7c4752828a5707a6225ff6ca62f68.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223094940epcms2p5e22d3981a396fbe4e2421f427019389b@epcms2p5>
Date:   Tue, 23 Feb 2021 18:49:40 +0900
X-CMS-MailID: 20210223094940epcms2p5e22d3981a396fbe4e2421f427019389b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52Tf1CTdRzH79nzsOeBoB4GxFe6aj0cICPGNtj8kg44NZ3HhdLJcWYKa3tu
        W8C2e55hxD8NCKb81BOFYIHgCScSS3QwpIQD40cdlYeJgBaeWKHOSKoLPbg2NtLrz/57f1+f
        35/vfQiUdxkPI3R6E83olbkU1w/rGY6Wxtq/S8gWtRdFwLmmHi78smwMhwvLP3Dh8OxDHJ5c
        XEbhI1ubD1wYioYdc5mw5LSNC60TZg6sqrFz4Z2bSzhsvdHDgTWrFgxOXrJyYcWUgwvbR1c5
        cPaiHzxjn0bgkbpODLa29GMpIYrJa6mKyeoqjqKv4RauONo6iCgGPu3EFR+PD2CK3+/OYIrq
        ix2IYqn7FYVlsIKzx+8dM7JFyai0ukM0n9arDGqdXiOnMvbuiIUUX2tgTXJqvxhKhOJEqTAh
        USjZdOANsUgkkVJ8vTKPllMFsd5ois+ojC5vE82aGFpFuxCTwpqUGlrIKvPYfL1GqDLkUfxD
        ytx8VxwVl7RFSyvVNMPPnke0DyuWcOOgT0HLzwuIGRlByxFfApAJYNF5lluO+BE80oGAym6r
        y0AQAWQgWHEEuX2CyGTw69h13K15JAVsVxtwDxeCmdudiFtzyddB3dhPuDtPMHkGA7Wjbaj7
        gZKPOWDsziLiqRYA6i13MY9+CfS229e4L7kTrDjPcT18I/i7rcrbXQiYPufE1/VvI83ePMGg
        9McJr08gmFvu9/INYKR/kePRHwH7zceIuwlAViJguG/Gx2OIA9cPn8c8U74FfmnjuTFGRoDi
        46e9sdtBmd251g9Kvgp6nZ6loGQ0sF2Kc0tAhoMrM9j6VObzT/D/apR8HhweXvmXO5rmvdkj
        QdeyjXMUCW94uumGZ2o1PK11CkE7kBdpI5unoVmJMf7Zj+5G1m5AsNOB1DsXhUMIh0CGEECg
        VHAA95YkmxegVn5YSDOGLCY/l2aHkELXlMfQsBCVwXVEelOWWCaSyKTxCfHx0gTp/8ZSiUwm
        SpRCqUwCqdAAVjSXxSM1ShOdQ9NGmlkvziF8w8ycKNZm0DoE75ZONBGNMrWlUleo+1p3ojc2
        dXcaL+Y5n03J+dFPjHIqPaN4sKjp87IQeRDRklKi1tzfVuBoLohJMYdLzI/oUMcUIvHfmt7V
        NDbaeDy1ffP3cv6+F/yPgcAr1qh5i2mXGNMXxOXUTBOvVRanF574YuPJ+gv++SWRMQNvhwpW
        D/AK9dJZgXHrJ/G1mQ+6bls2b4hKSuu4fPbeA+uFP8zitG8i9yZp0TetByVXp8wf3Hs/p/69
        8jpzdsyIXBA9vv8z4qs9+7bHqTnjf96vFhftuOHQMruZGUfzkH9mhLmvo/3b8mun1MnDAz0Z
        L//VyNs1XptZOnkwJoMKOkJhrFYpFqAMq/wH4GVHddEEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <d5393d50a2d7c4752828a5707a6225ff6ca62f68.camel@gmail.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >                 }
> >         }
> > @@ -532,8 +870,8 @@ static int ufshpb_execute_map_req(struct
> > ufshpb_lu *hpb,
> >         if (unlikely(last))
> >                 mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
> >  
> > -       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
> > -                               map_req->srgn_idx, mem_size);
> > +       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rb.rgn_idx,
> > +                               map_req->rb.srgn_idx, hpb-
> > >srgn_mem_size);
>  
> Are you sure here it is hpb->srgn_mem_size, not mem_size???
> if not mem_size, why you kept mem_size??

I will fix it.

Thanks,
Daejun
  
> Bean
>  
>  
>  
>   
