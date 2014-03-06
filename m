From: sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/6] iser-target: Fix active I/O shutdown related issues
Date: Thu, 6 Mar 2014 16:05:02 +0200
Message-ID: <5318808E.5080207@mellanox.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>	 <5315EE7C.3030806@dev.mellanox.co.il>	 <1393978007.30113.4.camel@haakon3.risingtidesystems.com>	 <531714BE.2060401@dev.mellanox.co.il> <1394057083.20601.51.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394057083.20601.51.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 3/6/2014 12:04 AM, Nicholas A. Bellinger wrote:
> On Wed, 2014-03-05 at 14:12 +0200, Sagi Grimberg wrote:
>> On 3/5/2014 2:06 AM, Nicholas A. Bellinger wrote:
>>> On Tue, 2014-03-04 at 17:17 +0200, Sagi Grimberg wrote:
>>>> On 3/4/2014 2:00 AM, Nicholas A. Bellinger wrote:
>>>>> From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
>>>>>
> <SNIP>
>
>>>> More on cleanup flow. isert_cma_handler does not handle
>>>> RDMA_CM_EVENT_TIMEWAIT_EXIT.
>>>> To be more specific, according to IB spec, when initiating disconnect
>>>> (rdma_disconnect/ib_send_cm_dreq),
>>>> one should not destroy a used qp until getting TIMEWAIT_EXIT CM event.
>>>> We are working on this in iSER initiator.
>>>> It might lead to "stale connection" CM rejects on future connections
>>>> (SRP also does not do that).
>>>>
>>> <nod>, I noticed that as well during recent debugging.
>>>
>>> However, AFAICT the RDMA_CM_EVENT_TIMEWAIT_EVENT doesn't (always) occur
>>> on the target side after a RDMA_CM_EVENT_DISCONNECTED, and thus far I've
>>> not been able to ascertain what's different about the shutdown sequence
>>> that would make this happen, or not happen..
>>>
>>> Any ideas..?
>> That's probably because the cm_id is destroyed before you get the event.
>> There is a specific
>> timout computation to get this event (see IB spec). If you will attempt
>> to disconnect while
>> the link is down (initiator won't receive it and send you disconnect
>> back), you should be able
>> to see this event. As I understand, in order to comply the spec, the QP
>> (and the cm_id afterwards)
>> should be destroyed only when getting this event and not before.
>>
> <nod>, thanks for the additional background.
>
> So currently rdma_destroy_qp() + rdma_destroy_id() is being done via
> isert_connect_release(), which occurs after the final isert_put_conn()
> happens from either the RDMA_CM_EVENT_DISCONNECTED handler, or within
> isert_free_conn() in one of the per connection kernel thread contexts
> via iscsit_close_connection().
>
> If I understand the above correctly, the isert_put_conn() should move
> from the RDMA_CM_EVENT_DISCONNECTED handler into the TIMEWAIT_EVENT
> handler, yes..?

Yes.

> And it's safe to assume that DISCONNECTED will always occur before
> TIMEWAIT_EVENT, right..?

DISCONNECTED event may not even come at all (in case the initiator 
didn't call rdma_disconnect). no guarantees here..
But, if once we get the TIMEWAIT event, we destroy the qp and the 
*cm_id*, we won't get any CM events at all.
As I understand, we don't even need to explicitly destroy the cm_id, we 
can just return a non-zero return from cma_handler
for TIMEWAIT events which will cause rdma_cm to implicitly destroy the 
cm_id.

Hope this helps,

Sagi.

> --nab
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
