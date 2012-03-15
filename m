From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] LIBISCSI: Alleviate NOP transmission request upon xmit
 failure
Date: Thu, 15 Mar 2012 13:48:36 -0500
Message-ID: <4F623984.9050102@cs.wisc.edu>
References: <eddie.wai@broadcom.com> <1331769005-1767-1-git-send-email-eddie.wai@broadcom.com> <4F614AC1.2080906@cs.wisc.edu> <4F614D29.3090108@cs.wisc.edu> <1331794939.5058.761.camel@dhcp-10-12-137-160.irv.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46051 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690Ab2COSss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2012 14:48:48 -0400
In-Reply-To: <1331794939.5058.761.camel@dhcp-10-12-137-160.irv.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 03/15/2012 02:02 AM, Eddie Wai wrote:
> 
> On Wed, 2012-03-14 at 21:00 -0500, Mike Christie wrote:
>> On 03/14/2012 08:49 PM, Mike Christie wrote:
>>> On 03/14/2012 06:50 PM, Eddie Wai wrote:
>>>> During heavy I/O transmission, it was observed that network packets
>>>> can get dropped when no link flow control is enabled.  When this happens,
>>>> I/O completions can exceed the default NOP transmission of 5s while the
>>>> hw send queue resource backs up.  When the queue gets full, NOP
>>>> transmission requests will also get blocked.  It was observed that
>>>> the NOP transmission requests will keep repeatedly try to send out
>>>> the NOP while holding the session lock.  This is very intrusive as the
>>>> requests are being called on every timer execution since the last_ping
>>>> parameter doesn't get updated upon transmission failure.  This creates a
>>>> tremendous bottleneck especially when the connection is about to get torn down.
>>>>
>>>> This patch alleviates the pounding of the NOP transmission in the
>>>> iscsi_check_transport_timeouts routine by injecting an artifical 1s delay
>>>> in between each NOP transmission requests due to failures upon timeout.
>>>>
>>>> There is no need to keep pounding on to request this data provoking NOP
>>>> transmission continuously when the transmit queue is full.
>>>>
>>>> Please review and comment.  Thanks.
>>>>
>>>>
>>>> Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
>>>> ---
>>>>  drivers/scsi/libiscsi.c |   13 +++++++++----
>>>>  1 files changed, 9 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>>>> index 82c3fd4..f1141a8 100644
>>>> --- a/drivers/scsi/libiscsi.c
>>>> +++ b/drivers/scsi/libiscsi.c
>>>> @@ -940,13 +940,14 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>>>>  	wake_up(&conn->ehwait);
>>>>  }
>>>>  
>>>> -static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>>>> +static struct iscsi_task *iscsi_send_nopout(struct iscsi_conn *conn,
>>>> +					    struct iscsi_nopin *rhdr)
>>>>  {
>>>>          struct iscsi_nopout hdr;
>>>>  	struct iscsi_task *task;
>>>>  
>>>>  	if (!rhdr && conn->ping_task)
>>>> -		return;
>>>> +		return NULL;
>>>>  
>>>>  	memset(&hdr, 0, sizeof(struct iscsi_nopout));
>>>>  	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
>>>> @@ -967,6 +968,7 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>>>>  		conn->ping_task = task;
>>>>  		conn->last_ping = jiffies;
>>>>  	}
>>>> +	return task;
>>>>  }
>>>>  
>>>>  static int iscsi_nop_out_rsp(struct iscsi_task *task,
>>>> @@ -2059,8 +2061,11 @@ static void iscsi_check_transport_timeouts(unsigned long data)
>>>>  	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
>>>>  		/* send a ping to try to provoke some traffic */
>>>>  		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
>>>> -		iscsi_send_nopout(conn, NULL);
>>>> -		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
>>>> +		if (iscsi_send_nopout(conn, NULL))
>>>> +			next_timeout = conn->last_ping +
>>>> +				       (conn->ping_timeout * HZ);
>>>
>>> Once we send a ping, we should not run this timer again until it has
>>> timed out Why is the ping not timing out and then why are not hitting
>>> the check above this that just returns?
>>>
>>> Is the timer firing early, so we keep hitting the iscsi_send_nopout path?
>>
>> One other side issue, when we get any completion we update the
>> conn->last_recv field, so we should not try another ping for another
>> recv_timeout seconds. If the above code is getting called to send a
>> ping, then we are not getting any completion for recv_timeout seconds.
>>
>> Is there a way to tell if the card is making progress? For example if we
>> were doing a lot of big writes, then the card could be making progress
>> on them and handling R2Ts and sending data, but the libiscsi layer does
>> not know, so it could fail the connection thinking that we did not get a
>> response when the card was really busy handling R2Ts.
> The default I/O completion timeout is defaulted to 5s which is not very
> forgiving.  As we observed, any hiccups in the link will sometimes
> trigger this timeout.  But the NOP heartbeat usually gets completed
> within its ping timeout of 5s (default).  
> 
> For bnx2i offload, all the r2t packets are handled in the fw so there's
> really no such indication I can think of to use.  I think the current
> invocation to send NOP upon recv timeout is okay.  But if the transmit
> queue is already full, I don't think its necessary to have the timer
> handler to keep on pounding on to try to submit the NOP request since
> the sole purpose of this NOP request is only to provoke traffic.  The
> commands sitting in the queue should be sufficient for that matter.

I agree it should not hammer on driver.

The purpose of the nop is to check if the network is up and the target
portal is still running ok. It is for cases where you might not get
something like a link down event or where we do not get some indication
the connection changed state, but want to be able to fail the path and
have IO switch to another path quickly or just restart the IO quickly.

Is there a way we can tell if the queue is full but are making progress
on the IO in the queue? I think what we want is if the driver knows IO
is being executed then it can return some new error code from the send
pdu callout. This will then tell the ping code to wait for another
recv_timeout seconds. I think there is no reason to retry 1 second later
like in your patch if we know we are making progress.

What we are trying to avoid is the case where the driver's queue is
full, and progress is not being made, and it is due to a legitimate
problem that the user would have wanted to handle with a path failover
or new tcp/iscsi connection and IO retry.
