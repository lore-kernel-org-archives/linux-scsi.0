From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag support
 for internal command indexing
Date: Tue, 21 Apr 2015 12:26:51 +0200
Message-ID: <553625EB.3060404@suse.de>
References: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbbDUK0x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:26:53 -0400
In-Reply-To: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
> megaraid_sas driver will use block layer provided tag for indexing in=
ternal MPT frames to get any unique MPT frame tied with tag.
> Each IO request submitted from SCSI mid layer will get associated MPT=
 frame from MPT framepool (retrieved and return back using spinlock
> inside megaraid_sas driver's submission/completion call back). Gettin=
g MPT frame from MPT Frame pool is very expensive operation because=20
> of associated spin lock operation (spinlock overhead increase on mult=
i NUMA node). This type of locking in driver is very expensive
> call considering each IO request need - Acquire and Release of the sa=
me lock.
>=20
> With this support, in IO path driver will directly provide the unique=
 command index(which is based on block layer tag)
> and will get the MPT frame tied to the tag and this way driver can ge=
t rid off lock, which synchronizes the access to MPT frame pool=20
> while fetching and returning MPT frame from the pool.
>=20
> This support in driver provides siginificant performance improvement(=
on multi NUMA node system)on latest upstream with SCSI.MQ
> as well as on existing linux distributions.
> Here is the data for test executed at Avago-
> - IO Tool- FIO
> - 4 Socket SMC server. (4 NUMA node server)
> - 12 SSDs in JBOD mode .
> - 4K Rand READ, QD=3D32
> - SCSI MQ x86_64 (Latest Upstream kernel)
> - upto 300% Performance Improvement.
>=20
> If IOs are running on single Node, perfromance gain is less, but as s=
oon as increase number of nodes, performance improvement
> is significant. IOs running on all 4 NUMA nodes, with this patch appl=
ied IOPs observed was  1170K vs 344K IOPs seen without this patch.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
