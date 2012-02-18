From: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Sat, 18 Feb 2012 20:54:49 +0800
Message-ID: <CAC=cRTOCpH8haMGDEDDG8k0k2DpaVM7DoU5AayrcscR1rZKXgQ@mail.gmail.com>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
	<201202142339.59423.rjw@sisk.pl>
	<1329378119.28581.34.camel@rui.sh.intel.com>
	<201202180054.49284.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201202180054.49284.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 18, 2012 at 7:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, February 16, 2012, Zhang Rui wrote:
>> On =E4=BA=8C, 2012-02-14 at 23:39 +0100, Rafael J. Wysocki wrote:
>> > On Tuesday, February 14, 2012, Zhang Rui wrote:
>> > > On =E4=B8=80, 2012-02-13 at 20:38 +0100, Rafael J. Wysocki wrote=
:
>> > > > On Monday, February 13, 2012, Alan Stern wrote:
>> > > > > On Mon, 13 Feb 2012, Lin Ming wrote:
[snip]
>> Yeah, I have thought about this for quite a while before, there ARE
>> several ways to do this, but these need a lot of changes in bus code=
, at
>> least for the buses that support device runtime D3 (off) by ACPI.
>>
>> Lets also take SATA port and ZPODD for example,
>> proposal one,
>> 1) introduce scsi_can_power_off and ata_can_power_off.
>> 2) sr driver set scsi_can_power_off bit and scsi layer is aware of t=
his,
>> thus the scsi host can set this bit as well.
>> 3) in the .runtime_suspend callback of ata port, it knows that its s=
csi
>> host interface can be powered off, thus it invokes ata_can_power_off=
 to
>> tell the ata layer.
>
> Hmm. =C2=A0I'm not sure why you want to introduce this special "power=
 off"
> condition. =C2=A0In fact, it's nothing special, it only means that th=
e device
> in question shouldn't be accessed by software, which pretty much is e=
quivalent
> to the "suspended" condition (as defined in the runtime PM docs).

I think some reasons to introduce can_poweroff can be:

1) To indicate the implementation of .runtime_suspend/.runtime_resume
is compatible with power off.  That is, .runtime_suspend will save all
needed information and .runtime_resume can work on the uninitialized
device.

If this is already the requirement of
=2Eruntime_suspend/.runtime_resume.  Then this is not needed.   Maybe w=
e
can make that explicitly for these callbacks via some kind of
documentation.

2) To support something like pm-qos.  power off device may have more
exit.latency than normal low power state (such as D3Hot).  Some device
may disable can_power_off based on that.

3) Whether to go to power off should be determined by leaf device
(such as SATA disk), but that may be done by its parent device (such
as SATA port).  It's a way for leaf device to tell its parent device
whether it want to go to power off.

[snip]

Best Regards,
Huang Ying
