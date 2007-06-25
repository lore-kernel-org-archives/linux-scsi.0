From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 16:03:56 +0200
Message-ID: <467FCB4C.6060907@suse.de>
References: <200706191025.30986.swen@vnet.ibm.com> <20070622044035.GB5560@us.ibm.com> <1182521500.3923.49.camel@mulgrave.il.steeleye.com> <200706251239.09755.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbXFYOEK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2007 10:04:10 -0400
In-Reply-To: <200706251239.09755.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Swen Schillig wrote:
> On Friday 22 June 2007 16:11, James Bottomley wrote:
>> On Thu, 2007-06-21 at 21:40 -0700, Mike Anderson wrote:
>>> James Bottomley <James.Bottomley@SteelEye.com> wrote:
>>>> A proposal to display the correct form of the LUN would be useful =
if you
>>>> wish to make it? ...  The problem is really that SAM specifies a
>>>> possible 4 level structure with 4 possible address methods per lev=
el.
>>>>
>>>> The well known LUNs should be simple; there are only three: Report=
 Lun,
>>>> Access Controls and Target Log Pages.  The rest we really need inp=
ut on.
>>>> For instance, I could see the vendors wishing us to combine a
>>>> multi-level flat addressing space into a single logical unit numbe=
r,
>>>> whereas I could see them wanting us to supply some sort of hierarc=
hy for
>>>> the peripheral and logical unit methods of addressing.
>>>>
>>>> Since you're already using 2 level flat addressing, how do you wan=
t to
>>>> see that represented?
>>> James, why would we would not want to display the lun per SAM4 4.6.=
2 as
>>> suggested by Stefan in a previous comment.
>> Because in a two LUN system, what was LUN 1 would then become LUN
>> 0x1000000000000 which looks a bit unpalatable.
>>
>> James
>>
>>
>> -
>=20
> Despite the issue whether we should display and/or use (sysfs !?)
> full blown 64bit values, so with leading zeros, you still have the op=
tion to display,=20
> for the single level addressing, the LUN as a 2 byte value as describ=
ed in  SAM4 4.6.2.=20
> So for your example this would be 0x0001 or 0x1, which is exactly wha=
t you'd like to see, right ?
> Only for 2+ level environment the 64bit representation comes into the=
 play.
>=20
> And, because you were asking how we'd like that to be represented, I =
personally prefer
> a full blown 64bit hex value with leading zeros.
> It makes the comparison to internal structures/models easier and gets=
 us a bit closer
> to the documented (SAM4) standard.
> ...and I think we all can deal with a few extra digits being displaye=
d.
>=20
Well ...
why don't we stick with the original implementation like zfcp had it?
We can simpley expand the midlayer to add an attribute 'lun'
to each scsi_device. This would be the LUN as returned by eg
REPORT LUNS.
No translation, nothing. Would be easy to implement and would allow
any administrator to map the h:c:i:l value to the 'real' lun.

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
