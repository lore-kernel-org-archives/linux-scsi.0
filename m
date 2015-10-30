From: Hannes Reinecke <hare@suse.de>
Subject: Re: Blk-mq/scsi-mq Tuning
Date: Fri, 30 Oct 2015 08:44:59 +0100
Message-ID: <56331FFB.9010703@suse.de>
References: <D256A425.229C0%chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbJ3HpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 03:45:02 -0400
In-Reply-To: <D256A425.229C0%chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>

On 10/28/2015 09:11 PM, Chad Dupuis wrote:
> Hi Folks,
>=20
> We=B9ve begun to explore blk-mq and scsi-mq and wanted to know if the=
re were
> any best practices in terms of block layer settings.  We=B9re looking
> specifically at the FCoE and iSCSI protocols.
>=20
> A little background on the queues in our hardware first: we have a pe=
r
> connection transmit queue and multiple, global receive queues.  The
> transmit queues are not pegged to a particular CPU.  The receive queu=
es
> are pegged to the first N CPUs where N is the number of receive queue=
s.
> We set the nr_hw_queues in the scsi_host_template to N as well.
>=20
Weelll ... I think you'll run into issues here.
The whole point of the multiqueue implementation is that you can tag th=
e
submission _and_ completion queue to a single CPU, thereby eliminating
locking.
If you only peg the completion queue to a CPU you'll still have
contention on the submission queue, needing to take locks etc.

Plus you will _inevitably_ incur cache misses, as the completion will
basically never occur on the same CPU which did the submissoin.
Hence the context needs to be bounced to the CPU holding the completion
queue, or you'll need to do a IPI to inform the submitting CPU.
But if you do that you're essentially doing single-queue submission,
so I doubt we're seeing that great improvements.

> In our initial testing we=B9re not seeing the performance scale as we=
 would
> expect so we wanted to see if there some =8Cknobs=B9 if you will that=
 we could
> try tuning to try to increase the performance.  Also, one question we=
 did
> have is there an official API to be able to set the CPU affinity of t=
he
> hw_ctx_queues?
>=20
As above, given the underlying design I'm not surprised.

But above you mentioned 'per-connection submission queues'; from which
one could infer that there are several _hardware_ submission queues?
If so, _maybe_ we should look into doing MC/S (in the iSCSI case),
which would allow us to keep the 1:1 submission/completion ratio
preferred by blk-mq and still use several queues ... Hmm?

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
