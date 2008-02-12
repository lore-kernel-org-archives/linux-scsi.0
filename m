From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] scsi: varlen extended and vendor-specific cdbs
Date: Tue, 12 Feb 2008 20:17:42 +0200
Message-ID: <47B1E2C6.4010305@panasas.com>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com> <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com> <47AF4974.9010200@panasas.com> <47AF4C82.2090103@panasas.com> <20080212175137.GC26316@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080212175137.GC26316@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 12 2008 at 19:51 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Feb 10, 2008 at 09:12:02PM +0200, Boaz Harrosh wrote:
>> @@ -525,6 +516,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>>  	unsigned long flags = 0;
>>  	unsigned long timeout;
>>  	int rtn = 0;
>> +	unsigned cmd_len;
>>  
>>  	/* check if the device is still usable */
>>  	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
>> @@ -606,9 +598,17 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>>  	 * Before we queue this command, check if the command
>>  	 * length exceeds what the host adapter can handle.
>>  	 */
>> -	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
>> +	cmd_len = cmd->cmd_len;
>> +	if (!cmd_len) {
>> +		BUG_ON(cmd->cmnd[0] == VARIABLE_LENGTH_CMD);
>> +		cmd_len = COMMAND_SIZE((cmd)->cmnd[0]);
>> +	}
> 
> This looks odd to me.  Shouldn't we make sure cmd_len is always
> initialized in a single place for either varlen or fixed length
> commands and not have things like this?
> 
I used to have a BUG_ON(!cmd_len) here at around the 2.6.20 kernels
And it would trigger. I'm not sure exactly how. Through a retransmit
or something.

Reinspecting all command submission paths, I agree with you that it
should not happen anymore. I will look at it some more and run tests.

Perhaps if this code will sit in -mm tree for a while I can put the
BUG_ON back and see if it triggers again. What do you recommend?

Boaz

