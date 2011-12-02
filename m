From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-mpath: Clear map_context pointer when requeuing
Date: Fri, 02 Dec 2011 17:19:27 +0100
Message-ID: <4ED8FA8F.20109@suse.de>
References: <1322663118-53387-1-git-send-email-hare@suse.de> <20111130144951.GA13775@redhat.com> <4ED6C67A.3060305@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab1LBQTc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2011 11:19:32 -0500
In-Reply-To: <4ED6C67A.3060305@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com

Hi Jun'ichi,

On 12/01/2011 01:12 AM, Jun'ichi Nomura wrote:
> Hi Hannes,
>=20
> On 11/30/11 23:49, Mike Snitzer wrote:
>> On Wed, Nov 30 2011 at  9:25am -0500,
>> Hannes Reinecke <hare@suse.de> wrote:
>>
>>> When requeing a request we should be clearing the map_context
>>> pointer, otherwise we might access an invalid memory location.
>=20
> Could you elaborate on the mechanism how the map_context->ptr
> (=3D mpio) is accessed after freeing it?
>=20
In short: No. Pure guesswork :-)

The longer answer here is that 'map_context' is managed by the
caller for multipath_map().
So in theory the caller is free to re-use the map_context whenever
'clone' is in use.
So if 'clone' is terminated when it's still requeued the caller
might be calling multipath_end_io(), at which point map_context->ptr
will be pointing to an invalid memory location.

But as I said, this is not a detailed analysis. It's good enough
for me that it solves the problem :-)

> mpio is known to be non-NULL where it is used. So clearing the pointe=
r
> should not make any difference in logic.
>=20
It does, see above.

> If this is a preventive change so that we can see NULL dereference
> instead of random invalid access if anything happens, it should be
> noted in the patch description and in the code.
> Otherwise, somebody looking at the code/change in future might be
> confused: "why we have to clear this pointer?"
>=20
> And there are other places where mpio is freed.
> (E.g. in dispatch_queued_ios() in dm-mpath.c)
> Don't we need the same change there?
>=20
I don't think so. It's just from multipath_map() where we need to
ensure map_context->ptr is correct. All the other places will not
touch the map_context->ptr again.

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
