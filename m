From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Thu, 30 Apr 2015 13:25:18 +0200
Message-ID: <5542111E.1080305@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
 <5541FB3F.70902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0058.outbound.protection.outlook.com ([65.55.169.58]:36576
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750866AbbD3LZZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 07:25:25 -0400
In-Reply-To: <5541FB3F.70902@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/30/15 11:51, Sagi Grimberg wrote:
> On 4/30/2015 11:58 AM, Bart Van Assche wrote:
>> -        srp_change_conn_state(target, false);
>> +        ch->connected = false;
>
> Shouldn't this be protected by the channel lock (like the target)?

On all CPU architectures I'm familiar with changes of boolean variables 
are atomic so I think modifying that variable without locking is fine.

>> @@ -170,6 +170,7 @@ struct srp_rdma_ch {
>>
>>       struct completion    tsk_mgmt_done;
>>       u8            tsk_mgmt_status;
>> +    bool            connected;
>
> I generally agree with this flag, but I'm a bit confused about the
> semantics of two connected flags? Also, we check the target connected
> flag on TMFs, although we are executing it on a channel (should we
> check both?)
>
> I'd say keep only the channel connected flag, the target logic needs to
> be mandated by the state.

I think we need both flags. The ch->connected flag is used only in 
srp_destroy_qp() to verify whether a channel has been disconnected 
before it is destroyed. The target->connected flag provides an easy way 
to test the connected state in e.g. srp_disconnect_target(). And if it 
is attempted to send a task management function over a channel that has 
just been disconnected that should be fine since any channel disconnect 
causes tl_err_work to be queued. That last action will sooner or later 
result in a reconnect.

Bart.
