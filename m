From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Fri, 28 Oct 2016 11:53:46 +0200
Message-ID: <4b411836-e76f-b67a-3d49-ad3d51b8f216@linux.vnet.ibm.com>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
 <2ea07f3f-88eb-b795-fa37-a223bf80e581@linux.vnet.ibm.com>
 <20161013162405.aoxy3bdkc4bqtwsk@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34551 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753390AbcJ1JyA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 05:54:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9S9rxP9085414
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2016 05:53:59 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26c2qe4gsw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2016 05:53:59 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Fri, 28 Oct 2016 10:53:54 +0100
In-Reply-To: <20161013162405.aoxy3bdkc4bqtwsk@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>s



On 10/13/2016 06:24 PM, Johannes Thumshirn wrote:
> On Thu, Oct 13, 2016 at 05:15:25PM +0200, Steffen Maier wrote:
>> I'm puzzled.
>>
>> $ git bisect start fc_bsg master

>>> 3087864ce3d7282f59021245d8a5f83ef1caef18 is the first bad commit
>>> commit 3087864ce3d7282f59021245d8a5f83ef1caef18
>>> Author: Johannes Thumshirn <jthumshirn@suse.de>
>>> Date:   Wed Oct 12 15:06:28 2016 +0200
>>>
>>>     scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>>>
>>>     Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
>>>     helper variables bsg_request and bsg_reply. This will be helpfull  when
>>>     transitioning to bsg-lib.
>>>
>>>     Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>>>
>>> :040000 040000 140c4b6829d5cfaec4079716e0795f63f8bc3bd2 0d9fe225615679550be91fbd9f84c09ab1e280fc M	drivers
>>
>> From there (on the reverse bisect path) I get the following Oops,
>> except for the full patch set having another stack trace as in my previous
>> mail (dying in zfcp code).
>>
>
> [...]
>
>>
>>> @@ -3937,6 +3944,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>>>  	struct request *req;
>>>  	struct fc_bsg_job *job;
>>>  	enum fc_dispatch_result ret;
>>> +	struct fc_bsg_reply *bsg_reply;
>>>
>>>  	if (!get_device(dev))
>>>  		return;
>>> @@ -3973,8 +3981,9 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>>>  		/* check if we have the msgcode value at least */
>>>  		if (job->request_len < sizeof(uint32_t)) {
>>>  			BUG_ON(job->reply_len < sizeof(uint32_t));
>>> -			job->reply->reply_payload_rcv_len = 0;
>>> -			job->reply->result = -ENOMSG;
>>> +			bsg_reply = job->reply;
>>> +			bsg_reply->reply_payload_rcv_len = 0;
>>> +			bsg_reply->result = -ENOMSG;

Compiler optimization re-ordered above two lines and the first pointer 
derefence is bsg_reply->result [field offset 0] where bsg_reply is NULL.
The assignment tries to write to memory at address NULL causing the 
kernel page fault.

Does your suggested change for [PATCH v3 02/16], shuffling the 
job->request_len checks, address above kernel page fault?

>>>  			job->reply_len = sizeof(uint32_t);
>>>  			fc_bsg_jobdone(job);
>>>  			spin_lock_irq(q->queue_lock);
>>>
>
> Ahm and what exactly can break here? It's just assigning variables. Now
> I'm puzzled too.


-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

