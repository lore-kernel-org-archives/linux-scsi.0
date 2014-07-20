From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH 2/2] block: support > 16 byte CDBs for SG_IO
Date: Sun, 20 Jul 2014 19:45:52 +0300
Message-ID: <53CBF240.1010807@gmail.com>
References: <1405851804-29096-1-git-send-email-hch@lst.de> <1405851804-29096-3-git-send-email-hch@lst.de> <53CBAC65.2040208@gmail.com> <20140720132725.GA7077@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140720132725.GA7077@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/20/2014 04:27 PM, Christoph Hellwig wrote:
> On Sun, Jul 20, 2014 at 02:47:49PM +0300, Boaz Harrosh wrote:
>>
>> So two things here:
>> - hdr->cmd_len is char so can be MAX of 255. I understand that 4 bytes alignment is a SCSI
>>   thing so you found no point of checking any max size?
> 
> I don't see any point to force the aligmnet - the devices need to reject
> garbage commands, and if for some reason we'd see future commands
> that are > 252 and < 255 we are prepared to handle them.
> 

I agree

>> - Why the zero alloc, if you are going to paste over it the exact same length. Now if like in scsi
>>   you need 4 bytes alignment and zero padding yes, but here you do not do this (and probably shouldn't).
>>   Hence why zero-alloc?
> 
> No good reason except that's what sg and bsg do.
> 

Ha sorry didn't look there. Looks redundant to me that's all

<>
>> Inside here: blk_fill_sghdr_rq() calls blk_verify_command() which does:
>> (Below cmd[] is the buffer copied from user)
>>
>> 	/* Anybody who can open the device can do a read-safe command */
>> 	if (test_bit(cmd[0], filter->read_ok))
>> 		return 0;
>>
>> 	/* Write-safe commands require a writable open */
>> 	if (test_bit(cmd[0], filter->write_ok) && has_write_perm)
>> 		return 0;
>>
>> Now I am not sure what type "Commands" you guys intend for these large commands
>> but if they are say SCSI-VARLEN this test will not work. Also a user might fool
>> the system with pretending to be "read" a device modifying command.
>>
>> I would pass len to this test function and only permit these above if command is
>> <= 16. Any "special" large command is root only.
> 
> Honestly that whole filter crap should never have been merged to start with,
> you'll just need proper CAP_SYS_RAWIO for variable length commands.
> 
> 

I agree. What I'm saying is - Are you sure that with current code as is we will not
pass on large commands without the proper CAP_SYS_RAWIO.

Should we not make sure and add:
	/* root can do any command. */
	if (capable(CAP_SYS_RAWIO))
		return 0;
+
+	if (cmnd_len > BLK_MAX_CDB)
+		return -EPERM;

Rrrr you are right. I finally get the filter code. Anything that is not "white-listed"
is rejected. OK sorry for the noise.

Reviewed-by: Boaz Harrosh <boaz@plexistor.com>

Thanks
Boaz
