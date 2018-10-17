From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [v5 2/4] mpt3sas: Fix Sync cache command failure during driver unload
Date: Wed, 17 Oct 2018 11:32:18 +0300
Message-ID: <CAHp75Ve=X9X6xG5FpuZrmRKfSpcLwFQYE_A8vhUzNn92KSoc4w@mail.gmail.com>
References: <1539755947-27014-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1539755947-27014-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539755947-27014-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Lukas Wunner <lukas@wunner.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 8:59 AM Suganath Prabu
<suganath-prabu.subramani@broadcom.com> wrote:
>
> This is to fix Sync cache and start stop command
>  failures with DID_NO_CONNECT during driver unload.
>
> 1) Release drives first from SML, then remove internally
> in driver.
> 2) And allow sync cache and Start stop commands to firmware,
> even when remove_host flag is set.

> +       if (ioc->hba_mpi_version_belonged == MPI2_VERSION) {
> +               if (ioc->remove_host)
> +                       return false;
> +
> +               return true;
> +       }
> +
> +       if (ioc->remove_host) {
> +
> +               switch (scmd->cmnd[0]) {
> +               case SYNCHRONIZE_CACHE:
> +               case START_STOP:
> +                       return true;
> +               default:
> +                       return false;
> +               }
> +       }
> +
> +       return true;

Wouldn't be the same as

if (!ioc->remove_host || ioc->hba_mpi_version_belonged == MPI2_VERSION)
   return !ioc->remove_host;

 switch (scmd->cmnd[0]) {
 case SYNCHRONIZE_CACHE:
 case START_STOP:
   return true;
 default:
   return false;
 }

?

-- 
With Best Regards,
Andy Shevchenko
