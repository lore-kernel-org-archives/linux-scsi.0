From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Mon, 11 May 2009 08:48:53 +0900
Message-ID: <4A0767E5.5050205@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A06DFAB.40205@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:

> Hi Tejun, I've carefully reviewed these files which I know more
> about.  The drivers/block files I've skipped, since I'm not familiar
> with this code.
> 
> Except a small fallout, it looks very good. See some comments plus
> Ack/review below

Thanks a lot for reviewing it closely.  It's really nice to have
careful extra pair of eyes on the changes.  :-)

>> --- a/drivers/message/fusion/mptsas.c
>> +++ b/drivers/message/fusion/mptsas.c
>> @@ -1357,8 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>>  		memcpy(req->sense, smprep, sizeof(*smprep));
>>  		req->sense_len = sizeof(*smprep);
>> -		req->data_len = 0;
>> -		rsp->data_len -= smprep->ResponseDataLength;
>> +		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
>>  	} else {
>>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
>>  		    ioc->name, __func__);
> 
> I think original code was assuming full residual count on the else side
> (not MPT_IOCTL_STATUS_RF_VALID). So maybe add:
> 
> +		rsp->resid_len = rsp->data_len;

Does resid_len make any sense w/ failed requests?  I think we would be
better off with declaring residual count to be undefined on request
failure.  Is there any place which depends on it?

That said, the value is eventually exported to userland, so it might
be better to not change it.  Eh... I don't know.

>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index 3da02e4..6605ec9 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>>  			       bio_data(rsp->bio), rsp->data_len);
>>  	if (ret > 0) {
>>  		/* positive number is the untransferred residual */
>> -		rsp->data_len = ret;
>> -		req->data_len = 0;
>> +		rsp->resid_len = ret;
>>  		ret = 0;
>> -	} else if (ret == 0) {
>> -		rsp->data_len = 0;
>> -		req->data_len = 0;
>>  	}
>>  
>>  	return ret;
> 
> This is actually a bug fix, as well as a strait conversion

Can you elaborate a bit about the bug fix part?

>> @@ -549,7 +549,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
>>  		int leftover = (req->hard_nr_sectors << 9);
>>  
>>  		if (blk_pc_request(req))
>> -			leftover = req->data_len;
>> +			leftover = req->resid_len;
> 
> This is the fallout:
> 
> The above is just a case of:
> 
> -		int leftover = (req->hard_nr_sectors << 9);
> -
> -		if (blk_pc_request(req))
> -			leftover = req->data_len;
> +		int leftover = blk_rq_bytes();
> 
> Which you separated into to stages, much later right?

Aieee.. yeah, that's one stupid misconversion.  That function should
just use blk_end_request_all().  Will fix.  Thanks for spotting it.

>> @@ -778,7 +778,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>>  			scsi_end_bidi_request(cmd);
>>  			return;
>>  		}
>> -		req->data_len = scsi_get_resid(cmd);
>> +		req->resid_len = scsi_get_resid(cmd);
>>  	}
>>  
>>  	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
> 
> Except the fallout the rest of scsi_lib looks good, specifically the
> bidi_parts.
> 
> I'll send a farther cleanup to scsi_lib based on this patchset later.

Cool.

> I've started farther cleanup based on your patchset. However I had a
> merge conflict when merging your branch with Linus-2.6.30-rc5,
> around the block areas, do you know what that might be? I've
> continued to work based on your branch alone, but will wait and post
> it later once things settle.

I saw a conflict in blkdev.h but there could be other things.  I think
it should be fine to just base things on my branch.  I or Jens should
be able to handle merge conflicts later.

I'll update the patchset and repost soonish.

Thanks a lot.

-- 
tejun
