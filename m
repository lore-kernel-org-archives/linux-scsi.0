From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Mon, 24 Sep 2012 23:46:03 +0200
Message-ID: <201209242346.03414.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209241506.11631.rjw@sisk.pl> <20120924150449.GB3293@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120924150449.GB3293@mint-spring.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Monday, September 24, 2012, Aaron Lu wrote:
> On Mon, Sep 24, 2012 at 03:06:11PM +0200, Rafael J. Wysocki wrote:
> > On Monday, September 24, 2012, Aaron Lu wrote:
> > > On Fri, Sep 21, 2012 at 11:18:27PM +0200, Rafael J. Wysocki wrote:
> > > > On Friday, September 21, 2012, Aaron Lu wrote:
> > > > > On Thu, Sep 20, 2012 at 10:00:51PM +0200, Rafael J. Wysocki wrote:
> > > > > > On Wednesday, September 19, 2012, Aaron Lu wrote:
> > > > > > > Thanks Rafael, and if there is any question/problem,
> > > > > > > please kindly let me know.
> > > > > > 
> > > > > > Well, unfortunately my initial review indicates that the patchset is not
> > > > > > quite ready to go upstream yet.
> > > > > > 
> > > > > > I'll send comments in replies to the individual patches, but overall I can
> > > > > > say that at this stage of development, when I look at the patches, it should
> > > > > > be clear to me not only what is being changed, but _why_ it is being changed
> > > > > > in the first place and, secondly, why it is being changed in this particular
> > > > > > way.  It's far from that, though.
> > > > > 
> > > > > I'm adding zero power support for optical disk drive(ZPODD), which is
> > > > > made possible with the newly defined device attention(DA) pin introduced
> > > > > in SATA 3.1 spec.
> > > > > 
> > > > > The idea here is to use runtime pm to achieve this, so I basically did 2
> > > > > things:
> > > > > 1 Add runtime pm support for ODD;
> > > > > 2 Add power off support for ODD after it is runtime suspended.
> > > > > 
> > > > > Patch 2 is runtime pm support for ODD, the reason it is done this way is
> > > > > discussed here:
> > > > > http://www.spinics.net/lists/linux-scsi/msg61551.html
> > > > 
> > > > Why isn't it explained in the patch changelog, then?  People should be able
> > > > to learn why things are done the way they are done from git logs.
> > > > 
> > > > > The basic idea is, the ODD will be runtime suspended as long as there is
> > > > > nobody using it, that is, no programs opening the block device.
> > > > > 
> > > > > The ODD will be polled periodically, so it will be runtime resumed
> > > > > before checking if there is any events pending and suspended when done.
> > > > 
> > > > OK.  So what happens if we power off the drive via runtime PM.  Does it
> > > > it really make sense to resumie it through polling in that case?
> > > 
> > > No, this is the reason I introduced the powered_off flag. If set, the
> > > poll will simply return without touching the device.
> > > 
> > > I've tried to do a disk_block_events call on its suspend callback when
> > > it is ready to be powered off, but there is a race that I don't know how
> > > to solve:
> > > pm_runtime_suspend			disk_events_workfn		
> > >   scsi_dev_type_suspend			  sr_block_check_events
> > >     sr_suspend				    cdrom_check_events
> > >       disk_block_events		      	      cdrom_update_events
> > >       (this call waits for all		        sr_check_events
> > >       running events_checking function	          scsi_autopm_get_device
> > >       to return)
> > > 
> > > Suppose sr_suspend runs first, and then sr_check_events comes in.
> > > sr_suspend calls disk_block_events, which waits for sr_check_events,
> > > while scsi_autopm_get_device wait for suspend callback to finish,
> > > deadlock.
> > 
> > I need some more time to think about this, stay tuned.
> 
> Thanks.

Alan has just given you a good suggestion, you can follow it I think.

