From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Tue, 02 Jul 2013 07:48:08 +0200
Message-ID: <51D26998.2050506@suse.de>
References: <1372661455-122384-1-git-send-email-hare@suse.de> <20130701174423.GA10645@logfs.org> <1372706605.2385.37.camel@dabdike> <20130701205546.GB10645@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3GBFsL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jul 2013 01:48:11 -0400
In-Reply-To: <20130701205546.GB10645@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>

On 07/01/2013 10:55 PM, J=C3=B6rn Engel wrote:
> On Mon, 1 July 2013 19:23:25 +0000, James Bottomley wrote:
>> On Mon, 2013-07-01 at 13:44 -0400, J=C3=B6rn Engel wrote:
>>> If a single device is bad, don't ever do a host
>>> reset.
>>
>> This isn't a tenable position.  Sometimes a device looks bad because=
 the
>> host state for it has gone insane.  At that point, the only safe act=
ion
>> is a reset of the host to sane state.
>>
>> I could be persuaded that you should never do the transport equivale=
nt
>> of a bus reset (on non-SPI transports, at least), which is actually =
hard
>> to do on some of the modern transports, but I don't think you can ge=
t
>> away without having a host reset in the eh arsenal.
>=20
> Fair enough.  Hardware being hardware and hardware bugs being hard to
> fix, I see your point.
>=20
> However, we shouldn't screw the poor user who has paid a premium for =
a
> second HBA to get some redundancy and reset both of them at the same
> time.  That would, you know, defeat the redundancy. ;)
>=20
Which would arguably a setup issue.

We've had SAN issues where the HBA lost track of the remote port
state (RSCNs being eaten by the switch firmware), so the only chance
of recovery was indeed a host reset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
