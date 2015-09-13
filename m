From: Hannes Reinecke <hare@suse.de>
Subject: Re: randconfig build error with next-20150908, in
 drivers/md/dm-mpath.c
Date: Sun, 13 Sep 2015 16:29:38 +0200
Message-ID: <55F58852.7070108@suse.de>
References: <CA+r1ZhgR=dO0ezk0Nm0JuAb1D0AU7K2Am=Pyy9aPqCMsLW9Y0w@mail.gmail.com>
 <20150908172356.GA1584@redhat.com> <1441733672.5932.1.camel@Odin.com>
 <20150908183021.GA3019@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbbIMO3o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Sep 2015 10:29:44 -0400
In-Reply-To: <20150908183021.GA3019@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, James Bottomley <jbottomley@odin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "jim.epost@gmail.com" <jim.epost@gmail.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On 09/08/2015 08:30 PM, Mike Snitzer wrote:
> On Tue, Sep 08 2015 at  1:34pm -0400,
> James Bottomley <jbottomley@odin.com> wrote:
>=20
>> On Tue, 2015-09-08 at 13:23 -0400, Mike Snitzer wrote:
>>> On Tue, Sep 08 2015 at  1:10pm -0400,
>>> Jim Davis <jim.epost@gmail.com> wrote:
>>>
>>>> Building with the attached random configuration file,
>>>>
>>>> drivers/built-in.o: In function `activate_path':
>>>> /home/jim/linux-next/drivers/md/dm-mpath.c:1225: undefined referen=
ce
>>>> to `scsi_dh_activate'
>>>> drivers/built-in.o: In function `parse_path':
>>>> /home/jim/linux-next/drivers/md/dm-mpath.c:581: undefined referenc=
e to
>>>> `scsi_dh_attached_handler_name'
>>>> /home/jim/linux-next/drivers/md/dm-mpath.c:600: undefined referenc=
e to
>>>> `scsi_dh_attach'
>>>> /home/jim/linux-next/drivers/md/dm-mpath.c:615: undefined referenc=
e to
>>>> `scsi_dh_set_params'
>>>
>>> These DM-mpath changes were staged via linux-scsi.  Cc'ing James an=
d Christoph.
>>
>> [adding linux-scsi]
>>
>> It must be Hannes' dm changes ... you acked them.  I take it the pro=
blem
>> is now dm-mpath won't build without CONFIG_SCSI?  How do you want it
>> fixed?  We can either add a Kconfig dependency or try to disentangle
>> them again.
>=20
> OK (Hannes' changes).  I'm fine with seeing DM_MULTIPATH depend on
> CONFIG_SCSI.
>=20
Indeed, with the switch for having scsi_dh being moved into struct
scsi_device DM_MULTIPATH will now depend on SCSI.

> The Kconfig for DM_MULTIPATH is clearly stale:
>=20
>         # nasty syntax but means make DM_MULTIPATH independent
>         # of SCSI_DH if the latter isn't defined but if
>         # it is, DM_MULTIPATH must depend on it.  We get a build
>         # error if SCSI_DH=3Dm and DM_MULTIPATH=3Dy
>         depends on SCSI_DH || !SCSI_DH
>=20
> James, if you have a vision for how to fix this please feel free.
> Otherwise, Hannes, care to send a patch to fix this?
>=20
Yep, once I'm back in the office on Monday.

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
