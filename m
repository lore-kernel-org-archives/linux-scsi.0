From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Thu, 25 Oct 2007 08:31:17 +0200
Message-ID: <47203835.30404@suse.de>
References: <20071019083239.D88FE18C61E@pentland.suse.de>	 <1192983563.3339.4.camel@localhost.localdomain>	 <20071022034605.GB8421@parisc-linux.org> <471C4845.20708@suse.de>	 <20071022112345.GC8421@parisc-linux.org>  <471C9030.6030700@suse.de> <1193158612.6294.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXJYGbV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 02:31:21 -0400
In-Reply-To: <1193158612.6294.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-10-22 at 13:57 +0200, Hannes Reinecke wrote:
>> Matthew Wilcox wrote:
>>> On Mon, Oct 22, 2007 at 08:50:45AM +0200, Hannes Reinecke wrote:
>>>> That's what I thought, too. Hence the patch.
>>>> But if we set the default to 16 byte cdbs you can of course ignore
>>>> the patch.
>>> I think the comment in hosts.c explains why we shouldn't do that ..=
=2E
>>>
>> _I_ certainly wouldn't. But if the maintainer says so :-)
>=20
> Actually, I misremembered.  I thought I did a commit a few years ago
> that automatically raised the cutoff to 16 byte cdbs and forced drive=
rs
> who couldn't do that to lower the limit, but apparently it was never
> merged.
>=20
> So, just pick either 16 or 32 for both drivers and add that as the ma=
x
> cdb size.
>=20
Hmm. But aic7xxx actually supports 32-byte cdbs (for whatever reason);
cf drivers/scsi/aic7xxx/aic7xxx.h:478.
And aic79xx only supports 16 byte cdbs; the clever 'use pointer for cdb
if it's longer than the 12 bytes' routine sadly isn't implemented
for aic79xx.

It somehow feels wrong to arbitrarily cut the limit to 16 bytes for
aic7xxx, hence the two different limits.

But again, you're the maintainer, you get to decide.
If you feel it's reasonable to limit both to 16 byte so be it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
