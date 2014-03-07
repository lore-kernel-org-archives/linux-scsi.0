From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 07 Mar 2014 11:35:34 +0100
Message-ID: <5319A0F6.8000100@suse.de>
References: <1392286032-85036-1-git-send-email-hare@suse.de> <1392286032-85036-3-git-send-email-hare@suse.de> <20140228170131.GA31510@infradead.org> <5316D459.6070107@suse.de> <20140305194255.GA5607@infradead.org> <53183951.7080805@suse.de> <20140307101118.GA32333@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaCGKfg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2014 05:35:36 -0500
In-Reply-To: <20140307101118.GA32333@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 03/07/2014 11:11 AM, Christoph Hellwig wrote:
> On Thu, Mar 06, 2014 at 10:01:05AM +0100, Hannes Reinecke wrote:
>> I am somewhat reluctant here.
>>
>> Adding separate flags like 'support_vpd_pg83' is a bit pointless,
>> given that we might as well check for vpg_pg83.
>>
>> So the only 'proper' solution would be to add a bitmap of supported
>> pages; however, this would be 256 bits =3D 32 bytes of additional
>> space required for struct sdev.
>> Which I'm a bit reluctant do to, as it'll be a sparse array in most
>> cases, adding to quite some wasted space.
>=20
> Might want to keep it a local bitmap for now, but I suspect we'll
> want it exposed sooner or later.
>=20
Agree. But for now I'd like to keep it as it is (ie without bitmap);
there is no real benefit for just the two pages we're exposing right
now.

Or, to be precise, we _might_ be exporting if those patches ever go
upstream :-(

Having any indication here would be good.
Can't we have a patch handling session at LSF?
It really is no fun, having tons of patches and no idea whether they
ever make it upstream.

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
