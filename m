From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] dm-mpath: Allow 'default' hardware handler
Date: Mon, 02 Apr 2012 19:07:48 +0200
Message-ID: <4F79DCE4.9050804@suse.de>
References: <1333385035-6663-1-git-send-email-hare@suse.de> <1333385035-6663-3-git-send-email-hare@suse.de> <20120402170426.GA28901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2DBRHq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2012 13:07:46 -0400
In-Reply-To: <20120402170426.GA28901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 04/02/2012 07:04 PM, Mike Snitzer wrote:
> On Mon, Apr 02 2012 at 12:43pm -0400,
> Hannes Reinecke <hare@suse.de> wrote:
>=20
>> This patch introduces a 'default' hardware handler for dm-mpath.
>> When specifying '1 default' dm-multipath will be using the currently
>> attached hardware handler.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/md/dm-mpath.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>> index 922a338..bbf950f 100644
>> --- a/drivers/md/dm-mpath.c
>> +++ b/drivers/md/dm-mpath.c
>> @@ -586,15 +586,19 @@ static struct pgpath *parse_path(struct dm_arg=
_set *as, struct path_selector *ps
>> =20
>>  	if (m->hw_handler_name) {
>>  		struct request_queue *q =3D bdev_get_queue(p->path.dev->bdev);
>> +		char *hw_handler =3D NULL;
>> =20
>> -		r =3D scsi_dh_attach(q, m->hw_handler_name);
>> +		if (strncmp(m->hw_handler_name, "default", 6))
>> +			hw_handler =3D m->hw_handler_name;
>=20
> Should be: if (strncmp(m->hw_handler_name, "default", 7))
A-hem.

Counting by hand is at times tricky.
I'll be sending an updated patchset.

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
