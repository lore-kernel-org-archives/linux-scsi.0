From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 03 Aug 2015 18:47:46 +0200
Message-ID: <55BF9B32.6030304@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de> <1438347728-106434-2-git-send-email-hare@suse.de> <20150802154415.GA31100@mtj.duckdns.org> <55BF18ED.3000002@suse.de> <20150803150428.GE32599@mtj.duckdns.org> <20150803151826.GG32599@mtj.duckdns.org> <1438616563.2173.16.camel@HansenPartnership.com> <20150803155513.GI32599@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20150803155513.GI32599@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/03/2015 05:55 PM, Tejun Heo wrote:
> Hello, James.
>=20
> On Mon, Aug 03, 2015 at 08:42:43AM -0700, James Bottomley wrote:
>> I'd think it would be the same reason as all modern transports: it's
>> faster and allows processing of sense data in-band.  Under the old
>> regime, the device is effectively frozen until you collect the data.
>> Under autosense, the data is collected as part of the in-band comman=
d
>> processing, so it doesn't stall the device.
>>
>> Modern drives (and protocols) are moving towards being somewhat more
>> chatty with sense data.  It doesn't just signal an error, mostly it'=
s
>> just reporting about drive characteristics or other advisory stuff.
>> This means that if you handle it the old way, you'll get more drive
>> stalls and a corresponding reduction in throughput.
>=20
> The problem is not the "auto" part but the "sense" part, I guess.  AT=
A
> devices (the harddisks) never reported sense data and instead had a
> more rudimentary error bits and for newer devices NCQ log pages, so
> libata EH decodes those error information and takes appropriate
> actions for the indicated error condition.
>=20
> Hannes's patchset makes ATA devices mostly bypass libata EH when sens=
e
> data is present.  For, say, unrecoverable read errors, it'd be
> possible to make this scheme work (broken currently tho); however,
> libata and SCSI aren't that closely tied and there currently is no wa=
y
> for SCSI to tell libata that, e.g., link error was detected on the
> device side, so libata will fail to take link recovery actions on
> those cases.
>=20
> This *can* be made to work in a couple different ways but what's
> implemented now is pretty broken and making it work properly in any
> other way than integrating sense decoding into libata EH would requir=
e
> major restructuring of the whole thing which I'm not sure would be
> worthwhile at this point.
>=20
At the moment NCQ autosense is mostly used to provide the host with mor=
e
details for a failed I/O. The typical case here is (no small surprise)
ZAC disks, which use autosense to inform the host about
a malformed I/O.
It is _not_ being used as a replacement for existing error behaviour,
(ie link errors are not being signalled with that; how could they
if there is no link?); in fact, during testing I"ve seen both, autosens=
e
I/O failures and normal I/O failures for which autosense is
not set, and the normal error handling kicks in.

It's not that I've disable the original error handler completely,
it's only bypassed for I/O failure where a sense code is provided.
And the drive surely knows which error occurs, so we'd be daft not be
using that.

So I think disabling autosense completely is a bit extreme...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
