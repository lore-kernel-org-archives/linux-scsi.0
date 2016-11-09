From: John Garry <john.garry@huawei.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Wed, 9 Nov 2016 17:36:53 +0000
Message-ID: <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
 <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------2696711AF76EE2B4179B28F8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:23735 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbcKIRhZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 12:37:25 -0500
In-Reply-To: <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-kernel@vger.kernel.org, lindar_liu@usish.com, jinpu.wang@profitbricks.com, dan.j.williams@intel.com, tj@kernel.org

--------------2696711AF76EE2B4179B28F8
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

On 09/11/2016 12:28, John Garry wrote:
> On 03/11/2016 14:58, John Garry wrote:
>> The following patch introduces an annoying WARN
>> when a device is removed from the SAS topology:
>> [SCSI] libsas: prevent domain rediscovery competing with ata error
>> handling
>>
>
> Are there any views on this patch? I would have thought that the parties
> who use the drivers based on libsas would be interested in fixing this bug.
>

I should have added the before and after logs earlier, so the issue is 
illustrated. Now attached. When a 24-port expander is unplugged we get 
 >6k lines of WARN on the console, lasting >30 seconds. Not nice.

John

  BTW, We are internally testing, hence the RFC.
>
> Thanks in advance,
> John
>
>> A sample WARN is as follows:
>> [  236.842227] WARNING: CPU: 7 PID: 1520 at fs/sysfs/group.c:237
>> sysfs_remove_group+0x90/0x98
>> [  236.850465] Modules linked in:
>> [  236.853544]
>> [  236.855045] CPU: 7 PID: 1520 Comm: kworker/u64:4 Tainted: G
>> W       4.9.0-rc1-15310-g3fbc29e-dirty #676
>> [  236.865010] Hardware name: Huawei Taishan 2180 /D03, BIOS Estuary
>> v2.3 D03 UEFI 08/17/2016
>> [  236.873249] Workqueue: scsi_wq_0 sas_destruct_devices
>> [  236.878317] task: ffff8027ba31b200 task.stack: ffff8027b9d44000
>> [  236.884225] PC is at sysfs_remove_group+0x90/0x98
>> [  236.888920] LR is at sysfs_remove_group+0x90/0x98
>> [  236.893616] pc : [<ffff000008256df8>] lr : [<ffff000008256df8>]
>> pstate: 60000145
>> [  236.900989] sp : ffff8027b9d47bf0
>>
>> < snip >
>>
>> [  237.116463] [<ffff000008256df8>] sysfs_remove_group+0x90/0x98
>> [  237.122197] [<ffff00000851fe68>] dpm_sysfs_remove+0x58/0x68
>> [  237.127758] [<ffff000008513678>] device_del+0x40/0x218
>> [  237.132886] [<ffff000008513864>] device_unregister+0x14/0x2c
>> [  237.138536] [<ffff0000083670c4>] bsg_unregister_queue+0x5c/0xa0
>> [  237.144442] [<ffff00000855b984>] sas_rphy_remove+0x44/0x80
>> [  237.149915] [<ffff00000855b9d4>] sas_rphy_delete+0x14/0x28
>> [  237.155388] [<ffff00000855f9d8>] sas_destruct_devices+0x64/0x98
>> [  237.161293] [<ffff0000080d2c1c>] process_one_work+0x128/0x2e4
>> [  237.167027] [<ffff0000080d2e30>] worker_thread+0x58/0x434
>> [  237.172415] [<ffff0000080d8c24>] kthread+0xd4/0xe8
>> [  237.177198] [<ffff000008082e80>] ret_from_fork+0x10/0x50
>> [  237.182557] sysfs group 'power' not found for kobject
>> 'end_device-0:0:5'
>>
>> (this can be really huge when an expander is unplugged)
>>
>> The problem is with the process of sas_port and domain_device
>> destruction in domain revalidation. There is a 2-stage process:
>> In domain revalidation (which runs in work queue context), if a
>> domain_device is discovered to be gone, then the following happens:
>> - the domain_device is queued for destruction in a separate work item
>> - the associated sas_port is destroyed immediately
>>
>> This causes a problem in that the sas_port associated with
>> a domain_device is destroyed prior the domain_device: this causes
>> the sysfs WARN. Essentially the "rug has been pulled from underneath".
>>
>> Also, likewise, when a root port is deformed due to loss of signal,
>> we have the same issue.
>>
>> To solve, destroy the sas_port in a separate work item to which
>> we do the domain revalidation with a new discovery event, as follows:
>> - When a domain_device is detected to be gone, the domain_device is
>>   queued for destruction in a separate work item. The associated
>>   sas_port is also queued for destruction in another separate work item
>>   (needs to be queued 2nd)
>> - the domain_device is destroyed
>> - the sas_port is destroyed
>> [similar is done for loss of signal event, in sas_port_deformed()].
>>
>> Fixes: 87c8331fcf72e501c3a3c0cdc5c [SCSI] libsas: prevent domain
>> rediscovery competing with ata error handling
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c
>> b/drivers/scsi/libsas/sas_discover.c
>> index 60de662..01d0fe2 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -361,7 +361,7 @@ static void sas_destruct_devices(struct
>> work_struct *work)
>>
>>      clear_bit(DISCE_DESTRUCT, &port->disc.pending);
>>
>> -    list_for_each_entry_safe(dev, n, &port->destroy_list,
>> disco_list_node) {
>> +    list_for_each_entry_safe(dev, n, &port->dev_destroy_list,
>> disco_list_node) {
>>          list_del_init(&dev->disco_list_node);
>>
>>          sas_remove_children(&dev->rphy->dev);
>> @@ -383,7 +383,7 @@ void sas_unregister_dev(struct asd_sas_port *port,
>> struct domain_device *dev)
>>
>>      if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
>>          sas_rphy_unlink(dev->rphy);
>> -        list_move_tail(&dev->disco_list_node, &port->destroy_list);
>> +        list_move_tail(&dev->disco_list_node, &port->dev_destroy_list);
>>          sas_discover_event(dev->port, DISCE_DESTRUCT);
>>      }
>>  }
>> @@ -525,6 +525,28 @@ static void sas_revalidate_domain(struct
>> work_struct *work)
>>      mutex_unlock(&ha->disco_mutex);
>>  }
>>
>> +/* ---------- Async Port destruct ---------- */
>> +static void sas_async_port_destruct(struct work_struct *work)
>> +{
>> +    struct sas_discovery_event *ev = to_sas_discovery_event(work);
>> +    struct asd_sas_port *port = ev->port;
>> +    struct sas_port *sas_port, *n;
>> +
>> +    clear_bit(DISCE_PORT_DESTRUCT, &port->disc.pending);
>> +
>> +    list_for_each_entry_safe(sas_port, n, &port->port_destroy_list,
>> destroy_list) {
>> +        list_del_init(&port->port_destroy_list);
>> +
>> +        sas_port_delete(sas_port);
>> +    }
>> +}
>> +
>> +void sas_port_destruct(struct asd_sas_port *port, struct sas_port
>> *sas_port)
>> +{
>> +    list_move_tail(&sas_port->destroy_list, &port->port_destroy_list);
>> +    sas_discover_event(port, DISCE_PORT_DESTRUCT);
>> +}
>> +
>>  /* ---------- Events ---------- */
>>
>>  static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work
>> *sw)
>> @@ -582,6 +604,7 @@ void sas_init_disc(struct sas_discovery *disc,
>> struct asd_sas_port *port)
>>          [DISCE_SUSPEND] = sas_suspend_devices,
>>          [DISCE_RESUME] = sas_resume_devices,
>>          [DISCE_DESTRUCT] = sas_destruct_devices,
>> +        [DISCE_PORT_DESTRUCT] = sas_async_port_destruct,
>>      };
>>
>>      disc->pending = 0;
>> diff --git a/drivers/scsi/libsas/sas_expander.c
>> b/drivers/scsi/libsas/sas_expander.c
>> index 022bb6e..f9522a0 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1900,10 +1900,11 @@ static void
>> sas_unregister_devs_sas_addr(struct domain_device *parent,
>>      }
>>      memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
>>      if (phy->port) {
>> +        struct asd_sas_port *port = found->port;
>>          sas_port_delete_phy(phy->port, phy->phy);
>>          sas_device_set_phy(found, phy->port);
>>          if (phy->port->num_phys == 0)
>> -            sas_port_delete(phy->port);
>> +            sas_port_destruct(port, phy->port);
>>          phy->port = NULL;
>>      }
>>  }
>> diff --git a/drivers/scsi/libsas/sas_port.c
>> b/drivers/scsi/libsas/sas_port.c
>> index d3c5297..1a32f86 100644
>> --- a/drivers/scsi/libsas/sas_port.c
>> +++ b/drivers/scsi/libsas/sas_port.c
>> @@ -219,7 +219,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int
>> gone)
>>
>>      if (port->num_phys == 1) {
>>          sas_unregister_domain_devices(port, gone);
>> -        sas_port_delete(port->port);
>> +        sas_port_destruct(port, port->port);
>>          port->port = NULL;
>>      } else {
>>          sas_port_delete_phy(port->port, phy->phy);
>> @@ -322,7 +322,8 @@ static void sas_init_port(struct asd_sas_port *port,
>>      port->id = i;
>>      INIT_LIST_HEAD(&port->dev_list);
>>      INIT_LIST_HEAD(&port->disco_list);
>> -    INIT_LIST_HEAD(&port->destroy_list);
>> +    INIT_LIST_HEAD(&port->dev_destroy_list);
>> +    INIT_LIST_HEAD(&port->port_destroy_list);
>>      spin_lock_init(&port->phy_list_lock);
>>      INIT_LIST_HEAD(&port->phy_list);
>>      port->ha = sas_ha;
>> diff --git a/drivers/scsi/scsi_transport_sas.c
>> b/drivers/scsi/scsi_transport_sas.c
>> index 60b651b..062c03c 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -934,6 +934,7 @@ struct sas_port *sas_port_alloc(struct device
>> *parent, int port_id)
>>
>>      mutex_init(&port->phy_list_mutex);
>>      INIT_LIST_HEAD(&port->phy_list);
>> +    INIT_LIST_HEAD(&port->destroy_list);
>>
>>      if (scsi_is_sas_expander_device(parent)) {
>>          struct sas_rphy *rphy = dev_to_rphy(parent);
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index dae99d7..a7953c8 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -91,7 +91,8 @@ enum discover_event {
>>      DISCE_SUSPEND        = 4,
>>      DISCE_RESUME        = 5,
>>      DISCE_DESTRUCT        = 6,
>> -    DISC_NUM_EVENTS        = 7,
>> +    DISCE_PORT_DESTRUCT    = 7,
>> +    DISC_NUM_EVENTS,
>>  };
>>
>>  /* ---------- Expander Devices ---------- */
>> @@ -268,7 +269,8 @@ struct asd_sas_port {
>>      spinlock_t dev_list_lock;
>>      struct list_head dev_list;
>>      struct list_head disco_list;
>> -    struct list_head destroy_list;
>> +    struct list_head dev_destroy_list;
>> +    struct list_head port_destroy_list;
>>      enum   sas_linkrate linkrate;
>>
>>      struct sas_work work;
>> @@ -702,6 +704,7 @@ extern int sas_bios_param(struct scsi_device *,
>>  int  sas_ex_revalidate_domain(struct domain_device *);
>>
>>  void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
>> +void sas_port_destruct(struct asd_sas_port *port, struct sas_port
>> *sas_port);
>>  void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
>>  int  sas_discover_event(struct asd_sas_port *, enum discover_event ev);
>>
>> diff --git a/include/scsi/scsi_transport_sas.h
>> b/include/scsi/scsi_transport_sas.h
>> index 73d8709..b495aac 100644
>> --- a/include/scsi/scsi_transport_sas.h
>> +++ b/include/scsi/scsi_transport_sas.h
>> @@ -154,6 +154,7 @@ struct sas_port {
>>
>>      struct mutex        phy_list_mutex;
>>      struct list_head    phy_list;
>> +    struct list_head    destroy_list; /* only used by libsas */
>>  };
>>
>>  #define dev_to_sas_port(d) \
>>
>
>
> _______________________________________________
> linuxarm mailing list
> linuxarm@huawei.com
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm
>
> .
>


--------------2696711AF76EE2B4179B28F8
Content-Type: text/plain; charset="UTF-8"; name="before.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="before.log"

root@(none)$ 
root@(none)$ 
root@(none)$ 
root@(none)$ 
root@(none)$ [   95.050056] hisi_sas_v2_hw a3000000.sas: phyup: phy2 link_rate=11
[   95.056181] hisi_sas_v2_hw a3000000.sas: phyup: phy0 link_rate=11
[   95.062303] hisi_sas_v2_hw a3000000.sas: phyup: phy1 link_rate=11
[   95.068425] hisi_sas_v2_hw a3000000.sas: phyup: phy3 link_rate=11
[   95.085511] scsi 2:0:1:0: Enclosure         ADAPTEC  AEC-82885T       B015 PQ: 0 ANSI: 6
[   98.269928] sysfs group 'power' not found for kobject '2:0:1:0'
[   98.275895] ------------[ cut here ]------------
[   98.280534] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[   98.288830] Modules linked in:
[   98.291905] 
[   98.293402] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[   98.303442] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[   98.313222] Workqueue: scsi_wq_2 sas_destruct_devices
[   98.318303] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[   98.324246] PC is at sysfs_remove_group+0x8c/0x94
[   98.328968] LR is at sysfs_remove_group+0x8c/0x94
[   98.333689] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[   98.341113] sp : ffff8003f5483b40
[   98.344438] x29: ffff8003f5483b40 [   98.347677] x28: ffff000008d45000 
[   98.351091] 
[   98.352586] x27: ffff8003e5080000 [   98.355824] x26: 0000000000000001 
[   98.359238] 
[   98.360732] x25: ffff000008e06f9a [   98.363970] x24: 0000000000000003 
[   98.367383] 
[   98.368878] x23: ffff8003e5080000 [   98.372116] x22: ffff8003e02fc990 
[   98.375530] 
[   98.377024] x21: ffff8003e033e410 [   98.380262] x20: ffff000008de32e0 
[   98.383676] 
[   98.385170] x19: 0000000000000000 [   98.388408] x18: 0000ffffcbcc6090 
[   98.391821] 
[   98.393315] x17: 0000000000497240 [   98.396552] x16: ffff0000081e3e54 
[   98.399966] 
[   98.401460] x15: 0000000000000000 [   98.404698] x14: 0000000000000000 
[   98.408112] 
[   98.409606] x13: 000000000000203e [   98.412845] x12: 0000000000000006 
[   98.416258] 
[   98.417753] x11: ffff000008e21698 [   98.420991] x10: 0000000000000000 
[   98.424405] 
[   98.425898] x9 : ffff8003fff62280 [   98.429136] x8 : 3227207463656a62 
[   98.432550] 
[   98.434044] x7 : 6f6b20726f662064 [   98.437282] x6 : 000000000000203f 
[   98.440696] 
[   98.442190] x5 : ffff8003f5486218 [   98.445428] x4 : 0000000000000000 
[   98.448841] 
[   98.450336] x3 : 0000000000000000 [   98.453574] x2 : ffff000008d5cd18 
[   98.456987] 
[   98.458482] x1 : 0000000000000000 [   98.461720] x0 : 0000000000000033 
[   98.465134] 
[   98.466628] 
[   98.468123] ---[ end trace d18a42ce2a4e2200 ]---
[   98.472756] Call trace:
[   98.475210] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[   98.481676] 3960:                                   0000000000000000 0001000000000000
[   98.489537] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000033
[   98.497398] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[   98.505258] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e033e410 ffff8003e02fc990
[   98.513119] 39e0: ffff8003e5080000 0000000000000003 ffff000008e06f9a 0000000000000001
[   98.520980] 3a00: ffff8003e5080000 ffff000008d45000 0000000000000033 0000000000000000
[   98.528841] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[   98.536701] 3a40: 000000000000203f 6f6b20726f662064 3227207463656a62 ffff8003fff62280
[   98.544561] 3a60: 0000000000000000 ffff000008e21698 0000000000000006 000000000000203e
[   98.552422] 3a80: 0000000000000000 0000000000000000 ffff0000081e3e54 0000000000497240
[   98.560284] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[   98.566054] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[   98.571648] [<ffff00000850d480>] device_del+0x40/0x210
[   98.576806] [<ffff00000850d664>] device_unregister+0x14/0x2c
[   98.582488] [<ffff00000836201c>] bsg_unregister_queue+0x58/0x9c
[   98.588430] [<ffff0000085514fc>] __scsi_remove_device+0xa0/0xbc
[   98.594373] [<ffff000008551540>] scsi_remove_device+0x28/0x3c
[   98.600141] [<ffff00000855171c>] scsi_remove_target+0x190/0x1d8
[   98.606084] [<ffff000008554a64>] sas_rphy_remove+0x64/0x80
[   98.611591] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[   98.617097] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[   98.623040] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[   98.628809] [<ffff0000080d283c>] worker_thread+0x58/0x438
[   98.634228] [<ffff0000080d8468>] kthread+0xd4/0xe8
[   98.639037] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[   98.644420] sysfs group 'power' not found for kobject '2:0:1:0'
[   98.650372] ------------[ cut here ]------------
[   98.655008] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[   98.663303] Modules linked in:
[   98.666378] 
[   98.667874] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[   98.677914] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[   98.687694] Workqueue: scsi_wq_2 sas_destruct_devices
[   98.692774] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[   98.698716] PC is at sysfs_remove_group+0x8c/0x94
[   98.703438] LR is at sysfs_remove_group+0x8c/0x94
[   98.708160] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[   98.715584] sp : ffff8003f5483b70
[   98.718909] x29: ffff8003f5483b70 [   98.722148] x28: ffff000008d45000 
[   98.725561] 
[   98.727055] x27: ffff8003e5080000 [   98.730292] x26: 0000000000000001 
[   98.733706] 
[   98.735200] x25: ffff000008e06f9a [   98.738438] x24: 0000000000000003 
[   98.741852] 
[   98.743346] x23: ffff8003e5080000 [   98.746584] x22: ffff8003e02fc990 
[   98.749997] 
[   98.751492] x21: ffff8003e02fcc70 [   98.754730] x20: ffff000008de32e0 
[   98.758143] 
[   98.759637] x19: 0000000000000000 [   98.762876] x18: 0000ffffcbcc6090 
[   98.766289] 
[   98.767783] x17: 0000000000497240 [   98.771020] x16: ffff0000081e3e54 
[   98.774433] 
[   98.775927] x15: 0000000000000000 [   98.779165] x14: 0000000000000000 
[   98.782579] 
[   98.784074] x13: 0000000000002095 [   98.787312] x12: 0000000000000002 
[   98.790725] 
[   98.792219] x11: ffff000008e21698 [   98.795457] x10: 0000000000000000 
[   98.798870] 
[   98.800365] x9 : ffff8003fff62280 [   98.803602] x8 : 313a303a32272074 
[   98.807016] 
[   98.808511] x7 : 63656a626f6b2072 [   98.811748] x6 : 0000000000002096 
[   98.815161] 
[   98.816655] x5 : ffff8003f5486218 [   98.819893] x4 : 0000000000000000 
[   98.823306] 
[   98.824800] x3 : 0000000000000000 [   98.828037] x2 : ffff000008d5cd18 
[   98.831451] 
[   98.832945] x1 : 0000000000000000 [   98.836183] x0 : 0000000000000033 
[   98.839596] 
[   98.841090] 
[   98.842584] ---[ end trace d18a42ce2a4e2201 ]---
[   98.847218] Call trace:
[   98.849673] Exception stack(0xffff8003f54839a0 to 0xffff8003f5483ad0)
[   98.856139] 39a0: 0000000000000000 0001000000000000 ffff8003f5483b70 ffff000008252a70
[   98.864001] 39c0: 0000000000000004 0000000000000033 0000000000000000 ffff000008b1ae70
[   98.871862] 39e0: ffff8003f5483a90 ffff0000080fc970 0000000000000000 ffff000008de32e0
[   98.879722] 3a00: ffff8003e02fcc70 ffff8003e02fc990 ffff8003e5080000 0000000000000003
[   98.887583] 3a20: ffff000008e06f9a 0000000000000001 ffff8003e5080000 ffff000008d45000
[   98.895443] 3a40: 0000000000000033 0000000000000000 ffff000008d5cd18 0000000000000000
[   98.903304] 3a60: 0000000000000000 ffff8003f5486218 0000000000002096 63656a626f6b2072
[   98.911165] 3a80: 313a303a32272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[   98.919026] 3aa0: 0000000000000002 0000000000002095 0000000000000000 0000000000000000
[   98.926886] 3ac0: ffff0000081e3e54 0000000000497240
[   98.931783] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[   98.937551] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[   98.943144] [<ffff00000850d480>] device_del+0x40/0x210
[   98.948301] [<ffff00000850d664>] device_unregister+0x14/0x2c
[   98.953982] [<ffff000008551504>] __scsi_remove_device+0xa8/0xbc
[   98.959924] [<ffff000008551540>] scsi_remove_device+0x28/0x3c
[   98.965692] [<ffff00000855171c>] scsi_remove_target+0x190/0x1d8
[   98.971634] [<ffff000008554a64>] sas_rphy_remove+0x64/0x80
[   98.977142] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[   98.982648] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[   98.988591] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[   98.994359] [<ffff0000080d283c>] worker_thread+0x58/0x438
[   98.999778] [<ffff0000080d8468>] kthread+0xd4/0xe8
[   99.004586] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[   99.009941] sysfs group 'power' not found for kobject '2:0:1:0'
[   99.015890] ------------[ cut here ]------------
[   99.020527] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[   99.028822] Modules linked in:
[   99.031897] 
[   99.033393] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[   99.043433] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[   99.053211] Workqueue: scsi_wq_2 sas_destruct_devices
[   99.058291] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[   99.064234] PC is at sysfs_remove_group+0x8c/0x94
[   99.068956] LR is at sysfs_remove_group+0x8c/0x94
[   99.073677] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[   99.081101] sp : ffff8003f5483b90
[   99.084427] x29: ffff8003f5483b90 [   99.087665] x28: ffff000008d45000 
[   99.091078] 
[   99.092572] x27: ffff8003e5080000 [   99.095810] x26: 0000000000000001 
[   99.099223] 
[   99.100716] x25: ffff000008e06f9a [   99.103954] x24: 0000000000000003 
[   99.107368] 
[   99.108862] x23: ffff8003e5080000 [   99.112100] x22: ffff8003e033d028 
[   99.115513] 
[   99.117008] x21: ffff8003e02fc9a0 [   99.120246] x20: ffff000008de32e0 
[   99.123660] 
[   99.125154] x19: 0000000000000000 [   99.128392] x18: 0000ffffcbcc6090 
[   99.131805] 
[   99.133299] x17: 0000000000497240 [   99.136538] x16: ffff0000081e3e54 
[   99.139951] 
[   99.141446] x15: 0000000000000000 [   99.144684] x14: 0000000000000000 
[   99.148097] 
[   99.149592] x13: 00000000000020eb [   99.152830] x12: 0000000000000002 
[   99.156244] 
[   99.157739] x11: ffff000008e21698 [   99.160977] x10: 0000000000000000 
[   99.164391] 
[   99.165885] x9 : ffff8003fff62280 [   99.169123] x8 : 3227207463656a62 
[   99.172537] 
[   99.174031] x7 : 6f6b20726f662064 [   99.177269] x6 : 00000000000020ec 
[   99.180682] 
[   99.182176] x5 : ffff8003f5486218 [   99.185415] x4 : 0000000000000000 
[   99.188829] 
[   99.190322] x3 : 0000000000000000 [   99.193561] x2 : ffff000008d5cd18 
[   99.196974] 
[   99.198468] x1 : 0000000000000000 [   99.201706] x0 : 0000000000000033 
[   99.205120] 
[   99.206613] 
[   99.208107] ---[ end trace d18a42ce2a4e2202 ]---
[   99.212741] Call trace:
[   99.215195] Exception stack(0xffff8003f54839c0 to 0xffff8003f5483af0)
[   99.221660] 39c0: 0000000000000000 0001000000000000 ffff8003f5483b90 ffff000008252a70
[   99.229521] 39e0: 0000000000000004 0000000000000033 0000000000000000 ffff000008b1ae70
[   99.237382] 3a00: ffff8003f5483ab0 ffff0000080fc970 0000000000000000 ffff000008de32e0
[   99.245243] 3a20: ffff8003e02fc9a0 ffff8003e033d028 ffff8003e5080000 0000000000000003
[   99.253103] 3a40: ffff000008e06f9a 0000000000000001 ffff8003e5080000 ffff000008d45000
[   99.260965] 3a60: 0000000000000033 0000000000000000 ffff000008d5cd18 0000000000000000
[   99.268826] 3a80: 0000000000000000 ffff8003f5486218 00000000000020ec 6f6b20726f662064
[   99.276686] 3aa0: 3227207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[   99.284547] 3ac0: 0000000000000002 00000000000020eb 0000000000000000 0000000000000000
[   99.292407] 3ae0: ffff0000081e3e54 0000000000497240
[   99.297304] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[   99.303073] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[   99.308666] [<ffff00000850d480>] device_del+0x40/0x210
[   99.313824] [<ffff000008551514>] __scsi_remove_device+0xb8/0xbc
[   99.319765] [<ffff000008551540>] scsi_remove_device+0x28/0x3c
[   99.325534] [<ffff00000855171c>] scsi_remove_target+0x190/0x1d8
[   99.331476] [<ffff000008554a64>] sas_rphy_remove+0x64/0x80
[   99.336983] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[   99.342488] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[   99.348432] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[   99.354200] [<ffff0000080d283c>] worker_thread+0x58/0x438
[   99.359620] [<ffff0000080d8468>] kthread+0xd4/0xe8
[   99.364428] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[   99.369880] sysfs group 'power' not found for kobject 'target2:0:1'
[   99.376183] ------------[ cut here ]------------
[   99.380820] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[   99.389116] Modules linked in:
[   99.392192] 
[   99.393688] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[   99.403728] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[   99.413508] Workqueue: scsi_wq_2 sas_destruct_devices
[   99.418587] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[   99.424531] PC is at sysfs_remove_group+0x8c/0x94
[   99.429253] LR is at sysfs_remove_group+0x8c/0x94
[   99.433975] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[   99.441399] sp : ffff8003f5483ba0
[   99.444724] x29: ffff8003f5483ba0 [   99.447963] x28: ffff000008d45000 
[   99.451376] 
[   99.452869] x27: ffff8003e5080000 [   99.456107] x26: 0000000000000001 
[   99.459521] 
[   99.461015] x25: ffff000008e06f9a [   99.464253] x24: 0000000000000003 
[   99.467666] 
[   99.469160] x23: ffff8003e5080000 [   99.472398] x22: ffff8003cb256400 
[   99.475812] 
[   99.477306] x21: ffff8003e033d038 [   99.480543] x20: ffff000008de32e0 
[   99.483957] 
[   99.485451] x19: 0000000000000000 [   99.488689] x18: ffff000008971660 
[   99.492103] 
[   99.493597] x17: 000000000000000e [   99.496835] x16: 0000000000000007 
[   99.500248] 
[   99.501742] x15: 0000000000000000 [   99.504980] x14: 0000000000000000 
[   99.508393] 
[   99.509887] x13: 0000000000002140 [   99.513124] x12: 0000000000000002 
[   99.516538] 
[   99.518032] x11: ffff000008e21698 [   99.521270] x10: 0000000000000000 
[   99.524683] 
[   99.526177] x9 : ffff8003fff62280 [   99.529415] x8 : 63656a626f6b2072 
[   99.532829] 
[   99.534323] x7 : 6f6620646e756f66 [   99.537561] x6 : 0000000000002141 
[   99.540974] 
[   99.542469] x5 : ffff8003f5486218 [   99.545706] x4 : 0000000000000000 
[   99.549119] 
[   99.550614] x3 : 0000000000000000 [   99.553851] x2 : ffff000008d5cd18 
[   99.557265] 
[   99.558759] x1 : 0000000000000000 [   99.561996] x0 : 0000000000000037 
[   99.565410] 
[   99.566904] 
[   99.568398] ---[ end trace d18a42ce2a4e2203 ]---
[   99.573031] Call trace:
[   99.575485] Exception stack(0xffff8003f54839d0 to 0xffff8003f5483b00)
[   99.581950] 39c0:                                   0000000000000000 0001000000000000
[   99.589811] 39e0: ffff8003f5483ba0 ffff000008252a70 0000000000000004 0000000000000037
[   99.597673] 3a00: 0000000000000000 ffff000008b1ae70 ffff8003f5483ac0 ffff0000080fc970
[   99.605533] 3a20: 0000000000000000 ffff000008de32e0 ffff8003e033d038 ffff8003cb256400
[   99.613394] 3a40: ffff8003e5080000 0000000000000003 ffff000008e06f9a 0000000000000001
[   99.621255] 3a60: ffff8003e5080000 ffff000008d45000 0000000000000037 0000000000000000
[   99.629115] 3a80: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[   99.636976] 3aa0: 0000000000002141 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[   99.644837] 3ac0: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002140
[   99.652698] 3ae0: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[   99.660560] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[   99.666329] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[   99.671923] [<ffff00000850d480>] device_del+0x40/0x210
[   99.677081] [<ffff00000854d9ac>] scsi_target_reap_ref_release+0x30/0x44
[   99.683721] [<ffff00000854ebb8>] scsi_target_reap+0x3c/0x48
[   99.689315] [<ffff000008551744>] scsi_remove_target+0x1b8/0x1d8
[   99.695258] [<ffff000008554a64>] sas_rphy_remove+0x64/0x80
[   99.700764] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[   99.706270] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[   99.712213] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[   99.717982] [<ffff0000080d283c>] worker_thread+0x58/0x438
[   99.723401] [<ffff0000080d8468>] kthread+0xd4/0xe8
[   99.728211] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[   99.733572] sysfs group 'power' not found for kobject 'end_device-2:1:36'
[   99.740396] ------------[ cut here ]------------
[   99.745032] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[   99.753327] Modules linked in:
[   99.756402] 
[   99.757897] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[   99.767937] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[   99.777716] Workqueue: scsi_wq_2 sas_destruct_devices
[   99.782797] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[   99.788740] PC is at sysfs_remove_group+0x8c/0x94
[   99.793461] LR is at sysfs_remove_group+0x8c/0x94
[   99.798182] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[   99.805605] sp : ffff8003f5483bf0
[   99.808930] x29: ffff8003f5483bf0 [   99.812168] x28: ffff000008d45000 
[   99.815582] 
[   99.817076] x27: 0000000000000000 [   99.820314] x26: 0000000000000000 
[   99.823727] 
[   99.825221] x25: 0000000000000001 [   99.828459] x24: 0000000000000001 
[   99.831871] 
[   99.833365] x23: 0000000000000000 [   99.836603] x22: ffff8003cb256400 
[   99.840017] 
[   99.841511] x21: ffff8003cb2b0010 [   99.844748] x20: ffff000008de32e0 
[   99.848162] 
[   99.849656] x19: 0000000000000000 [   99.852894] x18: ffff000008971660 
[   99.856308] 
[   99.857802] x17: 000000000000000e [   99.861040] x16: 0000000000000007 
[   99.864453] 
[   99.865947] x15: 0000000000000000 [   99.869186] x14: 0000000000000000 
[   99.872598] 
[   99.874092] x13: 0000000000002195 [   99.877331] x12: 0000000000000002 
[   99.880743] 
[   99.882238] x11: ffff000008e21698 [   99.885476] x10: 0000000000000000 
[   99.888890] 
[   99.890384] x9 : ffff8003fff62280 [   99.893622] x8 : 3a322d6563697665 
[   99.897034] 
[   99.898529] x7 : 645f646e65272074 [   99.901766] x6 : 0000000000002196 
[   99.905180] 
[   99.906674] x5 : ffff8003f5486218 [   99.909912] x4 : 0000000000000000 
[   99.913325] 
[   99.914819] x3 : 0000000000000000 [   99.918057] x2 : ffff000008d5cd18 
[   99.921470] 
[   99.922964] x1 : 0000000000000000 [   99.926202] x0 : 000000000000003d 
[   99.929616] 
[   99.931110] 
[   99.932604] ---[ end trace d18a42ce2a4e2204 ]---
[   99.937237] Call trace:
[   99.939692] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[   99.946158] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[   99.954019] 3a40: 0000000000000004 000000000000003d 0000000000000000 ffff000008b1ae70
[   99.961880] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[   99.969740] 3a80: ffff8003cb2b0010 ffff8003cb256400 0000000000000000 0000000000000001
[   99.977601] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[   99.985461] 3ac0: 000000000000003d 0000000000000000 ffff000008d5cd18 0000000000000000
[   99.993323] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002196 645f646e65272074
[  100.001183] 3b00: 3a322d6563697665 ffff8003fff62280 0000000000000000 ffff000008e21698
[  100.009043] 3b20: 0000000000000002 0000000000002195 0000000000000000 0000000000000000
[  100.016904] 3b40: 0000000000000007 000000000000000e
[  100.021801] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  100.027569] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  100.033163] [<ffff00000850d480>] device_del+0x40/0x210
[  100.038321] [<ffff00000850d664>] device_unregister+0x14/0x2c
[  100.044003] [<ffff00000836201c>] bsg_unregister_queue+0x58/0x9c
[  100.049945] [<ffff000008554a44>] sas_rphy_remove+0x44/0x80
[  100.055452] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  100.060958] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  100.066901] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  100.072669] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  100.078088] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  100.082896] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  100.088282] sysfs group 'power' not found for kobject 'end_device-2:1:36'
[  100.095108] ------------[ cut here ]------------
[  100.099745] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  100.108040] Modules linked in:
[  100.111115] 
[  100.112611] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  100.122651] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  100.132430] Workqueue: scsi_wq_2 sas_destruct_devices
[  100.137511] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  100.143454] PC is at sysfs_remove_group+0x8c/0x94
[  100.148177] LR is at sysfs_remove_group+0x8c/0x94
[  100.152899] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[  100.160323] sp : ffff8003f5483b90
[  100.163648] x29: ffff8003f5483b90 [  100.166887] x28: ffff000008d45000 
[  100.170300] 
[  100.171794] x27: 0000000000000000 [  100.175033] x26: 0000000000000000 
[  100.178446] 
[  100.179940] x25: 0000000000000001 [  100.183178] x24: 0000000000000001 
[  100.186592] 
[  100.188086] x23: ffff000008de2000 [  100.191324] x22: ffff8003cb256400 
[  100.194738] 
[  100.196232] x21: ffff8003cb256838 [  100.199470] x20: ffff000008de32e0 
[  100.202883] 
[  100.204377] x19: 0000000000000000 [  100.207615] x18: 0000ffffcbcc6090 
[  100.211028] 
[  100.212522] x17: 0000000000497240 [  100.215760] x16: ffff0000081e3e54 
[  100.219174] 
[  100.220667] x15: 0000000000000000 [  100.223905] x14: 0000000000000000 
[  100.227318] 
[  100.228812] x13: 00000000000021e9 [  100.232049] x12: 0000000000000002 
[  100.235462] 
[  100.236957] x11: ffff000008e21698 [  100.240195] x10: 0000000000000000 
[  100.243608] 
[  100.245103] x9 : ffff8003fff62280 [  100.248341] x8 : 645f646e65272074 
[  100.251754] 
[  100.253247] x7 : 63656a626f6b2072 [  100.256486] x6 : 00000000000021ea 
[  100.259898] 
[  100.261393] x5 : ffff8003f5486218 [  100.264632] x4 : 0000000000000000 
[  100.268045] 
[  100.269539] x3 : 0000000000000000 [  100.272777] x2 : ffff000008d5cd18 
[  100.276190] 
[  100.277685] x1 : 0000000000000000 [  100.280923] x0 : 000000000000003d 
[  100.284337] 
[  100.285831] 
[  100.287325] ---[ end trace d18a42ce2a4e2205 ]---
[  100.291959] Call trace:
[  100.294413] Exception stack(0xffff8003f54839c0 to 0xffff8003f5483af0)
[  100.300880] 39c0: 0000000000000000 0001000000000000 ffff8003f5483b90 ffff000008252a70
[  100.308741] 39e0: 0000000000000004 000000000000003d 0000000000000000 ffff000008b1ae70
[  100.316602] 3a00: ffff8003f5483ab0 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  100.324462] 3a20: ffff8003cb256838 ffff8003cb256400 ffff000008de2000 0000000000000001
[  100.332323] 3a40: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  100.340184] 3a60: 000000000000003d 0000000000000000 ffff000008d5cd18 0000000000000000
[  100.348045] 3a80: 0000000000000000 ffff8003f5486218 00000000000021ea 63656a626f6b2072
[  100.355907] 3aa0: 645f646e65272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  100.363768] 3ac0: 0000000000000002 00000000000021e9 0000000000000000 0000000000000000
[  100.371629] 3ae0: ffff0000081e3e54 0000000000497240
[  100.376526] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  100.382295] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  100.387888] [<ffff00000850d480>] device_del+0x40/0x210
[  100.393047] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  100.400384] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  100.406763] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  100.413927] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  100.420132] [<ffff000008554a4c>] sas_rphy_remove+0x4c/0x80
[  100.425638] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  100.431145] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  100.437088] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  100.442856] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  100.448275] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  100.453084] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  100.458441] sysfs group 'power' not found for kobject 'end_device-2:1:36'
[  100.465262] ------------[ cut here ]------------
[  100.469899] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  100.478194] Modules linked in:
[  100.481268] 
[  100.482763] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  100.492803] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  100.502582] Workqueue: scsi_wq_2 sas_destruct_devices
[  100.507663] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  100.513606] PC is at sysfs_remove_group+0x8c/0x94
[  100.518328] LR is at sysfs_remove_group+0x8c/0x94
[  100.523049] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[  100.530473] sp : ffff8003f5483b90
[  100.533799] x29: ffff8003f5483b90 [  100.537037] x28: ffff000008d45000 
[  100.540450] 
[  100.541944] x27: 0000000000000000 [  100.545183] x26: 0000000000000000 
[  100.548596] 
[  100.550090] x25: 0000000000000001 [  100.553327] x24: 0000000000000001 
[  100.556741] 
[  100.558234] x23: ffff000008de2000 [  100.561473] x22: ffff8003cb256400 
[  100.564887] 
[  100.566381] x21: ffff8003cb256c38 [  100.569620] x20: ffff000008de32e0 
[  100.573033] 
[  100.574527] x19: 0000000000000000 [  100.577765] x18: 0000ffffcbcc6090 
[  100.581178] 
[  100.582671] x17: 0000000000497240 [  100.585909] x16: ffff0000081e3e54 
[  100.589323] 
[  100.590817] x15: 0000000000000000 [  100.594054] x14: 0000000000000000 
[  100.597468] 
[  100.598962] x13: 000000000000223f [  100.602199] x12: 0000000000000002 
[  100.605612] 
[  100.607106] x11: ffff000008e21698 [  100.610344] x10: 0000000000000000 
[  100.613757] 
[  100.615251] x9 : ffff8003fff62280 [  100.618489] x8 : 63697665645f646e 
[  100.621902] 
[  100.623396] x7 : 6527207463656a62 [  100.626634] x6 : 0000000000002240 
[  100.630047] 
[  100.631541] x5 : ffff8003f5486218 [  100.634780] x4 : 0000000000000000 
[  100.638194] 
[  100.639688] x3 : 0000000000000000 [  100.642926] x2 : ffff000008d5cd18 
[  100.646340] 
[  100.647834] x1 : 0000000000000000 [  100.651071] x0 : 000000000000003d 
[  100.654484] 
[  100.655978] 
[  100.657473] ---[ end trace d18a42ce2a4e2206 ]---
[  100.662106] Call trace:
[  100.664560] Exception stack(0xffff8003f54839c0 to 0xffff8003f5483af0)
[  100.671026] 39c0: 0000000000000000 0001000000000000 ffff8003f5483b90 ffff000008252a70
[  100.678887] 39e0: 0000000000000004 000000000000003d 0000000000000000 ffff000008b1ae70
[  100.686748] 3a00: ffff8003f5483ab0 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  100.694609] 3a20: ffff8003cb256c38 ffff8003cb256400 ffff000008de2000 0000000000000001
[  100.702470] 3a40: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  100.710331] 3a60: 000000000000003d 0000000000000000 ffff000008d5cd18 0000000000000000
[  100.718191] 3a80: 0000000000000000 ffff8003f5486218 0000000000002240 6527207463656a62
[  100.726052] 3aa0: 63697665645f646e ffff8003fff62280 0000000000000000 ffff000008e21698
[  100.733912] 3ac0: 0000000000000002 000000000000223f 0000000000000000 0000000000000000
[  100.741773] 3ae0: ffff0000081e3e54 0000000000497240
[  100.746670] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  100.752438] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  100.758031] [<ffff00000850d480>] device_del+0x40/0x210
[  100.763189] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  100.770526] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  100.776905] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  100.784069] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  100.790273] [<ffff000008554a4c>] sas_rphy_remove+0x4c/0x80
[  100.795779] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  100.801285] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  100.807228] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  100.812996] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  100.818415] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  100.823224] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  100.828577] sysfs group 'power' not found for kobject 'end_device-2:1:36'
[  100.835398] ------------[ cut here ]------------
[  100.840034] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  100.848330] Modules linked in:
[  100.851404] 
[  100.852899] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  100.862939] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  100.872718] Workqueue: scsi_wq_2 sas_destruct_devices
[  100.877799] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  100.883741] PC is at sysfs_remove_group+0x8c/0x94
[  100.888464] LR is at sysfs_remove_group+0x8c/0x94
[  100.893186] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[  100.900610] sp : ffff8003f5483c40
[  100.903935] x29: ffff8003f5483c40 [  100.907173] x28: ffff000008d45000 
[  100.910587] 
[  100.912081] x27: 0000000000000000 [  100.915320] x26: 0000000000000000 
[  100.918733] 
[  100.920227] x25: 0000000000000001 [  100.923465] x24: 0000000000000001 
[  100.926878] 
[  100.928373] x23: 0000000000000000 [  100.931611] x22: ffff8003cb255c00 
[  100.935024] 
[  100.936519] x21: ffff8003cb256410 [  100.939756] x20: ffff000008de32e0 
[  100.943169] 
[  100.944663] x19: 0000000000000000 [  100.947901] x18: 0000ffffcbcc6090 
[  100.951313] 
[  100.952808] x17: 0000000000497240 [  100.956045] x16: ffff0000081e3e54 
[  100.959459] 
[  100.960953] x15: 0000000000000000 [  100.964191] x14: 0000000000000000 
[  100.967604] 
[  100.969098] x13: 0000000000002295 [  100.972337] x12: 0000000000000002 
[  100.975750] 
[  100.977244] x11: ffff000008e21698 [  100.980482] x10: 0000000000000000 
[  100.983895] 
[  100.985390] x9 : ffff8003fff62280 [  100.988628] x8 : 3a322d6563697665 
[  100.992040] 
[  100.993534] x7 : 645f646e65272074 [  100.996772] x6 : 0000000000002296 
[  101.000185] 
[  101.001679] x5 : ffff8003f5486218 [  101.004917] x4 : 0000000000000000 
[  101.008331] 
[  101.009825] x3 : 0000000000000000 [  101.013064] x2 : ffff000008d5cd18 
[  101.016476] 
[  101.017971] x1 : 0000000000000000 [  101.021209] x0 : 000000000000003d 
[  101.024622] 
[  101.026116] 
[  101.027611] ---[ end trace d18a42ce2a4e2207 ]---
[  101.032245] Call trace:
[  101.034698] Exception stack(0xffff8003f5483a70 to 0xffff8003f5483ba0)
[  101.041164] 3a60:                                   0000000000000000 0001000000000000
[  101.049025] 3a80: ffff8003f5483c40 ffff000008252a70 0000000000000004 000000000000003d
[  101.056886] 3aa0: 0000000000000000 ffff000008b1ae70 ffff8003f5483b60 ffff0000080fc970
[  101.064746] 3ac0: 0000000000000000 ffff000008de32e0 ffff8003cb256410 ffff8003cb255c00
[  101.072607] 3ae0: 0000000000000000 0000000000000001 0000000000000001 0000000000000000
[  101.080468] 3b00: 0000000000000000 ffff000008d45000 000000000000003d 0000000000000000
[  101.088329] 3b20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  101.096190] 3b40: 0000000000002296 645f646e65272074 3a322d6563697665 ffff8003fff62280
[  101.104051] 3b60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002295
[  101.111912] 3b80: 0000000000000000 0000000000000000 ffff0000081e3e54 0000000000497240
[  101.119773] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  101.125542] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  101.131135] [<ffff00000850d480>] device_del+0x40/0x210
[  101.136294] [<ffff000008554a54>] sas_rphy_remove+0x54/0x80
[  101.141800] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  101.147306] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  101.153248] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  101.159017] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  101.164436] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  101.169245] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  101.174596] hisi_sas_v2_hw a3000000.sas: found dev[1:1] is gone
[  101.180557] hisi_sas_v2_hw a3000000.sas: internal task abort: task to dev 50000d1108e7923e task=ffff8003cb1bbc00 resp: 0x0 sts 0x0
[  101.192440] sysfs group 'power' not found for kobject 'port-2:1:28'
[  101.198744] ------------[ cut here ]------------
[  101.203380] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  101.211675] Modules linked in:
[  101.214750] 
[  101.216246] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  101.226285] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  101.236064] Workqueue: scsi_wq_2 sas_destruct_devices
[  101.241145] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  101.247088] PC is at sysfs_remove_group+0x8c/0x94
[  101.251810] LR is at sysfs_remove_group+0x8c/0x94
[  101.256531] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  101.263955] sp : ffff8003f5483b10
[  101.267280] x29: ffff8003f5483b10 [  101.270517] x28: ffff000008d45000 
[  101.273930] 
[  101.275425] x27: 0000000000000000 [  101.278663] x26: ffff8003cb2556e8 
[  101.282076] 
[  101.283570] x25: ffff8003cb255410 [  101.286808] x24: ffff000008bb9848 
[  101.290222] 
[  101.291716] x23: ffff000008de2000 [  101.294954] x22: ffff8003cb255400 
[  101.298367] 
[  101.299861] x21: ffff8003cb255838 [  101.303099] x20: ffff000008de32e0 
[  101.306512] 
[  101.308006] x19: 0000000000000000 [  101.311244] x18: ffff000008971660 
[  101.314657] 
[  101.316151] x17: 000000000000000e [  101.319388] x16: 0000000000000007 
[  101.322802] 
[  101.324296] x15: 0000000000000000 [  101.327534] x14: 0000000000000000 
[  101.330946] 
[  101.332440] x13: 00000000000022e9 [  101.335678] x12: 0000000000000006 
[  101.339092] 
[  101.340587] x11: ffff000008e21698 [  101.343824] x10: 0000000000000000 
[  101.347237] 
[  101.348731] x9 : ffff8003fff62280 [  101.351969] x8 : 3a313a322d74726f 
[  101.355381] 
[  101.356875] x7 : 7027207463656a62 [  101.360113] x6 : 00000000000022ea 
[  101.363527] 
[  101.365021] x5 : ffff8003f5486218 [  101.368259] x4 : 0000000000000000 
[  101.371673] 
[  101.373167] x3 : 0000000000000000 [  101.376405] x2 : ffff000008d5cd18 
[  101.379819] 
[  101.381312] x1 : 0000000000000000 [  101.384550] x0 : 0000000000000037 
[  101.387963] 
[  101.389457] 
[  101.390951] ---[ end trace d18a42ce2a4e2208 ]---
[  101.395584] Call trace:
[  101.398038] Exception stack(0xffff8003f5483940 to 0xffff8003f5483a70)
[  101.404505] 3940: 0000000000000000 0001000000000000 ffff8003f5483b10 ffff000008252a70
[  101.412366] 3960: 0000000000000004 0000000000000037 0000000000000000 ffff000008b1ae70
[  101.420227] 3980: ffff8003f5483a30 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  101.428088] 39a0: ffff8003cb255838 ffff8003cb255400 ffff000008de2000 ffff000008bb9848
[  101.435948] 39c0: ffff8003cb255410 ffff8003cb2556e8 0000000000000000 ffff000008d45000
[  101.443808] 39e0: 0000000000000037 0000000000000000 ffff000008d5cd18 0000000000000000
[  101.451669] 3a00: 0000000000000000 ffff8003f5486218 00000000000022ea 7027207463656a62
[  101.459529] 3a20: 3a313a322d74726f ffff8003fff62280 0000000000000000 ffff000008e21698
[  101.467390] 3a40: 0000000000000006 00000000000022e9 0000000000000000 0000000000000000
[  101.475250] 3a60: 0000000000000007 000000000000000e
[  101.480147] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  101.485916] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  101.491510] [<ffff00000850d480>] device_del+0x40/0x210
[  101.496668] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  101.504006] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  101.510385] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  101.517549] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  101.523753] [<ffff0000085564d0>] sas_port_delete+0x100/0x138
[  101.529434] [<ffff00000855655c>] do_sas_phy_delete+0x54/0x58
[  101.535115] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  101.541144] [<ffff000008553658>] sas_remove_children+0x24/0x40
[  101.546999] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  101.552943] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  101.558711] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  101.564129] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  101.568937] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  101.574294] sysfs group 'power' not found for kobject 'port-2:1:28'
[  101.580594] ------------[ cut here ]------------
[  101.585230] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  101.593526] Modules linked in:
[  101.596601] 
[  101.598097] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  101.608136] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  101.617914] Workqueue: scsi_wq_2 sas_destruct_devices
[  101.622995] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  101.628938] PC is at sysfs_remove_group+0x8c/0x94
[  101.633660] LR is at sysfs_remove_group+0x8c/0x94
[  101.638381] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  101.645805] sp : ffff8003f5483bc0
[  101.649130] x29: ffff8003f5483bc0 [  101.652368] x28: ffff000008d45000 
[  101.655781] 
[  101.657275] x27: 0000000000000000 [  101.660514] x26: ffff8003cb2556e8 
[  101.663927] 
[  101.665421] x25: ffff8003cb255410 [  101.668659] x24: ffff000008bb9848 
[  101.672073] 
[  101.673567] x23: ffff8003cb255710 [  101.676805] x22: ffff8003cb1e8838 
[  101.680219] 
[  101.681713] x21: ffff8003cb255410 [  101.684950] x20: ffff000008de32e0 
[  101.688364] 
[  101.689859] x19: 0000000000000000 [  101.693096] x18: ffff000008971660 
[  101.696509] 
[  101.698003] x17: 000000000000000e [  101.701242] x16: 0000000000000007 
[  101.704655] 
[  101.706149] x15: 0000000000000000 [  101.709388] x14: 0000000000000000 
[  101.712800] 
[  101.714295] x13: 0000000000002341 [  101.717532] x12: 0000000000000002 
[  101.720945] 
[  101.722440] x11: ffff000008e21698 [  101.725677] x10: 0000000000000000 
[  101.729091] 
[  101.730585] x9 : ffff8003fff62280 [  101.733823] x8 : 63656a626f6b2072 
[  101.737237] 
[  101.738731] x7 : 6f6620646e756f66 [  101.741969] x6 : 0000000000002342 
[  101.745382] 
[  101.746876] x5 : ffff8003f5486218 [  101.750114] x4 : 0000000000000000 
[  101.753527] 
[  101.755021] x3 : 0000000000000000 [  101.758260] x2 : ffff000008d5cd18 
[  101.761673] 
[  101.763168] x1 : 0000000000000000 [  101.766405] x0 : 0000000000000037 
[  101.769819] 
[  101.771312] 
[  101.772806] ---[ end trace d18a42ce2a4e2209 ]---
[  101.777440] Call trace:
[  101.779893] Exception stack(0xffff8003f54839f0 to 0xffff8003f5483b20)
[  101.786358] 39e0:                                   0000000000000000 0001000000000000
[  101.794219] 3a00: ffff8003f5483bc0 ffff000008252a70 0000000000000004 0000000000000037
[  101.802080] 3a20: 0000000000000000 ffff000008b1ae70 ffff8003f5483ae0 ffff0000080fc970
[  101.809941] 3a40: 0000000000000000 ffff000008de32e0 ffff8003cb255410 ffff8003cb1e8838
[  101.817801] 3a60: ffff8003cb255710 ffff000008bb9848 ffff8003cb255410 ffff8003cb2556e8
[  101.825662] 3a80: 0000000000000000 ffff000008d45000 0000000000000037 0000000000000000
[  101.833523] 3aa0: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  101.841384] 3ac0: 0000000000002342 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  101.849244] 3ae0: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002341
[  101.857105] 3b00: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  101.864966] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  101.870735] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  101.876328] [<ffff00000850d480>] device_del+0x40/0x210
[  101.881486] [<ffff0000085564d8>] sas_port_delete+0x108/0x138
[  101.887167] [<ffff00000855655c>] do_sas_phy_delete+0x54/0x58
[  101.892847] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  101.898877] [<ffff000008553658>] sas_remove_children+0x24/0x40
[  101.904732] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  101.910674] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  101.916441] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  101.921860] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  101.926668] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  101.932017] sysfs group 'power' not found for kobject 'port-2:1:36'
[  101.938316] ------------[ cut here ]------------
[  101.942952] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  101.951249] Modules linked in:
[  101.954324] 
[  101.955820] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  101.965860] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  101.975638] Workqueue: scsi_wq_2 sas_destruct_devices
[  101.980718] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  101.986661] PC is at sysfs_remove_group+0x8c/0x94
[  101.991383] LR is at sysfs_remove_group+0x8c/0x94
[  101.996105] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  102.003529] sp : ffff8003f5483b10
[  102.006854] x29: ffff8003f5483b10 [  102.010092] x28: ffff000008d45000 
[  102.013506] 
[  102.015001] x27: 0000000000000000 [  102.018238] x26: ffff8003cb255ee8 
[  102.021652] 
[  102.023146] x25: ffff8003cb255c10 [  102.026384] x24: ffff000008bb9848 
[  102.029797] 
[  102.031292] x23: ffff000008de2000 [  102.034530] x22: ffff8003cb255c00 
[  102.037943] 
[  102.039437] x21: ffff8003cb256038 [  102.042676] x20: ffff000008de32e0 
[  102.046089] 
[  102.047584] x19: 0000000000000000 [  102.050821] x18: ffff000008971660 
[  102.054235] 
[  102.055729] x17: 000000000000000e [  102.058966] x16: 0000000000000007 
[  102.062380] 
[  102.063874] x15: 0000000000000000 [  102.067112] x14: 0000000000000000 
[  102.070525] 
[  102.072019] x13: 0000000000002395 [  102.075257] x12: 0000000000000002 
[  102.078671] 
[  102.080165] x11: ffff000008e21698 [  102.083403] x10: 0000000000000000 
[  102.086816] 
[  102.088310] x9 : ffff8003fff62280 [  102.091548] x8 : 2d74726f70272074 
[  102.094960] 
[  102.096455] x7 : 63656a626f6b2072 [  102.099693] x6 : 0000000000002396 
[  102.103107] 
[  102.104601] x5 : ffff8003f5486218 [  102.107838] x4 : 0000000000000000 
[  102.111251] 
[  102.112745] x3 : 0000000000000000 [  102.115983] x2 : ffff000008d5cd18 
[  102.119396] 
[  102.120890] x1 : 0000000000000000 [  102.124128] x0 : 0000000000000037 
[  102.127542] 
[  102.129035] 
[  102.130530] ---[ end trace d18a42ce2a4e220a ]---
[  102.135163] Call trace:
[  102.137617] Exception stack(0xffff8003f5483940 to 0xffff8003f5483a70)
[  102.144082] 3940: 0000000000000000 0001000000000000 ffff8003f5483b10 ffff000008252a70
[  102.151943] 3960: 0000000000000004 0000000000000037 0000000000000000 ffff000008b1ae70
[  102.159804] 3980: ffff8003f5483a30 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  102.167665] 39a0: ffff8003cb256038 ffff8003cb255c00 ffff000008de2000 ffff000008bb9848
[  102.175526] 39c0: ffff8003cb255c10 ffff8003cb255ee8 0000000000000000 ffff000008d45000
[  102.183387] 39e0: 0000000000000037 0000000000000000 ffff000008d5cd18 0000000000000000
[  102.191247] 3a00: 0000000000000000 ffff8003f5486218 0000000000002396 63656a626f6b2072
[  102.199109] 3a20: 2d74726f70272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  102.206970] 3a40: 0000000000000002 0000000000002395 0000000000000000 0000000000000000
[  102.214830] 3a60: 0000000000000007 000000000000000e
[  102.219727] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  102.225495] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  102.231088] [<ffff00000850d480>] device_del+0x40/0x210
[  102.236246] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  102.243583] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  102.249962] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  102.257126] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  102.263331] [<ffff0000085564d0>] sas_port_delete+0x100/0x138
[  102.269012] [<ffff00000855655c>] do_sas_phy_delete+0x54/0x58
[  102.274692] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  102.280722] [<ffff000008553658>] sas_remove_children+0x24/0x40
[  102.286577] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  102.292520] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  102.298287] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  102.303706] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  102.308514] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  102.313872] sysfs group 'power' not found for kobject 'port-2:1:36'
[  102.320170] ------------[ cut here ]------------
[  102.324806] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  102.333102] Modules linked in:
[  102.336176] 
[  102.337671] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  102.347711] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  102.357490] Workqueue: scsi_wq_2 sas_destruct_devices
[  102.362570] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  102.368513] PC is at sysfs_remove_group+0x8c/0x94
[  102.373235] LR is at sysfs_remove_group+0x8c/0x94
[  102.377956] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  102.385380] sp : ffff8003f5483bc0
[  102.388705] x29: ffff8003f5483bc0 [  102.391944] x28: ffff000008d45000 
[  102.395357] 
[  102.396852] x27: 0000000000000000 [  102.400089] x26: ffff8003cb255ee8 
[  102.403503] 
[  102.404997] x25: ffff8003cb255c10 [  102.408235] x24: ffff000008bb9848 
[  102.411649] 
[  102.413143] x23: ffff8003cb255f10 [  102.416380] x22: ffff8003cb1e8838 
[  102.419794] 
[  102.421289] x21: ffff8003cb255c10 [  102.424526] x20: ffff000008de32e0 
[  102.427940] 
[  102.429434] x19: 0000000000000000 [  102.432671] x18: ffff000008971660 
[  102.436084] 
[  102.437578] x17: 000000000000000e [  102.440816] x16: 0000000000000007 
[  102.444230] 
[  102.445724] x15: 0000000000000000 [  102.448962] x14: 0000000000000000 
[  102.452375] 
[  102.453869] x13: 00000000000023ed [  102.457107] x12: 0000000000000002 
[  102.460519] 
[  102.462013] x11: ffff000008e21698 [  102.465251] x10: 0000000000000000 
[  102.468664] 
[  102.470158] x9 : ffff8003fff62280 [  102.473396] x8 : 3a313a322d74726f 
[  102.476808] 
[  102.478302] x7 : 7027207463656a62 [  102.481540] x6 : 00000000000023ee 
[  102.484953] 
[  102.486448] x5 : ffff8003f5486218 [  102.489686] x4 : 0000000000000000 
[  102.493099] 
[  102.494593] x3 : 0000000000000000 [  102.497832] x2 : ffff000008d5cd18 
[  102.501246] 
[  102.502740] x1 : 0000000000000000 [  102.505978] x0 : 0000000000000037 
[  102.509391] 
[  102.510885] 
[  102.512379] ---[ end trace d18a42ce2a4e220b ]---
[  102.517012] Call trace:
[  102.519466] Exception stack(0xffff8003f54839f0 to 0xffff8003f5483b20)
[  102.525932] 39e0:                                   0000000000000000 0001000000000000
[  102.533792] 3a00: ffff8003f5483bc0 ffff000008252a70 0000000000000004 0000000000000037
[  102.541653] 3a20: 0000000000000000 ffff000008b1ae70 ffff8003f5483ae0 ffff0000080fc970
[  102.549514] 3a40: 0000000000000000 ffff000008de32e0 ffff8003cb255c10 ffff8003cb1e8838
[  102.557375] 3a60: ffff8003cb255f10 ffff000008bb9848 ffff8003cb255c10 ffff8003cb255ee8
[  102.565236] 3a80: 0000000000000000 ffff000008d45000 0000000000000037 0000000000000000
[  102.573097] 3aa0: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  102.580957] 3ac0: 00000000000023ee 7027207463656a62 3a313a322d74726f ffff8003fff62280
[  102.588818] 3ae0: 0000000000000000 ffff000008e21698 0000000000000002 00000000000023ed
[  102.596679] 3b00: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  102.604541] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  102.610309] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  102.615902] [<ffff00000850d480>] device_del+0x40/0x210
[  102.621059] [<ffff0000085564d8>] sas_port_delete+0x108/0x138
[  102.626740] [<ffff00000855655c>] do_sas_phy_delete+0x54/0x58
[  102.632420] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  102.638449] [<ffff000008553658>] sas_remove_children+0x24/0x40
[  102.644305] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  102.650248] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  102.656015] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  102.661434] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  102.666243] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  102.671598] sysfs group 'power' not found for kobject 'phy-2:1:0'
[  102.677722] ------------[ cut here ]------------
[  102.682359] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  102.690654] Modules linked in:
[  102.693728] 
[  102.695224] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  102.705264] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  102.715042] Workqueue: scsi_wq_2 sas_destruct_devices
[  102.720123] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  102.726066] PC is at sysfs_remove_group+0x8c/0x94
[  102.730787] LR is at sysfs_remove_group+0x8c/0x94
[  102.735508] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  102.742932] sp : ffff8003f5483b40
[  102.746258] x29: ffff8003f5483b40 [  102.749496] x28: ffff000008d45000 
[  102.752908] 
[  102.754403] x27: 0000000000000000 [  102.757641] x26: 0000000000000000 
[  102.761054] 
[  102.762548] x25: 0000000000000001 [  102.765786] x24: 0000000000000001 
[  102.769199] 
[  102.770693] x23: ffff000008de2000 [  102.773930] x22: ffff8003f5b52c00 
[  102.777343] 
[  102.778837] x21: ffff8003f5b53038 [  102.782074] x20: ffff000008de32e0 
[  102.785488] 
[  102.786981] x19: 0000000000000000 [  102.790218] x18: ffff000008971660 
[  102.793632] 
[  102.795125] x17: 000000000000000e [  102.798362] x16: 0000000000000007 
[  102.801776] 
[  102.803271] x15: 0000000000000000 [  102.806508] x14: 0000000000000000 
[  102.809921] 
[  102.811416] x13: 0000000000002441 [  102.814653] x12: 0000000000000002 
[  102.818067] 
[  102.819562] x11: ffff000008e21698 [  102.822800] x10: 0000000000000000 
[  102.826213] 
[  102.827707] x9 : ffff8003fff62280 [  102.830944] x8 : 7027207463656a62 
[  102.834357] 
[  102.835852] x7 : 6f6b20726f662064 [  102.839090] x6 : 0000000000002442 
[  102.842504] 
[  102.843997] x5 : ffff8003f5486218 [  102.847235] x4 : 0000000000000000 
[  102.850649] 
[  102.852144] x3 : 0000000000000000 [  102.855382] x2 : ffff000008d5cd18 
[  102.858796] 
[  102.860290] x1 : 0000000000000000 [  102.863528] x0 : 0000000000000035 
[  102.866942] 
[  102.868436] 
[  102.869930] ---[ end trace d18a42ce2a4e220c ]---
[  102.874564] Call trace:
[  102.877018] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  102.883483] 3960:                                   0000000000000000 0001000000000000
[  102.891344] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  102.899204] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  102.907065] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b53038 ffff8003f5b52c00
[  102.914925] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  102.922785] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  102.930646] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  102.938506] 3a40: 0000000000002442 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  102.946367] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002441
[  102.954227] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  102.962088] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  102.967856] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  102.973450] [<ffff00000850d480>] device_del+0x40/0x210
[  102.978607] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  102.985945] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  102.992324] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  102.999487] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  103.005691] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  103.011111] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  103.016793] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  103.022822] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  103.028676] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  103.034619] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  103.040387] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  103.045805] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  103.050613] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  103.055976] sysfs group 'power' not found for kobject 'phy-2:1:0'
[  103.062100] ------------[ cut here ]------------
[  103.066737] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  103.075033] Modules linked in:
[  103.078106] 
[  103.079601] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  103.089642] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  103.099421] Workqueue: scsi_wq_2 sas_destruct_devices
[  103.104502] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  103.110445] PC is at sysfs_remove_group+0x8c/0x94
[  103.115167] LR is at sysfs_remove_group+0x8c/0x94
[  103.119888] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  103.127311] sp : ffff8003f5483bf0
[  103.130636] x29: ffff8003f5483bf0 [  103.133874] x28: ffff000008d45000 
[  103.137288] 
[  103.138782] x27: 0000000000000000 [  103.142020] x26: 0000000000000000 
[  103.145433] 
[  103.146926] x25: 0000000000000001 [  103.150165] x24: 0000000000000001 
[  103.153577] 
[  103.155071] x23: 0000000000000000 [  103.158308] x22: ffff8003cb1e8838 
[  103.161721] 
[  103.163215] x21: ffff8003f5b52c10 [  103.166453] x20: ffff000008de32e0 
[  103.169866] 
[  103.171360] x19: 0000000000000000 [  103.174598] x18: ffff000008971660 
[  103.178010] 
[  103.179504] x17: 000000000000000e [  103.182741] x16: 0000000000000007 
[  103.186155] 
[  103.187649] x15: 0000000000000000 [  103.190887] x14: 0000000000000000 
[  103.194300] 
[  103.195794] x13: 0000000000002499 [  103.199032] x12: 0000000000000002 
[  103.202446] 
[  103.203940] x11: ffff000008e21698 [  103.207178] x10: 0000000000000000 
[  103.210591] 
[  103.212085] x9 : ffff8003fff62280 [  103.215322] x8 : 7027207463656a62 
[  103.218735] 
[  103.220229] x7 : 6f6b20726f662064 [  103.223467] x6 : 000000000000249a 
[  103.226880] 
[  103.228373] x5 : ffff8003f5486218 [  103.231611] x4 : 0000000000000000 
[  103.235025] 
[  103.236518] x3 : 0000000000000000 [  103.239756] x2 : ffff000008d5cd18 
[  103.243170] 
[  103.244663] x1 : 0000000000000000 [  103.247901] x0 : 0000000000000035 
[  103.251314] 
[  103.252808] 
[  103.254302] ---[ end trace d18a42ce2a4e220d ]---
[  103.258936] Call trace:
[  103.261390] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  103.267855] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  103.275716] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  103.283576] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  103.291437] 3a80: ffff8003f5b52c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  103.299297] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  103.307158] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  103.315018] 3ae0: 0000000000000000 ffff8003f5486218 000000000000249a 6f6b20726f662064
[  103.322879] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  103.330740] 3b20: 0000000000000002 0000000000002499 0000000000000000 0000000000000000
[  103.338600] 3b40: 0000000000000007 000000000000000e
[  103.343497] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  103.349266] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  103.354860] [<ffff00000850d480>] device_del+0x40/0x210
[  103.360018] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  103.365437] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  103.371118] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  103.377148] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  103.383004] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  103.388946] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  103.394714] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  103.400133] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  103.404941] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  103.410306] sysfs group 'power' not found for kobject 'phy-2:1:1'
[  103.416430] ------------[ cut here ]------------
[  103.421066] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  103.429362] Modules linked in:
[  103.432436] 
[  103.433931] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  103.443971] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  103.453750] Workqueue: scsi_wq_2 sas_destruct_devices
[  103.458830] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  103.464773] PC is at sysfs_remove_group+0x8c/0x94
[  103.469495] LR is at sysfs_remove_group+0x8c/0x94
[  103.474216] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  103.481640] sp : ffff8003f5483b40
[  103.484966] x29: ffff8003f5483b40 [  103.488204] x28: ffff000008d45000 
[  103.491617] 
[  103.493111] x27: 0000000000000000 [  103.496348] x26: 0000000000000000 
[  103.499761] 
[  103.501255] x25: 0000000000000001 [  103.504493] x24: 0000000000000001 
[  103.507907] 
[  103.509400] x23: ffff000008de2000 [  103.512638] x22: ffff8003f5b53400 
[  103.516052] 
[  103.517546] x21: ffff8003f5b53838 [  103.520784] x20: ffff000008de32e0 
[  103.524197] 
[  103.525691] x19: 0000000000000000 [  103.528929] x18: ffff000008971660 
[  103.532343] 
[  103.533837] x17: 000000000000000e [  103.537074] x16: 0000000000000007 
[  103.540487] 
[  103.541982] x15: 0000000000000000 [  103.545220] x14: 0000000000000000 
[  103.548633] 
[  103.550127] x13: 00000000000024ed [  103.553365] x12: 0000000000000002 
[  103.556778] 
[  103.558271] x11: ffff000008e21698 [  103.561509] x10: 0000000000000000 
[  103.564922] 
[  103.566416] x9 : ffff8003fff62280 [  103.569654] x8 : 63656a626f6b2072 
[  103.573068] 
[  103.574562] x7 : 6f6620646e756f66 [  103.577800] x6 : 00000000000024ee 
[  103.581214] 
[  103.582708] x5 : ffff8003f5486218 [  103.585946] x4 : 0000000000000000 
[  103.589359] 
[  103.590852] x3 : 0000000000000000 [  103.594090] x2 : ffff000008d5cd18 
[  103.597503] 
[  103.598997] x1 : 0000000000000000 [  103.602234] x0 : 0000000000000035 
[  103.605648] 
[  103.607142] 
[  103.608637] ---[ end trace d18a42ce2a4e220e ]---
[  103.613270] Call trace:
[  103.615724] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  103.622190] 3960:                                   0000000000000000 0001000000000000
[  103.630051] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  103.637912] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  103.645773] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b53838 ffff8003f5b53400
[  103.653634] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  103.661494] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  103.669355] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  103.677216] 3a40: 00000000000024ee 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  103.685076] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000024ed
[  103.692937] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  103.700799] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  103.706567] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  103.712161] [<ffff00000850d480>] device_del+0x40/0x210
[  103.717319] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  103.724657] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  103.731035] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  103.738198] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  103.744403] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  103.749822] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  103.755503] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  103.761532] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  103.767387] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  103.773329] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  103.779098] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  103.784516] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  103.789326] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  103.794682] sysfs group 'power' not found for kobject 'phy-2:1:1'
[  103.800806] ------------[ cut here ]------------
[  103.805442] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  103.813738] Modules linked in:
[  103.816811] 
[  103.818307] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  103.828347] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  103.838127] Workqueue: scsi_wq_2 sas_destruct_devices
[  103.843207] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  103.849150] PC is at sysfs_remove_group+0x8c/0x94
[  103.853872] LR is at sysfs_remove_group+0x8c/0x94
[  103.858593] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  103.866017] sp : ffff8003f5483bf0
[  103.869343] x29: ffff8003f5483bf0 [  103.872581] x28: ffff000008d45000 
[  103.875995] 
[  103.877490] x27: 0000000000000000 [  103.880727] x26: 0000000000000000 
[  103.884141] 
[  103.885635] x25: 0000000000000001 [  103.888873] x24: 0000000000000001 
[  103.892287] 
[  103.893780] x23: 0000000000000000 [  103.897018] x22: ffff8003cb1e8838 
[  103.900432] 
[  103.901926] x21: ffff8003f5b53410 [  103.905163] x20: ffff000008de32e0 
[  103.908577] 
[  103.910071] x19: 0000000000000000 [  103.913308] x18: ffff000008971660 
[  103.916722] 
[  103.918216] x17: 000000000000000e [  103.921453] x16: 0000000000000007 
[  103.924866] 
[  103.926360] x15: 0000000000000000 [  103.929597] x14: 0000000000000000 
[  103.933011] 
[  103.934505] x13: 0000000000002545 [  103.937743] x12: 0000000000000002 
[  103.941157] 
[  103.942651] x11: ffff000008e21698 [  103.945888] x10: 0000000000000000 
[  103.949302] 
[  103.950796] x9 : ffff8003fff62280 [  103.954034] x8 : 63656a626f6b2072 
[  103.957447] 
[  103.958942] x7 : 6f6620646e756f66 [  103.962179] x6 : 0000000000002546 
[  103.965593] 
[  103.967087] x5 : ffff8003f5486218 [  103.970324] x4 : 0000000000000000 
[  103.973737] 
[  103.975231] x3 : 0000000000000000 [  103.978469] x2 : ffff000008d5cd18 
[  103.981882] 
[  103.983376] x1 : 0000000000000000 [  103.986614] x0 : 0000000000000035 
[  103.990027] 
[  103.991521] 
[  103.993015] ---[ end trace d18a42ce2a4e220f ]---
[  103.997649] Call trace:
[  104.000103] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  104.006568] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  104.014429] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  104.022289] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  104.030150] 3a80: ffff8003f5b53410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  104.038011] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  104.045872] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  104.053734] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002546 6f6620646e756f66
[  104.061594] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  104.069455] 3b20: 0000000000000002 0000000000002545 0000000000000000 0000000000000000
[  104.077315] 3b40: 0000000000000007 000000000000000e
[  104.082212] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  104.087980] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  104.093573] [<ffff00000850d480>] device_del+0x40/0x210
[  104.098732] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  104.104152] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  104.109833] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  104.115862] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  104.121716] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  104.127659] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  104.133427] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  104.138845] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  104.143654] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  104.149010] sysfs group 'power' not found for kobject 'phy-2:1:2'
[  104.155134] ------------[ cut here ]------------
[  104.159771] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  104.168066] Modules linked in:
[  104.171141] 
[  104.172636] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  104.182676] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  104.192455] Workqueue: scsi_wq_2 sas_destruct_devices
[  104.197536] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  104.203478] PC is at sysfs_remove_group+0x8c/0x94
[  104.208199] LR is at sysfs_remove_group+0x8c/0x94
[  104.212921] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  104.220345] sp : ffff8003f5483b40
[  104.223670] x29: ffff8003f5483b40 [  104.226908] x28: ffff000008d45000 
[  104.230322] 
[  104.231816] x27: 0000000000000000 [  104.235054] x26: 0000000000000000 
[  104.238467] 
[  104.239961] x25: 0000000000000001 [  104.243199] x24: 0000000000000001 
[  104.246613] 
[  104.248107] x23: ffff000008de2000 [  104.251344] x22: ffff8003f5b53c00 
[  104.254758] 
[  104.256252] x21: ffff8003f5b54038 [  104.259489] x20: ffff000008de32e0 
[  104.262902] 
[  104.264396] x19: 0000000000000000 [  104.267634] x18: ffff000008971660 
[  104.271046] 
[  104.272540] x17: 000000000000000e [  104.275778] x16: 0000000000000007 
[  104.279191] 
[  104.280684] x15: 0000000000000000 [  104.283921] x14: 0000000000000000 
[  104.287334] 
[  104.288828] x13: 0000000000002599 [  104.292066] x12: 0000000000000002 
[  104.295479] 
[  104.296973] x11: ffff000008e21698 [  104.300211] x10: 0000000000000000 
[  104.303624] 
[  104.305118] x9 : ffff8003fff62280 [  104.308357] x8 : 323a313a322d7968 
[  104.311770] 
[  104.313265] x7 : 7027207463656a62 [  104.316503] x6 : 000000000000259a 
[  104.319916] 
[  104.321410] x5 : ffff8003f5486218 [  104.324648] x4 : 0000000000000000 
[  104.328062] 
[  104.329556] x3 : 0000000000000000 [  104.332793] x2 : ffff000008d5cd18 
[  104.336206] 
[  104.337700] x1 : 0000000000000000 [  104.340938] x0 : 0000000000000035 
[  104.344351] 
[  104.345845] 
[  104.347339] ---[ end trace d18a42ce2a4e2210 ]---
[  104.351973] Call trace:
[  104.354426] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  104.360891] 3960:                                   0000000000000000 0001000000000000
[  104.368752] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  104.376613] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  104.384474] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b54038 ffff8003f5b53c00
[  104.392334] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  104.400194] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  104.408056] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  104.415917] 3a40: 000000000000259a 7027207463656a62 323a313a322d7968 ffff8003fff62280
[  104.423778] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002599
[  104.431638] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  104.439499] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  104.445268] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  104.450862] [<ffff00000850d480>] device_del+0x40/0x210
[  104.456021] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  104.463359] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  104.469738] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  104.476902] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  104.483106] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  104.488526] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  104.494206] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  104.500236] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  104.506091] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  104.512034] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  104.517803] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  104.523221] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  104.528030] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  104.533393] sysfs group 'power' not found for kobject 'phy-2:1:2'
[  104.539517] ------------[ cut here ]------------
[  104.544153] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  104.552448] Modules linked in:
[  104.555523] 
[  104.557018] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  104.567058] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  104.576838] Workqueue: scsi_wq_2 sas_destruct_devices
[  104.581918] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  104.587861] PC is at sysfs_remove_group+0x8c/0x94
[  104.592583] LR is at sysfs_remove_group+0x8c/0x94
[  104.597304] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  104.604728] sp : ffff8003f5483bf0
[  104.608054] x29: ffff8003f5483bf0 [  104.611291] x28: ffff000008d45000 
[  104.614705] 
[  104.616199] x27: 0000000000000000 [  104.619436] x26: 0000000000000000 
[  104.622850] 
[  104.624344] x25: 0000000000000001 [  104.627582] x24: 0000000000000001 
[  104.630995] 
[  104.632489] x23: 0000000000000000 [  104.635727] x22: ffff8003cb1e8838 
[  104.639141] 
[  104.640635] x21: ffff8003f5b53c10 [  104.643873] x20: ffff000008de32e0 
[  104.647285] 
[  104.648780] x19: 0000000000000000 [  104.652018] x18: ffff000008971660 
[  104.655431] 
[  104.656925] x17: 000000000000000e [  104.660164] x16: 0000000000000007 
[  104.663577] 
[  104.665071] x15: 0000000000000000 [  104.668308] x14: 0000000000000000 
[  104.671722] 
[  104.673216] x13: 00000000000025f1 [  104.676453] x12: 0000000000000002 
[  104.679867] 
[  104.681361] x11: ffff000008e21698 [  104.684599] x10: 0000000000000000 
[  104.688013] 
[  104.689506] x9 : ffff8003fff62280 [  104.692744] x8 : 323a313a322d7968 
[  104.696158] 
[  104.697652] x7 : 7027207463656a62 [  104.700890] x6 : 00000000000025f2 
[  104.704304] 
[  104.705798] x5 : ffff8003f5486218 [  104.709036] x4 : 0000000000000000 
[  104.712449] 
[  104.713944] x3 : 0000000000000000 [  104.717181] x2 : ffff000008d5cd18 
[  104.720595] 
[  104.722089] x1 : 0000000000000000 [  104.725327] x0 : 0000000000000035 
[  104.728740] 
[  104.730234] 
[  104.731729] ---[ end trace d18a42ce2a4e2211 ]---
[  104.736362] Call trace:
[  104.738816] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  104.745282] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  104.753143] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  104.761003] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  104.768864] 3a80: ffff8003f5b53c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  104.776725] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  104.784585] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  104.792445] 3ae0: 0000000000000000 ffff8003f5486218 00000000000025f2 7027207463656a62
[  104.800306] 3b00: 323a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  104.808167] 3b20: 0000000000000002 00000000000025f1 0000000000000000 0000000000000000
[  104.816027] 3b40: 0000000000000007 000000000000000e
[  104.820925] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  104.826693] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  104.832286] [<ffff00000850d480>] device_del+0x40/0x210
[  104.837444] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  104.842863] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  104.848543] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  104.854573] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  104.860427] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  104.866370] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  104.872138] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  104.877557] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  104.882365] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  104.887720] sysfs group 'power' not found for kobject 'phy-2:1:3'
[  104.893842] ------------[ cut here ]------------
[  104.898478] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  104.906773] Modules linked in:
[  104.909847] 
[  104.911342] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  104.921382] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  104.931160] Workqueue: scsi_wq_2 sas_destruct_devices
[  104.936240] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  104.942183] PC is at sysfs_remove_group+0x8c/0x94
[  104.946905] LR is at sysfs_remove_group+0x8c/0x94
[  104.951626] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  104.959050] sp : ffff8003f5483b40
[  104.962375] x29: ffff8003f5483b40 [  104.965612] x28: ffff000008d45000 
[  104.969026] 
[  104.970520] x27: 0000000000000000 [  104.973757] x26: 0000000000000000 
[  104.977171] 
[  104.978665] x25: 0000000000000001 [  104.981902] x24: 0000000000000001 
[  104.985316] 
[  104.986810] x23: ffff000008de2000 [  104.990048] x22: ffff8003f5b54400 
[  104.993461] 
[  104.994955] x21: ffff8003f5b54838 [  104.998194] x20: ffff000008de32e0 
[  105.001607] 
[  105.003101] x19: 0000000000000000 [  105.006339] x18: ffff000008971660 
[  105.009753] 
[  105.011247] x17: 000000000000000e [  105.014484] x16: 0000000000000007 
[  105.017897] 
[  105.019391] x15: 0000000000000000 [  105.022630] x14: 0000000000000000 
[  105.026042] 
[  105.027537] x13: 0000000000002645 [  105.030775] x12: 0000000000000002 
[  105.034188] 
[  105.035682] x11: ffff000008e21698 [  105.038919] x10: 0000000000000000 
[  105.042333] 
[  105.043827] x9 : ffff8003fff62280 [  105.047065] x8 : 322d796870272074 
[  105.050479] 
[  105.051973] x7 : 63656a626f6b2072 [  105.055211] x6 : 0000000000002646 
[  105.058623] 
[  105.060117] x5 : ffff8003f5486218 [  105.063356] x4 : 0000000000000000 
[  105.066768] 
[  105.068263] x3 : 0000000000000000 [  105.071500] x2 : ffff000008d5cd18 
[  105.074914] 
[  105.076408] x1 : 0000000000000000 [  105.079645] x0 : 0000000000000035 
[  105.083059] 
[  105.084553] 
[  105.086048] ---[ end trace d18a42ce2a4e2212 ]---
[  105.090681] Call trace:
[  105.093135] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  105.099601] 3960:                                   0000000000000000 0001000000000000
[  105.107461] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  105.115321] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  105.123181] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b54838 ffff8003f5b54400
[  105.131041] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  105.138901] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  105.146763] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  105.154624] 3a40: 0000000000002646 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  105.162485] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002645
[  105.170345] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  105.178206] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  105.183975] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  105.189569] [<ffff00000850d480>] device_del+0x40/0x210
[  105.194726] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  105.202064] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  105.208443] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  105.215606] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  105.221810] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  105.227230] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  105.232910] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  105.238939] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  105.244794] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  105.250736] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  105.256503] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  105.261922] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  105.266730] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  105.272086] sysfs group 'power' not found for kobject 'phy-2:1:3'
[  105.278209] ------------[ cut here ]------------
[  105.282846] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  105.291142] Modules linked in:
[  105.294216] 
[  105.295711] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  105.305750] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  105.315529] Workqueue: scsi_wq_2 sas_destruct_devices
[  105.320609] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  105.326552] PC is at sysfs_remove_group+0x8c/0x94
[  105.331274] LR is at sysfs_remove_group+0x8c/0x94
[  105.335995] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  105.343419] sp : ffff8003f5483bf0
[  105.346744] x29: ffff8003f5483bf0 [  105.349982] x28: ffff000008d45000 
[  105.353395] 
[  105.354889] x27: 0000000000000000 [  105.358127] x26: 0000000000000000 
[  105.361540] 
[  105.363034] x25: 0000000000000001 [  105.366272] x24: 0000000000000001 
[  105.369685] 
[  105.371179] x23: 0000000000000000 [  105.374416] x22: ffff8003cb1e8838 
[  105.377829] 
[  105.379323] x21: ffff8003f5b54410 [  105.382562] x20: ffff000008de32e0 
[  105.385974] 
[  105.387468] x19: 0000000000000000 [  105.390706] x18: ffff000008971660 
[  105.394119] 
[  105.395614] x17: 000000000000000e [  105.398852] x16: 0000000000000007 
[  105.402266] 
[  105.403760] x15: 0000000000000000 [  105.406998] x14: 0000000000000000 
[  105.410411] 
[  105.411905] x13: 000000000000269d [  105.415143] x12: 0000000000000002 
[  105.418556] 
[  105.420050] x11: ffff000008e21698 [  105.423288] x10: 0000000000000000 
[  105.426701] 
[  105.428195] x9 : ffff8003fff62280 [  105.431433] x8 : 322d796870272074 
[  105.434847] 
[  105.436341] x7 : 63656a626f6b2072 [  105.439579] x6 : 000000000000269e 
[  105.442991] 
[  105.444485] x5 : ffff8003f5486218 [  105.447723] x4 : 0000000000000000 
[  105.451136] 
[  105.452630] x3 : 0000000000000000 [  105.455867] x2 : ffff000008d5cd18 
[  105.459280] 
[  105.460774] x1 : 0000000000000000 [  105.464012] x0 : 0000000000000035 
[  105.467425] 
[  105.468919] 
[  105.470414] ---[ end trace d18a42ce2a4e2213 ]---
[  105.475046] Call trace:
[  105.477499] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  105.483964] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  105.491825] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  105.499686] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  105.507546] 3a80: ffff8003f5b54410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  105.515407] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  105.523267] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  105.531127] 3ae0: 0000000000000000 ffff8003f5486218 000000000000269e 63656a626f6b2072
[  105.538988] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  105.546848] 3b20: 0000000000000002 000000000000269d 0000000000000000 0000000000000000
[  105.554709] 3b40: 0000000000000007 000000000000000e
[  105.559606] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  105.565375] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  105.570968] [<ffff00000850d480>] device_del+0x40/0x210
[  105.576126] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  105.581546] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  105.587226] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  105.593256] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  105.599111] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  105.605053] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  105.610821] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  105.616240] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  105.621048] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  105.626411] sysfs group 'power' not found for kobject 'phy-2:1:4'
[  105.632535] ------------[ cut here ]------------
[  105.637171] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  105.645466] Modules linked in:
[  105.648539] 
[  105.650035] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  105.660075] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  105.669854] Workqueue: scsi_wq_2 sas_destruct_devices
[  105.674934] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  105.680876] PC is at sysfs_remove_group+0x8c/0x94
[  105.685599] LR is at sysfs_remove_group+0x8c/0x94
[  105.690320] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  105.697744] sp : ffff8003f5483b40
[  105.701069] x29: ffff8003f5483b40 [  105.704307] x28: ffff000008d45000 
[  105.707720] 
[  105.709214] x27: 0000000000000000 [  105.712453] x26: 0000000000000000 
[  105.715867] 
[  105.717360] x25: 0000000000000001 [  105.720598] x24: 0000000000000001 
[  105.724012] 
[  105.725505] x23: ffff000008de2000 [  105.728742] x22: ffff8003f5b54c00 
[  105.732156] 
[  105.733650] x21: ffff8003f5b55038 [  105.736888] x20: ffff000008de32e0 
[  105.740302] 
[  105.741796] x19: 0000000000000000 [  105.745034] x18: ffff000008971660 
[  105.748447] 
[  105.749942] x17: 000000000000000e [  105.753179] x16: 0000000000000007 
[  105.756593] 
[  105.758087] x15: 0000000000000000 [  105.761324] x14: 0000000000000000 
[  105.764737] 
[  105.766230] x13: 00000000000026f1 [  105.769468] x12: 0000000000000002 
[  105.772881] 
[  105.774375] x11: ffff000008e21698 [  105.777613] x10: 0000000000000000 
[  105.781026] 
[  105.782520] x9 : ffff8003fff62280 [  105.785758] x8 : 7027207463656a62 
[  105.789171] 
[  105.790665] x7 : 6f6b20726f662064 [  105.793902] x6 : 00000000000026f2 
[  105.797315] 
[  105.798810] x5 : ffff8003f5486218 [  105.802047] x4 : 0000000000000000 
[  105.805461] 
[  105.806955] x3 : 0000000000000000 [  105.810193] x2 : ffff000008d5cd18 
[  105.813606] 
[  105.815101] x1 : 0000000000000000 [  105.818339] x0 : 0000000000000035 
[  105.821752] 
[  105.823245] 
[  105.824740] ---[ end trace d18a42ce2a4e2214 ]---
[  105.829372] Call trace:
[  105.831826] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  105.838292] 3960:                                   0000000000000000 0001000000000000
[  105.846153] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  105.854013] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  105.861873] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b55038 ffff8003f5b54c00
[  105.869734] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  105.877594] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  105.885455] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  105.893316] 3a40: 00000000000026f2 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  105.901177] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000026f1
[  105.909037] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  105.916899] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  105.922668] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  105.928261] [<ffff00000850d480>] device_del+0x40/0x210
[  105.933418] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  105.940755] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  105.947134] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  105.954297] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  105.960501] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  105.965921] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  105.971602] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  105.977631] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  105.983486] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  105.989429] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  105.995197] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  106.000616] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  106.005424] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  106.010780] sysfs group 'power' not found for kobject 'phy-2:1:4'
[  106.016903] ------------[ cut here ]------------
[  106.021539] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  106.029836] Modules linked in:
[  106.032910] 
[  106.034406] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  106.044446] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  106.054225] Workqueue: scsi_wq_2 sas_destruct_devices
[  106.059305] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  106.065248] PC is at sysfs_remove_group+0x8c/0x94
[  106.069970] LR is at sysfs_remove_group+0x8c/0x94
[  106.074692] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  106.082115] sp : ffff8003f5483bf0
[  106.085442] x29: ffff8003f5483bf0 [  106.088679] x28: ffff000008d45000 
[  106.092093] 
[  106.093587] x27: 0000000000000000 [  106.096825] x26: 0000000000000000 
[  106.100238] 
[  106.101732] x25: 0000000000000001 [  106.104970] x24: 0000000000000001 
[  106.108384] 
[  106.109878] x23: 0000000000000000 [  106.113115] x22: ffff8003cb1e8838 
[  106.116529] 
[  106.118023] x21: ffff8003f5b54c10 [  106.121261] x20: ffff000008de32e0 
[  106.124674] 
[  106.126167] x19: 0000000000000000 [  106.129405] x18: ffff000008971660 
[  106.132819] 
[  106.134313] x17: 000000000000000e [  106.137551] x16: 0000000000000007 
[  106.140963] 
[  106.142457] x15: 0000000000000000 [  106.145696] x14: 0000000000000000 
[  106.149109] 
[  106.150603] x13: 0000000000002749 [  106.153841] x12: 0000000000000002 
[  106.157255] 
[  106.158748] x11: ffff000008e21698 [  106.161986] x10: 0000000000000000 
[  106.165398] 
[  106.166893] x9 : ffff8003fff62280 [  106.170130] x8 : 7027207463656a62 
[  106.173543] 
[  106.175036] x7 : 6f6b20726f662064 [  106.178274] x6 : 000000000000274a 
[  106.181687] 
[  106.183182] x5 : ffff8003f5486218 [  106.186419] x4 : 0000000000000000 
[  106.189832] 
[  106.191326] x3 : 0000000000000000 [  106.194564] x2 : ffff000008d5cd18 
[  106.197978] 
[  106.199471] x1 : 0000000000000000 [  106.202709] x0 : 0000000000000035 
[  106.206123] 
[  106.207616] 
[  106.209111] ---[ end trace d18a42ce2a4e2215 ]---
[  106.213744] Call trace:
[  106.216198] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  106.222664] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  106.230525] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  106.238386] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  106.246247] 3a80: ffff8003f5b54c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  106.254107] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  106.261968] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  106.269828] 3ae0: 0000000000000000 ffff8003f5486218 000000000000274a 6f6b20726f662064
[  106.277688] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  106.285549] 3b20: 0000000000000002 0000000000002749 0000000000000000 0000000000000000
[  106.293409] 3b40: 0000000000000007 000000000000000e
[  106.298305] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  106.304073] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  106.309667] [<ffff00000850d480>] device_del+0x40/0x210
[  106.314825] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  106.320245] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  106.325926] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  106.331955] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  106.337810] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  106.343753] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  106.349521] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  106.354939] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  106.359747] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  106.365108] sysfs group 'power' not found for kobject 'phy-2:1:5'
[  106.371232] ------------[ cut here ]------------
[  106.375868] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  106.384164] Modules linked in:
[  106.387238] 
[  106.388734] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  106.398774] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  106.408553] Workqueue: scsi_wq_2 sas_destruct_devices
[  106.413632] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  106.419575] PC is at sysfs_remove_group+0x8c/0x94
[  106.424297] LR is at sysfs_remove_group+0x8c/0x94
[  106.429018] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  106.436442] sp : ffff8003f5483b40
[  106.439768] x29: ffff8003f5483b40 [  106.443006] x28: ffff000008d45000 
[  106.446418] 
[  106.447912] x27: 0000000000000000 [  106.451150] x26: 0000000000000000 
[  106.454563] 
[  106.456057] x25: 0000000000000001 [  106.459295] x24: 0000000000000001 
[  106.462709] 
[  106.464203] x23: ffff000008de2000 [  106.467442] x22: ffff8003f5b55400 
[  106.470855] 
[  106.472350] x21: ffff8003f5b55838 [  106.475587] x20: ffff000008de32e0 
[  106.479000] 
[  106.480495] x19: 0000000000000000 [  106.483733] x18: ffff000008971660 
[  106.487145] 
[  106.488640] x17: 000000000000000e [  106.491877] x16: 0000000000000007 
[  106.495291] 
[  106.496785] x15: 0000000000000000 [  106.500023] x14: 0000000000000000 
[  106.503436] 
[  106.504930] x13: 000000000000279d [  106.508168] x12: 0000000000000002 
[  106.511581] 
[  106.513075] x11: ffff000008e21698 [  106.516312] x10: 0000000000000000 
[  106.519725] 
[  106.521219] x9 : ffff8003fff62280 [  106.524457] x8 : 63656a626f6b2072 
[  106.527870] 
[  106.529364] x7 : 6f6620646e756f66 [  106.532603] x6 : 000000000000279e 
[  106.536015] 
[  106.537510] x5 : ffff8003f5486218 [  106.540748] x4 : 0000000000000000 
[  106.544160] 
[  106.545655] x3 : 0000000000000000 [  106.548892] x2 : ffff000008d5cd18 
[  106.552306] 
[  106.553800] x1 : 0000000000000000 [  106.557038] x0 : 0000000000000035 
[  106.560452] 
[  106.561946] 
[  106.563440] ---[ end trace d18a42ce2a4e2216 ]---
[  106.568074] Call trace:
[  106.570527] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  106.576992] 3960:                                   0000000000000000 0001000000000000
[  106.584854] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  106.592714] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  106.600575] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b55838 ffff8003f5b55400
[  106.608436] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  106.616297] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  106.624157] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  106.632018] 3a40: 000000000000279e 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  106.639878] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 000000000000279d
[  106.647739] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  106.655600] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  106.661369] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  106.666964] [<ffff00000850d480>] device_del+0x40/0x210
[  106.672122] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  106.679459] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  106.685838] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  106.693001] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  106.699205] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  106.704625] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  106.710306] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  106.716336] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  106.722190] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  106.728133] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  106.733902] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  106.739321] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  106.744129] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  106.749491] sysfs group 'power' not found for kobject 'phy-2:1:5'
[  106.755616] ------------[ cut here ]------------
[  106.760252] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  106.768548] Modules linked in:
[  106.771621] 
[  106.773116] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  106.783157] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  106.792935] Workqueue: scsi_wq_2 sas_destruct_devices
[  106.798016] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  106.803958] PC is at sysfs_remove_group+0x8c/0x94
[  106.808680] LR is at sysfs_remove_group+0x8c/0x94
[  106.813401] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  106.820825] sp : ffff8003f5483bf0
[  106.824150] x29: ffff8003f5483bf0 [  106.827388] x28: ffff000008d45000 
[  106.830802] 
[  106.832297] x27: 0000000000000000 [  106.835535] x26: 0000000000000000 
[  106.838948] 
[  106.840442] x25: 0000000000000001 [  106.843680] x24: 0000000000000001 
[  106.847092] 
[  106.848587] x23: 0000000000000000 [  106.851824] x22: ffff8003cb1e8838 
[  106.855238] 
[  106.856732] x21: ffff8003f5b55410 [  106.859970] x20: ffff000008de32e0 
[  106.863383] 
[  106.864877] x19: 0000000000000000 [  106.868115] x18: ffff000008971660 
[  106.871528] 
[  106.873022] x17: 000000000000000e [  106.876260] x16: 0000000000000007 
[  106.879673] 
[  106.881167] x15: 0000000000000000 [  106.884405] x14: 0000000000000000 
[  106.887819] 
[  106.889313] x13: 00000000000027f5 [  106.892551] x12: 0000000000000002 
[  106.895964] 
[  106.897458] x11: ffff000008e21698 [  106.900695] x10: 0000000000000000 
[  106.904109] 
[  106.905603] x9 : ffff8003fff62280 [  106.908841] x8 : 7027207463656a62 
[  106.912254] 
[  106.913748] x7 : 6f6b20726f662064 [  106.916986] x6 : 00000000000027f6 
[  106.920399] 
[  106.921893] x5 : ffff8003f5486218 [  106.925131] x4 : 0000000000000000 
[  106.928544] 
[  106.930038] x3 : 0000000000000000 [  106.933276] x2 : ffff000008d5cd18 
[  106.936690] 
[  106.938184] x1 : 0000000000000000 [  106.941422] x0 : 0000000000000035 
[  106.944836] 
[  106.946330] 
[  106.947824] ---[ end trace d18a42ce2a4e2217 ]---
[  106.952457] Call trace:
[  106.954911] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  106.961376] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  106.969236] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  106.977097] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  106.984957] 3a80: ffff8003f5b55410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  106.992817] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  107.000678] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  107.008539] 3ae0: 0000000000000000 ffff8003f5486218 00000000000027f6 6f6b20726f662064
[  107.016400] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  107.024260] 3b20: 0000000000000002 00000000000027f5 0000000000000000 0000000000000000
[  107.032120] 3b40: 0000000000000007 000000000000000e
[  107.037017] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  107.042786] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  107.048379] [<ffff00000850d480>] device_del+0x40/0x210
[  107.053537] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  107.058956] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  107.064637] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  107.070667] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  107.076522] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  107.082464] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  107.088232] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  107.093651] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  107.098459] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  107.103814] sysfs group 'power' not found for kobject 'phy-2:1:6'
[  107.109937] ------------[ cut here ]------------
[  107.114573] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  107.122869] Modules linked in:
[  107.125943] 
[  107.127438] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  107.137478] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  107.147257] Workqueue: scsi_wq_2 sas_destruct_devices
[  107.152337] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  107.158280] PC is at sysfs_remove_group+0x8c/0x94
[  107.163002] LR is at sysfs_remove_group+0x8c/0x94
[  107.167723] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  107.175147] sp : ffff8003f5483b40
[  107.178472] x29: ffff8003f5483b40 [  107.181711] x28: ffff000008d45000 
[  107.185124] 
[  107.186618] x27: 0000000000000000 [  107.189855] x26: 0000000000000000 
[  107.193269] 
[  107.194763] x25: 0000000000000001 [  107.198001] x24: 0000000000000001 
[  107.201414] 
[  107.202908] x23: ffff000008de2000 [  107.206145] x22: ffff8003f5b55c00 
[  107.209558] 
[  107.211052] x21: ffff8003f5b56038 [  107.214291] x20: ffff000008de32e0 
[  107.217704] 
[  107.219198] x19: 0000000000000000 [  107.222437] x18: ffff000008971660 
[  107.225850] 
[  107.227344] x17: 000000000000000e [  107.230582] x16: 0000000000000007 
[  107.233996] 
[  107.235490] x15: 0000000000000000 [  107.238727] x14: 0000000000000000 
[  107.242140] 
[  107.243634] x13: 0000000000002849 [  107.246872] x12: 0000000000000002 
[  107.250285] 
[  107.251779] x11: ffff000008e21698 [  107.255017] x10: 0000000000000000 
[  107.258431] 
[  107.259925] x9 : ffff8003fff62280 [  107.263163] x8 : 63656a626f6b2072 
[  107.266576] 
[  107.268070] x7 : 6f6620646e756f66 [  107.271308] x6 : 000000000000284a 
[  107.274721] 
[  107.276215] x5 : ffff8003f5486218 [  107.279452] x4 : 0000000000000000 
[  107.282865] 
[  107.284359] x3 : 0000000000000000 [  107.287597] x2 : ffff000008d5cd18 
[  107.291010] 
[  107.292504] x1 : 0000000000000000 [  107.295742] x0 : 0000000000000035 
[  107.299155] 
[  107.300648] 
[  107.302143] ---[ end trace d18a42ce2a4e2218 ]---
[  107.306777] Call trace:
[  107.309231] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  107.315697] 3960:                                   0000000000000000 0001000000000000
[  107.323557] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  107.331418] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  107.339279] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b56038 ffff8003f5b55c00
[  107.347140] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  107.355001] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  107.362861] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  107.370722] 3a40: 000000000000284a 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  107.378582] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002849
[  107.386443] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  107.394305] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  107.400074] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  107.405666] [<ffff00000850d480>] device_del+0x40/0x210
[  107.410824] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  107.418162] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  107.424541] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  107.431704] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  107.437909] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  107.443328] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  107.449009] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  107.455038] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  107.460893] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  107.466835] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  107.472603] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  107.478023] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  107.482832] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  107.488186] sysfs group 'power' not found for kobject 'phy-2:1:6'
[  107.494310] ------------[ cut here ]------------
[  107.498946] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  107.507241] Modules linked in:
[  107.510315] 
[  107.511810] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  107.521850] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  107.531629] Workqueue: scsi_wq_2 sas_destruct_devices
[  107.536708] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  107.542651] PC is at sysfs_remove_group+0x8c/0x94
[  107.547373] LR is at sysfs_remove_group+0x8c/0x94
[  107.552094] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  107.559518] sp : ffff8003f5483bf0
[  107.562844] x29: ffff8003f5483bf0 [  107.566082] x28: ffff000008d45000 
[  107.569495] 
[  107.570989] x27: 0000000000000000 [  107.574227] x26: 0000000000000000 
[  107.577640] 
[  107.579134] x25: 0000000000000001 [  107.582372] x24: 0000000000000001 
[  107.585785] 
[  107.587280] x23: 0000000000000000 [  107.590517] x22: ffff8003cb1e8838 
[  107.593930] 
[  107.595424] x21: ffff8003f5b55c10 [  107.598662] x20: ffff000008de32e0 
[  107.602075] 
[  107.603569] x19: 0000000000000000 [  107.606807] x18: ffff000008971660 
[  107.610220] 
[  107.611713] x17: 000000000000000e [  107.614951] x16: 0000000000000007 
[  107.618365] 
[  107.619859] x15: 0000000000000000 [  107.623097] x14: 0000000000000000 
[  107.626510] 
[  107.628004] x13: 00000000000028a1 [  107.631242] x12: 0000000000000002 
[  107.634655] 
[  107.636149] x11: ffff000008e21698 [  107.639387] x10: 0000000000000000 
[  107.642800] 
[  107.644294] x9 : ffff8003fff62280 [  107.647533] x8 : 63656a626f6b2072 
[  107.650947] 
[  107.652441] x7 : 6f6620646e756f66 [  107.655678] x6 : 00000000000028a2 
[  107.659092] 
[  107.660586] x5 : ffff8003f5486218 [  107.663823] x4 : 0000000000000000 
[  107.667237] 
[  107.668731] x3 : 0000000000000000 [  107.671968] x2 : ffff000008d5cd18 
[  107.675382] 
[  107.676876] x1 : 0000000000000000 [  107.680114] x0 : 0000000000000035 
[  107.683527] 
[  107.685021] 
[  107.686515] ---[ end trace d18a42ce2a4e2219 ]---
[  107.691147] Call trace:
[  107.693602] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  107.700067] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  107.707928] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  107.715788] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  107.723649] 3a80: ffff8003f5b55c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  107.731511] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  107.739371] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  107.747232] 3ae0: 0000000000000000 ffff8003f5486218 00000000000028a2 6f6620646e756f66
[  107.755092] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  107.762953] 3b20: 0000000000000002 00000000000028a1 0000000000000000 0000000000000000
[  107.770814] 3b40: 0000000000000007 000000000000000e
[  107.775710] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  107.781478] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  107.787072] [<ffff00000850d480>] device_del+0x40/0x210
[  107.792230] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  107.797649] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  107.803331] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  107.809360] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  107.815215] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  107.821157] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  107.826925] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  107.832343] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  107.837151] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  107.842507] sysfs group 'power' not found for kobject 'phy-2:1:7'
[  107.848631] ------------[ cut here ]------------
[  107.853268] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  107.861564] Modules linked in:
[  107.864637] 
[  107.866133] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  107.876173] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  107.885952] Workqueue: scsi_wq_2 sas_destruct_devices
[  107.891033] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  107.896976] PC is at sysfs_remove_group+0x8c/0x94
[  107.901698] LR is at sysfs_remove_group+0x8c/0x94
[  107.906419] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  107.913842] sp : ffff8003f5483b40
[  107.917167] x29: ffff8003f5483b40 [  107.920405] x28: ffff000008d45000 
[  107.923818] 
[  107.925312] x27: 0000000000000000 [  107.928550] x26: 0000000000000000 
[  107.931963] 
[  107.933458] x25: 0000000000000001 [  107.936695] x24: 0000000000000001 
[  107.940108] 
[  107.941602] x23: ffff000008de2000 [  107.944839] x22: ffff8003f5b56400 
[  107.948253] 
[  107.949747] x21: ffff8003f5b56838 [  107.952984] x20: ffff000008de32e0 
[  107.956397] 
[  107.957891] x19: 0000000000000000 [  107.961129] x18: ffff000008971660 
[  107.964543] 
[  107.966037] x17: 000000000000000e [  107.969275] x16: 0000000000000007 
[  107.972688] 
[  107.974182] x15: 0000000000000000 [  107.977420] x14: 0000000000000000 
[  107.980834] 
[  107.982328] x13: 00000000000028f5 [  107.985566] x12: 0000000000000002 
[  107.988978] 
[  107.990472] x11: ffff000008e21698 [  107.993710] x10: 0000000000000000 
[  107.997123] 
[  107.998617] x9 : ffff8003fff62280 [  108.001855] x8 : 373a313a322d7968 
[  108.005269] 
[  108.006763] x7 : 7027207463656a62 [  108.010000] x6 : 00000000000028f6 
[  108.013413] 
[  108.014907] x5 : ffff8003f5486218 [  108.018145] x4 : 0000000000000000 
[  108.021558] 
[  108.023052] x3 : 0000000000000000 [  108.026291] x2 : ffff000008d5cd18 
[  108.029704] 
[  108.031198] x1 : 0000000000000000 [  108.034436] x0 : 0000000000000035 
[  108.037849] 
[  108.039343] 
[  108.040838] ---[ end trace d18a42ce2a4e221a ]---
[  108.045471] Call trace:
[  108.047925] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  108.054391] 3960:                                   0000000000000000 0001000000000000
[  108.062251] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  108.070111] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  108.077971] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b56838 ffff8003f5b56400
[  108.085832] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  108.093692] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  108.101553] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  108.109414] 3a40: 00000000000028f6 7027207463656a62 373a313a322d7968 ffff8003fff62280
[  108.117274] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000028f5
[  108.125135] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  108.132996] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  108.138765] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  108.144359] [<ffff00000850d480>] device_del+0x40/0x210
[  108.149516] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  108.156853] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  108.163232] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  108.170396] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  108.176601] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  108.182020] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  108.187701] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  108.193730] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  108.199585] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  108.205528] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  108.211296] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  108.216714] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  108.221523] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  108.226878] sysfs group 'power' not found for kobject 'phy-2:1:7'
[  108.233001] ------------[ cut here ]------------
[  108.237637] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  108.245932] Modules linked in:
[  108.249007] 
[  108.250502] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  108.260542] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  108.270320] Workqueue: scsi_wq_2 sas_destruct_devices
[  108.275402] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  108.281345] PC is at sysfs_remove_group+0x8c/0x94
[  108.286066] LR is at sysfs_remove_group+0x8c/0x94
[  108.290787] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  108.298210] sp : ffff8003f5483bf0
[  108.301535] x29: ffff8003f5483bf0 [  108.304774] x28: ffff000008d45000 
[  108.308187] 
[  108.309682] x27: 0000000000000000 [  108.312919] x26: 0000000000000000 
[  108.316332] 
[  108.317826] x25: 0000000000000001 [  108.321063] x24: 0000000000000001 
[  108.324477] 
[  108.325972] x23: 0000000000000000 [  108.329209] x22: ffff8003cb1e8838 
[  108.332622] 
[  108.334116] x21: ffff8003f5b56410 [  108.337354] x20: ffff000008de32e0 
[  108.340767] 
[  108.342261] x19: 0000000000000000 [  108.345500] x18: ffff000008971660 
[  108.348913] 
[  108.350407] x17: 000000000000000e [  108.353645] x16: 0000000000000007 
[  108.357058] 
[  108.358552] x15: 0000000000000000 [  108.361790] x14: 0000000000000000 
[  108.365203] 
[  108.366697] x13: 000000000000294d [  108.369935] x12: 0000000000000002 
[  108.373349] 
[  108.374843] x11: ffff000008e21698 [  108.378081] x10: 0000000000000000 
[  108.381493] 
[  108.382987] x9 : ffff8003fff62280 [  108.386225] x8 : 373a313a322d7968 
[  108.389639] 
[  108.391133] x7 : 7027207463656a62 [  108.394371] x6 : 000000000000294e 
[  108.397784] 
[  108.399279] x5 : ffff8003f5486218 [  108.402516] x4 : 0000000000000000 
[  108.405930] 
[  108.407423] x3 : 0000000000000000 [  108.410661] x2 : ffff000008d5cd18 
[  108.414075] 
[  108.415569] x1 : 0000000000000000 [  108.418807] x0 : 0000000000000035 
[  108.422220] 
[  108.423714] 
[  108.425208] ---[ end trace d18a42ce2a4e221b ]---
[  108.429841] Call trace:
[  108.432295] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  108.438760] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  108.446621] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  108.454482] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  108.462343] 3a80: ffff8003f5b56410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  108.470203] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  108.478063] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  108.485924] 3ae0: 0000000000000000 ffff8003f5486218 000000000000294e 7027207463656a62
[  108.493785] 3b00: 373a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  108.501646] 3b20: 0000000000000002 000000000000294d 0000000000000000 0000000000000000
[  108.509506] 3b40: 0000000000000007 000000000000000e
[  108.514403] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  108.520172] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  108.525766] [<ffff00000850d480>] device_del+0x40/0x210
[  108.530923] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  108.536343] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  108.542023] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  108.548052] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  108.553907] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  108.559850] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  108.565618] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  108.571037] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  108.575845] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  108.581207] sysfs group 'power' not found for kobject 'phy-2:1:8'
[  108.587331] ------------[ cut here ]------------
[  108.591968] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  108.600263] Modules linked in:
[  108.603336] 
[  108.604832] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  108.614872] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  108.624650] Workqueue: scsi_wq_2 sas_destruct_devices
[  108.629732] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  108.635674] PC is at sysfs_remove_group+0x8c/0x94
[  108.640396] LR is at sysfs_remove_group+0x8c/0x94
[  108.645118] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  108.652541] sp : ffff8003f5483b40
[  108.655866] x29: ffff8003f5483b40 [  108.659104] x28: ffff000008d45000 
[  108.662518] 
[  108.664012] x27: 0000000000000000 [  108.667250] x26: 0000000000000000 
[  108.670663] 
[  108.672157] x25: 0000000000000001 [  108.675394] x24: 0000000000000001 
[  108.678807] 
[  108.680302] x23: ffff000008de2000 [  108.683539] x22: ffff8003f5b56c00 
[  108.686952] 
[  108.688446] x21: ffff8003f5b57038 [  108.691685] x20: ffff000008de32e0 
[  108.695099] 
[  108.696593] x19: 0000000000000000 [  108.699831] x18: ffff000008971660 
[  108.703244] 
[  108.704738] x17: 000000000000000e [  108.707976] x16: 0000000000000007 
[  108.711389] 
[  108.712884] x15: 0000000000000000 [  108.716122] x14: 0000000000000000 
[  108.719536] 
[  108.721030] x13: 00000000000029a1 [  108.724268] x12: 0000000000000002 
[  108.727681] 
[  108.729175] x11: ffff000008e21698 [  108.732413] x10: 0000000000000000 
[  108.735827] 
[  108.737321] x9 : ffff8003fff62280 [  108.740558] x8 : 322d796870272074 
[  108.743972] 
[  108.745466] x7 : 63656a626f6b2072 [  108.748704] x6 : 00000000000029a2 
[  108.752118] 
[  108.753612] x5 : ffff8003f5486218 [  108.756850] x4 : 0000000000000000 
[  108.760263] 
[  108.761758] x3 : 0000000000000000 [  108.764995] x2 : ffff000008d5cd18 
[  108.768408] 
[  108.769902] x1 : 0000000000000000 [  108.773139] x0 : 0000000000000035 
[  108.776552] 
[  108.778046] 
[  108.779540] ---[ end trace d18a42ce2a4e221c ]---
[  108.784173] Call trace:
[  108.786627] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  108.793093] 3960:                                   0000000000000000 0001000000000000
[  108.800954] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  108.808814] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  108.816675] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b57038 ffff8003f5b56c00
[  108.824536] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  108.832396] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  108.840257] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  108.848118] 3a40: 00000000000029a2 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  108.855978] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000029a1
[  108.863839] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  108.871700] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  108.877469] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  108.883063] [<ffff00000850d480>] device_del+0x40/0x210
[  108.888221] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  108.895558] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  108.901937] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  108.909100] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  108.915305] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  108.920724] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  108.926404] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  108.932433] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  108.938288] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  108.944230] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  108.949998] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  108.955417] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  108.960226] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  108.965581] sysfs group 'power' not found for kobject 'phy-2:1:8'
[  108.971706] ------------[ cut here ]------------
[  108.976342] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  108.984637] Modules linked in:
[  108.987710] 
[  108.989205] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  108.999245] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  109.009024] Workqueue: scsi_wq_2 sas_destruct_devices
[  109.014105] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  109.020047] PC is at sysfs_remove_group+0x8c/0x94
[  109.024769] LR is at sysfs_remove_group+0x8c/0x94
[  109.029490] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  109.036914] sp : ffff8003f5483bf0
[  109.040240] x29: ffff8003f5483bf0 [  109.043478] x28: ffff000008d45000 
[  109.046891] 
[  109.048384] x27: 0000000000000000 [  109.051622] x26: 0000000000000000 
[  109.055035] 
[  109.056529] x25: 0000000000000001 [  109.059767] x24: 0000000000000001 
[  109.063180] 
[  109.064674] x23: 0000000000000000 [  109.067912] x22: ffff8003cb1e8838 
[  109.071325] 
[  109.072819] x21: ffff8003f5b56c10 [  109.076057] x20: ffff000008de32e0 
[  109.079470] 
[  109.080964] x19: 0000000000000000 [  109.084201] x18: ffff000008971660 
[  109.087614] 
[  109.089108] x17: 000000000000000e [  109.092346] x16: 0000000000000007 
[  109.095760] 
[  109.097254] x15: 0000000000000000 [  109.100491] x14: 0000000000000000 
[  109.103905] 
[  109.105399] x13: 00000000000029f9 [  109.108637] x12: 0000000000000002 
[  109.112050] 
[  109.113545] x11: ffff000008e21698 [  109.116782] x10: 0000000000000000 
[  109.120196] 
[  109.121690] x9 : ffff8003fff62280 [  109.124927] x8 : 322d796870272074 
[  109.128341] 
[  109.129835] x7 : 63656a626f6b2072 [  109.133073] x6 : 00000000000029fa 
[  109.136486] 
[  109.137980] x5 : ffff8003f5486218 [  109.141218] x4 : 0000000000000000 
[  109.144632] 
[  109.146126] x3 : 0000000000000000 [  109.149364] x2 : ffff000008d5cd18 
[  109.152778] 
[  109.154272] x1 : 0000000000000000 [  109.157510] x0 : 0000000000000035 
[  109.160923] 
[  109.162417] 
[  109.163911] ---[ end trace d18a42ce2a4e221d ]---
[  109.168544] Call trace:
[  109.170998] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  109.177463] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  109.185323] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  109.193183] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  109.201044] 3a80: ffff8003f5b56c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  109.208905] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  109.216766] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  109.224627] 3ae0: 0000000000000000 ffff8003f5486218 00000000000029fa 63656a626f6b2072
[  109.232487] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  109.240348] 3b20: 0000000000000002 00000000000029f9 0000000000000000 0000000000000000
[  109.248208] 3b40: 0000000000000007 000000000000000e
[  109.253105] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  109.258873] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  109.264467] [<ffff00000850d480>] device_del+0x40/0x210
[  109.269625] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  109.275045] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  109.280726] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  109.286756] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  109.292611] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  109.298553] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  109.304322] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  109.309741] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  109.314550] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  109.319905] sysfs group 'power' not found for kobject 'phy-2:1:9'
[  109.326027] ------------[ cut here ]------------
[  109.330663] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  109.338958] Modules linked in:
[  109.342032] 
[  109.343528] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  109.353568] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  109.363347] Workqueue: scsi_wq_2 sas_destruct_devices
[  109.368427] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  109.374370] PC is at sysfs_remove_group+0x8c/0x94
[  109.379091] LR is at sysfs_remove_group+0x8c/0x94
[  109.383813] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  109.391237] sp : ffff8003f5483b40
[  109.394562] x29: ffff8003f5483b40 [  109.397800] x28: ffff000008d45000 
[  109.401214] 
[  109.402708] x27: 0000000000000000 [  109.405946] x26: 0000000000000000 
[  109.409359] 
[  109.410854] x25: 0000000000000001 [  109.414091] x24: 0000000000000001 
[  109.417504] 
[  109.418998] x23: ffff000008de2000 [  109.422235] x22: ffff8003f5b57400 
[  109.425649] 
[  109.427143] x21: ffff8003f5b57838 [  109.430381] x20: ffff000008de32e0 
[  109.433794] 
[  109.435289] x19: 0000000000000000 [  109.438526] x18: ffff000008971660 
[  109.441940] 
[  109.443433] x17: 000000000000000e [  109.446672] x16: 0000000000000007 
[  109.450085] 
[  109.451579] x15: 0000000000000000 [  109.454817] x14: 0000000000000000 
[  109.458231] 
[  109.459725] x13: 0000000000002a4d [  109.462963] x12: 0000000000000002 
[  109.466376] 
[  109.467870] x11: ffff000008e21698 [  109.471108] x10: 0000000000000000 
[  109.474521] 
[  109.476015] x9 : ffff8003fff62280 [  109.479253] x8 : 7027207463656a62 
[  109.482665] 
[  109.484160] x7 : 6f6b20726f662064 [  109.487397] x6 : 0000000000002a4e 
[  109.490810] 
[  109.492304] x5 : ffff8003f5486218 [  109.495542] x4 : 0000000000000000 
[  109.498956] 
[  109.500451] x3 : 0000000000000000 [  109.503689] x2 : ffff000008d5cd18 
[  109.507103] 
[  109.508597] x1 : 0000000000000000 [  109.511835] x0 : 0000000000000035 
[  109.515249] 
[  109.516743] 
[  109.518238] ---[ end trace d18a42ce2a4e221e ]---
[  109.522871] Call trace:
[  109.525324] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  109.531790] 3960:                                   0000000000000000 0001000000000000
[  109.539651] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000035
[  109.547511] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  109.555371] 39c0: 0000000000000000 ffff000008de32e0 ffff8003f5b57838 ffff8003f5b57400
[  109.563232] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  109.571093] 3a00: 0000000000000000 ffff000008d45000 0000000000000035 0000000000000000
[  109.578954] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  109.586814] 3a40: 0000000000002a4e 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  109.594674] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002a4d
[  109.602534] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  109.610396] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  109.616164] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  109.621757] [<ffff00000850d480>] device_del+0x40/0x210
[  109.626916] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  109.634254] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  109.640633] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  109.647796] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  109.654000] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  109.659420] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  109.665100] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  109.671130] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  109.676985] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  109.682927] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  109.688696] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  109.694115] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  109.698924] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  109.704284] sysfs group 'power' not found for kobject 'phy-2:1:9'
[  109.710407] ------------[ cut here ]------------
[  109.715043] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  109.723339] Modules linked in:
[  109.726413] 
[  109.727907] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  109.737947] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  109.747725] Workqueue: scsi_wq_2 sas_destruct_devices
[  109.752806] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  109.758749] PC is at sysfs_remove_group+0x8c/0x94
[  109.763472] LR is at sysfs_remove_group+0x8c/0x94
[  109.768193] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  109.775617] sp : ffff8003f5483bf0
[  109.778942] x29: ffff8003f5483bf0 [  109.782179] x28: ffff000008d45000 
[  109.785593] 
[  109.787088] x27: 0000000000000000 [  109.790326] x26: 0000000000000000 
[  109.793739] 
[  109.795234] x25: 0000000000000001 [  109.798472] x24: 0000000000000001 
[  109.801886] 
[  109.803380] x23: 0000000000000000 [  109.806618] x22: ffff8003cb1e8838 
[  109.810031] 
[  109.811525] x21: ffff8003f5b57410 [  109.814763] x20: ffff000008de32e0 
[  109.818176] 
[  109.819670] x19: 0000000000000000 [  109.822908] x18: ffff000008971660 
[  109.826322] 
[  109.827816] x17: 000000000000000e [  109.831055] x16: 0000000000000007 
[  109.834469] 
[  109.835963] x15: 0000000000000000 [  109.839201] x14: 0000000000000000 
[  109.842613] 
[  109.844108] x13: 0000000000002aa5 [  109.847346] x12: 0000000000000002 
[  109.850760] 
[  109.852254] x11: ffff000008e21698 [  109.855491] x10: 0000000000000000 
[  109.858905] 
[  109.860399] x9 : ffff8003fff62280 [  109.863637] x8 : 7027207463656a62 
[  109.867049] 
[  109.868544] x7 : 6f6b20726f662064 [  109.871782] x6 : 0000000000002aa6 
[  109.875194] 
[  109.876689] x5 : ffff8003f5486218 [  109.879927] x4 : 0000000000000000 
[  109.883340] 
[  109.884834] x3 : 0000000000000000 [  109.888073] x2 : ffff000008d5cd18 
[  109.891486] 
[  109.892980] x1 : 0000000000000000 [  109.896217] x0 : 0000000000000035 
[  109.899630] 
[  109.901124] 
[  109.902618] ---[ end trace d18a42ce2a4e221f ]---
[  109.907251] Call trace:
[  109.909705] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  109.916171] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  109.924032] 3a40: 0000000000000004 0000000000000035 0000000000000000 ffff000008b1ae70
[  109.931893] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  109.939753] 3a80: ffff8003f5b57410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  109.947613] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  109.955475] 3ac0: 0000000000000035 0000000000000000 ffff000008d5cd18 0000000000000000
[  109.963335] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002aa6 6f6b20726f662064
[  109.971196] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  109.979056] 3b20: 0000000000000002 0000000000002aa5 0000000000000000 0000000000000000
[  109.986917] 3b40: 0000000000000007 000000000000000e
[  109.991813] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  109.997582] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  110.003175] [<ffff00000850d480>] device_del+0x40/0x210
[  110.008332] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  110.013752] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  110.019433] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  110.025463] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  110.031318] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  110.037260] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  110.043028] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  110.048446] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  110.053255] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  110.058610] sysfs group 'power' not found for kobject 'phy-2:1:10'
[  110.064822] ------------[ cut here ]------------
[  110.069459] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  110.077754] Modules linked in:
[  110.080829] 
[  110.082324] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  110.092364] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  110.102144] Workqueue: scsi_wq_2 sas_destruct_devices
[  110.107224] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  110.113168] PC is at sysfs_remove_group+0x8c/0x94
[  110.117889] LR is at sysfs_remove_group+0x8c/0x94
[  110.122611] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  110.130034] sp : ffff8003f5483b40
[  110.133360] x29: ffff8003f5483b40 [  110.136597] x28: ffff000008d45000 
[  110.140010] 
[  110.141504] x27: 0000000000000000 [  110.144742] x26: 0000000000000000 
[  110.148156] 
[  110.149650] x25: 0000000000000001 [  110.152888] x24: 0000000000000001 
[  110.156301] 
[  110.157795] x23: ffff000008de2000 [  110.161033] x22: ffff8003f5b57c00 
[  110.164446] 
[  110.165940] x21: ffff8003e4c61438 [  110.169178] x20: ffff000008de32e0 
[  110.172592] 
[  110.174086] x19: 0000000000000000 [  110.177323] x18: ffff000008971660 
[  110.180736] 
[  110.182230] x17: 000000000000000e [  110.185468] x16: 0000000000000007 
[  110.188881] 
[  110.190376] x15: 0000000000000000 [  110.193614] x14: 0000000000000000 
[  110.197027] 
[  110.198521] x13: 0000000000002af9 [  110.201760] x12: 0000000000000002 
[  110.205173] 
[  110.206668] x11: ffff000008e21698 [  110.209906] x10: 0000000000000000 
[  110.213319] 
[  110.214814] x9 : ffff8003fff62280 [  110.218052] x8 : 63656a626f6b2072 
[  110.221465] 
[  110.222959] x7 : 6f6620646e756f66 [  110.226196] x6 : 0000000000002afa 
[  110.229610] 
[  110.231105] x5 : ffff8003f5486218 [  110.234343] x4 : 0000000000000000 
[  110.237757] 
[  110.239251] x3 : 0000000000000000 [  110.242489] x2 : ffff000008d5cd18 
[  110.245903] 
[  110.247397] x1 : 0000000000000000 [  110.250635] x0 : 0000000000000036 
[  110.254048] 
[  110.255542] 
[  110.257035] ---[ end trace d18a42ce2a4e2220 ]---
[  110.261668] Call trace:
[  110.264122] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  110.270587] 3960:                                   0000000000000000 0001000000000000
[  110.278447] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  110.286307] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  110.294168] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c61438 ffff8003f5b57c00
[  110.302028] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  110.309888] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  110.317749] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  110.325610] 3a40: 0000000000002afa 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  110.333471] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002af9
[  110.341330] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  110.349191] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  110.354960] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  110.360554] [<ffff00000850d480>] device_del+0x40/0x210
[  110.365712] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  110.373049] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  110.379428] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  110.386590] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  110.392795] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  110.398215] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  110.403895] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  110.409925] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  110.415780] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  110.421722] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  110.427490] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  110.432909] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  110.437718] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  110.443077] sysfs group 'power' not found for kobject 'phy-2:1:10'
[  110.449288] ------------[ cut here ]------------
[  110.453924] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  110.462220] Modules linked in:
[  110.465294] 
[  110.466788] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  110.476828] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  110.486607] Workqueue: scsi_wq_2 sas_destruct_devices
[  110.491687] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  110.497630] PC is at sysfs_remove_group+0x8c/0x94
[  110.502352] LR is at sysfs_remove_group+0x8c/0x94
[  110.507073] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  110.514497] sp : ffff8003f5483bf0
[  110.517822] x29: ffff8003f5483bf0 [  110.521060] x28: ffff000008d45000 
[  110.524473] 
[  110.525967] x27: 0000000000000000 [  110.529204] x26: 0000000000000000 
[  110.532618] 
[  110.534112] x25: 0000000000000001 [  110.537350] x24: 0000000000000001 
[  110.540763] 
[  110.542257] x23: 0000000000000000 [  110.545495] x22: ffff8003cb1e8838 
[  110.548908] 
[  110.550402] x21: ffff8003f5b57c10 [  110.553640] x20: ffff000008de32e0 
[  110.557054] 
[  110.558548] x19: 0000000000000000 [  110.561786] x18: ffff000008971660 
[  110.565199] 
[  110.566694] x17: 000000000000000e [  110.569932] x16: 0000000000000007 
[  110.573345] 
[  110.574839] x15: 0000000000000000 [  110.578077] x14: 0000000000000000 
[  110.581489] 
[  110.582984] x13: 0000000000002b51 [  110.586222] x12: 0000000000000002 
[  110.589635] 
[  110.591129] x11: ffff000008e21698 [  110.594367] x10: 0000000000000000 
[  110.597780] 
[  110.599273] x9 : ffff8003fff62280 [  110.602511] x8 : 63656a626f6b2072 
[  110.605924] 
[  110.607418] x7 : 6f6620646e756f66 [  110.610656] x6 : 0000000000002b52 
[  110.614070] 
[  110.615564] x5 : ffff8003f5486218 [  110.618802] x4 : 0000000000000000 
[  110.622216] 
[  110.623710] x3 : 0000000000000000 [  110.626948] x2 : ffff000008d5cd18 
[  110.630361] 
[  110.631855] x1 : 0000000000000000 [  110.635093] x0 : 0000000000000036 
[  110.638506] 
[  110.640001] 
[  110.641495] ---[ end trace d18a42ce2a4e2221 ]---
[  110.646128] Call trace:
[  110.648581] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  110.655047] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  110.662908] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  110.670768] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  110.678629] 3a80: ffff8003f5b57c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  110.686490] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  110.694351] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  110.702212] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002b52 6f6620646e756f66
[  110.710073] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  110.717933] 3b20: 0000000000000002 0000000000002b51 0000000000000000 0000000000000000
[  110.725793] 3b40: 0000000000000007 000000000000000e
[  110.730689] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  110.736457] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  110.742051] [<ffff00000850d480>] device_del+0x40/0x210
[  110.747208] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  110.752628] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  110.758308] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  110.764338] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  110.770192] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  110.776134] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  110.781903] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  110.787322] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  110.792130] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  110.797486] sysfs group 'power' not found for kobject 'phy-2:1:11'
[  110.803697] ------------[ cut here ]------------
[  110.808333] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  110.816629] Modules linked in:
[  110.819704] 
[  110.821199] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  110.831239] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  110.841018] Workqueue: scsi_wq_2 sas_destruct_devices
[  110.846098] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  110.852040] PC is at sysfs_remove_group+0x8c/0x94
[  110.856763] LR is at sysfs_remove_group+0x8c/0x94
[  110.861483] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  110.868907] sp : ffff8003f5483b40
[  110.872232] x29: ffff8003f5483b40 [  110.875470] x28: ffff000008d45000 
[  110.878883] 
[  110.880378] x27: 0000000000000000 [  110.883616] x26: 0000000000000000 
[  110.887030] 
[  110.888524] x25: 0000000000000001 [  110.891761] x24: 0000000000000001 
[  110.895175] 
[  110.896669] x23: ffff000008de2000 [  110.899907] x22: ffff8003e4c60800 
[  110.903321] 
[  110.904815] x21: ffff8003e4c60038 [  110.908053] x20: ffff000008de32e0 
[  110.911466] 
[  110.912961] x19: 0000000000000000 [  110.916198] x18: ffff000008971660 
[  110.919612] 
[  110.921106] x17: 000000000000000e [  110.924344] x16: 0000000000000007 
[  110.927756] 
[  110.929251] x15: 0000000000000000 [  110.932489] x14: 0000000000000000 
[  110.935902] 
[  110.937397] x13: 0000000000002ba5 [  110.940635] x12: 0000000000000002 
[  110.944048] 
[  110.945542] x11: ffff000008e21698 [  110.948780] x10: 0000000000000000 
[  110.952193] 
[  110.953687] x9 : ffff8003fff62280 [  110.956925] x8 : 313a313a322d7968 
[  110.960338] 
[  110.961832] x7 : 7027207463656a62 [  110.965070] x6 : 0000000000002ba6 
[  110.968482] 
[  110.969977] x5 : ffff8003f5486218 [  110.973215] x4 : 0000000000000000 
[  110.976629] 
[  110.978123] x3 : 0000000000000000 [  110.981361] x2 : ffff000008d5cd18 
[  110.984773] 
[  110.986268] x1 : 0000000000000000 [  110.989505] x0 : 0000000000000036 
[  110.992918] 
[  110.994412] 
[  110.995907] ---[ end trace d18a42ce2a4e2222 ]---
[  111.000539] Call trace:
[  111.002993] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  111.009459] 3960:                                   0000000000000000 0001000000000000
[  111.017320] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  111.025181] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  111.033041] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c60038 ffff8003e4c60800
[  111.040902] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  111.048762] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  111.056623] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  111.064483] 3a40: 0000000000002ba6 7027207463656a62 313a313a322d7968 ffff8003fff62280
[  111.072344] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002ba5
[  111.080205] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  111.088066] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  111.093835] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  111.099429] [<ffff00000850d480>] device_del+0x40/0x210
[  111.104587] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  111.111924] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  111.118302] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  111.125465] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  111.131669] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  111.137089] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  111.142770] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  111.148799] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  111.154654] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  111.160597] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  111.166365] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  111.171783] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  111.176592] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  111.181947] sysfs group 'power' not found for kobject 'phy-2:1:11'
[  111.188158] ------------[ cut here ]------------
[  111.192794] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  111.201089] Modules linked in:
[  111.204164] 
[  111.205659] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  111.215699] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  111.225478] Workqueue: scsi_wq_2 sas_destruct_devices
[  111.230557] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  111.236500] PC is at sysfs_remove_group+0x8c/0x94
[  111.241222] LR is at sysfs_remove_group+0x8c/0x94
[  111.245942] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  111.253366] sp : ffff8003f5483bf0
[  111.256692] x29: ffff8003f5483bf0 [  111.259930] x28: ffff000008d45000 
[  111.263344] 
[  111.264838] x27: 0000000000000000 [  111.268077] x26: 0000000000000000 
[  111.271490] 
[  111.272985] x25: 0000000000000001 [  111.276222] x24: 0000000000000001 
[  111.279636] 
[  111.281130] x23: 0000000000000000 [  111.284368] x22: ffff8003cb1e8838 
[  111.287782] 
[  111.289276] x21: ffff8003e4c60810 [  111.292514] x20: ffff000008de32e0 
[  111.295926] 
[  111.297420] x19: 0000000000000000 [  111.300658] x18: ffff000008971660 
[  111.304071] 
[  111.305565] x17: 000000000000000e [  111.308802] x16: 0000000000000007 
[  111.312215] 
[  111.313710] x15: 0000000000000000 [  111.316947] x14: 0000000000000000 
[  111.320360] 
[  111.321854] x13: 0000000000002bfd [  111.325091] x12: 0000000000000002 
[  111.328504] 
[  111.329998] x11: ffff000008e21698 [  111.333236] x10: 0000000000000000 
[  111.336650] 
[  111.338144] x9 : ffff8003fff62280 [  111.341382] x8 : 313a313a322d7968 
[  111.344796] 
[  111.346290] x7 : 7027207463656a62 [  111.349528] x6 : 0000000000002bfe 
[  111.352941] 
[  111.354435] x5 : ffff8003f5486218 [  111.357673] x4 : 0000000000000000 
[  111.361086] 
[  111.362580] x3 : 0000000000000000 [  111.365818] x2 : ffff000008d5cd18 
[  111.369231] 
[  111.370725] x1 : 0000000000000000 [  111.373964] x0 : 0000000000000036 
[  111.377378] 
[  111.378872] 
[  111.380366] ---[ end trace d18a42ce2a4e2223 ]---
[  111.385000] Call trace:
[  111.387454] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  111.393920] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  111.401781] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  111.409641] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  111.417500] 3a80: ffff8003e4c60810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  111.425362] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  111.433222] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  111.441083] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002bfe 7027207463656a62
[  111.448943] 3b00: 313a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  111.456804] 3b20: 0000000000000002 0000000000002bfd 0000000000000000 0000000000000000
[  111.464664] 3b40: 0000000000000007 000000000000000e
[  111.469560] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  111.475329] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  111.480923] [<ffff00000850d480>] device_del+0x40/0x210
[  111.486080] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  111.491500] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  111.497180] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  111.503210] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  111.509065] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  111.515007] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  111.520775] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  111.526194] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  111.531002] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  111.536363] sysfs group 'power' not found for kobject 'phy-2:1:12'
[  111.542573] ------------[ cut here ]------------
[  111.547209] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  111.555505] Modules linked in:
[  111.558579] 
[  111.560074] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  111.570114] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  111.579893] Workqueue: scsi_wq_2 sas_destruct_devices
[  111.584974] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  111.590917] PC is at sysfs_remove_group+0x8c/0x94
[  111.595638] LR is at sysfs_remove_group+0x8c/0x94
[  111.600360] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  111.607783] sp : ffff8003f5483b40
[  111.611109] x29: ffff8003f5483b40 [  111.614347] x28: ffff000008d45000 
[  111.617760] 
[  111.619254] x27: 0000000000000000 [  111.622492] x26: 0000000000000000 
[  111.625905] 
[  111.627399] x25: 0000000000000001 [  111.630637] x24: 0000000000000001 
[  111.634051] 
[  111.635546] x23: ffff000008de2000 [  111.638783] x22: ffff8003e4c61800 
[  111.642196] 
[  111.643690] x21: ffff8003e4c61c38 [  111.646928] x20: ffff000008de32e0 
[  111.650341] 
[  111.651835] x19: 0000000000000000 [  111.655072] x18: ffff000008971660 
[  111.658486] 
[  111.659980] x17: 000000000000000e [  111.663218] x16: 0000000000000007 
[  111.666632] 
[  111.668126] x15: 0000000000000000 [  111.671364] x14: 0000000000000000 
[  111.674777] 
[  111.676271] x13: 0000000000002c51 [  111.679509] x12: 0000000000000002 
[  111.682922] 
[  111.684416] x11: ffff000008e21698 [  111.687654] x10: 0000000000000000 
[  111.691067] 
[  111.692561] x9 : ffff8003fff62280 [  111.695799] x8 : 322d796870272074 
[  111.699212] 
[  111.700706] x7 : 63656a626f6b2072 [  111.703945] x6 : 0000000000002c52 
[  111.707358] 
[  111.708853] x5 : ffff8003f5486218 [  111.712090] x4 : 0000000000000000 
[  111.715503] 
[  111.716997] x3 : 0000000000000000 [  111.720234] x2 : ffff000008d5cd18 
[  111.723647] 
[  111.725141] x1 : 0000000000000000 [  111.728378] x0 : 0000000000000036 
[  111.731791] 
[  111.733285] 
[  111.734780] ---[ end trace d18a42ce2a4e2224 ]---
[  111.739413] Call trace:
[  111.741866] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  111.748331] 3960:                                   0000000000000000 0001000000000000
[  111.756192] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  111.764052] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  111.771913] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c61c38 ffff8003e4c61800
[  111.779774] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  111.787635] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  111.795495] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  111.803355] 3a40: 0000000000002c52 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  111.811215] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002c51
[  111.819075] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  111.826937] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  111.832706] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  111.838300] [<ffff00000850d480>] device_del+0x40/0x210
[  111.843457] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  111.850795] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  111.857173] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  111.864337] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  111.870541] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  111.875959] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  111.881640] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  111.887669] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  111.893524] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  111.899468] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  111.905236] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  111.910654] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  111.915463] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  111.920817] sysfs group 'power' not found for kobject 'phy-2:1:12'
[  111.927028] ------------[ cut here ]------------
[  111.931663] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  111.939959] Modules linked in:
[  111.943032] 
[  111.944527] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  111.954567] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  111.964346] Workqueue: scsi_wq_2 sas_destruct_devices
[  111.969427] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  111.975370] PC is at sysfs_remove_group+0x8c/0x94
[  111.980092] LR is at sysfs_remove_group+0x8c/0x94
[  111.984813] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  111.992238] sp : ffff8003f5483bf0
[  111.995563] x29: ffff8003f5483bf0 [  111.998801] x28: ffff000008d45000 
[  112.002215] 
[  112.003710] x27: 0000000000000000 [  112.006947] x26: 0000000000000000 
[  112.010361] 
[  112.011855] x25: 0000000000000001 [  112.015093] x24: 0000000000000001 
[  112.018506] 
[  112.020000] x23: 0000000000000000 [  112.023238] x22: ffff8003cb1e8838 
[  112.026652] 
[  112.028146] x21: ffff8003e4c61810 [  112.031383] x20: ffff000008de32e0 
[  112.034796] 
[  112.036290] x19: 0000000000000000 [  112.039528] x18: ffff000008971660 
[  112.042942] 
[  112.044436] x17: 000000000000000e [  112.047673] x16: 0000000000000007 
[  112.051087] 
[  112.052581] x15: 0000000000000000 [  112.055818] x14: 0000000000000000 
[  112.059231] 
[  112.060725] x13: 0000000000002ca9 [  112.063963] x12: 0000000000000002 
[  112.067377] 
[  112.068871] x11: ffff000008e21698 [  112.072109] x10: 0000000000000000 
[  112.075521] 
[  112.077015] x9 : ffff8003fff62280 [  112.080254] x8 : 322d796870272074 
[  112.083667] 
[  112.085162] x7 : 63656a626f6b2072 [  112.088399] x6 : 0000000000002caa 
[  112.091812] 
[  112.093307] x5 : ffff8003f5486218 [  112.096545] x4 : 0000000000000000 
[  112.099959] 
[  112.101453] x3 : 0000000000000000 [  112.104691] x2 : ffff000008d5cd18 
[  112.108104] 
[  112.109598] x1 : 0000000000000000 [  112.112836] x0 : 0000000000000036 
[  112.116248] 
[  112.117742] 
[  112.119237] ---[ end trace d18a42ce2a4e2225 ]---
[  112.123871] Call trace:
[  112.126325] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  112.132790] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  112.140651] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  112.148511] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  112.156372] 3a80: ffff8003e4c61810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  112.164233] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  112.172093] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  112.179953] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002caa 63656a626f6b2072
[  112.187814] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  112.195675] 3b20: 0000000000000002 0000000000002ca9 0000000000000000 0000000000000000
[  112.203536] 3b40: 0000000000000007 000000000000000e
[  112.208432] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  112.214200] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  112.219794] [<ffff00000850d480>] device_del+0x40/0x210
[  112.224952] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  112.230371] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  112.236053] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  112.242082] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  112.247937] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  112.253879] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  112.259647] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  112.265065] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  112.269875] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  112.275230] sysfs group 'power' not found for kobject 'phy-2:1:13'
[  112.281441] ------------[ cut here ]------------
[  112.286077] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  112.294373] Modules linked in:
[  112.297447] 
[  112.298942] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  112.308982] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  112.318761] Workqueue: scsi_wq_2 sas_destruct_devices
[  112.323841] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  112.329784] PC is at sysfs_remove_group+0x8c/0x94
[  112.334506] LR is at sysfs_remove_group+0x8c/0x94
[  112.339227] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  112.346651] sp : ffff8003f5483b40
[  112.349977] x29: ffff8003f5483b40 [  112.353215] x28: ffff000008d45000 
[  112.356629] 
[  112.358123] x27: 0000000000000000 [  112.361361] x26: 0000000000000000 
[  112.364774] 
[  112.366268] x25: 0000000000000001 [  112.369506] x24: 0000000000000001 
[  112.372920] 
[  112.374414] x23: ffff000008de2000 [  112.377652] x22: ffff8003e4c62000 
[  112.381066] 
[  112.382560] x21: ffff8003e4c61038 [  112.385798] x20: ffff000008de32e0 
[  112.389211] 
[  112.390706] x19: 0000000000000000 [  112.393944] x18: ffff000008971660 
[  112.397357] 
[  112.398850] x17: 000000000000000e [  112.402088] x16: 0000000000000007 
[  112.405501] 
[  112.406996] x15: 0000000000000000 [  112.410233] x14: 0000000000000000 
[  112.413647] 
[  112.415141] x13: 0000000000002cfd [  112.418379] x12: 0000000000000002 
[  112.421793] 
[  112.423287] x11: ffff000008e21698 [  112.426525] x10: 0000000000000000 
[  112.429939] 
[  112.431433] x9 : ffff8003fff62280 [  112.434671] x8 : 7027207463656a62 
[  112.438084] 
[  112.439578] x7 : 6f6b20726f662064 [  112.442815] x6 : 0000000000002cfe 
[  112.446229] 
[  112.447723] x5 : ffff8003f5486218 [  112.450961] x4 : 0000000000000000 
[  112.454374] 
[  112.455868] x3 : 0000000000000000 [  112.459106] x2 : ffff000008d5cd18 
[  112.462518] 
[  112.464012] x1 : 0000000000000000 [  112.467250] x0 : 0000000000000036 
[  112.470664] 
[  112.472158] 
[  112.473652] ---[ end trace d18a42ce2a4e2226 ]---
[  112.478286] Call trace:
[  112.480739] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  112.487205] 3960:                                   0000000000000000 0001000000000000
[  112.495065] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  112.502926] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  112.510787] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c61038 ffff8003e4c62000
[  112.518647] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  112.526507] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  112.534368] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  112.542228] 3a40: 0000000000002cfe 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  112.550090] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002cfd
[  112.557950] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  112.565812] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  112.571581] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  112.577175] [<ffff00000850d480>] device_del+0x40/0x210
[  112.582332] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  112.589670] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  112.596048] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  112.603211] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  112.609415] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  112.614834] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  112.620515] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  112.626544] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  112.632399] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  112.638342] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  112.644109] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  112.649528] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  112.654336] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  112.659696] sysfs group 'power' not found for kobject 'phy-2:1:13'
[  112.665907] ------------[ cut here ]------------
[  112.670542] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  112.678838] Modules linked in:
[  112.681912] 
[  112.683407] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  112.693447] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  112.703226] Workqueue: scsi_wq_2 sas_destruct_devices
[  112.708306] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  112.714250] PC is at sysfs_remove_group+0x8c/0x94
[  112.718971] LR is at sysfs_remove_group+0x8c/0x94
[  112.723692] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  112.731115] sp : ffff8003f5483bf0
[  112.734442] x29: ffff8003f5483bf0 [  112.737679] x28: ffff000008d45000 
[  112.741092] 
[  112.742586] x27: 0000000000000000 [  112.745824] x26: 0000000000000000 
[  112.749237] 
[  112.750731] x25: 0000000000000001 [  112.753969] x24: 0000000000000001 
[  112.757382] 
[  112.758876] x23: 0000000000000000 [  112.762114] x22: ffff8003cb1e8838 
[  112.765528] 
[  112.767022] x21: ffff8003e4c62010 [  112.770259] x20: ffff000008de32e0 
[  112.773673] 
[  112.775166] x19: 0000000000000000 [  112.778404] x18: ffff000008971660 
[  112.781817] 
[  112.783312] x17: 000000000000000e [  112.786549] x16: 0000000000000007 
[  112.789962] 
[  112.791455] x15: 0000000000000000 [  112.794693] x14: 0000000000000000 
[  112.798106] 
[  112.799600] x13: 0000000000002d55 [  112.802837] x12: 0000000000000002 
[  112.806251] 
[  112.807745] x11: ffff000008e21698 [  112.810983] x10: 0000000000000000 
[  112.814396] 
[  112.815891] x9 : ffff8003fff62280 [  112.819128] x8 : 7027207463656a62 
[  112.822541] 
[  112.824034] x7 : 6f6b20726f662064 [  112.827272] x6 : 0000000000002d56 
[  112.830686] 
[  112.832180] x5 : ffff8003f5486218 [  112.835417] x4 : 0000000000000000 
[  112.838830] 
[  112.840324] x3 : 0000000000000000 [  112.843562] x2 : ffff000008d5cd18 
[  112.846975] 
[  112.848469] x1 : 0000000000000000 [  112.851708] x0 : 0000000000000036 
[  112.855120] 
[  112.856614] 
[  112.858108] ---[ end trace d18a42ce2a4e2227 ]---
[  112.862741] Call trace:
[  112.865194] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  112.871660] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  112.879520] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  112.887380] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  112.895241] 3a80: ffff8003e4c62010 ffff8003cb1e8838 0000000000000000 0000000000000001
[  112.903101] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  112.910961] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  112.918822] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002d56 6f6b20726f662064
[  112.926682] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  112.934542] 3b20: 0000000000000002 0000000000002d55 0000000000000000 0000000000000000
[  112.942403] 3b40: 0000000000000007 000000000000000e
[  112.947300] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  112.953069] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  112.958662] [<ffff00000850d480>] device_del+0x40/0x210
[  112.963819] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  112.969238] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  112.974919] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  112.980948] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  112.986803] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  112.992746] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  112.998513] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  113.003932] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  113.008741] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  113.014095] sysfs group 'power' not found for kobject 'phy-2:1:14'
[  113.020306] ------------[ cut here ]------------
[  113.024942] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  113.033238] Modules linked in:
[  113.036313] 
[  113.037808] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  113.047848] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  113.057627] Workqueue: scsi_wq_2 sas_destruct_devices
[  113.062706] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  113.068649] PC is at sysfs_remove_group+0x8c/0x94
[  113.073370] LR is at sysfs_remove_group+0x8c/0x94
[  113.078092] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  113.085515] sp : ffff8003f5483b40
[  113.088841] x29: ffff8003f5483b40 [  113.092079] x28: ffff000008d45000 
[  113.095493] 
[  113.096987] x27: 0000000000000000 [  113.100224] x26: 0000000000000000 
[  113.103638] 
[  113.105132] x25: 0000000000000001 [  113.108369] x24: 0000000000000001 
[  113.111782] 
[  113.113276] x23: ffff000008de2000 [  113.116514] x22: ffff8003e4c60c00 
[  113.119929] 
[  113.121423] x21: ffff8003e4c62438 [  113.124661] x20: ffff000008de32e0 
[  113.128074] 
[  113.129568] x19: 0000000000000000 [  113.132806] x18: ffff000008971660 
[  113.136219] 
[  113.137713] x17: 000000000000000e [  113.140950] x16: 0000000000000007 
[  113.144364] 
[  113.145858] x15: 0000000000000000 [  113.149096] x14: 0000000000000000 
[  113.152509] 
[  113.154003] x13: 0000000000002da9 [  113.157240] x12: 0000000000000002 
[  113.160654] 
[  113.162148] x11: ffff000008e21698 [  113.165386] x10: 0000000000000000 
[  113.168799] 
[  113.170293] x9 : ffff8003fff62280 [  113.173531] x8 : 63656a626f6b2072 
[  113.176945] 
[  113.178439] x7 : 6f6620646e756f66 [  113.181676] x6 : 0000000000002daa 
[  113.185090] 
[  113.186584] x5 : ffff8003f5486218 [  113.189822] x4 : 0000000000000000 
[  113.193236] 
[  113.194729] x3 : 0000000000000000 [  113.197967] x2 : ffff000008d5cd18 
[  113.201379] 
[  113.202873] x1 : 0000000000000000 [  113.206111] x0 : 0000000000000036 
[  113.209525] 
[  113.211018] 
[  113.212512] ---[ end trace d18a42ce2a4e2228 ]---
[  113.217145] Call trace:
[  113.219600] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  113.226065] 3960:                                   0000000000000000 0001000000000000
[  113.233926] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  113.241786] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  113.249647] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c62438 ffff8003e4c60c00
[  113.257508] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  113.265368] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  113.273229] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  113.281089] 3a40: 0000000000002daa 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  113.288949] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002da9
[  113.296810] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  113.304671] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  113.310439] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  113.316033] [<ffff00000850d480>] device_del+0x40/0x210
[  113.321190] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  113.328528] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  113.334906] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  113.342070] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  113.348274] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  113.353694] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  113.359375] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  113.365405] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  113.371259] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  113.377202] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  113.382970] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  113.388389] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  113.393197] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  113.398552] sysfs group 'power' not found for kobject 'phy-2:1:14'
[  113.404763] ------------[ cut here ]------------
[  113.409399] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  113.417694] Modules linked in:
[  113.420767] 
[  113.422263] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  113.432303] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  113.442082] Workqueue: scsi_wq_2 sas_destruct_devices
[  113.447162] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  113.453105] PC is at sysfs_remove_group+0x8c/0x94
[  113.457827] LR is at sysfs_remove_group+0x8c/0x94
[  113.462548] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  113.469971] sp : ffff8003f5483bf0
[  113.473297] x29: ffff8003f5483bf0 [  113.476534] x28: ffff000008d45000 
[  113.479948] 
[  113.481442] x27: 0000000000000000 [  113.484679] x26: 0000000000000000 
[  113.488094] 
[  113.489587] x25: 0000000000000001 [  113.492825] x24: 0000000000000001 
[  113.496238] 
[  113.497732] x23: 0000000000000000 [  113.500970] x22: ffff8003cb1e8838 
[  113.504383] 
[  113.505877] x21: ffff8003e4c60c10 [  113.509114] x20: ffff000008de32e0 
[  113.512528] 
[  113.514022] x19: 0000000000000000 [  113.517260] x18: ffff000008971660 
[  113.520673] 
[  113.522167] x17: 000000000000000e [  113.525406] x16: 0000000000000007 
[  113.528818] 
[  113.530312] x15: 0000000000000000 [  113.533551] x14: 0000000000000000 
[  113.536964] 
[  113.538458] x13: 0000000000002e01 [  113.541696] x12: 0000000000000002 
[  113.545109] 
[  113.546603] x11: ffff000008e21698 [  113.549842] x10: 0000000000000000 
[  113.553254] 
[  113.554749] x9 : ffff8003fff62280 [  113.557987] x8 : 63656a626f6b2072 
[  113.561400] 
[  113.562895] x7 : 6f6620646e756f66 [  113.566133] x6 : 0000000000002e02 
[  113.569545] 
[  113.571039] x5 : ffff8003f5486218 [  113.574277] x4 : 0000000000000000 
[  113.577690] 
[  113.579184] x3 : 0000000000000000 [  113.582423] x2 : ffff000008d5cd18 
[  113.585836] 
[  113.587329] x1 : 0000000000000000 [  113.590567] x0 : 0000000000000036 
[  113.593981] 
[  113.595474] 
[  113.596969] ---[ end trace d18a42ce2a4e2229 ]---
[  113.601602] Call trace:
[  113.604055] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  113.610521] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  113.618382] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  113.626243] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  113.634104] 3a80: ffff8003e4c60c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  113.641965] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  113.649826] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  113.657686] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002e02 6f6620646e756f66
[  113.665546] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  113.673406] 3b20: 0000000000000002 0000000000002e01 0000000000000000 0000000000000000
[  113.681266] 3b40: 0000000000000007 000000000000000e
[  113.686163] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  113.691932] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  113.697525] [<ffff00000850d480>] device_del+0x40/0x210
[  113.702682] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  113.708101] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  113.713781] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  113.719811] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  113.725666] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  113.731608] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  113.737377] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  113.742795] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  113.747605] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  113.752958] sysfs group 'power' not found for kobject 'phy-2:1:15'
[  113.759171] ------------[ cut here ]------------
[  113.763807] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  113.772103] Modules linked in:
[  113.775177] 
[  113.776672] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  113.786712] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  113.796491] Workqueue: scsi_wq_2 sas_destruct_devices
[  113.801571] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  113.807513] PC is at sysfs_remove_group+0x8c/0x94
[  113.812235] LR is at sysfs_remove_group+0x8c/0x94
[  113.816956] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  113.824380] sp : ffff8003f5483b40
[  113.827706] x29: ffff8003f5483b40 [  113.830944] x28: ffff000008d45000 
[  113.834357] 
[  113.835852] x27: 0000000000000000 [  113.839089] x26: 0000000000000000 
[  113.842502] 
[  113.843997] x25: 0000000000000001 [  113.847234] x24: 0000000000000001 
[  113.850648] 
[  113.852143] x23: ffff000008de2000 [  113.855380] x22: ffff8003e4c67800 
[  113.858794] 
[  113.860289] x21: ffff8003e4c67c38 [  113.863527] x20: ffff000008de32e0 
[  113.866940] 
[  113.868433] x19: 0000000000000000 [  113.871672] x18: ffff000008971660 
[  113.875085] 
[  113.876579] x17: 000000000000000e [  113.879817] x16: 0000000000000007 
[  113.883231] 
[  113.884725] x15: 0000000000000000 [  113.887963] x14: 0000000000000000 
[  113.891377] 
[  113.892871] x13: 0000000000002e55 [  113.896108] x12: 0000000000000002 
[  113.899522] 
[  113.901016] x11: ffff000008e21698 [  113.904254] x10: 0000000000000000 
[  113.907667] 
[  113.909160] x9 : ffff8003fff62280 [  113.912398] x8 : 313a313a322d7968 
[  113.915811] 
[  113.917305] x7 : 7027207463656a62 [  113.920543] x6 : 0000000000002e56 
[  113.923955] 
[  113.925449] x5 : ffff8003f5486218 [  113.928687] x4 : 0000000000000000 
[  113.932101] 
[  113.933595] x3 : 0000000000000000 [  113.936833] x2 : ffff000008d5cd18 
[  113.940247] 
[  113.941741] x1 : 0000000000000000 [  113.944979] x0 : 0000000000000036 
[  113.948392] 
[  113.949885] 
[  113.951380] ---[ end trace d18a42ce2a4e222a ]---
[  113.956013] Call trace:
[  113.958467] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  113.964933] 3960:                                   0000000000000000 0001000000000000
[  113.972793] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  113.980654] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  113.988514] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c67c38 ffff8003e4c67800
[  113.996375] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  114.004236] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  114.012097] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  114.019958] 3a40: 0000000000002e56 7027207463656a62 313a313a322d7968 ffff8003fff62280
[  114.027818] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002e55
[  114.035679] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  114.043540] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  114.049308] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  114.054902] [<ffff00000850d480>] device_del+0x40/0x210
[  114.060059] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  114.067397] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  114.073776] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  114.080939] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  114.087143] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  114.092562] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  114.098242] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  114.104271] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  114.110127] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  114.116069] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  114.121837] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  114.127255] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  114.132064] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  114.137421] sysfs group 'power' not found for kobject 'phy-2:1:15'
[  114.143633] ------------[ cut here ]------------
[  114.148270] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  114.156566] Modules linked in:
[  114.159640] 
[  114.161136] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  114.171176] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  114.180955] Workqueue: scsi_wq_2 sas_destruct_devices
[  114.186034] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  114.191976] PC is at sysfs_remove_group+0x8c/0x94
[  114.196698] LR is at sysfs_remove_group+0x8c/0x94
[  114.201419] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  114.208843] sp : ffff8003f5483bf0
[  114.212169] x29: ffff8003f5483bf0 [  114.215407] x28: ffff000008d45000 
[  114.218821] 
[  114.220315] x27: 0000000000000000 [  114.223553] x26: 0000000000000000 
[  114.226967] 
[  114.228461] x25: 0000000000000001 [  114.231700] x24: 0000000000000001 
[  114.235113] 
[  114.236607] x23: 0000000000000000 [  114.239845] x22: ffff8003cb1e8838 
[  114.243259] 
[  114.244753] x21: ffff8003e4c67810 [  114.247991] x20: ffff000008de32e0 
[  114.251404] 
[  114.252898] x19: 0000000000000000 [  114.256136] x18: ffff000008971660 
[  114.259549] 
[  114.261043] x17: 000000000000000e [  114.264281] x16: 0000000000000007 
[  114.267695] 
[  114.269189] x15: 0000000000000000 [  114.272427] x14: 0000000000000000 
[  114.275839] 
[  114.277333] x13: 0000000000002ead [  114.280571] x12: 0000000000000002 
[  114.283985] 
[  114.285479] x11: ffff000008e21698 [  114.288716] x10: 0000000000000000 
[  114.292130] 
[  114.293623] x9 : ffff8003fff62280 [  114.296861] x8 : 313a313a322d7968 
[  114.300275] 
[  114.301768] x7 : 7027207463656a62 [  114.305007] x6 : 0000000000002eae 
[  114.308419] 
[  114.309914] x5 : ffff8003f5486218 [  114.313152] x4 : 0000000000000000 
[  114.316565] 
[  114.318059] x3 : 0000000000000000 [  114.321297] x2 : ffff000008d5cd18 
[  114.324710] 
[  114.326204] x1 : 0000000000000000 [  114.329442] x0 : 0000000000000036 
[  114.332856] 
[  114.334349] 
[  114.335844] ---[ end trace d18a42ce2a4e222b ]---
[  114.340478] Call trace:
[  114.342932] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  114.349398] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  114.357259] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  114.365121] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  114.372980] 3a80: ffff8003e4c67810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  114.380841] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  114.388702] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  114.396562] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002eae 7027207463656a62
[  114.404424] 3b00: 313a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  114.412284] 3b20: 0000000000000002 0000000000002ead 0000000000000000 0000000000000000
[  114.420143] 3b40: 0000000000000007 000000000000000e
[  114.425040] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  114.430809] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  114.436403] [<ffff00000850d480>] device_del+0x40/0x210
[  114.441561] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  114.446980] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  114.452660] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  114.458691] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  114.464546] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  114.470489] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  114.476257] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  114.481676] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  114.486484] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  114.491838] sysfs group 'power' not found for kobject 'phy-2:1:16'
[  114.498048] ------------[ cut here ]------------
[  114.502684] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  114.510979] Modules linked in:
[  114.514053] 
[  114.515549] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  114.525589] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  114.535367] Workqueue: scsi_wq_2 sas_destruct_devices
[  114.540448] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  114.546390] PC is at sysfs_remove_group+0x8c/0x94
[  114.551111] LR is at sysfs_remove_group+0x8c/0x94
[  114.555833] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  114.563257] sp : ffff8003f5483b40
[  114.566582] x29: ffff8003f5483b40 [  114.569820] x28: ffff000008d45000 
[  114.573233] 
[  114.574727] x27: 0000000000000000 [  114.577964] x26: 0000000000000000 
[  114.581378] 
[  114.582873] x25: 0000000000000001 [  114.586110] x24: 0000000000000001 
[  114.589523] 
[  114.591017] x23: ffff000008de2000 [  114.594255] x22: ffff8003e4c67000 
[  114.597668] 
[  114.599162] x21: ffff8003e4c67438 [  114.602400] x20: ffff000008de32e0 
[  114.605813] 
[  114.607307] x19: 0000000000000000 [  114.610545] x18: ffff000008971660 
[  114.613957] 
[  114.615451] x17: 000000000000000e [  114.618689] x16: 0000000000000007 
[  114.622102] 
[  114.623596] x15: 0000000000000000 [  114.626834] x14: 0000000000000000 
[  114.630247] 
[  114.631742] x13: 0000000000002f01 [  114.634979] x12: 0000000000000002 
[  114.638393] 
[  114.639888] x11: ffff000008e21698 [  114.643125] x10: 0000000000000000 
[  114.646538] 
[  114.648033] x9 : ffff8003fff62280 [  114.651270] x8 : 322d796870272074 
[  114.654683] 
[  114.656177] x7 : 63656a626f6b2072 [  114.659415] x6 : 0000000000002f02 
[  114.662828] 
[  114.664322] x5 : ffff8003f5486218 [  114.667560] x4 : 0000000000000000 
[  114.670973] 
[  114.672467] x3 : 0000000000000000 [  114.675705] x2 : ffff000008d5cd18 
[  114.679118] 
[  114.680612] x1 : 0000000000000000 [  114.683849] x0 : 0000000000000036 
[  114.687262] 
[  114.688756] 
[  114.690251] ---[ end trace d18a42ce2a4e222c ]---
[  114.694884] Call trace:
[  114.697338] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  114.703804] 3960:                                   0000000000000000 0001000000000000
[  114.711664] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  114.719526] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  114.727387] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c67438 ffff8003e4c67000
[  114.735247] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  114.743108] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  114.750969] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  114.758829] 3a40: 0000000000002f02 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  114.766689] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002f01
[  114.774549] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  114.782410] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  114.788179] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  114.793772] [<ffff00000850d480>] device_del+0x40/0x210
[  114.798929] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  114.806266] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  114.812645] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  114.819809] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  114.826012] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  114.831432] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  114.837113] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  114.843143] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  114.848997] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  114.854940] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  114.860708] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  114.866128] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  114.870936] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  114.876298] sysfs group 'power' not found for kobject 'phy-2:1:16'
[  114.882509] ------------[ cut here ]------------
[  114.887145] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  114.895441] Modules linked in:
[  114.898515] 
[  114.900011] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  114.910050] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  114.919829] Workqueue: scsi_wq_2 sas_destruct_devices
[  114.924910] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  114.930853] PC is at sysfs_remove_group+0x8c/0x94
[  114.935574] LR is at sysfs_remove_group+0x8c/0x94
[  114.940295] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  114.947719] sp : ffff8003f5483bf0
[  114.951044] x29: ffff8003f5483bf0 [  114.954281] x28: ffff000008d45000 
[  114.957694] 
[  114.959189] x27: 0000000000000000 [  114.962426] x26: 0000000000000000 
[  114.965839] 
[  114.967333] x25: 0000000000000001 [  114.970571] x24: 0000000000000001 
[  114.973985] 
[  114.975479] x23: 0000000000000000 [  114.978716] x22: ffff8003cb1e8838 
[  114.982130] 
[  114.983623] x21: ffff8003e4c67010 [  114.986861] x20: ffff000008de32e0 
[  114.990274] 
[  114.991768] x19: 0000000000000000 [  114.995006] x18: ffff000008971660 
[  114.998420] 
[  114.999914] x17: 000000000000000e [  115.003152] x16: 0000000000000007 
[  115.006566] 
[  115.008060] x15: 0000000000000000 [  115.011298] x14: 0000000000000000 
[  115.014711] 
[  115.016205] x13: 0000000000002f59 [  115.019443] x12: 0000000000000002 
[  115.022855] 
[  115.024350] x11: ffff000008e21698 [  115.027587] x10: 0000000000000000 
[  115.031000] 
[  115.032493] x9 : ffff8003fff62280 [  115.035731] x8 : 322d796870272074 
[  115.039145] 
[  115.040639] x7 : 63656a626f6b2072 [  115.043877] x6 : 0000000000002f5a 
[  115.047290] 
[  115.048784] x5 : ffff8003f5486218 [  115.052021] x4 : 0000000000000000 
[  115.055434] 
[  115.056928] x3 : 0000000000000000 [  115.060166] x2 : ffff000008d5cd18 
[  115.063580] 
[  115.065074] x1 : 0000000000000000 [  115.068312] x0 : 0000000000000036 
[  115.071725] 
[  115.073218] 
[  115.074712] ---[ end trace d18a42ce2a4e222d ]---
[  115.079344] Call trace:
[  115.081798] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  115.088263] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  115.096124] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  115.103985] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  115.111846] 3a80: ffff8003e4c67010 ffff8003cb1e8838 0000000000000000 0000000000000001
[  115.119707] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  115.127568] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  115.135428] 3ae0: 0000000000000000 ffff8003f5486218 0000000000002f5a 63656a626f6b2072
[  115.143289] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  115.151150] 3b20: 0000000000000002 0000000000002f59 0000000000000000 0000000000000000
[  115.159009] 3b40: 0000000000000007 000000000000000e
[  115.163906] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  115.169674] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  115.175268] [<ffff00000850d480>] device_del+0x40/0x210
[  115.180425] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  115.185843] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  115.191524] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  115.197554] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  115.203408] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  115.209351] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  115.215119] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  115.220537] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  115.225346] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  115.230701] sysfs group 'power' not found for kobject 'phy-2:1:17'
[  115.236911] ------------[ cut here ]------------
[  115.241547] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  115.249841] Modules linked in:
[  115.252916] 
[  115.254411] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  115.264450] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  115.274229] Workqueue: scsi_wq_2 sas_destruct_devices
[  115.279310] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  115.285252] PC is at sysfs_remove_group+0x8c/0x94
[  115.289973] LR is at sysfs_remove_group+0x8c/0x94
[  115.294694] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  115.302117] sp : ffff8003f5483b40
[  115.305442] x29: ffff8003f5483b40 [  115.308680] x28: ffff000008d45000 
[  115.312094] 
[  115.313588] x27: 0000000000000000 [  115.316826] x26: 0000000000000000 
[  115.320239] 
[  115.321734] x25: 0000000000000001 [  115.324971] x24: 0000000000000001 
[  115.328385] 
[  115.329879] x23: ffff000008de2000 [  115.333117] x22: ffff8003e4c66800 
[  115.336530] 
[  115.338024] x21: ffff8003e4c66c38 [  115.341262] x20: ffff000008de32e0 
[  115.344676] 
[  115.346170] x19: 0000000000000000 [  115.349408] x18: ffff000008971660 
[  115.352821] 
[  115.354316] x17: 000000000000000e [  115.357554] x16: 0000000000000007 
[  115.360967] 
[  115.362461] x15: 0000000000000000 [  115.365699] x14: 0000000000000000 
[  115.369113] 
[  115.370607] x13: 0000000000002fad [  115.373845] x12: 0000000000000002 
[  115.377259] 
[  115.378753] x11: ffff000008e21698 [  115.381990] x10: 0000000000000000 
[  115.385404] 
[  115.386898] x9 : ffff8003fff62280 [  115.390135] x8 : 7027207463656a62 
[  115.393549] 
[  115.395043] x7 : 6f6b20726f662064 [  115.398282] x6 : 0000000000002fae 
[  115.401695] 
[  115.403189] x5 : ffff8003f5486218 [  115.406428] x4 : 0000000000000000 
[  115.409840] 
[  115.411335] x3 : 0000000000000000 [  115.414572] x2 : ffff000008d5cd18 
[  115.417986] 
[  115.419480] x1 : 0000000000000000 [  115.422717] x0 : 0000000000000036 
[  115.426130] 
[  115.427624] 
[  115.429119] ---[ end trace d18a42ce2a4e222e ]---
[  115.433752] Call trace:
[  115.436206] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  115.442670] 3960:                                   0000000000000000 0001000000000000
[  115.450531] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  115.458392] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  115.466253] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c66c38 ffff8003e4c66800
[  115.474114] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  115.481974] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  115.489834] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  115.497694] 3a40: 0000000000002fae 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  115.505555] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000002fad
[  115.513416] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  115.521277] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  115.527046] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  115.532639] [<ffff00000850d480>] device_del+0x40/0x210
[  115.537797] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  115.545134] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  115.551513] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  115.558677] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  115.564881] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  115.570300] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  115.575981] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  115.582010] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  115.587865] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  115.593808] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  115.599575] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  115.604995] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  115.609803] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  115.615158] sysfs group 'power' not found for kobject 'phy-2:1:17'
[  115.621368] ------------[ cut here ]------------
[  115.626003] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  115.634299] Modules linked in:
[  115.637373] 
[  115.638868] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  115.648908] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  115.658687] Workqueue: scsi_wq_2 sas_destruct_devices
[  115.663766] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  115.669709] PC is at sysfs_remove_group+0x8c/0x94
[  115.674430] LR is at sysfs_remove_group+0x8c/0x94
[  115.679151] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  115.686575] sp : ffff8003f5483bf0
[  115.689901] x29: ffff8003f5483bf0 [  115.693139] x28: ffff000008d45000 
[  115.696551] 
[  115.698046] x27: 0000000000000000 [  115.701284] x26: 0000000000000000 
[  115.704698] 
[  115.706192] x25: 0000000000000001 [  115.709429] x24: 0000000000000001 
[  115.712842] 
[  115.714336] x23: 0000000000000000 [  115.717574] x22: ffff8003cb1e8838 
[  115.720987] 
[  115.722482] x21: ffff8003e4c66810 [  115.725719] x20: ffff000008de32e0 
[  115.729132] 
[  115.730626] x19: 0000000000000000 [  115.733864] x18: ffff000008971660 
[  115.737278] 
[  115.738772] x17: 000000000000000e [  115.742010] x16: 0000000000000007 
[  115.745423] 
[  115.746917] x15: 0000000000000000 [  115.750155] x14: 0000000000000000 
[  115.753567] 
[  115.755062] x13: 0000000000003005 [  115.758299] x12: 0000000000000002 
[  115.761712] 
[  115.763206] x11: ffff000008e21698 [  115.766444] x10: 0000000000000000 
[  115.769858] 
[  115.771352] x9 : ffff8003fff62280 [  115.774590] x8 : 7027207463656a62 
[  115.778003] 
[  115.779497] x7 : 6f6b20726f662064 [  115.782734] x6 : 0000000000003006 
[  115.786148] 
[  115.787642] x5 : ffff8003f5486218 [  115.790880] x4 : 0000000000000000 
[  115.794294] 
[  115.795788] x3 : 0000000000000000 [  115.799026] x2 : ffff000008d5cd18 
[  115.802439] 
[  115.803933] x1 : 0000000000000000 [  115.807171] x0 : 0000000000000036 
[  115.810584] 
[  115.812078] 
[  115.813572] ---[ end trace d18a42ce2a4e222f ]---
[  115.818205] Call trace:
[  115.820659] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  115.827124] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  115.834984] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  115.842845] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  115.850705] 3a80: ffff8003e4c66810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  115.858565] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  115.866426] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  115.874286] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003006 6f6b20726f662064
[  115.882147] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  115.890008] 3b20: 0000000000000002 0000000000003005 0000000000000000 0000000000000000
[  115.897868] 3b40: 0000000000000007 000000000000000e
[  115.902765] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  115.908534] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  115.914128] [<ffff00000850d480>] device_del+0x40/0x210
[  115.919286] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  115.924706] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  115.930387] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  115.936416] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  115.942271] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  115.948214] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  115.953982] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  115.959401] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  115.964209] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  115.969564] sysfs group 'power' not found for kobject 'phy-2:1:18'
[  115.975775] ------------[ cut here ]------------
[  115.980411] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  115.988707] Modules linked in:
[  115.991781] 
[  115.993277] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  116.003316] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  116.013094] Workqueue: scsi_wq_2 sas_destruct_devices
[  116.018175] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  116.024118] PC is at sysfs_remove_group+0x8c/0x94
[  116.028839] LR is at sysfs_remove_group+0x8c/0x94
[  116.033561] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  116.040985] sp : ffff8003f5483b40
[  116.044310] x29: ffff8003f5483b40 [  116.047549] x28: ffff000008d45000 
[  116.050962] 
[  116.052456] x27: 0000000000000000 [  116.055694] x26: 0000000000000000 
[  116.059107] 
[  116.060600] x25: 0000000000000001 [  116.063837] x24: 0000000000000001 
[  116.067250] 
[  116.068744] x23: ffff000008de2000 [  116.071982] x22: ffff8003e4c66000 
[  116.075395] 
[  116.076890] x21: ffff8003e4c66438 [  116.080128] x20: ffff000008de32e0 
[  116.083541] 
[  116.085036] x19: 0000000000000000 [  116.088274] x18: ffff000008971660 
[  116.091687] 
[  116.093181] x17: 000000000000000e [  116.096419] x16: 0000000000000007 
[  116.099832] 
[  116.101326] x15: 0000000000000000 [  116.104563] x14: 0000000000000000 
[  116.107977] 
[  116.109471] x13: 0000000000003059 [  116.112709] x12: 0000000000000002 
[  116.116122] 
[  116.117616] x11: ffff000008e21698 [  116.120853] x10: 0000000000000000 
[  116.124266] 
[  116.125761] x9 : ffff8003fff62280 [  116.128998] x8 : 63656a626f6b2072 
[  116.132412] 
[  116.133905] x7 : 6f6620646e756f66 [  116.137144] x6 : 000000000000305a 
[  116.140557] 
[  116.142051] x5 : ffff8003f5486218 [  116.145288] x4 : 0000000000000000 
[  116.148701] 
[  116.150196] x3 : 0000000000000000 [  116.153433] x2 : ffff000008d5cd18 
[  116.156846] 
[  116.158341] x1 : 0000000000000000 [  116.161578] x0 : 0000000000000036 
[  116.164992] 
[  116.166486] 
[  116.167980] ---[ end trace d18a42ce2a4e2230 ]---
[  116.172613] Call trace:
[  116.175067] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  116.181533] 3960:                                   0000000000000000 0001000000000000
[  116.189393] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  116.197254] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  116.205115] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c66438 ffff8003e4c66000
[  116.212975] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  116.220836] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  116.228696] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  116.236557] 3a40: 000000000000305a 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  116.244417] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003059
[  116.252278] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  116.260140] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  116.265909] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  116.271503] [<ffff00000850d480>] device_del+0x40/0x210
[  116.276662] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  116.284000] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  116.290379] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  116.297541] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  116.303746] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  116.309165] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  116.314845] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  116.320875] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  116.326730] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  116.332672] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  116.338440] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  116.343858] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  116.348668] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  116.354021] sysfs group 'power' not found for kobject 'phy-2:1:18'
[  116.360232] ------------[ cut here ]------------
[  116.364868] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  116.373164] Modules linked in:
[  116.376238] 
[  116.377733] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  116.387774] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  116.397552] Workqueue: scsi_wq_2 sas_destruct_devices
[  116.402632] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  116.408576] PC is at sysfs_remove_group+0x8c/0x94
[  116.413297] LR is at sysfs_remove_group+0x8c/0x94
[  116.418018] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  116.425442] sp : ffff8003f5483bf0
[  116.428768] x29: ffff8003f5483bf0 [  116.432006] x28: ffff000008d45000 
[  116.435420] 
[  116.436914] x27: 0000000000000000 [  116.440152] x26: 0000000000000000 
[  116.443566] 
[  116.445060] x25: 0000000000000001 [  116.448297] x24: 0000000000000001 
[  116.451711] 
[  116.453205] x23: 0000000000000000 [  116.456443] x22: ffff8003cb1e8838 
[  116.459856] 
[  116.461351] x21: ffff8003e4c66010 [  116.464589] x20: ffff000008de32e0 
[  116.468002] 
[  116.469495] x19: 0000000000000000 [  116.472732] x18: ffff000008971660 
[  116.476146] 
[  116.477640] x17: 000000000000000e [  116.480878] x16: 0000000000000007 
[  116.484291] 
[  116.485784] x15: 0000000000000000 [  116.489022] x14: 0000000000000000 
[  116.492435] 
[  116.493930] x13: 00000000000030b1 [  116.497168] x12: 0000000000000002 
[  116.500581] 
[  116.502074] x11: ffff000008e21698 [  116.505312] x10: 0000000000000000 
[  116.508726] 
[  116.510220] x9 : ffff8003fff62280 [  116.513458] x8 : 63656a626f6b2072 
[  116.516871] 
[  116.518365] x7 : 6f6620646e756f66 [  116.521604] x6 : 00000000000030b2 
[  116.525017] 
[  116.526511] x5 : ffff8003f5486218 [  116.529749] x4 : 0000000000000000 
[  116.533163] 
[  116.534657] x3 : 0000000000000000 [  116.537895] x2 : ffff000008d5cd18 
[  116.541308] 
[  116.542802] x1 : 0000000000000000 [  116.546040] x0 : 0000000000000036 
[  116.549453] 
[  116.550947] 
[  116.552441] ---[ end trace d18a42ce2a4e2231 ]---
[  116.557075] Call trace:
[  116.559529] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  116.565995] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  116.573856] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  116.581716] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  116.589577] 3a80: ffff8003e4c66010 ffff8003cb1e8838 0000000000000000 0000000000000001
[  116.597438] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  116.605298] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  116.613158] 3ae0: 0000000000000000 ffff8003f5486218 00000000000030b2 6f6620646e756f66
[  116.621018] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  116.628879] 3b20: 0000000000000002 00000000000030b1 0000000000000000 0000000000000000
[  116.636739] 3b40: 0000000000000007 000000000000000e
[  116.641635] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  116.647404] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  116.652998] [<ffff00000850d480>] device_del+0x40/0x210
[  116.658155] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  116.663574] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  116.669254] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  116.675284] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  116.681139] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  116.687082] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  116.692849] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  116.698268] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  116.703077] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  116.708437] sysfs group 'power' not found for kobject 'phy-2:1:19'
[  116.714648] ------------[ cut here ]------------
[  116.719284] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  116.727579] Modules linked in:
[  116.730653] 
[  116.732148] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  116.742187] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  116.751966] Workqueue: scsi_wq_2 sas_destruct_devices
[  116.757048] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  116.762991] PC is at sysfs_remove_group+0x8c/0x94
[  116.767713] LR is at sysfs_remove_group+0x8c/0x94
[  116.772433] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  116.779857] sp : ffff8003f5483b40
[  116.783182] x29: ffff8003f5483b40 [  116.786421] x28: ffff000008d45000 
[  116.789834] 
[  116.791328] x27: 0000000000000000 [  116.794565] x26: 0000000000000000 
[  116.797979] 
[  116.799474] x25: 0000000000000001 [  116.802711] x24: 0000000000000001 
[  116.806124] 
[  116.807618] x23: ffff000008de2000 [  116.810856] x22: ffff8003e4c65800 
[  116.814270] 
[  116.815764] x21: ffff8003e4c65c38 [  116.819002] x20: ffff000008de32e0 
[  116.822415] 
[  116.823910] x19: 0000000000000000 [  116.827148] x18: ffff000008971660 
[  116.830561] 
[  116.832055] x17: 000000000000000e [  116.835293] x16: 0000000000000007 
[  116.838706] 
[  116.840200] x15: 0000000000000000 [  116.843438] x14: 0000000000000000 
[  116.846852] 
[  116.848347] x13: 0000000000003105 [  116.851584] x12: 0000000000000002 
[  116.854998] 
[  116.856492] x11: ffff000008e21698 [  116.859730] x10: 0000000000000000 
[  116.863144] 
[  116.864638] x9 : ffff8003fff62280 [  116.867876] x8 : 313a313a322d7968 
[  116.871289] 
[  116.872783] x7 : 7027207463656a62 [  116.876021] x6 : 0000000000003106 
[  116.879434] 
[  116.880928] x5 : ffff8003f5486218 [  116.884166] x4 : 0000000000000000 
[  116.887579] 
[  116.889073] x3 : 0000000000000000 [  116.892310] x2 : ffff000008d5cd18 
[  116.895724] 
[  116.897218] x1 : 0000000000000000 [  116.900457] x0 : 0000000000000036 
[  116.903870] 
[  116.905364] 
[  116.906858] ---[ end trace d18a42ce2a4e2232 ]---
[  116.911492] Call trace:
[  116.913946] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  116.920410] 3960:                                   0000000000000000 0001000000000000
[  116.928270] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  116.936132] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  116.943993] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c65c38 ffff8003e4c65800
[  116.951854] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  116.959715] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  116.967576] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  116.975437] 3a40: 0000000000003106 7027207463656a62 313a313a322d7968 ffff8003fff62280
[  116.983297] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003105
[  116.991158] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  116.999019] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  117.004788] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  117.010381] [<ffff00000850d480>] device_del+0x40/0x210
[  117.015539] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  117.022877] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  117.029256] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  117.036420] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  117.042624] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  117.048043] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  117.053723] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  117.059753] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  117.065608] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  117.071552] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  117.077320] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  117.082738] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  117.087547] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  117.092902] sysfs group 'power' not found for kobject 'phy-2:1:19'
[  117.099114] ------------[ cut here ]------------
[  117.103750] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  117.112046] Modules linked in:
[  117.115121] 
[  117.116616] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  117.126656] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  117.136435] Workqueue: scsi_wq_2 sas_destruct_devices
[  117.141515] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  117.147459] PC is at sysfs_remove_group+0x8c/0x94
[  117.152181] LR is at sysfs_remove_group+0x8c/0x94
[  117.156902] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  117.164326] sp : ffff8003f5483bf0
[  117.167652] x29: ffff8003f5483bf0 [  117.170890] x28: ffff000008d45000 
[  117.174303] 
[  117.175797] x27: 0000000000000000 [  117.179035] x26: 0000000000000000 
[  117.182449] 
[  117.183942] x25: 0000000000000001 [  117.187180] x24: 0000000000000001 
[  117.190593] 
[  117.192087] x23: 0000000000000000 [  117.195325] x22: ffff8003cb1e8838 
[  117.198738] 
[  117.200233] x21: ffff8003e4c65810 [  117.203470] x20: ffff000008de32e0 
[  117.206884] 
[  117.208378] x19: 0000000000000000 [  117.211616] x18: ffff000008971660 
[  117.215028] 
[  117.216522] x17: 000000000000000e [  117.219760] x16: 0000000000000007 
[  117.223173] 
[  117.224668] x15: 0000000000000000 [  117.227905] x14: 0000000000000000 
[  117.231318] 
[  117.232811] x13: 000000000000315d [  117.236049] x12: 0000000000000002 
[  117.239462] 
[  117.240956] x11: ffff000008e21698 [  117.244194] x10: 0000000000000000 
[  117.247607] 
[  117.249101] x9 : ffff8003fff62280 [  117.252339] x8 : 313a313a322d7968 
[  117.255751] 
[  117.257246] x7 : 7027207463656a62 [  117.260483] x6 : 000000000000315e 
[  117.263897] 
[  117.265391] x5 : ffff8003f5486218 [  117.268629] x4 : 0000000000000000 
[  117.272043] 
[  117.273537] x3 : 0000000000000000 [  117.276775] x2 : ffff000008d5cd18 
[  117.280187] 
[  117.281681] x1 : 0000000000000000 [  117.284918] x0 : 0000000000000036 
[  117.288332] 
[  117.289826] 
[  117.291320] ---[ end trace d18a42ce2a4e2233 ]---
[  117.295954] Call trace:
[  117.298408] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  117.304873] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  117.312734] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  117.320594] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  117.328456] 3a80: ffff8003e4c65810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  117.336316] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  117.344176] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  117.352037] 3ae0: 0000000000000000 ffff8003f5486218 000000000000315e 7027207463656a62
[  117.359898] 3b00: 313a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  117.367759] 3b20: 0000000000000002 000000000000315d 0000000000000000 0000000000000000
[  117.375619] 3b40: 0000000000000007 000000000000000e
[  117.380516] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  117.386284] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  117.391877] [<ffff00000850d480>] device_del+0x40/0x210
[  117.397036] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  117.402456] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  117.408137] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  117.414167] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  117.420021] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  117.425963] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  117.431732] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  117.437151] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  117.441960] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  117.447314] sysfs group 'power' not found for kobject 'phy-2:1:20'
[  117.453524] ------------[ cut here ]------------
[  117.458160] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  117.466455] Modules linked in:
[  117.469528] 
[  117.471022] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  117.481063] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  117.490842] Workqueue: scsi_wq_2 sas_destruct_devices
[  117.495921] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  117.501864] PC is at sysfs_remove_group+0x8c/0x94
[  117.506585] LR is at sysfs_remove_group+0x8c/0x94
[  117.511305] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  117.518729] sp : ffff8003f5483b40
[  117.522055] x29: ffff8003f5483b40 [  117.525293] x28: ffff000008d45000 
[  117.528707] 
[  117.530201] x27: 0000000000000000 [  117.533440] x26: 0000000000000000 
[  117.536853] 
[  117.538347] x25: 0000000000000001 [  117.541585] x24: 0000000000000001 
[  117.544998] 
[  117.546492] x23: ffff000008de2000 [  117.549731] x22: ffff8003e4c65000 
[  117.553143] 
[  117.554637] x21: ffff8003e4c65438 [  117.557875] x20: ffff000008de32e0 
[  117.561288] 
[  117.562781] x19: 0000000000000000 [  117.566019] x18: ffff000008971660 
[  117.569432] 
[  117.570926] x17: 000000000000000e [  117.574163] x16: 0000000000000007 
[  117.577576] 
[  117.579069] x15: 0000000000000000 [  117.582307] x14: 0000000000000000 
[  117.585720] 
[  117.587214] x13: 00000000000031b1 [  117.590452] x12: 0000000000000002 
[  117.593866] 
[  117.595361] x11: ffff000008e21698 [  117.598598] x10: 0000000000000000 
[  117.602012] 
[  117.603505] x9 : ffff8003fff62280 [  117.606743] x8 : 322d796870272074 
[  117.610156] 
[  117.611650] x7 : 63656a626f6b2072 [  117.614888] x6 : 00000000000031b2 
[  117.618302] 
[  117.619796] x5 : ffff8003f5486218 [  117.623034] x4 : 0000000000000000 
[  117.626446] 
[  117.627940] x3 : 0000000000000000 [  117.631178] x2 : ffff000008d5cd18 
[  117.634592] 
[  117.636085] x1 : 0000000000000000 [  117.639323] x0 : 0000000000000036 
[  117.642736] 
[  117.644229] 
[  117.645723] ---[ end trace d18a42ce2a4e2234 ]---
[  117.650357] Call trace:
[  117.652811] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  117.659277] 3960:                                   0000000000000000 0001000000000000
[  117.667138] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  117.674998] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  117.682859] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c65438 ffff8003e4c65000
[  117.690719] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  117.698579] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  117.706439] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  117.714299] 3a40: 00000000000031b2 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  117.722160] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000031b1
[  117.730020] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  117.737881] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  117.743649] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  117.749243] [<ffff00000850d480>] device_del+0x40/0x210
[  117.754400] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  117.761738] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  117.768116] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  117.775280] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  117.781484] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  117.786904] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  117.792585] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  117.798615] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  117.804470] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  117.810412] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  117.816180] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  117.821599] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  117.826407] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  117.831760] sysfs group 'power' not found for kobject 'phy-2:1:20'
[  117.837970] ------------[ cut here ]------------
[  117.842606] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  117.850901] Modules linked in:
[  117.853976] 
[  117.855471] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  117.865511] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  117.875290] Workqueue: scsi_wq_2 sas_destruct_devices
[  117.880372] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  117.886314] PC is at sysfs_remove_group+0x8c/0x94
[  117.891036] LR is at sysfs_remove_group+0x8c/0x94
[  117.895757] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  117.903181] sp : ffff8003f5483bf0
[  117.906507] x29: ffff8003f5483bf0 [  117.909745] x28: ffff000008d45000 
[  117.913159] 
[  117.914653] x27: 0000000000000000 [  117.917891] x26: 0000000000000000 
[  117.921304] 
[  117.922798] x25: 0000000000000001 [  117.926036] x24: 0000000000000001 
[  117.929448] 
[  117.930942] x23: 0000000000000000 [  117.934181] x22: ffff8003cb1e8838 
[  117.937594] 
[  117.939088] x21: ffff8003e4c65010 [  117.942325] x20: ffff000008de32e0 
[  117.945738] 
[  117.947232] x19: 0000000000000000 [  117.950470] x18: ffff000008971660 
[  117.953883] 
[  117.955376] x17: 000000000000000e [  117.958614] x16: 0000000000000007 
[  117.962027] 
[  117.963521] x15: 0000000000000000 [  117.966759] x14: 0000000000000000 
[  117.970173] 
[  117.971667] x13: 0000000000003209 [  117.974904] x12: 0000000000000002 
[  117.978317] 
[  117.979811] x11: ffff000008e21698 [  117.983049] x10: 0000000000000000 
[  117.986462] 
[  117.987956] x9 : ffff8003fff62280 [  117.991194] x8 : 322d796870272074 
[  117.994607] 
[  117.996102] x7 : 63656a626f6b2072 [  117.999340] x6 : 000000000000320a 
[  118.002754] 
[  118.004248] x5 : ffff8003f5486218 [  118.007486] x4 : 0000000000000000 
[  118.010899] 
[  118.012393] x3 : 0000000000000000 [  118.015631] x2 : ffff000008d5cd18 
[  118.019044] 
[  118.020538] x1 : 0000000000000000 [  118.023775] x0 : 0000000000000036 
[  118.027188] 
[  118.028681] 
[  118.030176] ---[ end trace d18a42ce2a4e2235 ]---
[  118.034809] Call trace:
[  118.037262] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  118.043727] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  118.051588] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  118.059448] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  118.067309] 3a80: ffff8003e4c65010 ffff8003cb1e8838 0000000000000000 0000000000000001
[  118.075169] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  118.083030] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  118.090891] 3ae0: 0000000000000000 ffff8003f5486218 000000000000320a 63656a626f6b2072
[  118.098752] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  118.106613] 3b20: 0000000000000002 0000000000003209 0000000000000000 0000000000000000
[  118.114473] 3b40: 0000000000000007 000000000000000e
[  118.119370] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  118.125139] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  118.130732] [<ffff00000850d480>] device_del+0x40/0x210
[  118.135890] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  118.141310] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  118.146990] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  118.153020] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  118.158875] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  118.164817] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  118.170585] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  118.176004] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  118.180813] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  118.186171] sysfs group 'power' not found for kobject 'phy-2:1:21'
[  118.192383] ------------[ cut here ]------------
[  118.197019] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  118.205315] Modules linked in:
[  118.208390] 
[  118.209885] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  118.219925] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  118.229703] Workqueue: scsi_wq_2 sas_destruct_devices
[  118.234784] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  118.240726] PC is at sysfs_remove_group+0x8c/0x94
[  118.245447] LR is at sysfs_remove_group+0x8c/0x94
[  118.250169] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  118.257593] sp : ffff8003f5483b40
[  118.260918] x29: ffff8003f5483b40 [  118.264156] x28: ffff000008d45000 
[  118.267570] 
[  118.269065] x27: 0000000000000000 [  118.272303] x26: 0000000000000000 
[  118.275716] 
[  118.277210] x25: 0000000000000001 [  118.280447] x24: 0000000000000001 
[  118.283860] 
[  118.285354] x23: ffff000008de2000 [  118.288592] x22: ffff8003e4c64800 
[  118.292006] 
[  118.293499] x21: ffff8003e4c64c38 [  118.296738] x20: ffff000008de32e0 
[  118.300151] 
[  118.301645] x19: 0000000000000000 [  118.304883] x18: ffff000008971660 
[  118.308295] 
[  118.309790] x17: 000000000000000e [  118.313028] x16: 0000000000000007 
[  118.316440] 
[  118.317935] x15: 0000000000000000 [  118.321172] x14: 0000000000000000 
[  118.324585] 
[  118.326078] x13: 000000000000325d [  118.329317] x12: 0000000000000002 
[  118.332730] 
[  118.334224] x11: ffff000008e21698 [  118.337462] x10: 0000000000000000 
[  118.340876] 
[  118.342369] x9 : ffff8003fff62280 [  118.345607] x8 : 7027207463656a62 
[  118.349020] 
[  118.350515] x7 : 6f6b20726f662064 [  118.353752] x6 : 000000000000325e 
[  118.357166] 
[  118.358660] x5 : ffff8003f5486218 [  118.361898] x4 : 0000000000000000 
[  118.365311] 
[  118.366805] x3 : 0000000000000000 [  118.370043] x2 : ffff000008d5cd18 
[  118.373456] 
[  118.374949] x1 : 0000000000000000 [  118.378187] x0 : 0000000000000036 
[  118.381601] 
[  118.383095] 
[  118.384589] ---[ end trace d18a42ce2a4e2236 ]---
[  118.389222] Call trace:
[  118.391676] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  118.398141] 3960:                                   0000000000000000 0001000000000000
[  118.406002] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  118.413863] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  118.421723] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c64c38 ffff8003e4c64800
[  118.429584] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  118.437445] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  118.445305] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  118.453165] 3a40: 000000000000325e 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  118.461027] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 000000000000325d
[  118.468887] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  118.476749] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  118.482517] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  118.488111] [<ffff00000850d480>] device_del+0x40/0x210
[  118.493268] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  118.500606] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  118.506985] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  118.514148] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  118.520352] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  118.525771] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  118.531451] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  118.537482] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  118.543337] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  118.549280] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  118.555047] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  118.560466] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  118.565275] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  118.570635] sysfs group 'power' not found for kobject 'phy-2:1:21'
[  118.576846] ------------[ cut here ]------------
[  118.581482] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  118.589778] Modules linked in:
[  118.592852] 
[  118.594347] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  118.604387] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  118.614166] Workqueue: scsi_wq_2 sas_destruct_devices
[  118.619247] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  118.625189] PC is at sysfs_remove_group+0x8c/0x94
[  118.629910] LR is at sysfs_remove_group+0x8c/0x94
[  118.634631] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  118.642055] sp : ffff8003f5483bf0
[  118.645381] x29: ffff8003f5483bf0 [  118.648619] x28: ffff000008d45000 
[  118.652033] 
[  118.653527] x27: 0000000000000000 [  118.656765] x26: 0000000000000000 
[  118.660178] 
[  118.661672] x25: 0000000000000001 [  118.664910] x24: 0000000000000001 
[  118.668324] 
[  118.669818] x23: 0000000000000000 [  118.673056] x22: ffff8003cb1e8838 
[  118.676469] 
[  118.677963] x21: ffff8003e4c64810 [  118.681201] x20: ffff000008de32e0 
[  118.684615] 
[  118.686108] x19: 0000000000000000 [  118.689346] x18: ffff000008971660 
[  118.692760] 
[  118.694253] x17: 000000000000000e [  118.697492] x16: 0000000000000007 
[  118.700905] 
[  118.702399] x15: 0000000000000000 [  118.705637] x14: 0000000000000000 
[  118.709051] 
[  118.710545] x13: 00000000000032b5 [  118.713782] x12: 0000000000000002 
[  118.717196] 
[  118.718691] x11: ffff000008e21698 [  118.721928] x10: 0000000000000000 
[  118.725341] 
[  118.726835] x9 : ffff8003fff62280 [  118.730073] x8 : 7027207463656a62 
[  118.733486] 
[  118.734979] x7 : 6f6b20726f662064 [  118.738217] x6 : 00000000000032b6 
[  118.741630] 
[  118.743124] x5 : ffff8003f5486218 [  118.746362] x4 : 0000000000000000 
[  118.749775] 
[  118.751269] x3 : 0000000000000000 [  118.754507] x2 : ffff000008d5cd18 
[  118.757921] 
[  118.759415] x1 : 0000000000000000 [  118.762653] x0 : 0000000000000036 
[  118.766066] 
[  118.767560] 
[  118.769054] ---[ end trace d18a42ce2a4e2237 ]---
[  118.773688] Call trace:
[  118.776141] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  118.782607] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  118.790468] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  118.798328] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  118.806188] 3a80: ffff8003e4c64810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  118.814049] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  118.821909] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  118.829769] 3ae0: 0000000000000000 ffff8003f5486218 00000000000032b6 6f6b20726f662064
[  118.837631] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  118.845492] 3b20: 0000000000000002 00000000000032b5 0000000000000000 0000000000000000
[  118.853352] 3b40: 0000000000000007 000000000000000e
[  118.858249] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  118.864018] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  118.869611] [<ffff00000850d480>] device_del+0x40/0x210
[  118.874770] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  118.880188] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  118.885869] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  118.891899] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  118.897754] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  118.903696] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  118.909465] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  118.914884] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  118.919692] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  118.925046] sysfs group 'power' not found for kobject 'phy-2:1:22'
[  118.931258] ------------[ cut here ]------------
[  118.935894] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  118.944190] Modules linked in:
[  118.947264] 
[  118.948759] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  118.958799] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  118.968578] Workqueue: scsi_wq_2 sas_destruct_devices
[  118.973658] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  118.979601] PC is at sysfs_remove_group+0x8c/0x94
[  118.984323] LR is at sysfs_remove_group+0x8c/0x94
[  118.989043] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  118.996467] sp : ffff8003f5483b40
[  118.999792] x29: ffff8003f5483b40 [  119.003030] x28: ffff000008d45000 
[  119.006443] 
[  119.007937] x27: 0000000000000000 [  119.011175] x26: 0000000000000000 
[  119.014589] 
[  119.016083] x25: 0000000000000001 [  119.019321] x24: 0000000000000001 
[  119.022734] 
[  119.024228] x23: ffff000008de2000 [  119.027465] x22: ffff8003e4c64000 
[  119.030878] 
[  119.032372] x21: ffff8003e4c64438 [  119.035610] x20: ffff000008de32e0 
[  119.039023] 
[  119.040517] x19: 0000000000000000 [  119.043755] x18: ffff000008971660 
[  119.047168] 
[  119.048662] x17: 000000000000000e [  119.051900] x16: 0000000000000007 
[  119.055312] 
[  119.056806] x15: 0000000000000000 [  119.060044] x14: 0000000000000000 
[  119.063457] 
[  119.064951] x13: 0000000000003309 [  119.068189] x12: 0000000000000002 
[  119.071603] 
[  119.073097] x11: ffff000008e21698 [  119.076334] x10: 0000000000000000 
[  119.079748] 
[  119.081242] x9 : ffff8003fff62280 [  119.084481] x8 : 63656a626f6b2072 
[  119.087895] 
[  119.089389] x7 : 6f6620646e756f66 [  119.092627] x6 : 000000000000330a 
[  119.096040] 
[  119.097534] x5 : ffff8003f5486218 [  119.100771] x4 : 0000000000000000 
[  119.104184] 
[  119.105678] x3 : 0000000000000000 [  119.108916] x2 : ffff000008d5cd18 
[  119.112329] 
[  119.113822] x1 : 0000000000000000 [  119.117061] x0 : 0000000000000036 
[  119.120474] 
[  119.121968] 
[  119.123463] ---[ end trace d18a42ce2a4e2238 ]---
[  119.128096] Call trace:
[  119.130550] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  119.137015] 3960:                                   0000000000000000 0001000000000000
[  119.144876] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  119.152737] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  119.160598] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c64438 ffff8003e4c64000
[  119.168459] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  119.176319] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  119.184180] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  119.192041] 3a40: 000000000000330a 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  119.199901] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003309
[  119.207762] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  119.215623] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  119.221391] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  119.226985] [<ffff00000850d480>] device_del+0x40/0x210
[  119.232144] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  119.239482] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  119.245860] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  119.253023] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  119.259227] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  119.264647] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  119.270328] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  119.276357] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  119.282212] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  119.288155] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  119.293923] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  119.299342] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  119.304151] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  119.309504] sysfs group 'power' not found for kobject 'phy-2:1:22'
[  119.315716] ------------[ cut here ]------------
[  119.320351] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  119.328647] Modules linked in:
[  119.331721] 
[  119.333216] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  119.343256] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  119.353034] Workqueue: scsi_wq_2 sas_destruct_devices
[  119.358115] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  119.364059] PC is at sysfs_remove_group+0x8c/0x94
[  119.368781] LR is at sysfs_remove_group+0x8c/0x94
[  119.373501] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  119.380926] sp : ffff8003f5483bf0
[  119.384252] x29: ffff8003f5483bf0 [  119.387490] x28: ffff000008d45000 
[  119.390904] 
[  119.392398] x27: 0000000000000000 [  119.395637] x26: 0000000000000000 
[  119.399051] 
[  119.400545] x25: 0000000000000001 [  119.403782] x24: 0000000000000001 
[  119.407196] 
[  119.408691] x23: 0000000000000000 [  119.411928] x22: ffff8003cb1e8838 
[  119.415342] 
[  119.416836] x21: ffff8003e4c64010 [  119.420074] x20: ffff000008de32e0 
[  119.423487] 
[  119.424982] x19: 0000000000000000 [  119.428221] x18: ffff000008971660 
[  119.431634] 
[  119.433129] x17: 000000000000000e [  119.436366] x16: 0000000000000007 
[  119.439780] 
[  119.441274] x15: 0000000000000000 [  119.444512] x14: 0000000000000000 
[  119.447925] 
[  119.449419] x13: 0000000000003361 [  119.452656] x12: 0000000000000002 
[  119.456070] 
[  119.457564] x11: ffff000008e21698 [  119.460802] x10: 0000000000000000 
[  119.464214] 
[  119.465708] x9 : ffff8003fff62280 [  119.468947] x8 : 63656a626f6b2072 
[  119.472360] 
[  119.473855] x7 : 6f6620646e756f66 [  119.477093] x6 : 0000000000003362 
[  119.480506] 
[  119.482001] x5 : ffff8003f5486218 [  119.485239] x4 : 0000000000000000 
[  119.488651] 
[  119.490145] x3 : 0000000000000000 [  119.493383] x2 : ffff000008d5cd18 
[  119.496797] 
[  119.498291] x1 : 0000000000000000 [  119.501529] x0 : 0000000000000036 
[  119.504942] 
[  119.506436] 
[  119.507931] ---[ end trace d18a42ce2a4e2239 ]---
[  119.512564] Call trace:
[  119.515019] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  119.521484] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  119.529344] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  119.537205] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  119.545065] 3a80: ffff8003e4c64010 ffff8003cb1e8838 0000000000000000 0000000000000001
[  119.552926] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  119.560786] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  119.568647] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003362 6f6620646e756f66
[  119.576508] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  119.584369] 3b20: 0000000000000002 0000000000003361 0000000000000000 0000000000000000
[  119.592229] 3b40: 0000000000000007 000000000000000e
[  119.597126] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  119.602895] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  119.608489] [<ffff00000850d480>] device_del+0x40/0x210
[  119.613646] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  119.619065] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  119.624746] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  119.630776] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  119.636630] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  119.642573] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  119.648341] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  119.653760] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  119.658569] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  119.663927] sysfs group 'power' not found for kobject 'phy-2:1:23'
[  119.670138] ------------[ cut here ]------------
[  119.674773] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  119.683070] Modules linked in:
[  119.686143] 
[  119.687638] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  119.697678] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  119.707457] Workqueue: scsi_wq_2 sas_destruct_devices
[  119.712538] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  119.718481] PC is at sysfs_remove_group+0x8c/0x94
[  119.723202] LR is at sysfs_remove_group+0x8c/0x94
[  119.727923] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  119.735347] sp : ffff8003f5483b40
[  119.738672] x29: ffff8003f5483b40 [  119.741910] x28: ffff000008d45000 
[  119.745323] 
[  119.746818] x27: 0000000000000000 [  119.750055] x26: 0000000000000000 
[  119.753469] 
[  119.754963] x25: 0000000000000001 [  119.758200] x24: 0000000000000001 
[  119.761613] 
[  119.763108] x23: ffff000008de2000 [  119.766346] x22: ffff8003e4c63800 
[  119.769759] 
[  119.771253] x21: ffff8003e4c63c38 [  119.774491] x20: ffff000008de32e0 
[  119.777905] 
[  119.779399] x19: 0000000000000000 [  119.782636] x18: ffff000008971660 
[  119.786049] 
[  119.787544] x17: 000000000000000e [  119.790782] x16: 0000000000000007 
[  119.794196] 
[  119.795690] x15: 0000000000000000 [  119.798928] x14: 0000000000000000 
[  119.802341] 
[  119.803835] x13: 00000000000033b5 [  119.807073] x12: 0000000000000002 
[  119.810486] 
[  119.811980] x11: ffff000008e21698 [  119.815218] x10: 0000000000000000 
[  119.818631] 
[  119.820126] x9 : ffff8003fff62280 [  119.823363] x8 : 323a313a322d7968 
[  119.826776] 
[  119.828271] x7 : 7027207463656a62 [  119.831509] x6 : 00000000000033b6 
[  119.834922] 
[  119.836416] x5 : ffff8003f5486218 [  119.839654] x4 : 0000000000000000 
[  119.843067] 
[  119.844561] x3 : 0000000000000000 [  119.847799] x2 : ffff000008d5cd18 
[  119.851212] 
[  119.852706] x1 : 0000000000000000 [  119.855944] x0 : 0000000000000036 
[  119.859357] 
[  119.860850] 
[  119.862345] ---[ end trace d18a42ce2a4e223a ]---
[  119.866978] Call trace:
[  119.869433] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  119.875897] 3960:                                   0000000000000000 0001000000000000
[  119.883757] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  119.891619] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  119.899479] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c63c38 ffff8003e4c63800
[  119.907339] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  119.915199] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  119.923059] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  119.930919] 3a40: 00000000000033b6 7027207463656a62 323a313a322d7968 ffff8003fff62280
[  119.938780] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000033b5
[  119.946640] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  119.954502] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  119.960271] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  119.965865] [<ffff00000850d480>] device_del+0x40/0x210
[  119.971024] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  119.978361] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  119.984739] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  119.991902] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  119.998106] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  120.003525] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  120.009205] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  120.015234] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  120.021089] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  120.027033] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  120.032801] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  120.038220] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  120.043028] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  120.048389] sysfs group 'power' not found for kobject 'phy-2:1:23'
[  120.054599] ------------[ cut here ]------------
[  120.059236] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  120.067532] Modules linked in:
[  120.070606] 
[  120.072102] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  120.082141] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  120.091920] Workqueue: scsi_wq_2 sas_destruct_devices
[  120.097001] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  120.102943] PC is at sysfs_remove_group+0x8c/0x94
[  120.107665] LR is at sysfs_remove_group+0x8c/0x94
[  120.112386] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  120.119810] sp : ffff8003f5483bf0
[  120.123136] x29: ffff8003f5483bf0 [  120.126373] x28: ffff000008d45000 
[  120.129787] 
[  120.131282] x27: 0000000000000000 [  120.134519] x26: 0000000000000000 
[  120.137933] 
[  120.139428] x25: 0000000000000001 [  120.142666] x24: 0000000000000001 
[  120.146079] 
[  120.147573] x23: 0000000000000000 [  120.150812] x22: ffff8003cb1e8838 
[  120.154225] 
[  120.155720] x21: ffff8003e4c63810 [  120.158957] x20: ffff000008de32e0 
[  120.162370] 
[  120.163864] x19: 0000000000000000 [  120.167102] x18: ffff000008971660 
[  120.170515] 
[  120.172009] x17: 000000000000000e [  120.175246] x16: 0000000000000007 
[  120.178659] 
[  120.180152] x15: 0000000000000000 [  120.183389] x14: 0000000000000000 
[  120.186802] 
[  120.188297] x13: 000000000000340d [  120.191535] x12: 0000000000000002 
[  120.194948] 
[  120.196442] x11: ffff000008e21698 [  120.199679] x10: 0000000000000000 
[  120.203092] 
[  120.204586] x9 : ffff8003fff62280 [  120.207824] x8 : 323a313a322d7968 
[  120.211237] 
[  120.212731] x7 : 7027207463656a62 [  120.215969] x6 : 000000000000340e 
[  120.219382] 
[  120.220876] x5 : ffff8003f5486218 [  120.224114] x4 : 0000000000000000 
[  120.227526] 
[  120.229020] x3 : 0000000000000000 [  120.232258] x2 : ffff000008d5cd18 
[  120.235670] 
[  120.237164] x1 : 0000000000000000 [  120.240402] x0 : 0000000000000036 
[  120.243815] 
[  120.245309] 
[  120.246803] ---[ end trace d18a42ce2a4e223b ]---
[  120.251436] Call trace:
[  120.253891] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  120.260356] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  120.268216] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  120.276078] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  120.283938] 3a80: ffff8003e4c63810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  120.291798] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  120.299658] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  120.307519] 3ae0: 0000000000000000 ffff8003f5486218 000000000000340e 7027207463656a62
[  120.315380] 3b00: 323a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  120.323241] 3b20: 0000000000000002 000000000000340d 0000000000000000 0000000000000000
[  120.331102] 3b40: 0000000000000007 000000000000000e
[  120.335997] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  120.341766] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  120.347359] [<ffff00000850d480>] device_del+0x40/0x210
[  120.352518] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  120.357937] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  120.363618] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  120.369648] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  120.375503] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  120.381445] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  120.387213] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  120.392632] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  120.397441] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  120.402794] sysfs group 'power' not found for kobject 'phy-2:1:24'
[  120.409005] ------------[ cut here ]------------
[  120.413641] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  120.421936] Modules linked in:
[  120.425010] 
[  120.426506] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  120.436546] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  120.446325] Workqueue: scsi_wq_2 sas_destruct_devices
[  120.451406] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  120.457349] PC is at sysfs_remove_group+0x8c/0x94
[  120.462070] LR is at sysfs_remove_group+0x8c/0x94
[  120.466792] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  120.474215] sp : ffff8003f5483b40
[  120.477541] x29: ffff8003f5483b40 [  120.480778] x28: ffff000008d45000 
[  120.484193] 
[  120.485687] x27: 0000000000000000 [  120.488925] x26: 0000000000000000 
[  120.492338] 
[  120.493832] x25: 0000000000000001 [  120.497070] x24: 0000000000000001 
[  120.500482] 
[  120.501976] x23: ffff000008de2000 [  120.505215] x22: ffff8003e4c63000 
[  120.508627] 
[  120.510122] x21: ffff8003e4c63438 [  120.513360] x20: ffff000008de32e0 
[  120.516773] 
[  120.518267] x19: 0000000000000000 [  120.521504] x18: ffff000008971660 
[  120.524917] 
[  120.526411] x17: 000000000000000e [  120.529649] x16: 0000000000000007 
[  120.533062] 
[  120.534556] x15: 0000000000000000 [  120.537793] x14: 0000000000000000 
[  120.541207] 
[  120.542701] x13: 0000000000003461 [  120.545938] x12: 0000000000000002 
[  120.549352] 
[  120.550846] x11: ffff000008e21698 [  120.554084] x10: 0000000000000000 
[  120.557497] 
[  120.558991] x9 : ffff8003fff62280 [  120.562229] x8 : 322d796870272074 
[  120.565642] 
[  120.567136] x7 : 63656a626f6b2072 [  120.570374] x6 : 0000000000003462 
[  120.573787] 
[  120.575281] x5 : ffff8003f5486218 [  120.578519] x4 : 0000000000000000 
[  120.581932] 
[  120.583426] x3 : 0000000000000000 [  120.586664] x2 : ffff000008d5cd18 
[  120.590078] 
[  120.591572] x1 : 0000000000000000 [  120.594810] x0 : 0000000000000036 
[  120.598224] 
[  120.599717] 
[  120.601211] ---[ end trace d18a42ce2a4e223c ]---
[  120.605845] Call trace:
[  120.608298] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  120.614763] 3960:                                   0000000000000000 0001000000000000
[  120.622624] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  120.630485] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  120.638346] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c63438 ffff8003e4c63000
[  120.646206] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  120.654067] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  120.661928] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  120.669789] 3a40: 0000000000003462 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  120.677649] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003461
[  120.685509] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  120.693371] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  120.699139] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  120.704734] [<ffff00000850d480>] device_del+0x40/0x210
[  120.709892] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  120.717229] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  120.723608] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  120.730771] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  120.736975] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  120.742394] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  120.748075] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  120.754105] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  120.759960] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  120.765902] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  120.771670] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  120.777089] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  120.781897] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  120.787250] sysfs group 'power' not found for kobject 'phy-2:1:24'
[  120.793460] ------------[ cut here ]------------
[  120.798095] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  120.806391] Modules linked in:
[  120.809464] 
[  120.810959] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  120.820999] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  120.830778] Workqueue: scsi_wq_2 sas_destruct_devices
[  120.835859] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  120.841802] PC is at sysfs_remove_group+0x8c/0x94
[  120.846523] LR is at sysfs_remove_group+0x8c/0x94
[  120.851244] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  120.858668] sp : ffff8003f5483bf0
[  120.861994] x29: ffff8003f5483bf0 [  120.865232] x28: ffff000008d45000 
[  120.868645] 
[  120.870139] x27: 0000000000000000 [  120.873377] x26: 0000000000000000 
[  120.876789] 
[  120.878283] x25: 0000000000000001 [  120.881522] x24: 0000000000000001 
[  120.884935] 
[  120.886429] x23: 0000000000000000 [  120.889668] x22: ffff8003cb1e8838 
[  120.893080] 
[  120.894575] x21: ffff8003e4c63010 [  120.897813] x20: ffff000008de32e0 
[  120.901227] 
[  120.902721] x19: 0000000000000000 [  120.905959] x18: ffff000008971660 
[  120.909372] 
[  120.910866] x17: 000000000000000e [  120.914104] x16: 0000000000000007 
[  120.917517] 
[  120.919011] x15: 0000000000000000 [  120.922249] x14: 0000000000000000 
[  120.925662] 
[  120.927157] x13: 00000000000034b9 [  120.930395] x12: 0000000000000002 
[  120.933808] 
[  120.935302] x11: ffff000008e21698 [  120.938540] x10: 0000000000000000 
[  120.941954] 
[  120.943448] x9 : ffff8003fff62280 [  120.946686] x8 : 322d796870272074 
[  120.950099] 
[  120.951593] x7 : 63656a626f6b2072 [  120.954831] x6 : 00000000000034ba 
[  120.958243] 
[  120.959737] x5 : ffff8003f5486218 [  120.962975] x4 : 0000000000000000 
[  120.966389] 
[  120.967883] x3 : 0000000000000000 [  120.971120] x2 : ffff000008d5cd18 
[  120.974535] 
[  120.976029] x1 : 0000000000000000 [  120.979267] x0 : 0000000000000036 
[  120.982681] 
[  120.984175] 
[  120.985669] ---[ end trace d18a42ce2a4e223d ]---
[  120.990302] Call trace:
[  120.992756] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  120.999222] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  121.007082] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  121.014944] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  121.022804] 3a80: ffff8003e4c63010 ffff8003cb1e8838 0000000000000000 0000000000000001
[  121.030665] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  121.038525] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  121.046385] 3ae0: 0000000000000000 ffff8003f5486218 00000000000034ba 63656a626f6b2072
[  121.054246] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  121.062108] 3b20: 0000000000000002 00000000000034b9 0000000000000000 0000000000000000
[  121.069968] 3b40: 0000000000000007 000000000000000e
[  121.074865] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  121.080634] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  121.086228] [<ffff00000850d480>] device_del+0x40/0x210
[  121.091386] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  121.096805] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  121.102485] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  121.108515] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  121.114370] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  121.120313] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  121.126080] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  121.131499] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  121.136308] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  121.141662] sysfs group 'power' not found for kobject 'phy-2:1:25'
[  121.147873] ------------[ cut here ]------------
[  121.152510] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  121.160806] Modules linked in:
[  121.163880] 
[  121.165376] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  121.175417] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  121.185196] Workqueue: scsi_wq_2 sas_destruct_devices
[  121.190276] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  121.196219] PC is at sysfs_remove_group+0x8c/0x94
[  121.200940] LR is at sysfs_remove_group+0x8c/0x94
[  121.205661] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  121.213084] sp : ffff8003f5483b40
[  121.216410] x29: ffff8003f5483b40 [  121.219648] x28: ffff000008d45000 
[  121.223060] 
[  121.224555] x27: 0000000000000000 [  121.227793] x26: 0000000000000000 
[  121.231206] 
[  121.232700] x25: 0000000000000001 [  121.235938] x24: 0000000000000001 
[  121.239351] 
[  121.240845] x23: ffff000008de2000 [  121.244083] x22: ffff8003e4c62800 
[  121.247496] 
[  121.248990] x21: ffff8003e4c62c38 [  121.252228] x20: ffff000008de32e0 
[  121.255642] 
[  121.257136] x19: 0000000000000000 [  121.260374] x18: ffff000008971660 
[  121.263787] 
[  121.265281] x17: 000000000000000e [  121.268519] x16: 0000000000000007 
[  121.271933] 
[  121.273426] x15: 0000000000000000 [  121.276664] x14: 0000000000000000 
[  121.280078] 
[  121.281571] x13: 000000000000350d [  121.284809] x12: 0000000000000002 
[  121.288222] 
[  121.289716] x11: ffff000008e21698 [  121.292955] x10: 0000000000000000 
[  121.296367] 
[  121.297861] x9 : ffff8003fff62280 [  121.301099] x8 : 7027207463656a62 
[  121.304512] 
[  121.306006] x7 : 6f6b20726f662064 [  121.309245] x6 : 000000000000350e 
[  121.312657] 
[  121.314152] x5 : ffff8003f5486218 [  121.317390] x4 : 0000000000000000 
[  121.320804] 
[  121.322298] x3 : 0000000000000000 [  121.325536] x2 : ffff000008d5cd18 
[  121.328950] 
[  121.330444] x1 : 0000000000000000 [  121.333681] x0 : 0000000000000036 
[  121.337095] 
[  121.338588] 
[  121.340082] ---[ end trace d18a42ce2a4e223e ]---
[  121.344716] Call trace:
[  121.347170] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  121.353634] 3960:                                   0000000000000000 0001000000000000
[  121.361495] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  121.369356] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  121.377216] 39c0: 0000000000000000 ffff000008de32e0 ffff8003e4c62c38 ffff8003e4c62800
[  121.385076] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  121.392937] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  121.400798] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  121.408658] 3a40: 000000000000350e 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  121.416519] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 000000000000350d
[  121.424380] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  121.432241] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  121.438010] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  121.443603] [<ffff00000850d480>] device_del+0x40/0x210
[  121.448761] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  121.456098] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  121.462477] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  121.469641] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  121.475845] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  121.481265] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  121.486946] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  121.492975] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  121.498830] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  121.504773] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  121.510541] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  121.515960] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  121.520768] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  121.526127] sysfs group 'power' not found for kobject 'phy-2:1:25'
[  121.532339] ------------[ cut here ]------------
[  121.536975] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  121.545270] Modules linked in:
[  121.548344] 
[  121.549840] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  121.559880] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  121.569658] Workqueue: scsi_wq_2 sas_destruct_devices
[  121.574740] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  121.580683] PC is at sysfs_remove_group+0x8c/0x94
[  121.585404] LR is at sysfs_remove_group+0x8c/0x94
[  121.590125] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  121.597549] sp : ffff8003f5483bf0
[  121.600875] x29: ffff8003f5483bf0 [  121.604113] x28: ffff000008d45000 
[  121.607526] 
[  121.609020] x27: 0000000000000000 [  121.612258] x26: 0000000000000000 
[  121.615672] 
[  121.617166] x25: 0000000000000001 [  121.620403] x24: 0000000000000001 
[  121.623817] 
[  121.625311] x23: 0000000000000000 [  121.628549] x22: ffff8003cb1e8838 
[  121.631962] 
[  121.633457] x21: ffff8003e4c62810 [  121.636695] x20: ffff000008de32e0 
[  121.640109] 
[  121.641603] x19: 0000000000000000 [  121.644841] x18: ffff000008971660 
[  121.648254] 
[  121.649748] x17: 000000000000000e [  121.652987] x16: 0000000000000007 
[  121.656400] 
[  121.657895] x15: 0000000000000000 [  121.661132] x14: 0000000000000000 
[  121.664546] 
[  121.666040] x13: 0000000000003565 [  121.669278] x12: 0000000000000002 
[  121.672691] 
[  121.674185] x11: ffff000008e21698 [  121.677423] x10: 0000000000000000 
[  121.680836] 
[  121.682330] x9 : ffff8003fff62280 [  121.685568] x8 : 7027207463656a62 
[  121.688981] 
[  121.690475] x7 : 6f6b20726f662064 [  121.693713] x6 : 0000000000003566 
[  121.697127] 
[  121.698621] x5 : ffff8003f5486218 [  121.701859] x4 : 0000000000000000 
[  121.705272] 
[  121.706766] x3 : 0000000000000000 [  121.710003] x2 : ffff000008d5cd18 
[  121.713416] 
[  121.714910] x1 : 0000000000000000 [  121.718149] x0 : 0000000000000036 
[  121.721562] 
[  121.723055] 
[  121.724549] ---[ end trace d18a42ce2a4e223f ]---
[  121.729183] Call trace:
[  121.731637] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  121.738103] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  121.745964] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  121.753825] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  121.761687] 3a80: ffff8003e4c62810 ffff8003cb1e8838 0000000000000000 0000000000000001
[  121.769547] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  121.777407] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  121.785268] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003566 6f6b20726f662064
[  121.793130] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  121.800991] 3b20: 0000000000000002 0000000000003565 0000000000000000 0000000000000000
[  121.808851] 3b40: 0000000000000007 000000000000000e
[  121.813748] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  121.819516] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  121.825110] [<ffff00000850d480>] device_del+0x40/0x210
[  121.830268] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  121.835688] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  121.841368] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  121.847398] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  121.853253] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  121.859196] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  121.864964] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  121.870383] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  121.875192] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  121.880544] sysfs group 'power' not found for kobject 'phy-2:1:26'
[  121.886754] ------------[ cut here ]------------
[  121.891389] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  121.899685] Modules linked in:
[  121.902758] 
[  121.904254] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  121.914293] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  121.924072] Workqueue: scsi_wq_2 sas_destruct_devices
[  121.929152] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  121.935094] PC is at sysfs_remove_group+0x8c/0x94
[  121.939817] LR is at sysfs_remove_group+0x8c/0x94
[  121.944537] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  121.951962] sp : ffff8003f5483b40
[  121.955287] x29: ffff8003f5483b40 [  121.958525] x28: ffff000008d45000 
[  121.961939] 
[  121.963433] x27: 0000000000000000 [  121.966671] x26: 0000000000000000 
[  121.970084] 
[  121.971578] x25: 0000000000000001 [  121.974816] x24: 0000000000000001 
[  121.978229] 
[  121.979723] x23: ffff000008de2000 [  121.982961] x22: ffff8003e4c60400 
[  121.986373] 
[  121.987868] x21: ffff8003cb250038 [  121.991105] x20: ffff000008de32e0 
[  121.994519] 
[  121.996013] x19: 0000000000000000 [  121.999251] x18: ffff000008971660 
[  122.002664] 
[  122.004159] x17: 000000000000000e [  122.007397] x16: 0000000000000007 
[  122.010810] 
[  122.012304] x15: 0000000000000000 [  122.015542] x14: 0000000000000000 
[  122.018955] 
[  122.020449] x13: 00000000000035b9 [  122.023687] x12: 0000000000000002 
[  122.027099] 
[  122.028593] x11: ffff000008e21698 [  122.031831] x10: 0000000000000000 
[  122.035244] 
[  122.036739] x9 : ffff8003fff62280 [  122.039977] x8 : 63656a626f6b2072 
[  122.043390] 
[  122.044884] x7 : 6f6620646e756f66 [  122.048123] x6 : 00000000000035ba 
[  122.051536] 
[  122.053030] x5 : ffff8003f5486218 [  122.056268] x4 : 0000000000000000 
[  122.059681] 
[  122.061175] x3 : 0000000000000000 [  122.064413] x2 : ffff000008d5cd18 
[  122.067826] 
[  122.069319] x1 : 0000000000000000 [  122.072558] x0 : 0000000000000036 
[  122.075970] 
[  122.077464] 
[  122.078958] ---[ end trace d18a42ce2a4e2240 ]---
[  122.083591] Call trace:
[  122.086044] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  122.092510] 3960:                                   0000000000000000 0001000000000000
[  122.100370] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  122.108230] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  122.116090] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb250038 ffff8003e4c60400
[  122.123951] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  122.131811] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  122.139672] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  122.147532] 3a40: 00000000000035ba 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  122.155393] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000035b9
[  122.163253] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  122.171115] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  122.176883] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  122.182476] [<ffff00000850d480>] device_del+0x40/0x210
[  122.187634] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  122.194972] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  122.201351] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  122.208513] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  122.214718] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  122.220138] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  122.225819] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  122.231848] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  122.237703] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  122.243645] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  122.249414] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  122.254834] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  122.259642] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  122.265001] sysfs group 'power' not found for kobject 'phy-2:1:26'
[  122.271212] ------------[ cut here ]------------
[  122.275848] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  122.284143] Modules linked in:
[  122.287218] 
[  122.288712] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  122.298753] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  122.308532] Workqueue: scsi_wq_2 sas_destruct_devices
[  122.313611] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  122.319555] PC is at sysfs_remove_group+0x8c/0x94
[  122.324277] LR is at sysfs_remove_group+0x8c/0x94
[  122.328998] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  122.336422] sp : ffff8003f5483bf0
[  122.339748] x29: ffff8003f5483bf0 [  122.342986] x28: ffff000008d45000 
[  122.346399] 
[  122.347893] x27: 0000000000000000 [  122.351131] x26: 0000000000000000 
[  122.354545] 
[  122.356039] x25: 0000000000000001 [  122.359277] x24: 0000000000000001 
[  122.362690] 
[  122.364184] x23: 0000000000000000 [  122.367422] x22: ffff8003cb1e8838 
[  122.370834] 
[  122.372328] x21: ffff8003e4c60410 [  122.375566] x20: ffff000008de32e0 
[  122.378979] 
[  122.380474] x19: 0000000000000000 [  122.383711] x18: ffff000008971660 
[  122.387124] 
[  122.388618] x17: 000000000000000e [  122.391855] x16: 0000000000000007 
[  122.395268] 
[  122.396762] x15: 0000000000000000 [  122.400000] x14: 0000000000000000 
[  122.403413] 
[  122.404907] x13: 0000000000003611 [  122.408145] x12: 0000000000000002 
[  122.411559] 
[  122.413053] x11: ffff000008e21698 [  122.416291] x10: 0000000000000000 
[  122.419704] 
[  122.421198] x9 : ffff8003fff62280 [  122.424436] x8 : 63656a626f6b2072 
[  122.427849] 
[  122.429343] x7 : 6f6620646e756f66 [  122.432581] x6 : 0000000000003612 
[  122.435994] 
[  122.437488] x5 : ffff8003f5486218 [  122.440726] x4 : 0000000000000000 
[  122.444140] 
[  122.445634] x3 : 0000000000000000 [  122.448872] x2 : ffff000008d5cd18 
[  122.452285] 
[  122.453779] x1 : 0000000000000000 [  122.457017] x0 : 0000000000000036 
[  122.460430] 
[  122.461924] 
[  122.463419] ---[ end trace d18a42ce2a4e2241 ]---
[  122.468052] Call trace:
[  122.470507] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  122.476972] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  122.484832] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  122.492692] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  122.500553] 3a80: ffff8003e4c60410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  122.508414] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  122.516274] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  122.524135] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003612 6f6620646e756f66
[  122.531995] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  122.539856] 3b20: 0000000000000002 0000000000003611 0000000000000000 0000000000000000
[  122.547716] 3b40: 0000000000000007 000000000000000e
[  122.552613] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  122.558382] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  122.563975] [<ffff00000850d480>] device_del+0x40/0x210
[  122.569134] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  122.574554] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  122.580234] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  122.586264] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  122.592119] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  122.598062] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  122.603830] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  122.609249] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  122.614058] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  122.619417] sysfs group 'power' not found for kobject 'phy-2:1:27'
[  122.625627] ------------[ cut here ]------------
[  122.630264] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  122.638560] Modules linked in:
[  122.641634] 
[  122.643130] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  122.653170] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  122.662948] Workqueue: scsi_wq_2 sas_destruct_devices
[  122.668029] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  122.673972] PC is at sysfs_remove_group+0x8c/0x94
[  122.678693] LR is at sysfs_remove_group+0x8c/0x94
[  122.683415] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  122.690839] sp : ffff8003f5483b40
[  122.694164] x29: ffff8003f5483b40 [  122.697402] x28: ffff000008d45000 
[  122.700816] 
[  122.702310] x27: 0000000000000000 [  122.705547] x26: 0000000000000000 
[  122.708961] 
[  122.710456] x25: 0000000000000001 [  122.713693] x24: 0000000000000001 
[  122.717107] 
[  122.718601] x23: ffff000008de2000 [  122.721840] x22: ffff8003cb250400 
[  122.725253] 
[  122.726748] x21: ffff8003cb250838 [  122.729985] x20: ffff000008de32e0 
[  122.733398] 
[  122.734892] x19: 0000000000000000 [  122.738130] x18: ffff000008971660 
[  122.741543] 
[  122.743038] x17: 000000000000000e [  122.746276] x16: 0000000000000007 
[  122.749690] 
[  122.751185] x15: 0000000000000000 [  122.754422] x14: 0000000000000000 
[  122.757835] 
[  122.759329] x13: 0000000000003665 [  122.762567] x12: 0000000000000002 
[  122.765980] 
[  122.767475] x11: ffff000008e21698 [  122.770713] x10: 0000000000000000 
[  122.774126] 
[  122.775620] x9 : ffff8003fff62280 [  122.778858] x8 : 323a313a322d7968 
[  122.782271] 
[  122.783765] x7 : 7027207463656a62 [  122.787003] x6 : 0000000000003666 
[  122.790416] 
[  122.791909] x5 : ffff8003f5486218 [  122.795147] x4 : 0000000000000000 
[  122.798560] 
[  122.800055] x3 : 0000000000000000 [  122.803292] x2 : ffff000008d5cd18 
[  122.806706] 
[  122.808200] x1 : 0000000000000000 [  122.811438] x0 : 0000000000000036 
[  122.814852] 
[  122.816345] 
[  122.817839] ---[ end trace d18a42ce2a4e2242 ]---
[  122.822473] Call trace:
[  122.824927] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  122.831392] 3960:                                   0000000000000000 0001000000000000
[  122.839253] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  122.847113] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  122.854973] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb250838 ffff8003cb250400
[  122.862834] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  122.870694] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  122.878555] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  122.886416] 3a40: 0000000000003666 7027207463656a62 323a313a322d7968 ffff8003fff62280
[  122.894276] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003665
[  122.902136] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  122.909998] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  122.915767] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  122.921361] [<ffff00000850d480>] device_del+0x40/0x210
[  122.926519] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  122.933857] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  122.940235] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  122.947398] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  122.953603] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  122.959022] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  122.964702] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  122.970731] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  122.976587] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  122.982530] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  122.988298] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  122.993716] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  122.998525] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  123.003878] sysfs group 'power' not found for kobject 'phy-2:1:27'
[  123.010088] ------------[ cut here ]------------
[  123.014724] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  123.023020] Modules linked in:
[  123.026094] 
[  123.027589] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  123.037629] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  123.047409] Workqueue: scsi_wq_2 sas_destruct_devices
[  123.052490] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  123.058433] PC is at sysfs_remove_group+0x8c/0x94
[  123.063154] LR is at sysfs_remove_group+0x8c/0x94
[  123.067875] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  123.075299] sp : ffff8003f5483bf0
[  123.078624] x29: ffff8003f5483bf0 [  123.081863] x28: ffff000008d45000 
[  123.085277] 
[  123.086771] x27: 0000000000000000 [  123.090008] x26: 0000000000000000 
[  123.093422] 
[  123.094916] x25: 0000000000000001 [  123.098154] x24: 0000000000000001 
[  123.101566] 
[  123.103061] x23: 0000000000000000 [  123.106299] x22: ffff8003cb1e8838 
[  123.109712] 
[  123.111207] x21: ffff8003cb250410 [  123.114444] x20: ffff000008de32e0 
[  123.117857] 
[  123.119351] x19: 0000000000000000 [  123.122590] x18: ffff000008971660 
[  123.126003] 
[  123.127497] x17: 000000000000000e [  123.130735] x16: 0000000000000007 
[  123.134148] 
[  123.135642] x15: 0000000000000000 [  123.138880] x14: 0000000000000000 
[  123.142294] 
[  123.143788] x13: 00000000000036bd [  123.147026] x12: 0000000000000002 
[  123.150440] 
[  123.151934] x11: ffff000008e21698 [  123.155172] x10: 0000000000000000 
[  123.158585] 
[  123.160079] x9 : ffff8003fff62280 [  123.163317] x8 : 323a313a322d7968 
[  123.166730] 
[  123.168225] x7 : 7027207463656a62 [  123.171462] x6 : 00000000000036be 
[  123.174876] 
[  123.176370] x5 : ffff8003f5486218 [  123.179608] x4 : 0000000000000000 
[  123.183021] 
[  123.184515] x3 : 0000000000000000 [  123.187754] x2 : ffff000008d5cd18 
[  123.191167] 
[  123.192661] x1 : 0000000000000000 [  123.195898] x0 : 0000000000000036 
[  123.199312] 
[  123.200806] 
[  123.202300] ---[ end trace d18a42ce2a4e2243 ]---
[  123.206933] Call trace:
[  123.209387] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  123.215853] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  123.223714] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  123.231574] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  123.239435] 3a80: ffff8003cb250410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  123.247296] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  123.255157] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  123.263018] 3ae0: 0000000000000000 ffff8003f5486218 00000000000036be 7027207463656a62
[  123.270879] 3b00: 323a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  123.278739] 3b20: 0000000000000002 00000000000036bd 0000000000000000 0000000000000000
[  123.286600] 3b40: 0000000000000007 000000000000000e
[  123.291496] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  123.297264] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  123.302859] [<ffff00000850d480>] device_del+0x40/0x210
[  123.308017] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  123.313437] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  123.319118] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  123.325149] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  123.331004] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  123.336946] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  123.342714] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  123.348132] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  123.352941] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  123.358295] sysfs group 'power' not found for kobject 'phy-2:1:28'
[  123.364506] ------------[ cut here ]------------
[  123.369143] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  123.377438] Modules linked in:
[  123.380511] 
[  123.382006] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  123.392046] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  123.401825] Workqueue: scsi_wq_2 sas_destruct_devices
[  123.406905] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  123.412849] PC is at sysfs_remove_group+0x8c/0x94
[  123.417570] LR is at sysfs_remove_group+0x8c/0x94
[  123.422291] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  123.429715] sp : ffff8003f5483b40
[  123.433040] x29: ffff8003f5483b40 [  123.436278] x28: ffff000008d45000 
[  123.439691] 
[  123.441186] x27: 0000000000000000 [  123.444423] x26: 0000000000000000 
[  123.447837] 
[  123.449330] x25: 0000000000000001 [  123.452568] x24: 0000000000000001 
[  123.455981] 
[  123.457475] x23: ffff000008de2000 [  123.460713] x22: ffff8003cb250c00 
[  123.464127] 
[  123.465621] x21: ffff8003cb251038 [  123.468859] x20: ffff000008de32e0 
[  123.472272] 
[  123.473766] x19: 0000000000000000 [  123.477004] x18: ffff000008971660 
[  123.480418] 
[  123.481912] x17: 000000000000000e [  123.485150] x16: 0000000000000007 
[  123.488563] 
[  123.490058] x15: 0000000000000000 [  123.493296] x14: 0000000000000000 
[  123.496709] 
[  123.498202] x13: 0000000000003711 [  123.501441] x12: 0000000000000002 
[  123.504854] 
[  123.506349] x11: ffff000008e21698 [  123.509587] x10: 0000000000000000 
[  123.513000] 
[  123.514494] x9 : ffff8003fff62280 [  123.517731] x8 : 322d796870272074 
[  123.521145] 
[  123.522639] x7 : 63656a626f6b2072 [  123.525876] x6 : 0000000000003712 
[  123.529290] 
[  123.530783] x5 : ffff8003f5486218 [  123.534021] x4 : 0000000000000000 
[  123.537435] 
[  123.538928] x3 : 0000000000000000 [  123.542167] x2 : ffff000008d5cd18 
[  123.545580] 
[  123.547074] x1 : 0000000000000000 [  123.550313] x0 : 0000000000000036 
[  123.553727] 
[  123.555221] 
[  123.556715] ---[ end trace d18a42ce2a4e2244 ]---
[  123.561348] Call trace:
[  123.563803] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  123.570268] 3960:                                   0000000000000000 0001000000000000
[  123.578130] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  123.585990] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  123.593851] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb251038 ffff8003cb250c00
[  123.601712] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  123.609572] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  123.617432] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  123.625293] 3a40: 0000000000003712 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  123.633153] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003711
[  123.641013] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  123.648875] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  123.654643] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  123.660238] [<ffff00000850d480>] device_del+0x40/0x210
[  123.665395] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  123.672733] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  123.679111] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  123.686275] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  123.692480] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  123.697899] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  123.703580] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  123.709609] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  123.715464] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  123.721406] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  123.727175] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  123.732594] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  123.737402] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  123.742760] sysfs group 'power' not found for kobject 'phy-2:1:28'
[  123.748970] ------------[ cut here ]------------
[  123.753606] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  123.761901] Modules linked in:
[  123.764975] 
[  123.766471] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  123.776511] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  123.786290] Workqueue: scsi_wq_2 sas_destruct_devices
[  123.791371] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  123.797313] PC is at sysfs_remove_group+0x8c/0x94
[  123.802035] LR is at sysfs_remove_group+0x8c/0x94
[  123.806756] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  123.814180] sp : ffff8003f5483bf0
[  123.817505] x29: ffff8003f5483bf0 [  123.820743] x28: ffff000008d45000 
[  123.824156] 
[  123.825651] x27: 0000000000000000 [  123.828888] x26: 0000000000000000 
[  123.832301] 
[  123.833795] x25: 0000000000000001 [  123.837033] x24: 0000000000000001 
[  123.840447] 
[  123.841941] x23: 0000000000000000 [  123.845179] x22: ffff8003cb1e8838 
[  123.848593] 
[  123.850087] x21: ffff8003cb250c10 [  123.853325] x20: ffff000008de32e0 
[  123.856738] 
[  123.858233] x19: 0000000000000000 [  123.861470] x18: ffff000008971660 
[  123.864884] 
[  123.866377] x17: 000000000000000e [  123.869615] x16: 0000000000000007 
[  123.873028] 
[  123.874522] x15: 0000000000000000 [  123.877760] x14: 0000000000000000 
[  123.881173] 
[  123.882667] x13: 0000000000003769 [  123.885905] x12: 0000000000000002 
[  123.889319] 
[  123.890813] x11: ffff000008e21698 [  123.894050] x10: 0000000000000000 
[  123.897464] 
[  123.898958] x9 : ffff8003fff62280 [  123.902196] x8 : 322d796870272074 
[  123.905610] 
[  123.907104] x7 : 63656a626f6b2072 [  123.910342] x6 : 000000000000376a 
[  123.913756] 
[  123.915250] x5 : ffff8003f5486218 [  123.918488] x4 : 0000000000000000 
[  123.921901] 
[  123.923396] x3 : 0000000000000000 [  123.926633] x2 : ffff000008d5cd18 
[  123.930047] 
[  123.931541] x1 : 0000000000000000 [  123.934779] x0 : 0000000000000036 
[  123.938193] 
[  123.939686] 
[  123.941180] ---[ end trace d18a42ce2a4e2245 ]---
[  123.945814] Call trace:
[  123.948268] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  123.954733] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  123.962593] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  123.970454] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  123.978314] 3a80: ffff8003cb250c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  123.986174] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  123.994035] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  124.001896] 3ae0: 0000000000000000 ffff8003f5486218 000000000000376a 63656a626f6b2072
[  124.009757] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  124.017618] 3b20: 0000000000000002 0000000000003769 0000000000000000 0000000000000000
[  124.025479] 3b40: 0000000000000007 000000000000000e
[  124.030376] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  124.036144] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  124.041738] [<ffff00000850d480>] device_del+0x40/0x210
[  124.046895] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  124.052314] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  124.057995] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  124.064024] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  124.069879] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  124.075822] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  124.081591] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  124.087009] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  124.091818] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  124.097171] sysfs group 'power' not found for kobject 'phy-2:1:29'
[  124.103382] ------------[ cut here ]------------
[  124.108018] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  124.116314] Modules linked in:
[  124.119388] 
[  124.120884] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  124.130923] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  124.140703] Workqueue: scsi_wq_2 sas_destruct_devices
[  124.145783] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  124.151725] PC is at sysfs_remove_group+0x8c/0x94
[  124.156447] LR is at sysfs_remove_group+0x8c/0x94
[  124.161168] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  124.168592] sp : ffff8003f5483b40
[  124.171917] x29: ffff8003f5483b40 [  124.175155] x28: ffff000008d45000 
[  124.178569] 
[  124.180063] x27: 0000000000000000 [  124.183301] x26: 0000000000000000 
[  124.186714] 
[  124.188209] x25: 0000000000000001 [  124.191447] x24: 0000000000000001 
[  124.194860] 
[  124.196354] x23: ffff000008de2000 [  124.199592] x22: ffff8003cb251400 
[  124.203005] 
[  124.204500] x21: ffff8003cb251838 [  124.207738] x20: ffff000008de32e0 
[  124.211151] 
[  124.212645] x19: 0000000000000000 [  124.215884] x18: ffff000008971660 
[  124.219297] 
[  124.220791] x17: 000000000000000e [  124.224029] x16: 0000000000000007 
[  124.227442] 
[  124.228936] x15: 0000000000000000 [  124.232174] x14: 0000000000000000 
[  124.235588] 
[  124.237082] x13: 00000000000037bd [  124.240320] x12: 0000000000000002 
[  124.243734] 
[  124.245228] x11: ffff000008e21698 [  124.248466] x10: 0000000000000000 
[  124.251879] 
[  124.253374] x9 : ffff8003fff62280 [  124.256612] x8 : 7027207463656a62 
[  124.260025] 
[  124.261520] x7 : 6f6b20726f662064 [  124.264757] x6 : 00000000000037be 
[  124.268171] 
[  124.269665] x5 : ffff8003f5486218 [  124.272903] x4 : 0000000000000000 
[  124.276317] 
[  124.277811] x3 : 0000000000000000 [  124.281048] x2 : ffff000008d5cd18 
[  124.284462] 
[  124.285956] x1 : 0000000000000000 [  124.289195] x0 : 0000000000000036 
[  124.292609] 
[  124.294103] 
[  124.295597] ---[ end trace d18a42ce2a4e2246 ]---
[  124.300231] Call trace:
[  124.302686] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  124.309151] 3960:                                   0000000000000000 0001000000000000
[  124.317012] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  124.324873] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  124.332734] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb251838 ffff8003cb251400
[  124.340594] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  124.348455] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  124.356315] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  124.364175] 3a40: 00000000000037be 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  124.372036] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000037bd
[  124.379897] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  124.387758] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  124.393526] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  124.399119] [<ffff00000850d480>] device_del+0x40/0x210
[  124.404277] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  124.411614] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  124.417992] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  124.425156] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  124.431361] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  124.436780] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  124.442461] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  124.448491] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  124.454346] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  124.460288] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  124.466057] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  124.471476] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  124.476284] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  124.481636] sysfs group 'power' not found for kobject 'phy-2:1:29'
[  124.487848] ------------[ cut here ]------------
[  124.492484] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  124.500779] Modules linked in:
[  124.503853] 
[  124.505349] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  124.515389] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  124.525168] Workqueue: scsi_wq_2 sas_destruct_devices
[  124.530250] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  124.536192] PC is at sysfs_remove_group+0x8c/0x94
[  124.540914] LR is at sysfs_remove_group+0x8c/0x94
[  124.545634] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  124.553059] sp : ffff8003f5483bf0
[  124.556384] x29: ffff8003f5483bf0 [  124.559622] x28: ffff000008d45000 
[  124.563036] 
[  124.564530] x27: 0000000000000000 [  124.567767] x26: 0000000000000000 
[  124.571181] 
[  124.572675] x25: 0000000000000001 [  124.575913] x24: 0000000000000001 
[  124.579327] 
[  124.580821] x23: 0000000000000000 [  124.584059] x22: ffff8003cb1e8838 
[  124.587472] 
[  124.588966] x21: ffff8003cb251410 [  124.592204] x20: ffff000008de32e0 
[  124.595617] 
[  124.597110] x19: 0000000000000000 [  124.600348] x18: ffff000008971660 
[  124.603761] 
[  124.605255] x17: 000000000000000e [  124.608493] x16: 0000000000000007 
[  124.611906] 
[  124.613400] x15: 0000000000000000 [  124.616638] x14: 0000000000000000 
[  124.620051] 
[  124.621545] x13: 0000000000003815 [  124.624783] x12: 0000000000000002 
[  124.628197] 
[  124.629691] x11: ffff000008e21698 [  124.632928] x10: 0000000000000000 
[  124.636341] 
[  124.637836] x9 : ffff8003fff62280 [  124.641073] x8 : 7027207463656a62 
[  124.644487] 
[  124.645981] x7 : 6f6b20726f662064 [  124.649219] x6 : 0000000000003816 
[  124.652632] 
[  124.654126] x5 : ffff8003f5486218 [  124.657364] x4 : 0000000000000000 
[  124.660776] 
[  124.662270] x3 : 0000000000000000 [  124.665508] x2 : ffff000008d5cd18 
[  124.668921] 
[  124.670414] x1 : 0000000000000000 [  124.673652] x0 : 0000000000000036 
[  124.677065] 
[  124.678559] 
[  124.680053] ---[ end trace d18a42ce2a4e2247 ]---
[  124.684686] Call trace:
[  124.687139] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  124.693604] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  124.701464] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  124.709325] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  124.717186] 3a80: ffff8003cb251410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  124.725046] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  124.732907] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  124.740768] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003816 6f6b20726f662064
[  124.748628] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  124.756489] 3b20: 0000000000000002 0000000000003815 0000000000000000 0000000000000000
[  124.764349] 3b40: 0000000000000007 000000000000000e
[  124.769245] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  124.775013] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  124.780607] [<ffff00000850d480>] device_del+0x40/0x210
[  124.785765] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  124.791184] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  124.796864] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  124.802894] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  124.808748] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  124.814691] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  124.820458] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  124.825877] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  124.830686] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  124.836037] sysfs group 'power' not found for kobject 'phy-2:1:30'
[  124.842247] ------------[ cut here ]------------
[  124.846884] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  124.855179] Modules linked in:
[  124.858251] 
[  124.859746] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  124.869786] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  124.879565] Workqueue: scsi_wq_2 sas_destruct_devices
[  124.884645] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  124.890587] PC is at sysfs_remove_group+0x8c/0x94
[  124.895309] LR is at sysfs_remove_group+0x8c/0x94
[  124.900030] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  124.907454] sp : ffff8003f5483b40
[  124.910780] x29: ffff8003f5483b40 [  124.914018] x28: ffff000008d45000 
[  124.917431] 
[  124.918925] x27: 0000000000000000 [  124.922164] x26: 0000000000000000 
[  124.925577] 
[  124.927071] x25: 0000000000000001 [  124.930309] x24: 0000000000000001 
[  124.933722] 
[  124.935217] x23: ffff000008de2000 [  124.938454] x22: ffff8003cb251c00 
[  124.941867] 
[  124.943361] x21: ffff8003cb252038 [  124.946599] x20: ffff000008de32e0 
[  124.950012] 
[  124.951506] x19: 0000000000000000 [  124.954743] x18: ffff000008971660 
[  124.958157] 
[  124.959651] x17: 000000000000000e [  124.962889] x16: 0000000000000007 
[  124.966302] 
[  124.967795] x15: 0000000000000000 [  124.971034] x14: 0000000000000000 
[  124.974447] 
[  124.975941] x13: 0000000000003869 [  124.979179] x12: 0000000000000002 
[  124.982593] 
[  124.984087] x11: ffff000008e21698 [  124.987325] x10: 0000000000000000 
[  124.990739] 
[  124.992233] x9 : ffff8003fff62280 [  124.995471] x8 : 63656a626f6b2072 
[  124.998884] 
[  125.000378] x7 : 6f6620646e756f66 [  125.003616] x6 : 000000000000386a 
[  125.007029] 
[  125.008523] x5 : ffff8003f5486218 [  125.011760] x4 : 0000000000000000 
[  125.015174] 
[  125.016668] x3 : 0000000000000000 [  125.019905] x2 : ffff000008d5cd18 
[  125.023318] 
[  125.024812] x1 : 0000000000000000 [  125.028050] x0 : 0000000000000036 
[  125.031464] 
[  125.032958] 
[  125.034452] ---[ end trace d18a42ce2a4e2248 ]---
[  125.039086] Call trace:
[  125.041539] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  125.048004] 3960:                                   0000000000000000 0001000000000000
[  125.055865] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  125.063725] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  125.071586] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb252038 ffff8003cb251c00
[  125.079447] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  125.087308] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  125.095168] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  125.103030] 3a40: 000000000000386a 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  125.110891] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003869
[  125.118751] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  125.126613] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  125.132381] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  125.137974] [<ffff00000850d480>] device_del+0x40/0x210
[  125.143132] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  125.150470] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  125.156848] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  125.164012] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  125.170216] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  125.175636] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  125.181316] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  125.187346] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  125.193200] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  125.199143] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  125.204911] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  125.210329] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  125.215138] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  125.220489] sysfs group 'power' not found for kobject 'phy-2:1:30'
[  125.226700] ------------[ cut here ]------------
[  125.231335] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  125.239630] Modules linked in:
[  125.242705] 
[  125.244200] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  125.254240] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  125.264019] Workqueue: scsi_wq_2 sas_destruct_devices
[  125.269099] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  125.275043] PC is at sysfs_remove_group+0x8c/0x94
[  125.279764] LR is at sysfs_remove_group+0x8c/0x94
[  125.284486] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  125.291910] sp : ffff8003f5483bf0
[  125.295236] x29: ffff8003f5483bf0 [  125.298474] x28: ffff000008d45000 
[  125.301887] 
[  125.303381] x27: 0000000000000000 [  125.306619] x26: 0000000000000000 
[  125.310033] 
[  125.311527] x25: 0000000000000001 [  125.314765] x24: 0000000000000001 
[  125.318178] 
[  125.319672] x23: 0000000000000000 [  125.322910] x22: ffff8003cb1e8838 
[  125.326323] 
[  125.327817] x21: ffff8003cb251c10 [  125.331055] x20: ffff000008de32e0 
[  125.334468] 
[  125.335961] x19: 0000000000000000 [  125.339199] x18: ffff000008971660 
[  125.342613] 
[  125.344106] x17: 000000000000000e [  125.347344] x16: 0000000000000007 
[  125.350758] 
[  125.352252] x15: 0000000000000000 [  125.355491] x14: 0000000000000000 
[  125.358903] 
[  125.360397] x13: 00000000000038c1 [  125.363635] x12: 0000000000000002 
[  125.367049] 
[  125.368543] x11: ffff000008e21698 [  125.371780] x10: 0000000000000000 
[  125.375194] 
[  125.376688] x9 : ffff8003fff62280 [  125.379925] x8 : 63656a626f6b2072 
[  125.383339] 
[  125.384833] x7 : 6f6620646e756f66 [  125.388071] x6 : 00000000000038c2 
[  125.391485] 
[  125.392980] x5 : ffff8003f5486218 [  125.396217] x4 : 0000000000000000 
[  125.399630] 
[  125.401124] x3 : 0000000000000000 [  125.404361] x2 : ffff000008d5cd18 
[  125.407775] 
[  125.409269] x1 : 0000000000000000 [  125.412506] x0 : 0000000000000036 
[  125.415919] 
[  125.417413] 
[  125.418907] ---[ end trace d18a42ce2a4e2249 ]---
[  125.423541] Call trace:
[  125.425994] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  125.432460] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  125.440320] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  125.448180] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  125.456041] 3a80: ffff8003cb251c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  125.463900] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  125.471761] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  125.479622] 3ae0: 0000000000000000 ffff8003f5486218 00000000000038c2 6f6620646e756f66
[  125.487482] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  125.495344] 3b20: 0000000000000002 00000000000038c1 0000000000000000 0000000000000000
[  125.503204] 3b40: 0000000000000007 000000000000000e
[  125.508101] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  125.513870] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  125.519464] [<ffff00000850d480>] device_del+0x40/0x210
[  125.524622] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  125.530041] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  125.535721] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  125.541750] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  125.547605] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  125.553547] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  125.559315] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  125.564734] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  125.569543] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  125.574901] sysfs group 'power' not found for kobject 'phy-2:1:31'
[  125.581112] ------------[ cut here ]------------
[  125.585748] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  125.594044] Modules linked in:
[  125.597118] 
[  125.598613] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  125.608654] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  125.618433] Workqueue: scsi_wq_2 sas_destruct_devices
[  125.623512] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  125.629455] PC is at sysfs_remove_group+0x8c/0x94
[  125.634176] LR is at sysfs_remove_group+0x8c/0x94
[  125.638897] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  125.646321] sp : ffff8003f5483b40
[  125.649647] x29: ffff8003f5483b40 [  125.652885] x28: ffff000008d45000 
[  125.656299] 
[  125.657793] x27: 0000000000000000 [  125.661031] x26: 0000000000000000 
[  125.664444] 
[  125.665938] x25: 0000000000000001 [  125.669175] x24: 0000000000000001 
[  125.672588] 
[  125.674083] x23: ffff000008de2000 [  125.677321] x22: ffff8003cb252400 
[  125.680735] 
[  125.682229] x21: ffff8003cb252838 [  125.685466] x20: ffff000008de32e0 
[  125.688879] 
[  125.690373] x19: 0000000000000000 [  125.693612] x18: ffff000008971660 
[  125.697026] 
[  125.698520] x17: 000000000000000e [  125.701758] x16: 0000000000000007 
[  125.705171] 
[  125.706665] x15: 0000000000000000 [  125.709903] x14: 0000000000000000 
[  125.713317] 
[  125.714811] x13: 0000000000003915 [  125.718049] x12: 0000000000000002 
[  125.721463] 
[  125.722957] x11: ffff000008e21698 [  125.726195] x10: 0000000000000000 
[  125.729609] 
[  125.731103] x9 : ffff8003fff62280 [  125.734341] x8 : 333a313a322d7968 
[  125.737754] 
[  125.739249] x7 : 7027207463656a62 [  125.742486] x6 : 0000000000003916 
[  125.745899] 
[  125.747393] x5 : ffff8003f5486218 [  125.750630] x4 : 0000000000000000 
[  125.754044] 
[  125.755539] x3 : 0000000000000000 [  125.758777] x2 : ffff000008d5cd18 
[  125.762191] 
[  125.763685] x1 : 0000000000000000 [  125.766923] x0 : 0000000000000036 
[  125.770336] 
[  125.771829] 
[  125.773324] ---[ end trace d18a42ce2a4e224a ]---
[  125.777957] Call trace:
[  125.780411] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  125.786876] 3960:                                   0000000000000000 0001000000000000
[  125.794737] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  125.802598] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  125.810459] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb252838 ffff8003cb252400
[  125.818320] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  125.826181] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  125.834042] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  125.841903] 3a40: 0000000000003916 7027207463656a62 333a313a322d7968 ffff8003fff62280
[  125.849763] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003915
[  125.857623] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  125.865485] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  125.871254] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  125.876848] [<ffff00000850d480>] device_del+0x40/0x210
[  125.882006] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  125.889345] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  125.895724] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  125.902887] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  125.909091] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  125.914511] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  125.920191] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  125.926221] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  125.932076] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  125.938019] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  125.943788] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  125.949206] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  125.954015] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  125.959366] sysfs group 'power' not found for kobject 'phy-2:1:31'
[  125.965576] ------------[ cut here ]------------
[  125.970213] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  125.978508] Modules linked in:
[  125.981582] 
[  125.983078] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  125.993118] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  126.002897] Workqueue: scsi_wq_2 sas_destruct_devices
[  126.007977] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  126.013919] PC is at sysfs_remove_group+0x8c/0x94
[  126.018641] LR is at sysfs_remove_group+0x8c/0x94
[  126.023362] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  126.030785] sp : ffff8003f5483bf0
[  126.034111] x29: ffff8003f5483bf0 [  126.037349] x28: ffff000008d45000 
[  126.040762] 
[  126.042256] x27: 0000000000000000 [  126.045494] x26: 0000000000000000 
[  126.048907] 
[  126.050401] x25: 0000000000000001 [  126.053639] x24: 0000000000000001 
[  126.057052] 
[  126.058546] x23: 0000000000000000 [  126.061784] x22: ffff8003cb1e8838 
[  126.065197] 
[  126.066691] x21: ffff8003cb252410 [  126.069929] x20: ffff000008de32e0 
[  126.073343] 
[  126.074837] x19: 0000000000000000 [  126.078074] x18: ffff000008971660 
[  126.081488] 
[  126.082982] x17: 000000000000000e [  126.086221] x16: 0000000000000007 
[  126.089634] 
[  126.091128] x15: 0000000000000000 [  126.094365] x14: 0000000000000000 
[  126.097779] 
[  126.099273] x13: 000000000000396d [  126.102511] x12: 0000000000000002 
[  126.105924] 
[  126.107419] x11: ffff000008e21698 [  126.110656] x10: 0000000000000000 
[  126.114069] 
[  126.115564] x9 : ffff8003fff62280 [  126.118802] x8 : 333a313a322d7968 
[  126.122215] 
[  126.123709] x7 : 7027207463656a62 [  126.126947] x6 : 000000000000396e 
[  126.130361] 
[  126.131855] x5 : ffff8003f5486218 [  126.135093] x4 : 0000000000000000 
[  126.138505] 
[  126.139999] x3 : 0000000000000000 [  126.143236] x2 : ffff000008d5cd18 
[  126.146649] 
[  126.148143] x1 : 0000000000000000 [  126.151380] x0 : 0000000000000036 
[  126.154794] 
[  126.156288] 
[  126.157782] ---[ end trace d18a42ce2a4e224b ]---
[  126.162415] Call trace:
[  126.164868] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  126.171334] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  126.179195] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  126.187056] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  126.194917] 3a80: ffff8003cb252410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  126.202777] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  126.210639] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  126.218500] 3ae0: 0000000000000000 ffff8003f5486218 000000000000396e 7027207463656a62
[  126.226360] 3b00: 333a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  126.234220] 3b20: 0000000000000002 000000000000396d 0000000000000000 0000000000000000
[  126.242081] 3b40: 0000000000000007 000000000000000e
[  126.246978] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  126.252746] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  126.258340] [<ffff00000850d480>] device_del+0x40/0x210
[  126.263497] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  126.268916] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  126.274596] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  126.280626] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  126.286481] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  126.292423] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  126.298192] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  126.303610] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  126.308418] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  126.313773] sysfs group 'power' not found for kobject 'phy-2:1:32'
[  126.319985] ------------[ cut here ]------------
[  126.324621] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  126.332916] Modules linked in:
[  126.335989] 
[  126.337484] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  126.347525] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  126.357304] Workqueue: scsi_wq_2 sas_destruct_devices
[  126.362384] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  126.368327] PC is at sysfs_remove_group+0x8c/0x94
[  126.373050] LR is at sysfs_remove_group+0x8c/0x94
[  126.377771] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  126.385195] sp : ffff8003f5483b40
[  126.388521] x29: ffff8003f5483b40 [  126.391759] x28: ffff000008d45000 
[  126.395172] 
[  126.396666] x27: 0000000000000000 [  126.399904] x26: 0000000000000000 
[  126.403317] 
[  126.404811] x25: 0000000000000001 [  126.408049] x24: 0000000000000001 
[  126.411463] 
[  126.412956] x23: ffff000008de2000 [  126.416194] x22: ffff8003cb252c00 
[  126.419608] 
[  126.421103] x21: ffff8003cb253038 [  126.424341] x20: ffff000008de32e0 
[  126.427755] 
[  126.429249] x19: 0000000000000000 [  126.432487] x18: ffff000008971660 
[  126.435901] 
[  126.437394] x17: 000000000000000e [  126.440633] x16: 0000000000000007 
[  126.444046] 
[  126.445540] x15: 0000000000000000 [  126.448778] x14: 0000000000000000 
[  126.452191] 
[  126.453686] x13: 00000000000039c1 [  126.456923] x12: 0000000000000002 
[  126.460336] 
[  126.461831] x11: ffff000008e21698 [  126.465069] x10: 0000000000000000 
[  126.468482] 
[  126.469976] x9 : ffff8003fff62280 [  126.473214] x8 : 322d796870272074 
[  126.476628] 
[  126.478123] x7 : 63656a626f6b2072 [  126.481360] x6 : 00000000000039c2 
[  126.484773] 
[  126.486267] x5 : ffff8003f5486218 [  126.489504] x4 : 0000000000000000 
[  126.492917] 
[  126.494412] x3 : 0000000000000000 [  126.497649] x2 : ffff000008d5cd18 
[  126.501063] 
[  126.502557] x1 : 0000000000000000 [  126.505794] x0 : 0000000000000036 
[  126.509208] 
[  126.510702] 
[  126.512196] ---[ end trace d18a42ce2a4e224c ]---
[  126.516829] Call trace:
[  126.519282] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  126.525748] 3960:                                   0000000000000000 0001000000000000
[  126.533608] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  126.541469] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  126.549330] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb253038 ffff8003cb252c00
[  126.557190] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  126.565050] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  126.572911] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  126.580772] 3a40: 00000000000039c2 63656a626f6b2072 322d796870272074 ffff8003fff62280
[  126.588633] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 00000000000039c1
[  126.596494] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  126.604355] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  126.610124] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  126.615718] [<ffff00000850d480>] device_del+0x40/0x210
[  126.620876] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  126.628214] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  126.634592] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  126.641755] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  126.647960] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  126.653379] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  126.659059] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  126.665089] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  126.670944] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  126.676887] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  126.682655] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  126.688074] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  126.692883] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  126.698241] sysfs group 'power' not found for kobject 'phy-2:1:32'
[  126.704453] ------------[ cut here ]------------
[  126.709089] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  126.717385] Modules linked in:
[  126.720458] 
[  126.721953] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  126.731993] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  126.741771] Workqueue: scsi_wq_2 sas_destruct_devices
[  126.746853] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  126.752796] PC is at sysfs_remove_group+0x8c/0x94
[  126.757517] LR is at sysfs_remove_group+0x8c/0x94
[  126.762238] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  126.769662] sp : ffff8003f5483bf0
[  126.772987] x29: ffff8003f5483bf0 [  126.776225] x28: ffff000008d45000 
[  126.779638] 
[  126.781132] x27: 0000000000000000 [  126.784370] x26: 0000000000000000 
[  126.787784] 
[  126.789278] x25: 0000000000000001 [  126.792516] x24: 0000000000000001 
[  126.795929] 
[  126.797423] x23: 0000000000000000 [  126.800661] x22: ffff8003cb1e8838 
[  126.804075] 
[  126.805569] x21: ffff8003cb252c10 [  126.808807] x20: ffff000008de32e0 
[  126.812221] 
[  126.813714] x19: 0000000000000000 [  126.816953] x18: ffff000008971660 
[  126.820366] 
[  126.821860] x17: 000000000000000e [  126.825098] x16: 0000000000000007 
[  126.828511] 
[  126.830006] x15: 0000000000000000 [  126.833244] x14: 0000000000000000 
[  126.836658] 
[  126.838152] x13: 0000000000003a19 [  126.841390] x12: 0000000000000002 
[  126.844804] 
[  126.846298] x11: ffff000008e21698 [  126.849536] x10: 0000000000000000 
[  126.852949] 
[  126.854443] x9 : ffff8003fff62280 [  126.857681] x8 : 322d796870272074 
[  126.861094] 
[  126.862589] x7 : 63656a626f6b2072 [  126.865826] x6 : 0000000000003a1a 
[  126.869239] 
[  126.870734] x5 : ffff8003f5486218 [  126.873971] x4 : 0000000000000000 
[  126.877385] 
[  126.878879] x3 : 0000000000000000 [  126.882116] x2 : ffff000008d5cd18 
[  126.885530] 
[  126.887024] x1 : 0000000000000000 [  126.890262] x0 : 0000000000000036 
[  126.893675] 
[  126.895169] 
[  126.896663] ---[ end trace d18a42ce2a4e224d ]---
[  126.901296] Call trace:
[  126.903750] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  126.910216] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  126.918077] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  126.925938] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  126.933799] 3a80: ffff8003cb252c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  126.941659] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  126.949520] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  126.957381] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003a1a 63656a626f6b2072
[  126.965242] 3b00: 322d796870272074 ffff8003fff62280 0000000000000000 ffff000008e21698
[  126.973103] 3b20: 0000000000000002 0000000000003a19 0000000000000000 0000000000000000
[  126.980964] 3b40: 0000000000000007 000000000000000e
[  126.985860] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  126.991628] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  126.997222] [<ffff00000850d480>] device_del+0x40/0x210
[  127.002379] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  127.007798] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  127.013478] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  127.019508] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  127.025363] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  127.031306] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  127.037074] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  127.042493] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  127.047302] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  127.052654] sysfs group 'power' not found for kobject 'phy-2:1:33'
[  127.058864] ------------[ cut here ]------------
[  127.063499] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  127.071794] Modules linked in:
[  127.074869] 
[  127.076364] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  127.086404] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  127.096182] Workqueue: scsi_wq_2 sas_destruct_devices
[  127.101263] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  127.107206] PC is at sysfs_remove_group+0x8c/0x94
[  127.111928] LR is at sysfs_remove_group+0x8c/0x94
[  127.116649] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  127.124072] sp : ffff8003f5483b40
[  127.127398] x29: ffff8003f5483b40 [  127.130636] x28: ffff000008d45000 
[  127.134049] 
[  127.135544] x27: 0000000000000000 [  127.138781] x26: 0000000000000000 
[  127.142195] 
[  127.143688] x25: 0000000000000001 [  127.146926] x24: 0000000000000001 
[  127.150340] 
[  127.151834] x23: ffff000008de2000 [  127.155072] x22: ffff8003cb253400 
[  127.158485] 
[  127.159979] x21: ffff8003cb253838 [  127.163217] x20: ffff000008de32e0 
[  127.166629] 
[  127.168124] x19: 0000000000000000 [  127.171361] x18: ffff000008971660 
[  127.174775] 
[  127.176268] x17: 000000000000000e [  127.179507] x16: 0000000000000007 
[  127.182921] 
[  127.184415] x15: 0000000000000000 [  127.187653] x14: 0000000000000000 
[  127.191066] 
[  127.192560] x13: 0000000000003a6d [  127.195797] x12: 0000000000000002 
[  127.199210] 
[  127.200704] x11: ffff000008e21698 [  127.203943] x10: 0000000000000000 
[  127.207357] 
[  127.208851] x9 : ffff8003fff62280 [  127.212089] x8 : 7027207463656a62 
[  127.215503] 
[  127.216996] x7 : 6f6b20726f662064 [  127.220234] x6 : 0000000000003a6e 
[  127.223646] 
[  127.225141] x5 : ffff8003f5486218 [  127.228379] x4 : 0000000000000000 
[  127.231791] 
[  127.233286] x3 : 0000000000000000 [  127.236523] x2 : ffff000008d5cd18 
[  127.239936] 
[  127.241430] x1 : 0000000000000000 [  127.244667] x0 : 0000000000000036 
[  127.248080] 
[  127.249574] 
[  127.251068] ---[ end trace d18a42ce2a4e224e ]---
[  127.255702] Call trace:
[  127.258155] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  127.264620] 3960:                                   0000000000000000 0001000000000000
[  127.272480] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  127.280341] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  127.288201] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb253838 ffff8003cb253400
[  127.296061] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  127.303922] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  127.311782] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  127.319643] 3a40: 0000000000003a6e 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  127.327503] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003a6d
[  127.335365] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  127.343226] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  127.348995] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  127.354588] [<ffff00000850d480>] device_del+0x40/0x210
[  127.359746] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  127.367084] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  127.373461] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  127.380624] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  127.386828] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  127.392247] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  127.397927] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  127.403957] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  127.409812] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  127.415756] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  127.421523] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  127.426942] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  127.431751] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  127.437103] sysfs group 'power' not found for kobject 'phy-2:1:33'
[  127.443314] ------------[ cut here ]------------
[  127.447950] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  127.456246] Modules linked in:
[  127.459320] 
[  127.460815] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  127.470855] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  127.480634] Workqueue: scsi_wq_2 sas_destruct_devices
[  127.485715] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  127.491658] PC is at sysfs_remove_group+0x8c/0x94
[  127.496380] LR is at sysfs_remove_group+0x8c/0x94
[  127.501102] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  127.508526] sp : ffff8003f5483bf0
[  127.511852] x29: ffff8003f5483bf0 [  127.515089] x28: ffff000008d45000 
[  127.518502] 
[  127.519997] x27: 0000000000000000 [  127.523236] x26: 0000000000000000 
[  127.526650] 
[  127.528143] x25: 0000000000000001 [  127.531381] x24: 0000000000000001 
[  127.534794] 
[  127.536287] x23: 0000000000000000 [  127.539526] x22: ffff8003cb1e8838 
[  127.542939] 
[  127.544433] x21: ffff8003cb253410 [  127.547671] x20: ffff000008de32e0 
[  127.551084] 
[  127.552578] x19: 0000000000000000 [  127.555815] x18: ffff000008971660 
[  127.559228] 
[  127.560722] x17: 000000000000000e [  127.563960] x16: 0000000000000007 
[  127.567374] 
[  127.568868] x15: 0000000000000000 [  127.572107] x14: 0000000000000000 
[  127.575520] 
[  127.577014] x13: 0000000000003ac5 [  127.580252] x12: 0000000000000002 
[  127.583666] 
[  127.585160] x11: ffff000008e21698 [  127.588398] x10: 0000000000000000 
[  127.591811] 
[  127.593305] x9 : ffff8003fff62280 [  127.596543] x8 : 7027207463656a62 
[  127.599957] 
[  127.601450] x7 : 6f6b20726f662064 [  127.604688] x6 : 0000000000003ac6 
[  127.608101] 
[  127.609595] x5 : ffff8003f5486218 [  127.612832] x4 : 0000000000000000 
[  127.616246] 
[  127.617740] x3 : 0000000000000000 [  127.620977] x2 : ffff000008d5cd18 
[  127.624391] 
[  127.625885] x1 : 0000000000000000 [  127.629123] x0 : 0000000000000036 
[  127.632536] 
[  127.634029] 
[  127.635523] ---[ end trace d18a42ce2a4e224f ]---
[  127.640157] Call trace:
[  127.642611] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  127.649076] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  127.656937] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  127.664798] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  127.672658] 3a80: ffff8003cb253410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  127.680518] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  127.688378] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  127.696239] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003ac6 6f6b20726f662064
[  127.704100] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  127.711960] 3b20: 0000000000000002 0000000000003ac5 0000000000000000 0000000000000000
[  127.719820] 3b40: 0000000000000007 000000000000000e
[  127.724716] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  127.730484] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  127.736078] [<ffff00000850d480>] device_del+0x40/0x210
[  127.741235] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  127.746655] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  127.752336] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  127.758365] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  127.764220] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  127.770162] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  127.775930] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  127.781349] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  127.786157] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  127.791509] sysfs group 'power' not found for kobject 'phy-2:1:34'
[  127.797719] ------------[ cut here ]------------
[  127.802355] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  127.810651] Modules linked in:
[  127.813725] 
[  127.815220] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  127.825261] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  127.835040] Workqueue: scsi_wq_2 sas_destruct_devices
[  127.840121] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  127.846063] PC is at sysfs_remove_group+0x8c/0x94
[  127.850786] LR is at sysfs_remove_group+0x8c/0x94
[  127.855507] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  127.862931] sp : ffff8003f5483b40
[  127.866257] x29: ffff8003f5483b40 [  127.869495] x28: ffff000008d45000 
[  127.872908] 
[  127.874402] x27: 0000000000000000 [  127.877641] x26: 0000000000000000 
[  127.881054] 
[  127.882548] x25: 0000000000000001 [  127.885785] x24: 0000000000000001 
[  127.889198] 
[  127.890691] x23: ffff000008de2000 [  127.893930] x22: ffff8003cb253c00 
[  127.897344] 
[  127.898838] x21: ffff8003cb254038 [  127.902076] x20: ffff000008de32e0 
[  127.905489] 
[  127.906983] x19: 0000000000000000 [  127.910221] x18: ffff000008971660 
[  127.913635] 
[  127.915129] x17: 000000000000000e [  127.918366] x16: 0000000000000007 
[  127.921780] 
[  127.923275] x15: 0000000000000000 [  127.926512] x14: 0000000000000000 
[  127.929925] 
[  127.931419] x13: 0000000000003b19 [  127.934656] x12: 0000000000000002 
[  127.938069] 
[  127.939564] x11: ffff000008e21698 [  127.942802] x10: 0000000000000000 
[  127.946215] 
[  127.947710] x9 : ffff8003fff62280 [  127.950947] x8 : 63656a626f6b2072 
[  127.954361] 
[  127.955855] x7 : 6f6620646e756f66 [  127.959093] x6 : 0000000000003b1a 
[  127.962505] 
[  127.964000] x5 : ffff8003f5486218 [  127.967238] x4 : 0000000000000000 
[  127.970651] 
[  127.972145] x3 : 0000000000000000 [  127.975383] x2 : ffff000008d5cd18 
[  127.978797] 
[  127.980291] x1 : 0000000000000000 [  127.983529] x0 : 0000000000000036 
[  127.986942] 
[  127.988436] 
[  127.989930] ---[ end trace d18a42ce2a4e2250 ]---
[  127.994564] Call trace:
[  127.997018] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  128.003483] 3960:                                   0000000000000000 0001000000000000
[  128.011345] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  128.019205] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  128.027065] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb254038 ffff8003cb253c00
[  128.034925] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  128.042787] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  128.050647] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  128.058507] 3a40: 0000000000003b1a 6f6620646e756f66 63656a626f6b2072 ffff8003fff62280
[  128.066368] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003b19
[  128.074229] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  128.082090] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  128.087859] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  128.093452] [<ffff00000850d480>] device_del+0x40/0x210
[  128.098610] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  128.105947] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  128.112326] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  128.119490] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  128.125694] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  128.131114] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  128.136795] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  128.142824] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  128.148679] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  128.154622] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  128.160390] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  128.165809] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  128.170618] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  128.175977] sysfs group 'power' not found for kobject 'phy-2:1:34'
[  128.182188] ------------[ cut here ]------------
[  128.186823] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  128.195118] Modules linked in:
[  128.198193] 
[  128.199689] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  128.209730] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  128.219509] Workqueue: scsi_wq_2 sas_destruct_devices
[  128.224589] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  128.230532] PC is at sysfs_remove_group+0x8c/0x94
[  128.235254] LR is at sysfs_remove_group+0x8c/0x94
[  128.239975] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  128.247399] sp : ffff8003f5483bf0
[  128.250725] x29: ffff8003f5483bf0 [  128.253964] x28: ffff000008d45000 
[  128.257378] 
[  128.258872] x27: 0000000000000000 [  128.262110] x26: 0000000000000000 
[  128.265523] 
[  128.267018] x25: 0000000000000001 [  128.270256] x24: 0000000000000001 
[  128.273669] 
[  128.275163] x23: 0000000000000000 [  128.278402] x22: ffff8003cb1e8838 
[  128.281815] 
[  128.283310] x21: ffff8003cb253c10 [  128.286547] x20: ffff000008de32e0 
[  128.289960] 
[  128.291454] x19: 0000000000000000 [  128.294692] x18: ffff000008971660 
[  128.298105] 
[  128.299599] x17: 000000000000000e [  128.302837] x16: 0000000000000007 
[  128.306249] 
[  128.307744] x15: 0000000000000000 [  128.310981] x14: 0000000000000000 
[  128.314394] 
[  128.315889] x13: 0000000000003b71 [  128.319126] x12: 0000000000000002 
[  128.322540] 
[  128.324034] x11: ffff000008e21698 [  128.327272] x10: 0000000000000000 
[  128.330685] 
[  128.332180] x9 : ffff8003fff62280 [  128.335418] x8 : 63656a626f6b2072 
[  128.338831] 
[  128.340325] x7 : 6f6620646e756f66 [  128.343563] x6 : 0000000000003b72 
[  128.346976] 
[  128.348470] x5 : ffff8003f5486218 [  128.351707] x4 : 0000000000000000 
[  128.355120] 
[  128.356614] x3 : 0000000000000000 [  128.359853] x2 : ffff000008d5cd18 
[  128.363266] 
[  128.364760] x1 : 0000000000000000 [  128.367998] x0 : 0000000000000036 
[  128.371411] 
[  128.372905] 
[  128.374399] ---[ end trace d18a42ce2a4e2251 ]---
[  128.379032] Call trace:
[  128.381487] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  128.387952] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  128.395812] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  128.403673] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  128.411534] 3a80: ffff8003cb253c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  128.419394] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  128.427255] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  128.435116] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003b72 6f6620646e756f66
[  128.442977] 3b00: 63656a626f6b2072 ffff8003fff62280 0000000000000000 ffff000008e21698
[  128.450837] 3b20: 0000000000000002 0000000000003b71 0000000000000000 0000000000000000
[  128.458697] 3b40: 0000000000000007 000000000000000e
[  128.463594] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  128.469362] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  128.474956] [<ffff00000850d480>] device_del+0x40/0x210
[  128.480114] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  128.485534] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  128.491214] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  128.497243] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  128.503098] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  128.509041] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  128.514809] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  128.520228] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  128.525036] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  128.530389] sysfs group 'power' not found for kobject 'phy-2:1:35'
[  128.536600] ------------[ cut here ]------------
[  128.541237] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  128.549532] Modules linked in:
[  128.552606] 
[  128.554101] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  128.564142] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  128.573921] Workqueue: scsi_wq_2 sas_destruct_devices
[  128.579001] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  128.584943] PC is at sysfs_remove_group+0x8c/0x94
[  128.589666] LR is at sysfs_remove_group+0x8c/0x94
[  128.594387] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  128.601811] sp : ffff8003f5483b40
[  128.605135] x29: ffff8003f5483b40 [  128.608374] x28: ffff000008d45000 
[  128.611787] 
[  128.613281] x27: 0000000000000000 [  128.616519] x26: 0000000000000000 
[  128.619932] 
[  128.621426] x25: 0000000000000001 [  128.624665] x24: 0000000000000001 
[  128.628078] 
[  128.629573] x23: ffff000008de2000 [  128.632810] x22: ffff8003cb254400 
[  128.636223] 
[  128.637718] x21: ffff8003cb254838 [  128.640955] x20: ffff000008de32e0 
[  128.644369] 
[  128.645863] x19: 0000000000000000 [  128.649101] x18: ffff000008971660 
[  128.652514] 
[  128.654008] x17: 000000000000000e [  128.657246] x16: 0000000000000007 
[  128.660659] 
[  128.662153] x15: 0000000000000000 [  128.665391] x14: 0000000000000000 
[  128.668805] 
[  128.670299] x13: 0000000000003bc5 [  128.673537] x12: 0000000000000002 
[  128.676949] 
[  128.678444] x11: ffff000008e21698 [  128.681681] x10: 0000000000000000 
[  128.685095] 
[  128.686589] x9 : ffff8003fff62280 [  128.689827] x8 : 333a313a322d7968 
[  128.693241] 
[  128.694735] x7 : 7027207463656a62 [  128.697972] x6 : 0000000000003bc6 
[  128.701386] 
[  128.702880] x5 : ffff8003f5486218 [  128.706118] x4 : 0000000000000000 
[  128.709530] 
[  128.711024] x3 : 0000000000000000 [  128.714263] x2 : ffff000008d5cd18 
[  128.717676] 
[  128.719170] x1 : 0000000000000000 [  128.722409] x0 : 0000000000000036 
[  128.725821] 
[  128.727316] 
[  128.728810] ---[ end trace d18a42ce2a4e2252 ]---
[  128.733442] Call trace:
[  128.735897] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  128.742363] 3960:                                   0000000000000000 0001000000000000
[  128.750224] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  128.758085] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  128.765945] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb254838 ffff8003cb254400
[  128.773806] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  128.781667] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  128.789527] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  128.797388] 3a40: 0000000000003bc6 7027207463656a62 333a313a322d7968 ffff8003fff62280
[  128.805248] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003bc5
[  128.813110] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  128.820971] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  128.826740] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  128.832334] [<ffff00000850d480>] device_del+0x40/0x210
[  128.837492] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  128.844829] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  128.851208] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  128.858371] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  128.864575] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  128.869993] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  128.875675] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  128.881704] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  128.887559] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  128.893503] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  128.899271] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  128.904689] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  128.909498] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  128.914850] sysfs group 'power' not found for kobject 'phy-2:1:35'
[  128.921060] ------------[ cut here ]------------
[  128.925695] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  128.933990] Modules linked in:
[  128.937065] 
[  128.938560] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  128.948600] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  128.958380] Workqueue: scsi_wq_2 sas_destruct_devices
[  128.963460] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  128.969404] PC is at sysfs_remove_group+0x8c/0x94
[  128.974125] LR is at sysfs_remove_group+0x8c/0x94
[  128.978847] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  128.986270] sp : ffff8003f5483bf0
[  128.989596] x29: ffff8003f5483bf0 [  128.992834] x28: ffff000008d45000 
[  128.996248] 
[  128.997742] x27: 0000000000000000 [  129.000979] x26: 0000000000000000 
[  129.004393] 
[  129.005887] x25: 0000000000000001 [  129.009124] x24: 0000000000000001 
[  129.012537] 
[  129.014031] x23: 0000000000000000 [  129.017268] x22: ffff8003cb1e8838 
[  129.020681] 
[  129.022176] x21: ffff8003cb254410 [  129.025413] x20: ffff000008de32e0 
[  129.028826] 
[  129.030320] x19: 0000000000000000 [  129.033558] x18: ffff000008971660 
[  129.036972] 
[  129.038466] x17: 000000000000000e [  129.041704] x16: 0000000000000007 
[  129.045117] 
[  129.046611] x15: 0000000000000000 [  129.049849] x14: 0000000000000000 
[  129.053262] 
[  129.054756] x13: 0000000000003c1d [  129.057995] x12: 0000000000000002 
[  129.061407] 
[  129.062902] x11: ffff000008e21698 [  129.066140] x10: 0000000000000000 
[  129.069553] 
[  129.071048] x9 : ffff8003fff62280 [  129.074285] x8 : 333a313a322d7968 
[  129.077699] 
[  129.079193] x7 : 7027207463656a62 [  129.082431] x6 : 0000000000003c1e 
[  129.085844] 
[  129.087338] x5 : ffff8003f5486218 [  129.090576] x4 : 0000000000000000 
[  129.093989] 
[  129.095483] x3 : 0000000000000000 [  129.098721] x2 : ffff000008d5cd18 
[  129.102135] 
[  129.103629] x1 : 0000000000000000 [  129.106866] x0 : 0000000000000036 
[  129.110280] 
[  129.111774] 
[  129.113268] ---[ end trace d18a42ce2a4e2253 ]---
[  129.117901] Call trace:
[  129.120356] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  129.126822] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  129.134683] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  129.142543] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  129.150403] 3a80: ffff8003cb254410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  129.158264] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  129.166125] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  129.173986] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003c1e 7027207463656a62
[  129.181846] 3b00: 333a313a322d7968 ffff8003fff62280 0000000000000000 ffff000008e21698
[  129.189706] 3b20: 0000000000000002 0000000000003c1d 0000000000000000 0000000000000000
[  129.197567] 3b40: 0000000000000007 000000000000000e
[  129.202463] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  129.208232] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  129.213825] [<ffff00000850d480>] device_del+0x40/0x210
[  129.218984] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  129.224403] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  129.230084] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  129.236113] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  129.241968] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  129.247910] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  129.253677] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  129.259096] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  129.263905] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  129.269258] sysfs group 'power' not found for kobject 'phy-2:1:36'
[  129.275470] ------------[ cut here ]------------
[  129.280106] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  129.288402] Modules linked in:
[  129.291476] 
[  129.292971] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  129.303010] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  129.312789] Workqueue: scsi_wq_2 sas_destruct_devices
[  129.317869] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  129.323811] PC is at sysfs_remove_group+0x8c/0x94
[  129.328533] LR is at sysfs_remove_group+0x8c/0x94
[  129.333254] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  129.340678] sp : ffff8003f5483b40
[  129.344004] x29: ffff8003f5483b40 [  129.347242] x28: ffff000008d45000 
[  129.350655] 
[  129.352149] x27: 0000000000000000 [  129.355387] x26: 0000000000000000 
[  129.358799] 
[  129.360294] x25: 0000000000000001 [  129.363532] x24: 0000000000000001 
[  129.366945] 
[  129.368440] x23: ffff000008de2000 [  129.371678] x22: ffff8003cb254c00 
[  129.375091] 
[  129.376586] x21: ffff8003cb255038 [  129.379824] x20: ffff000008de32e0 
[  129.383237] 
[  129.384732] x19: 0000000000000000 [  129.387969] x18: ffff000008971660 
[  129.391382] 
[  129.392875] x17: 000000000000000e [  129.396113] x16: 0000000000000007 
[  129.399526] 
[  129.401020] x15: 0000000000000000 [  129.404257] x14: 0000000000000000 
[  129.407671] 
[  129.409165] x13: 0000000000003c71 [  129.412403] x12: 0000000000000002 
[  129.415817] 
[  129.417311] x11: ffff000008e21698 [  129.420549] x10: 0000000000000000 
[  129.423962] 
[  129.425456] x9 : ffff8003fff62280 [  129.428693] x8 : 7027207463656a62 
[  129.432107] 
[  129.433601] x7 : 6f6b20726f662064 [  129.436838] x6 : 0000000000003c72 
[  129.440252] 
[  129.441746] x5 : ffff8003f5486218 [  129.444985] x4 : 0000000000000000 
[  129.448398] 
[  129.449892] x3 : 0000000000000000 [  129.453130] x2 : ffff000008d5cd18 
[  129.456543] 
[  129.458037] x1 : 0000000000000000 [  129.461275] x0 : 0000000000000036 
[  129.464689] 
[  129.466183] 
[  129.467677] ---[ end trace d18a42ce2a4e2254 ]---
[  129.472310] Call trace:
[  129.474764] Exception stack(0xffff8003f5483970 to 0xffff8003f5483aa0)
[  129.481229] 3960:                                   0000000000000000 0001000000000000
[  129.489089] 3980: ffff8003f5483b40 ffff000008252a70 0000000000000004 0000000000000036
[  129.496950] 39a0: 0000000000000000 ffff000008b1ae70 ffff8003f5483a60 ffff0000080fc970
[  129.504811] 39c0: 0000000000000000 ffff000008de32e0 ffff8003cb255038 ffff8003cb254c00
[  129.512671] 39e0: ffff000008de2000 0000000000000001 0000000000000001 0000000000000000
[  129.520531] 3a00: 0000000000000000 ffff000008d45000 0000000000000036 0000000000000000
[  129.528392] 3a20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  129.536253] 3a40: 0000000000003c72 6f6b20726f662064 7027207463656a62 ffff8003fff62280
[  129.544114] 3a60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003c71
[  129.551974] 3a80: 0000000000000000 0000000000000000 0000000000000007 000000000000000e
[  129.559835] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  129.565603] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  129.571196] [<ffff00000850d480>] device_del+0x40/0x210
[  129.576354] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  129.583691] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  129.590069] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  129.597232] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  129.603436] [<ffff0000085560c0>] sas_phy_delete+0x24/0x4c
[  129.608856] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  129.614536] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  129.620567] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  129.626422] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  129.632364] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  129.638132] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  129.643551] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  129.648359] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  129.653716] sysfs group 'power' not found for kobject 'phy-2:1:36'
[  129.659928] ------------[ cut here ]------------
[  129.664564] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  129.672860] Modules linked in:
[  129.675935] 
[  129.677430] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  129.687470] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  129.697249] Workqueue: scsi_wq_2 sas_destruct_devices
[  129.702330] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  129.708272] PC is at sysfs_remove_group+0x8c/0x94
[  129.712995] LR is at sysfs_remove_group+0x8c/0x94
[  129.717716] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  129.725140] sp : ffff8003f5483bf0
[  129.728466] x29: ffff8003f5483bf0 [  129.731704] x28: ffff000008d45000 
[  129.735117] 
[  129.736611] x27: 0000000000000000 [  129.739849] x26: 0000000000000000 
[  129.743263] 
[  129.744757] x25: 0000000000000001 [  129.747995] x24: 0000000000000001 
[  129.751407] 
[  129.752902] x23: 0000000000000000 [  129.756139] x22: ffff8003cb1e8838 
[  129.759553] 
[  129.761047] x21: ffff8003cb254c10 [  129.764284] x20: ffff000008de32e0 
[  129.767698] 
[  129.769192] x19: 0000000000000000 [  129.772429] x18: ffff000008971660 
[  129.775842] 
[  129.777337] x17: 000000000000000e [  129.780575] x16: 0000000000000007 
[  129.783988] 
[  129.785482] x15: 0000000000000000 [  129.788720] x14: 0000000000000000 
[  129.792133] 
[  129.793627] x13: 0000000000003cc9 [  129.796866] x12: 0000000000000002 
[  129.800280] 
[  129.801774] x11: ffff000008e21698 [  129.805011] x10: 0000000000000000 
[  129.808425] 
[  129.809918] x9 : ffff8003fff62280 [  129.813156] x8 : 7027207463656a62 
[  129.816569] 
[  129.818063] x7 : 6f6b20726f662064 [  129.821302] x6 : 0000000000003cca 
[  129.824715] 
[  129.826209] x5 : ffff8003f5486218 [  129.829448] x4 : 0000000000000000 
[  129.832861] 
[  129.834355] x3 : 0000000000000000 [  129.837592] x2 : ffff000008d5cd18 
[  129.841006] 
[  129.842500] x1 : 0000000000000000 [  129.845738] x0 : 0000000000000036 
[  129.849151] 
[  129.850645] 
[  129.852140] ---[ end trace d18a42ce2a4e2255 ]---
[  129.856774] Call trace:
[  129.859228] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  129.865694] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  129.873554] 3a40: 0000000000000004 0000000000000036 0000000000000000 ffff000008b1ae70
[  129.881415] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  129.889275] 3a80: ffff8003cb254c10 ffff8003cb1e8838 0000000000000000 0000000000000001
[  129.897135] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  129.904995] 3ac0: 0000000000000036 0000000000000000 ffff000008d5cd18 0000000000000000
[  129.912856] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003cca 6f6b20726f662064
[  129.920716] 3b00: 7027207463656a62 ffff8003fff62280 0000000000000000 ffff000008e21698
[  129.928577] 3b20: 0000000000000002 0000000000003cc9 0000000000000000 0000000000000000
[  129.936437] 3b40: 0000000000000007 000000000000000e
[  129.941334] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  129.947102] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  129.952697] [<ffff00000850d480>] device_del+0x40/0x210
[  129.957855] [<ffff0000085560c8>] sas_phy_delete+0x2c/0x4c
[  129.963273] [<ffff000008556554>] do_sas_phy_delete+0x4c/0x58
[  129.968954] [<ffff00000850d094>] device_for_each_child+0x44/0x74
[  129.974983] [<ffff000008553668>] sas_remove_children+0x34/0x40
[  129.980838] [<ffff000008558a0c>] sas_destruct_devices+0x5c/0x98
[  129.986780] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  129.992548] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  129.997967] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  130.002776] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  130.008124] sysfs group 'power' not found for kobject 'expander-2:1'
[  130.014508] ------------[ cut here ]------------
[  130.019144] WARNING: CPU: 21 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  130.027441] Modules linked in:
[  130.030516] 
[  130.032011] CPU: 21 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  130.042052] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  130.051831] Workqueue: scsi_wq_2 sas_destruct_devices
[  130.056910] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  130.062854] PC is at sysfs_remove_group+0x8c/0x94
[  130.067576] LR is at sysfs_remove_group+0x8c/0x94
[  130.072296] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000045
[  130.079721] sp : ffff8003f5483bf0
[  130.083046] x29: ffff8003f5483bf0 [  130.086284] x28: ffff000008d45000 
[  130.089698] 
[  130.091193] x27: 0000000000000000 [  130.094430] x26: 0000000000000000 
[  130.097843] 
[  130.099337] x25: 0000000000000001 [  130.102575] x24: 0000000000000001 
[  130.105988] 
[  130.107482] x23: 0000000000000000 [  130.110719] x22: ffff8003cb1e8838 
[  130.114133] 
[  130.115627] x21: ffff8003cb1ea410 [  130.118865] x20: ffff000008de32e0 
[  130.122279] 
[  130.123773] x19: 0000000000000000 [  130.127011] x18: ffff000008971660 
[  130.130424] 
[  130.131918] x17: 000000000000000e [  130.135156] x16: 0000000000000007 
[  130.138568] 
[  130.140062] x15: 0000000000000000 [  130.143300] x14: 0000000000000000 
[  130.146713] 
[  130.148208] x13: 0000000000003d1d [  130.151445] x12: 0000000000000002 
[  130.154859] 
[  130.156353] x11: ffff000008e21698 [  130.159591] x10: 0000000000000000 
[  130.163004] 
[  130.164498] x9 : ffff8003fff62280 [  130.167735] x8 : 27313a322d726564 
[  130.171148] 
[  130.172643] x7 : 6e61707865272074 [  130.175880] x6 : 0000000000003d1e 
[  130.179294] 
[  130.180788] x5 : ffff8003f5486218 [  130.184026] x4 : 0000000000000000 
[  130.187438] 
[  130.188933] x3 : 0000000000000000 [  130.192170] x2 : ffff000008d5cd18 
[  130.195583] 
[  130.197077] x1 : 0000000000000000 [  130.200315] x0 : 0000000000000038 
[  130.203727] 
[  130.205221] 
[  130.206715] ---[ end trace d18a42ce2a4e2256 ]---
[  130.211349] Call trace:
[  130.213803] Exception stack(0xffff8003f5483a20 to 0xffff8003f5483b50)
[  130.220269] 3a20: 0000000000000000 0001000000000000 ffff8003f5483bf0 ffff000008252a70
[  130.228129] 3a40: 0000000000000004 0000000000000038 0000000000000000 ffff000008b1ae70
[  130.235989] 3a60: ffff8003f5483b10 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  130.243850] 3a80: ffff8003cb1ea410 ffff8003cb1e8838 0000000000000000 0000000000000001
[  130.251711] 3aa0: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  130.259572] 3ac0: 0000000000000038 0000000000000000 ffff000008d5cd18 0000000000000000
[  130.267433] 3ae0: 0000000000000000 ffff8003f5486218 0000000000003d1e 6e61707865272074
[  130.275294] 3b00: 27313a322d726564 ffff8003fff62280 0000000000000000 ffff000008e21698
[  130.283155] 3b20: 0000000000000002 0000000000003d1d 0000000000000000 0000000000000000
[  130.291014] 3b40: 0000000000000007 000000000000000e
[  130.295910] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  130.301678] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  130.307272] [<ffff00000850d480>] device_del+0x40/0x210
[  130.312431] [<ffff00000850d664>] device_unregister+0x14/0x2c
[  130.318112] [<ffff00000836201c>] bsg_unregister_queue+0x58/0x9c
[  130.324056] [<ffff000008554a44>] sas_rphy_remove+0x44/0x80
[  130.329562] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  130.335069] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  130.341011] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  130.346779] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  130.352198] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  130.357006] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  130.362394] sysfs group 'power' not found for kobject 'expander-2:1'
[  130.368784] ------------[ cut here ]------------
[  130.373421] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  130.381716] Modules linked in:
[  130.384790] 
[  130.386286] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  130.396327] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  130.406106] Workqueue: scsi_wq_2 sas_destruct_devices
[  130.411186] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  130.417129] PC is at sysfs_remove_group+0x8c/0x94
[  130.421852] LR is at sysfs_remove_group+0x8c/0x94
[  130.426573] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[  130.433996] sp : ffff8003f5483b90
[  130.437322] x29: ffff8003f5483b90 [  130.440559] x28: ffff000008d45000 
[  130.443972] 
[  130.445466] x27: 0000000000000000 [  130.448704] x26: 0000000000000000 
[  130.452117] 
[  130.453611] x25: 0000000000000001 [  130.456850] x24: 0000000000000001 
[  130.460263] 
[  130.461757] x23: ffff000008de2000 [  130.464995] x22: ffff8003cb1e8838 
[  130.468408] 
[  130.469902] x21: ffff8003cb1e8c38 [  130.473140] x20: ffff000008de32e0 
[  130.476553] 
[  130.478046] x19: 0000000000000000 [  130.481284] x18: 0000ffffcbcc6090 
[  130.484698] 
[  130.486191] x17: 0000000000497240 [  130.489430] x16: ffff0000081e3e54 
[  130.492843] 
[  130.494337] x15: 0000000000000000 [  130.497575] x14: 0000000000000000 
[  130.500988] 
[  130.502481] x13: 0000000000003d71 [  130.505719] x12: 0000000000000002 
[  130.509132] 
[  130.510625] x11: ffff000008e21698 [  130.513864] x10: 0000000000000000 
[  130.517276] 
[  130.518770] x9 : ffff8003fff62280 [  130.522008] x8 : 27313a322d726564 
[  130.525422] 
[  130.526915] x7 : 6e61707865272074 [  130.530154] x6 : 0000000000003d72 
[  130.533567] 
[  130.535062] x5 : ffff8003f5486218 [  130.538300] x4 : 0000000000000000 
[  130.541713] 
[  130.543208] x3 : 0000000000000000 [  130.546446] x2 : ffff000008d5cd18 
[  130.549860] 
[  130.551354] x1 : 0000000000000000 [  130.554592] x0 : 0000000000000038 
[  130.558006] 
[  130.559499] 
[  130.560994] ---[ end trace d18a42ce2a4e2257 ]---
[  130.565628] Call trace:
[  130.568082] Exception stack(0xffff8003f54839c0 to 0xffff8003f5483af0)
[  130.574547] 39c0: 0000000000000000 0001000000000000 ffff8003f5483b90 ffff000008252a70
[  130.582408] 39e0: 0000000000000004 0000000000000038 0000000000000000 ffff000008b1ae70
[  130.590269] 3a00: ffff8003f5483ab0 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  130.598129] 3a20: ffff8003cb1e8c38 ffff8003cb1e8838 ffff000008de2000 0000000000000001
[  130.605990] 3a40: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  130.613851] 3a60: 0000000000000038 0000000000000000 ffff000008d5cd18 0000000000000000
[  130.621712] 3a80: 0000000000000000 ffff8003f5486218 0000000000003d72 6e61707865272074
[  130.629572] 3aa0: 27313a322d726564 ffff8003fff62280 0000000000000000 ffff000008e21698
[  130.637432] 3ac0: 0000000000000002 0000000000003d71 0000000000000000 0000000000000000
[  130.645292] 3ae0: ffff0000081e3e54 0000000000497240
[  130.650189] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  130.655958] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  130.661552] [<ffff00000850d480>] device_del+0x40/0x210
[  130.666710] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  130.674048] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  130.680426] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  130.687589] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  130.693794] [<ffff000008554a4c>] sas_rphy_remove+0x4c/0x80
[  130.699301] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  130.704807] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  130.710749] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  130.716517] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  130.721937] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  130.726746] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  130.732101] sysfs group 'power' not found for kobject 'expander-2:1'
[  130.738487] ------------[ cut here ]------------
[  130.743123] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  130.751418] Modules linked in:
[  130.754492] 
[  130.755987] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  130.766028] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  130.775807] Workqueue: scsi_wq_2 sas_destruct_devices
[  130.780887] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  130.786831] PC is at sysfs_remove_group+0x8c/0x94
[  130.791552] LR is at sysfs_remove_group+0x8c/0x94
[  130.796274] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[  130.803698] sp : ffff8003f5483b90
[  130.807024] x29: ffff8003f5483b90 [  130.810262] x28: ffff000008d45000 
[  130.813676] 
[  130.815170] x27: 0000000000000000 [  130.818409] x26: 0000000000000000 
[  130.821822] 
[  130.823316] x25: 0000000000000001 [  130.826554] x24: 0000000000000001 
[  130.829968] 
[  130.831461] x23: ffff000008de2000 [  130.834699] x22: ffff8003cb1e8838 
[  130.838113] 
[  130.839606] x21: ffff8003cb1e9038 [  130.842844] x20: ffff000008de32e0 
[  130.846257] 
[  130.847751] x19: 0000000000000000 [  130.850988] x18: 0000ffffcbcc6090 
[  130.854401] 
[  130.855895] x17: 0000000000497240 [  130.859133] x16: ffff0000081e3e54 
[  130.862546] 
[  130.864040] x15: 0000000000000000 [  130.867279] x14: 0000000000000000 
[  130.870692] 
[  130.872187] x13: 0000000000003dc7 [  130.875425] x12: 0000000000000002 
[  130.878838] 
[  130.880333] x11: ffff000008e21698 [  130.883571] x10: 0000000000000000 
[  130.886985] 
[  130.888479] x9 : ffff8003fff62280 [  130.891717] x8 : 2d7265646e617078 
[  130.895131] 
[  130.896625] x7 : 6527207463656a62 [  130.899863] x6 : 0000000000003dc8 
[  130.903277] 
[  130.904771] x5 : ffff8003f5486218 [  130.908008] x4 : 0000000000000000 
[  130.911422] 
[  130.912917] x3 : 0000000000000000 [  130.916155] x2 : ffff000008d5cd18 
[  130.919569] 
[  130.921064] x1 : 0000000000000000 [  130.924302] x0 : 0000000000000038 
[  130.927715] 
[  130.929210] 
[  130.930704] ---[ end trace d18a42ce2a4e2258 ]---
[  130.935337] Call trace:
[  130.937791] Exception stack(0xffff8003f54839c0 to 0xffff8003f5483af0)
[  130.944256] 39c0: 0000000000000000 0001000000000000 ffff8003f5483b90 ffff000008252a70
[  130.952117] 39e0: 0000000000000004 0000000000000038 0000000000000000 ffff000008b1ae70
[  130.959978] 3a00: ffff8003f5483ab0 ffff0000080fc970 0000000000000000 ffff000008de32e0
[  130.967839] 3a20: ffff8003cb1e9038 ffff8003cb1e8838 ffff000008de2000 0000000000000001
[  130.975700] 3a40: 0000000000000001 0000000000000000 0000000000000000 ffff000008d45000
[  130.983560] 3a60: 0000000000000038 0000000000000000 ffff000008d5cd18 0000000000000000
[  130.991421] 3a80: 0000000000000000 ffff8003f5486218 0000000000003dc8 6527207463656a62
[  130.999282] 3aa0: 2d7265646e617078 ffff8003fff62280 0000000000000000 ffff000008e21698
[  131.007143] 3ac0: 0000000000000002 0000000000003dc7 0000000000000000 0000000000000000
[  131.015004] 3ae0: ffff0000081e3e54 0000000000497240
[  131.019901] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  131.025670] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  131.031265] [<ffff00000850d480>] device_del+0x40/0x210
[  131.036422] [<ffff000008515b44>] attribute_container_class_device_del+0x1c/0x28
[  131.043759] [<ffff000008515d1c>] transport_remove_classdev+0x54/0x68
[  131.050138] [<ffff0000085156f8>] attribute_container_device_trigger+0xd8/0xdc
[  131.057302] [<ffff000008515c80>] transport_remove_device+0x14/0x1c
[  131.063506] [<ffff000008554a4c>] sas_rphy_remove+0x4c/0x80
[  131.069012] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  131.074517] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  131.080460] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  131.086229] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  131.091648] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  131.096458] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  131.101811] sysfs group 'power' not found for kobject 'expander-2:1'
[  131.108197] ------------[ cut here ]------------
[  131.112833] WARNING: CPU: 19 PID: 239 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
[  131.121128] Modules linked in:
[  131.124203] 
[  131.125698] CPU: 19 PID: 239 Comm: kworker/u64:3 Tainted: G        W       4.9.0-rc1-00004-gf079a92-dirty #833
[  131.135738] Hardware name: Huawei Technologies Co., Ltd. Hi1610 EVBa/CH02TEVBA, BIOS 10.01.01T07 01/01/1900
[  131.145517] Workqueue: scsi_wq_2 sas_destruct_devices
[  131.150598] task: ffff8003f5a90c80 task.stack: ffff8003f5480000
[  131.156541] PC is at sysfs_remove_group+0x8c/0x94
[  131.161264] LR is at sysfs_remove_group+0x8c/0x94
[  131.165985] pc : [<ffff000008252a70>] lr : [<ffff000008252a70>] pstate: 60000145
[  131.173409] sp : ffff8003f5483c40
[  131.176734] x29: ffff8003f5483c40 [  131.179972] x28: ffff000008d45000 
[  131.183385] 
[  131.184879] x27: 0000000000000000 [  131.188117] x26: 0000000000000000 
[  131.191531] 
[  131.193024] x25: 0000000000000001 [  131.196263] x24: 0000000000000001 
[  131.199675] 
[  131.201169] x23: 0000000000000000 [  131.204407] x22: ffff8003cb1e8000 
[  131.207821] 
[  131.209315] x21: ffff8003cb1e8848 [  131.212553] x20: ffff000008de32e0 
[  131.215966] 
[  131.217460] x19: 0000000000000000 [  131.220699] x18: 0000ffffcbcc6090 
[  131.224112] 
[  131.225606] x17: 0000000000497240 [  131.228843] x16: ffff0000081e3e54 
[  131.232257] 
[  131.233751] x15: 0000000000000000 [  131.236988] x14: 0000000000000000 
[  131.240402] 
[  131.241896] x13: 0000000000003e1d [  131.245134] x12: 0000000000000002 
[  131.248547] 
[  131.250041] x11: ffff000008e21698 [  131.253279] x10: 0000000000000000 
[  131.256693] 
[  131.258187] x9 : ffff8003fff62280 [  131.261424] x8 : 6e61707865272074 
[  131.264838] 
[  131.266332] x7 : 63656a626f6b2072 [  131.269569] x6 : 0000000000003e1e 
[  131.272982] 
[  131.274477] x5 : ffff8003f5486218 [  131.277715] x4 : 0000000000000000 
[  131.281128] 
[  131.282622] x3 : 0000000000000000 [  131.285861] x2 : ffff000008d5cd18 
[  131.289274] 
[  131.290768] x1 : 0000000000000000 [  131.294006] x0 : 0000000000000038 
[  131.297419] 
[  131.298913] 
[  131.300407] ---[ end trace d18a42ce2a4e2259 ]---
[  131.305041] Call trace:
[  131.307495] Exception stack(0xffff8003f5483a70 to 0xffff8003f5483ba0)
[  131.313960] 3a60:                                   0000000000000000 0001000000000000
[  131.321820] 3a80: ffff8003f5483c40 ffff000008252a70 0000000000000004 0000000000000038
[  131.329681] 3aa0: 0000000000000000 ffff000008b1ae70 ffff8003f5483b60 ffff0000080fc970
[  131.337543] 3ac0: 0000000000000000 ffff000008de32e0 ffff8003cb1e8848 ffff8003cb1e8000
[  131.345403] 3ae0: 0000000000000000 0000000000000001 0000000000000001 0000000000000000
[  131.353264] 3b00: 0000000000000000 ffff000008d45000 0000000000000038 0000000000000000
[  131.361125] 3b20: ffff000008d5cd18 0000000000000000 0000000000000000 ffff8003f5486218
[  131.368985] 3b40: 0000000000003e1e 63656a626f6b2072 6e61707865272074 ffff8003fff62280
[  131.376845] 3b60: 0000000000000000 ffff000008e21698 0000000000000002 0000000000003e1d
[  131.384706] 3b80: 0000000000000000 0000000000000000 ffff0000081e3e54 0000000000497240
[  131.392567] [<ffff000008252a70>] sysfs_remove_group+0x8c/0x94
[  131.398337] [<ffff000008519b0c>] dpm_sysfs_remove+0x58/0x68
[  131.403930] [<ffff00000850d480>] device_del+0x40/0x210
[  131.409089] [<ffff000008554a54>] sas_rphy_remove+0x54/0x80
[  131.414596] [<ffff000008554a94>] sas_rphy_delete+0x14/0x28
[  131.420102] [<ffff000008558a14>] sas_destruct_devices+0x64/0x98
[  131.426045] [<ffff0000080d2638>] process_one_work+0x130/0x2dc
[  131.431814] [<ffff0000080d283c>] worker_thread+0x58/0x438
[  131.437232] [<ffff0000080d8468>] kthread+0xd4/0xe8
[  131.442040] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  131.447390] hisi_sas_v2_hw a3000000.sas: found dev[0:2] is gone

