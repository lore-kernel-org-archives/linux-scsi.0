From: Hannes Reinecke <hare@suse.de>
Subject: Re: Is there any plan to support 64bit lun in mainline?
Date: Tue, 15 Oct 2013 08:01:14 +0200
Message-ID: <525CDA2A.2060308@suse.de>
References: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com>  <525BC836.2030306@suse.de> <1381775449.3752.9.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3JOGBS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Oct 2013 02:01:18 -0400
In-Reply-To: <1381775449.3752.9.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On 10/14/2013 08:30 PM, James Bottomley wrote:
> On Mon, 2013-10-14 at 12:32 +0200, Hannes Reinecke wrote:
[ .. ]
>>
>> However, there are two other patchsets pending (EH Deadline and
>> asynchronous command aborts), both of which have been tested
>> thoroughly _and_ have acked-by from various other parties.
>> None of these patchset had received any feedback from James
>> Bottomley, let alone any indication if or when they'll be merged.
>>
>> So I stopped sending further patchsets, sensing some communication
>> breakdown on the line.
>=20
> There's no communications breakdown, I've just been very busy.  EH
> deadline looks OK, but let me look again to make sure.  Async aborts =
I'm
> not necessarily keen on because I know a lot of devices where abortin=
g
> just confuses the firmware more, so I think skipping aborts and movin=
g
> to LUN reset might be a better form of acceleration.
>=20

Hmm. I've made exactly the opposite experience with FC devices.
A faulty SFP or wiring might cause the occasional frame drop, which
will be happily corrected with an ABTS.
And HBAs like lpfc or qla2xxx even have a fast command abort built
into the firmware, where the firmware will not even wait for a
command abort to hit the wire but rather just disable the exchange
internally and return.
_Not_ sending an abort but rather escalating directly to LUN reset
will only make matters worse here.
Plus a LUN reset won't be able to fix anything here.

But sure, if there are some devices which are confused by aborts,
sure we should be doing something about it.
Just out of curiosity, which devices are we talking about?

I would very much prefer to have inlined command aborts at least for
=46C, as it has proven to be really beneficial there.

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
