From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 0/6] iser-target: Fix active I/O shutdown related issues
Date: Wed, 05 Mar 2014 14:12:46 +0200
Message-ID: <531714BE.2060401@dev.mellanox.co.il>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>	 <5315EE7C.3030806@dev.mellanox.co.il> <1393978007.30113.4.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:54938 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCEMMz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2014 07:12:55 -0500
Received: by mail-ea0-f171.google.com with SMTP id n15so979430ead.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2014 04:12:53 -0800 (PST)
In-Reply-To: <1393978007.30113.4.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>

On 3/5/2014 2:06 AM, Nicholas A. Bellinger wrote:
> On Tue, 2014-03-04 at 17:17 +0200, Sagi Grimberg wrote:
>> On 3/4/2014 2:00 AM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>
>>> Hi Or & Sagi,
>>>
>>> This series addresses a number of active I/O shutdown related issues
>>> in iser-target code that have come up recently during stress testing.
>>>
>>> Note there is still a seperate iser-target network portal shutdown
>>> bug being tracked down, but this series addresses all existing issues
>>> related to active I/O session shutdown.
>>>
>>> The patch breakdown looks like:
>>>
>>> Patch #1 fixes a long-standing bug where TPGs in shutdown incorrectly
>>> could be referenced by new login attempts.
>>>
>>> Patch #2 converts list_del -> list_del_init for iscsi_cmd->i_conn_node
>>> so that list_empty works correctly.
>>>
>>> Patch #3 addresses isert_conn->state related bugs resulting in hung
>>> shutdown, and splits isert_free_conn() into seperate code that is
>>> called earlier during shutdown to ensure that all outstanding I/O
>>> has completed.
>>>
>>> Patch #4 fixes incorrect accounting of ->post_send_buf_count during
>>> active I/O shutdown with outstanding RDMA WRITE + RDMA READ work
>>> requests.
>>>
>>> Patch #5 addresses a bug related to active I/O shutdown with
>>> outstanding FRMR work requests.  Note this patch is specific to
>>> v3.12+ code.
>>>
>>> Patch #6 addresses bugs related to active I/O shutdown with
>>> outstanding completion interrupt coalescing batches. Note this patch
>>> is specific to v3.13+ code.
>>>
>>> Please review.
>> Hey Nic,
>>
>> So besides a minor comment, you have my Ack on this set.
>>
> Thanks!
>
>> More on cleanup flow. isert_cma_handler does not handle
>> RDMA_CM_EVENT_TIMEWAIT_EXIT.
>> To be more specific, according to IB spec, when initiating disconnect
>> (rdma_disconnect/ib_send_cm_dreq),
>> one should not destroy a used qp until getting TIMEWAIT_EXIT CM event.
>> We are working on this in iSER initiator.
>> It might lead to "stale connection" CM rejects on future connections
>> (SRP also does not do that).
>>
> <nod>, I noticed that as well during recent debugging.
>
> However, AFAICT the RDMA_CM_EVENT_TIMEWAIT_EVENT doesn't (always) occur
> on the target side after a RDMA_CM_EVENT_DISCONNECTED, and thus far I've
> not been able to ascertain what's different about the shutdown sequence
> that would make this happen, or not happen..
>
> Any ideas..?

That's probably because the cm_id is destroyed before you get the event. 
There is a specific
timout computation to get this event (see IB spec). If you will attempt 
to disconnect while
the link is down (initiator won't receive it and send you disconnect 
back), you should be able
to see this event. As I understand, in order to comply the spec, the QP 
(and the cm_id afterwards)
should be destroyed only when getting this event and not before.

Sagi.

> --nab
>

