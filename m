From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 07 Mar 2014 11:51:00 +0100
Message-ID: <5319A494.6020308@suse.de>
References: <1392286032-85036-1-git-send-email-hare@suse.de>	 <1392286032-85036-3-git-send-email-hare@suse.de>	 <20140228170131.GA31510@infradead.org> <5316D459.6070107@suse.de>	 <20140305194255.GA5607@infradead.org> <53183951.7080805@suse.de> <1394188779.5225.40.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaCGKvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2014 05:51:01 -0500
In-Reply-To: <1394188779.5225.40.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "kay@vrfy.org" <kay@vrfy.org>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On 03/07/2014 11:39 AM, James Bottomley wrote:
> On Thu, 2014-03-06 at 10:01 +0100, Hannes Reinecke wrote:
>> So the only 'proper' solution would be to add a bitmap of supported
>> pages; however, this would be 256 bits =3D 32 bytes of additional
>> space required for struct sdev.
>> Which I'm a bit reluctant do to, as it'll be a sparse array in most
>> cases, adding to quite some wasted space.
>=20
> Why per sdev?  Isn't it per target?  The supported EVPD page list
> shouldn't really vary for luns of the same target unless something ve=
ry
> strange is happening in the array.
>=20
Spec says it's per LUN:

7.8.16 Supported VPD Pages VPD page
The Supported VDP Pages VPD page contains a list of the VPD page
codes supported by the logical unit (see
table 637).

so we shouldn't really make any assumptions about what might be
sensible or strange.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
