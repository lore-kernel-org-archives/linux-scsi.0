From: Ewan Milne <emilne@redhat.com>
Subject: Re: [dm-devel] ALUA - rescan device capacity on zero sized block
 devices
Date: Wed, 10 Jun 2015 11:02:10 -0400
Message-ID: <1433948530.27387.92.camel@localhost.localdomain>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
	 <552C008A.9070201@sandisk.com>
	 <987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>
	 <552CCC77.9040703@suse.de>	<552CE2C2.8000809@sandisk.com>
	 <CABr-GnefEhc_dOKs360Hox7asbvO5qN8BqPczqC+V8CQ6Myh8w@mail.gmail.com>
	 <55349580.1040205@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbbFJPCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:02:12 -0400
In-Reply-To: <55349580.1040205@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>

On Mon, 2015-04-20 at 07:58 +0200, Hannes Reinecke wrote:
> On 04/19/2015 12:56 AM, Christophe Varoqui wrote:
> > About five years ago, we faced a somewhat simular issue with
> > Symmetrix arrays, where the replicated LU of a SRDF pair (R2) was
> > flagged read-only by the kernel upon discovery. Splitting the pair
> > with a symcli command  made the LU read-write from the array
> > controller point of view, but the Linux kernel would not promote it
> > read-write dynamically.
> >=20
> > I don't know if the Symmetrix array also use a unit attention to
> > signal the change to the initiators. If it does, it might be worth
> > trying to address both the 3par peer persistance and the Symmetrix
> > SRDF situations.
> >=20
> > On the other hand, if the SRDF R2 rw promotion issue has been fixed
> > since, the patch might give guidance about where/how to plug the
> > 3par peer persistance ghost path rescans.
> >=20
> It's not only that; if you are faced with LUNs in standby even the
> kernel wouldn't detect them properly.
>=20
> I'm currently debugging this issue and will have an update soon(-ish)=
=2E

I have a patch set to have the kernel automatically rescan the device
when the ALUA state changes to an ACTIVE state, if it couldn't read
capacity when the device was initially probed.  I've had it for a while=
,
but I haven't had *any* response from the vendor if it actually works
with their product, so I haven't posted it to the list for review yet.

I did point out to them that the T10 spec does not *prohibit* supportin=
g
the READ CAPACITY command in the ALUA standby state, which would avoid
the problem, and is what other vendors seem to do.  However, they then
raised the issue that if the capacity changes in the standby state then
they should be generating the capacity changed UA, etc and you can sort
of see their point of why this gets complicated.

-Ewan

>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
