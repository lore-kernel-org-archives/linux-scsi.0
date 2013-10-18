From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH v2 2/4] BNX2FC: hung task timeout warning observed
 when rmmod bnx2x with active FCoE targets
Date: Fri, 18 Oct 2013 14:54:31 +0000
Message-ID: <D1781424-C9F6-40CF-8D45-250C1FAA815B@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1380171680-4905-1-git-send-email-eddie.wai@broadcom.com>,<52613C5D.8020404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4681 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab3JROyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2013 10:54:40 -0400
In-Reply-To: <52613C5D.8020404@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <jbottomley@parallels.com>, Robert Love <robert.w.love@intel.com>, fcoe-devel <fcoe-devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>

Tomas,

I have already took this up to James  yesterday and he said he will be fixing it over the weekend.

Thanks,
Eddie

On Oct 18, 2013, at 6:49 AM, "Tomas Henzl" <thenzl@redhat.com> wrote:

> On 09/26/2013 07:01 AM, Eddie Wai wrote:
>> [v2] - removed the interface->enabled flag setting which prevented the
>>       fcoe ctlr link from being brought back up after a MTU change
> 
> Maybe I miss something but it seems to me that the previous version
> has been taken into the for-next branch - 881e188ec7078f6850170ca72cc60621fe0672e1
> 
> If it is so, and the V2 is the right one, post a V1-V2 diff
> 
> Thanks, Tomas
> 
>> 
>> A rtnl_lock deadlock was observed from the rmmod thread where it
>> tries to unregister the fcoe_ctlr device.  This unregistration
>> triggered a flush of the sysfs queue of the associated ctlr and led to
>> a call to the set_fcoe_ctlr_enabled routine.  This will eventually propagate
>> down to call the bnx2fc_disable routine and contented for the rtnl_lock
>> in the same context.
>> 
>> This patch creates a subset of the bnx2fc_enable/disable routine which
>> removes the unnecesary rtnl_lock and the bnx2fc_dev_lock acquisition from
>> the set_fcoe_ctlr_enabled path.
>> 
>> kernel: INFO: task rmmod:7874 blocked for more than 120 seconds.
>> kernel:      Tainted: G        W  ---------------    2.6.32-415.0.1.el6.x86_64 #1
>> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> kernel: rmmod         D 000000000000000f     0  7874   6518 0x00000080
>> kernel: ffff88022158f7d8 0000000000000086 0000000000000000 0000000000000000
>> kernel: ffff88023fe72600 ffff88043c74d410 ffff88043c74d400 ffff88043c74d000
>> kernel: ffff88021ecbe5f8 ffff88022158ffd8 000000000000fbc8 ffff88021ecbe5f8
>> kernel: Call Trace:
>> kernel: [<ffffffff81525985>] schedule_timeout+0x215/0x2e0
>> kernel: [<ffffffff810680c0>] ? pick_next_task_fair+0xd0/0x130
>> kernel: [<ffffffff81524858>] ? schedule+0x178/0x3b2
>> kernel: [<ffffffff81525603>] wait_for_common+0x123/0x180
>> kernel: [<ffffffff81066b40>] ? default_wake_function+0x0/0x20
>> kernel: [<ffffffff811a486e>] ? ifind_fast+0x5e/0xb0
>> kernel: [<ffffffff8152571d>] wait_for_completion+0x1d/0x20
>> kernel: [<ffffffff81203868>] sysfs_addrm_finish+0x228/0x270
>> kernel: [<ffffffff812014ab>] sysfs_hash_and_remove+0x5b/0x90
>> kernel: [<ffffffff812056af>] sysfs_remove_group+0x5f/0x100
>> kernel: [<ffffffff81367e8b>] device_remove_groups+0x3b/0x60
>> kernel: [<ffffffff8136811d>] device_remove_attrs+0x3d/0x90
>> kernel: [<ffffffff81368295>] device_del+0x125/0x1e0
>> kernel: [<ffffffff81368372>] device_unregister+0x22/0x60
>> kernel: [<ffffffffa038ead2>] fcoe_ctlr_device_delete+0xe2/0xf4 [libfcoe]
>> kernel: [<ffffffffa03c43cb>] bnx2fc_interface_release+0x5b/0x90 [bnx2fc]
>> kernel: [<ffffffffa03c4370>] ? bnx2fc_interface_release+0x0/0x90 [bnx2fc]
>> kernel: [<ffffffff812835e7>] kref_put+0x37/0x70
>> kernel: [<ffffffffa03c4192>] __bnx2fc_destroy+0x72/0xa0 [bnx2fc]
>> kernel: [<ffffffffa03c5265>] bnx2fc_ulp_exit+0xf5/0x160 [bnx2fc]    <- got bnx2fc_dev_lock mutex_lock
>> kernel: [<ffffffffa03b03c6>] cnic_ulp_exit+0xb6/0xc0 [cnic]
>> kernel: [<ffffffffa03b5418>] cnic_netdev_event+0x368/0x370 [cnic]
>> kernel: [<ffffffffa038c56c>] ? fcoe_del_netdev_mapping+0x8c/0xa0 [libfcoe]
>> kernel: [<ffffffff8152a6e5>] notifier_call_chain+0x55/0x80
>> kernel: [<ffffffff810a0a46>] raw_notifier_call_chain+0x16/0x20
>> kernel: [<ffffffff81459beb>] call_netdevice_notifiers+0x1b/0x20
>> kernel: [<ffffffff8145ab34>] rollback_registered_many+0x154/0x280
>> kernel: [<ffffffff8145ad08>] rollback_registered+0x38/0x50
>> kernel: [<ffffffff8145ad78>] unregister_netdevice_queue+0x58/0xa0
>> kernel: [<ffffffff8145add0>] unregister_netdevice+0x10/0x20
>> kernel: [<ffffffff8145adfe>] unregister_netdev+0x1e/0x30                  <- got rtnl_lock!!!!!!!!!
>> kernel: [<ffffffffa0122278>] __bnx2x_remove+0x48/0x270 [bnx2x] <- got & rel rtnl_lock
>> kernel: [<ffffffffa0122554>] bnx2x_remove_one+0x44/0x80 [bnx2x]
>> kernel: [<ffffffff812a3af7>] pci_device_remove+0x37/0x70
>> kernel: [<ffffffff8136b2ef>] __device_release_driver+0x6f/0xe0
>> kernel: [<ffffffff8136b428>] driver_detach+0xc8/0xd0
>> kernel: [<ffffffff8136a22e>] bus_remove_driver+0x8e/0x110
>> kernel: [<ffffffff8136bc12>] driver_unregister+0x62/0xa0
>> kernel: [<ffffffff812a3e04>] pci_unregister_driver+0x44/0xb0
>> kernel: [<ffffffffa0191954>] bnx2x_cleanup+0x18/0x73 [bnx2x]
>> kernel: [<ffffffff810b8be4>] sys_delete_module+0x194/0x260
>> kernel: [<ffffffff810e1347>] ? audit_syscall_entry+0x1d7/0x200
>> kernel: [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
>> 
>> Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
>> ---
>> drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   59 +++++++++++++++++++++++++++---------
>> 1 files changed, 44 insertions(+), 15 deletions(-)
>> 
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> index 69ac554..7a25766 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> @@ -2004,6 +2004,24 @@ static void bnx2fc_ulp_init(struct cnic_dev *dev)
>>        set_bit(BNX2FC_CNIC_REGISTERED, &hba->reg_with_cnic);
>> }
>> 
>> +/* Assumes rtnl_lock and the bnx2fc_dev_lock are already taken */
>> +static int __bnx2fc_disable(struct fcoe_ctlr *ctlr)
>> +{
>> +    struct bnx2fc_interface *interface = fcoe_ctlr_priv(ctlr);
>> +
>> +    if (interface->enabled == true) {
>> +        if (!ctlr->lp) {
>> +            pr_err(PFX "__bnx2fc_disable: lport not found\n");
>> +            return -ENODEV;
>> +        } else {
>> +            interface->enabled = false;
>> +            fcoe_ctlr_link_down(ctlr);
>> +            fcoe_clean_pending_queue(ctlr->lp);
>> +        }
>> +    }
>> +    return 0;
>> +}
>> +
>> /**
>>  * Deperecated: Use bnx2fc_enabled()
>>  */
>> @@ -2018,20 +2036,34 @@ static int bnx2fc_disable(struct net_device *netdev)
>> 
>>    interface = bnx2fc_interface_lookup(netdev);
>>    ctlr = bnx2fc_to_ctlr(interface);
>> -    if (!interface || !ctlr->lp) {
>> +
>> +    if (!interface) {
>>        rc = -ENODEV;
>> -        printk(KERN_ERR PFX "bnx2fc_disable: interface or lport not found\n");
>> +        pr_err(PFX "bnx2fc_disable: interface not found\n");
>>    } else {
>> -        interface->enabled = false;
>> -        fcoe_ctlr_link_down(ctlr);
>> -        fcoe_clean_pending_queue(ctlr->lp);
>> +        rc = __bnx2fc_disable(ctlr);
>>    }
>> -
>>    mutex_unlock(&bnx2fc_dev_lock);
>>    rtnl_unlock();
>>    return rc;
>> }
>> 
>> +static int __bnx2fc_enable(struct fcoe_ctlr *ctlr)
>> +{
>> +    struct bnx2fc_interface *interface = fcoe_ctlr_priv(ctlr);
>> +
>> +    if (interface->enabled == false) {
>> +        if (!ctlr->lp) {
>> +            pr_err(PFX "__bnx2fc_enable: lport not found\n");
>> +            return -ENODEV;
>> +        } else if (!bnx2fc_link_ok(ctlr->lp)) {
>> +            fcoe_ctlr_link_up(ctlr);
>> +            interface->enabled = true;
>> +        }
>> +    }
>> +    return 0;
>> +}
>> +
>> /**
>>  * Deprecated: Use bnx2fc_enabled()
>>  */
>> @@ -2046,12 +2078,11 @@ static int bnx2fc_enable(struct net_device *netdev)
>> 
>>    interface = bnx2fc_interface_lookup(netdev);
>>    ctlr = bnx2fc_to_ctlr(interface);
>> -    if (!interface || !ctlr->lp) {
>> +    if (!interface) {
>>        rc = -ENODEV;
>> -        printk(KERN_ERR PFX "bnx2fc_enable: interface or lport not found\n");
>> -    } else if (!bnx2fc_link_ok(ctlr->lp)) {
>> -        fcoe_ctlr_link_up(ctlr);
>> -        interface->enabled = true;
>> +        pr_err(PFX "bnx2fc_enable: interface not found\n");
>> +    } else {
>> +        rc = __bnx2fc_enable(ctlr);
>>    }
>> 
>>    mutex_unlock(&bnx2fc_dev_lock);
>> @@ -2072,14 +2103,12 @@ static int bnx2fc_enable(struct net_device *netdev)
>> static int bnx2fc_ctlr_enabled(struct fcoe_ctlr_device *cdev)
>> {
>>    struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(cdev);
>> -    struct fc_lport *lport = ctlr->lp;
>> -    struct net_device *netdev = bnx2fc_netdev(lport);
>> 
>>    switch (cdev->enabled) {
>>    case FCOE_CTLR_ENABLED:
>> -        return bnx2fc_enable(netdev);
>> +        return __bnx2fc_enable(ctlr);
>>    case FCOE_CTLR_DISABLED:
>> -        return bnx2fc_disable(netdev);
>> +        return __bnx2fc_disable(ctlr);
>>    case FCOE_CTLR_UNUSED:
>>    default:
>>        return -ENOTSUPP;
> 
> 

