From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/4] scsi: ufs: Fix broken task management command implementation
Date: Fri, 28 Jun 2013 17:02:49 +0530
Message-ID: <51CD7461.3000501@codeaurora.org>
References: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org> <1371133860-17574-2-git-send-email-sthumma@codeaurora.org> <CALMYJDuRyovi3X_jmb0-PjZgRYgJfSi_ryg0YO48Cr2bRHLd+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:59110 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3F1Lcz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 07:32:55 -0400
In-Reply-To: <CALMYJDuRyovi3X_jmb0-PjZgRYgJfSi_ryg0YO48Cr2bRHLd+g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-arm-msm@vger.kernel.org

On 6/27/2013 4:49 PM, Santosh Y wrote:
>> >+       spin_lock_irqsave(host->host_lock, flags);
>> >         task_req_descp = hba->utmrdl_base_addr;
>> >         task_req_descp += free_slot;
>> >
>> >@@ -2353,38 +2387,39 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>> >                 (struct utp_upiu_task_req *) task_req_descp->task_req_upiu;
>> >         task_req_upiup->header.dword_0 =
>> >                 UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
>> >-                                             lrbp->lun, lrbp->task_tag);
>> >+                               lun_id, free_slot);
> Actually it still doesn't fix the problem. The*task tag*  used here
> should be unique across the SCSI/Query and Task Managment UPIUs.

I am sorry, I didn't get that. Why should it be unique across the 
SCSI/Query? For example, if a machine supports 32 request slots and 8 
task management slots, then the task management command tag can be 
anything out of 8 slots.

-- 
Regards,
Sujit
