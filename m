From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Fri, 29 Aug 2008 20:28:52 +0400
Message-ID: <48B823C4.7010803@vlnb.net>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>	 <48B59556.7050108@vlnb.net>	 <1219875219.13470.380.camel@haakon2.linux-iscsi.org>	 <48B6E5C8.2000306@vlnb.net> <1219964919.13470.505.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:36035 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751382AbYH2Q2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2008 12:28:22 -0400
In-Reply-To: <1219964919.13470.505.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>, Greg KH <greg@kroah.com>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jerome Martin <tramjoe.merin@gmail.com>

Nicholas A. Bellinger wrote:
> On Thu, 2008-08-28 at 21:52 +0400, Vladislav Bolkhovitin wrote:
>> Nicholas A. Bellinger wrote:
> 
>>>> 2. It assumes the stateless type of configuration, when each call 
>>>> configures exactly one thing without any side effects on already 
>>>> configured or future entries.
>>>>  This approach is good for cases like 
>>>> iptables, but for SCSI targets it's possible that several configuration 
>>>> steps require to be done in an atomic manner, like adding an iSCSI 
>>>> target and configuring its parameters.
>>> Well, the ability for an admin to force an LIO-Core related action, say
>>> removing an HBA and all associated storage object with lots of exported
>>> LUNs and running I/O, or an LIO-Target related action, say removing an
>>> entire iSCSI Target Node with targetname=) at any time..  This obviously
>>> require precision interaction between Target Fabric I/O Paths <-> Target
>>> Core and Target Core <-> Control Interface to Admin.
>>>
>>> That control interface needs to be protected in object contexts.  In
>>> LIO-Core this is on a per HBA (be it physical or virtual) context.  With
>>> LIO-Target this is on a iSCSI Target Node by targetname -> Target Portal
>>> Group Tag context.  Obviously doing this from an IOCTL is the only real
>>> choice I had when this code started in 2001, but I wonder how configfs
>>> would work for something like this.
>> My favorite configuration interface would have 2 levels.
>>
>> 1. The lowest level would be /proc, /sys, etc. based and allow to 
>> configure exactly one parameter or set of related parameters with 
>> corresponding subparameters necessary to provide required atomicity, if 
>> needed. For instance, this is how a new virtual read-only SBC device 
>> with 4K block size is added in SCST vdisk handler:
>>
>> # echo "open disk_4K /disk_4K 4096 READ_ONLY" >/proc/scst/vdisk/vdisk
>>
> 
> So, I would consider proc and sysfs both medieval for RW data, with the
> latter being slightly sharper instrument than the former, but both not
> very effective..
> 
> Configfs on the other hand, is quite sharp in the battlefield..  Here is
> what I am thinking for LIO-Target after it was loaded to an configfs
> enabled generic target engine:
> 
> # This is the iSCSI Qualifed Target Name we will be creating
> MY_TARGETIQN=/config/target/iscsi/iqn.superturbodiskarray
> # From 'lvs -v'
> LVM_UUID=y2sbeD-insM-xykn-s3SV-3tge-VWhn-xB4FMv
> # From 'lsscsi' or '/proc/scsi/scsi'
> SCSI_HCTL_LOCATION=1:0:0:0
> 
> # Same as 'target-ctl coreaddtiqn targetname=$IQN' with LIO today
> mkdir $MY_TARGETIQN
> 
> # Make TPGT=1 on iqn.superturbodiskarray
> mkdir $MY_TARGETIQN/tpgt_1
> 
> # Make TPGT=1 run in Demo Mode for this example (no Initiator ACLs)
> echo 1 > $MY_TARGETIQN/tpgt_1/attribs/generate_node_acls
> 
> # Create network portal mapping to TPGT=1
> mkdir $MY_TARGETIQN/tpgt_1/np/192.168.100.10
> 
> # DEPENDS ON GENERIC TARGET CORE
> # Create TPGT=1,LUN=0 from Linux LVM Block Device
> mkdir $MY_TARGETIQN/tpgt_1/lun_0
> echo $LVM_UUID > $MY_TARGETIQN/tpgt_1/lun_0/location
> 
> # DEPENDS ON GENERIC TARGET CORE
> # Create TPGT=1,LUN=1 from SCSI Layer
> mkdir $MY_TARGETIQN/tpgt_1/lun_1
> echo $SCSI_HCTL_LOCATION > $MY_TARGETIQN/tpgt_1/lun_1/location
> 
> # This is the atomic part, once we throw this flag iSCSI Initiators will
> be allowed to login to this TPGT
> echo 1 > $MY_TARGETIQN/tpgt_1/enable_tpg
> 
> # The equivliant of 'target-ctl coredeltiqn targetname=$IQN' today
> rm -rf $MY_TARGETIQN
> 
> I think this would make a very useful and extremely flexiable interface
> for my purposes...  What do you think about the potential..?

