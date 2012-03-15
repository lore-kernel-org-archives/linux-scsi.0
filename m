From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] LIBISCSI: Alleviate NOP transmission request upon xmit
 failure
Date: Wed, 14 Mar 2012 21:00:09 -0500
Message-ID: <4F614D29.3090108@cs.wisc.edu>
References: <eddie.wai@broadcom.com> <1331769005-1767-1-git-send-email-eddie.wai@broadcom.com> <4F614AC1.2080906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44729 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759659Ab2COCAU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2012 22:00:20 -0400
In-Reply-To: <4F614AC1.2080906@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <jbottomley@parallels.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 03/14/2012 08:49 PM, Mike Christie wrote:
> On 03/14/2012 06:50 PM, Eddie Wai wrote:
>> During heavy I/O transmission, it was observed that network packets
>> can get dropped when no link flow control is enabled.  When this happens,
>> I/O completions can exceed the default NOP transmission of 5s while the
>> hw send queue resource backs up.  When the queue gets full, NOP
>> transmission requests will also get blocked.  It was observed that
>> the NOP transmission requests will keep repeatedly try to send out
>> the NOP while holding the session lock.  This is very intrusive as the
>> requests are being called on every timer execution since the last_ping
>> parameter doesn't get updated upon transmission failure.  This creates a
>> tremendous bottleneck especially when the connection is about to get torn down.
>>
>> This patch alleviates the pounding of the NOP transmission in the
>> iscsi_check_transport_timeouts routine by injecting an artifical 1s delay
>> in between each NOP transmission requests due to failures upon timeout.
>>
>> There is no need to keep pounding on to request this data provoking NOP
>> transmission continuously when the transmit queue is full.
>>
>> Please review and comment.  Thanks.
>>
>>
>> Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
>> ---
>>  drivers/scsi/libiscsi.c |   13 +++++++++----
>>  1 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 82c3fd4..f1141a8 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -940,13 +940,14 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>>  	wake_up(&conn->ehwait);
>>  }
>>  
>> -static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>> +static struct iscsi_task *iscsi_send_nopout(struct iscsi_conn *conn,
>> +					    struct iscsi_nopin *rhdr)
>>  {
>>          struct iscsi_nopout hdr;
>>  	struct iscsi_task *task;
>>  
>>  	if (!rhdr && conn->ping_task)
>> -		return;
>> +		return NULL;
>>  
>>  	memset(&hdr, 0, sizeof(struct iscsi_nopout));
>>  	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
>> @@ -967,6 +968,7 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>>  		conn->ping_task = task;
>>  		conn->last_ping = jiffies;
>>  	}
>> +	return task;
>>  }
>>  
>>  static int iscsi_nop_out_rsp(struct iscsi_task *task,
>> @@ -2059,8 +2061,11 @@ static void iscsi_check_transport_timeouts(unsigned long data)
>>  	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
>>  		/* send a ping to try to provoke some traffic */
>>  		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
>> -		iscsi_send_nopout(conn, NULL);
>> -		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
>> +		if (iscsi_send_nopout(conn, NULL))
>> +			next_timeout = conn->last_ping +
>> +				       (conn->ping_timeout * HZ);
> 
> Once we send a ping, we should not run this timer again until it has
> timed out Why is the ping not timing out and then why are not hitting
> the check above this that just returns?
> 
> Is the timer firing early, so we keep hitting the iscsi_send_nopout path?

One other side issue, when we get any completion we update the
conn->last_recv field, so we should not try another ping for another
recv_timeout seconds. If the above code is getting called to send a
ping, then we are not getting any completion for recv_timeout seconds.

Is there a way to tell if the card is making progress? For example if we
were doing a lot of big writes, then the card could be making progress
on them and handling R2Ts and sending data, but the libiscsi layer does
not know, so it could fail the connection thinking that we did not get a
response when the card was really busy handling R2Ts.

