From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and implementation.
Date: Fri, 17 Apr 2009 14:51:08 +0400
Message-ID: <49E85F1C.7040106@vlnb.net>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZDQKvA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 06:51:00 -0400
In-Reply-To: <49E77795.7080204@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Cc: scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Daniel Debonzi, on 04/16/2009 10:23 PM wrote:
> Vladislav Bolkhovitin wrote:
>> Hi All,
>>
>> Below is proposal for the SCST sysfs layout, which will replace existing procfs-based infrastructure. Any comments, questions and suggestions are welcome!
>>
>> I. SCST sysfs layout.
>>
>> Root would be /sys/scsi_tgt.
>>
>> In the root there would be the following files and subdirectories:
>>
>>  - targets - subdirectory listing names of all registered target drivers.
>>
>>  - devices - subdirectory listing all registered backend devices.
>>
>>  - sgv - subdirectory listing all existing SGV pools.
>>
>>  - drivers - subdirectory listing all loaded target and backend drivers (dev handlers).
>>
>>  - threads - RW file listing number of global SCST threads. Writing to that file would allow to change that value.
>>
>>  - trace_level - RW file listing SCST core logging level. Writing to that file would allow to change that. Example content: 
>> "out_of_mem | minor | pid | line | function | special | mgmt | mgmt_minor | mgmt_dbg | retry". See current procfs implementation of this file for more info.
>>
>>  - version - RO file listing version of SCST core and enabled compile time features. Example content: "1.0.2, EXTRACHECKS, DEBUG"                                                                                                                          
> 
> Based on all I read this last days, I believe we are not allowed to 
> include the directory scsi_tgt on /sys root. I think it has to be in a 
> existent directory reserved for this sort of application. I just didn't 
> figured out which one it would be.

/sys/class? It already has scsi_device, scsi_disk, scsi_generic and 
scsi_host.

>> III. Implementation considerations
>>
>> 1. Top level subdirectories and files should be created by init_scst().
>>
>> 2. targets/target_driver_name drivers/target_driver_name and should be created by scst_register_target_template() and removed by scst_unregister_target_template().
>>
>> 3. targets/target_driver_name/target with sessions, luns and ini_groups subdirectories should be created by scst_register() and removed by scst_unregister().
>>
>> 4. targets/target_driver_name/target/sessions/session and below should be created by scst_init_session() and removed by scst_free_session().
>>
>> 5. Pass-through devices should be added to devices/ by scst_register_device() and removed by scst_unregister_device(). Initially they should have "handler" link pointed to "none".
>>
>> 6. Virtual devices should be added to devices/ by scst_register_virtual_device() and removed by scst_unregister_virtual_device().
>>
>> 7. drivers/dev_handler_name should be added by scst_register_dev_driver() or scst_register_virtual_dev_driver() and removed by scst_unregister_dev_driver() or scst_unregister_virtual_dev_driver().
>>
>> 8. It isn't clear how to best combine standard and custom entries in targets/target_driver_name/target, devices/device, drivers/target_driver_name and drivers/dev_handler_name, I don't know sysfs interfaces sufficiently well. I can only suggest places, where it should be done:
>>
>>  - For targets/target_driver_name/target a target driver after scst_register() register call should call new function scst_get_target_root() and add there new entries. Before scst_unregister() call the target driver should remove them at first. Similarly it should be done for drivers/target_driver_name and drivers/dev_handler_name.
>>
>>  - For devices/device a dev handler should do it in attach() callback and remove in detach() callback. Similarly to scst_get_target_root(), the dev handler should get its sysfs root by calling scst_get_dev_root().
>>
>> Both should be made in some generic way to minimize duplicated code between target drivers and between dev handlers.
> 
> Also based on what I read, the way to have data structures reflected on 
> sysfs is using kobjecs. I feel that the expected approach to have it is 
> to include a kobject (or kset depending on the case) on the existent 
> structures which will be reflected on the sysfs. I notice that on the 
> actual implementation all the proc interface is implemented on 
> scst_proc.c and I don't know if it will be possible to keep having the 
> access interfaces on a separated source file. We could possible have the 
> callback functions on a separated file but I can't visualize it without 
> start to touch it more deeply. Probably you guys have a better view of 
> this implementation possibilities.

All the above sysfs layout reflects internal SCST objects:

1. targets/target_driver_name and drivers/target_driver_name -> struct 
scst_tgt_template

2. targets/target_driver_name/target -> struct scst_tgt

3. targets/target_driver_name/target/sessions/session -> struct scst_session

4. targets/target_driver_name/target/ini_groups/group -> struct 
scst_acg. (For targets/target_driver_name/target/luns each struct 
scst_tgt would have internal struct scst_acg.)

5. 
targets/target_driver_name/target/ini_groups/group/initiators/initiator 
-> struct scst_acn

6. targets/target_driver_name/target/ini_groups/group/luns/lun and 
targets/target_driver_name/target/luns/lun -> struct scst_acg_dev

7. devices/device -> struct scst_device

8. drivers/dev_handler_name -> struct scst_dev_type

9. sgv/pool -> struct sgv_pool

So, we should simply add kobjects in them. To manipulate with then 
already there is an API, used by procfs, and should be also used by 
sysfs. This API is completely out of scst_proc.c


LAYOUT UPDATE.

Looks like it would be better to move entries from 
drivers/target_driver_name to targets/target_driver_name to keep all the 
related entries in one place. Then to reflect new state rename drivers/ 
to back_drivers/.

Thanks,
Vlad

