From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: Fix a double-fetch bug in drivers/scsi/sg.c
Date: Wed, 5 Jun 2019 13:07:25 -0400
Message-ID: <da6f10b8-3b9a-f8d6-33c4-0d8f5711bb23@interlog.com>
References: <20190523023855.GA17852@zhanggen-UX430UQ>
 <d7cb94f3-f136-62ff-3067-b3e5f6ac63ce@suse.cz>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d7cb94f3-f136-62ff-3067-b3e5f6ac63ce@suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, Gen Zhang <blackgod016574@gmail.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2019-06-05 2:00 a.m., Jiri Slaby wrote:
> On 23. 05. 19, 4:38, Gen Zhang wrote:
>> In sg_write(), the opcode of the command is fetched the first time from
>> the userspace by __get_user(). Then the whole command, the opcode
>> included, is fetched again from userspace by __copy_from_user().
>> However, a malicious user can change the opcode between the two fetches.
>> This can cause inconsistent data and potential errors as cmnd is used in
>> the following codes.
>>
>> Thus we should check opcode between the two fetches to prevent this.
>>
>> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
>> ---
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index d3f1531..a2971b8 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -694,6 +694,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
>>   	hp->flags = input_size;	/* structure abuse ... */
>>   	hp->pack_id = old_hdr.pack_id;
>>   	hp->usr_ptr = NULL;
>> +	if (opcode != cmnd[0])
>> +		return -EINVAL;
> 
> Isn't it too early to check cmnd which is copied only here:
> 
>>   	if (__copy_from_user(cmnd, buf, cmd_size))
>>   		return -EFAULT;
>>   	/*
>> ---
>>

Hi,
Yes, it is too early. It needs to be after that __copy_from_user(cmnd,
buf, cmd_size) call.

To put this in context, this is a very old interface; dating from 1992
and deprecated for almost 20 years. The fact that the first byte of
the SCSI cdb needs to be read first to work out that size of the
following SCSI command and optionally the offset of a data-out
buffer that may follow the command; is one reason why that interface
was replaced. Also the implementation did not handle SCSI variable
length cdb_s.

Then there is the question of whether this double-fetch is exploitable?
I cannot think of an example, but there might be (e.g. turning a READ
command into a WRITE). But the "double-fetch" issue may be more wide
spread. The replacement interface passes the command and data-in/-out as
pointers while their corresponding lengths are placed in the newer
interface structure. This assumes that the cdb and data-out won't
change in the user space between when the write(2) is called and
before or while the driver, using those pointers, reads the data.
All drivers that use pointers to pass data have this "feature".

Also I'm looking at this particular double-fetch from the point of view
of the driver rewrite I have done and is currently in the early stages
of review [linux-scsi list: "[PATCH 00/19] sg: v4 interface, rq sharing
+ multiple rqs"] and this problem is more difficult to fix since the
full cdb read is delayed to a common point further along the submit
processing path. To detect a change in cbd[0] my current code would
need to be altered to carry cdb[0] through to that common point. So
is it worth it for such an old, deprecated and replaced interface??
What cdb/user_permissions checking that is done, is done _after_
the full cdb is read. So trying to get around a user exclusion of
say WRITE(10) by first using the first byte of READ(10), won't succeed.

Doug Gilbert
