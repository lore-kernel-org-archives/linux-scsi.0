From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/2] zfcp: zfcp: add statistics and other zfcp
	relatedinformation to sysfs
Date: Sat, 8 Sep 2007 13:54:05 +0200
Message-ID: <20070908115405.GB8077@osiris.boeblingen.de.ibm.com>
References: <200709070915.33439.swen@vnet.ibm.com> <46E165B5.9060606@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62334 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbXIHLyH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Sep 2007 07:54:07 -0400
Content-Disposition: inline
In-Reply-To: <46E165B5.9060606@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

>> +	dev_set_drvdata(&adapter->stat_services, adapter);
>> +
>> +	if (device_register(&adapter->stat_services))
>> +		goto services_failed;
>> +
>> +	if (zfcp_sysfs_statistic_services_create_files(&adapter->stat_services))
>> +	{
>> +		device_unregister(&adapter->stat_services);

Sorry, but this change won't solve the lifetime problems of objects we have
in here.

device_unregister(&adapter->stat_services) does not mean you can free the
memory used for the struct adapter immediatly after the function returns.
What might happen here:

device_unregister(&adapter->stat_services);
...
kfree(adapter);
...
[somewhere else somebody else feels the need to allocate memory]
kmalloc(whatever size);
[this kmalloc could return the memory you freed above, and the newly
 allocated memory gets written to and therefore invalidated]
...
[now finally the driver core feels like it may call the release function of
 your struct device, but... the struct device got overwritten already]
-> jump to random spot.

So we have a use-after-free bug here with potential of memory corruption
and random jumps.

This is already broken in the current code without this patch and the
problem was introduced with the "generic_services" device. Just have a
look at zfcp_adapter_dequeue(). Same problem as described above.
Needs fixing :)

Having a device release function that does nothing (zfcp_dummy_release)
is a problem. How can the rest of the code know if the release function
was already called and therefore if somebody still needs the struct
device if the release function does nothing?

Adding more stuff to the zfcp sysfs tree doesn't look like the right way
to go for me. It just adds more complexity because of things that you
don't even should care about. IMHO you should go the way that Matthew
Wilcox proposed and add your new attributes somewhere in the scsi
midlayer or transport class code.

>> @@ -1264,6 +1285,7 @@ zfcp_port_enqueue(struct zfcp_adapter *a
>>  	if (zfcp_sysfs_port_create_files(&port->sysfs_device, status)) {
>>  		device_unregister(&port->sysfs_device);
>> +		kfree(port);
>
> Scratching my head... another unrelated change (looks like a fix for a real 
> memory leak)?

Adding a kfree() in here is wrong. The struct port gets freed when the
release function of the sysfs_device gets called. So you would end up freeing
the struct port twice and one of them is too early (see above).

Btw. this kfree() line wasn't part of your first patch. It would be helpful
if you outline what and why you changed something, even if that would be just
to reply on my first review. That way whoever commented on your patch would
know if you agree or why you don't.
E.g. you still have the same four nearly identical functions. So it looks to
me like you disagree with what I suggested, but why?
