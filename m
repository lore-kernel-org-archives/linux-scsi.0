From: David Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: prevent out-of-bounds access due to changing
 fip header sizes
Date: Thu, 4 Aug 2016 16:38:30 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A15FA5D6A@avsrvexchmbx1.microsemi.net>
References: <1470299764-96617-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470299764-96617-1-git-send-email-jthumshirn@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Pengfei Wang <wpengfeinudt@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Johannes Thumshirn
> Sent: Thursday, August 04, 2016 2:36 AM
> To: Martin K . Petersen; James Bottomley
> Cc: Linux SCSI Mailinglist; Pengfei Wang; Johannes Thumshirn;
> stable@vger.kernel.org
> Subject: [PATCH] aacraid: prevent out-of-bounds access due to changing fip
> header sizes
> 
> EXTERNAL EMAIL
> 
> 
> In aacraid's ioctl_send_fib() we do two fetches from userspace, one the get the
> fib header's size and one for the fib itself. Later we use the size field from the
> second fetch to further process the fib. If for some reason the size from the
> second fetch is different than from the first fix, we may encounter an out-of-
> bounds access in aac_fib_send(). This was reported in
> https://bugzilla.kernel.org/show_bug.cgi?id=116751 and was assigned CVE-
> 2016-6480.
> 
> Reported-by: Pengfei Wang <wpengfeinudt@gmail.com>
> Fixes: 7c00ffa31 '[SCSI] 2.6 aacraid: Variable FIB size (updated patch)'
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/aacraid/commctrl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> index 4b3bb52..2d4acd1 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -118,6 +118,12 @@ static int ioctl_send_fib(struct aac_dev * dev, void
> __user *arg)
>                 goto cleanup;
>         }
> 
> +       if (size != le16_to_cpu(kfib->header.Size)
> +                       + sizeof(struct aac_fibhdr)) {
> +               retval = -EINVAL;
> +               goto cleanup;
> +       }
> +
>         if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
>                 aac_adapter_interrupt(dev);
>                 /*
> --
> 1.8.5.6
> 

NAK, size is the MAX((header.size+hdr), sender_size). I will send a patch tomorrow which will insure that neither of those values is larger than size on the second fetch.

Thanks, -Dave