It has a big problem with atomicity of changes. Configuration of each 
iSCSI target should be atomic and on the target driver's start 
configuration of *all* targets as a whole should be atomic as well. How 
are you going to solve this issue?

Plus:

1. As I already wrote, separate subdir for each target and device is 
harder to parse

2. The high level interface needs to lock somehow the low level 
interface during updates to protect from simultaneous actions. I don't 
see a simple way to do that in configfs.

>> 2. The higher level interface(s) would allow people to not bother with 
>> low level commands, but use regular text config file(s). See scstadmin 
>> utility for example. It allows to do all necessary configuration of SCST 
>> core from /etc/scst.conf file. Such interface must have an important 
>> property: it must be able to detect changes in the config file and apply 
>> them to the running system. That property would allow to have system 
>> configuration always persistent: if one needs to change something, he 
>> would edit the config file and rerun the corresponding utility 
>> (scstadmin in this example; it really can do that, though with some 
>> limitations). Although this interface level would completely belong to 
>> user space, we in kernel need to provide for it a convenient interface.
>>
>> Target drivers and backstorage device handlers, who need advanced 
>> configuration, would have own low and high level interfaces, as needed. 
>> For instance, an iSCSI target must not start serving clients until all 
>> its targets fully configured. Otherwise, initiators can get rejected for 
>> not yet configured target and erroneously consider it dead. In 
>> iSCSI-SCST the user space part of the target doesn't start accepting 
>> connection until it finishes reading /etc/iscsi-scst.conf file.
>>
>>>> 3. It's hard to read 5+ parameters in one command line, so it's a lot 
>>>> easier to make a mistake there.
>>> No, I completely agree.  But I honestly think the actual target CLI
>>> interface and parameters to admin need to do alot of pre-execution
>>> script logic in userspace to reference different interested objects,
>>> without the admin have to provide all of stuff.  I do this today to
>>> determine the major/minor for lvm_uuid= (from lvs -v), md_uuid= (from
>>> mdadm -D) and udev_path= (from /dev/disk)..
>>>
>>> Same goes for real SCSI devices that we are exporting directly from
>>> drivers/scsi.  We want to use EVPD Unit Serial or Device Identificaton
>>> where ever able to reference said storage object.
>> Yes, this is why we need the high level interface. Otherwise for complex 
>> targets the configuration task quickly grows up to a nightmare.
>>
>>>> So, I believe, a configuration interface should be rather /proc or /sys 
>>>> interface based. I don't think we should care much about backward 
>>>> compatibility with tgtadm, because the existing interface doesn't reach 
>>>> the state of being widely used.
>>> I would definately vote against proc here for the fancy stuff I
>>> mentioned above.  I have experience enabled core-iscsi to use sysfs for
>>> RO data, but nothing along the lines of what would be required for a
>>> generic target mode RW control path.  Does anyone with sysfs experience
>>> have any comments on thing..?
>> Sysfs as well as configfs have one big disadvantage. They limit each 
>> file to only 4KB. This would force us for to create a subdirectory for 
>> each device and for each connected initiator. I don't like seeing 
>> thousands subdirectories. Additionally, such layout is a lot less 
>> convenient for parsing for the high level configuration tool, which 
>> needs to find out the difference between the current configuration and 
>> content of the corresponding config file.
>>
> 
> So yeah, the output with configfs is limited to PAGE_SIZE as well, but
> for the R/W cases we don't expect that data sets to exceed this per
> configfs mkdir invocation.. 
> 
>> Currently, with procfs SCST can list in /proc/scst/sessions virtually 
>> unlimited amount of connected initiators in a simple for parsing manner. 
>> It was done using seq interface well and simply. Neither sysfs, nor 
>> configfs support seq interface. This would introduce significant effort 
>> in both kernel and user spaces.
>>
> 
> Same for me with all of the target-ctl IOCTL commands.   No one ever
> said upstream target code was not going to require significant
> effort. :-)

