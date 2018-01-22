From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: sg: assorted memory corruptions
Date: Mon, 22 Jan 2018 20:06:01 +0100
Message-ID: <CACT4Y+acm4hW05HCQTC03sEzY1oC4d4rOkfsYActEPmmnxyDRQ@mail.gmail.com>
References: <CACT4Y+b0pizvOAxtWQ-TGCRAYvHXdv79BAEaXh50W6vF8gBvkQ@mail.gmail.com>
 <1516638634.2545.0.camel@wdc.com> <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35117 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbeAVTGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 14:06:22 -0500
Received: by mail-pg0-f67.google.com with SMTP id o13so2667270pgs.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2018 11:06:22 -0800 (PST)
In-Reply-To: <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>

On Mon, Jan 22, 2018 at 7:57 PM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 2018-01-22 11:30 AM, Bart Van Assche wrote:
>>
>> On Mon, 2018-01-22 at 12:06 +0100, Dmitry Vyukov wrote:
>>>
>>> general protection fault: 0000 [#1] SMP KASAN
>>
>>
>> How about the untested patch below?
>>
>> Thanks,
>>
>> Bart.
>>
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index cd9b6ebd7257..04a644b39d79 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -627,6 +627,10 @@ sg_write(struct file *filp, const char __user *buf,
>> size_t count, loff_t * ppos)
>>         mutex_unlock(&sfp->f_mutex);
>>         SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
>>                 "sg_write:   scsi opcode=0x%02x, cmd_size=%d\n", (int)
>> opcode, cmd_size));
>> +       if (cmd_size > sizeof(cmnd)) {
>> +               sg_remove_request(sfp, srp);
>> +               return -EFAULT;
>> +       }
>>         /* Determine buffer size.  */
>>         input_size = count - cmd_size;
>>         mxsize = max(input_size, old_hdr.reply_len);
>>
>
> Using 'scsi_logging_level -s -T 5' on the sg driver and running the test
> program provided, the cmd_size is 9, just like the ioctl() in his program
> set it to. The sizeof(cmnd) is 252. So I don't know what caused the
> GPF but it wasn't cmd_size being out of bounds.
>
> As for the above patch, did you notice this check in that function:
>
>         if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof
> (cmnd))) {
>                 sg_remove_request(sfp, srp);
>                 return -EMSGSIZE;
>         }
>
> As far as I remember, Dmitry has not indicated in multiple reports
> over several years what /dev/sg0 is.

That's because I know nothing about sg. If you give a command to run,
I will provide it's output.

> Perhaps it misbehaves when it
> gets a SCSI command in the T10 range (i.e. not vendor specific) with
> a 9 byte cdb length. As far as I'm aware T10 (and the Ansi committee
> before it) have never defined a cdb with an odd length.
>
> For those that are not aware, the sg driver is a relatively thin
> shim over the block layer, the SCSI mid-level, and a low-level
> driver which may have another kernel driver stack underneath it
> (e.g. UAS (USB attached SCSI)). The previous report from syzkaller
> on the sg driver ("scsi: memory leak in sg_start_req") has resulted
> in one accepted patch on the block layer with probably more to
> come in the same area.
>
> Testing the patch Dmitry gave (with some added error checks which
> reported no problems) with the scsi_debug driver supplying /dev/sg0
> I have not seen any problems running that test program. Again
> there might be a very slow memory leak, but if there is I don't
> believe it is in the sg driver.

Did you run it in a loop? First runs pass just fine for me too.

> While it's not invalid from a testing perspective, throwing total
> nonsense at a pass-through mechanism, including absurd SCSI commands
> at best will test error paths, but only at a very shallow level.
> Setting up almost valid pass-through scenarios will test error
> paths at a deeper level. Then there are lots of valid pass-through
> scenarios that would be expected not to fail.

Agree. syzkaller can test very elaborate scenarios, but it needs help
for this (telling what are these "almost valid" inputs). Kernel has
hundreds of APIs, some of them are quite elaborate and require
expertise to use (and undocumented), we can't describe all of them.
Frequently after adding a proper description, syzkaller finds a dozen
or two of bugs in the subsystem.
