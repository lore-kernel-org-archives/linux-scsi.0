From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Thu, 06 Mar 2014 10:01:05 +0100
Message-ID: <53183951.7080805@suse.de>
References: <1392286032-85036-1-git-send-email-hare@suse.de> <1392286032-85036-3-git-send-email-hare@suse.de> <20140228170131.GA31510@infradead.org> <5316D459.6070107@suse.de> <20140305194255.GA5607@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaCFJBH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2014 04:01:07 -0500
In-Reply-To: <20140305194255.GA5607@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 03/05/2014 08:42 PM, Christoph Hellwig wrote:
> On Wed, Mar 05, 2014 at 08:38:01AM +0100, Hannes Reinecke wrote:
>>> Either way I think the call to query evpd 0 should be a separate
>>> function, so even if we don't store the information it's abstracted=
 out.
>>>
>> Hmm. That would work if we were just asking for a single page; but
>> when we're checking several pages (like 0x83 and 0x80) we'd need
>> either to pass in a page array or querying page 0 several times.
>> Neither of which is very appealing.
>>
>> However, specifying additional flags for the individual pages might
>> work. I'll see what I can come up with.
>=20
> Passing in a bitmask or flags seems useful.  Even better storing it i=
n the
> scsi_device.  Note that I expect the place that need to know the EVPD
> patch to grow slowly but steadily over time.
>=20
I am somewhat reluctant here.

Adding separate flags like 'support_vpd_pg83' is a bit pointless,
given that we might as well check for vpg_pg83.

So the only 'proper' solution would be to add a bitmap of supported
pages; however, this would be 256 bits =3D 32 bytes of additional
space required for struct sdev.
Which I'm a bit reluctant do to, as it'll be a sparse array in most
cases, adding to quite some wasted space.

Thoughts?

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
