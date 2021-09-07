Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63DFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 00:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3CDA6105A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 00:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbhIGAjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 20:39:07 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:40710 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbhIGAjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 20:39:07 -0400
Received: by mail-pf1-f173.google.com with SMTP id n34so3417741pfv.7
        for <linux-scsi@vger.kernel.org>; Mon, 06 Sep 2021 17:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eXpfI41F5NGLb9j/CY9RF7gFhBYHP0zk8c99DExdGtM=;
        b=QvBGgUCOz3MXcEJz16m+OAcPNtZXeXJXm0lhLR0oVjhrLiYx28xrQQhDz3mMEYudd0
         rVTXP5vlklFiBANiS+bvVNMFYnbrJ/WgcRiDRPTZsqMkakEDcKSOE1In89bYw45knFi2
         Y7WlnH+tyhujhJdCEAVhf815c6kyGois5gtipEC8nImHLXMDEwgxvbplDgIQOPrlzyOw
         ofJQrLTeaV9+2PYV3/0wMrzUcwUXGDX5f+uosjfPEKSvU+rAbgyib75ZM+Cx+AYGBThl
         wX5wGpbZSxddRGTj9/El0KpXLVJ1g1X0E0NkJkjPgLXPi+JxMtjnwtW4NUYfmxuWNjGe
         Bn+Q==
X-Gm-Message-State: AOAM5313hSqL3YWgDA3s/TNVkaooBZ5NERN+XSOkgNSsw54bHQbU1fgh
        pP7Pg1wGSLU70370vPjay80=
X-Google-Smtp-Source: ABdhPJzZwe674ApJNR+JhlMXTG3MyqFv9LR805N2RLwDQPcmtDXtvE0wuRtYujUa+ipcf3pSJF1KjQ==
X-Received: by 2002:aa7:958f:0:b0:416:2525:4ad with SMTP id z15-20020aa7958f000000b00416252504admr4335210pfj.11.1630975081306;
        Mon, 06 Sep 2021 17:38:01 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:6d38:bd0e:234b:803? ([2601:647:4000:d7:6d38:bd0e:234b:803])
        by smtp.gmail.com with UTF8SMTPSA id n26sm3296844pfq.44.2021.09.06.17.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 17:38:00 -0700 (PDT)
Message-ID: <bd3692d9-f3da-9a78-60ee-09e10dd6c77f@acm.org>
Date:   Mon, 6 Sep 2021 17:37:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH V2 1/3] scsi: ufs: Fix error handler clear ua deadlock
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210903095609.16201-1-adrian.hunter@intel.com>
 <20210903095609.16201-2-adrian.hunter@intel.com>
 <56b1a7b3-90b7-e208-2486-20421d32d2e7@acm.org>
 <58c32af5-7a96-16bd-1f59-e77ea97a50f4@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <58c32af5-7a96-16bd-1f59-e77ea97a50f4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/5/21 02:51, Adrian Hunter wrote:
> On 3/09/21 11:29 pm, Bart Van Assche wrote:
>> On 9/3/21 2:56 AM, Adrian Hunter wrote:
>>> There is no guarantee to be able to enter the queue if requests
>>> are blocked. That is because freezing the queue will block entry
>>> to the queue, but freezing also waits for outstanding requests
>>> which can make no progress while the queue is blocked.
>>> 
>>> That situation can happen when the error handler issues requests
>>> to clear unit attention condition. The deadlock is very unlikely,
>>> so the error handler can be expected to clear ua at some point
>>> anyway, so the simple solution is not to wait to enter the
>>> queue.
>>> 
>>> Additionally, note that the RPMB queue might be not be entered
>>> because it is runtime suspended, but in that case ua will be
>>> cleared at RPMB runtime resume.
>> 
>> The only ufshcd_clear_ua_wluns() call that I am aware of and that
>> is related to error handling is the call in
>> ufshcd_err_handling_unprepare(). That call happens after
>> ufshcd_scsi_unblock_requests() has been called so how can it be
>> involved in a deadlock?
> 
> That is a very good question.  I went back to reproduce the deadlock
> again, and it is because, in addition, ufshcd_state is
> UFSHCD_STATE_EH_SCHEDULED_FATAL.  So I have updated the commit
> message accordingly in V3.
 >
>> Additionally, the ufshcd_scsi_block_requests() and
>> ufshcd_scsi_unblock_requests() calls can be removed from
>> ufshcd_err_handling_prepare() and ufshcd_err_handling_unprepare().
>> These calls are no longer necessary since patch "scsi: ufs:
>> Synchronize SCSI and UFS error handling".
> 
> As has been noted, that commit introduces several new deadlocks - and
> will presumably cause the deadlock this patches addresses, even if
> ufshcd_state is not UFSHCD_STATE_EH_SCHEDULED_FATAL.
> 
> It is perhaps more appropriate to revert "scsi: ufs: Synchronize SCSI
> and UFS error handling" for v5.15 and try to get things sorted out
> for v5.16.  What do you think?

Reverting that patch would be a step backwards because it would make it 
again possible that the SCSI EH and UFS EH run concurrently and obstruct 
each other.

Does the above mean that "if (hba->pm_op_in_progress)" should be removed 
from the following code in ufshcd_queuecommand()?

	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
		if (hba->pm_op_in_progress) {
			hba->force_reset = true;
			set_host_byte(cmd, DID_BAD_TARGET);
			cmd->scsi_done(cmd);
			goto out;
		}

Thanks,

Bart.
