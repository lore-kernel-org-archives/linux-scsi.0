Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B06AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 23:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhKVXFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:05:15 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:55612 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229739AbhKVXFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 18:05:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637622128; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=t0AYXy6Z6e0zzKQqgcekATfBpCZJU02TWh34xdyQLu8=; b=eYrtGbFS7Nu2QwTCz2eazd5oIa4ozliHxdslKgGhZsc/m9D21JVlVjtDv59ZSLSZk50WEvjq
 IJZ3mtzg9wFfxxPweS/F+3FEbpUW5VCeXiRXrHF7C0wzNfNaa1hB7HKT9F23a5qhjuHkb9KW
 CRSJ1F17Wq4pTb1jqHyF7Vc5iSs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 619c216fe7d68470afadf8c0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Nov 2021 23:02:07
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F30DC43639; Mon, 22 Nov 2021 23:02:05 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DE4A9C4360D;
        Mon, 22 Nov 2021 23:02:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org DE4A9C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <2071f69b-885f-e0c5-3ded-9f0c39eb38ae@codeaurora.org>
Date:   Mon, 22 Nov 2021 15:02:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2 18/20] scsi: ufs: Optimize the command queueing code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-19-bvanassche@acm.org>
 <a2599b2c-208c-3333-61f0-d61a269b53d4@codeaurora.org>
 <f6eb1b4c-ef73-7e34-cecd-fa0c9ce07a2f@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <f6eb1b4c-ef73-7e34-cecd-fa0c9ce07a2f@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/2021 10:13 AM, Bart Van Assche wrote:
> On 11/22/21 9:46 AM, Asutosh Das (asd) wrote:
>> On 11/19/2021 11:57 AM, Bart Van Assche wrote:
>>> +    blk_freeze_queue_start(hba->tmf_queue);
>>> +    blk_freeze_queue_start(hba->cmd_queue);
>>> +    shost_for_each_device(sdev, hba->host)
>>> +        blk_freeze_queue_start(sdev->request_queue);
>>
>> This would still issue the requests present in the queue before 
>> freezing and that's a concern.
> 
> Isn't that exactly what the existing code is doing since the existing 
> code waits until both doorbell registers are zero? See also 
> ufshcd_wait_for_doorbell_clr().
> 
> Thanks,
> 
> Bart.
Current code waits for the already issued requests to complete. It 
doesn't issue the yet-to-be issued requests. Wouldn't freezing the queue 
issue the requests in the context of scaling_{up/down}?
If yes, I don't think the current code is doing that.

-asd

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
