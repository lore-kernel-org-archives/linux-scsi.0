From: Steven Haber <steven@qumulo.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Mon, 9 Jun 2014 10:21:42 -0700
Message-ID: <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	<1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36305 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaFIRVn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2014 13:21:43 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so1038404oag.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jun 2014 10:21:42 -0700 (PDT)
In-Reply-To: <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

Thanks a bunch James! I patched and ran our suite over the weekend and
didn't see any failures at all. I also didn't notice any side effects.
I poked through the kernel logs and everything looked like it did
before. I'll let you know if anything else weird crops up. Any idea
when this will get checked in?

Steven

On Sat, Jun 7, 2014 at 12:29 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2014-06-05 at 16:52 -0700, Steven Haber wrote:
>> Hello,
>>
>> I am testing ATA device durability during hot unplug. I have a power
>> fault test suite that has turned up issues with the fsync->SCSI->ATA
>> codepath. If a device is unplugged while an fsync is in progress, ATA
>> returns a flush error to the SCSI driver but scsi_io_completion()
>> seems to disregard it. fsync() returns no error, which should mean
>> that the write was durably flushed to disk. I expect fsync() to return
>> EIO or something similar when the flush isn't acked by the device.
>>
>> When the failure occurs, the SCSI sense key is set to ABORTED_COMMAND.
>> However, scsi_end_command() is called without any of the sense context
>> and scsi_io_completion() returns early without checking sense at all.
>>
>> This commit may be related:
>> d6b0c53723753fc0cfda63f56735b225c43e1e9a
>> (http://git.opencores.org/?a=commitdiff&p=linux&h=d6b0c53723753fc0cfda63f56735b225c43e1e9a)
>>
>> The following patch fixes the issue, but it's a hack. I only have a
>> vague understanding of Linux drivers, so I'm looking for advice on how
>> to make this fix better and get it upstream.
>
> OK, so for some reason this is a zero size REQ_TYPE_FS command, which
> the logic actually assumes we cannot have.
>
> I suspect REQ_TYPE_FLUSH subtly broke this logic because it's coming
> back to us as REQ_TYPE_FS even though it's been set up (in SCSI) as
> REQ_TYPE_BLOCK_PC.
>
> On this theory, we'd eat the return codes of all no data transfer
> commands that fail.  I think the generic fix is to make sure that all
> commands initiallised as REQ_TYPE_BLOCK_PC actually have the ->cmd_type
> set to that.
>
> There may be some knock on side effects because it doesn't look like the
> block flush code expects us to change the request->cmd_type.  Cc'd Jens
> for opinions on this.
>
> Can you try this out and see if it fixes the problem?  If it doesn't,
> we're going to have to get into debugging exactly what this zero length
> request is.
>
> Thanks,
>
> James
>
> ---
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9db097a..78229ec7 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1171,6 +1171,11 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>
>         cmd->transfersize = blk_rq_bytes(req);
>         cmd->allowed = req->retries;
> +       /*
> +        * Thanks to flush and other PC prepared commands, we may
> +        * not be a REQ_TYPE_BLOCK_PC; make sure we are
> +        */
> +       req->cmd_type = REQ_TYPE_BLOCK_PC;
>         return BLKPREP_OK;
>  }
>  EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
>
>
