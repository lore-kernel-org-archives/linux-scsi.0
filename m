From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix a missing-check bug
Date: Tue, 16 Oct 2018 17:26:54 +0530
Message-ID: <CAL2rwxqeeJgSz=DePWZvh8sr15MJK8Gqta7EbfjwAUMUcvvMJA@mail.gmail.com>
References: <1538850861-26882-1-git-send-email-wang6495@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1538850861-26882-1-git-send-email-wang6495@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: wang6495@umn.edu
Cc: kjlu@umn.edu, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 7, 2018 at 12:04 AM Wenwen Wang <wang6495@umn.edu> wrote:
>
> In megasas_mgmt_compat_ioctl_fw(), to handle the structure
> compat_megasas_iocpacket 'cioc', a user-space structure megasas_iocpacket
> 'ioc' is allocated before megasas_mgmt_ioctl_fw() is invoked to handle the
> packet. Since the two data structures have different fields, the data is
> copied from 'cioc' to 'ioc' field by field. In the copy process,
> 'sense_ptr' is prepared if the field 'sense_len' is not null, because it
> will be used in megasas_mgmt_ioctl_fw(). To prepare 'sense_ptr', the
> user-space data 'ioc->sense_off' and 'cioc->sense_off' are copied and saved
> to kernel-space variables 'local_sense_off' and 'user_sense_off'
> respectively. Given that 'ioc->sense_off' is also copied from
> 'cioc->sense_off', 'local_sense_off' and 'user_sense_off' should have the
> same value. However, 'cioc' is in the user space and a malicious user can
> race to change the value of 'cioc->sense_off' after it is copied to
> 'ioc->sense_off' but before it is copied to 'user_sense_off'. By doing so,
> the attacker can inject different values into 'local_sense_off' and
> 'user_sense_off'. This can cause undefined behavior in the following
> execution, because the two variables are supposed to be same.
>
> This patch enforces a check on the two kernel variables 'local_sense_off'
> and 'user_sense_off' to make sure they are the same after the copy. In case
> they are not, an error code EINVAL will be returned.
>
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 9aa9590..f6de752 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -7523,6 +7523,9 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
>                 get_user(user_sense_off, &cioc->sense_off))
>                 return -EFAULT;
>
> +       if (local_sense_off != user_sense_off)
> +               return -EINVAL;
> +
>         if (local_sense_len) {
>                 void __user **sense_ioc_ptr =
>                         (void __user **)((u8 *)((unsigned long)&ioc->frame.raw) + local_sense_off);

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> --
> 2.7.4
>
