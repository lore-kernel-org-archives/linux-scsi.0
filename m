From: Hannes Reinecke <hare@suse.de>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Mon, 13 Feb 2012 16:12:58 +0100
Message-ID: <4F39287A.9030808@suse.de>
References: <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com> <4F3390FB.80107@redhat.com> <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com> <4F38B657.7060405@de.ibm.com> <4F38C27E.7030300@redhat.com> <1329136806.9333.383.camel@haakon2.linux-iscsi.org> <4F3907EB.4030402@redhat.com> <20120213130005.GB26773@redhat.com> <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com> <20120213131848.GD26773@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120213131848.GD26773@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/13/2012 02:18 PM, Michael S. Tsirkin wrote:
> On Tue, Feb 14, 2012 at 12:13:36AM +1100, ronnie sahlberg wrote:
>> On Tue, Feb 14, 2012 at 12:00 AM, Michael S. Tsirkin <mst@redhat.com=
> wrote:
>>> On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
>>>> Only if you use the pci multi-function option but that kills
>>>> standard hot unplug
>>>
>>> It doesn't kill it as such, rather you can't unplug luns individual=
ly.
>>
>> Isnt that just a consequence of the current implementation rather th=
an
>> a SCSI limitation?
>=20
> Yes.
>=20
>> A different way to do hoplug could be to flag all devices as removab=
le
>> in the standard inq page then
>> leave the LUN there persistently and what you remove/add is not the
>> LUN device itself but just the media in the device.
>>
>> Instead of hot-plug remove the LUN,  hot-plug becomes "media eject" =
or
>> "media insert".
>> The device remains present all time, you never remove it, but instea=
d
>> hot-plug controls if the media is present or not.
>>
>>
>> This would require implementing at least START_STOP_UNIT and
>> PREVENT_ALLOW_MEDIUM_REMOVAL opcode emulation from SBC.
>>
>>
>> regards
>> ronnie sahlberg
>=20
> That would work.
>
Or we simply use the Peripheral Qualifier that the device is gone;
eg we could simply set PQ =3D 1, return sense code 0x25/00 and be done
with ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
