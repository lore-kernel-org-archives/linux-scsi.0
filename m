Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C020FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 04:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 786D8238E2
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 04:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbhANEKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 23:10:09 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:54433 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbhANEKJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 23:10:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610597389; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=KEhEnxDdZvkvCPxXrDuP2+CvAQyFcZ9lrV7IBZA6ja4=;
 b=UIyOQk4WziOlVV7U118jrXusSPzrgVPF0uxWgdF66Xe3QMunbznIxSRImPha0kDGyiRhUTkC
 VwyGZ9QjueY0et8Y/v7LwFchZDNSiSBaOylbd01vlWDMTwXt7+vDDgyCQzunzvJh3e+iVyj/
 jjJYudZQyxyIFZU/Ve128tlmoTE=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fffc3e5c88af06107e11724 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 04:09:09
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DEC3CC43464; Thu, 14 Jan 2021 04:09:08 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 222F1C433CA;
        Thu, 14 Jan 2021 04:09:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Jan 2021 12:09:08 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, huobean@gmail.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v18 3/3] scsi: ufs: Prepare HPB read for cached sub-region
In-Reply-To: <20210113013633epcms2p60b9dccaa405ff568a18d28b94089665b@epcms2p6>
References: <e9b2479d0371e3cbe8aeb6c90ffb5d72@codeaurora.org>
 <20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
 <20201222015854epcms2p1bdc30b8fab8ef01502451b75e7fbaf49@epcms2p1>
 <CGME20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
 <20210113013633epcms2p60b9dccaa405ff568a18d28b94089665b@epcms2p6>
Message-ID: <c6a4e4abd856aa03b6b91b619cddbeb7@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun,

On 2021-01-13 09:36, Daejun Park wrote:
> Hi Can Guo,
> 
>> > +static void
>> > +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb
>> > *lrbp,
>> > +				  u32 lpn, u64 ppn,  unsigned int transfer_len)
>> > +{
>> > +	unsigned char *cdb = lrbp->ucd_req_ptr->sc.cdb;
>> > +
>> > +	cdb[0] = UFSHPB_READ;
>> 
>> You are only replacing opcode in cdb[0], but 
>> ufshcd_add_command_trace()
>> is
>> counting on lrbp->cmd->cmnd. This will lead to wrong opcode recorded 
>> by
>> UFS ftrace.
>> 
> You're comment is good point for improving this patch. But there is no
> "case" for HPB read (0xF8) in ufshcd_add_command_trace().
> So I will add codes to support tracing HPB read command in
> ufshcd_add_command_trace() on next patch.
> 

It is not just about ftrace. If HPB READ cmd fails with sense key infos.
When SCSI layer prints the cmd, it still prints the READ(10) CDB, which 
is
misleading.

Thanks,
Can Guo.

> Thanks,
> Daejun
