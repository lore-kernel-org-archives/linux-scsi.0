From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [v5 1/4] mpt3sas: Separate out mpt3sas_wait_for_ioc_to_operational
Date: Wed, 17 Oct 2018 11:19:32 +0300
Message-ID: <CAHp75VfPok+x4U_CmP91eG8KtOUvFYkavrw0Wg5Q9m2ZNbcVZg@mail.gmail.com>
References: <1539755947-27014-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1539755947-27014-2-git-send-email-suganath-prabu.subramani@broadcom.com> <CAHp75Veh=CkhD67jb+Qjps-UqtcCBUsA8bWco6kqppm0Q+tcvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Veh=CkhD67jb+Qjps-UqtcCBUsA8bWco6kqppm0Q+tcvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Lukas Wunner <lukas@wunner.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 11:17 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Oct 17, 2018 at 8:59 AM Suganath Prabu
> <suganath-prabu.subramani@broadcom.com> wrote:
> >
> > No functional changes. This section of code
> >  "wait for IOC to be operational" is used in many places
> >  across the driver, and hence moved this code in to
> >  a function "mpt3sas_wait_for_ioc_to_operational()"
>
> > +       ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
> > +       while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
> > +
>
> Do we need this blank line?
>
> > +               if (wait_state_count++ == timeout) {
> > +                       ioc_err(ioc, "%s: failed due to ioc not operational\n",
> > +                               __func__);
> > +                       return -EFAULT;
> > +               }
> > +               ssleep(1);
> > +               ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
> > +               ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
> > +                        __func__, wait_state_count);
> > +       }
>
> I understand this is part of existing code, but can you consider to
> modify it to something like
>
> do {
>     ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
>     if (ioc_state == MPI2_IOC_STATE_OPERATIONAL)
>       break;

Forgot ssleep(1); here.

>     ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
> __func__, ++wait_state_count);
> while (timeout--);
> if (!timeout) {
>     ioc_err(ioc, "%s: failed due to ioc not operational\n", __func__);
>     return -EFAULT;
> }
> Less lines, more understandable in my view.

-- 
With Best Regards,
Andy Shevchenko
