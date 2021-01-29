Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AD8C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C4B64DFF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhA2F6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:58:35 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:14169 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231965AbhA2F6e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Jan 2021 00:58:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611899887; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=/g9Z8CUjGzUYN5AdIpOXqDsXSC/Y686XirND/DPmaKg=;
 b=XBigt5Cq3EfW5PWnYBdBcnkP0TdocAnw9x5KKZNiGfnDx+Kk1DKLxaAXWaw++FltbL073Rka
 WuiJnOZlb10RsHxye5f5SByQl9XXmDy7R5O0vB8dnrOj1/Ql8kCPirgJgmftY83fVgUu7mPd
 qnCbWPedSzihP8ltYNR0kx+6SsY=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6013a3c8d08556f4551241e1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 Jan 2021 05:57:28
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E1056C43464; Fri, 29 Jan 2021 05:57:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F6AAC433CA;
        Fri, 29 Jan 2021 05:57:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 Jan 2021 13:57:27 +0800
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
In-Reply-To: <8351747f-0ec9-3c66-1bdf-b4b73fcee698@acm.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-4-git-send-email-cang@codeaurora.org>
 <8351747f-0ec9-3c66-1bdf-b4b73fcee698@acm.org>
Message-ID: <f0d1c6a196a044198647df6ca4b06efb@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-29 11:15, Bart Van Assche wrote:
> On 1/27/21 8:16 PM, Can Guo wrote:
>> In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs + 
>> req->tag as
>> the Task Tag in one TMR UPIU. Directly use req->tag as the Task Tag.
> 
> Why is the current code wrong and why is this patch the proper fix?
> Please explain this in the patch description.
> 

req->tag is the tag allocated for one TMR, no?

>> +	 * blk_get_request() used here is only to get a free tag.
> 
> Please fix the word order in this comment ("blk_get_request() is used
> here only to get a free tag").

Sure.

> 
>> +	ufshcd_release(hba);
>>  	blk_put_request(req);
>> 
>> -	ufshcd_release(hba);
> 
> An explanation for this change is missing from the patch description.
> 

This is just for symmetric coding since this change is almost
re-writing the whole func - at the entrence it calls blk_get_request()
and ufshcd_hold(), so before exit it'd be good to call ufshcd_release()
before blk_put_request(). If you think this single line change worths
a separate patch, I can split it out in next version.

Thanks,
Can Guo.

> Thanks,
> 
> Bart.
