Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0B7C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F7D206D4
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lwzvhZsO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgHCFKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 01:10:20 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20134 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbgHCFKU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Aug 2020 01:10:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596431419; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=xH2GNNEeKA5M2HSxLn3DvMsbHNeHZZGIVLaa9prWnN0=;
 b=lwzvhZsOB/tv+pnlpPaZt7PR3bQTpKQyQ6nYf3IF3quDAh5XsnEkaFI11PqxIe4UJ3aGAlw+
 E6gGgCCqZFcCpP635YBhE/FfpqJ4XyMXwcMf/5Y8ejtl1QP7IsxHAZXtwpo90r7pbe2h6ecY
 gTvs+AFiCzN0q/FfYA2kWoopFF8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5f279b9c2dfc1b5cc2467d2f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 03 Aug 2020 05:07:40
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 25F26C4339C; Mon,  3 Aug 2020 05:07:40 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 77B7BC433C6;
        Mon,  3 Aug 2020 05:07:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 03 Aug 2020 13:07:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <Avri.Altman@wdc.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
Subject: Re: [PATCH v4] scsi: ufs: Cleanup completed request without interrupt
 notification
In-Reply-To: <80f5e213-502b-3532-e782-6f26a778274e@acm.org>
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
 <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1596159018.17247.53.camel@mtkswgap22>
 <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
 <8b0a158a7c3ee2165e09290996521ffc@codeaurora.org>
 <f45c6c47-ffc5-3f8e-3234-9e5989dbf996@acm.org>
 <548b602daa1e15415625cb8d1f81a208@codeaurora.org>
 <80f5e213-502b-3532-e782-6f26a778274e@acm.org>
Message-ID: <7002ce0c5c84409cae6910675f7fe4c0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-08-03 11:12, Bart Van Assche wrote:
> On 2020-07-31 16:17, Can Guo wrote:
>> For scsi_dma_unmap() part, that is true - we should make it serialized 
>> with
>> any other completion paths. I've found it during my fault injection 
>> test, so
>> I've made a patch to fix it, but it only comes in my next error 
>> recovery
>> enhancement patch series. Please check the attachment.
> 
> Hi Can,
> 
> It is not clear to me how that patch serializes scsi_dma_unmap() 
> against
> other completion paths? Doesn't the regular completion path call
> __ufshcd_transfer_req_compl() without holding the host lock?
> 
> Thanks,
> 
> Bart.

FYI, ufshcd_intr() holds the host spin lock the whole time. So, to your
question, the regular completion path from IRQ handler has the host lock 
held.

Thanks,

Can Guo.
