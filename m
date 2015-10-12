From: Hannes Reinecke <hare@suse.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Mon, 12 Oct 2015 14:45:38 +0200
Message-ID: <561BAB72.1070205@suse.de>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com> <20150925151802.GB20282@lst.de> <1443202278.2188.13.camel@HansenPartnership.com> <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org> <1443652494.2185.57.camel@HansenPartnership.com> <20151002125608.GB14899@lst.de> <1443792301.2209.4.camel@HansenPartnership.com> <20151002133423.GA15867@lst.de> <1443793497.2209.10.camel@HansenPartnership.com> <20151004074556.GA13932@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbbJLMpl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 08:45:41 -0400
In-Reply-To: <20151004074556.GA13932@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On 10/04/2015 09:45 AM, Christoph Hellwig wrote:
> On Fri, Oct 02, 2015 at 06:44:57AM -0700, James Bottomley wrote:
>> I think I prefer restoring that to having to build in every dh modul=
e to
>> get them to work.  If we take your proposed fix for the sync module =
load
>> in the current scheme, any non-built in modules would never attach, =
so
>> we'd be moving towards the conclusion that *every* device handler ha=
s to
>> be non-modular.
>=20
> You don't need to build every module in to make it work.  In 4.2 and =
earlier
> we already only auto load modules when dm-multipath explicitly attach=
es
> to them.  That will still work in 4.3+.  In fact we will now autoload
> when activating through sysfs as well.  With the change I sent to Pau=
l
> we still won't autoload at scan time, which would be really useful to=
 have,
> but wasn't implemented previously.
>=20
>> Skimming the code it looks like dh should be using the driver bindin=
g
>> model rather than reinventing it.  That would decouple it better and
>> make sure binding happened regardless of when the module was loaded.
>=20
> I tried this early on but gave up because I ran into too many problem=
s.
> I can try to give it a spin again.

You cannot easily use the driver model here as the scsi_device is
already (potentially) bound to the ULDs.
If you were to go with the driver model you'd have to introduce
another sub device between scsi_target and scsi_device.

Actually I have been thinking that, as it might make my life for the
ALUA handler easier. However, this would be quite a largish redesign
of the current handler infrastructure, pushing out my ALUA handler
update even more.
So I'd like to have the ALUA changes ironed out first and merged,
and then work on a redesigned device handler infrastructure.

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
