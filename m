From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Sun, 30 Oct 2016 11:56:52 -0600
Message-ID: <20161030175652.al6viedhd3i67jq5@linux-x5ow.site>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
 <2ea07f3f-88eb-b795-fa37-a223bf80e581@linux.vnet.ibm.com>
 <20161013162405.aoxy3bdkc4bqtwsk@linux-x5ow.site>
 <4b411836-e76f-b67a-3d49-ad3d51b8f216@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48611 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753391AbcJ3R5V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Oct 2016 13:57:21 -0400
Content-Disposition: inline
In-Reply-To: <4b411836-e76f-b67a-3d49-ad3d51b8f216@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>s

On Fri, Oct 28, 2016 at 11:53:46AM +0200, Steffen Maier wrote:

[...]

> > > 
> > > > @@ -3937,6 +3944,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
> > > >  	struct request *req;
> > > >  	struct fc_bsg_job *job;
> > > >  	enum fc_dispatch_result ret;
> > > > +	struct fc_bsg_reply *bsg_reply;
> > > > 
> > > >  	if (!get_device(dev))
> > > >  		return;
> > > > @@ -3973,8 +3981,9 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
> > > >  		/* check if we have the msgcode value at least */
> > > >  		if (job->request_len < sizeof(uint32_t)) {
> > > >  			BUG_ON(job->reply_len < sizeof(uint32_t));
> > > > -			job->reply->reply_payload_rcv_len = 0;
> > > > -			job->reply->result = -ENOMSG;
> > > > +			bsg_reply = job->reply;
> > > > +			bsg_reply->reply_payload_rcv_len = 0;
> > > > +			bsg_reply->result = -ENOMSG;
> 
> Compiler optimization re-ordered above two lines and the first pointer
> derefence is bsg_reply->result [field offset 0] where bsg_reply is NULL.
> The assignment tries to write to memory at address NULL causing the kernel
> page fault.
> 
> Does your suggested change for [PATCH v3 02/16], shuffling the
> job->request_len checks, address above kernel page fault?

This is what I hope at least. I'm sorry but I don't have any experience with s390
and zfcp at all. I still need to get a test environment set up, but all the
people knowing how to do are rather busy at the moment. All my tests on x86_64
with FCoE and lpfc haven't had a problem so far.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
