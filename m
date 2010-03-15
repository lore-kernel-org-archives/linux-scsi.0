From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: [ANNOUNCE][RFC]: New SCST SysFS-based interface become
	fully usable
Date: Mon, 15 Mar 2010 23:03:40 +0300
Message-ID: <4B9E929C.1030205@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: Gal Rosen <galr-KQ2hCNmt5q1Wk0Htik3J/w@public.gmane.org>, James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Andy Yan <ayan-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi All,

I'm glad to announce that new SCST SysFS-based interface has become fully usable, so you can start migrating to it and update your target drivers, dev handlers and management utilities.

>From now on the old ProcFS-based interface as well as iscsi-scst.conf config file and iscsi-scst-adm utility for iSCSI-SCST have become obsoleted.

To get the SysFS-enabled SCST you should download it by command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst/trunk

and then enable the SysFS build (the ProcFS build is going to be default until scstadmin will be updated for the SysFS interface) by:

$ make disable_proc

Here is an example how to configure an iSCSI-SCST target "iqn.2006-10.net.vlnb:tgt" with one virtual FILEIO disk "disk1" using file /disk1 as SCSI device with block size 4K on LUN 0:

modprobe scst
modprobe scst_vdisk

echo "add_device disk1 filename=/disk1; blocksize=1" >/sys/kernel/scst_tgt/handlers/vdisk_fileio/mgmt

service iscsi-scst start

echo "add_target iqn.2006-10.net.vlnb:tgt" >/sys/kernel/scst_tgt/targets/iscsi/mgmt
echo "add disk1 0" >/sys/kernel/scst_tgt/targets/iscsi/iqn.2006-10.net.vlnb:tgt/luns/mgmt

echo 1 >/sys/kernel/scst_tgt/targets/iscsi/iqn.2006-10.net.vlnb:tgt/enabled
echo 1 >/sys/kernel/scst_tgt/targets/iscsi/enabled

The SCST sys/ tree for this example you can find in [2].

The exceptional feature of the new SysFS interface is that it is self-documented, i.e. with it for any management utilities, like scstadmin, there's no need to know anymore how to configure each specific target driver and dev handler. In other words, the management will be made once and will work for all current and future targets and dev handlers, including implemented both in kernel and user spaces, without any internal changes. To achieve that all is necessary is that all target drivers and dev handlers should follow few several simple rules how to represent their internal configuration on the SysFS. Those rules are described in SysfsRules file, which you can see online at http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/SysfsRules. Any comments about it are welcome.

The new SysFS interface is documented in READMEs of SCST core and updated target drivers. At the moment iSCSI-SCST, Qla2x00t, Fcst (FCoE target) and all standard dev handlers are fully SysFS ready. Work on other target drivers as well as work to make scst_user's user space targets match the Sysfs rules is carrying on.

Basically, all target drivers will work as is with the SysFS interface, if they are built in the SysFS build. But they need to implement:

1. "enable" target attribute, if they want race free initial configuration.

2. "mgmt" interface, if they can create virtual targets. For example how to do it, you can see iSCSI-SCST.

Home page of SCST and drivers is http://scst.sourceforge.net

Vlad

[1] Scstadmin is an utility, which allows doing SCST configuration using 
a text config file. Among other, it has the following great facilities:

1. A possibility to apply changes in the config file to currently 
running system. Only changes applied, so there are no any unneeded 
restarts and resets.

2. Generate a config file for currently running system.

[2] The sample SysFS tree with initiator iqn.2005-03.org.open-iscsi:cacdcd2520 connected will be:

/sys/kernel/scst_tgt
|-- devices
|   |-- disk1
|   |   |-- blocksize
|   |   |-- exported
|   |   |   `-- export0 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt/luns/0
|   |   |-- filename
|   |   |-- handler -> ../../handlers/vdisk_fileio
|   |   |-- nv_cache
|   |   |-- o_direct
|   |   |-- read_only
|   |   |-- removable
|   |   |-- resync_size
|   |   |-- size_mb
|   |   |-- t10_dev_id
|   |   |-- type
|   |   |-- usn
|   |   `-- write_through
|-- handlers
|   |-- vcdrom
|   |   |-- mgmt
|   |   |-- trace_level
|   |   `-- type
|   |-- vdisk_blockio
|   |   |-- mgmt
|   |   |-- trace_level
|   |   `-- type
|   |-- vdisk_fileio
|   |   |-- disk1 -> ../../devices/disk1
|   |   |-- mgmt
|   |   |-- trace_level
|   |   `-- type
|   `-- vdisk_nullio
|       |-- mgmt
|       |-- trace_level
|       `-- type
|-- sgv
|   |-- global_stats
|   |-- sgv
|   |   `-- stats
|   |-- sgv-clust
|   |   `-- stats
|   `-- sgv-dma
|       `-- stats
|-- targets
|   `-- iscsi
|       |-- enabled
|       |-- iSNSServer
|       |-- iqn.2006-10.net.vlnb:tgt
|       |   |-- DataDigest
|       |   |-- FirstBurstLength
|       |   |-- HeaderDigest
|       |   |-- ImmediateData
|       |   |-- InitialR2T
|       |   |-- MaxBurstLength
|       |   |-- MaxOutstandingR2T
|       |   |-- MaxRecvDataSegmentLength
|       |   |-- MaxXmitDataSegmentLength
|       |   |-- NopInInterval
|       |   |-- QueuedCommands
|       |   |-- RspTimeout
|       |   |-- enabled
|       |   |-- ini_groups
|       |   |   `-- mgmt
|       |   |-- luns
|       |   |   |-- 0
|       |   |   |   |-- device -> ../../../../../devices/disk1
|       |   |   |   `-- read_only
|       |   |   `-- mgmt
|       |   |-- rel_tgt_id
|       |   |-- sessions
|       |   |   `-- iqn.2005-03.org.open-iscsi:cacdcd2520
|       |   |       |-- 10.170.75.2
|       |   |       |   |-- cid
|       |   |       |   |-- ip
|       |   |       |   `-- state
|       |   |       |-- DataDigest
|       |   |       |-- FirstBurstLength
|       |   |       |-- HeaderDigest
|       |   |       |-- ImmediateData
|       |   |       |-- InitialR2T
|       |   |       |-- MaxBurstLength
|       |   |       |-- MaxOutstandingR2T
|       |   |       |-- MaxRecvDataSegmentLength
|       |   |       |-- MaxXmitDataSegmentLength
|       |   |       |-- active_commands
|       |   |       |-- commands
|       |   |       |-- force_close
|       |   |       |-- initiator_name
|       |   |       |-- luns -> ../../luns
|       |   |       |-- reinstating
|       |   |       `-- sid
|       |   `-- tid
|       |-- mgmt
|       |-- open_state
|       |-- trace_level
|       `-- version
|-- threads
|-- trace_level
`-- version
