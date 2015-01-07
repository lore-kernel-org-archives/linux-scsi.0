From: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Wed, 07 Jan 2015 09:22:13 -0800
Message-ID: <54AD6B45.9080807@suse.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBD54HHNYIIIMXVVVUUCRUBGBZ3YJU-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <54AD5DDD.2090808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 01/07/2015 08:25 AM, Sagi Grimberg wrote:
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
>    round-robin connection selection (per scsi command execution).
> 2. Plug into scsi-mq - exposing num_connections as nr_hw_queues and
>    using blk-mq based queue (conn) selection.
> 3. Rework iSCSI core locking scheme to avoid session-wide locking
>    as much as possible.
> 4. Use blk-mq pre-allocation and tagging facilities.
> 
> I've recently started looking into this. I would like the community to
> agree (or debate) on this scheme and also talk about implementation
> with anyone who is also interested in this.
> 
> Cheers,
> Sagi.

I started looking at this last year (and Hannes' suggestion), and would
love to join the discussion.

Please add me to the list of those that wish to attend.
-- 
Lee Duncan
SUSE Labs

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
