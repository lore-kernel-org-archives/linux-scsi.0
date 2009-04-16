From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [RFC]: SCST sysfs layout
Date: Thu, 16 Apr 2009 17:19:54 +0400
Message-ID: <49E7307A.8000205@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:49578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbZDPNTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 09:19:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel@lists.sourceforge.net, Daniel Debonzi <debonzi@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi All,

Below is proposal for the SCST sysfs layout, which will replace existing procfs-based infrastructure. Any comments, questions and suggestions are welcome!

I. SCST sysfs layout.

Root would be /sys/scsi_tgt.

In the root there would be the following files and subdirectories:

 - targets - subdirectory listing names of all registered target drivers.

 - devices - subdirectory listing all registered backend devices.

 - sgv - subdirectory listing all existing SGV pools.

 - drivers - subdirectory listing all loaded target and backend drivers (dev handlers).

 - threads - RW file listing number of global SCST threads. Writing to that file would allow to change that value.

 - trace_level - RW file listing SCST core logging level. Writing to that file would allow to change that. Example content: 
"out_of_mem | minor | pid | line | function | special | mgmt | mgmt_minor | mgmt_dbg | retry". See current procfs implementation of this file for more info.

 - version - RO file listing version of SCST core and enabled compile time features. Example content: "1.0.2, EXTRACHECKS, DEBUG"                                                                                                                          

1. Subdirectory targets would contain only subdirectories with names the same as the names of the registered target drivers.

Subdirectory targets/target_driver_name would contain only subdirectories with names the same as the names of the registered targets.

In each targets/target_driver_name/target subdirectory there would be the following files and subdirectories:

 - sessions - subdirectory listing all existing sessions with this target.

 - luns - subdirectory listing all configured in this target LUNs.

 - ini_groups - subdirectory listing all initiator-specific security groups (ACL) configured in this target LUNs. Such groups would be mainly used for hardware targets, which don't allow creation of virtual targets, to let different initiators see different sets of devices (LUNs) from a single target. Refer to SCST core README file for initiator-oriented access control.

 - One or more target-specific files or directories. For instance, QLogic target driver qla2x00t would have here the following:

	* enabled - RO file, which is at the moment in /sys/class/scsi_host/hostX/target_mode_enabled. It defines if this target enabled (i.e. target mode on it enabled)

	* host - link to original initiator driver's entry /sys/class/scsi_host/hostX

1.1. Subdirectory targets/target_driver_name/target/sessions would contain only subdirectories with names the same as the names of connected to this target initiators.

In each targets/target_driver_name/target/sessions/initiator subdirectory there would be the following files and subdirectories:

 - group - link to the security group (../../ini_groups/group), to which this initiator was assigned or to "../..".

 - commands - RO file listing count of currently active commands in this session.

1.2. Subdirectory targets/target_driver_name/target/luns would contain subdirectories with names LU numbers and RW file "mgmt". Reading from it would provide a list of available commands ("help"), writing to it would execute the corresponding commands. Available commands:

	* add_device DEVICE_NAME LUN [READ_ONLY] - adds device DEVICE_NAME with LUN LUN, optionally read-only

	* del_device LUN - deletes LUN

Subdirectory targets/target_driver_name/target/luns/lun would contain:

 - device - link to the corresponding device in ../../../devices/device with name LU number.

 - options - RO file listing options of this LUN, see "mgmt" below.

1.3. Subdirectory targets/target_driver_name/target/ini_groups would contain subdirectories with group names and 1 RW file "mgmt". Reading from it would provide a list of available commands ("help"), writing to it would execute the corresponding commands. Available commands:

	* create_group GROUP_NAME - would create the corresponding group and empty subdirectory for it.

	* del_group GROUP_NAME - would delete the corresponding group and its subdirectory.

1.3.1. In each targets/target_driver_name/target/ini_groups/group subdirectory there would be the following files and subdirectories:

 - luns - subdirectory listing all configured in this group LUNs. Each LUN in would be listed as a link similarly to targets/target_driver_name/luns.

 - initiators - subdirectory listing names of all initiators, which should be assigned to this group. Each would be listed as an empty file with name the name of the corresponding initiator.

 - mgmt - RW file. Reading from it would provide a list of available commands ("help"), writing to it would execute the corresponding commands. Available commands:

	* add_device DEVICE_NAME LUN [READ_ONLY]

	* del_device LUN 

	* add_initiator INITIATOR_NAME

	* del_initiator INITIATOR_NAME

