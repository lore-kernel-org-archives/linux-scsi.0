From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 19/43] hpsa: add ioaccel sg chaining for the ioaccel2
 path
Date: Thu, 23 Apr 2015 07:50:41 +0200
Message-ID: <55388831.90109@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134827.30238.67380.stgit@brunhilda> <55310729.1040304@suse.de> <07F70BBF6832E34FA1C923241E8833AB4869FBD3@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbDWFur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 01:50:47 -0400
In-Reply-To: <07F70BBF6832E34FA1C923241E8833AB4869FBD3@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brace <brace@pmcs.com>, Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, Justin Lindley <Justin.Lindley@pmcs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/22/2015 09:12 PM, brace wrote:
> The last I read about mempools was from:
> Linux Device Drivers
>  By Jonathan Corbet, Alessandro Rubini, Greg Kroah-Hartman
>=20
> https://lwn.net/images/pdf/LDD3/ch08.pdf
>=20
>=20
> If  you  are  considering  using  a  mempool  in  your  driver,  plea=
se  keep  one  thing  in
> mind: mempools allocate a chunk of memory that sits in a list, idle a=
nd unavailable
> for any real use. It is easy to consume a great deal of memory with m=
empools. In
> almost every case, the preferred alternative is to do without the mem=
pool and simply
> deal with the possibility of allocation failures instead. If there is=
 any way for your
> driver to respond to an allocation failure in a way that does not end=
anger the integ-
> rity of the system, do things that way. Use of mempools in driver cod=
e should be
> rare
>=20
> But this book is now quite old in Linux terms.
>=20
> So, I can investigate using mempools. However, I would prefer to cont=
inue using the existing methods in this current patchset.
>=20
> I hope that is ok with you...
>=20
Yes, that's okay with me.

Personally I would be using mempools when you need lots of small,
frequently changed allocations (like sg elements), and kzalloc() for
large or infrequently changed bits of memory.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
