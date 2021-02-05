Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B075DC433E9
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 06:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B0D64FC5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 06:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhBEGKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 01:10:54 -0500
Received: from so15.mailgun.net ([198.61.254.15]:21977 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhBEGKw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 Feb 2021 01:10:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612505428; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=IFL4u0zMOgMkwj7IrAvMy3o6w3y0xusQQ4M2DQQ2kcU=;
 b=lKbM2uB0UeaMKmaXjrrpFWTLyWqZ4QSWyv0TJSWIu3D6vlt8+S/Br51cjrR47gZJBMe6kCkO
 h1kDJZi5APtrrih1lT7ZlhVfiJBxNQVajwIbLf8fcataSab/Wgc/D0QQnFJH1PfEM+pYco1V
 Ktd1I0iXL93ojCZ0tLbDhfa+tPQ=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 601ce13371c267229398a565 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Feb 2021 06:09:55
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0F519C43462; Fri,  5 Feb 2021 06:09:55 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4462BC433C6;
        Fri,  5 Feb 2021 06:09:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 05 Feb 2021 14:09:54 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] scsi: ufs: Fix wrong Task Tag used in task
 management request UPIUs
In-Reply-To: <cd83aa1d-444e-d4ba-c363-517dbf07891a@acm.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-4-git-send-email-cang@codeaurora.org>
 <8351747f-0ec9-3c66-1bdf-b4b73fcee698@acm.org>
 <f0d1c6a196a044198647df6ca4b06efb@codeaurora.org>
 <cd83aa1d-444e-d4ba-c363-517dbf07891a@acm.org>
Message-ID: <cf50ecf7a245674f8aee917455a7ccfa@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-01 10:39, Bart Van Assche wrote:
> On 1/28/21 9:57 PM, Can Guo wrote:
>> On 2021-01-29 11:15, Bart Van Assche wrote:
>>> On 1/27/21 8:16 PM, Can Guo wrote:
>>>> In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs +
>>>> req->tag as
>>>> the Task Tag in one TMR UPIU. Directly use req->tag as the Task Tag.
>>> 
>>> Why is the current code wrong and why is this patch the proper fix?
>>> Please explain this in the patch description.
>> 
>> req->tag is the tag allocated for one TMR, no?
> 
> Hi Can,
>  Commit e293313262d3 ("scsi: ufs: Fix broken task management command
> implementation") includes the following changes:
> 
> +       task_tag = hba->nutrs + free_slot;
>         task_req_upiup->header.dword_0 =
>                 UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
> -                                            lrbp->lun, 
> lrbp->task_tag);
> +                                            lun_id, task_tag);
>         task_req_upiup->header.dword_1 =
>                 UPIU_HEADER_DWORD(0, tm_function, 0, 0);
> 
> As one can see the value written in dword_0 starts at hba->nutrs. Was
> that code correct? If that code was correct, does your patch perhaps
> break task management support?

That code is wrong. The Task Tag in Dword_0 should be the real tag we
allocated for TMR. The transfer request Task Tag which we are trying to
abort is given in Dword_5, which is the Input Parameter 3 of the TMR 
UPIU.
I am not sure why the author gave hba->nutrs + req->tag as the Task Tag
of one TMR, the commit msg abot this part is not quite informative....

Table 10.22 — Task Management Request UPIU
TASK MANAGEMENT REQUEST UPIU
----------------------------------
|0         |1      |2   |3       |
----------------------------------
|xx00 0100b| Flags |LUN |Task Tag|
----------------------------------
...
16 (MSB)   |17     |18  |19 (LSB)|
----------------------------------
Input Parameter 2
----------------------------------

Table 10.24 — Task Management Input Parameters
Field Description
Input Parameter 2 LSB: Task Tag of the task/command operated by the task 
management function.

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
