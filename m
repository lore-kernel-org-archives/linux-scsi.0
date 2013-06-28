From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Fri, 28 Jun 2013 09:42:47 +0200
Message-ID: <51CD3E77.60100@suse.de>
References: <1370862713-41323-1-git-send-email-hare@suse.de> <1370862713-41323-8-git-send-email-hare@suse.de> <51CD3B62.9010609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab3F1Hmt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 03:42:49 -0400
In-Reply-To: <51CD3B62.9010609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On 06/28/2013 09:29 AM, Bart Van Assche wrote:
> On 06/10/13 13:11, Hannes Reinecke wrote:
>> +static int sdev_eh_deadline(struct Scsi_Host *shost,
>> +               unsigned long eh_start)
>> +{
>> +    if (!shost->eh_deadline)
>> +        return 0;
>> +
>> +    if (shost->last_reset !=3D 0 &&
>> +        time_before(shost->last_reset, eh_start))
>> +        eh_start =3D shost->last_reset;
>> +
>> +    if (time_before(jiffies,
>> +            eh_start + shost->eh_deadline))
>> +        return 0;
>> +
>> +    return 1;
>> +}
>> +
>> +static int scsi_host_eh_deadline(struct Scsi_Host *shost)
>> +{
>> +    if (!shost->last_reset)
>> +        return 0;
>> +
>> +    return sdev_eh_deadline(shost, shost->last_reset);
>> +}
>=20
> Hello Hannes,
>=20
> I would appreciate if you would choose other names for these two
> functions and also for shost->eh_deadline. To me a deadline is a
> time instant. As far as I can see the two functions above check
> whether a deadline has been passed, and shost->eh_deadline is a time
> interval. How about the following names: sdev_eh_past_deadline(),
> shost_eh_past_deadline() and shost->max_eh_jiffies ?
>=20
Sure. I changed the naming once already, so I don't have any issues
with that.
And yes, the suggested naming does make more sense.

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
