From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v4] scsi: ufs: Make sysfs attributes writable
Date: Wed, 26 Sep 2018 10:41:52 -0700
Message-ID: <CAE=gft57aP3Qx-zdHR1UsJwS7JjVEpVvmCSTk3ctWrRF2=W4ww@mail.gmail.com>
References: <20180808224454.243790-1-evgreen@chromium.org> <6dd8a547-7260-09b8-9096-8a1564b08e70@intel.com>
 <8fd05b2d-fa48-78af-6f1c-7e485c1008f6@intel.com> <CAD=FV=W7h_3LwV-P5_E58-3qOo7Y-yQDTDfSLoU1+3c_6ZF0cg@mail.gmail.com>
 <yq1h8idgj5y.fsf@oracle.com> <CAD=FV=WNHDd8icQi3wtFV98w1zdEd-QqFn1PrZeXQWgYt4Yo1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD=FV=WNHDd8icQi3wtFV98w1zdEd-QqFn1PrZeXQWgYt4Yo1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Anderson <dianders@chromium.org>
Cc: martin.petersen@oracle.com, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, stanislav.nijnikov@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, adrian.hunter@intel.com, sayali <sayalil@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 25, 2018 at 6:46 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Martin,
>
> On Tue, Sep 25, 2018 at 6:08 PM Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >
> > Doug,
> >
> > > I came across this patch and Evan's other one and noticed that they
> > > haven't been applied though a batch of other SCSI patches for 4.20
> > > were applied about a week ago.  Martin: is there something about these
> > > patches that needs to change before they can land?
> >
> > I have simply been awaiting some sort of consensus on the various
> > competing approaches. Lots of patches posted with tiny incremental fixes
> > but very little discussion about the merits of one over the other.
>
> Ah, perfect information!  Thank you!  I was just confused because I
> didn't understand all the status and it just looked like silence here.
>
> Maybe someone on this thread can start a discussion with all the
> stakeholders (people who have been involved in competing patches or
> other tiny bits and pieces) and summarize their view of the current
> status?  Maybe that would help get the ball rolling again?
>

Ah, I did not realize that's what was being gated on.

These patches complement, rather than compete with, the other patches
out there. There are two components to completely provisioning a UFS
device: writing the configuration descriptors, and setting
attributes/flags. My original series [1] did contain support for the
provisioning portion, but I opted to leave that to Sayali's patch [2]
that uses configfs, rather than duplicate effort. Sayali's other patch
[3] does handle setting the reference clock frequency, which has some
overlap with this patch in that both set bRefClkFreq. But this patch
and the flag patch [4] are still needed for provisioning activity like
locking the descriptors down once they're set up, and enable other
device experimentation. In other words, they're independent.

There was also another independent fix [5] for devices that start in
sleep mode, which Linux currently can't handle. That patch got no
reviews, which is a shame, and I should probably resend as multiple
patches or at least with some additional information.

-Evan

[1] https://lkml.org/lkml/2018/5/29/969
[2] https://lkml.org/lkml/2018/9/14/293
[3] https://lkml.org/lkml/2018/9/14/292
[4] https://patchwork.kernel.org/patch/10570811/
[5] https://lkml.org/lkml/2018/8/10/669
