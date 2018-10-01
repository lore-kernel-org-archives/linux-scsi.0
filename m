From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH RESEND] scsi: sg: Prevent potential double frees in sg
 driver
Date: Tue, 2 Oct 2018 09:34:33 +1000
Message-ID: <ef53fcb4-9001-c06b-779f-d40949224c98@interlog.com>
References: <20181001161506.100284-1-evgreen@chromium.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001161506.100284-1-evgreen@chromium.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Nick Desaulniers <ndesaulniers@google.com>, Christoph Hellwig <hch@infradead.org>, Robb Glasser <rglasser@google.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-10-02 02:15 AM, Evan Green wrote:
> From: Robb Glasser <rglasser@google.com>
> 
> sg_ioctl could be spammed by requests, leading to a double free in
> __free_pages. This protects the entry points of sg_ioctl where the
> memory could be corrupted by a double call to __free_pages if multiple
> requests are happening concurrently.

Hi,
I  don't like this patch. I would like to see the trace for the double
call to the __free_pages you are referring too. A test program that
show the fault, perhaps?

I have test code to "spam" the sg driver and have not seen a double
__free_pages that you refer to (see sg3_utils package version 1.44,
testing/sg_tst_async.cpp).

Currently I am dusting off 20 years of "laparoscopic" patches to the sg
driver that have made a bit of a mess of the naming and comments. Also
the 16 outstanding requests per file descriptor limit is being removed.
Then I want to add the SG_IOSUBMIT and SG_IORECEIVE ioctls proposed by
Linus Torvalds two week ago.

Executive summary: nak, without further information

Doug Gilbert

> Signed-off-by: Robb Glasser <rglasser@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Evan Green <evgreen@chromium.org>
> Cc: stable@vger.kernel.org
> 
> ---
> Reposting this patch from last summer, as it looks like it fell in between
> the cracks.
> 
>   drivers/scsi/sg.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 8a254bb46a9b..25579d8a16b5 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -924,8 +924,10 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>   			return -ENXIO;
>   		if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR))
>   			return -EFAULT;
> +		mutex_lock(&sfp->parentdp->open_rel_lock);
>   		result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
>   				 1, read_only, 1, &srp);
> +		mutex_unlock(&sfp->parentdp->open_rel_lock);
>   		if (result < 0)
>   			return result;
>   		result = wait_event_interruptible(sfp->read_wait,
> 
