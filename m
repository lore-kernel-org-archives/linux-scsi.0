From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Tue, 8 Nov 2016 08:52:15 -0800
Message-ID: <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
 <1478618887.2824.2.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0071.outbound.protection.outlook.com ([104.47.40.71]:33504
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753940AbcKHQwa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 11:52:30 -0500
In-Reply-To: <1478618887.2824.2.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Eric Biederman <ebiederm@xmission.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/08/2016 07:28 AM, James Bottomley wrote:
> On Mon, 2016-11-07 at 16:32 -0800, Bart Van Assche wrote:
>> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
>> index cf4c636..44ec536 100644
>> --- a/fs/kernfs/dir.c
>> +++ b/fs/kernfs/dir.c
>> @@ -1410,7 +1410,7 @@ int kernfs_remove_by_name_ns(struct kernfs_node
>> *parent, const char *name,
>>  	mutex_lock(&kernfs_mutex);
>>
>>  	kn = kernfs_find_ns(parent, name, ns);
>> -	if (kn)
>> +	if (kn && !(kn->flags & KERNFS_SUICIDED))
>
> Actually, wrong flag, you need KERNFS_SUICIDAL.  The reason is that
> kernfs_mutex is actually dropped half way through __kernfs_remove, so
> KERNFS_SUICIDED is not set atomically with this mutex.

Hello James,

Sorry but what you wrote is not correct. __kernfs_remove() calls 
kernfs_drain(). That last function not only drops but also reacquires 
kernfs_mutex. So both KERNFS_SUICIDAL and KERNFS_SUICIDED are set while 
holding kernfs_mutex.

Bart.

