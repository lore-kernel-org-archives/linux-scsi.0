From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 18:45:24 +0100
Message-ID: <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com>
References: <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59700 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab0KORpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 12:45:49 -0500
In-Reply-To: <20101113235938.GA1827@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Sun, Nov 14, 2010 at 12:59 AM, Greg KH <greg@kroah.com> wrote:
>
> On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
> > So, I decided to reimplement it to be completely synchronous. SYSFS
> > authors did really great job and thanks to the excellent internal SYSFS
> > design and implementation it is absolutely safe. See:
> >
> > [root@tgt ~]# modprobe scst
> > [root@tgt ~]# cd /sys/kernel/scst_tgt/
>
> Sorry, but no, you can't put this in /sys/kernel/ without getting the
> approval of the sysfs maintainer.
>
> I really don't understand why you are using kobjects in the first place,
> why isn't this in the main device tree in the kernel, using 'struct
> device'?

We might have missed something, but as far as we know it has not yet
been explained in this thread why using 'struct device' would be an
advantage over using 'struct kobject'. All I can see are the
disadvantages of such a transition: instead of having a single
hierarchy that represents all SCST-related information, there would be
multiple, and the hierarchical relationship between objects would be
lost. Also, during startup, once all SCST-related kernel modules have
been loaded, configuration happens by writing values to individual
sysfs variables. There is a user-space tool included with SCST that
not only can restore a configuration from a file but also can save an
existing configuration to file. I'm afraid that saving an existing
configuration would be made considerably more difficult by
transforming the single SCST sysfs-tree into multiple. Below you can
find an example of a sysfs-tree created by SCST:

