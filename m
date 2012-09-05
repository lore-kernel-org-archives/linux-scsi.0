From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [Ping^3] Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Wed, 05 Sep 2012 16:41:04 +0200
Message-ID: <50476480.9010302@redhat.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <50195108.1090105@redhat.com> <503CA5BA.2040003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <503CA5BA.2040003@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 28/08/2012 13:04, Paolo Bonzini ha scritto:
> Il 01/08/2012 17:53, Paolo Bonzini ha scritto:
>> Il 20/07/2012 18:30, Paolo Bonzini ha scritto:
>>> These commands cannot be issued right now without giving CAP_SYS_RAWIO to
>>> the process who wishes to send them.  These commands can be useful also to
>>> non-privileged programs who have access to the block devices.  For example
>>> a virtual machine monitor needs them to forward trim/discard to host disks.
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  block/scsi_ioctl.c |    3 ++
>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
>>> index 260fa80..dd71f18 100644
>>> --- a/block/scsi_ioctl.c
>>> +++ b/block/scsi_ioctl.c
>>> @@ -168,13 +168,16 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
>>>  	/* Basic writing commands */
>>>  	__set_bit(WRITE_6, filter->write_ok);
>>>  	__set_bit(WRITE_10, filter->write_ok);
>>> +	__set_bit(WRITE_SAME, filter->write_ok);
>>>  	__set_bit(WRITE_VERIFY, filter->write_ok);
>>>  	__set_bit(WRITE_12, filter->write_ok);
>>>  	__set_bit(WRITE_VERIFY_12, filter->write_ok);
>>>  	__set_bit(WRITE_16, filter->write_ok);
>>> +	__set_bit(WRITE_SAME_16, filter->write_ok);
>>>  	__set_bit(WRITE_LONG, filter->write_ok);
>>>  	__set_bit(WRITE_LONG_2, filter->write_ok);
>>>  	__set_bit(ERASE, filter->write_ok);
>>> +	__set_bit(UNMAP, filter->write_ok);
>>>  	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
>>>  	__set_bit(MODE_SELECT, filter->write_ok);
>>>  	__set_bit(LOG_SELECT, filter->write_ok);
>>>
>>
>> Jens,
>>
>> can this go in 3.6 as well?
> 
> Another ping...

Ping & adding some more folks hoping to get a Reviewed-by or to be
screamed at.

Paolo
