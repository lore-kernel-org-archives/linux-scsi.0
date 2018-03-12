From: "Tobin C. Harding" <tobin@apporbit.com>
Subject: Re: [PATCH] scsi: eata: drop VLA in reorder()
Date: Mon, 12 Mar 2018 14:08:34 +1100
Message-ID: <20180312030834.GC8631@eros>
References: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernelnewbies@kernelnewbies.org
List-Id: linux-scsi@vger.kernel.org

Adding kernel newbies to CC because I pose a few noob questions :)
Adding Linus to CC because I quoted him.

On Sun, Mar 11, 2018 at 10:06:58PM +0100, Salvatore Mesoraca wrote:
> n_ready will always be less than or equal to MAX_MAILBOXES.
> So we avoid a VLA[1] and use fixed-length arrays instead.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  drivers/scsi/eata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 6501c33..202cd17 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -2096,7 +2096,7 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
>  	unsigned int k, n;
>  	unsigned int rev = 0, s = 1, r = 1;
>  	unsigned int input_only = 1, overlap = 0;
> -	unsigned long sl[n_ready], pl[n_ready], ll[n_ready];
> +	unsigned long sl[MAX_MAILBOXES], pl[MAX_MAILBOXES], ll[MAX_MAILBOXES];

I think we are going to see a recurring theme here.  MAX_MAILBOXES==64
so this patch adds 1536 bytes to the stack on a 64 bit machine or 768
bytes on a 32 bit machine.  Linus already commented on another VLA
removal patch that 768 was a lot of stack space.  That comment did,
however say 'deep in some transfer call chain'.  I don't know what a
'transfer call chain' (the transfer bit) is but is there some heuristic
we can use to know how deep is deep?  Or more to the point, is there some
heuristic we can use to know what is an acceptable amount of stack space
to use?

As far as this patch is concerned wouldn't a kmalloc (with GFP_ATOMIC)
be ok?  We are in an interrupt handler, can we assume that since IO has
just occurred that the IO will be so slow comparatively that a memory
allocation will be quick.  (assuming IO since eata.c only requests a
single irq line.)


thanks,
Tobin.
