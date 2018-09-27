From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v4] scsi: ufs: Make sysfs attributes writable
Date: Thu, 27 Sep 2018 16:16:33 -0700
Message-ID: <CAE=gft5sgayo8CUOp7WfA5Vs1Pp2YR0OayyUvxOMtHEXzDJwRw@mail.gmail.com>
References: <20180808224454.243790-1-evgreen@chromium.org> <6dd8a547-7260-09b8-9096-8a1564b08e70@intel.com>
 <8fd05b2d-fa48-78af-6f1c-7e485c1008f6@intel.com> <CAD=FV=W7h_3LwV-P5_E58-3qOo7Y-yQDTDfSLoU1+3c_6ZF0cg@mail.gmail.com>
 <yq1h8idgj5y.fsf@oracle.com> <CAD=FV=WNHDd8icQi3wtFV98w1zdEd-QqFn1PrZeXQWgYt4Yo1w@mail.gmail.com>
 <CAE=gft57aP3Qx-zdHR1UsJwS7JjVEpVvmCSTk3ctWrRF2=W4ww@mail.gmail.com>
 <SN6PR04MB4925DAB09EED762CDCCBBF47FC140@SN6PR04MB4925.namprd04.prod.outlook.com>
 <20180927140133.GA22096@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927140133.GA22096@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org
Cc: Avri.Altman@wdc.com, Doug Anderson <dianders@chromium.org>, martin.petersen@oracle.com, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, Stanislav.Nijnikov@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, adrian.hunter@intel.com, sayali <sayalil@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 27, 2018 at 7:01 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Sep 27, 2018 at 06:32:47AM +0000, Avri Altman wrote:
> > Also, in this context there is the series in
> > https://www.spinics.net/lists/linux-scsi/msg123479.html
> > which allows to send UPIUs via a bsg device.
> >
> > It's not a provisioning series per-se like Evan's and Sayali's.
> > It covers the provisioning functionality,
> > But also allow to send task management UPIU, and UIC commands,
> > Which can be used for testing and validation.
>
> And as someone having been involved with review of a few different
> UFS provisioning bits this is what I think we should be merging.
>
> Instead of being in a rat race of adding ever new sysfs or configfs
> attributes for things that don't matter to normal driver operation
> I'd rather have a relatively clean pass through interface and move
> policy to userspace.  Especially given that there are plenty of
> vendor specific commands at these levels as well.

There's no policy in my patches (nor Sayali's), nor are there any
vendor-specific commands here. The sysfs interface has exposed knobs
defined by the UFS specification, which to me seems like the kernel
providing a sane abstraction of device functionality. I don't see
there being a rat race, as these attributes and the config descriptor
are all that's needed to provision a device, and any reasonable future
versions of the UFS spec would likely be backwards compatible with
respect to attributes and flags.

The patches Avri linked to seem fine as well, but I don't see why
there's not room for both the "roll your own driver completely in user
mode" approach, and the "kernel provides a reasonable abstraction of
device functionality" approach to co-exist. We do the same sort of
thing for simple buses like I2C for example, where you can both write
a kernel driver or do bus transactions directly from user mode.

-Evan
