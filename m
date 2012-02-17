From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Fri, 17 Feb 2012 23:37:42 +0100
Message-ID: <201202172337.42768.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202161010500.1268-100000@iolanthe.rowland.org> <1329441126.3376.30.camel@minggr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329441126.3376.30.camel@minggr>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday, February 17, 2012, Lin Ming wrote:
> On Thu, 2012-02-16 at 10:13 -0500, Alan Stern wrote:
> > On Thu, 16 Feb 2012, Zhang Rui wrote:
> > 
> > > > I'm not exactly sure what you're trying to achieve and what you mean by
> > > > "resume a device directly"?  Do you want to run the device's resume
> > > > callback at the time when another device is being resumed?
> > > > 
> > > I mean, wakeup event is sent to ATA port, but our goal is to resume
> > > ZPODD after receiving this wakeup event.
> > > Ideally, it is ACPI that resumes ATA port. And then, the ATA port
> > > runtime resumes ZPODD. But this does not look good to runtime resume a
> > > child device in the parent's .runtime_resume callback.
> > > So I introduced these two APIs so that an runtime_resume request can be
> > > sent to ZPODD directly and the runtime PM core can resume all the
> > > parents of ZPODD automatically.
> > 
> > It's not clear what you're trying to achieve.  Do you basically want
> > the ZPODD always to be suspended and resumed along with the ATA port,
> > or should it be possible to suspend the ZPODD while the port remains
> > running?
> 
> We want to ZPODD always to be suspended and resumed along with the ATA
> port.
> 
> Below is part of the GPE handler for ZPODD device attention event.
> 
>         Scope (\_GPE)
>         {
>             Method (_L13, 0, NotSerialized)
>             {
>                 ADBG ("ZPODD DA Event")
>                 ....
> 
>                 Notify (\_SB.PCI0.SAT0.PRT2, 0x02)
>                 ....
>             }
>         }
> 
> It maybe a bit confused, but actually, \_SB.PCI0.SAT0.PRT2 is bind to
> the attached device, not the ata port itself.
> 
> See below commit in linux-next tree.
> 75d22c(libata: Bind the Linux device tree to the ACPI device tree)
> 
> And below notify handler(PATCH 6) will resume the attached device(CDROM
> in ZPODD case).
> 
> +static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
> +{
> +       struct ata_device *ata_dev = context;
> +
> +       if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev)
> +               scsi_autopm_get_device(ata_dev->sdev);
> +}
> +
> 
> But the code to power on/power off the device is in ata_acpi_set_state,
> which is called when ata port is resumed/suspended.
> 
> ata_eh_handle_port_resume/suspend
>     ata_acpi_set_state
>         ata_for_each_dev {
>             acpi_bus_set_power(<the acpi handle of the device>, acpi_state)
>         }
> 
> Could you take a look at PATCH 6?
> It's more clear over there.

It seems that you can use pm_runtime_no_callbacks() to work around this
as suggested by Alan.

Thanks,
Rafael
