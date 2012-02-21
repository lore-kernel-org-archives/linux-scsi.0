From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Tue, 21 Feb 2012 22:07:35 +0800
Message-ID: <CAF1ivSY4-cYsHjrM3g5D_Skt=mCxvKuLWc+fgGDEgE2XaZN+gQ@mail.gmail.com>
References: <744357E9AAD1214791ACBA4B0B90926305BFDC@SHSMSX101.ccr.corp.intel.com>
	<Pine.LNX.4.44L0.1202171003060.1350-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1202171003060.1350-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 17, 2012 at 11:07 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Fri, 17 Feb 2012, Zhang, Rui wrote:
>
>> > Do you basically want
>> > the ZPODD always to be suspended and resumed along with the ATA po=
rt,
>>
>> No. ZPODD suspends itself, which put ZPODD to a SCSI low power state=
 (NOT power off/D3_COLD).
>> And then it is the "Runtime PM core" that suspends ATA port after ZP=
ODD being suspended.
>> And the .runtime_suspend callback for ATA port actually turns off th=
e ZPODD power.
>>
>> During resume, ATA port is resumed first because of the ACPI wakeup =
event.
>> But in fact, this wakeup event should be read as "ZPODD remote wakeu=
p signal", thus runtime resume request is sent to ZPODD, done by Patch =
3/6.
>>
>> > or should it be possible to suspend the ZPODD while the port remai=
ns
>> > running?
>> >
>> Sure, but the power is still on at this time.
>
> Then maybe you can use pm_runtime_no_callbacks() for the ZPODD device=
=2E
> It's explained in Documentation/power/runtime_pm.txt, and I use it fo=
r
> USB interfaces.

If pm_runtime_no_callbacks() is used, runtime PM sysfs attributes
won't be created.
Then how to disable ZPODD feature in userspace?

Currently, I use "control" file of scsi device to enable/disable
ZPODD, for example
echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0=
/1:0:0:0/power/control
echo on > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0/1=
:0:0:0/power/control

>
> The idea is that the ZPODD will never receive any runtime PM callback=
s
> from the PM core. =A0Instead the ATA port callback routines will be
> responsible for power management of the ZPODD device.

Does the ATA port callback also responsible to resume its child?

=46or example,
/sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0/1:0:0:0/

ata0 is resumed.

Then who will be responsible to resume host1, target1:0:0 and 1:0:0:0?

Or do you mean that we don't need to resume these devices at all?
host1 and target1:0:0 are logical devices, but I think 1:0:0:0 is not.

Thanks,
Lin Ming
