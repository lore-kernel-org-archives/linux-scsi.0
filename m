From: Wenwen Wang <wang6495@umn.edu>
Subject: Re: [PATCH] scsi: mpt3sas: fix a missing-check bug
Date: Wed, 9 May 2018 00:28:53 -0500
Message-ID: <CAAa=b7dx5kfBzD+CTxMsonRj8c5mA5QRAud8PmfZJ0fYxh_cYw@mail.gmail.com>
References: <1525501896-8235-1-git-send-email-wang6495@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525501896-8235-1-git-send-email-wang6495@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>, "open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello

Could you please review this patch? We need a confirmation because we
are working on an approaching deadline.

Thanks!
Wenwen

On Sat, May 5, 2018 at 1:31 AM, Wenwen Wang <wang6495@umn.edu> wrote:
> In _ctl_ioctl_main(), 'ioctl_header' is first copied from the userspace
> pointer 'arg'. 'ioctl_header.ioc_number' is then verified by
> _ctl_verify_adapter(). If the verification is failed, an error code -ENODEV
> is returned. Otherwise, the verification result, i.e., the MPT3SAS adapter
> that matches with the 'ioctl_header.ioc_number', is saved to 'ioc'. Later
> on, if the 'cmd' is MPT3COMMAND, the whole ioctl command struct is copied
> again from the userspace pointer 'arg' and saved to 'karg'. Then the
> function _ctl_do_mpt_command() is invoked to execute the command with the
> adapter 'ioc' and 'karg' as inputs.
>
> Given that the pointer 'arg' resides in userspace, a malicious userspace
> process can race to change the 'ioc_number' between the two copies, which
> will cause inconsistency issues, potentially security issues since an
> inconsistent adapter could be used with the command struct 'karg' as inputs
> of _ctl_do_mpt_command(). Moreover, the user can potentially provide a
> valid 'ioc_number' to pass the verification, and then modify it to an
> invalid 'ioc_number'. That means, an invalid 'ioc_number' can potentially
> bypass the verification check.
>
> To fix this issue, we need to recheck the 'ioc_number' copied after the
> second copy to make sure it is not changed since the first copy.
>
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index d3cb387..0c140c7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -2388,6 +2388,11 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
>                         break;
>                 }
>
> +               if (karg.hdr.ioc_number != ioctl_header.ioc_number) {
> +                       ret = -EINVAL;
> +                       break;
> +               }
> +
>                 if (_IOC_SIZE(cmd) == sizeof(struct mpt3_ioctl_command)) {
>                         uarg = arg;
>                         ret = _ctl_do_mpt_command(ioc, karg, &uarg->mf);
> --
> 2.7.4
>
