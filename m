From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 14 Feb 2012 07:42:50 +1100
Message-ID: <CAN05THT=7xJhqAMrAvDsK2Z1_4d+=tV9yhOFkr5Z-i43k5hAGA@mail.gmail.com>
References: <4F313526.2050907@redhat.com>
	<OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
	<4F3390FB.80107@redhat.com>
	<1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
	<4F38B657.7060405@de.ibm.com>
	<4F38C27E.7030300@redhat.com>
	<1329136806.9333.383.camel@haakon2.linux-iscsi.org>
	<4F3907EB.4030402@redhat.com>
	<20120213130005.GB26773@redhat.com>
	<CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com>
	<20120213131848.GD26773@redhat.com>
	<4F39287A.9030808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4F39287A.9030808@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2012 at 2:12 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/13/2012 02:18 PM, Michael S. Tsirkin wrote:
>> On Tue, Feb 14, 2012 at 12:13:36AM +1100, ronnie sahlberg wrote:
>>> On Tue, Feb 14, 2012 at 12:00 AM, Michael S. Tsirkin <mst@redhat.co=
m> wrote:
>>>> On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
>>>>> Only if you use the pci multi-function option but that kills
>>>>> standard hot unplug
>>>>
>>>> It doesn't kill it as such, rather you can't unplug luns individua=
lly.
>>>
>>> Isnt that just a consequence of the current implementation rather t=
han
>>> a SCSI limitation?
>>
>> Yes.
>>
>>> A different way to do hoplug could be to flag all devices as remova=
ble
>>> in the standard inq page then
>>> leave the LUN there persistently and what you remove/add is not the
>>> LUN device itself but just the media in the device.
>>>
>>> Instead of hot-plug remove the LUN, =A0hot-plug becomes "media ejec=
t" or
>>> "media insert".
>>> The device remains present all time, you never remove it, but inste=
ad
>>> hot-plug controls if the media is present or not.
>>>
>>>
>>> This would require implementing at least START_STOP_UNIT and
>>> PREVENT_ALLOW_MEDIUM_REMOVAL opcode emulation from SBC.
>>>
>>>
>>> regards
>>> ronnie sahlberg
>>
>> That would work.
>>
> Or we simply use the Peripheral Qualifier that the device is gone;
> eg we could simply set PQ =3D 1, return sense code 0x25/00 and be don=
e
> with ...
>

That is still similar to "rip a device out from the guest without notic=
e"
and can cause the guest to be "surprised".


Removable media is standard feature in SCSI SBC (and other commandsets)=
=2E
The nice part of removable media is that it activates a contract
between the device and the guest
to prevent removal of the media when the guest depends on the media
not being removed.

I.e.  If you have a SBC device with the removable-media bit set,
this is used to tell the initiator "this media can be removed, be
prepared that this might happen".
So when you mount such a SBC device in the guest, the guest will issue
a "PREVENT_ALLOW_MEDIUM_REMOVAL"
to tell the device "this medium is in use and may not be removed".

This automatically provides you with a mechanism where any guest can
signal to qemu when qemu may or may not remove the device/medium.



In addition to implementing PREVENT_ALLOW_MEDIUM_REMOVAL emulation,
qemu would also need to check the prevent-allow status before it
allows the device to be removed.

If nothing else, using this approach will automatically provide a
channel from the guest kernel to qemu to tell qemu when a device may
be unplugged and when it is not safe to unplug the device.



regards
ronnie sahlberg
