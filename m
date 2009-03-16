From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Mon, 16 Mar 2009 04:40:26 -0700
Message-ID: <FEF98017-BE60-4CA8-BD53-6C69D8935BE3@qlogic.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BCCAA4.5060104@panasas.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57651 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZCPLka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2009 07:40:30 -0400
In-Reply-To: <49BCCAA4.5060104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com Schuetz" <sven@linux.vnet.ibm.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Giridhar Malavali <giridhar.malavali@qlogic.com>


On Mar 15, 2009, at 2:30 AM, Boaz Harrosh wrote:

> Seokmann Ju wrote:
>> On Feb 11, 2009, at 7:43 AM, Seokmann Ju wrote:
>>
>>> On Feb 11, 2009, at 7:13 AM, James Smart wrote:
>>>
>>>> Trying to kick-start this again...
>>>> I've updated the prior RFC with the comments from Seokmann,
>>>> SvenFujita, and Boaz. I would still like review on the
>>>> blk_xxx completion calls in the std and error paths.
>>> I'm looking the driver changes to match it with latest updates in
>>> the transport layer.
>>> The driver with the changes should be available within a couple of
>>> weeks.
>> Here is a change that I've made for transport layer while I'm testing
>> the feature.
>> ---
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/
>> scsi_transport_fc.c
>> index 63ab7bc..4bca164 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -3435,10 +3435,11 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>>                 BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
>>                 /* set reply (bidi) residual */
>>                 rsp->data_len = (rsp_len - job->reply-
>>> reply_payload_rcv_len);
>
> This part looks a bit white-space broken.
>
>> -       }
>> +               blk_end_bidi_request(req, err, blk_rq_bytes(req),
>> +                   job->reply->reply_payload_rcv_len);
>>
>> -       /* we assume all request payload was transferred */
>> -       blk_end_request(req, err, blk_rq_bytes(req));
>> +       } else
>> +               blk_end_request(req, err, blk_rq_bytes(req));
>
> I still do not like this version for more then one reason. There is
> a more proper simpler way.
>
> Where is the code-base this is patching? I'll make a proper patch  
> for you.
I took James S's patch from here.
http://lwn.net/Articles/318731/

Thank you,
Seokmann

