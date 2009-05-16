From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to blk_rq_bytes()
 on issue
Date: Sat, 16 May 2009 16:29:33 +0400
Message-ID: <4A0EB1AD.6050806@ru.mvista.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0D8C73.50208@ru.mvista.com> <4A0DEA33.5050905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0DEA33.5050905@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Pete Zaitcev <zaitcev@redhat.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

>>> Index: block/drivers/message/fusion/mptsas.c
>>> ===================================================================
>>> --- block.orig/drivers/message/fusion/mptsas.c
>>> +++ block/drivers/message/fusion/mptsas.c
>>> @@ -1357,7 +1357,8 @@ static int mptsas_smp_handler(struct Scs
>>>          smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>>>          memcpy(req->sense, smprep, sizeof(*smprep));
>>>          req->sense_len = sizeof(*smprep);
>>> -        rsp->resid_len = blk_rq_bytes(rsp) - smprep->ResponseDataLength;
>>> +        req->resid_len = 0;
>>> +        rsp->resid_len -= smprep->ResponseDataLength;
>>>       
>>    Is negative resid_len intended here? If so, shouldn't it be simply:
>>
>>         rsp->resid_len = -smprep->ResponseDataLength;
>>     
>
> From patch description.
>
>  This patchset restores the original behavior by setting rq->resid_len
>  to blk_rq_bytes(rq) on issue and restoring explicit clearing in
>  affected drivers.
>
> So, rsp->resid_len equals the initial request length before the
> subtraction and after subtraction it becomes the residue count.  The
> original code was
>
> 	req->data_len = 0;
> 	rsp->data_len -= smprep->ResponseDataLength;
>   

  Ah, I've confused up 'rsp' and 'req' as being one thing. Nevermind 
then. :-<

>>> Index: block/drivers/scsi/libsas/sas_expander.c
>>> ===================================================================
>>> --- block.orig/drivers/scsi/libsas/sas_expander.c
>>> +++ block/drivers/scsi/libsas/sas_expander.c
>>> @@ -1937,7 +1937,11 @@ int sas_smp_handler(struct Scsi_Host *sh
>>>      if (ret > 0) {
>>>          /* positive number is the untransferred residual */
>>>          rsp->resid_len = ret;
>>> +        req->resid_len = 0;
>>>          ret = 0;
>>> +    } else if (ret == 0) {
>>> +        rsp->resid_len = 0;
>>> +        req->resid_len = 0;
>>>       
>
> Heh... there's a reason I mentioned the original commit.  The original
> code was
>
> 	if (ret > 0) {
> 		/* positive number is the untransferred residual */
> 		rsp->data_len = ret;
> 		req->data_len = 0;
> 		ret = 0;
> 	} else if (ret == 0) {
> 		rsp->data_len = 0;
> 		req->data_len = 0;
> 	}
>   

   But still,

                req->data_len = 0;

is common between both branches, so could be moved after the *if* statement.

>>> Index: block/drivers/scsi/libsas/sas_host_smp.c
>>> ===================================================================
>>> --- block.orig/drivers/scsi/libsas/sas_host_smp.c
>>> +++ block/drivers/scsi/libsas/sas_host_smp.c
>>> @@ -176,9 +176,6 @@ int sas_smp_host_handler(struct Scsi_Hos
>>>      resp_data[1] = req_data[1];
>>>      resp_data[2] = SMP_RESP_FUNC_UNK;
>>>  
>>> -    req->resid_len = blk_rq_bytes(req);
>>> -    rsp->resid_len = blk_rq_bytes(rsp);
>>> -
>>>       
>
> Cuz it's already set to blk_rq_bytes().
>   

   Mixed them up again... :-<

>>>      switch (req_data[1]) {
>>>      case SMP_REPORT_GENERAL:
>>>          req->resid_len -= 8;
>>> Index: block/drivers/scsi/mpt2sas/mpt2sas_transport.c
>>> ===================================================================
>>> --- block.orig/drivers/scsi/mpt2sas/mpt2sas_transport.c
>>> +++ block/drivers/scsi/mpt2sas/mpt2sas_transport.c
>>> @@ -1170,8 +1170,8 @@ transport_smp_handler(struct Scsi_Host *
>>>  
>>>          memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
>>>          req->sense_len = sizeof(*mpi_reply);
>>> -        rsp->resid_len = blk_rq_bytes(rsp) -
>>> -                 mpi_reply->ResponseDataLength;
>>> +        req->resid_len = 0;
>>> +        rsp->resid_len -= mpi_reply->ResponseDataLength;
>>>       
>>    Again, is negative resid_len intended?
>>     
>
> Ditto.
>   

   ... and again.

> Thanks.
>   

WBR, Sergei


