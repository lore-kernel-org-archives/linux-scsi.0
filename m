From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Mon, 11 May 2009 14:31:41 +0300
Message-ID: <4A080C9D.9000109@panasas.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0767E5.5050205@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 05/11/2009 02:48 AM, Tejun Heo wrote:
> 
> Does resid_len make any sense w/ failed requests?  I think we would be
> better off with declaring residual count to be undefined on request
> failure.  Is there any place which depends on it?
> 
> That said, the value is eventually exported to userland, so it might
> be better to not change it.  Eh... I don't know.
> 

When possible, residual should be exact because the residual amount is not bounced
and might even be zeroed-out for security, as the meaning of residual is that these bytes
are garbage.

>>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>>> index 3da02e4..6605ec9 100644
>>> --- a/drivers/scsi/libsas/sas_expander.c
>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>>>  			       bio_data(rsp->bio), rsp->data_len);
>>>  	if (ret > 0) {
>>>  		/* positive number is the untransferred residual */
>>> -		rsp->data_len = ret;
>>> -		req->data_len = 0;
>>> +		rsp->resid_len = ret;
>>>  		ret = 0;
>>> -	} else if (ret == 0) {
>>> -		rsp->data_len = 0;
>>> -		req->data_len = 0;
>>>  	}
>>>  
>>>  	return ret;
>> This is actually a bug fix, as well as a strait conversion
> 
> Can you elaborate a bit about the bug fix part?
> 

Nothing big really, just that before (according to the comment), the theoretical
negative case would be full-residual. and now it is zero (untouched).

I know that in iscsi a negative residual is possible which means over-flow. That is:
the target had more data to give then the buffer had space for. (which is not an error at all)

>>> @@ -549,7 +549,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
>>>  		int leftover = (req->hard_nr_sectors << 9);
>>>  
>>>  		if (blk_pc_request(req))
>>> -			leftover = req->data_len;
>>> +			leftover = req->resid_len;
>> This is the fallout:
>>
>> The above is just a case of:
>>
>> -		int leftover = (req->hard_nr_sectors << 9);
>> -
>> -		if (blk_pc_request(req))
>> -			leftover = req->data_len;
>> +		int leftover = blk_rq_bytes();
>>
>> Which you separated into to stages, much later right?
> 
> Aieee.. yeah, that's one stupid misconversion.  That function should
> just use blk_end_request_all().  Will fix.  Thanks for spotting it.
> 

Yes, there is a couple of other places that have that with the meaning of
blk_end_request_all() (Have I commented on one?). Are you doing this conversion
in these patchset? or this is for a second pass?

> 
> Thanks a lot.
> 

Thanks
Boaz
