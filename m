From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 6/7] bnx2fc: Add HZ to task management timeout.
Date: Tue, 20 Oct 2015 10:17:11 -0400
Message-ID: <alpine.OSX.2.00.1510201016130.4822@administrators-macbook-pro.local>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com> <1445283641-7358-7-git-send-email-chad.dupuis@qlogic.com> <562629BE.4020904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:25468 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbbJTOR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Oct 2015 10:17:29 -0400
In-Reply-To: <562629BE.4020904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org



On Tue, 20 Oct 2015, Tomas Henzl wrote:

> On 19.10.2015 21:40, Chad Dupuis wrote:
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>> ---
>>  drivers/scsi/bnx2fc/bnx2fc.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
>> index d46267d..d05866d 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc.h
>> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
>> @@ -129,7 +129,7 @@
>>  #define BNX2FC_MAX_FCP_TGT		256
>>  #define BNX2FC_MAX_CMD_LEN		16
>>
>> -#define BNX2FC_TM_TIMEOUT		60	/* secs */
>> +#define BNX2FC_TM_TIMEOUT		(60 * HZ) /* seconds */
>
> Hi Chad,
> when you add HZ here it should be removed from bnx2fc_initiate_tmf :
>        rc = wait_for_completion_timeout(&io_req->tm_done,
>                                         BNX2FC_TM_TIMEOUT * HZ);
> Cheers,
> Tomas

Yeah, you're right...no need for this patch then.  Self nack on this one.

>
>>  #define BNX2FC_IO_TIMEOUT		20000UL	/* msecs */
>>
>>  #define BNX2FC_WAIT_CNT			1200
>
>
