From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no
 management
Date: Thu, 15 Oct 2015 07:52:17 +0200
Message-ID: <561F3F11.4060000@suse.com>
References: <cover.1444241058.git.lduncan@suse.com>	 <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>	 <1444830904.2220.28.camel@HansenPartnership.com>	 <561EA018.7020700@suse.com> <1444848835.2220.50.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444848835.2220.50.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/14/2015 08:53 PM, James Bottomley wrote:
> On Wed, 2015-10-14 at 11:34 -0700, Lee Duncan wrote:
>> On 10/14/2015 06:55 AM, James Bottomley wrote:
>>> On Wed, 2015-10-07 at 16:51 -0700, Lee Duncan wrote:
>>>> Update the SCSI hosts module to use the ida_simple*() routines
>>>> to manage its host_no index instead of an ATOMIC integer. This
>>>> means that the SCSI host number will now be reclaimable.
>>>
>>> OK, but why would we want to do this?  We do it for sd because our =
minor
>>> space for the device nodes is very constrained, so packing is essen=
tial.
>>> For HBAs, there's no device space density to worry about, they're
>>> largely statically allocated at boot time and not reusing the numbe=
rs
>>> allows easy extraction of hotplug items for the logs (quite useful =
for
>>> USB) because each separate hotplug has a separate and monotonically
>>> increasing host number.
>>>
>>> James
>>>
>>
>> Good question, James. Apologies for not making the need clear.
>>
>> The iSCSI subsystem uses a host structure for discovery, then throws=
 it
>> away. So each time it does discovery it gets a new host structure. W=
ith
>> the current approach, that number is ever increasing. It's only a ma=
tter
>> of time until some user with a hundreds of disks and perhaps thousan=
ds
>> of LUNs, that likes to do periodic discovery (think super-computers)
>> will run out of host numbers. Or, worse yet, get a negative number
>> number (because the value is signed right now).
>>
>> And this use case is a real one right now, by the way.
>=20
> Um, so even if you do discovery continuously, say one every second, i=
t
> still will take 68 years before we wrap the sign.
>=20
>> As you can see from the patch, it's a small amount of code to ensure
>> that the host number management is handled more cleanly.
>=20
> Well, I'm a bit worried about the loss of a monotonically increasing
> host number from the debugging perspective.  Right now, if you look a=
t
> any log, hostX always refers to one and only one incarnation througho=
ut
> the system lifetime for any given value of X.  With your patch, the
> lowest host number gets continually reused ... probably for every hot
> plug event.  If the USB and other hotplug system people don't mind th=
is,
> I suppose I can live with it, but I'd like to hear their view before
> making this change.
>=20
Typically host numbers are not a real issue; whenever I need to
debug something more often than not I need to figure out
informations about the scsi device. And not once in my entire career
I had any needs to rely on the SCSI host number.

Plus the SCSI host number is the only thing in the stack which
_does_ increase; everything else like bus/target/LUN
numbers are stable and won't change much, irrespective of the
number of rescans or unloads. Which always irritated me.

So I'm definitely in favour of reusing the SCSI host numbers.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
