From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 0/6] iser-target: Fix active I/O shutdown related issues
Date: Tue, 11 Mar 2014 12:27:08 +0200
Message-ID: <531EE4FC.9010402@dev.mellanox.co.il>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>	 <5315EE7C.3030806@dev.mellanox.co.il>	 <1393978007.30113.4.camel@haakon3.risingtidesystems.com>	 <531714BE.2060401@dev.mellanox.co.il>	 <1394057083.20601.51.camel@haakon3.risingtidesystems.com>	 <5318808E.5080207@mellanox.com> <1394488811.16214.32.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1394488811.16214.32.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, sagi grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 3/11/2014 12:00 AM, Nicholas A. Bellinger wrote:
> On Thu, 2014-03-06 at 16:05 +0200, sagi grimberg wrote:
>> On 3/6/2014 12:04 AM, Nicholas A. Bellinger wrote:
>>> On Wed, 2014-03-05 at 14:12 +0200, Sagi Grimberg wrote:
>>>> On 3/5/2014 2:06 AM, Nicholas A. Bellinger wrote:
>>>>> On Tue, 2014-03-04 at 17:17 +0200, Sagi Grimberg wrote:
>>>>>> On 3/4/2014 2:00 AM, Nicholas A. Bellinger wrote:
> <SNIP>
>
>>>>> <nod>, I noticed that as well during recent debugging.
>>>>>
>>>>> However, AFAICT the RDMA_CM_EVENT_TIMEWAIT_EVENT doesn't (always) occur
>>>>> on the target side after a RDMA_CM_EVENT_DISCONNECTED, and thus far I've
>>>>> not been able to ascertain what's different about the shutdown sequence
>>>>> that would make this happen, or not happen..
>>>>>
>>>>> Any ideas..?
>>>> That's probably because the cm_id is destroyed before you get the event.
>>>> There is a specific
>>>> timout computation to get this event (see IB spec). If you will attempt
>>>> to disconnect while
>>>> the link is down (initiator won't receive it and send you disconnect
>>>> back), you should be able
>>>> to see this event. As I understand, in order to comply the spec, the QP
>>>> (and the cm_id afterwards)
>>>> should be destroyed only when getting this event and not before.
>>>>
>>> <nod>, thanks for the additional background.
>>>
>>> So currently rdma_destroy_qp() + rdma_destroy_id() is being done via
>>> isert_connect_release(), which occurs after the final isert_put_conn()
>>> happens from either the RDMA_CM_EVENT_DISCONNECTED handler, or within
>>> isert_free_conn() in one of the per connection kernel thread contexts
>>> via iscsit_close_connection().
>>>
>>> If I understand the above correctly, the isert_put_conn() should move
>>> from the RDMA_CM_EVENT_DISCONNECTED handler into the TIMEWAIT_EVENT
>>> handler, yes..?
>> Yes.
>>
>>> And it's safe to assume that DISCONNECTED will always occur before
>>> TIMEWAIT_EVENT, right..?
>> DISCONNECTED event may not even come at all (in case the initiator
>> didn't call rdma_disconnect). no guarantees here..
>> But, if once we get the TIMEWAIT event, we destroy the qp and the
>> *cm_id*, we won't get any CM events at all.
>> As I understand, we don't even need to explicitly destroy the cm_id, we
>> can just return a non-zero return from cma_handler
>> for TIMEWAIT events which will cause rdma_cm to implicitly destroy the
>> cm_id.
>>
> Mmmm, if that's the case then I'm more confused about how reference
> counting for isert_conn should work wrt TIMEWAIT_EVENT than before..  ;)

Yes, it is indeed confusing.
The below might be even more confusing... I'll try to simplify.

> As mentioned earlier, the first isert_put_conn() occurs from the per
> connection process context after calling rdma_disconnect(), and the
> second from the disconnected event handler.
>
> Your comment above would seem to indicate that iser-target code should
> be waiting to receive TIMEWAIT_EVENT, instead of pro-actively calling
> rdma_disconnect() to trigger the disconnect.  Is that correct..?

Not instead. iser-target should call rdma_disconnect upon DISCONNECTED 
event but
destroy the qp and cm_id when getting TIMEWAIT.

There is a matter of sending disconnect request/response and a matter of 
when
to destroy the QP.

DISCONNECTED events are coming from 2 conditions:
static int cma_ib_handler()
{
         ...
         case IB_CM_DREQ_RECEIVED:    /* remote side sent a disconnect 
request */
         case IB_CM_DREP_RECEIVED:    /* remote side responded our 
disconnect request */
                 if (!cma_comp_exch(id_priv, RDMA_CM_CONNECT,
                                    RDMA_CM_DISCONNECT))
                         goto out;
                 event.event = RDMA_CM_EVENT_DISCONNECTED;
                 break;
         ...
}

So regardless if iser_target initiated rdma_disconnect - once it gets 
DISCONNECTED event
it should call it *again* to respond the initiator disconnect request 
(rdma_disconnect sends
CM DREQ and if fails calls CM_DREP - this is to cover that both sides 
will send DREQ and DREP).

The removal of the QP and cm_id should come once getting TIMEWAIT event.

Hope this wasn't even more confusing...

Sagi.
