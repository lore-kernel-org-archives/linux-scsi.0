From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 1/2] scsi: sas: flush destruct workqueue on device
 unregister
Date: Wed, 29 Mar 2017 12:53:28 +0100
Message-ID: <343ddf8b-70e0-32f8-6ab8-31479729f827@huawei.com>
References: <cover.1490775958.git.jthumshirn@suse.de>
 <9580eaf323f5da17dcace9e32b22a1df4099961d.1490775958.git.jthumshirn@suse.de>
 <02778435-6c67-0ac9-2faa-03ebb7934477@huawei.com>
 <20170329112922.GB9183@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170329112922.GB9183@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 29/03/2017 12:29, Johannes Thumshirn wrote:
> On Wed, Mar 29, 2017 at 12:15:44PM +0100, John Garry wrote:
>> On 29/03/2017 10:41, Johannes Thumshirn wrote:
>>> In the advent of an SAS device unregister we have to wait for all destruct
>>> works to be done to not accidently delay deletion of a SAS rphy or it's
>>> children to the point when we're removing the SCSI or SAS hosts.
>>>
>>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>>> ---
>>> drivers/scsi/libsas/sas_discover.c | 4 ++++
>>> 1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
>>> index 60de662..75b18f1 100644
>>> --- a/drivers/scsi/libsas/sas_discover.c
>>> +++ b/drivers/scsi/libsas/sas_discover.c
>>> @@ -382,9 +382,13 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
>>> 	}
>>>
>>> 	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
>>> +		struct sas_discovery *disc = &dev->port->disc;
>>> +		struct sas_work *sw = &disc->disc_work[DISCE_DESTRUCT].work;
>>> +
>>> 		sas_rphy_unlink(dev->rphy);
>>> 		list_move_tail(&dev->disco_list_node, &port->destroy_list);
>>> 		sas_discover_event(dev->port, DISCE_DESTRUCT);
>>> +		flush_work(&sw->work);
>>
>> I quickly tested plugging out the expander and we never get past this call
>> to flush - a hang results:
>
> Can you activat lockdep so we can see which lock it is that we're blocking on?
>

I have it on:
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y

> It's most likely in sas_unregister_common_dev() but this function takes two spin
> locks, port->dev_list_lock and ha->lock.
>

We can see from the callstack I provided that we're working in workqueue 
scsi_wq_0 and trying to flush that same queue.

Much appreciated,
John

> Thanks a lot,
>        Johannes
>
