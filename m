From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: A bug in scsi_alloc_target of drivers/scsi/scsi_scan.c
Date: Tue, 16 May 2017 19:56:03 +0200
Message-ID: <20170516175603.GB14268@bblock-ThinkPad-W530>
References: <23B7B563BA4E9446B962B142C86EF24A02D029C9@CNMAILEX03.lenovo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23B7B563BA4E9446B962B142C86EF24A02D029C9@CNMAILEX03.lenovo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dashi DS1 Cao <caods1@lenovo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Dashi,

On Tue, May 09, 2017 at 09:08:14AM +0000, Dashi DS1 Cao wrote:
> When debugging a race condition in scsi_remove_target of 3.12, I ran into this possible bug within scsi_alloc_target.
> When an existing "struct scsi_target" is found and used, the starget just got through kzmalloc should be freed, rather than dong a "put_device(dev)".

But that is exactly what is done when put_device is called and the
internal ref-count drops below 1. It will go through the kobj-core and
end up in scsi_target_dev_release().

Also this specific code was changed in 12fb8c1574d7d in 2010, see the
commit message there.

                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 81d4151..96795d4 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -483,7 +483,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
> 
>         spin_unlock_irqrestore(shost->host_lock, flags);
>         if (ref_got) {
> -               put_device(dev);
> +               kfree(starget);
>                 return found_target;
>         }
>         /*
> --
> 
> Dashi Cao
> 
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
