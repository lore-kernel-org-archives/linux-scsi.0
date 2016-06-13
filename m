From: Hannes Reinecke <hare@suse.de>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Mon, 13 Jun 2016 09:04:52 +0200
Message-ID: <575E5B14.7020308@suse.de>
References: <1465668572.2364.26.camel@HansenPartnership.com>
 <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
 <CA+55aFzoFPQB6GQ-bZZJQ2bQNxDyqioxZmsDxW=P7tVOauC+AA@mail.gmail.com>
 <1465674067.2364.43.camel@HansenPartnership.com>
 <CA+55aFw5xsPx0r01Z5aKXn6UbHLhGbXoa0qyGVJbfWiC7yq1WA@mail.gmail.com>
 <1465679005.2364.75.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465679005.2364.75.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/11/2016 11:03 PM, James Bottomley wrote:
> On Sat, 2016-06-11 at 13:25 -0700, Linus Torvalds wrote:
>> On Sat, Jun 11, 2016 at 12:41 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>>>
>>> The QEMU people have accepted it as their bug and are fixing it.
>>
>> Of course they are. Somebody found a bug in their device model, I'd
>> expect nothing else.
>>
>> But I'm not worried about qemu. I'm worried about all the other=20
>> random devices that have never been tested.
>=20
> Most of the other devices that are likely to misbehave don't advertis=
e
> high levels of SCSI conformance, so we seem to be mostly covered.
>=20
And we have been running the very patch in SLES for over a year now,
without a single issue being reported.

>>>  There's no other course of action, really because we can't stop
>>> people
>>> sending this command using the BLOCK_PC interface from user space,
>>> so
>>> it's now a known and easy to use way of stopping the device from
>>> responding.
>>
>> Bah. That's not an argument from kernel space. We've had that=20
>> forever. Broken device that hangs up when you try to read past the=20
>> end? If you can open the raw device for reading, you can still do a
>> SCSI_IOCTL_SEND_COMMAND to send that read command past the end.
>>
>> The fact that you can craft special commands that can cause problems
>> for specific devices (if you have access to the raw device) does=20
>> *not* at all argue that the kernel should then do those accesses of=20
>> its own volition.
>>
>> My worry basically comes down to: we're clearly now doing something
>> that has never ever been tested by anybody before.
>>
Not quite. See above.

The reported issue came from someone who has been running the very
latest linux kernel in a VM which was hosted on an ancient version of
QEMU. Hardly a common scenario.

>> And I think that the assumption that the bug would magically be
>> limited to qemu is a *big* assumption.
>=20
> How do we ever find out if we don't test it, though?  I'm sure some
> obscure minor celebrity trying to get on the chat show circuit once
> said "what is userspace except a test case for the kernel?"
>=20
> If this is the only problem that turns up, I think we're done.  If we
> get any more we can consider either blacklisting all CD type devices =
or
> raising the conformance bar to SPC-3.
>=20
I'm fully with James here.
The alternative would be to whitelist _every_ conformant device,
resulting in lots of unhappy customers until we've got the whitelist
settled.

Having to discuss with customers why Linux doesn't follow the specs is
infinitely harder than discussing with customers whose _hardware_
doesn't follow the specs.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
