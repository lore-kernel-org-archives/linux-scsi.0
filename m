From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND] megaraid:Fix for loop termination statment in the
 function process_fw_state_change_wq
Date: Mon, 4 Jan 2016 11:11:02 +0530
Message-ID: <25ea254d9eb153f31d92edd78da0d790@mail.gmail.com>
References: <1451630166-9323-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451630166-9323-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com, martin.petersen@oracle.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Friday, January 01, 2016 12:06 PM
> To: kashyap.desai@avagotech.com
> Cc: sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> JBottomley@odin.com; martin.petersen@oracle.com;
> megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH RESEND] megaraid:Fix for loop termination statment in
the
> function process_fw_state_change_wq
>
> This fixes the for loop terimation for the waiting period between the
first and
> second init to make the variable wait terminate at the value of 20
rather then 30
> in other to follow the comments about this for loop of waiting for about
20
> seconds rather then
> 30 in the function fw_state_change_wq between initializations.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 71b884d..22fd333 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3168,9 +3168,8 @@ process_fw_state_change_wq(struct work_struct
> *work)
>  					"state 2 starting...\n");
>
>  		/*waitting for about 20 second before start the second
init*/
> -		for (wait = 0; wait < 30; wait++) {
> +		for (wait = 0; wait < 20; wait++)
>  			msleep(1000);
> -		}
>
>  		if (megasas_transition_to_ready(instance, 1)) {
>  			printk(KERN_NOTICE "megaraid_sas:adapter not
> ready\n");

There should be 30 seconds delay here, comments needs to be rectified
here. I will take care of this in next patch set.
> --
> 2.1.4
