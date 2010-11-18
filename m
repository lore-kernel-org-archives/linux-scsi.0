From: Vladislav Bolkhovitin <vvvvvst@gmail.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 19 Nov 2010 00:02:58 +0300
Message-ID: <4CE59482.3050002@gmail.com>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com> <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com> <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com> <4CE2846C.6070501@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CE2846C.6070501@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Richard Williams <richard@etechsoft.com>, Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin, on 11/16/2010 04:17 PM wrote:
> Your questions are very good, so let's summarize what we need to serve
> the needs of a SCSI target subsystem (not necessary SCST) and see what
> can fit them.
> 
> So, the needs:
> 
> 1. Be capable to represent to user space internal configuration to let
> user space be able to see and analyze it, including various statistics.
> 
> 2. Let user space manage the internal configuration.
> 
> 3. Desired: possibility to send to user space events about important
> internal actions, like I/O failures, which may need user space
> intervention to recover, like switching from active to passive role in a
> cluster.
> 
> So, what can we do with ConfigFS:
> 
> (1): Only partially, because by design ConfigFS isn't supposed to
> represent internal configuration, it can only manage it. Extending
> ConfigFS to be capable to do that would be, in my understanding, a
> strong violation of its purpose and, hence, design and if went this way
> eventually ConfigFS would become just a duplication of the SYSFS
> functionality.
> 
> (2): ConfigFS can do that. This is exactly for what it was designed and
> implemented. But in this particular application it would have some
> limitations derived from (1): to manage harware-related entries a user
> should magically know from somewhen names of those entries to create
> them by "mkdir" command.
> 
> For instance, consider a user has a Fibre Channel HBA and want to use it
> in the target mode. Before he can configure it, he should somehow know
> its ports names and for each of them run:
> 
> # mkdir /sys/kernel/config/.../50:50:00:00:00:00:00:11
> # mkdir /sys/kernel/config/.../50:50:00:00:00:00:00:12
> ...
> 
> where 50:50:00:00:00:00:00:1x are the ports' names. Only after that
> those ports appear on the ConfigFS and can be managed.
> 
> (3): No events at all.
> 
> Now consider SYSFS:
> 
> (1): Easily. This is exactly for what it was designed and implemented.
> 
> (2): Possible without any limitations and side effects.
> 
> (3): Also possible.
> 
> So, why not use SYSFS if it suits all the needs _without_ any additional
> effort and patches?
> 
> Other alternatives? A set of custom IOCTLs? One more configuration FS? I
> believe, those would be quite disgusting for all.
> 
>> Maybe I misunderstand - But if both sides have merit then wouldn't a
>> compromise be appropriate?
>>
>> Maybe the sensical compromise is to use sysfs code to create a new
>> namespace that would fit this purpose?  It seems that I am also
>> hearing that the alternatives to sysfs aren't always adequate - so
>> why not use sysfs, but have a place where it's appropriate to use it?
> 
> This is exactly what we are proposing: to use SYSFS in additional
> namespace /sys/kernel/scst_tgt.
> 
> As far as I can see, only Greg is against it. Greg keeps his reasons
> private, so I can only guess that Greg is against extending usage of
> SYSFS (note, _usage_, not implementation! Everything needed long ago
> implemented.) beyond the scope it was originally designed around 10
> years ago. But SYSFS is already widely used this way in the kernel, as
> Joe illustrated, hence there is demand for it. People need it. So, why
> not to just acknowledge this fact and go ahead the simplest and most
> useful for both users and developers way?

Since nobody objected, Greg, could you consider to ACK SCST SYSFS
management interface in /sys/kernel/scst_tgt/, please? Please find the
SCST SYSFS ABI documentation file you requested below.

We are also preparing a new patch to free our objects in kobjects.release()
without explicit x_initialized flags as you requested.

Thank you for your effort,
Vlad

Documentation/ABI/testing/sysfs-scst:

What:		/sys/kernel/scst_tgt/
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains SCST management interface entries.

What:		/sys/kernel/scst_tgt/devices/
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains subdirectories for all SCST devices

What:		/sys/kernel/scst_tgt/devices/<device>/exported/exportX
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Links to LUNs in the LUNs group where <device> exported, e.g. to
		/sys/kernel/scst_tgt/targets/iscsi/iqn.2006-10.net.vlnb:tgt/luns/11

