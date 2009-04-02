From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/7] libiscsi: fix iscsi pool error path
Date: Thu, 02 Apr 2009 10:15:22 -0500
Message-ID: <49D4D68A.8080606@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu> <12386094922477-git-send-email-michaelc@cs.wisc.edu> <12386094933319-git-send-email-michaelc@cs.wisc.edu> <200904021602.55587.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51398 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZDBPQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 11:16:25 -0400
In-Reply-To: <200904021602.55587.jdelvare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-scsi@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

Jean Delvare wrote:
> Hi Mike,
>=20
> Sorry for the late answer, I have been traveling for the last 2 days.
>=20
> Le mercredi 01 avril 2009, michaelc@cs.wisc.edu a =C3=A9crit :
>> From: Jean Delvare <jdelvare@suse.de>
>>
>> Le lundi 30 mars 2009, Chris Wright a =C3=A9crit :
>>> q->queue could be ERR_PTR(-ENOMEM) which will break unwinding
>>> on error.  Make iscsi_pool_free more defensive.
>>>
>> Making the freeing of q->queue dependent on q->pool being set looks
>> really weird (although it is correct at the moment. But this seems
>> to be fixable in a much simpler way.
>>
>> With the benefit that only the error case is slowed down. In both
>> cases we have a problem if q->queue contains an error value but it's
>> not -ENOMEM. Apparently this can't happen today, but it doesn't feel
>> right to assume this will always be true. Maybe it's the right time
>> to fix this as well.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>  drivers/scsi/libiscsi.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index dfaa8ad..6896283 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -1999,8 +1999,10 @@ iscsi_pool_init(struct iscsi_pool *q, int max=
, void ***items, int item_size)
>> =20
>>  	q->queue =3D kfifo_init((void*)q->pool, max * sizeof(void*),
>>  			      GFP_KERNEL, NULL);
>> -	if (q->queue =3D=3D ERR_PTR(-ENOMEM))
>> +	if (IS_ERR(q->queue)) {
>=20
> This indeed solves the problem I had underlined before, but
> introduces a new one. Right now the only error returned by kfifo_init
> is -ENOMEM. This may however change in the future, and then the
> above code would silently convert the other error code to -ENOMEM.
> This might make it difficult to trace errors.

What do you mean by converting other errors codes to -ENOMEM?

>=20
> I know this is all just theoretical, at the moment your code is
> correct, but I don't much like relying on assumptions which are not
> guaranteed to last. So I would rather cleanly transmit the error code
> up to the caller, or change the calling convention of kfifo_init() to

What do you mean by cleanly transmitting the error code up the caller?



> return NULL on error. The former will add a few lines of code, the
> latter will result in faster code but is obviously more intrusive.
> The latter might also be undesirable for some reason I am
> overlooking; I'm really not familiar with kfifo.
>=20
> Or you can consider I am too perfectionist and ignore me and go with
> the current fix, that's also fine with me ;)
>=20

I think it is fine for now. We really do  not care what the error is. I=
f=20
it fails, it fails. If kfifo_init() were to return some new error code=20
for different errors we would have to evaluate the kfifo_init() change=20
as well as the iscsi code to made sure we could handle it or not, until=
=20
then it is safest to fail on all errors instead of possible limping=20
along and possibly causing corruption.

I am also going to remove iscsi's use of kfifos in the next feature win=
dow.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