I don't think we should create the additional one :-)

>> Debugfs supports seq interface, but, because of the name, I doubt we can 
>> use it ;)
>>
>> Thus, looks like we'd better stay with /proc. After all, networking and 
>> VM widely use /proc for internal configuration. Why SCSI target is worse?
>>
> 
> So yeah, RW configuration data going with /proc is completely
> unacceptable for my purposes.  However since all of the LIO iSCSI and
> SCSI MIB code is procfs + seq_file based (and is read-only) I figure
> that considering there are other MIBs related procfs code in other
> subsystems, that this would not be too much of a stumbling point.
> 
> So this configfs stuff is really starting to grow on me, I am surprised
> that I have missed it for so long, I know the author (and alot of the
> OCFSv2 team) and I believe their reasons for creating and moving ocfs2
> to use configfs (even though a production ocfs2 create has much *FEWER*
> configuration information respresented in configfs directories and
> entries than a production iSCSI target would) provide compelling
> evidence to move our efforts for a generic kernel target engine in this
> direction.  So yes, I do feel your pain wrt to existing code, but I
> believe that using procfs from my current IOCTL would quite honestly be
> a step back.  
> 
> How about this, I will begin to implement the LIO-Target pieces in
> configfs for lio-core-2.6.git, and leave LIO-Core in IOCTL for now, and
> once I have some running code, I will look at the process to begin to
> incorporate the requirements to preform the "dumb registration" with a
> generic target engine.  From there, that would give me a good idea of
> what would be required with SCST and configfs.  From the above example
> with configfs, these would be:
> 
> # Create TPGT=1,LUN=0 from Linux LVM Block Device using UUID from
> # 'lvs -v' output
> mkdir $MY_TARGETIQN/tpgt_1/lun_0
> echo $LVM_UUID > $MY_TARGETIQN/tpgt_1/lun_0/location
> 
> # Create TPGT=1,LUN=1 from SCSI Layer h/c/t/l Parameters from lsscsi
> # or /proc/scsi/scsi output
> mkdir $MY_TARGETIQN/tpgt_1/lun_1
> echo $SCSI_HCTL_LOCATION > $MY_TARGETIQN/tpgt_1/lun_1/location
> 
> Of course, we could do poke directly at Target-Core storage objects via
> configfs as well!
> 
> # Preform a LUN reset on $LVM_UUID on all mapped target PORTs/LUNs
> echo 1 > /config/target/core/$LVM_UUID/lun_reset
> # Remove the SCSI device from the target, and all mapped PORTs/LUNs
> # and fall all outstanding I/Os.
> rm -rf /config/target/core/$SCSI_HTL_LOCATION
> 
> Again, I think this would be extremely flexible and easily extendable
> for new uses. Also, providing some level of backwards compatibility with
> our project's existing CLI nomenclature would not been that hard if our
> repsective projects really require it.
> 
> I would also be happy to help with configfs and SCST if you are
> interested..

Thanks, but more I'm thinking, more I'm coming to an IOCTL's based 
interface, where each submodule has own set of IOCTL's, multiplexed over 
a single device, and for each module there would be a simple dedicated 
utility. For example, to configure virtual disk backstorage handler: 
scst_vdisk_ctl, which would allow to create, delete and manage virtual 
FILEIO/BLOCKIO disks. Or for managing security groups there would be 
scst_acl_ctl utility. Each such utility would be very simple, would 
offload kernel from parsing character strings or converting to them, as 
it is necessary for configfs, each new future module would come with own 
management tool. Git uses a similar approach: a dedicated program for 
each action.

Data of big lists, like list of devices, would be returned at once in an 
easy to parse form, which would considerably simplify creation of the 
high level interface.

Such approach would be pretty simple for implementation and maintenance 
(I love simplicity) as well as solve all other configfs problems, namely:

1. The atomicity would be natural. An iscsi_tgt_ctl utility would parse 
the input or corresponding config file and create a target with all 
parameters in a single IOCTL call.

2. Locking would be automatic via forced exclusive open without any 
additional actions.

Also SCST /proc helpers, which target drivers and backstorage handlers 
intensively use, would fit in this approach quite well.

How's that look?

Vlad
