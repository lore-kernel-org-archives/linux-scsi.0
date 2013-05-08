From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [SCSI] ufs: add support for query requests
Date: Tue, 7 May 2013 23:27:26 -0700
Message-ID: <a68a1a1bc5658e8e61acda91340f2aa4.squirrel@www.codeaurora.org>
References: <20130507142540.GA20764@elgon.mountain>
    <1367964184.4108.27.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21063 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3EHG10 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 02:27:26 -0400
In-Reply-To: <1367964184.4108.27.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, draviv@codeaurora.org, linux-scsi@vger.kernel.org, kbuild@01.org


> On Tue, 2013-05-07 at 17:25 +0300, Dan Carpenter wrote:
>> Hello Dolev Raviv,
>>
>> This is a semi-automatic email about new static checker warnings.
>>
>> The patch 3aee47c623a3: "[SCSI] ufs: add support for query requests"
>> from May 2, 2013, leads to the following Smatch complaint:
>>
>> drivers/scsi/ufs/ufshcd.c:723 ufshcd_query_request()
>> 	 error: we previously assumed 'hba' could be null (see line 722)
>>
>> drivers/scsi/ufs/ufshcd.c
>>    721
>>    722		if (!hba || !query || !response) {
>>                     ^^^^
>> New check.
>>
>>    723			dev_err(hba->dev,
>>                                 ^^^^^^^^
>> New dereference.
>>
>>    724				"%s: NULL pointer hba = %p, query = %p response = %p\n",
>>    725				__func__, hba, query, response);
>
> We don't actually have any callers of this function either, so nothing
> ever exercises the code.  Given that we're not supposed to put stuff in
> the tree without a use case anyway, I can just remove it and then it can
> be resubmitted when the function has a user.

This is fine, this patch introduce the infrastructure and the api.
I could upload the api as part of the fDeviceInit patch that was sent before.

>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


