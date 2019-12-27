Return-Path: <SRS0=4AUr=2R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6DAC2D0C3
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 05:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13EB9208C4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 05:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="OQjD3ZKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfL0Fu7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Dec 2019 00:50:59 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:54441 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbfL0Fu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Dec 2019 00:50:59 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577425858; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=L4g9JDgVQ7pa2YXxfZuRLv37uHydhuYzTYFuEaQJFPg=;
 b=OQjD3ZKeWsnnNv9Ev19RIo5P4U/M8aakCaZDkIWB/DcIax34Rgh9skvkSv0jqHKWQAOVwvRQ
 DPoW7Igygp4/4YNchEBG7qluikTQZPz6XxGoktVd2Vxpsq8lu+oUO6dCcQfzhyYkwN2YzvAB
 7rB2emdAyLh6DrQU/rJn0noiTvI=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e059bc1.7f92461eb618-smtp-out-n02;
 Fri, 27 Dec 2019 05:50:57 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 55C67C447A6; Fri, 27 Dec 2019 05:50:56 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 911EAC433CB;
        Fri, 27 Dec 2019 05:50:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 27 Dec 2019 13:50:54 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 4/6] ufs: Fix a race condition in the tracing code
In-Reply-To: <27fdf41d-9ec1-380b-e481-7d76a2906c3d@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-5-bvanassche@acm.org>
 <39b63e90a34a294957c89bd30d0e4912@codeaurora.org>
 <27fdf41d-9ec1-380b-e481-7d76a2906c3d@acm.org>
Message-ID: <b3fdbe9779af3eab89c05da6ff4ea0fb@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-27 01:35, Bart Van Assche wrote:
> On 12/25/19 2:59 AM, Can Guo wrote:
>> On 2019-12-25 06:02, Bart Van Assche wrote:
>>> Starting execution of a command before tracing a command may cause 
>>> the
>>> completion handler to free data while it is being traced. Fix this 
>>> race
>>> by tracing a command before it is submitted.
>>> 
>>> Cc: Bean Huo <beanhuo@micron.com>
>>> Cc: Can Guo <cang@codeaurora.org>
>>> Cc: Avri Altman <avri.altman@wdc.com>
>>> Cc: Stanley Chu <stanley.chu@mediatek.com>
>>> Cc: Tomas Winkler <tomas.winkler@intel.com>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index 80b028ba39e9..4d9bb1932b39 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -1875,12 +1875,12 @@ void ufshcd_send_command(struct ufs_hba *hba,
>>> unsigned int task_tag)
>>>  {
>>>      hba->lrb[task_tag].issue_time_stamp = ktime_get();
>>>      hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
>>> +    ufshcd_add_command_trace(hba, task_tag, "send");
>> 
>> How about moving it after __set_bit(task_tag, 
>> &hba->outstanding_reqs);?
>> 
>> Thanks,
>> 
>> Can Guo.
>> 
>>>      ufshcd_clk_scaling_start_busy(hba);
>>>      __set_bit(task_tag, &hba->outstanding_reqs);
>>>      ufshcd_writel(hba, 1 << task_tag, 
>>> REG_UTP_TRANSFER_REQ_DOOR_BELL);
>>>      /* Make sure that doorbell is committed immediately */
>>>      wmb();
>>> -    ufshcd_add_command_trace(hba, task_tag, "send");
>>>  }
> 
> Hi Can,
> 
> As far as I can see ufshcd_add_command_trace() does not read
> hba->outstanding_reqs so calling ufshcd_add_command_trace() before
> changing outstanding_reqs should be fine.
> 
> The order chosen in the posted patch should minimize energy usage of
> the UFS controller, namely by calling the tracing function before
> starting clock scaling.
> 
> Thanks,
> 
> Bart.

True.

One concern regards this change is that since we move the 
ufshcd_add_command_trace() before ringing doorbell, in tracing log,
we will lose the info/status of this specific tag in doorbell register.

Usually, with the old code, after we collect the tracing log, we can
tell whether the doorbell bit was set/rung correctly in doorbell
register or not for an specific tag/task, because it is an important
sign of whether HW had actually accepted the task on that tag. It
is really helpful sometime if things go wrong.

Any good ways to keep the doorbell info as before?

Thanks,

Can Guo.
