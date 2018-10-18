From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [v5 1/4] mpt3sas: Separate out mpt3sas_wait_for_ioc_to_operational
Date: Thu, 18 Oct 2018 10:22:00 +0300
Message-ID: <CAHp75Vd63Ss3WBuAA0euutGboUuOzS0EJ3J-365b5QOTz98NqQ@mail.gmail.com>
References: <1539755947-27014-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1539755947-27014-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <CAHp75Veh=CkhD67jb+Qjps-UqtcCBUsA8bWco6kqppm0Q+tcvg@mail.gmail.com>
 <CAHp75VfPok+x4U_CmP91eG8KtOUvFYkavrw0Wg5Q9m2ZNbcVZg@mail.gmail.com> <CA+RiK66_gpLvzFyztdQ3BdX11wn2uRfxoF6hhRg1TXoERe7z3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+RiK66_gpLvzFyztdQ3BdX11wn2uRfxoF6hhRg1TXoERe7z3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Lukas Wunner <lukas@wunner.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, ruscur@russell.cc, sbobroff@linux.ibm.com, Oliver <oohall@gmail.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 18, 2018 at 10:10 AM Suganath Prabu Subramani
<suganath-prabu.subramani@broadcom.com> wrote:
> On Wed, Oct 17, 2018 at 1:49 PM Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>> On Wed, Oct 17, 2018 at 11:17 AM Andy Shevchenko
>> <andy.shevchenko@gmail.com> wrote:

>> > I understand this is part of existing code, but can you consider to
>> > modify it to something like
>> >
>> > do {
>> >     ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
>> >     if (ioc_state == MPI2_IOC_STATE_OPERATIONAL)
>> >       break;
>>
>> Forgot ssleep(1); here.
>>
>> >     ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
>> > __func__, ++wait_state_count);

>> > while (timeout--);

Just noticed this should be --timeout.

>> > if (!timeout) {
>> >     ioc_err(ioc, "%s: failed due to ioc not operational\n", __func__);
>> >     return -EFAULT;
>> > }
>> > Less lines, more understandable in my view.
>
> Yes, We 'll take this change and resend.


-- 
With Best Regards,
Andy Shevchenko
