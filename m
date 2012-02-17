From: "Zhang, Rui" <rui.zhang@intel.com>
Subject: RE: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Fri, 17 Feb 2012 07:05:55 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926305BFDC@SHSMSX101.ccr.corp.intel.com>
References: <1329376686.28581.15.camel@rui.sh.intel.com>
 <Pine.LNX.4.44L0.1202161010500.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1202161010500.1268-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Lin, Ming M" <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, alan,

> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Thursday, February 16, 2012 11:14 PM
> To: Zhang, Rui
> Cc: Rafael J. Wysocki; Lin, Ming M; Jeff Garzik; Tejun Heo; Len Brown;
> linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-pm@vger.kernel.org
> Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power
> Resource
> Importance: High
> 
> On Thu, 16 Feb 2012, Zhang Rui wrote:
> 
> > > I'm not exactly sure what you're trying to achieve and what you
> mean by
> > > "resume a device directly"?  Do you want to run the device's resume
> > > callback at the time when another device is being resumed?
> > >
> > I mean, wakeup event is sent to ATA port, but our goal is to resume
> > ZPODD after receiving this wakeup event.
> > Ideally, it is ACPI that resumes ATA port. And then, the ATA port
> > runtime resumes ZPODD. But this does not look good to runtime resume
> a
> > child device in the parent's .runtime_resume callback.
> > So I introduced these two APIs so that an runtime_resume request can
> be
> > sent to ZPODD directly and the runtime PM core can resume all the
> > parents of ZPODD automatically.
> 
> It's not clear what you're trying to achieve.


> Do you basically want
> the ZPODD always to be suspended and resumed along with the ATA port,

No. ZPODD suspends itself, which put ZPODD to a SCSI low power state (NOT power off/D3_COLD).
And then it is the "Runtime PM core" that suspends ATA port after ZPODD being suspended.
And the .runtime_suspend callback for ATA port actually turns off the ZPODD power.

During resume, ATA port is resumed first because of the ACPI wakeup event. 
But in fact, this wakeup event should be read as "ZPODD remote wakeup signal", thus runtime resume request is sent to ZPODD, done by Patch 3/6.

> or should it be possible to suspend the ZPODD while the port remains
> running?
> 
Sure, but the power is still on at this time.

Thanks,
rui
