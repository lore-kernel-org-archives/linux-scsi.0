From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Wed, 03 Dec 2014 17:28:40 +0100
Message-ID: <547F3A38.6070908@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>	 <20141203152141.GA6175@lst.de>	 <201412031634.48711.linux@rainbow-software.org> <1417621350.2206.3.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaLCQ2l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 11:28:41 -0500
In-Reply-To: <1417621350.2206.3.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "linux@rainbow-software.org" <linux@rainbow-software.org>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "matthew@wil.cx" <matthew@wil.cx>

On 12/03/2014 04:42 PM, James Bottomley wrote:
> On Wed, 2014-12-03 at 16:34 +0100, Ondrej Zary wrote:
>> On Wednesday 03 December 2014, Christoph Hellwig wrote:
>>> Thanks for looking into this old driver.
>>>
>>> If you've got a few spare cycles it might make sense to simply spli=
t
>>> the "wide board" support out - the driver literally is two differen=
t
>>> drivers with an if/else section in every method for the totally
>>> different narrow vs wide boards.  Having at least a clean and simpl=
e
>>> driver for the newer wide boards would be good, and narrow ones are
>>> probably old enough that we can let the driver for those fade away.=
=2E
>>
>> I have an ASB-3940UA (bought around 2000) and use it for scanner so =
I can test=20
>> patches.
>> The driver was working fine so I never had to look at the code. Now =
I see that=20
>> it's 12K lines long :( Converting that to something simple would req=
uire a=20
>> lot of work.
>=20
> That's the problem: The driver as-is works in all of the use cases, s=
o
> no-one has any motivation to fix it.  Plus the complexity is pretty
> daunting.  It's not even the worst driver we have (that prize goes to
> atp870u which still has internal bus scanning code).  I'm not saying
> don't do the conversion, but I am saying it will have to be validated
> and tested before it can go in because lots of people still seem to u=
se
> this family of devices in odd corners of the world.
>=20
It was actually on my mind, too, to split the driver up.
The code for the narrow board has some issues even today (I've
inserted some remarks in the code) which always get in the way when
trying to update the other side.

But then I only got a wide board, so I couldn't do any testing
there; I was sort of banking on Matt Wilcox to have a board
available ...

Ondrej, if you got a narrow board I'd be willing to to the split and
let you test out the result.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
