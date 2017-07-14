From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 4/7] libsas: add sas event wait-complete support
Date: Fri, 14 Jul 2017 09:42:43 +0100
Message-ID: <230b428c-c5b2-e14c-dbbd-2ebf3f295fe5@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-5-git-send-email-wangyijing@huawei.com>
 <b2939814-ebbe-866a-b067-e94d7e814647@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9771 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdGNInT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2017 04:43:19 -0400
In-Reply-To: <b2939814-ebbe-866a-b067-e94d7e814647@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>

On 14/07/2017 07:51, Hannes Reinecke wrote:
>>  #ifdef CONFIG_SCSI_SAS_HOST_SMP
>> >  extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>> >  				struct request *rsp);
>> > diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
>> > index 9326628..d589adb 100644
>> > --- a/drivers/scsi/libsas/sas_port.c
>> > +++ b/drivers/scsi/libsas/sas_port.c
>> > @@ -191,7 +191,9 @@ static void sas_form_port(struct asd_sas_phy *phy)
>> >  	if (si->dft->lldd_port_formed)
>> >  		si->dft->lldd_port_formed(phy);
>> >
>> > +	sas_port_wait_init(port);
>> >  	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
>> > +	sas_port_wait_completion(port);
>> >  }
>> >
>> >  /**
>> > @@ -218,7 +220,9 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
>> >  		dev->pathways--;
>> >

Hannes thanks for checking.

>> >  	if (port->num_phys == 1) {
>> > +		sas_port_wait_init(port);
>> >  		sas_unregister_domain_devices(port, gone);
>> > +		sas_port_wait_completion(port);
>> >  		sas_port_delete(port->port);
>> >  		port->port = NULL;
>> >  	} else {
> I would rather use the standard on-stack completion here;
> like this:
>
> 	DECLARE_COMPLETION_ONSTACK(complete);
> 	port->completion = &complete;
> 	sas_unregister_domain_devices(port, gone);
> 	wait_for_completion(&complete);
> 	sas_port_delete(port->port);
>
> which would simplify the above helpers to:
>
> static inline void sas_port_put(struct asd_sas_port *port)
> {
> 	if (port->completion)
> 		kref_put(&port->ref, sas_complete_event);
> }
>
> and you could do away with the 'is_sync' helper.
>

I did wonder if we could avoid using completion altogether and just 
flush the respective queue which the work item is being processed in. 
But, due to the intricacy of SCSI/ATA EH, and since we still use shost 
workqueue for the libsas hotplug processing, maybe it best to keep it 
straightforward and keep using completions.

Anyway, The idea to declare the completion on the stack seems sound. 
And, for patch 6/7, I don't think the is_sync element is even required 
without any change to declaration of completion in struct 
sas_discovery_event.

John

> Cheers,
>
> Hannes
> --
