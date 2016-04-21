From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH] libfc: unsafe refcounting in fc_rport_work()
Date: Thu, 21 Apr 2016 14:39:27 +0200
Message-ID: <20160421123927.GO28402@c203.arch.suse.de>
References: <1461158661-97688-1-git-send-email-hare@suse.de>
 <1461178992.14609.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbcDUMjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2016 08:39:31 -0400
Content-Disposition: inline
In-Reply-To: <1461178992.14609.12.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Apr 20, 2016 at 03:03:12PM -0400, James Bottomley wrote:
> On Wed, 2016-04-20 at 15:24 +0200, Hannes Reinecke wrote:
> > When pushing items on a workqueue we cannot take reference
> > when the workqueue item is executed, as the structure might
> > already been freed at that time.
> > So instead we need to take a reference before adding it
> > to the workqueue, thereby ensuring that the workqueue item
> > will always be valid.
>=20
> Have you actually seen this happen?  The rdata structure is fully ref
> counted, so if it's done a final put, then something should see
> unreferenced memory.  It looks like the model is that the final put i=
s
> done from the queue, so I don't quite see how you can lose the final
> reference in either of the places you alter.
>=20

I _think_ I have seen this, however I'm not 100% certain. What I can sa=
y
is, I have crash dumps of lpfc, fnic and bnx2fc with either no longer
vaild pointers (use after free) or overwritten pointers (one has ASCII
'O' 'W' 'N' written to it), but I never have had a chance to reproduce
them in a test environment. It's even possible that these are all total=
ly
unrelated issues, again, I'm not certain at all.

Byte,
	Johannes
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
