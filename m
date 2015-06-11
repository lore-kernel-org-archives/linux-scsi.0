From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] target: 64-bit LUN support
Date: Thu, 11 Jun 2015 07:56:39 +0200
Message-ID: <55792317.5020500@suse.de>
References: <1433918483-46849-1-git-send-email-hare@suse.de> <5578699D.6090405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5578699D.6090405@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 06/10/2015 06:45 PM, Andy Grover wrote:
> On 06/09/2015 11:41 PM, Hannes Reinecke wrote:
>> Hi Nic,
>>
>> here's now the patchset for making LIO-target support 64-bit LUNs.
>> Pretty straightforward, plus an additional patch to remove the
>> now obsolete limitation on 256 LUNs per TPG. There had been a
>> comment in the header that REPORT LUN emulation would only support
>> up to one page in payload, but I couldn't find any evidence for
>> this in the code.
>>
>> As usual, comments and reviews are welcome.
>=20
> Hi Hannes,
>=20
> I think we also need to take care of how we report LUNs in spc.c
> spc_emulate_report_luns(). From reading SAM-5 4.7.7 (addressing
> methods) it looks like we're currently using the simple addressing
> format (address method =3D 0) and if we want to report more than 14
> bits we would need to report the luns with a different addressing
> format.
>=20
> I'm wondering if this could be seen as a bug in int_to_scsilun, but
> in any case I hope you'll take a look and make sure we're ok?
>=20
Actually, I've been thinking about this. Currently I'm not sure if
we should fully embrace this route; after all, 'scsilun_to_int' is
meant to be a conversion from the (abstract) LUN number into our
internal representation.
And as it's internal we're free to use whatever we like.

Where we need to fix up things is in reporting; whenever we display
LUN numbers to userspace (printk or sysfs-wise) we probably should
use the appropriate format.

I'll see if I can whip up a printk format for this.
Never liked the '%llu' format for LUNs anyway.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
