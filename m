From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] iser-target: Fix active I/O shutdown related issues
Date: Wed, 05 Mar 2014 14:04:43 -0800
Message-ID: <1394057083.20601.51.camel@haakon3.risingtidesystems.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
	 <5315EE7C.3030806@dev.mellanox.co.il>
	 <1393978007.30113.4.camel@haakon3.risingtidesystems.com>
	 <531714BE.2060401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <531714BE.2060401@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-03-05 at 14:12 +0200, Sagi Grimberg wrote:
> On 3/5/2014 2:06 AM, Nicholas A. Bellinger wrote:
> > On Tue, 2014-03-04 at 17:17 +0200, Sagi Grimberg wrote:
> >> On 3/4/2014 2:00 AM, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>>

<SNIP>

> >> More on cleanup flow. isert_cma_handler does not handle
> >> RDMA_CM_EVENT_TIMEWAIT_EXIT.
> >> To be more specific, according to IB spec, when initiating disconnect
> >> (rdma_disconnect/ib_send_cm_dreq),
> >> one should not destroy a used qp until getting TIMEWAIT_EXIT CM event.
> >> We are working on this in iSER initiator.
> >> It might lead to "stale connection" CM rejects on future connections
> >> (SRP also does not do that).
> >>
> > <nod>, I noticed that as well during recent debugging.
> >
> > However, AFAICT the RDMA_CM_EVENT_TIMEWAIT_EVENT doesn't (always) occur
> > on the target side after a RDMA_CM_EVENT_DISCONNECTED, and thus far I've
> > not been able to ascertain what's different about the shutdown sequence
> > that would make this happen, or not happen..
> >
> > Any ideas..?
> 
> That's probably because the cm_id is destroyed before you get the event. 
> There is a specific
> timout computation to get this event (see IB spec). If you will attempt 
> to disconnect while
> the link is down (initiator won't receive it and send you disconnect 
> back), you should be able
> to see this event. As I understand, in order to comply the spec, the QP 
> (and the cm_id afterwards)
> should be destroyed only when getting this event and not before.
> 

<nod>, thanks for the additional background.

So currently rdma_destroy_qp() + rdma_destroy_id() is being done via
isert_connect_release(), which occurs after the final isert_put_conn()
happens from either the RDMA_CM_EVENT_DISCONNECTED handler, or within
isert_free_conn() in one of the per connection kernel thread contexts
via iscsit_close_connection().

If I understand the above correctly, the isert_put_conn() should move
from the RDMA_CM_EVENT_DISCONNECTED handler into the TIMEWAIT_EVENT
handler, yes..?

And it's safe to assume that DISCONNECTED will always occur before
TIMEWAIT_EVENT, right..?

--nab
