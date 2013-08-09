From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 9 Aug 2013 17:07:45 +0200
Message-ID: <20130809150744.GB25306@dhcp-26-207.brq.redhat.com>
References: <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <20130729114653.GB20951@mtj.dyndns.org>
 <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
 <5204FBA6.6040001@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5204FBA6.6040001@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 09, 2013 at 08:24:38AM -0600, Jens Axboe wrote:
> On 08/09/2013 02:23 AM, Alexander Gordeev wrote:
> > +	ap->qc_tags = blk_mq_init_tags(ATA_MAX_QUEUE, 1, NUMA_NO_NODE);
> > +	if (!ap->qc_tags) {
> > +		kfree(ap);
> > +		return NULL;
> > +	}
> 
> This should be blk_mq_init_tags(ATA_MAX_QUEUE - 1, 1, ...) since the
> total depth is normal_tags + reserved_tags.

Aha.. If blk_mq_init_tags() should be like this then?

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index dcbc2a4..b131a48 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -468,10 +468,9 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 	 * Rest of the tags start at the queue list
 	 */
 	tags->nr_free = 0;
-	while (nr_tags - tags->nr_reserved) {
+	while (nr_tags--) {
 		tags->freelist[tags->nr_free] = tags->nr_free +
 							tags->nr_reserved;
-		nr_tags--;
 		tags->nr_free++;
 	}

> -- 
> Jens Axboe

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
