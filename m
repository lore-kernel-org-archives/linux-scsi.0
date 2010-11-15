From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 23:36:04 +0300
Message-ID: <4CE199B4.7080800@vlnb.net>
References: <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101113235938.GA1827@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greg KH, on 11/14/2010 02:59 AM wrote:
> On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
>> So, I decided to reimplement it to be completely synchronous. SYSFS
>> authors did really great job and thanks to the excellent internal SYSFS
>> design and implementation it is absolutely safe. See:
>>
>> [root@tgt ~]# modprobe scst
>> [root@tgt ~]# cd /sys/kernel/scst_tgt/
> 
> Sorry, but no, you can't put this in /sys/kernel/ without getting the
> approval of the sysfs maintainer.

Hmm, I thought we had the approvement in the "[RFC]: SCST sysfs layout"
thread (http://osdir.com/ml/linux-kernel/2009-04/msg07822.html). Particularly,
in the message http://osdir.com/ml/linux-kernel/2009-04/msg08557.html.

But, looks like it isn't so and I should have asked you, the SYSFS maintainer.
Sorry.

Could you consider it, please?

You can find detail description why SCST needs such layout below.
 
> I really don't understand why you are using kobjects in the first place,
> why isn't this in the main device tree in the kernel, using 'struct
> device'?

I'll try to explain. It's a bit long story involving deep SCSI target specific
knowledge, but I'll try to make it as simple and short as possible.

SCST is a SCSI _target_ side subsystem, i.e. it is a _server_ side sybsystem.
It exports SCSI-speaking devices, not using them. You can consider it as an NFS
server. What usually meant by "SCSI subsystem" is SCSI _initiator_ subsystem,
i.e. client side subsystem (like NFS client), which is using SCSI-speaking
devices by sending SCSI commands to them.

Any SCSI-speaking protocol can be used with SCST: parallel (wide) SCSI, Fibre Channel,
iSCSI, SAS, SRP, iSER, etc. (Also, non-SCSI speaking protocols, like AoE and
NBD can be used, but that's another story.)

Strictly as required by SCSI Architecture Model (SAM [1]), SCST doesn't deal with
hardware devices. The closest to hardware things SCST deals with are SCSI target
ports and SCSI target devices.

SCSI target port is an abstract concept reflecting path through which SCST
exports devices. You can consider it as an IP network (network, not interface!)
through which an NFS server's exports can be used. For instance, for iSCSI
such ports are iSCSI targets. For Fibre Channel - virtual or hardware Fibre
Channel ports.

SCSI target device is an abstract concept, which provides a way to reach real storage
(files, block devices, etc.) and contains internal state information (reservations,
configuration parameters, etc.). You can consider it as an NFS export. Please don't
confuse it with SCSI _initiator_ device, which is a place to generate SCSI commands
and send them via one or more SCSI initiator ports (MPIO). On the target side
they will be accepted via one or more SCSI target ports, then sent by the
corresponding SCSI target device to back storage device (file, block device, etc.).

So, there is no place in SCST to make Linux devices and use struct device. It's up to
SCST target drivers to create Linux devices for target hardware, if they need it,
which is rare. For instance, scst_local driver make SCST's SCSI target devices be
available as SCSI initiator, i.e. regular, devices by creating all the necessary
devices and SYSFS infrastructure for them:

Load SCST modules:

[root@tgt ~]# modprobe scst
[root@tgt ~]# modprobe scst_vdisk

Create SCSI target device "blockio" with /dev/sda5 as backstorage:

[root@tgt ~]# echo "add_device blockio filename=/dev/sda5" >/sys/kernel/scst_tgt/handlers/vdisk_blockio/mgmt

Check current SCSI devices:

[root@tgt ~]# lsscsi
[1:0:0:0]    disk    SEAGATE  ST373455LW       0003  /dev/sda
[2:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb

Check that host3 doesn't exist:

[root@tgt ~]# cd /sys/class/scsi_host/host3
bash: cd: /sys/class/scsi_host/host3: No such file or directory

Load scst_local target driver:

[root@tgt ~]# modprobe scst_local

Create SCSI target port "scst_local_tgt" with SCSI host "scst_local_host" (host3):

[root@tgt ~]# echo "add_target scst_local_tgt session_name=scst_local_host" >/sys/kernel/scst_tgt/targets/scst_local/mgmt

Add "blockio" as LUN 0:

[root@tgt ~]# echo "add blockio 0" >/sys/kernel/scst_tgt/targets/scst_local/scst_local_tgt/luns/mgmt

See new local SCSI device 3:0:0:0 (/dev/sdc):

[root@tgt ~]# lsscsi
[1:0:0:0]    disk    SEAGATE  ST373455LW       0003  /dev/sda
[2:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb
[3:0:0:0]    disk    SCST_BIO blockio           210  /dev/sdc

[root@tgt ~]# cd /sys/class/scsi_host/host3
[root@tgt host3]# ll
total 0
-rw-r--r-- 1 root root 4096 Nov 16 00:22 active_mode
-r--r--r-- 1 root root 4096 Nov 16 00:22 can_queue
-r--r--r-- 1 root root 4096 Nov 16 00:22 cmd_per_lun
lrwxrwxrwx 1 root root    0 Nov 16 00:07 device -> ../../../devices/scst_local/scst_local_host/host3
-r--r--r-- 1 root root 4096 Nov 16 00:22 host_busy
drwxr-xr-x 2 root root    0 Nov 16 00:22 power
-r--r--r-- 1 root root 4096 Nov 16 00:22 proc_name
-r--r--r-- 1 root root 4096 Nov 16 00:22 prot_capabilities
-r--r--r-- 1 root root 4096 Nov 16 00:22 prot_guard_type
--w------- 1 root root 4096 Nov 16 00:22 scan
-r--r--r-- 1 root root 4096 Nov 16 00:22 sg_tablesize
-rw-r--r-- 1 root root 4096 Nov 16 00:22 state
lrwxrwxrwx 1 root root    0 Nov 16 00:22 subsystem -> ../../scsi_host
-rw-r--r-- 1 root root 4096 Nov 16 00:22 supported_mode
-rw-r--r-- 1 root root 4096 Nov 16 00:22 uevent
-r--r--r-- 1 root root 4096 Nov 16 00:22 unchecked_isa_dma
-r--r--r-- 1 root root 4096 Nov 16 00:22 unique_id

Hopefully, it will make a bit clearer, why SCST can't use struct device, but uses
struct kobject, and why it needs a special place in the SYSFS tree to attach to.

Thanks,
Vlad

[1] You can download a copy of SAM from http://www.t10.org/drafts.htm. Exact version doesn't matter.
