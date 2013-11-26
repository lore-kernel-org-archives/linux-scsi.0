From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: qla2xxx: automatically rescan removed luns.
Date: Tue, 26 Nov 2013 16:06:57 +0000
Message-ID: <5294C721.4070802@mpstor.com>
References: <52936EB4.4090508@mpstor.com> <1385399823.3839.116.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.blacknight.com ([78.153.203.204]:45945 "EHLO
	relay1.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab3KZQG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2013 11:06:59 -0500
In-Reply-To: <1385399823.3839.116.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org

On 25/11/13 17:17, Ewan Milne wrote:
> On Mon, 2013-11-25 at 15:37 +0000, Benjamin ESTRABAUD wrote:
>> Hi,
>>
>> Using the qla2xxx driver from Linux 3.10.1 (release), if a LUN from the
>> target side (multiple drives exported over a LIO IBlock qla2xxx export)
>> is removed at the LIO level, the initiator side will not automatically
>> detect that this LUN was removed.
>>
>> All commands to this LUN will fail (sg_inq, read, writes) but the
>> qla2xxx will never kick the drive out.
>>
>> If another drive was to be exported on the target side using the same
>> lun as the previously removed drive, commands sent to the same block id
>> would now work again but be sent to the new LUN.
>>
>> I tried to echo "- - -" in the scsi_host sysfs "scan" file corresponding
>> to the FC port. This worked to detect new LUNs but not to "clear"
>> removed ones.
>>
>> I tried issuing a lip_reset on both sides, but no change.
>>
>> Looking through Google, I realized that, on RedHat, a /proc/scsi/qla2xxx
>> virtual FS exists which allows to send a "scsi-qlascan" command to the
>> driver that apparently can detect removed LUNs. Unfortunately I don't
>> have this FS visible on my Linux kernel, and I made sure /proc/scsi was
>> enabled.
>>
>> The only way I found was to "echo 1 > /sys/block/sdX/device/delete" to
>> the stale device (that corresponds to the removed LUN from the target
>> side), then replace the removed LUN on the target side before finally
>> issuing a "scan" command on the initiator side.
>>
>> Am I missing something here? Is there a way to rescan a Qlogic FC port
>> using the "qla2xxx" driver from the official, stock kernel?
>
Hi,

Thank you very much for your reply, this is much appreciated.

> The kernel does not contain support for removing devices automatically
> during a subsequent rescan.

I thought that it used to with older kernels, is that possible (was this 
a recent change of behaviour)? It does, however, remove devices which 
port or connection has gone offline (pulled SAS disk, FC target 
inaccessible because of a disconnected cable).

Looking into it, the 'echo "- - -" > /sys/class/scsi_host/hostX/scan' 
scan command does issue a request_lun command (at least in SAS, used a 
target on which I could trace incoming commands).

When ran and a new LUN is detected, Linux does the right thing and adds 
the device.

When ran and a LUN is gone, it does nothing, as you explained above.


   You have to delete them individually.
Noted.

> You can, however, update the properties detected when scanning a device
> (e.g. disk capacity) by scanning the individual device in sysfs.  For
> SCSI devices, there is a "rescan" capability, e.g.
>
> echo 1> /sys/devices/<pci device path>/host0/target0:0:0/0:0:0:0/rescan
>
I used that rescan feature that I didn't know about and it's *very* 
useful, thank you!!

> *Very* recent kernels contain a udev notification mechanism when a SCSI
> device reports a Unit Attention, so you can have udev rules like:
>
> ACTION=="change", SUBSYSTEM=="scsi", \
> ENV{SDEV_UA}=="INQUIRY_DATA_HAS_CHANGED", TEST=="rescan", \
> ATTR{rescan}="x"
>
> ACTION=="change", SUBSYSTEM=="scsi", \
> ENV{SDEV_UA}=="CAPACITY_DATA_HAS_CHANGED", TEST=="rescan", \
> ATTR{rescan}="x"
>
> ACTION=="change", SUBSYSTEM=="scsi", \
> ENV{SDEV_UA}=="THIN_PROVISIONING_SOFT_THRESHOLD_REACHED", \
> TEST=="rescan", ATTR{rescan}="x"
>
> ACTION=="change", SUBSYSTEM=="scsi", \
> ENV{SDEV_UA}=="MODE_PARAMETERS_CHANGED", TEST=="rescan", \
> ATTR{rescan}="x"
>
> ACTION=="change", SUBSYSTEM=="scsi", \
> ENV{SDEV_UA}=="REPORTED_LUNS_DATA_HAS_CHANGED", \
> RUN+="<script to scan devices> $env{DEVPATH}"
>
> ...
>
That sounded promising, unfortunately the version we use (3.10.y branch) 
doesn't have this yet.

> A script to scan devices can use the devpath of the SCSI device
> reporting the Unit Attention to perform the desired action.  If you
> just want to scan the target port, something like this might work,
> although it is a little clumsy...
>
Thank you very much for that script, that gives me a pretty good idea of 
what needs to be done here.

> #!/bin/sh -e
>
> HOST_PATH1=`echo $1 | awk '{print substr($1,0,index($1,"/target")-1)}'`
> HOST_PATH2="scsi_host/host"`echo $1 | awk
> '{split(substr($1,index($1,"target")),a,"/"); split(a[2],b,":"); print
> b[1]}'`"/scan"
>
> SCAN_STRING=`echo $1 | awk '{split(substr($1,index($1,"target")),a,"/");
> split(a[2],b,":"); print b[2],b[3],"-"}'`
>
> echo $SCAN_STRING > "/sys/"$HOST_PATH1"/"$HOST_PATH2
>
> Or, "rescan-scsi-bus.sh" from (I think) sg3_utils might do what you
> want.  Beware of running shell scripts from udev rules, however, as
> that doesn't scale well in large configurations.
>
"rescan-scsi-bus.sh" did detect new LUN, but apparently not removed 
ones. However I need to test it on a system with a compatible bash shell 
as I wasn't able to run the script without errors.

Thanks a lot again for all your help.

> -Ewan
>
>
Regards,
Ben.
>>
>> Thank you very much in advance for your help!
>>
>> Regards,
>>
>> Ben - MPSTOR
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

