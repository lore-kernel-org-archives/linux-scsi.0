From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Current git --> kaboom [bisect] seems IDE related.
Date: Sun, 10 Feb 2008 17:07:13 +0200
Message-ID: <47AF1321.7000107@panasas.com>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com> <20080210144352.GA3537@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080210144352.GA3537@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 10 2008 at 16:43 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Feb 10, 2008 at 02:38:46PM +0100, Bartlomiej Zolnierkiewicz wrote:
>> The OOPS is most likely (again) my fault - I was rushing out to push out
>> the fix and memset() line didn't get converted.
> 
> The new patch works fine for me.
> 
>> I prepared the new patch, documented it and started looking into SCSI
>> build breakage... and I no longer feel comfortable with the hack :(
>>
>> It seems that fixing IDE properly will be easier than auditing the whole
>> SCSI for all the weird assumptions on rq->cmd[] size (James?) so I'm back
>> to the code, in the meantime here's the updated patch:
> 
> Yeah, this is quite nasty.  I'll attach the patch below which just
> rejects a command in scsi_setup_blk_pc_cmnd if it's too large for
> the scsi_cmnd cmnd array.  This is probably enough but I haven't
> audited all of the scsi code yet.  But as James said this is
> too much of a memory vastage to put it into the tree.
> 
> Long-term the Panasas folks have looked into killing the scsi_cmnd.cmnd
> filed entirely and make the struct request.cmd field dynamically sized
> which would solve your problem, but probably won't be ready for 2.6.25.
> 
> 
<snip>

As far as I'm concerned it is very ready, and I have sent a last version
for inclusion into 2.6.25.
- There is a very minor patch-ability problem between last patchset and 
  scsi-misc I will resend the pachset as a reply to this mail.
- Since I never got any comments from Jens or James, this code was never
  accepted into -mm. So it was not widely tested. Though I have thrown
  every test I can on these patches. But that is still, a very limited 
  testing.

If people have a bit of spare time, please review. For some of us it is
very important

Thanks
Boaz
