From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: mkdir: cannot create directory `/sys/kernel/config/target/iscsi':
 Invalid argument
Date: Fri, 16 Sep 2011 13:05:03 -0400
Message-ID: <4E7381BF.7020802@interlog.com>
References: <loom.20110719T170144-482@post.gmane.org> <4E7374B1.8040502@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40662 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1IPRFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2011 13:05:09 -0400
In-Reply-To: <4E7374B1.8040502@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Well I can answer my own question.
configfs doesn't seem to be mounted at /sys/kernel/config
and even when it is, superuser cannot create a directory
there. So mount configfs somewhere else:

mount -t configfs none /tmp/config

Then in reference to this page:
   http://linux-iscsi.org/wiki/Target/configFS

change this line:
   export TARGET=/sys/kernel/config/target/core/
to
   export TARGET=/tmp/config/target/core/
then continue.

BTW The target infrastructure creates this noise in the log:
   "Unable to load target_core_stgt"
There is no such module that I can see.


And I still can't do what I want: to use the target
infrastructure to make a disk image in a file look
like a SCSI device on the local machine. No iSCSI,
SRP, FCxxx, SAS, UAS nor SOP ... just _SCSI_ !!

Doug Gilbert



On 11-09-16 12:09 PM, Douglas Gilbert wrote:
> ping ....
>
> Could some target folks please answer the following question?
>
> I get the same show stopper on lk 3.0.4 :
>
> root@test:/sys/kernel/config# mkdir target
> mkdir: cannot create directory `target': No such file or directory
>
> Doug Gilbert
>
>
> On 11-07-19 11:17 AM, Raju wrote:
>> Hi,
>> I can't able create an iscsi target because of some problem in configfs:
>>
>>
>> Below are the steps I followed in Debian Lenny(upgraded kernel to 2.6.39.2):
>>
>> #!/bin/sh
>> # BEGIN CONFIG FOR CONFIGFS USAGE
>> modprobe configfs
>> mount -t configfs none /sys/kernel/config
>> # END CONFIG FOR CONFIGFS USAGE
>>
>> # BEGIN CONFIGFS CODE FOR GENERIC TARGET ENGINE
>> modprobe target_core_mod
>> export CONFIGFS=/sys/kernel/config/
>> export TARGET=/sys/kernel/config/target/core/
>> export FABRIC=/sys/kernel/config/target/iscsi/
>> # END CONFIGFS CODE FOR GENERIC TARGET ENGINE
>>
>> # START RAMDISK SUBSYSTEM PLUGIN OBJECTS
>> mkdir -p $TARGET/rd_mcp_0/ramdisk
>> echo rd_pages=32768> $TARGET/rd_mcp_0/ramdisk/control
>> echo 1> $TARGET/rd_mcp_0/ramdisk/enable
>> # END RAMDISK SUBSYSTEM PLUGIN OBJECTS
>>
>> # BEGIN CONFIGFS CODE FOR LINUX ISCSI TARGET (LIO-TARGET)
>> DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"
>> # Define the first iSCSI Network Portal
>> PORTAL1="10.0.0.1:3260"
>> # The first mkdir(2) to $FABRIC will load iscsi_target_mod
>> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/$PORTAL1"
>> mkdir: cannot create directory `/sys/kernel/config/target/iscsi':
>> Invalid argument
>>
>>
>> AND KERNEL LOG:
>>
>> [10443.799266] CORE_HBA[0] - TCM Ramdisk HBA Driver v4.0 on Generic
>> Target CoreStack v4.0.0-rc7-ml
>> [10443.799272] CORE_HBA[0] - Attached Ramdisk HBA: 0 to Generic Target
>> Core TCQDepth: 256 MaxSectors: 1024
>> [10443.799278] CORE_HBA[1] - Attached HBA to Generic Target Core
>> [10443.799329] Target_Core_ConfigFS: Allocated struct se_subsystem_dev:
>> f4ee1000se_dev_su_ptr: f4e3e2c0
>> [10443.800370] Missing rd_pages= parameter
>> [10443.805761] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
>> [10443.838505] target_core_get_fabric() failed for iscsi
>> [10443.841826] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
>> [10443.875313] target_core_get_fabric() failed for iscsi
>> [10443.878496] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
>> [10443.910039] target_core_get_fabric() failed for iscsi
>> [10443.921684] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
>> [10443.951926] target_core_get_fabric() failed for iscsi
>>
>>
>>
>> Please suggest any idea,
>>
>>
>> Thanks,
>> Raju.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

