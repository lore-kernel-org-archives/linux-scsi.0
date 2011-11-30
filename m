From: Hannes Reinecke <hare@suse.de>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 30 Nov 2011 08:25:02 +0100
Message-ID: <4ED5DA4E.5060500@suse.de>
References: <20111031100557.GA2621@osiris.boeblingen.de.ibm.com> <1320057746.2964.1.camel@dabdike> <4EAE8A7E.8000504@ce.jp.nec.com> <20111031130004.GB4768@osiris.boeblingen.de.ibm.com> <20111103182548.GA12131@redhat.com> <20111104091936.GB2397@osiris.boeblingen.de.ibm.com> <4EBA49C2.1000704@suse.de> <20111110161008.GA15659@osiris.boeblingen.de.ibm.com> <20111117162919.GA3812@redhat.com> <20111129120047.GA2456@osiris.boeblingen.de.ibm.com> <20111129201803.GB6827@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab1K3HZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 02:25:09 -0500
In-Reply-To: <20111129201803.GB6827@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com, dm-devel@redhat.com

On 11/29/2011 09:18 PM, Mike Snitzer wrote:
> On Tue, Nov 29 2011 at  7:00am -0500,
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
>=20
>>>>> Hmm. Just to be on the safe side, could you try this one:
>>>>>
>>>>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>>>>> index 5e0090e..e6fad46 100644
>>>>> --- a/drivers/md/dm-mpath.c
>>>>> +++ b/drivers/md/dm-mpath.c
>>>>> @@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *t=
i,
>>>>> struct reque
>>>>> st *clone,
>>>>>         map_context->ptr =3D mpio;
>>>>>         clone->cmd_flags |=3D REQ_FAILFAST_TRANSPORT;
>>>>>         r =3D map_io(m, clone, mpio, 0);
>>>>> -       if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE)
>>>>> +       if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE) {
>>>>>                 mempool_free(mpio, m->mpio_pool);
>>>>> +               map_context->ptr =3D NULL;
>>>>> +       }
>>>>>
>>>>>         return r;
>>>>>  }
>>>>
>>>> With your patch we haven't been able to reproduce the kernel crash=
 until now.
>>>> Now we "only" run into I/O stalls, which before your patch we also=
 did. But
>>>> repeatedly rebooting and retrying and ignoring the I/O stalls alwa=
ys lead to
>>>> a crash.
>>>> Gonzalo will run a couple of extra rounds so we can have a feeling=
 if at least
>>>> one of the bugs could be fixed with your patch ;)
>>>
>>> Hi,
>>>
>>> Any update after further testing with Hannes' patch?
>>
>> Sorry for the late update, our internal IBM IMAP servers have been d=
own
>> for nearly a week :/
>>
>> So, we were unable to reproduce the original bug with the patch appl=
ied
>> during various runs.
>=20
> OK, so it seems to be a benenficial change (and obviously correct to
> me).  Hannes, care to formally post your fix to dm-devel so we can ge=
t
> it in 3.2-rc?
>=20
Yep, will do.

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
