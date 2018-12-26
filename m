From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: avoid a double-fetch and a redundant copy
Date: Wed, 26 Dec 2018 01:49:10 -0500
Message-ID: <e68496e2-248b-e7ec-9bc2-597446c5b495@interlog.com>
References: <20181225201554.69395-1-kjlu@umn.edu>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181225201554.69395-1-kjlu@umn.edu>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-12-25 3:15 p.m., Kangjie Lu wrote:
> What we need is only "pack_id", so do not create a heap object or copy
> the whole object in. The fix efficiently copies "pack_id" only.

Now this looks like a worthwhile optimization, in some pretty tricky
code. I can't see a security angle in it. Did you test it?

Well the code as presented doesn't compile and the management takes a
dim view of that.

> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>   drivers/scsi/sg.c | 12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index c6ad00703c5b..4dacbfffd113 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -446,16 +446,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   		}
>   		if (old_hdr->reply_len < 0) {
>   			if (count >= SZ_SG_IO_HDR) {
> -				sg_io_hdr_t *new_hdr;
> -				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
> -				if (!new_hdr) {
> -					retval = -ENOMEM;
> -					goto free_old_hdr;
> -				}
> -				retval =__copy_from_user
> -				    (new_hdr, buf, SZ_SG_IO_HDR);
> -				req_pack_id = new_hdr->pack_id;
> -				kfree(new_hdr);
> +				retval = get_user(req_pack_id,
> +						&((sg_io_hdr_t *)buf->pack_id));

The '->' binds higher then the cast and since buf is a 'char *' it doesn't
have a member called pack_id .

Hopefully your drive to remove redundancy went a little too far and removed
the required (but missing) parentheses binding the cast to 'buf'.

>   				if (retval) {
>   					retval = -EFAULT;
>   					goto free_old_hdr;
> 

Good work, silly mistake, but its got me thinking, the heap allocation can be
replaced by stack since its short. The code in this area is more tricky in
the v4 driver because I want to specifically exclude the sg_io_v4 (aka v4)
interface being sent through write(2)/read(2). The way to do that is to read
the first 32 bit integer which should be 'S' or v3, 'Q' for v4.


Hmm, just looking further along my mailer I see the kbuild test robot
has picked up the error and you have presented another patch which also
won't compile. Please stop doing that; apply your patch to kernel source
and compile it _before_ sending it to this list.

Doug Gilbert
