From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libfc: unsafe refcounting in fc_rport_work()
Date: Mon, 25 Apr 2016 10:01:27 +0200
Message-ID: <571DCED7.1030107@suse.de>
References: <1461158661-97688-1-git-send-email-hare@suse.de>
 <1461178992.14609.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbcDYIB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 04:01:29 -0400
In-Reply-To: <1461178992.14609.12.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 04/20/2016 09:03 PM, James Bottomley wrote:
> On Wed, 2016-04-20 at 15:24 +0200, Hannes Reinecke wrote:
>> When pushing items on a workqueue we cannot take reference
>> when the workqueue item is executed, as the structure might
>> already been freed at that time.
>> So instead we need to take a reference before adding it
>> to the workqueue, thereby ensuring that the workqueue item
>> will always be valid.
>=20
> Have you actually seen this happen?  The rdata structure is fully ref
> counted, so if it's done a final put, then something should see
> unreferenced memory.  It looks like the model is that the final put i=
s
> done from the queue, so I don't quite see how you can lose the final
> reference in either of the places you alter.
>=20
Yes, I _did_ see this happen; a customer was complaining about a
soft lockup happening in fc_rport_timeout every 30 seconds.

> Plus, kref_get_unless_zero() should not be used.  At that point, the
> structure would be freed, so there's no point looking for it.=20
>  kref_get_unless_zero is for refcounts that don't necessarily free th=
e
> structure (embedded ones).
>=20
Yes, you are right; turns out to be a problem with mutexes and krefs
in general (cf https://lkml.org/lkml/2015/2/11/245).

I'll be sending a new patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