root@(none)$ 


--------------2696711AF76EE2B4179B28F8
Content-Type: text/plain; charset="UTF-8"; name="after.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="after.log"

[    8.409750] Freeing unused kernel memory: 1024K (ffff800000c40000 - ffff800000d40000)
root@(none)$ [   25.012139] hisi_sas_v2_hw a3000000.sas: phyup: phy0 link_rate=11
[   25.018265] hisi_sas_v2_hw a3000000.sas: phyup: phy2 link_rate=11
[   25.024388] hisi_sas_v2_hw a3000000.sas: phyup: phy1 link_rate=11
[   25.030509] hisi_sas_v2_hw a3000000.sas: phyup: phy3 link_rate=11
[   25.066781] scsi 2:0:0:0: Enclosure         ADAPTEC  AEC-82885T       B015 PQ: 0 ANSI: 6
[   27.603764] random: fast init done
[   27.607560] hisi_sas_v2_hw a3000000.sas: found dev[1:1] is gone
[   27.627319] hisi_sas_v2_hw a3000000.sas: found dev[0:2] is gone
[   29.650670] hisi_sas_v2_hw a3000000.sas: phyup: phy2 link_rate=11
[   29.656793] hisi_sas_v2_hw a3000000.sas: phyup: phy0 link_rate=11
[   29.662915] hisi_sas_v2_hw a3000000.sas: phyup: phy1 link_rate=11
[   29.669036] hisi_sas_v2_hw a3000000.sas: phyup: phy3 link_rate=11
[   29.685864] scsi 2:0:1:0: Enclosure         ADAPTEC  AEC-82885T       B015 PQ: 0 ANSI: 6

root@(none)$ 


--------------2696711AF76EE2B4179B28F8--
