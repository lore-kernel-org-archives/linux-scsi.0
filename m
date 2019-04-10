From: Erwan Velu <erwanaliasr1@gmail.com>
Subject: Re: [PATCH] scsi: smartpqi: Reporting unhandled SCSI errors
Date: Wed, 10 Apr 2019 13:02:51 +0200
Message-ID: <CAL2JzuyHb_gfu5Suf3yaMF1883JN1667yhEwpdmoiqYrUTO2YA@mail.gmail.com>
References: <20190321094928.4198-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321094928.4198-1-e.velu@criteo.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Erwan Velu <e.velu@criteo.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <esc.storagedev@microsemi.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi there !
Any reactions to this one ? I didn't got a single comment.
Cheers,
Erwan,

Le jeu. 21 mars 2019 =C3=A0 10:49, Erwan Velu <erwanaliasr1@gmail.com> a =
=C3=A9crit :
>
> When a HARDWARE_ERROR is triggered for asc=3D0x3e, the actual code is onl=
y considering the case where ascq=3D0x1.
>
> Following the http://www.t10.org/lists/asc-num.htm#ASC_3E specification, =
other values may occur like a timeout (ascq=3D0x2).
>
> This patch is about printing an error message when a non-handled message =
is received.
> This could help diagnose a possible miss-behavior of the controller and/o=
r a missing implementation in the Linux Kernel.
>
> This patch keeps the exact same error handling but prints a message if an=
 ascq !=3D 1 income.
>
> Signed-off-by: Erwan Velu <e.velu@criteo.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 75ec43aa8df3..baf16c138800 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -2762,16 +2762,25 @@ static void pqi_process_raid_io_error(struct pqi_=
io_request *io_request)
>                         scsi_normalize_sense(error_info->data,
>                                 sense_data_length, &sshdr) &&
>                                 sshdr.sense_key =3D=3D HARDWARE_ERROR &&
> -                               sshdr.asc =3D=3D 0x3e &&
> -                               sshdr.ascq =3D=3D 0x1) {
> +                               sshdr.asc =3D=3D 0x3e) {
>                         struct pqi_ctrl_info *ctrl_info =3D shost_to_hba(=
scmd->device->host);
>                         struct pqi_scsi_dev *device =3D scmd->device->hos=
tdata;
>
> -                       if (printk_ratelimit())
> -                               scmd_printk(KERN_ERR, scmd, "received 'lo=
gical unit failure' from controller for scsi %d:%d:%d:%d\n",
> -                                       ctrl_info->scsi_host->host_no, de=
vice->bus, device->target, device->lun);
> -                       pqi_take_device_offline(scmd->device, "RAID");
> -                       host_byte =3D DID_NO_CONNECT;
> +                       switch (sshdr.ascq) {
> +                       case 0x1: /*LOGICAL UNIT FAILURE */
> +                               if (printk_ratelimit())
> +                                       scmd_printk(KERN_ERR, scmd, "rece=
ived 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",
> +                                               ctrl_info->scsi_host->hos=
t_no, device->bus, device->target, device->lun);
> +                               pqi_take_device_offline(scmd->device, "RA=
ID");
> +                               host_byte =3D DID_NO_CONNECT;
> +                               break;
> +
> +                       default: /* See http://www.t10.org/lists/asc-num.=
htm#ASC_3E */
> +                               if (printk_ratelimit())
> +                                       scmd_printk(KERN_ERR, scmd, "rece=
ived unhandled error %d from controller for scsi %d:%d:%d:%d\n",
> +                                               sshdr.ascq, ctrl_info->sc=
si_host->host_no, device->bus, device->target, device->lun);
> +                               break;
> +                       }
>                 }
>
>                 if (sense_data_length > SCSI_SENSE_BUFFERSIZE)
> --
> 2.20.1
>