# (cd /sys/kernel/scst_tgt && find | cut -c3-)
threads
setup_id
trace_level
version
last_sysfs_mgmt_res
targets
targets/ib_srpt
targets/ib_srpt/ib_srpt_target_0
targets/ib_srpt/ib_srpt_target_0/enabled
targets/ib_srpt/ib_srpt_target_0/sessions
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/initiator_name
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/req_lim
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/req_lim_delta
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/luns
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun0
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun0/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun1
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun1/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun2
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun2/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun255
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun255/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun3
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun3/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun4
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun4/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun5
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun5/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun6
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun6/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun7
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun7/active_commands
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun8
targets/ib_srpt/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/lun8/active_commands
targets/ib_srpt/ib_srpt_target_0/luns
targets/ib_srpt/ib_srpt_target_0/luns/mgmt
targets/ib_srpt/ib_srpt_target_0/luns/0
targets/ib_srpt/ib_srpt_target_0/luns/0/read_only
targets/ib_srpt/ib_srpt_target_0/luns/0/device
targets/ib_srpt/ib_srpt_target_0/luns/1
targets/ib_srpt/ib_srpt_target_0/luns/1/read_only
targets/ib_srpt/ib_srpt_target_0/luns/1/device
targets/ib_srpt/ib_srpt_target_0/luns/2
targets/ib_srpt/ib_srpt_target_0/luns/2/read_only
targets/ib_srpt/ib_srpt_target_0/luns/2/device
targets/ib_srpt/ib_srpt_target_0/luns/255
targets/ib_srpt/ib_srpt_target_0/luns/255/read_only
targets/ib_srpt/ib_srpt_target_0/luns/255/device
targets/ib_srpt/ib_srpt_target_0/luns/3
targets/ib_srpt/ib_srpt_target_0/luns/3/read_only
targets/ib_srpt/ib_srpt_target_0/luns/3/device
targets/ib_srpt/ib_srpt_target_0/luns/4
targets/ib_srpt/ib_srpt_target_0/luns/4/read_only
targets/ib_srpt/ib_srpt_target_0/luns/4/device
targets/ib_srpt/ib_srpt_target_0/luns/5
targets/ib_srpt/ib_srpt_target_0/luns/5/read_only
targets/ib_srpt/ib_srpt_target_0/luns/5/device
targets/ib_srpt/ib_srpt_target_0/luns/6
targets/ib_srpt/ib_srpt_target_0/luns/6/read_only
targets/ib_srpt/ib_srpt_target_0/luns/6/device
targets/ib_srpt/ib_srpt_target_0/luns/7
targets/ib_srpt/ib_srpt_target_0/luns/7/read_only
targets/ib_srpt/ib_srpt_target_0/luns/7/device
targets/ib_srpt/ib_srpt_target_0/luns/8
targets/ib_srpt/ib_srpt_target_0/luns/8/read_only
targets/ib_srpt/ib_srpt_target_0/luns/8/device
targets/ib_srpt/ib_srpt_target_0/ini_groups
targets/ib_srpt/ib_srpt_target_0/ini_groups/mgmt
targets/ib_srpt/ib_srpt_target_0/rel_tgt_id
targets/ib_srpt/ib_srpt_target_0/addr_method
targets/ib_srpt/ib_srpt_target_0/io_grouping_type
targets/ib_srpt/ib_srpt_target_0/cpu_mask
targets/ib_srpt/ib_srpt_target_1
targets/ib_srpt/ib_srpt_target_1/enabled
targets/ib_srpt/ib_srpt_target_1/sessions
targets/ib_srpt/ib_srpt_target_1/luns
targets/ib_srpt/ib_srpt_target_1/luns/mgmt
targets/ib_srpt/ib_srpt_target_1/luns/0
targets/ib_srpt/ib_srpt_target_1/luns/0/read_only
targets/ib_srpt/ib_srpt_target_1/luns/0/device
targets/ib_srpt/ib_srpt_target_1/luns/1
targets/ib_srpt/ib_srpt_target_1/luns/1/read_only
targets/ib_srpt/ib_srpt_target_1/luns/1/device
targets/ib_srpt/ib_srpt_target_1/luns/2
targets/ib_srpt/ib_srpt_target_1/luns/2/read_only
targets/ib_srpt/ib_srpt_target_1/luns/2/device
targets/ib_srpt/ib_srpt_target_1/luns/255
targets/ib_srpt/ib_srpt_target_1/luns/255/read_only
targets/ib_srpt/ib_srpt_target_1/luns/255/device
targets/ib_srpt/ib_srpt_target_1/luns/3
targets/ib_srpt/ib_srpt_target_1/luns/3/read_only
targets/ib_srpt/ib_srpt_target_1/luns/3/device
targets/ib_srpt/ib_srpt_target_1/luns/4
targets/ib_srpt/ib_srpt_target_1/luns/4/read_only
targets/ib_srpt/ib_srpt_target_1/luns/4/device
targets/ib_srpt/ib_srpt_target_1/luns/5
targets/ib_srpt/ib_srpt_target_1/luns/5/read_only
targets/ib_srpt/ib_srpt_target_1/luns/5/device
targets/ib_srpt/ib_srpt_target_1/luns/6
targets/ib_srpt/ib_srpt_target_1/luns/6/read_only
targets/ib_srpt/ib_srpt_target_1/luns/6/device
targets/ib_srpt/ib_srpt_target_1/luns/7
targets/ib_srpt/ib_srpt_target_1/luns/7/read_only
targets/ib_srpt/ib_srpt_target_1/luns/7/device
targets/ib_srpt/ib_srpt_target_1/luns/8
targets/ib_srpt/ib_srpt_target_1/luns/8/read_only
targets/ib_srpt/ib_srpt_target_1/luns/8/device
targets/ib_srpt/ib_srpt_target_1/ini_groups
targets/ib_srpt/ib_srpt_target_1/ini_groups/mgmt
targets/ib_srpt/ib_srpt_target_1/rel_tgt_id
targets/ib_srpt/ib_srpt_target_1/addr_method
targets/ib_srpt/ib_srpt_target_1/io_grouping_type
targets/ib_srpt/ib_srpt_target_1/cpu_mask
targets/iscsi
targets/iscsi/mgmt
targets/iscsi/version
targets/iscsi/open_state
targets/iscsi/trace_level
targets/iscsi/iSNSServer
targets/iscsi/enabled
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/enabled
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/sessions
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/luns
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/luns/0
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/luns/0/read_only
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/luns/0/device
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/luns/mgmt
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/ini_groups
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/ini_groups/mgmt
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/rel_tgt_id
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/addr_method
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/io_grouping_type
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/cpu_mask
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/tid
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/per_portal_acl
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/redirect
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/InitialR2T
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/ImmediateData
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/MaxRecvDataSegmentLength
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/MaxXmitDataSegmentLength
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/MaxBurstLength
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/FirstBurstLength
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/MaxOutstandingR2T
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/HeaderDigest
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/DataDigest
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/QueuedCommands
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/RspTimeout
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/NopInInterval
targets/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:storage/MaxSessions
targets/scst_local
targets/scst_local/mgmt
targets/scst_local/version
targets/scst_local/stats
targets/scst_local/trace_level
targets/scst_local/scst_local_tgt
targets/scst_local/scst_local_tgt/sessions
targets/scst_local/scst_local_tgt/sessions/scst_local_host
targets/scst_local/scst_local_tgt/sessions/scst_local_host/commands
targets/scst_local/scst_local_tgt/sessions/scst_local_host/active_commands
targets/scst_local/scst_local_tgt/sessions/scst_local_host/initiator_name
targets/scst_local/scst_local_tgt/sessions/scst_local_host/transport_id
targets/scst_local/scst_local_tgt/sessions/scst_local_host/luns
targets/scst_local/scst_local_tgt/sessions/scst_local_host/host
targets/scst_local/scst_local_tgt/luns
targets/scst_local/scst_local_tgt/luns/mgmt
targets/scst_local/scst_local_tgt/ini_groups
targets/scst_local/scst_local_tgt/ini_groups/mgmt
targets/scst_local/scst_local_tgt/rel_tgt_id
targets/scst_local/scst_local_tgt/addr_method
targets/scst_local/scst_local_tgt/io_grouping_type
targets/scst_local/scst_local_tgt/cpu_mask
targets/scst_local/scst_local_tgt/scsi_transport_version
targets/scst_local/scst_local_tgt/phys_transport_version
devices
devices/2:0:0:0
devices/2:0:0:0/type
devices/2:0:0:0/exported
devices/2:0:0:0/scsi_device
devices/2:0:1:0
devices/2:0:1:0/type
devices/2:0:1:0/exported
devices/2:0:1:0/scsi_device
devices/3:0:0:0
devices/3:0:0:0/type
devices/3:0:0:0/exported
devices/3:0:0:0/scsi_device
devices/disk01
devices/disk01/type
devices/disk01/exported
devices/disk01/exported/export0
devices/disk01/exported/export1
devices/disk01/exported/export2
devices/disk01/dump_prs
devices/disk01/handler
devices/disk01/threads_num
devices/disk01/threads_pool_type
devices/disk01/size_mb
devices/disk01/blocksize
devices/disk01/read_only
devices/disk01/write_through
devices/disk01/thin_provisioned
devices/disk01/nv_cache
devices/disk01/o_direct
devices/disk01/removable
devices/disk01/filename
devices/disk01/resync_size
devices/disk01/t10_dev_id
devices/disk01/usn
devices/disk02
devices/disk02/type
devices/disk02/exported
devices/disk02/exported/export0
devices/disk02/exported/export1
devices/disk02/dump_prs
devices/disk02/handler
devices/disk02/threads_num
devices/disk02/threads_pool_type
devices/disk02/size_mb
devices/disk02/blocksize
devices/disk02/read_only
devices/disk02/write_through
devices/disk02/thin_provisioned
devices/disk02/nv_cache
devices/disk02/o_direct
devices/disk02/removable
devices/disk02/filename
devices/disk02/resync_size
devices/disk02/t10_dev_id
devices/disk02/usn
devices/disk03
devices/disk03/type
devices/disk03/exported
devices/disk03/exported/export0
devices/disk03/exported/export1
devices/disk03/dump_prs
devices/disk03/handler
devices/disk03/threads_num
devices/disk03/threads_pool_type
devices/disk03/size_mb
devices/disk03/blocksize
devices/disk03/read_only
devices/disk03/write_through
devices/disk03/thin_provisioned
devices/disk03/nv_cache
devices/disk03/o_direct
devices/disk03/removable
devices/disk03/filename
devices/disk03/resync_size
devices/disk03/t10_dev_id
devices/disk03/usn
devices/disk04
devices/disk04/type
devices/disk04/exported
devices/disk04/exported/export0
devices/disk04/exported/export1
devices/disk04/dump_prs
devices/disk04/handler
devices/disk04/threads_num
devices/disk04/threads_pool_type
devices/disk04/size_mb
devices/disk04/blocksize
devices/disk04/read_only
devices/disk04/write_through
devices/disk04/thin_provisioned
devices/disk04/nv_cache
devices/disk04/o_direct
devices/disk04/removable
devices/disk04/filename
devices/disk04/resync_size
devices/disk04/t10_dev_id
devices/disk04/usn
devices/disk05
devices/disk05/type
devices/disk05/exported
devices/disk05/exported/export0
devices/disk05/exported/export1
devices/disk05/dump_prs
devices/disk05/handler
devices/disk05/threads_num
devices/disk05/threads_pool_type
devices/disk05/size_mb
devices/disk05/blocksize
devices/disk05/read_only
devices/disk05/write_through
devices/disk05/thin_provisioned
devices/disk05/nv_cache
devices/disk05/o_direct
devices/disk05/removable
devices/disk05/filename
devices/disk05/resync_size
devices/disk05/t10_dev_id
devices/disk05/usn
devices/disk06
devices/disk06/type
devices/disk06/exported
devices/disk06/exported/export0
devices/disk06/exported/export1
devices/disk06/dump_prs
devices/disk06/handler
devices/disk06/threads_num
devices/disk06/threads_pool_type
devices/disk06/size_mb
devices/disk06/blocksize
devices/disk06/read_only
devices/disk06/write_through
devices/disk06/thin_provisioned
devices/disk06/nv_cache
devices/disk06/o_direct
devices/disk06/removable
devices/disk06/filename
devices/disk06/resync_size
devices/disk06/t10_dev_id
devices/disk06/usn
devices/disk07
devices/disk07/type
devices/disk07/exported
devices/disk07/exported/export0
devices/disk07/exported/export1
devices/disk07/dump_prs
devices/disk07/handler
devices/disk07/threads_num
devices/disk07/threads_pool_type
devices/disk07/size_mb
devices/disk07/blocksize
devices/disk07/read_only
devices/disk07/write_through
devices/disk07/thin_provisioned
devices/disk07/nv_cache
devices/disk07/o_direct
devices/disk07/removable
devices/disk07/filename
devices/disk07/resync_size
devices/disk07/t10_dev_id
devices/disk07/usn
devices/disk08
devices/disk08/type
devices/disk08/exported
devices/disk08/exported/export0
devices/disk08/exported/export1
devices/disk08/dump_prs
devices/disk08/handler
devices/disk08/threads_num
devices/disk08/threads_pool_type
devices/disk08/size_mb
devices/disk08/blocksize
devices/disk08/read_only
devices/disk08/write_through
devices/disk08/thin_provisioned
devices/disk08/nv_cache
devices/disk08/o_direct
devices/disk08/removable
devices/disk08/filename
devices/disk08/resync_size
devices/disk08/t10_dev_id
devices/disk08/usn
devices/disk09
devices/disk09/type
devices/disk09/exported
devices/disk09/exported/export0
devices/disk09/exported/export1
devices/disk09/dump_prs
devices/disk09/handler
devices/disk09/threads_num
devices/disk09/threads_pool_type
devices/disk09/size_mb
devices/disk09/blocksize
devices/disk09/read_only
devices/disk09/removable
devices/disk09/t10_dev_id
devices/disk09/usn
devices/disk10
devices/disk10/type
devices/disk10/exported
devices/disk10/exported/export0
devices/disk10/exported/export1
devices/disk10/dump_prs
devices/disk10/handler
devices/disk10/threads_num
devices/disk10/threads_pool_type
devices/disk10/size_mb
devices/disk10/blocksize
devices/disk10/read_only
devices/disk10/removable
devices/disk10/t10_dev_id
devices/disk10/usn
sgv
sgv/global_stats
sgv/sgv
sgv/sgv/stats
sgv/sgv-clust
sgv/sgv-clust/stats
sgv/sgv-dma
sgv/sgv-dma/stats
handlers
handlers/vdisk_fileio
handlers/vdisk_fileio/type
handlers/vdisk_fileio/mgmt
handlers/vdisk_fileio/trace_level
handlers/vdisk_fileio/disk01
handlers/vdisk_fileio/disk02
handlers/vdisk_fileio/disk03
handlers/vdisk_fileio/disk04
handlers/vdisk_fileio/disk05
handlers/vdisk_fileio/disk06
handlers/vdisk_fileio/disk07
handlers/vdisk_fileio/disk08
handlers/vdisk_blockio
handlers/vdisk_blockio/type
handlers/vdisk_blockio/mgmt
handlers/vdisk_blockio/trace_level
handlers/vdisk_nullio
handlers/vdisk_nullio/type
handlers/vdisk_nullio/mgmt
handlers/vdisk_nullio/trace_level
handlers/vdisk_nullio/disk09
handlers/vdisk_nullio/disk10
handlers/vcdrom
handlers/vcdrom/type
handlers/vcdrom/mgmt
handlers/vcdrom/trace_level

Bart.
