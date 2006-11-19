From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND 2/2] SCSI: add scsi_device->retries
Date: Mon, 20 Nov 2006 08:31:28 +0900
Message-ID: <4560E950.9000209@gmail.com>
References: <20061119125115.GJ2184@htj.dyndns.org> <20061119125200.GK2184@htj.dyndns.org> <Pine.LNX.4.64.0611200001230.4946@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:23774 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S933755AbWKSXbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 18:31:36 -0500
Received: by nf-out-0910.google.com with SMTP id o25so2110663nfa
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2006 15:31:35 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.0611200001230.4946@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Hello,

Kai Makisara wrote:
>> * st uses three retry limits - MAX_RETRIES, MAX_WRITE_RETRIES and
>>   MAX_READY_RETRIES, which are all zero.  This patch only converts
>>   MAX_RETRIES to sdev->retries.  Defining WRITE and READY retries in
>>   terms of sdev->retries would make more sense.
>>
> I am neither acking nor naking this now. The patch does not change st 
> behavior but moves part of the retry strategy out of the driver. (Which is 
> also good because it makes one of the retry limits user changeable.)
> 
> Combining all retry counts is something that may not be a good thing. 
> Below is justification why st has three different retry limits.
> 
> For some devices one number of retries is not perfect for all functions.
> 
> The firmware of tape devices usually retries quite thoroughly before 
> returning error. This is why the default zero applies to most cases.
> 
> MAX_WRITE_RETRIES is separate from MAX_RETRIES because a plausible 
> strategy might be (maybe not any more) to allow no retries for write but 
> allow retries for reading and repositioning. The writes should fail 
> directly so that the minimum number of marginal errors will be written. 
> The reads can be retried so that even marginal data can be recovered. 
> (Note that this may lead to tape positioning errors and may not be a 
> good strategy in all cases.)
> 
> MAX_READY_RETRIES is used for commands that don't move the tape. This is a 
> situation where retrying is probably harmless.

I see.  Then, how about adding and initializing STp->write_retries and 
STp->ready_retries according to SDp->retries (some reasonable default 
value, say write_retries is always zero while ready_retries is round up 
of retries * 1.1) and export both through sysfs?  That will give lower 
level primitive control as other ULDs do and also allow users to 
configure each timeout separately if necessary.

Thanks.

-- 
tejun