> > > > > The only exception is, if we found a disc is just inserted, we will not
> > > > > idle it immediately at the end of the poll, reason explained in another
> > > > > mail.
> > > > > 
> > > > > This is the rational I wrote patch 2, and patch 1 is used by patch 2.
> > > > > 
> > > > > Patch 3 is adding power off support for ODD after it is runtime
> > > > > suspended, the condition is specified in section 15:
> > > > > ftp://ftp.seagate.com/sff/INF-8090.PDF
> > > > > 
> > > > > That is, for tray type ODD: no media inside and door closed; for slot
> > > > > type ODD: no media inside.
> > > > > 
> > > > > The is the reason sr_suspend is written, for non-ZPODD capable devices,
> > > > > it does nothing; for ZPODD devices, it will check the above condition to
> > > > > see if it is ready to be powered off. The ready_to_power_off flag will be
> > > > > used by ATA layer to decide if power can be removed.
> > > > 
> > > > Now, James says he doesn't like the way ready_to_power_off is used.  Sure
> > > > enough, it is totally irrelevant to the majority of SCSI devices.  It actually
> > > > is totally irrelevant to everything in the SCSI subsystem except for the sr
> > > > driver and libata.  So I wonder if you have considered any alternative
> > > > way to address the use case at hand?
> > > > 
> > > > > When in powered off state, if user presses the eject button or insert a
> > > > > disc, an ACPI event will be generated and our acpi wake handler will
> > > > > pm_runtime_resume the ODD. And if it is a tray type ODD, its tray should
> > > > > be ejected(need_eject flag) after powered on. This is patch 3.
> > > > 
> > > > That sounds reasonable enough, but the role of the powered_off and
> > > > need_eject flags could be explained a bit better.  In particular, it would
> > > 
> > > powered_off: set when the device is powered off, clear otherwise.
> > 
> > That's pretty clear, but I think this flag should be called no_polling
> > or something like this, because that's what it means to the SCSI layer.
> 
> Agree.
> 
> > 
> > > need_eject:
> > > First consider how the device will be runtime resumed:
> > > 1 Some program opens the block device;
> > > 2 Events checking poll when it's not powered off yet;
> > > 3 User presses the eject button or inserts a disc into the slot when the
> > >   device is in powered off state.
> > > And the need_eject flag is for case 3, when the device is in powered off
> > > state and user presses the eject button, it will be powered on(through
> > > acpi wake notification function) and runtime resumed. In its runtime
> > > resume callback, its tray needs to be ejected since user just presses
> > > the eject button. The whole process of ZPODD is opaque to the user,
> > > he/she doesn't know the ODD lost power so the ODD has to behave exactly
> > > like it doesn't lose power.
> > 
> > Do you think it can be useful for other types of devices, not necessarily
> > handled through ACPI?
> 
> I can only say that it is useful for ZPODD, if ZPODD someday is used on
> another platform that does not use ACPI, the need_eject flag should
> still be needed.
> 
> As for other scsi devices, I'm not sure.

I see.  This means we don't really have good arguments for putting that flag
into struct scsi_device ...

> > > Hi Oliver,
> > > This flag is really to say the tray needs to be ejected after runtime
> > > resumed, it's not that media change detected. It is possible that user
> > > ejects the tray without putting any disc inside and simply close the
> > > tray, which doesn't qualify a media change event. And if user does
> > > put a disc in, the sr_check_events will find that and report the media
> > > change event to user space. Agree?
> > > 
> > > > be nice to have explained why they have to be present in struct scsi_device,
> > > > because they don't seem to be particularly useful for many SCSI devices
> > > > that aren't CD drives (the need_eject one in particular).
> > > 
> > > With your suggestion of pm_platform_power_off_allowed, I suppose
> > > powered_off can be eliminated similarly with something like
> > > pm_platform_powered_off returning true or false(for ACPI platform,
> > > return true when device is in D3 cold state).
> > 
> > I'm currently thinking that using PM QoS may be a better approach here.
> 
> Is it something like a "power_off_allowed" binary constraint?
> Then both the sr driver and the user can change the value so that both
> the ready_to_power_off and may_power_off is no longer needed.

Yes, that's the idea.

Thanks,
Rafael
