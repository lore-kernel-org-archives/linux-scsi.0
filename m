From: John Fastabend <john.r.fastabend@intel.com>
Subject: Re: [Open-FCoE] [PATCH] fcoe: Don't hold rtnl_mutex in fcoe_update_src_mac
Date: Tue, 13 Mar 2012 19:14:49 -0700
Message-ID: <4F5FFF19.1060601@intel.com>
References: <bug-42918-11613@https.bugzilla.kernel.org> <20120313225254.5473.92174.stgit@localhost6.localdomain6> <4F5FE95D.8040408@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760671Ab2CNCOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 22:14:50 -0400
In-Reply-To: <4F5FE95D.8040408@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 3/13/2012 5:42 PM, Love, Robert W wrote:
> On 03/13/2012 03:52 PM, Robert Love wrote:
>> The rtnl_mutex was held to protect calls to dev_uc_add
>> and dev_uc_del. Holding rtnl is not required as those
>> functions make use of the netif_addr_lock* API to
>> protect the MAC changing.
>>
>> This change fixes the following regression by removing
>> the rtnl usage when fcoe_update_src_mac is called.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=42918
>>
>> the existing dependency chain (in reverse order) is:
>>
>> ->  #1 (&fip->ctlr_mutex){+.+...}:
>>         [<c1091f70>] lock_acquire+0x80/0x1b0
>>         [<c147655d>] mutex_lock_nested+0x6d/0x340
>>         [<f8970c32>] fcoe_ctlr_link_up+0x22/0x180 [libfcoe]
>>         [<f894620e>] fcoe_create+0x47e/0x6e0 [fcoe]
>>         [<f8973dd3>] fcoe_transport_create+0x143/0x250 [libfcoe]
>>         [<c10527e0>] param_attr_store+0x30/0x60
>>         [<c1052696>] module_attr_store+0x26/0x40
>>         [<c11a201e>] sysfs_write_file+0xae/0x100
>>         [<c11449df>] vfs_write+0x8f/0x160
>>         [<c1144cbd>] sys_write+0x3d/0x70
>>         [<c147a0c4>] syscall_call+0x7/0xb
>>
>> ->  #0 (rtnl_mutex){+.+.+.}:
>>         [<c109164b>] __lock_acquire+0x140b/0x1720
>>         [<c1091f70>] lock_acquire+0x80/0x1b0
>>         [<c147655d>] mutex_lock_nested+0x6d/0x340
>>         [<c13a10c4>] rtnl_lock+0x14/0x20
>>         [<f89445ac>] fcoe_update_src_mac+0x2c/0xb0 [fcoe]
>>         [<f8971712>] fcoe_ctlr_timer_work+0x712/0xb60 [libfcoe]
>>         [<c104fb69>] process_one_work+0x179/0x5d0
>>         [<c10502f1>] worker_thread+0x121/0x2d0
>>         [<c10550ed>] kthread+0x7d/0x90
>>         [<c1481a82>] kernel_thread_helper+0x6/0x10
>>
>> other info that might help us debug this:
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&fip->ctlr_mutex);
>>                                 lock(rtnl_mutex);
>>                                 lock(&fip->ctlr_mutex);
>>    lock(rtnl_mutex);
>>
>>   *** DEADLOCK ***
>>
>> Signed-off-by: Robert Love<robert.w.love@intel.com>
>> ---
>>   drivers/scsi/fcoe/fcoe.c |    2 --
>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
>> index e959960..85b8203 100644
>> --- a/drivers/scsi/fcoe/fcoe.c
>> +++ b/drivers/scsi/fcoe/fcoe.c
>> @@ -539,13 +539,11 @@ static void fcoe_update_src_mac(struct fc_lport *lport, u8 *addr)
>>   	struct fcoe_port *port = lport_priv(lport);
>>   	struct fcoe_interface *fcoe = port->priv;
>>
>> -	rtnl_lock();
>>   	if (!is_zero_ether_addr(port->data_src_addr))
>>   		dev_uc_del(fcoe->netdev, port->data_src_addr);
>>   	if (!is_zero_ether_addr(addr))
>>   		dev_uc_add(fcoe->netdev, addr);
>>   	memcpy(port->data_src_addr, addr, ETH_ALEN);
>> -	rtnl_unlock();
>>   }
>>
>>   /**
>>
> This isn't going to work. We do need rtnl_lock when calling 
> dev_uc_add/del to ensure the driver isn't removed while making the 
> change. I have an alternative patch that I'll post as soon as I clean it 
> up a bit.
> 
> Nacked-by: Robert Love <robert.w.love@intel.com>

So there is a case you don't have a ref cnt on the netdev here? 

I guess my point is if your carrying around a ptr to the struct why
haven't you incremented the refcnt. I think the dev_hold() in the
create path would be enough to stop the above concern.

Thanks,
John
