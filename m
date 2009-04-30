From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/10] block: cleanup rq->data_len usages
Date: Thu, 30 Apr 2009 10:35:57 -0500
Message-ID: <1241105757.3320.1.camel@mulgrave.int.hansenpartnership.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	 <1240996428-10159-9-git-send-email-tj@kernel.org>
	 <49F9AC04.9060403@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932350AbZD3Ph2@vger.kernel.org>
In-Reply-To: <49F9AC04.9060403@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-04-30 at 16:47 +0300, Boaz Harrosh wrote:
> > @@ -966,7 +965,7 @@ static int scsi_init_sgtable(struct request
> *req, struct scsi_data_buffer *sdb,
> >       BUG_ON(count > sdb->table.nents);
> >       sdb->table.nents = count;
> >       if (blk_pc_request(req))
> > -             sdb->length = req->data_len;
> > +             sdb->length = blk_rq_bytes(req);
> >       else
> >               sdb->length = blk_rq_sectors(req) << 9;
> 
> Is this true. I thought they must be the same now. I was actually
> anticipating this if() removed.

Me too ... there's one of these in scsi_lib.c as well.

The difference comes because filesystem requests are always in sectors,
but BLOCK_PC requests are always in bytes .... we should be able to wrap
the accessors so they do the correct conversions.

James
