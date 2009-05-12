From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 11:46:58 +0300
Message-ID: <4A093782.80701@panasas.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A08C26E.80801@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 05/12/2009 03:27 AM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Boaz Harrosh wrote:
>> On 05/11/2009 02:48 AM, Tejun Heo wrote:
>>> Does resid_len make any sense w/ failed requests?  I think we would be
>>> better off with declaring residual count to be undefined on request
>>> failure.  Is there any place which depends on it?
>>>
>>> That said, the value is eventually exported to userland, so it might
>>> be better to not change it.  Eh... I don't know.
>> When possible, residual should be exact because the residual amount
>> is not bounced and might even be zeroed-out for security, as the
>> meaning of residual is that these bytes are garbage.
> 
> When a request failed, the whole buffer is garbage.

ret is the transferred size, right? I don't see any check for  
success/failure in below code.

> There's no
> partial transfer.  There shouldn't be.  I don't think residual count
> on request failure means anything. 

That's not true, there are many cases when transfer failed eventually
but some bytes are valid. Even the simple read/write case. Imagine a 
very large transfer with last sector encounter a "bad sector". that can
be critical, (trying to rescue a disk). And many other examples.
 

 Also, the 'whenever possible'
> doesn't mean much when the issuer can't determine whether the value is
> valid or not.  On success, we should guarantee resid count is valid,
> on failure, I don't see a way we can.
> 

Code is as strong as it's weakest link, right? If lower driver/firmware
is brain-dead, what can we do? But why give up where you can do better?

The scsi standard is very clear about what every one should do with the residual
and what it means at every stage, everyone should do his part. Here at the middle
layer we need to correctly translate what lower level returned and pass it up the
chain.

Must stacks are amateuristic in regard to error handling but some are not, what
should we strive for, if we can? 

>>>>> index 3da02e4..6605ec9 100644
>>>>> --- a/drivers/scsi/libsas/sas_expander.c
>>>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>>>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>>>>>  			       bio_data(rsp->bio), rsp->data_len);
>>>>>  	if (ret > 0) {
>>>>>  		/* positive number is the untransferred residual */
>>>>> -		rsp->data_len = ret;
>>>>> -		req->data_len = 0;
>>>>> +		rsp->resid_len = ret;
>>>>>  		ret = 0;
>>>>> -	} else if (ret == 0) {
>>>>> -		rsp->data_len = 0;
>>>>> -		req->data_len = 0;
>>>>>  	}
>>>>>  
>>>>>  	return ret;
>>>> This is actually a bug fix, as well as a strait conversion
>>> Can you elaborate a bit about the bug fix part?
>> Nothing big really, just that before (according to the comment), the
>> theoretical negative case would be full-residual. and now it is zero
>> (untouched).
> 
> Yeah, the same thing as above, I suppose.
> 

Should we check for errors then?

>> I know that in iscsi a negative residual is possible which means
>> over-flow. That is: the target had more data to give then the buffer
>> had space for. (which is not an error at all)
> 
> Hmm... I've never seen negative residual in use.  Is it even defined?
> 

It is defined, as I explained before. But yes no one uses it in Kernel.
The "good" low-level drivers fix it up by setting resid to zero, in that
case. (other wise the upper layers might crash)

>>>> The above is just a case of:
>>>>
>>>> -		int leftover = (req->hard_nr_sectors << 9);
>>>> -
>>>> -		if (blk_pc_request(req))
>>>> -			leftover = req->data_len;
>>>> +		int leftover = blk_rq_bytes();
>>>>
>>>> Which you separated into to stages, much later right?
>>> Aieee.. yeah, that's one stupid misconversion.  That function should
>>> just use blk_end_request_all().  Will fix.  Thanks for spotting it.
>> Yes, there is a couple of other places that have that with the
>> meaning of blk_end_request_all() (Have I commented on one?). Are you
>> doing this conversion in these patchset? or this is for a second
>> pass?
> 
> If you spot some, please go ahead and submit patches.  I don't have
> any patch in my queue which hasn't been posted.
> 
> Thanks.
> 

Thanks
Boaz
