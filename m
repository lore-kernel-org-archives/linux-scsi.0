Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB777C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB7A5206D7
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="bT28odVq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgHCFOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 01:14:07 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20383 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgHCFOG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Aug 2020 01:14:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596431646; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=2SttEpjWkPUzgGIFPGBOgS8vyJzXv+pt+lN3X+pHN84=;
 b=bT28odVq5FY/sbyWe3cRnftgmqJtFmBCH4dny+g9beLuJfYaAQU7kBElQVNjh1AHoTos65DL
 jL07jommm12iN87nReGplBrzcBHMnD4vpqMJvdSG1+H1SJERwczpPCCSnpq8UNkrDWW1rMNc
 tEP4lBhpL87Fq99vUeaZjAQB8GM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-east-1.postgun.com with SMTP id
 5f279d1e798b102968ef1b25 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 03 Aug 2020 05:14:06
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2C3B9C433A0; Mon,  3 Aug 2020 05:14:04 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 01717C433C9;
        Mon,  3 Aug 2020 05:14:02 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 03 Aug 2020 13:14:02 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
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
In-Reply-To: <1596423655.32283.7.camel@mtkswgap22>
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
 <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1596159018.17247.53.camel@mtkswgap22>
 <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
 <8b0a158a7c3ee2165e09290996521ffc@codeaurora.org>
 <f45c6c47-ffc5-3f8e-3234-9e5989dbf996@acm.org>
 <548b602daa1e15415625cb8d1f81a208@codeaurora.org>
 <1596423655.32283.7.camel@mtkswgap22>
Message-ID: <3b144ed6897483d1ae3ced6de2dfc64c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-08-03 11:00, Stanley Chu wrote:
> Hi Can,
> 
> On Sat, 2020-08-01 at 07:17 +0800, Can Guo wrote:
>> Hi Bart,
>> 
>> On 2020-08-01 00:51, Bart Van Assche wrote:
>> > On 2020-07-31 01:00, Can Guo wrote:
>> >> AFAIK, sychronization of scsi_done is not a problem here, because scsi
>> >> layer
>> >> use the atomic state, namely SCMD_STATE_COMPLETE, of a scsi cmd to
>> >> prevent
>> >> the concurrency of abort and real completion of it.
>> >>
>> >> Check func scsi_times_out(), hope it helps.
>> >>
>> >> enum blk_eh_timer_return scsi_times_out(struct request *req)
>> >> {
>> >> ...
>> >>         if (rtn == BLK_EH_DONE) {
>> >>                 /*
>> >>                  * Set the command to complete first in order to
>> >> prevent
>> >> a real
>> >>                  * completion from releasing the command while error
>> >> handling
>> >>                  * is using it. If the command was already completed,
>> >> then the
>> >>                  * lower level driver beat the timeout handler, and it
>> >> is safe
>> >>                  * to return without escalating error recovery.
>> >>                  *
>> >>                  * If timeout handling lost the race to a real
>> >> completion, the
>> >>                  * block layer may ignore that due to a fake timeout
>> >> injection,
>> >>                  * so return RESET_TIMER to allow error handling
>> >> another
>> >> shot
>> >>                  * at this command.
>> >>                  */
>> >>                 if (test_and_set_bit(SCMD_STATE_COMPLETE,
>> >> &scmd->state))
>> >>                         return BLK_EH_RESET_TIMER;
>> >>                 if (scsi_abort_command(scmd) != SUCCESS) {
>> >>                         set_host_byte(scmd, DID_TIME_OUT);
>> >>                         scsi_eh_scmd_add(scmd);
>> >>                 }
>> >>         }
>> >> }
>> >
>> > I am familiar with this mechanism. My concern is that both the regular
>> > completion path and the abort handler must call scsi_dma_unmap() before
>> > calling cmd->scsi_done(cmd). I don't see how
>> > test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state) could prevent that
>> > the regular completion path and the abort handler call scsi_dma_unmap()
>> > concurrently since both calls happen before the SCMD_STATE_COMPLETE bit
>> > is set?
>> >
>> > Thanks,
>> >
>> > Bart.
>> 
>> For scsi_dma_unmap() part, that is true - we should make it serialized
>> with
>> any other completion paths. I've found it during my fault injection
>> test, so
>> I've made a patch to fix it, but it only comes in my next error 
>> recovery
>> enhancement patch series. Please check the attachment.
>> 
> 
> Your patch looks good to me.
> 
> I have the same idea before but I found that calling scsi_done() (by
> __ufshcd_transfer_req_compl()) in ufshcd_abort() in old kernel (e.g.,
> 4.14) will cause issues but it has been resolved by introduced
> SCMD_STATE_COMPLETE flag in newer kernel. So your patch makes sense.
> 
> Would you mind sending out this draft patch as a formal patch together
> with my patch to fix issues in ufshcd_abort()? Our patches are aimed to
> fix cases that host/device reset eventually not being triggered by the
> result of ufshcd_abort(), for example, command is aborted successfully
> or command is not pending in device with its doorbell also cleared.
> 
> Thanks,
> Stanley Chu
> 

I don't quite actually follow your fix here and I didn't test the 
similar
fault injection scenario like you do here, so I am not sure if I should
just absorb your fix into mine. How about I put my fix in my current 
error
recovery patch series (maybe in next version of it) and you can give 
your
review. So you can still go with your fix as it is. Mine will be picked 
up
later by Martin. What do you think?

Thanks,

Can Guo.

>> Thanks,
>> 
>> Can Guo.
>> 