2. Subdirectory "devices" would contain only subdirectories with names the same as the names of the registered devices. For pass-through devices it would be host:channel:id:lun numbers.

In each devices/device subdirectory there would be the following files:

 - type - RO file listing SCSI type of this device, like: "0 - Direct-access device (e.g., magnetic disk)"

 - handler - link pointing to backend handler servicing this device or to "none", if the handler was not set. The handler can be not set for pass-through devices.

 - exported - subdirectory listing links to all groups in which this device was configured. This subdirectory wouldn't necessary for SCST configuration, but would much improve usability and, hence, security, because it would allow to see simply who can use this device. Names of this links would be simple incrementing numbers starting from 0.

 - Backend handler specific files and subdirectories. For instance, vdisk handler would have the following here:

	* size - RO file listing size of this device

	* block_size - RO file listing block size of this device

	* options - RO file listing options of this device. Like: "READ_ONLY"

	* file_name - RO file listing full path to the corresponding file, used as backstorage for this device.

	* resync_size - WO file. Writing to it would tell vdisk handler to reread size of this device after its backstorage file was resized. It is the same as current "resync_size" /proc command.

3. Subdirectory "sgv" would contain RO files with names the same as the names of existing SGV pools. They would list statistic of this pool. For instance:

Name                           Hit         Total       % merged    Cached                                                                   
sgv                            223         231         0           0/0 (P/O)                                                                
  sgv-4K                       195         198         0                                                                                    
  sgv-8K                       0           0           0                                                                                    
  sgv-16K                      10          11          0                                                                                    
  sgv-32K                      2           3           0                                                                                    
  sgv-64K                      1           2           0                                                                                    
  sgv-128K                     15          16          0                                                                                    
  sgv-256K                     0           1           0                                                                                    
  sgv-512K                     0           0           0                                                                                    
  sgv-1024K                    0           0           0                                                                                    
  sgv-2048K                    0           0           0                                                                                    
  sgv-4096K                    0           0           0                                                                                    
  big/other                                0/0         0/0                                                                                  
 
Also subdirectory "sgv" would contain RO file "global" which would list some global SGV statistic, like:

Inactive/active pages                      0/0                                                                                              
Hi/lo watermarks [pages]                   125696/0                                                                                         
Hi watermark releases/failures             0/0                                                                                              
 
4. Subdirectory "drivers" would contain only subdirectories with names the same as the names of the loaded target and backend drivers.

Each drivers/driver subdirectory would contain any driver-specific files and subdirectories. For instance, vdisk driver would contain there the following:

 - mgmt - RW file. Reading from it would provide a list of available commands ("help"), writing to it would execute the corresponding commands. Available commands:

	* add_device DEVICE_NAME [FILE_NAME [BLOCK_SIZE] [WRITE_THROUGH READ_ONLY O_DIRECT NULLIO NV_CACHE BLOCKIO]]

	* del_device DEVICE_NAME

	* trace_level - RW file listing vdisk's logging level similar to SCST cores logging level.

See example below for more samples.

II. SCST sysfs layout example. Hopefully, target's configuration is obvious from it.