What:		/sys/kernel/scst_tgt/devices/<device>/handler
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Link to dev handler of this device, if assigned, e.g. to
		/sys/kernel/scst_tgt/handlers/dev_disk

What:		/sys/kernel/scst_tgt/devices/<device>/type
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		SCSI type of this device as define by SAM.

What:		/sys/kernel/scst_tgt/handlers/
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains all SCST dev handlers.

What:		/sys/kernel/scst_tgt/handlers/<handler>/<device>
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Links to <device> managed by this dev handler, e.g.
		ext3_disk1_4K -> /sys/kernel/scst_tgt/devices/ext3_disk1_4K

What:		/sys/kernel/scst_tgt/handlers/<handler>/mgmt
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Management entry, which allows to create and delete
		devices for this dev handler. See SysfsRules file for more
		info.

What:		/sys/kernel/scst_tgt/handlers/<handler>/type
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		SCSI type of this dev handler as define by SAM.

What:		/sys/kernel/scst_tgt/sgv/
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains SCST SGV caches statistics.

What:		/sys/kernel/scst_tgt/sgv/global_stats
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains global SGV cache statistics.

What:		/sys/kernel/scst_tgt/sgv/<cache>/stats
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains statistics for SGV cache <cache>

What:		/sys/kernel/scst_tgt/targets/
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains all SCST target drivers

What:		/sys/kernel/scst_tgt/targets/<target_driver>
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains all targets for <target_driver>

What:		/sys/kernel/scst_tgt/targets/<target_driver>/mgmt
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Optional management entry, which allows to create and
		delete targets for this target driver. See SysfsRules
		file for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/enable
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Optional attribute to enable <target_driver> and make it serve
		incoming connections from initiators. Possible values:
		1 - enable
		0 - disable

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Contains security groups for <target>

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/mgmt
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Allows to create and delete security groups for <target>.
		See README.scst for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/initiators/mgmt
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Allows to add and delete initiators to/from <group>.
		See README.scst for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/initiators/<initiator_name>
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		One or more initiators in <group>. Contains initiator's name.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/luns/mgmt
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Allows to add and delete LUNs to/from <group>. See README.scst
		for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/luns/<lun>/device
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Link to device for <lun>, e.g. to /sys/kernel/scst_tgt/devices/ext3_disk1_4K

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/luns/<lun>/read_only
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets if this LUN should be read only

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/addr_method
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets SCSI addressing method for <group>. See README.scst
		for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/cpu_mask
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets CPU mask for threads serving initiators in <group>.
		See README.scst for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/io_grouping_type
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets IO grouping types for threads serving initiators
		in <group>. See README.scst for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/luns/mgmt
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Allows to add and delete LUNs to/from the <target>'s default
		set of LUNs. See README.scst for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/luns/<lun>/device
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Link to device for <lun>, e.g. to /sys/kernel/scst_tgt/devices/ext3_disk1_4K

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/luns/<lun>/read_only
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets if this LUN should be read only

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/addr_method
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets SCSI addressing method for the <target>'s default
		set of LUNs. See README.scst for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/cpu_mask
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets CPU mask for threads serving initiators in the
		<target>'s default set of LUNs. See README.scst for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/io_grouping_type
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Sets IO grouping types for threads serving initiators
		in the <target>'s default set of LUNs. See README.scst
		for more info.

What:		/sys/kernel/scst_tgt/targets/<target_driver>/<target>/enable
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Optional attribute to enable <target> and make it serve
		incoming connections from initiators. Possible values:
		1 - enable
		0 - disable

What:		/sys/kernel/scst_tgt/last_sysfs_mgmt_res
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Returning completion status of the last management
		command. See README.scst for more info.

What:		/sys/kernel/scst_tgt/setup_id
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Allows to read and write SCST setup ID. This ID can be
		used in cases, when the same SCST configuration should
		be installed on several targets, but exported from those
		targets devices should have different IDs and SNs. For
		instance, VDISK dev handler uses this ID to generate T10
		vendor specific identifier and SN of the devices.

What:		/sys/kernel/scst_tgt/threads
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Allows to read and set number of global SCST I/O
		threads. Those threads used with async. dev handlers,
		for instance, vdisk BLOCKIO or NULLIO

What:		/sys/kernel/scst_tgt/version
Date:		November 2010
Contact:	Vladislav Bolkhovitin <vst@vlnb.net>
Description:
		Allows to see version of SCST and enabled optional features.
