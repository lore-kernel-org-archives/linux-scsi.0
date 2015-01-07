From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Wed, 7 Jan 2015 20:11:33 +0100
Message-ID: <20150107191133.GD2802@quack.suse.cz>
References: <54AD5DDD.2090808@dev.mellanox.co.il>
 <54AD6B45.9080807@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AD6B45.9080807@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, lsf-pc@lists.linux-foundation.org, open-iscsi@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed 07-01-15 09:22:13, Lee Duncan wrote:
> On 01/07/2015 08:25 AM, Sagi Grimberg wrote:
> > Hi everyone,
> > 
> > Now that scsi-mq is fully included, we need an iSCSI initiator that
> > would use it to achieve scalable performance. The need is even greater
> > for iSCSI offload devices and transports that support multiple HW
> > queues. As iSER maintainer I'd like to discuss the way we would choose
> > to implement that in iSCSI.
> > 
> > My measurements show that iSER initiator can scale up to ~2.1M IOPs
> > with multiple sessions but only ~630K IOPs with a single session where
> > the most significant bottleneck the (single) core processing
> > completions.
> > 
> > In the existing single connection per session model, given that command
> > ordering must be preserved session-wide, we end up in a serial command
> > execution over a single connection which is basically a single queue
> > model. The best fit seems to be plugging iSCSI MCS as a multi-queued
> > scsi LLDD. In this model, a hardware context will have a 1x1 mapping
> > with an iSCSI connection (TCP socket or a HW queue).
> > 
> > iSCSI MCS and it's role in the presence of dm-multipath layer was
> > discussed several times in the past decade(s). The basic need for MCS is
> > implementing a multi-queue data path, so perhaps we may want to avoid
> > doing any type link aggregation or load balancing to not overlap
> > dm-multipath. For example we can implement ERL=0 (which is basically the
> > scsi-mq ERL) and/or restrict a session to a single portal.
> > 
> > As I see it, the todo's are:
> > 1. Getting MCS to work (kernel + user-space) with ERL=0 and a
> >    round-robin connection selection (per scsi command execution).
> > 2. Plug into scsi-mq - exposing num_connections as nr_hw_queues and
> >    using blk-mq based queue (conn) selection.
> > 3. Rework iSCSI core locking scheme to avoid session-wide locking
> >    as much as possible.
> > 4. Use blk-mq pre-allocation and tagging facilities.
> > 
> > I've recently started looking into this. I would like the community to
> > agree (or debate) on this scheme and also talk about implementation
> > with anyone who is also interested in this.
> > 
> > Cheers,
> > Sagi.
> 
> I started looking at this last year (and Hannes' suggestion), and would
> love to join the discussion.
> 
> Please add me to the list of those that wish to attend.
  For that please send a separate email with attend request as described in
the call for proposals. Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
