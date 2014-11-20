From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 20 Nov 2014 18:44:32 +0100
Message-ID: <546E2880.5070303@laposte.net>
References: <20141120060933.GA21432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141120060933.GA21432@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Christoph,

I tested your patch, it works, the bug is gone with your patch, it's a
good news,

I notice that my motherboard doesn't support "AHCI" mode, my motherboar=
d
uses an ICH7 sata controler, ICH7 doesn't support AHCI if I check the
technical specifications of this controler,

it seems that my bios treats SATA devices like IDE devices ( IDE
emulation mode ), for example I can read in the bios these lines "IDE 0
channel master : "the name of Sata harddisk 1", "IDE 3 channel master :
"the name of Sata harddisk 2",

perhaps the bug only occurs when the AHCI mode is not used ?

because on archlinux forums another user has noticed that this bug only
occurs if he enables the "IDE emulation" option in the bios of his
motherboard ( a recent gigabyte motherboard : Z68P-DS3 intel for i7 CPU
), and if he chooses the "AHCI mode" instead of the "IDE emulation mode=
"
in his bios settings then the bug disappears, no random hangs at boot
when AHCI is enabled,

and this user has also a SATA DVD burner,

so perhaps you can reproduce this bug on your PC if you have the same
option enabled in the bios ( IDE emulation mode ) and a Sata DVD burner=
,
in this case you will have 20~30% of chance to trigger the bug (  rando=
m
hangs will occur approximately every 5~10 boots )


Le 20/11/2014 07:09, Christoph Hellwig a =E9crit :
> I
>=20
> Hi Barto,
>=20
> sorry for the late reply, and thanks for drilling down the exact
> conditions.
>=20
> I think we have some issues with the lack of the host lock vs error
> handling, but I still don't undertand the details.
>=20
> I've got a test patch for you that just adds the host lock back in a =
few
> places while keeing the atomic_t.  Can you try to reproduce with that
> one?
>=20
> When breaking an existing setup in software it's always the softwares
> fault, btw..
>=20
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 994eb08..99b77f7 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -311,16 +311,16 @@ void scsi_device_unbusy(struct scsi_device *sde=
v)
>  	struct scsi_target *starget =3D scsi_target(sdev);
>  	unsigned long flags;
> =20
> +	spin_lock_irqsave(shost->host_lock, flags);
>  	atomic_dec(&shost->host_busy);
>  	if (starget->can_queue > 0)
>  		atomic_dec(&starget->target_busy);
> =20
>  	if (unlikely(scsi_host_in_recovery(shost) &&
>  		     (shost->host_failed || shost->host_eh_scheduled))) {
> -		spin_lock_irqsave(shost->host_lock, flags);
>  		scsi_eh_wakeup(shost);
> -		spin_unlock_irqrestore(shost->host_lock, flags);
>  	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> =20
>  	atomic_dec(&sdev->device_busy);
>  }
> @@ -1504,6 +1504,8 @@ static inline int scsi_host_queue_ready(struct =
request_queue *q,
>  	if (scsi_host_in_recovery(shost))
>  		return 0;
> =20
> +	spin_lock_irq(shost->host_lock);
> +
>  	busy =3D atomic_inc_return(&shost->host_busy) - 1;
>  	if (atomic_read(&shost->host_blocked) > 0) {
>  		if (busy)
> @@ -1527,21 +1529,19 @@ static inline int scsi_host_queue_ready(struc=
t request_queue *q,
> =20
>  	/* We're OK to process the command, so we can't be starved */
>  	if (!list_empty(&sdev->starved_entry)) {
> -		spin_lock_irq(shost->host_lock);
>  		if (!list_empty(&sdev->starved_entry))
>  			list_del_init(&sdev->starved_entry);
> -		spin_unlock_irq(shost->host_lock);
>  	}
> =20
> +	spin_unlock_irq(shost->host_lock);
>  	return 1;
> =20
>  starved:
> -	spin_lock_irq(shost->host_lock);
>  	if (list_empty(&sdev->starved_entry))
>  		list_add_tail(&sdev->starved_entry, &shost->starved_list);
> -	spin_unlock_irq(shost->host_lock);
>  out_dec:
>  	atomic_dec(&shost->host_busy);
> +	spin_unlock_irq(shost->host_lock);
>  	return 0;
>  }
> =20
>=20
