From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH] [SCSI] aacraid: use kmemdup
Date: Thu, 19 May 2016 18:25:06 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A16358BC9@avsrvexchmbx2.microsemi.net>
References: <1463666915-16906-1-git-send-email-falakreyaz@gmail.com>
 <1463666915-16906-3-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463666915-16906-3-git-send-email-falakreyaz@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Muhammad Falak R Wani <falakreyaz@gmail.com>, Hannes Reinecke <hare@suse.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Muhammad Falak R Wani
> Sent: Thursday, May 19, 2016 7:09 AM
> To: Hannes Reinecke
> Cc: Adaptec OEM Raid Solutions; James E.J. Bottomley; Martin K. Petersen;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] [SCSI] aacraid: use kmemdup
> 
> EXTERNAL EMAIL
> 
> 
> Use kmemdup when some other buffer is immediately copied into allocated
> region. It replaces call to allocation followed by memcpy, by a single
> call to kmemdup.
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  drivers/scsi/aacraid/commctrl.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> index 4b3bb52..b381b37 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -635,15 +635,14 @@ static int aac_send_raw_srb(struct aac_dev* dev,
> void __user * arg)
>                         }
>                 } else {
>                         struct user_sgmap* usg;
> -                       usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
> -                         + sizeof(struct sgmap), GFP_KERNEL);
> +                       usg = kmemdup(upsg,
> +                                     actual_fibsize - sizeof(struct aac_srb)
> +                                     + sizeof(struct sgmap), GFP_KERNEL);
>                         if (!usg) {
>                                 dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB
> command\n"));
>                                 rcode = -ENOMEM;
>                                 goto cleanup;
>                         }
> -                       memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
> -                         + sizeof(struct sgmap));
>                         actual_fibsize = actual_fibsize64;
> 
>                         for (i = 0; i < usg->count; i++) {

Reviewed-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