/sys/scsi_tgt/
	targets/
		qla2x00tgt/
			21:00:00:e0:e5:87:a2:b0/
				sessions/
					21:00:00:e0:e5:87:a2:b1/
						group -> ../..
						commands
					21:00:00:e0:e5:87:a2:aa/
						group -> ../../ini_groups/restricted
						commands
				luns/
					0/
						device -> ../../../devices/rd
						options
					1/
						device -> ../../../devices/xfs_disk1
						options
					2/
						device -> ../../../devices/xfs_disk2
						options
					15/
						device -> ../../../devices/nullio
						options
					mgmt
				ini_groups/
					restricted/
						initiators/
							21:00:00:e0:e5:87:a2:aa
							21:00:00:e0:e5:87:a2:bb
						luns/
							0/
								device -> ../../../../../devices/rd
								options
					mgmt
				enabled
				host -> ../../../../../class/scsi_host/hostX
		iscsi/
			iqn.2006-10.net.vlnb:tgt/
				sessions/
					iqn.2005-03.org.open-iscsi:cacdcd2520/
						group -> ../..
						commands
				luns/
					0/
						device -> ../../../devices/rd
						options
					5/
						device -> ../../../devices/2:0:0:0
						options
					mgmt
				ini_groups/
					mgmt
			iqn.2006-10.net.vlnb:null/
				sessions/
				luns/
					0/
						device -> ../../../devices/nullio
						options
					mgmt
				ini_groups/
					mgmt
	devices/
		2:0:0:0/
			exported/
				0 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt/luns/5
			type
			handler	-> ../drivers/dev_disk/disk
		3:0:0:0/
			exported/
			type
			handler	-> none /* i.e. to nowhere */
		xfs_disk1/
			exported/
				0 -> ../../../targets/qla2x00tgt/21:00:00:e0:e5:87:a2:b0/luns/1
			type
			handler -> ../drivers/vdisk/fileio
			size
			block_size
			options
			file_name
			resync_size
		xfs_disk2/
			exported/
				0 -> ../../../targets/qla2x00tgt/21:00:00:e0:e5:87:a2:b0/luns/2
			type
			handler -> ../drivers/vdisk/blockio
			size
			block_size
			options
			file_name
			resync_size
		nullio/
			exported/
				0 -> ../../../targets/qla2x00tgt/21:00:00:e0:e5:87:a2:b0/luns/15
				1 -> ../../../targets/iqn.2006-10.net.vlnb:null/luns/0
			type
			handler -> ../drivers/vdisk/nullio
			size
			block_size
			options
			file_name
			resync_size
		rd/
			exported/
				0 -> ../../../targets/qla2x00tgt/21:00:00:e0:e5:87:a2:b0/luns/0
				1 -> ../../../targets/qla2x00tgt/ini_groups/restricted/luns/0
				2 -> ../../../targets/iqn.2006-10.net.vlnb:tgt/luns/0
			type
			handler	-> ../drivers/user/dh-rd
	sgv/
		sgv
		sgv-clust
		sgv-dma
		rd
		rd-clust
		other
		global
	drivers/
		qla2x00tgt/
			trace_level
		iscsi/
			tid:1 name:iqn.2006-10.net.vlnb:tgt/
				iqn.2005-03.org.open-iscsi/
					0/ /* it's CID number */
						ip
						digest	/* content: header:none data:none */
						state	/* content: established idle */
					sid 	/* content: 10000013d0200 */
					state	/* content: reinstating no */
			trace_level
			version
		vdisk/
			fileio/
				xfs_disk1 -> ../devices/xfs_disk1
				xfs_disk2 -> ../devices/xfs_disk2
			blockio/
			nullio/
				nullio -> ../devices/nullio
			mgmt
			trace_level
		dev_disk/
			disk/
				2:0:0:0 -> ../devices/2:0:0:0
			disk_perf/
			mgmt	/* allows to change dev handler on pass-through devices. Command is only one: "assign H:C:I:L HANDLER_NAME" */
			type	/* content: 0 - Direct-access device (e.g., magnetic disk) */
			trace_level
		user/
			dh-rd/
				rd -> ../devices/rd
			trace_level
	threads
	trace_level
	version
					
III. Implementation considerations

1. Top level subdirectories and files should be created by init_scst().

2. targets/target_driver_name drivers/target_driver_name and should be created by scst_register_target_template() and removed by scst_unregister_target_template().

3. targets/target_driver_name/target with sessions, luns and ini_groups subdirectories should be created by scst_register() and removed by scst_unregister().

4. targets/target_driver_name/target/sessions/session and below should be created by scst_init_session() and removed by scst_free_session().

5. Pass-through devices should be added to devices/ by scst_register_device() and removed by scst_unregister_device(). Initially they should have "handler" link pointed to "none".

6. Virtual devices should be added to devices/ by scst_register_virtual_device() and removed by scst_unregister_virtual_device().

7. drivers/dev_handler_name should be added by scst_register_dev_driver() or scst_register_virtual_dev_driver() and removed by scst_unregister_dev_driver() or scst_unregister_virtual_dev_driver().

8. It isn't clear how to best combine standard and custom entries in targets/target_driver_name/target, devices/device, drivers/target_driver_name and drivers/dev_handler_name, I don't know sysfs interfaces sufficiently well. I can only suggest places, where it should be done:

 - For targets/target_driver_name/target a target driver after scst_register() register call should call new function scst_get_target_root() and add there new entries. Before scst_unregister() call the target driver should remove them at first. Similarly it should be done for drivers/target_driver_name and drivers/dev_handler_name.

 - For devices/device a dev handler should do it in attach() callback and remove in detach() callback. Similarly to scst_get_target_root(), the dev handler should get its sysfs root by calling scst_get_dev_root().

Both should be made in some generic way to minimize duplicated code between target drivers and between dev handlers.

Vlad

-- 
Home page of SCST and target drivers: http://scst.sourceforge.net
