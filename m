From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi: sg: assorted memory corruptions
Date: Mon, 22 Jan 2018 13:57:49 -0500
Message-ID: <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
References: <CACT4Y+b0pizvOAxtWQ-TGCRAYvHXdv79BAEaXh50W6vF8gBvkQ@mail.gmail.com>
 <1516638634.2545.0.camel@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516638634.2545.0.camel@wdc.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dvyukov@google.com" <dvyukov@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>
Cc: "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On 2018-01-22 11:30 AM, Bart Van Assche wrote:
> On Mon, 2018-01-22 at 12:06 +0100, Dmitry Vyukov wrote:
>> general protection fault: 0000 [#1] SMP KASAN
> 
> How about the untested patch below?
> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index cd9b6ebd7257..04a644b39d79 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -627,6 +627,10 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
>   	mutex_unlock(&sfp->f_mutex);
>   	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
>   		"sg_write:   scsi opcode=0x%02x, cmd_size=%d\n", (int) opcode, cmd_size));
> +	if (cmd_size > sizeof(cmnd)) {
> +		sg_remove_request(sfp, srp);
> +		return -EFAULT;
> +	}
>   	/* Determine buffer size.  */
>   	input_size = count - cmd_size;
>   	mxsize = max(input_size, old_hdr.reply_len);
> 

Using 'scsi_logging_level -s -T 5' on the sg driver and running the test
program provided, the cmd_size is 9, just like the ioctl() in his program
set it to. The sizeof(cmnd) is 252. So I don't know what caused the
GPF but it wasn't cmd_size being out of bounds.

As for the above patch, did you notice this check in that function:

         if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof (cmnd))) {
                 sg_remove_request(sfp, srp);
                 return -EMSGSIZE;
         }

As far as I remember, Dmitry has not indicated in multiple reports
over several years what /dev/sg0 is. Perhaps it misbehaves when it
gets a SCSI command in the T10 range (i.e. not vendor specific) with
a 9 byte cdb length. As far as I'm aware T10 (and the Ansi committee
before it) have never defined a cdb with an odd length.

For those that are not aware, the sg driver is a relatively thin
shim over the block layer, the SCSI mid-level, and a low-level
driver which may have another kernel driver stack underneath it
(e.g. UAS (USB attached SCSI)). The previous report from syzkaller
on the sg driver ("scsi: memory leak in sg_start_req") has resulted
in one accepted patch on the block layer with probably more to
come in the same area.

Testing the patch Dmitry gave (with some added error checks which
reported no problems) with the scsi_debug driver supplying /dev/sg0
I have not seen any problems running that test program. Again
there might be a very slow memory leak, but if there is I don't
believe it is in the sg driver.


While it's not invalid from a testing perspective, throwing total
nonsense at a pass-through mechanism, including absurd SCSI commands
at best will test error paths, but only at a very shallow level.
Setting up almost valid pass-through scenarios will test error
paths at a deeper level. Then there are lots of valid pass-through
scenarios that would be expected not to fail.

Doug Gilbert
