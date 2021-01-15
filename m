Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67322C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 08:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CEF4208BA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 08:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbhAOIAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 03:00:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29911 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732129AbhAOIAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 03:00:36 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210115075952epoutp0499ab3a4c556357760b8c4298834b13cb~aWO0_1onl1172411724epoutp04R
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2021 07:59:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210115075952epoutp0499ab3a4c556357760b8c4298834b13cb~aWO0_1onl1172411724epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610697592;
        bh=HzW5oVWVK5z4kC0Iznp8lV7xOqPzoYkWXP5R8aanphA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=hpGF9PY9ogthIpxdkzuUuxF4y4ccykYaiYocdzRpHgmmgA3ShTvESyHkr9ZhDVUHD
         BvSWZDzbG3WYWWbpUQEL10sciLphmj5kLHtLF6fu4YmYhEjxjB/EIrfRtxzsBJ7495
         fLc+yoQOHreTVce/5unAgdH1cPH7PIn4V4EwZB94=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210115075940epcas2p21d59f7d6dffb0b4ad0233b5f5c5938e9~aWOpksumn1145611456epcas2p2u;
        Fri, 15 Jan 2021 07:59:40 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DHD9R1HPVz4x9QB; Fri, 15 Jan
        2021 07:59:39 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-2c-60014b6b87df
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.15.10621.B6B41006; Fri, 15 Jan 2021 16:59:39 +0900 (KST)
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
In-Reply-To: <c6a4e4abd856aa03b6b91b619cddbeb7@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210115075935epcms2p6e7fb72edab9f5f1390164b3c66c016d5@epcms2p6>
Date:   Fri, 15 Jan 2021 16:59:35 +0900
X-CMS-MailID: 20210115075935epcms2p6e7fb72edab9f5f1390164b3c66c016d5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmqW62N2OCwZ8ZLBYb775itXgwbxub
        xd62E+wWL39eZbM4fPsdu8W0Dz+ZLT6tX8Zq8fKQpsWqB+EWzYvXs1nMOdvAZNHbv5XNYtGN
        bUwWl3fNYbPovr6DzWL58X9MFre3cFks3XqT0aJz+hoWi0ULd7M4iHhcvuLtcbmvl8lj56y7
        7B4TFh1g9Ng/dw27R8vJ/SweH5/eYvHo27KK0ePzJjmP9gPdTAFcUTk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjLe/VzGUrCTo+LArQ1M
        DYw72LoYOTkkBEwk1ja1A9lcHEICOxglDt/sY+li5ODgFRCU+LtDGMQUFgiR2LknEKRcSEBJ
        Yv3FWewgtrCAnsSth2sYQWw2AR2J6Sfug8VFBDwlvk5ezQoykllgMZvEhJ8HoXbxSsxof8oC
        YUtLbF++FayZU8BOYu3Ee1A1GhI/lvUyQ9iiEjdXv2WHsd8fm88IYYtItN47C1UjKPHg526o
        uKTEsd0fmCDseomtd34xghwhIdAD9NfOW6wQCX2Jax0bwY7gFfCV6F+6CWwQi4CqxJ3b26GO
        c5E4d3cb2CBmAXmJ7W/nMIMCgllAU2L9Ln0QU0JAWeLILRaYtxo2/mZHZzML8El0HP4LF98x
        7wnUaWoS636uZ5rAqDwLEdCzkOyahbBrASPzKkax1ILi3PTUYqMCQ+S43cQITudarjsYJ7/9
        oHeIkYmD8RCjBAezkghvvjJDghBvSmJlVWpRfnxRaU5q8SFGU6AvJzJLiSbnAzNKXkm8oamR
        mZmBpamFqZmRhZI4b7HBg3ghgfTEktTs1NSC1CKYPiYOTqkGpgWPc8+sDvmyvFT1SeGhvUuO
        umw2Waayrs7RYePrRVXyjRsNWd4ebvK5Ino0PDzY+VAfx1WDs5cF1mQtnrfznv2V9Hxja7mS
        j6erk5PeLC83LfPfX19342XG1aMJ7cUBUQIai9yP8HLJx7f3H4kJ2rdOxdtJp/9UvujJlFOl
        Z04//JMkP7H740t/1d07XWVSV2/Lm7p56bl0Id3cDOfpFxtumLG7pSQcO6B7hPkz97dVc7I/
        CB3dwMfksH/WzbJXlqt6Pj3VmGW1y/kjyxMfp311nAWiQuI7EtK+s8cq9evb6R4tuz8tzsWZ
        6fR9M4ewGZb3Xkk4dn1zmtuvPyVqztGmFO7QFXue6S2XkheboMRSnJFoqMVcVJwIAEJegDZw
        BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222015704epcms2p643f0c5011064a7ce56b08331811a8509
References: <c6a4e4abd856aa03b6b91b619cddbeb7@codeaurora.org>
        <e9b2479d0371e3cbe8aeb6c90ffb5d72@codeaurora.org>
        <20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
        <20201222015854epcms2p1bdc30b8fab8ef01502451b75e7fbaf49@epcms2p1>
        <20210113013633epcms2p60b9dccaa405ff568a18d28b94089665b@epcms2p6>
        <CGME20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,

> 
> On 2021-01-13 09:36, Daejun Park wrote:
> > Hi Can Guo,
> > 
> >> > +static void
> >> > +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb
> >> > *lrbp,
> >> > +				  u32 lpn, u64 ppn,  unsigned int transfer_len)
> >> > +{
> >> > +	unsigned char *cdb = lrbp->ucd_req_ptr->sc.cdb;
> >> > +
> >> > +	cdb[0] = UFSHPB_READ;
> >> 
> >> You are only replacing opcode in cdb[0], but 
> >> ufshcd_add_command_trace()
> >> is
> >> counting on lrbp->cmd->cmnd. This will lead to wrong opcode recorded 
> >> by
> >> UFS ftrace.
> >> 
> > You're comment is good point for improving this patch. But there is no
> > "case" for HPB read (0xF8) in ufshcd_add_command_trace().
> > So I will add codes to support tracing HPB read command in
> > ufshcd_add_command_trace() on next patch.
> > 
> 
> It is not just about ftrace. If HPB READ cmd fails with sense key infos.
> When SCSI layer prints the cmd, it still prints the READ(10) CDB, which 
> is
> misleading.

Oh, thanks. I will fix this problem on next patch.


Daejun
