Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B881C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 01:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5431D20B80
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 01:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="gPYvvpsf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbgE2BjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 21:39:19 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64848 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390743AbgE2BjR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 21:39:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590716355; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Bi5hDeyIs8yacDRynmT+aDvq/Fjkhp6b6zMEzfAWReM=;
 b=gPYvvpsf3RzCUTyxPAqTZWiD32/0sg77CQBGUne+Lac01sw16wFaddUyXOUaScwv1qcH5UfK
 hfIyUoCt7GnZvd6Gku0znWFtqKxU53B/m6R5g0eam31PABa2FOOnUgnl00Oz0YKOCQbaMDL6
 Asw8laNQiYFfjbiJhBt4dkalgtU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5ed067c2ea0dfa490eeb610a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 01:39:14
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5CCCDC43395; Fri, 29 May 2020 01:39:13 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5FD69C433CA;
        Fri, 29 May 2020 01:39:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 May 2020 09:39:12 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 6/6] ufs: Remove the SCSI timeout handler
In-Reply-To: <1728e2d6-5b00-e71f-5476-b082f4201aa1@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-7-bvanassche@acm.org>
 <4fe9074323178a0b006f08402dd08b51@codeaurora.org>
 <1728e2d6-5b00-e71f-5476-b082f4201aa1@acm.org>
Message-ID: <8bd12e9fe32b0f996209ac2d4e8aa484@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-29 00:12, Bart Van Assche wrote:
> On 2020-05-28 02:47, Can Guo wrote:
>> Hi Bart,
>> 
>> On 2019-12-25 06:02, Bart Van Assche wrote:
>>> The UFS SCSI timeout handler was needed to compensate that
>>> ufshcd_queuecommand() could return SCSI_MLQUEUE_HOST_BUSY for a long
>>> time. Commit a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by 
>>> eliminating
>>> tag conflicts") fixed this so the timeout handler is no longer 
>>> necessary.
>>> 
>>> See also commit f550c65b543b ("scsi: ufs: implement scsi host timeout
>>> handler").
>>> 
>> 
>> Sorry for bugging you on this old change. I am afraid we may need to 
>> add
>> this timeout handler back. Because there is till chances that a 
>> request
>> gets stuck somewhere in ufshcd_queuecommand() path before
>> ufshcd_send_command() gets called. e.g.
>> 
>> ufshcd_queuecommand()
>> ->ufshcd_map_sg()
>> -->scsi_dma_map()
>> --->dma_map_sg()
>> ---->dev->ops->map_sg()
>> 
>> map_sg() ops may get stuck. map_sg() method can vary on different 
>> platforms
>> based on actual IOMMU engines. We cannot gaurantee map_sg() ops must 
>> return
>> immediately as we don't know what is actually inside map_sg() ops.
>> 
>> And if it gets stuck there for a long time till the request times out,
>> without
>> the UFS timeout handler, scsi layer will try to abort this request 
>> from UFS
>> driver by calling ufshcd_abort() eventually. ufshcd_abort() will think 
>> this
>> request has been completed due to its tag is not in 
>> hba->outstanding_reqs
>> or UFS host's door bell reg. However, actually, this request is still 
>> in
>> ufshcd_queuecommand() path. I don't need to continue on the subsequent
>> impact
>> to UFS driver if ufshcd_abort() happens in this case. This is a corner
>> case,
>> but it is still possible (I did see map_sg() ops hangs on real 
>> devices).
>> 
>> Having the UFS timeout handler back will prevent this situation as UFS
>> timeout
>> handler checks if the tag is in hba->outstanding_reqs (for our case, 
>> it
>> is not
>> in there), if no, it returns BLK_EH_RESET_TIMER so that scsi/block 
>> layer
>> will
>> keep waiting.
>> 
>> What do you think? Please let me know your ideas on this, thanks!

Hi Bart,

> 
> Hi Can,
> 
> I see the following issues with the above proposal:
> - Although I haven't been able to find explicit documentation of this, 
> I
>   think that dma_map_sg() must not sleep. If it would sleep that would
>   break most block and SCSI drivers because many of these drivers call
>   dma_map_sg() from their .queue_rq() or .queuecommand() implementation
>   and if BLK_MQ_F_BLOCKING has not been set these functions must not
>   sleep.
> - A timeout handler must not be invoked while .queuecommand() is still
>   in progress. The SCSI core calls blk_mq_start_request() before it
>   calls ufshcd_queuecommand(). The blk_mq_start_request() activates the
>   block layer timeout mechanism. ufshcd_queuecommand() must have
>   finished before the block layer timeout handler is activated.
> 
> Please fix the root cause, namely the map_sg implementation that may 
> get
> stuck.
> 
> Thanks,
> 
> Bart.

queuecommand path should not sleep - that is right, due to queuecommand
can be invoked from contexts where preempt is disabled, e.g. softirq.

I don't know why map_sg() ops can take that long, but apparently it does
not sleep, otherwise we should have seen schedule while atomic error 
long
time ago.

> ufshcd_queuecommand() must have
> finished before the block layer timeout handler is activated.
This is the ideal/expected situation, but we are seeing the corner case.

Fixing the root cause of that is one thing, but having the timeout 
handler
back can prevent UFS driver from messing up the subsequent requests 
further
in such case, causing possible data corruption. Is there any drawbacks 
if
we have it back?

Thanks,
Can Guo.
