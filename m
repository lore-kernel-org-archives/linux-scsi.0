From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] scsi: Add SHT->unlocked_qcmd for host_lock less
	SHT->queuecommand() dispatch
Date: Wed, 27 Oct 2010 12:48:57 -0700
Message-ID: <1288208937.5169.206.camel@haakon2.linux-iscsi.org>
References: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
	 <4CC86E36.8060102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm2.bullet.mail.ac4.yahoo.com ([98.139.52.199]:35758 "HELO
	nm2.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751680Ab0J0Tx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 15:53:56 -0400
In-Reply-To: <4CC86E36.8060102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>

On Wed, 2010-10-27 at 13:23 -0500, Mike Christie wrote:
> On 10/26/2010 07:32 PM, Nicholas A. Bellinger wrote:
> > diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> > index fec47de..f5933dd 100644
> > --- a/drivers/scsi/iscsi_tcp.c
> > +++ b/drivers/scsi/iscsi_tcp.c
> > @@ -882,6 +882,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
> >   	.target_alloc		= iscsi_target_alloc,
> >   	.proc_name		= "iscsi_tcp",
> >   	.this_id		= -1,
> > +	.unlocked_qcmd		= 1,
> >   };
> >
> >   static struct iscsi_transport iscsi_sw_tcp_transport = {
> > diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> > index 633e090..7e4134e 100644
> > --- a/drivers/scsi/libiscsi.c
> > +++ b/drivers/scsi/libiscsi.c
> > @@ -1615,7 +1615,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
> >
> >   	host = sc->device->host;
> >   	ihost = shost_priv(host);
> > -	spin_unlock(host->host_lock);
> >
> >   	cls_session = starget_to_session(scsi_target(sc->device));
> >   	session = cls_session->dd_data;
> > @@ -1706,7 +1705,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
> >
> >   	session->queued_cmdsn++;
> >   	spin_unlock(&session->lock);
> > -	spin_lock(host->host_lock);
> >   	return 0;
> >
> >   prepd_reject:
> > @@ -1716,7 +1714,6 @@ reject:
> >   	spin_unlock(&session->lock);
> >   	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
> >   			  sc->cmnd[0], reason);
> > -	spin_lock(host->host_lock);
> >   	return SCSI_MLQUEUE_TARGET_BUSY;
> >
> >   prepd_fault:
> > @@ -1733,7 +1730,6 @@ fault:
> >   		scsi_in(sc)->resid = scsi_in(sc)->length;
> >   	}
> >   	done(sc);
> > -	spin_lock(host->host_lock);
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(iscsi_queuecommand);
> 
> 
> Hey,
> 
> iscsi_tcp, drivers/infiniband/ulp/iser/ib_iser, drivers/scsi/cxgb3i, 
> drivers/scsi/bnx2i, and drivers/scsi/be2iscsi use libiscsi's 
> iscsi_queuecommand function, so they should all use the same setting 
> unlocked_qcmd=1.


Hmmm, that is what I was thinking too.. Thanks for confirming this.
Respinning again to include this LLDs w/ the new
SHT->queuecommad_unlocked() usage.

Thanks Mike!

--nab

