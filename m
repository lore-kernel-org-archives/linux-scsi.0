From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 10/17] scsi_dh_alua: Use separate alua_port_group structure
Date: Thu, 7 May 2015 15:36:08 +0200
Message-ID: <554B6A48.1090405@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-11-git-send-email-hare@suse.de>
 <554B5BD8.2090605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0057.outbound.protection.outlook.com ([207.46.100.57]:37232
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751311AbbEGNgO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 09:36:14 -0400
In-Reply-To: <554B5BD8.2090605@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/07/15 14:34, Bart Van Assche wrote:
> On 05/04/15 14:42, Hannes Reinecke wrote:
>> +    spin_lock(&port_group_lock);
>> +    pg = kzalloc(sizeof(struct alua_port_group), GFP_ATOMIC);
>> +    if (!pg) {
>> +        sdev_printk(KERN_WARNING, sdev,
>> +                "%s: kzalloc port group failed\n",
>> +                ALUA_DH_NAME);
>> +        /* Temporary failure, bypass */
>> +        spin_unlock(&port_group_lock);
>> +        return SCSI_DH_DEV_TEMP_BUSY;
>> +    }
>> +    pg->group_id = group_id;
>> +    pg->buff = pg->inq;
>> +    pg->bufflen = ALUA_INQUIRY_SIZE;
>> +    pg->tpgs = h->tpgs;
>> +    pg->state = TPGS_STATE_OPTIMIZED;
>> +    kref_init(&pg->kref);
>> +    list_add(&pg->node, &port_group_list);
>> +    h->pg = pg;
>> +    spin_unlock(&port_group_lock);
>
> Sorry but it's not clear to me why the kzalloc() statement happens under
> port_group_lock. Please consider to perform only the list_add()
> statement under port_group_lock, to perform all other assignments
> without holding that lock and to change GFP_ATOMIC into GFP_KERNEL.

(replying to my own e-mail)

Hello Hannes,

Is it correct that port_group_list is only accessed from thread context 
? If so, has it been considered to change port_group_lock into a mutex 
instead ?

Thanks,

Bart.
