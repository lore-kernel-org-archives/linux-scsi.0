Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60E7C4151A
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC2764E02
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443571AbhCCMrG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48437 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353167AbhCCE6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 23:58:50 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210303045807epoutp03b6c747141796f826b1dc326a9638f2f8~ovEja7dvN0433104331epoutp03m
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 04:58:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210303045807epoutp03b6c747141796f826b1dc326a9638f2f8~ovEja7dvN0433104331epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614747487;
        bh=Pc1wOYKNjTeOPqPY5AL7PRnrrPlngedIuzWw71SJAWo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=lf3o46zP/c2HYjBtT24AXUU1wteF2z1ghfpNb/Rjfk/v4IGChwAUHxZSQzvqB55bD
         r2gQUh/nBXFz4J1iIz68W2yg+j0+Eu/hmuQafXbe7fAt4QyyjSowjs6w3njO26zlVy
         LalwpUm3++zpgILmlFeyNYz3cdInnikp0ww4gUcs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210303045806epcas2p285a5e7778cce1eb26a1220dfbe046bd0~ovEifM6RX2200022000epcas2p2B;
        Wed,  3 Mar 2021 04:58:06 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Dr1wF2kXjz4x9QG; Wed,  3 Mar
        2021 04:58:05 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-27-603f175dd69f
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.77.52511.D571F306; Wed,  3 Mar 2021 13:58:05 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
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
        Javier Gonzalez <javier.gonz@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <967425555dc20554ce312c6929967d82@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210303045804epcms2p8ba1a2455e015c27354cda36091d3f790@epcms2p8>
Date:   Wed, 03 Mar 2021 13:58:04 +0900
X-CMS-MailID: 20210303045804epcms2p8ba1a2455e015c27354cda36091d3f790
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52Te0xTZxjG8/WUcwpJzaHcvuEc3UE3YaO0hZaPjVvchWPMEpyamamBrhyB
        DEpzTlHnzOjkOu6LC2hFYGVKBmxFBSwgk1CHOK3TISjgFCedqxHksrl1GzpKyzT7c/89+eV9
        3+d9vi+vABP1EoGCDI2OYTWqTAr34ndaQqLCdgTEp0jry73RRF0njnoLBwlkdwzjyDI+TaDq
        GQeG5kzHPJC9PwQ1T7yD8hpNOKq16nmovLIDR3duzBPIeL2ThyofFfHRUHctjkqvmXHUdO4R
        D423e6GjHaMAfVLTykfGz3v4CX700NUN9FBFOY/uMvxI0FXGPkCfOdJK0Pnnz/DpWdsYn65o
        bwb0/Inn6KK+Ul6S17t6EKNi1ekZuxgxo1Fnp2Zo0mKpLZvfDEOUOD2b08VS22RILpFFKySR
        0RJ51I5XZFKpXEGJNaosJpbaE+bupsSsWrtYrWM4HcuomUXEJnA6VRoj4VRZXI4mTaLOzqLE
        u1SZOYt9VHhcTDqjSmVYccokSG9rs+PaaXxP18eHcD2o9igBngJIRsK20ntECfASiEgzgH1N
        xaAECARC0hsumH2cNT5kPJy1VgKnFpEUNF0xEC4ugWO3W5c4Tr4MawZvLXFfcj387UCLh3Mm
        Rg7hcL9FD1xmQniwyMZ36ZXwVFPHEvck4+Bc2X7CxdfCP46VYy7tB0dbpohl/WCg3j3HFxbc
        tLprvOGEo8fNn4EDPTM8l86FHTf+BM4lIFkGoKVrzJ04HI4UH19aQki+Besu5+FOzSfXwHvW
        SQ9neEi+Dg83veTEGBkET03VYk6MkSHQ1B3uqgiGZ8f4y6n0x/8i/qsxcgUstiz8y811k+7N
        XoBfO0y8KhBsePLQhqe8DE+8GgDWDPwZLZeVxnBybeTT/3wCLJ1AKG0Gh6dmJP2AJwD9AAow
        ylcYYI9NEQlTVR/sZdjsZDYnk+H6wd7FkJ9igX7q7MUb0uiSZUqpXKmIiIyIUEQq/jdWyJVK
        abQCKZRyRAUIWelEsohMU+mY9xlGy7DL5jyBZ6Cet3s0MeiH84UVK+Kpo5n8ocKNbzeKNhp0
        +TXmpKC5+74NdwuuF9BlbdLQK5cGH9Q8/wsz8mF9uOLQyff87fYkTXepiagJOGJZt+riz7fD
        w/K/sQ6Axn3VF7QxdWLDyjtrggN9yAqT41JeLmcZMQh3+ouGrTO0cbjn8verN22vWmt5eGBK
        jX4vMQZPtyV+2fnFupaz7UkdB9db7m9no2LixLa740FbR4LnH2pXX6CunduQe1r2Ru9rtn3I
        qIzZvNXWKnqsMjS++mK/JFT9E1pV1szd/GyipDZRvluT+9HpcNN8gzzh1q/PJn3FzI7G2rb5
        zlx9vInZ+Z3lYrtj4du/t5y0oVqKz6WrZKEYy6n+Aaw5bUfQBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210226073233epcms2p80fca2dffabea03143a9414838f757633
References: <967425555dc20554ce312c6929967d82@codeaurora.org>
        <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
        <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
        <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +bool ufshpb_is_legacy(struct ufs_hba *hba)
> > +{
> > +        return hba->ufshpb_dev.is_legacy;
> > +}
> > +
> >  static struct ufshpb_lu *ufshpb_get_hpb_data(struct scsi_device *sdev)
> >  {
> >          return sdev->hostdata;
> > @@ -64,9 +69,19 @@ static bool ufshpb_is_write_or_discard_cmd(struct
> > scsi_cmnd *cmd)
> >                 op_is_discard(req_op(cmd->request));
> >  }
> > 
> > -static bool ufshpb_is_support_chunk(int transfer_len)
> > +static bool ufshpb_is_support_chunk(struct ufshpb_lu *hpb, int 
> > transfer_len)
> >  {
> > -        return transfer_len <= HPB_MULTI_CHUNK_HIGH;
> > +        return transfer_len <= hpb->pre_req_max_tr_len;
>  
> In the case of HPB1.0, this is wrong - you are allowing transfer_len > 1 
> for HPB1.0 devices.
>  
> Can Guo.

OK, I will check whether it is HPB 1.0 or not.

Thanks,
Daejun
