From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [v5 1/4] mpt3sas: Separate out mpt3sas_wait_for_ioc_to_operational
Date: Wed, 17 Oct 2018 11:17:41 +0300
Message-ID: <CAHp75Veh=CkhD67jb+Qjps-UqtcCBUsA8bWco6kqppm0Q+tcvg@mail.gmail.com>
References: <1539755947-27014-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1539755947-27014-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539755947-27014-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Lukas Wunner <lukas@wunner.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 8:59 AM Suganath Prabu
<suganath-prabu.subramani@broadcom.com> wrote:
>
> No functional changes. This section of code
>  "wait for IOC to be operational" is used in many places
>  across the driver, and hence moved this code in to
>  a function "mpt3sas_wait_for_ioc_to_operational()"

> +       ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
> +       while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
> +

Do we need this blank line?

> +               if (wait_state_count++ == timeout) {
> +                       ioc_err(ioc, "%s: failed due to ioc not operational\n",
> +                               __func__);
> +                       return -EFAULT;
> +               }
> +               ssleep(1);
> +               ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
> +               ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
> +                        __func__, wait_state_count);
> +       }

I understand this is part of existing code, but can you consider to
modify it to something like

do {
    ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
    if (ioc_state == MPI2_IOC_STATE_OPERATIONAL)
      break;
    ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
__func__, ++wait_state_count);
while (timeout--);
if (!timeout) {
    ioc_err(ioc, "%s: failed due to ioc not operational\n", __func__);
    return -EFAULT;
}
Less lines, more understandable in my view.

> +       rc = mpt3sas_wait_for_ioc_to_operational(ioc,
> +                                       IOC_OPERATIONAL_WAIT_COUNT);

This can be one line (yes, I aware that is 82 characters, but it
improves readability from my p.o.v.).

> +       rc = mpt3sas_wait_for_ioc_to_operational(ioc,
> +                                       IOC_OPERATIONAL_WAIT_COUNT);

Ditto.

>         u16 smid;
> -       u32 ioc_state;
>         Mpi2ConfigRequest_t *config_request;
>         int r;
>         u8 retry_count, issue_host_reset = 0;
> -       u16 wait_state_count;
> +

Usually we don't split definition block.

>         struct config_request mem;
>         u32 ioc_status = UINT_MAX;

> +       ret = mpt3sas_wait_for_ioc_to_operational(ioc,
> +                                       IOC_OPERATIONAL_WAIT_COUNT);

One line?

> +       rc = mpt3sas_wait_for_ioc_to_operational(ioc,
> +                                       IOC_OPERATIONAL_WAIT_COUNT);

Ditto.

> +       rc = mpt3sas_wait_for_ioc_to_operational(ioc,
> +                                       IOC_OPERATIONAL_WAIT_COUNT);

Ditto.

> +       rc = mpt3sas_wait_for_ioc_to_operational(ioc,
> +                                       IOC_OPERATIONAL_WAIT_COUNT);

Ditto.

-- 
With Best Regards,
Andy Shevchenko
