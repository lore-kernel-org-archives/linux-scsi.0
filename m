From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] ALUA - rescan device capacity on zero sized block
 devices
Date: Thu, 11 Jun 2015 07:52:06 +0200
Message-ID: <55792206.3090505@suse.de>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>	 <552C008A.9070201@sandisk.com>	 <987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>	 <552CCC77.9040703@suse.de>	<552CE2C2.8000809@sandisk.com>	 <CABr-GnefEhc_dOKs360Hox7asbvO5qN8BqPczqC+V8CQ6Myh8w@mail.gmail.com>	 <55349580.1040205@suse.de> <1433948530.27387.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbFKFwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 01:52:08 -0400
In-Reply-To: <1433948530.27387.92.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>

On 06/10/2015 05:02 PM, Ewan Milne wrote:
> On Mon, 2015-04-20 at 07:58 +0200, Hannes Reinecke wrote:
>> On 04/19/2015 12:56 AM, Christophe Varoqui wrote:
>>> About five years ago, we faced a somewhat simular issue with
>>> Symmetrix arrays, where the replicated LU of a SRDF pair (R2) was
>>> flagged read-only by the kernel upon discovery. Splitting the pair
>>> with a symcli command  made the LU read-write from the array
>>> controller point of view, but the Linux kernel would not promote it
>>> read-write dynamically.
>>>
>>> I don't know if the Symmetrix array also use a unit attention to
>>> signal the change to the initiators. If it does, it might be worth
>>> trying to address both the 3par peer persistance and the Symmetrix
>>> SRDF situations.
>>>
>>> On the other hand, if the SRDF R2 rw promotion issue has been fixed
>>> since, the patch might give guidance about where/how to plug the
>>> 3par peer persistance ghost path rescans.
>>>
>> It's not only that; if you are faced with LUNs in standby even the
>> kernel wouldn't detect them properly.
>>
>> I'm currently debugging this issue and will have an update soon(-ish=
).
>=20
> I have a patch set to have the kernel automatically rescan the device
> when the ALUA state changes to an ACTIVE state, if it couldn't read
> capacity when the device was initially probed.  I've had it for a whi=
le,
> but I haven't had *any* response from the vendor if it actually works
> with their product, so I haven't posted it to the list for review yet=
=2E
>=20
Please hold off that patchset.

I've posted the ALUA update patchset a while ago, and are working on
including the suggestions from hch.

Please check if that patchset fixes the issue.

Additionally, I've got some patches for lio-target which will blank
out the READ CAPACITY command when in standby; with that one has an
easy testbed for this kind of issues.

> I did point out to them that the T10 spec does not *prohibit* support=
ing
> the READ CAPACITY command in the ALUA standby state, which would avoi=
d
> the problem, and is what other vendors seem to do.  However, they the=
n
> raised the issue that if the capacity changes in the standby state th=
en
> they should be generating the capacity changed UA, etc and you can so=
rt
> of see their point of why this gets complicated.
>=20
Which is actually not true. The capacity did _not_ change, it's just
the command which isn't supported. If the command was supported and
would have reported a size of '0' in standby _then_ it would have
been a capacity change. But that's not the case here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
