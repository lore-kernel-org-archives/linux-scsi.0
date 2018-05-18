From: Wenwen Wang <wang6495@umn.edu>
Subject: Re: [PATCH] scsi: sg: fix a missing-check bug
Date: Fri, 18 May 2018 16:48:46 -0500
Message-ID: <CAAa=b7efo0jVRq56wQDVq-UQ4ynh+oxRNuKO+HDmuJkzWCYf_A@mail.gmail.com>
References: <1525576895-15708-1-git-send-email-wang6495@umn.edu> <be344261-9110-ed6f-6916-04e5a2e5fc7e@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <be344261-9110-ed6f-6916-04e5a2e5fc7e@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Kangjie Lu <kjlu@umn.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SG DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Wenwen Wang <wang6495@umn.edu>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 7, 2018 at 12:13 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 2018-05-05 11:21 PM, Wenwen Wang wrote:
>>
>> In sg_write(), the opcode of the command is firstly copied from the
>> userspace pointer 'buf' and saved to the kernel variable 'opcode', using
>> the __get_user() function. The size of the command, i.e., 'cmd_size' is
>> then calculated based on the 'opcode'. After that, the whole command,
>> including the opcode, is copied again from 'buf' using the
>> __copy_from_user() function and saved to 'cmnd'. Finally, the function
>>   sg_common_write() is invoked to process 'cmnd'. Given that the 'buf'
>> pointer resides in userspace, a malicious userspace process can race to
>> change the opcode of the command between the two copies. That means, the
>> opcode indicated by the variable 'opcode' could be different from the
>> opcode in 'cmnd'. This can cause inconsistent data in 'cmnd' and
>> potential logical errors in the function sg_common_write(), as it needs to
>> work on 'cmnd'.
>>
>> This patch reuses the opcode obtained in the first copy and only copies
>> the
>> remaining part of the command from userspace.
>>
>> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
>> ---
>>   drivers/scsi/sg.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index c198b963..0ad8106 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -657,7 +657,8 @@ sg_write(struct file *filp, const char __user *buf,
>> size_t count, loff_t * ppos)
>>         hp->flags = input_size; /* structure abuse ... */
>>         hp->pack_id = old_hdr.pack_id;
>>         hp->usr_ptr = NULL;
>> -       if (__copy_from_user(cmnd, buf, cmd_size))
>> +       cmnd[0] = opcode;
>> +       if (__copy_from_user(cmnd + 1, buf + 1, cmd_size - 1))
>>                 return -EFAULT;
>>         /*
>>          * SG_DXFER_TO_FROM_DEV is functionally equivalent to
>> SG_DXFER_FROM_DEV,
>>
>
> That is in the deprecated "v2" part of the sg driver (for around 15 years).
> There are lots more interesting races with that interface than that one
> described above. My guess is that all system calls would be susceptible
> to playing around with a buffer being passed to or from the OS by a thread
> other than the one doing the system call, during that call. Surely no Unix
> like OS gives any security guarantees to a thread being attacked by a
> malevolent thread in the same process!
>
> My question is did this actually cause to program to fail; or is it
> something
> that a sanity checker flagged?

This is detected by a static analysis tool. But, based on our manual
investigation, it can cause program failure. So it is better to fix
it.

>
> Also wouldn't it be better just to return an error such as EINVAL if
> opcode != command[0]  ?

I can revise this patch to return EINVAL if the opcode is not as
expected, and resubmit it.

Thanks!

Wenwen
