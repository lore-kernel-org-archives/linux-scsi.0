From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Wed, 07 Jan 2015 08:58:37 -0800
Message-ID: <1420649917.12144.20.camel@haakon3.risingtidesystems.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54AD5DDD.2090808@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-01-07 at 18:25 +0200, Sagi Grimberg wrote:
> Hi everyone,
> 
> Now that scsi-mq is fully included, we need an iSCSI initiator that
> would use it to achieve scalable performance. The need is even greater
> for iSCSI offload devices and transports that support multiple HW
> queues. As iSER maintainer I'd like to discuss the way we would choose
> to implement that in iSCSI.
> 
> My measurements show that iSER initiator can scale up to ~2.1M IOPs
> with multiple sessions but only ~630K IOPs with a single session where
> the most significant bottleneck the (single) core processing
> completions.
> 
> In the existing single connection per session model, given that command
> ordering must be preserved session-wide, we end up in a serial command
> execution over a single connection which is basically a single queue
> model. The best fit seems to be plugging iSCSI MCS as a multi-queued
> scsi LLDD. In this model, a hardware context will have a 1x1 mapping
> with an iSCSI connection (TCP socket or a HW queue).
> 
> iSCSI MCS and it's role in the presence of dm-multipath layer was
> discussed several times in the past decade(s). The basic need for MCS is
> implementing a multi-queue data path, so perhaps we may want to avoid
> doing any type link aggregation or load balancing to not overlap
> dm-multipath. For example we can implement ERL=0 (which is basically the
> scsi-mq ERL) and/or restrict a session to a single portal.
> 
> As I see it, the todo's are:
> 1. Getting MCS to work (kernel + user-space) with ERL=0 and a
>     round-robin connection selection (per scsi command execution).
> 2. Plug into scsi-mq - exposing num_connections as nr_hw_queues and
>     using blk-mq based queue (conn) selection.
> 3. Rework iSCSI core locking scheme to avoid session-wide locking
>     as much as possible.
> 4. Use blk-mq pre-allocation and tagging facilities.
> 
> I've recently started looking into this. I would like the community to
> agree (or debate) on this scheme and also talk about implementation
> with anyone who is also interested in this.
> 

(Adding CC' for MNC)

+1.  I'd be up for this discussion to finally get MC/S support into
open-iscsi, and determining the best method for mapping connection
conects to scsi-mq hw queues.

--nab
