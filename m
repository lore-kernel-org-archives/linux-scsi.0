From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/8] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Fri, 28 Feb 2014 08:24:50 +0100
Message-ID: <531039C2.5000307@suse.de>
References: <1382518282-107606-1-git-send-email-hare@suse.de> <1382518282-107606-8-git-send-email-hare@suse.de> <5310344D.8090400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaB1HYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 02:24:52 -0500
In-Reply-To: <5310344D.8090400@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 02/28/2014 08:01 AM, Ren Mingxin wrote:
> Hi, Hannes:
>=20
> On 10/23/2013 04:51 PM, Hannes Reinecke wrote:
>> This patchs adds an 'eh_deadline' sysfs attribute to the scsi
>> host which limits the overall runtime of the SCSI EH.
>=20
> As you known, adding to scsi host means such interface has also been
> added to the SATA and USB controllers. But to users, I think it is
> possible that there are 3 confusing points below:
>=20
> 1) There should not be this sysfs interface for SATA controllers, for
>    such interface will not work under SATA's own EH policy;
> 2) There should not be this sysfs interface for USB controllers,
>    because probably they will not consider EH recovery to USB ones;
> 3) They are not willing to affect SATA/USB controllers(even if their
>    sysfs interfaces) while setting global interafce by assigning scsi
>    module parameter.
>=20
> I was thinking how to mask SATA/USB controllers, but havn't a perfect
> solution so far, for it seems that it is not clever enough to mask
> them in each controller driver. Do you have any idea about above?
>=20
Yes, I have.

I've send a patchset titled 'Display EVPD pages in sysfs', which
introduces the ability to mask individual (device) attributes.
The same mechanism can easily be used for host attributes.

James B indicated that those patches might be okay for inclusion,
but so far nothing has happened with them.
I'll ping him again.

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
