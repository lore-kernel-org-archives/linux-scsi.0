From: Hannes Reinecke <hare@suse.de>
Subject: Re: Why using configfs as the only interface is wrong for a storage
 target
Date: Mon, 07 Feb 2011 16:10:30 +0100
Message-ID: <4D500B66.5000103@suse.de>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>	 <20110207115347.GA7503@noexit> <1297089709.3012.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab1BGPCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2011 10:02:21 -0500
In-Reply-To: <1297089709.3012.19.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>, Bart Van Assche <bvanassche@acm.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On 02/07/2011 03:41 PM, James Bottomley wrote:
> On Mon, 2011-02-07 at 03:53 -0800, Joel Becker wrote:
>> On Mon, Feb 07, 2011 at 12:41:18PM +0100, Bart Van Assche wrote:
>>> On Fri, Feb 4, 2011 at 7:45 AM, Nicholas A. Bellinger
>>> <nab@linux-iscsi.org> wrote:
>>>> Please consider the following patch series for mainline target cod=
e.
>>>> It consists of predominately configfs bugfixes uncovered with rece=
nt SLUB
>>>> poison testing, and proper removal of legacy procfs target_core_mi=
b.c code.
>>>> Note that the complete set of fabric independent statistics (SCSI =
MIBs) and
>>>> fabric dependent statistics will be included as native configfs gr=
oup context
>>>> 'per value' attribute series during the .39 time frame.
>>>
>>> I'm still not convinced that using configfs in a storage target as =
the
>>> only interface between kernel space and user space is a good idea.
>>> While configfs may satisfy all the needs of an iSCSI target, the us=
e
>>> of configfs in combination with hot-pluggable HCAs is really awkwar=
d.
>>> Whenever a HCA is plugged in, the user has to issue mkdir commands =
to
>>> make these interfaces appear in configfs. And whenever a HCA is
>>> removed, stale information will remain present in configfs until th=
e
>>> user issues an rmdir command. As we all know, it is not possible fo=
r a
>>> storage target to make these directories appear / disappear
>>> automatically in configfs because of basic configfs design choices.
>>
>> 	Any configuration would have to be handled.  We have plenty of
>> stuff that is handled by userspace hooks out of udev, etc.  That's a
>> normal hotplug process.
>> 	Essentially, you're not challenging Nick's use of configfs here,
>> you're challenging his environment of setting up the target stack fr=
om
>> userspace.
>=20
> I think the overall philosophical point here, and it's a good one
> because I've heard it from several sources, is that it's not possible=
 to
> separate configuration from status completely.  The classic example i=
s
> where the kernel has to validate and adjust config information, but t=
he
> storage specific one is where events alter the topology.  In either
> case, the configfs tree gets out of sync with reality if the kernel d=
oes
> the adjustment..  Just saying we have to use a user space tool to fix=
 it
> up is a bit of a cop out because the kernel has already adjusted its =
own
> configuration, so getting userspace to work out what the kernel's don=
e
> and adjust configfs is a bit sub optimal.
>=20
This sounds exactly like the familiar problem we have on zSeries;
devices are being configured via sysfs but require a separate store
to hold the information if the device doesn't happen to be present.

What we came up with is
a) Devices which are not configured won't be activated.
   Essentially this means you have to have a configuration for
   each device (_not_ stored in sysfs, obviously), and use this
   as the primary config. If and when the device becomes available,
   udev will use this information to configure the device.
b) If the device state changes either the device is smart enough
   to handle it internally or the correct events have to be send out
   via udev to allow proper configuration here.

And yes, without udev that wouldn't work. If you have a problem
with this, you can stop reading now.

Applying this to configfs we need to define a configuration file
format, and a set of udev rules which would use this information
to configure the configfs tree.

Of course, it would be preferable to have target_core to update
the information itself (eg for device removal).
If that wouldn't be possible we need to insure that the configfs
part doesn't crash if the underlying device is removed but rather
returns sensible errors when accessed.

But I don't see any principle problem here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
