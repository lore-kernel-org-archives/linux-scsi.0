From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 07/18] qla2xxx: Fix to include FCE data as part of
 dump.
Date: Fri, 16 Dec 2011 10:34:53 -0500
Message-ID: <alpine.WNT.2.00.1112161033320.3796@N5102REMCQXM4BS.qlogic.org>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>  <1321635802-16491-8-git-send-email-chad.dupuis@qlogic.com> <1323864196.3063.55.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:51287
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab1LPPfD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 10:35:03 -0500
In-Reply-To: <1323864196.3063.55.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Wed, 14 Dec 2011, James Bottomley wrote:

> On Fri, 2011-11-18 at 09:03 -0800, Chad Dupuis wrote:
>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
>> index 58e0bfb..8607ab7 100644
>> --- a/drivers/scsi/qla2xxx/qla_dbg.c
>> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
>> @@ -369,7 +369,7 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
>>
>>      memcpy(iter_reg, ha->fce, ntohl(fcec->size));
>>
>> -    return iter_reg;
>> +    return (void *)iter_reg + ntohl(fcec->size);
>
> That should be (char *).  (void *) is a pointer to an incomplete type
> and as such pointer arithmetic on it is technically illegal.  gcc treats
> it as char * for this purpose, so the expression works, but other
> compilers (or some future version of gcc) might not be so lenient.
>

Yes, this makes sense as well. Thanks for the info.

> James
>
>
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

