From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] ch: add refcounting
Date: Thu, 10 Apr 2014 16:12:57 +0200
Message-ID: <5346A6E9.9070801@suse.de>
References: <1396938437-29616-1-git-send-email-hare@suse.de> <20140410115157.GA8564@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934020AbaDJOM7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2014 10:12:59 -0400
In-Reply-To: <20140410115157.GA8564@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 04/10/2014 01:51 PM, Christoph Hellwig wrote:
>>  static int
>>  ch_release(struct inode *inode, struct file *file)
>>  {
>>  	scsi_changer *ch =3D file->private_data;
>> =20
>>  	scsi_device_put(ch->device);
>> +	ch->device =3D NULL;
>>  	file->private_data =3D NULL;
>> +	kref_put(&ch->ref, ch_destroy);
>=20
> Any reason you need to put the scsi_device here already?  Defering
> this would give you much eaiser life time rules, and no need to
> deal with a NULL ch->device ever.
>=20
Sure. But this would require a far more in-depth analysis of the
lifetime of the ch object, and most likely a far more intrusive
patch. You're welcome to do so :-)

This patch is just a minimal fix; I didn't dare to change too much
of the internals.

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
