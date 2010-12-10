From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 10 Dec 2010 13:06:06 +0100
Message-ID: <AANLkTimJo_ZtQ3uVEBv864pP9f9AZR3D_o0R7T-B3fWL@mail.gmail.com>
References: <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com>
 <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com>
 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
 <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com> <4CE2846C.6070501@vlnb.net>
 <4CE59482.3050002@gmail.com> <20101118214619.GA29097@kroah.com>
 <4CE6BB4A.5060606@gmail.com> <20101119211904.GB28606@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101119211904.GB28606@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vvvvvst@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 19, 2010 at 10:19 PM, Greg KH <greg@kroah.com> wrote:
> [ ... ]
>
> None. =A0Use 'struct device'

How about using 'struct device' as follows ?
* Move /sys/kernel/scst_tgt/targets to /sys/class/target_driver.
* Move /sys/kernel/scst_tgt/handlers to /sys/class/device_driver.
* Move /sys/kernel/scst_tgt/devices to /sys/class/target_device.
* Move the attributes of /sys/kernel/scst_tgt to /sys/devices/scst.
* Move /sys/kernel/scst_tgt/sgv to /sys/devices/scst/sgv

Some quickly hacked up code (that needs further polishing) that
implements this scheme can be found here:
https://scst.svn.sourceforge.net/svnroot/scst/branches/sysfs-tree-chang=
es.

An example of an SCST configuration file and the corresponding sysfs hi=
erarchy:

# uname -r
2.6.37-rc5-scst+

# cat /etc/scst.conf
HANDLER vdisk_blockio {
	DEVICE disk01 {
		filename /dev/ram0
		nv_cache 1
	}
	DEVICE disk02 {
		filename /dev/ram1
		nv_cache 1
	}
}

HANDLER vdisk_fileio {
	DEVICE disk03 {
		filename /dev/vdisk
		nv_cache 1
	}
	DEVICE disk04 {
		filename /dev/vdisk
		nv_cache 1
	}
}

HANDLER vdisk_nullio {
	DEVICE disk05
	DEVICE disk06
}

TARGET_DRIVER scst_local {
	TARGET local {
		session_name local

		LUN 0 disk01
		LUN 1 disk02
		LUN 2 disk03
		LUN 3 disk04
		LUN 4 disk05
		LUN 5 disk06
	}
}

TARGET_DRIVER ib_srpt {
	TARGET ib_srpt_target_0 {
		rel_tgt_id 1
		enabled 1

		LUN 0 disk01
		LUN 1 disk02
		LUN 2 disk03
		LUN 3 disk04
		LUN 4 disk05
		LUN 5 disk06
	}

	TARGET ib_srpt_target_1 {
		rel_tgt_id 2
		enabled 1

		LUN 0 disk01
		LUN 1 disk02
		LUN 2 disk03
		LUN 3 disk04
		LUN 4 disk05
		LUN 5 disk06
	}
}

TARGET_DRIVER iscsi {
	enabled 1

	TARGET iqn.2005-03.org.open-iscsi:dbc01e1792b:storage {
		rel_tgt_id 4
		LUN 0 disk01
		LUN 1 disk02
		LUN 2 disk03
		LUN 3 disk04
		LUN 4 disk05
		LUN 5 disk06
		enabled 1
	}
}

# find /sys/{class,devices/virtual}/{target_driver,device_driver,target=
_device}
/sys/devices/scst | while read f; do if [ -h $f ]; then echo "$f ->
$(readlink $f)"; else echo "$f"; fi; done
/sys/class/target_driver
/sys/class/target_driver/iscsi -> ../../devices/virtual/target_driver/i=
scsi
/sys/class/target_driver/ib_srpt -> ../../devices/virtual/target_driver=
/ib_srpt
/sys/class/target_driver/scst_local ->
=2E./../devices/virtual/target_driver/scst_local
/sys/class/device_driver
/sys/class/device_driver/dev_disk_perf ->
=2E./../devices/virtual/device_driver/dev_disk_perf
/sys/class/device_driver/dev_disk ->
=2E./../devices/virtual/device_driver/dev_disk
/sys/class/device_driver/vdisk_fileio ->
=2E./../devices/virtual/device_driver/vdisk_fileio
/sys/class/device_driver/vdisk_blockio ->
=2E./../devices/virtual/device_driver/vdisk_blockio
/sys/class/device_driver/vdisk_nullio ->
=2E./../devices/virtual/device_driver/vdisk_nullio
/sys/class/device_driver/vcdrom -> ../../devices/virtual/device_driver/=
vcdrom
/sys/class/target_device
/sys/class/target_device/disk01 -> ../../devices/virtual/target_device/=
disk01
/sys/class/target_device/2:0:0:0 -> ../../devices/virtual/target_device=
/2:0:0:0
/sys/class/target_device/2:0:1:0 -> ../../devices/virtual/target_device=
/2:0:1:0
/sys/class/target_device/3:0:0:0 -> ../../devices/virtual/target_device=
/3:0:0:0
/sys/class/target_device/disk02 -> ../../devices/virtual/target_device/=
disk02
/sys/class/target_device/disk03 -> ../../devices/virtual/target_device/=
disk03
/sys/class/target_device/disk04 -> ../../devices/virtual/target_device/=
disk04
/sys/class/target_device/disk05 -> ../../devices/virtual/target_device/=
disk05
/sys/class/target_device/disk06 -> ../../devices/virtual/target_device/=
disk06
/sys/devices/virtual/target_driver
/sys/devices/virtual/target_driver/iscsi
/sys/devices/virtual/target_driver/iscsi/iSNSServer
/sys/devices/virtual/target_driver/iscsi/enabled
/sys/devices/virtual/target_driver/iscsi/uevent
/sys/devices/virtual/target_driver/iscsi/subsystem ->
=2E./../../../class/target_driver
/sys/devices/virtual/target_driver/iscsi/power
/sys/devices/virtual/target_driver/iscsi/power/wakeup
/sys/devices/virtual/target_driver/iscsi/power/wakeup_count
/sys/devices/virtual/target_driver/iscsi/power/wakeup_active_count
/sys/devices/virtual/target_driver/iscsi/power/wakeup_hit_count
/sys/devices/virtual/target_driver/iscsi/power/wakeup_active
/sys/devices/virtual/target_driver/iscsi/power/wakeup_total_time_ms
/sys/devices/virtual/target_driver/iscsi/power/wakeup_max_time_ms
/sys/devices/virtual/target_driver/iscsi/power/wakeup_last_time_ms
/sys/devices/virtual/target_driver/iscsi/power/runtime_status
/sys/devices/virtual/target_driver/iscsi/power/control
/sys/devices/virtual/target_driver/iscsi/power/runtime_suspended_time
/sys/devices/virtual/target_driver/iscsi/power/runtime_active_time
/sys/devices/virtual/target_driver/iscsi/power/autosuspend_delay_ms
/sys/devices/virtual/target_driver/iscsi/add_target_parameters
/sys/devices/virtual/target_driver/iscsi/driver_attributes
/sys/devices/virtual/target_driver/iscsi/target_attributes
/sys/devices/virtual/target_driver/iscsi/version
/sys/devices/virtual/target_driver/iscsi/open_state
/sys/devices/virtual/target_driver/iscsi/trace_level
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/uevent
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/subsystem
-> ../../../../../class/target_instance
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/device
-> ../../iscsi
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup_count
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup_active_count
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup_hit_count
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup_active
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup_total_time_ms
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup_max_time_ms
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/wakeup_last_time_ms
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/runtime_status
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/control
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/runtime_suspended_time
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/runtime_active_time
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/power/autosuspend_delay_ms
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/enabled
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/commands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/active_co=
mmands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/initiator=
_name
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/InitialR2=
T
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/Immediate=
Data
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/MaxRecvDa=
taSegmentLength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/MaxXmitDa=
taSegmentLength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/MaxBurstL=
ength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/FirstBurs=
tLength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/MaxOutsta=
ndingR2T
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/HeaderDig=
est
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/DataDiges=
t
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/sid
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/reinstati=
ng
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/force_clo=
se
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/luns
-> ../../luns
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun0
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun0/acti=
ve_commands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun1
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun1/acti=
ve_commands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun2
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun2/acti=
ve_commands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun3
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun3/acti=
ve_commands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun4
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun4/acti=
ve_commands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun5
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/lun5/acti=
ve_commands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/192.168.2=
=2E6
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/192.168.2=
=2E6/state
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/192.168.2=
=2E6/cid
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/sessions/iqn.1996-04.de.suse:01:e4bde122139a/192.168.2=
=2E6/ip
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/parameters
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/0
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/0/read_only
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/0/device
-> ../../../../../target_device/disk01
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/1
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/1/read_only
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/1/device
-> ../../../../../target_device/disk02
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/2
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/2/read_only
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/2/device
-> ../../../../../target_device/disk03
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/3
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/3/read_only
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/3/device
-> ../../../../../target_device/disk04
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/4
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/4/read_only
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/4/device
-> ../../../../../target_device/disk05
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/5
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/5/read_only
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/luns/5/device
-> ../../../../../target_device/disk06
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/ini_groups
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/rel_tgt_id
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/addr_method
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/io_grouping_type
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/cpu_mask
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/tid
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/per_portal_acl
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/redirect
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/InitialR2T
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/ImmediateData
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/MaxRecvDataSegmentLength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/MaxXmitDataSegmentLength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/MaxBurstLength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/FirstBurstLength
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/MaxOutstandingR2T
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/HeaderDigest
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/DataDigest
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/QueuedCommands
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/RspTimeout
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/NopInInterval
/sys/devices/virtual/target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc=
01e1792b:storage/MaxSessions
/sys/devices/virtual/target_driver/ib_srpt
/sys/devices/virtual/target_driver/ib_srpt/uevent
/sys/devices/virtual/target_driver/ib_srpt/subsystem ->
=2E./../../../class/target_driver
/sys/devices/virtual/target_driver/ib_srpt/power
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup_count
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup_active_count
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup_hit_count
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup_active
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup_total_time_ms
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup_max_time_ms
/sys/devices/virtual/target_driver/ib_srpt/power/wakeup_last_time_ms
/sys/devices/virtual/target_driver/ib_srpt/power/runtime_status
/sys/devices/virtual/target_driver/ib_srpt/power/control
/sys/devices/virtual/target_driver/ib_srpt/power/runtime_suspended_time
/sys/devices/virtual/target_driver/ib_srpt/power/runtime_active_time
/sys/devices/virtual/target_driver/ib_srpt/power/autosuspend_delay_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/uevent
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/subsystem
-> ../../../../../class/target_instance
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/device ->
=2E./../ib_srpt
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p_count
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p_active_count
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p_hit_count
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p_active
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p_total_time_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p_max_time_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/wakeu=
p_last_time_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/runti=
me_status
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/contr=
ol
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/runti=
me_suspended_time
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/runti=
me_active_time
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/power/autos=
uspend_delay_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/enabled
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/active_commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/initiator_name
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/req_lim
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/req_lim_delta
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/luns
-> ../../luns
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun0
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun0/active_commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun1
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun1/active_commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun2
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun2/active_commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun3
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun3/active_commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun4
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun4/active_commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun5
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/sessions/0x=
00000000000000000002c9030005f34b/lun5/active_commands
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/parame=
ters
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/0
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/0/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/0/devi=
ce
-> ../../../../../target_device/disk01
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/1
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/1/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/1/devi=
ce
-> ../../../../../target_device/disk02
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/2
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/2/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/2/devi=
ce
-> ../../../../../target_device/disk03
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/3
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/3/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/3/devi=
ce
-> ../../../../../target_device/disk04
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/4
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/4/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/4/devi=
ce
-> ../../../../../target_device/disk05
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/5
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/5/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/luns/5/devi=
ce
-> ../../../../../target_device/disk06
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/ini_groups
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/rel_tgt_id
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/addr_method
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/io_grouping=
_type
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/cpu_mask
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_0/login_info
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/uevent
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/subsystem
-> ../../../../../class/target_instance
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/device ->
=2E./../ib_srpt
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p_count
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p_active_count
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p_hit_count
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p_active
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p_total_time_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p_max_time_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/wakeu=
p_last_time_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/runti=
me_status
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/contr=
ol
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/runti=
me_suspended_time
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/runti=
me_active_time
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/power/autos=
uspend_delay_ms
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/enabled
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/sessions
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/parame=
ters
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/0
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/0/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/0/devi=
ce
-> ../../../../../target_device/disk01
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/1
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/1/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/1/devi=
ce
-> ../../../../../target_device/disk02
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/2
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/2/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/2/devi=
ce
-> ../../../../../target_device/disk03
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/3
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/3/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/3/devi=
ce
-> ../../../../../target_device/disk04
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/4
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/4/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/4/devi=
ce
-> ../../../../../target_device/disk05
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/5
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/5/read=
_only
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/luns/5/devi=
ce
-> ../../../../../target_device/disk06
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/ini_groups
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/rel_tgt_id
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/addr_method
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/io_grouping=
_type
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/cpu_mask
/sys/devices/virtual/target_driver/ib_srpt/ib_srpt_target_1/login_info
/sys/devices/virtual/target_driver/scst_local
/sys/devices/virtual/target_driver/scst_local/uevent
/sys/devices/virtual/target_driver/scst_local/subsystem ->
=2E./../../../class/target_driver
/sys/devices/virtual/target_driver/scst_local/power
/sys/devices/virtual/target_driver/scst_local/power/wakeup
/sys/devices/virtual/target_driver/scst_local/power/wakeup_count
/sys/devices/virtual/target_driver/scst_local/power/wakeup_active_count
/sys/devices/virtual/target_driver/scst_local/power/wakeup_hit_count
/sys/devices/virtual/target_driver/scst_local/power/wakeup_active
/sys/devices/virtual/target_driver/scst_local/power/wakeup_total_time_m=
s
/sys/devices/virtual/target_driver/scst_local/power/wakeup_max_time_ms
/sys/devices/virtual/target_driver/scst_local/power/wakeup_last_time_ms
/sys/devices/virtual/target_driver/scst_local/power/runtime_status
/sys/devices/virtual/target_driver/scst_local/power/control
/sys/devices/virtual/target_driver/scst_local/power/runtime_suspended_t=
ime
/sys/devices/virtual/target_driver/scst_local/power/runtime_active_time
/sys/devices/virtual/target_driver/scst_local/power/autosuspend_delay_m=
s
/sys/devices/virtual/target_driver/scst_local/add_target_parameters
/sys/devices/virtual/target_driver/scst_local/version
/sys/devices/virtual/target_driver/scst_local/stats
/sys/devices/virtual/target_driver/scst_local/trace_level
/sys/devices/virtual/target_driver/scst_local/local
/sys/devices/virtual/target_driver/scst_local/local/uevent
/sys/devices/virtual/target_driver/scst_local/local/subsystem ->
=2E./../../../../class/target_instance
/sys/devices/virtual/target_driver/scst_local/local/device -> ../../scs=
t_local
/sys/devices/virtual/target_driver/scst_local/local/power
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup_count
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup_active=
_count
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup_hit_co=
unt
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup_active
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup_total_=
time_ms
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup_max_ti=
me_ms
/sys/devices/virtual/target_driver/scst_local/local/power/wakeup_last_t=
ime_ms
/sys/devices/virtual/target_driver/scst_local/local/power/runtime_statu=
s
/sys/devices/virtual/target_driver/scst_local/local/power/control
/sys/devices/virtual/target_driver/scst_local/local/power/runtime_suspe=
nded_time
/sys/devices/virtual/target_driver/scst_local/local/power/runtime_activ=
e_time
/sys/devices/virtual/target_driver/scst_local/local/power/autosuspend_d=
elay_ms
/sys/devices/virtual/target_driver/scst_local/local/sessions
/sys/devices/virtual/target_driver/scst_local/local/sessions/local
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/comm=
ands
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/acti=
ve_commands
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/init=
iator_name
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/tran=
sport_id
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/luns
-> ../../luns
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/host
-> ../../../../../../scst_local/local/host8/scsi_host/host8
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun0
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun0=
/active_commands
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun1
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun1=
/active_commands
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun2
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun2=
/active_commands
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun3
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun3=
/active_commands
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun4
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun4=
/active_commands
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun5
/sys/devices/virtual/target_driver/scst_local/local/sessions/local/lun5=
/active_commands
/sys/devices/virtual/target_driver/scst_local/local/luns
/sys/devices/virtual/target_driver/scst_local/local/luns/parameters
/sys/devices/virtual/target_driver/scst_local/local/luns/0
/sys/devices/virtual/target_driver/scst_local/local/luns/0/read_only
/sys/devices/virtual/target_driver/scst_local/local/luns/0/device ->
=2E./../../../../target_device/disk01
/sys/devices/virtual/target_driver/scst_local/local/luns/1
/sys/devices/virtual/target_driver/scst_local/local/luns/1/read_only
/sys/devices/virtual/target_driver/scst_local/local/luns/1/device ->
=2E./../../../../target_device/disk02
/sys/devices/virtual/target_driver/scst_local/local/luns/2
/sys/devices/virtual/target_driver/scst_local/local/luns/2/read_only
/sys/devices/virtual/target_driver/scst_local/local/luns/2/device ->
=2E./../../../../target_device/disk03
/sys/devices/virtual/target_driver/scst_local/local/luns/3
/sys/devices/virtual/target_driver/scst_local/local/luns/3/read_only
/sys/devices/virtual/target_driver/scst_local/local/luns/3/device ->
=2E./../../../../target_device/disk04
/sys/devices/virtual/target_driver/scst_local/local/luns/4
/sys/devices/virtual/target_driver/scst_local/local/luns/4/read_only
/sys/devices/virtual/target_driver/scst_local/local/luns/4/device ->
=2E./../../../../target_device/disk05
/sys/devices/virtual/target_driver/scst_local/local/luns/5
/sys/devices/virtual/target_driver/scst_local/local/luns/5/read_only
/sys/devices/virtual/target_driver/scst_local/local/luns/5/device ->
=2E./../../../../target_device/disk06
/sys/devices/virtual/target_driver/scst_local/local/ini_groups
/sys/devices/virtual/target_driver/scst_local/local/rel_tgt_id
/sys/devices/virtual/target_driver/scst_local/local/addr_method
/sys/devices/virtual/target_driver/scst_local/local/io_grouping_type
/sys/devices/virtual/target_driver/scst_local/local/cpu_mask
/sys/devices/virtual/target_driver/scst_local/local/scsi_transport_vers=
ion
/sys/devices/virtual/target_driver/scst_local/local/phys_transport_vers=
ion
/sys/devices/virtual/device_driver
/sys/devices/virtual/device_driver/dev_disk_perf
/sys/devices/virtual/device_driver/dev_disk_perf/uevent
/sys/devices/virtual/device_driver/dev_disk_perf/subsystem ->
=2E./../../../class/device_driver
/sys/devices/virtual/device_driver/dev_disk_perf/type
/sys/devices/virtual/device_driver/dev_disk_perf/power
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup_count
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup_active_co=
unt
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup_hit_count
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup_active
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup_total_tim=
e_ms
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup_max_time_=
ms
/sys/devices/virtual/device_driver/dev_disk_perf/power/wakeup_last_time=
_ms
/sys/devices/virtual/device_driver/dev_disk_perf/power/runtime_status
/sys/devices/virtual/device_driver/dev_disk_perf/power/control
/sys/devices/virtual/device_driver/dev_disk_perf/power/runtime_suspende=
d_time
/sys/devices/virtual/device_driver/dev_disk_perf/power/runtime_active_t=
ime
/sys/devices/virtual/device_driver/dev_disk_perf/power/autosuspend_dela=
y_ms
/sys/devices/virtual/device_driver/dev_disk_perf/trace_level
/sys/devices/virtual/device_driver/dev_disk
/sys/devices/virtual/device_driver/dev_disk/trace_level
/sys/devices/virtual/device_driver/dev_disk/uevent
/sys/devices/virtual/device_driver/dev_disk/subsystem ->
=2E./../../../class/device_driver
/sys/devices/virtual/device_driver/dev_disk/type
/sys/devices/virtual/device_driver/dev_disk/power
/sys/devices/virtual/device_driver/dev_disk/power/wakeup
/sys/devices/virtual/device_driver/dev_disk/power/wakeup_count
/sys/devices/virtual/device_driver/dev_disk/power/wakeup_active_count
/sys/devices/virtual/device_driver/dev_disk/power/wakeup_hit_count
/sys/devices/virtual/device_driver/dev_disk/power/wakeup_active
/sys/devices/virtual/device_driver/dev_disk/power/wakeup_total_time_ms
/sys/devices/virtual/device_driver/dev_disk/power/wakeup_max_time_ms
/sys/devices/virtual/device_driver/dev_disk/power/wakeup_last_time_ms
/sys/devices/virtual/device_driver/dev_disk/power/runtime_status
/sys/devices/virtual/device_driver/dev_disk/power/control
/sys/devices/virtual/device_driver/dev_disk/power/runtime_suspended_tim=
e
/sys/devices/virtual/device_driver/dev_disk/power/runtime_active_time
/sys/devices/virtual/device_driver/dev_disk/power/autosuspend_delay_ms
/sys/devices/virtual/device_driver/vdisk_fileio
/sys/devices/virtual/device_driver/vdisk_fileio/uevent
/sys/devices/virtual/device_driver/vdisk_fileio/subsystem ->
=2E./../../../class/device_driver
/sys/devices/virtual/device_driver/vdisk_fileio/type
/sys/devices/virtual/device_driver/vdisk_fileio/power
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup_count
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup_active_cou=
nt
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup_hit_count
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup_active
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup_total_time=
_ms
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup_max_time_m=
s
/sys/devices/virtual/device_driver/vdisk_fileio/power/wakeup_last_time_=
ms
/sys/devices/virtual/device_driver/vdisk_fileio/power/runtime_status
/sys/devices/virtual/device_driver/vdisk_fileio/power/control
/sys/devices/virtual/device_driver/vdisk_fileio/power/runtime_suspended=
_time
/sys/devices/virtual/device_driver/vdisk_fileio/power/runtime_active_ti=
me
/sys/devices/virtual/device_driver/vdisk_fileio/power/autosuspend_delay=
_ms
/sys/devices/virtual/device_driver/vdisk_fileio/add_device_parameters
/sys/devices/virtual/device_driver/vdisk_fileio/trace_level
/sys/devices/virtual/device_driver/vdisk_fileio/disk03 ->
=2E./../target_device/disk03
/sys/devices/virtual/device_driver/vdisk_fileio/disk04 ->
=2E./../target_device/disk04
/sys/devices/virtual/device_driver/vdisk_blockio
/sys/devices/virtual/device_driver/vdisk_blockio/uevent
/sys/devices/virtual/device_driver/vdisk_blockio/subsystem ->
=2E./../../../class/device_driver
/sys/devices/virtual/device_driver/vdisk_blockio/type
/sys/devices/virtual/device_driver/vdisk_blockio/power
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup_count
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup_active_co=
unt
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup_hit_count
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup_active
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup_total_tim=
e_ms
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup_max_time_=
ms
/sys/devices/virtual/device_driver/vdisk_blockio/power/wakeup_last_time=
_ms
/sys/devices/virtual/device_driver/vdisk_blockio/power/runtime_status
/sys/devices/virtual/device_driver/vdisk_blockio/power/control
/sys/devices/virtual/device_driver/vdisk_blockio/power/runtime_suspende=
d_time
/sys/devices/virtual/device_driver/vdisk_blockio/power/runtime_active_t=
ime
/sys/devices/virtual/device_driver/vdisk_blockio/power/autosuspend_dela=
y_ms
/sys/devices/virtual/device_driver/vdisk_blockio/add_device_parameters
/sys/devices/virtual/device_driver/vdisk_blockio/trace_level
/sys/devices/virtual/device_driver/vdisk_blockio/disk01 ->
=2E./../target_device/disk01
/sys/devices/virtual/device_driver/vdisk_blockio/disk02 ->
=2E./../target_device/disk02
/sys/devices/virtual/device_driver/vdisk_nullio
/sys/devices/virtual/device_driver/vdisk_nullio/uevent
/sys/devices/virtual/device_driver/vdisk_nullio/subsystem ->
=2E./../../../class/device_driver
/sys/devices/virtual/device_driver/vdisk_nullio/type
/sys/devices/virtual/device_driver/vdisk_nullio/power
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup_count
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup_active_cou=
nt
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup_hit_count
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup_active
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup_total_time=
_ms
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup_max_time_m=
s
/sys/devices/virtual/device_driver/vdisk_nullio/power/wakeup_last_time_=
ms
/sys/devices/virtual/device_driver/vdisk_nullio/power/runtime_status
/sys/devices/virtual/device_driver/vdisk_nullio/power/control
/sys/devices/virtual/device_driver/vdisk_nullio/power/runtime_suspended=
_time
/sys/devices/virtual/device_driver/vdisk_nullio/power/runtime_active_ti=
me
/sys/devices/virtual/device_driver/vdisk_nullio/power/autosuspend_delay=
_ms
/sys/devices/virtual/device_driver/vdisk_nullio/add_device_parameters
/sys/devices/virtual/device_driver/vdisk_nullio/trace_level
/sys/devices/virtual/device_driver/vdisk_nullio/disk05 ->
=2E./../target_device/disk05
/sys/devices/virtual/device_driver/vdisk_nullio/disk06 ->
=2E./../target_device/disk06
/sys/devices/virtual/device_driver/vcdrom
/sys/devices/virtual/device_driver/vcdrom/uevent
/sys/devices/virtual/device_driver/vcdrom/subsystem ->
=2E./../../../class/device_driver
/sys/devices/virtual/device_driver/vcdrom/type
/sys/devices/virtual/device_driver/vcdrom/power
/sys/devices/virtual/device_driver/vcdrom/power/wakeup
/sys/devices/virtual/device_driver/vcdrom/power/wakeup_count
/sys/devices/virtual/device_driver/vcdrom/power/wakeup_active_count
/sys/devices/virtual/device_driver/vcdrom/power/wakeup_hit_count
/sys/devices/virtual/device_driver/vcdrom/power/wakeup_active
/sys/devices/virtual/device_driver/vcdrom/power/wakeup_total_time_ms
/sys/devices/virtual/device_driver/vcdrom/power/wakeup_max_time_ms
/sys/devices/virtual/device_driver/vcdrom/power/wakeup_last_time_ms
/sys/devices/virtual/device_driver/vcdrom/power/runtime_status
/sys/devices/virtual/device_driver/vcdrom/power/control
/sys/devices/virtual/device_driver/vcdrom/power/runtime_suspended_time
/sys/devices/virtual/device_driver/vcdrom/power/runtime_active_time
/sys/devices/virtual/device_driver/vcdrom/power/autosuspend_delay_ms
/sys/devices/virtual/device_driver/vcdrom/trace_level
/sys/devices/virtual/target_device
/sys/devices/virtual/target_device/disk01
/sys/devices/virtual/target_device/disk01/uevent
/sys/devices/virtual/target_device/disk01/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/disk01/type
/sys/devices/virtual/target_device/disk01/power
/sys/devices/virtual/target_device/disk01/power/wakeup
/sys/devices/virtual/target_device/disk01/power/wakeup_count
/sys/devices/virtual/target_device/disk01/power/wakeup_active_count
/sys/devices/virtual/target_device/disk01/power/wakeup_hit_count
/sys/devices/virtual/target_device/disk01/power/wakeup_active
/sys/devices/virtual/target_device/disk01/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/disk01/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/disk01/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/disk01/power/runtime_status
/sys/devices/virtual/target_device/disk01/power/control
/sys/devices/virtual/target_device/disk01/power/runtime_suspended_time
/sys/devices/virtual/target_device/disk01/power/runtime_active_time
/sys/devices/virtual/target_device/disk01/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/disk01/exported
/sys/devices/virtual/target_device/disk01/exported/export0 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_0/luns/0
/sys/devices/virtual/target_device/disk01/exported/export1 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_1/luns/0
/sys/devices/virtual/target_device/disk01/exported/export2 ->
=2E./../../target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:s=
torage/luns/0
/sys/devices/virtual/target_device/disk01/exported/export3 ->
=2E./../../target_driver/scst_local/local/luns/0
/sys/devices/virtual/target_device/disk01/dump_prs
/sys/devices/virtual/target_device/disk01/handler ->
=2E./../device_driver/vdisk_blockio
/sys/devices/virtual/target_device/disk01/threads_num
/sys/devices/virtual/target_device/disk01/threads_pool_type
/sys/devices/virtual/target_device/disk01/size_mb
/sys/devices/virtual/target_device/disk01/blocksize
/sys/devices/virtual/target_device/disk01/read_only
/sys/devices/virtual/target_device/disk01/nv_cache
/sys/devices/virtual/target_device/disk01/removable
/sys/devices/virtual/target_device/disk01/filename
/sys/devices/virtual/target_device/disk01/resync_size
/sys/devices/virtual/target_device/disk01/t10_dev_id
/sys/devices/virtual/target_device/disk01/usn
/sys/devices/virtual/target_device/disk01/thin_provisioned
/sys/devices/virtual/target_device/2:0:0:0
/sys/devices/virtual/target_device/2:0:0:0/exported
/sys/devices/virtual/target_device/2:0:0:0/scsi_device ->
=2E./../../pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/scsi_devic=
e/2:0:0:0
/sys/devices/virtual/target_device/2:0:0:0/uevent
/sys/devices/virtual/target_device/2:0:0:0/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/2:0:0:0/type
/sys/devices/virtual/target_device/2:0:0:0/power
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup_count
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup_active_count
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup_hit_count
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup_active
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/2:0:0:0/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/2:0:0:0/power/runtime_status
/sys/devices/virtual/target_device/2:0:0:0/power/control
/sys/devices/virtual/target_device/2:0:0:0/power/runtime_suspended_time
/sys/devices/virtual/target_device/2:0:0:0/power/runtime_active_time
/sys/devices/virtual/target_device/2:0:0:0/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/2:0:1:0
/sys/devices/virtual/target_device/2:0:1:0/uevent
/sys/devices/virtual/target_device/2:0:1:0/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/2:0:1:0/type
/sys/devices/virtual/target_device/2:0:1:0/power
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup_count
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup_active_count
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup_hit_count
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup_active
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/2:0:1:0/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/2:0:1:0/power/runtime_status
/sys/devices/virtual/target_device/2:0:1:0/power/control
/sys/devices/virtual/target_device/2:0:1:0/power/runtime_suspended_time
/sys/devices/virtual/target_device/2:0:1:0/power/runtime_active_time
/sys/devices/virtual/target_device/2:0:1:0/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/2:0:1:0/exported
/sys/devices/virtual/target_device/2:0:1:0/scsi_device ->
=2E./../../pci0000:00/0000:00:1f.2/host2/target2:0:1/2:0:1:0/scsi_devic=
e/2:0:1:0
/sys/devices/virtual/target_device/3:0:0:0
/sys/devices/virtual/target_device/3:0:0:0/uevent
/sys/devices/virtual/target_device/3:0:0:0/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/3:0:0:0/type
/sys/devices/virtual/target_device/3:0:0:0/power
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup_count
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup_active_count
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup_hit_count
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup_active
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/3:0:0:0/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/3:0:0:0/power/runtime_status
/sys/devices/virtual/target_device/3:0:0:0/power/control
/sys/devices/virtual/target_device/3:0:0:0/power/runtime_suspended_time
/sys/devices/virtual/target_device/3:0:0:0/power/runtime_active_time
/sys/devices/virtual/target_device/3:0:0:0/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/3:0:0:0/exported
/sys/devices/virtual/target_device/3:0:0:0/scsi_device ->
=2E./../../pci0000:00/0000:00:1f.2/host3/target3:0:0/3:0:0:0/scsi_devic=
e/3:0:0:0
/sys/devices/virtual/target_device/disk02
/sys/devices/virtual/target_device/disk02/uevent
/sys/devices/virtual/target_device/disk02/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/disk02/type
/sys/devices/virtual/target_device/disk02/power
/sys/devices/virtual/target_device/disk02/power/wakeup
/sys/devices/virtual/target_device/disk02/power/wakeup_count
/sys/devices/virtual/target_device/disk02/power/wakeup_active_count
/sys/devices/virtual/target_device/disk02/power/wakeup_hit_count
/sys/devices/virtual/target_device/disk02/power/wakeup_active
/sys/devices/virtual/target_device/disk02/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/disk02/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/disk02/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/disk02/power/runtime_status
/sys/devices/virtual/target_device/disk02/power/control
/sys/devices/virtual/target_device/disk02/power/runtime_suspended_time
/sys/devices/virtual/target_device/disk02/power/runtime_active_time
/sys/devices/virtual/target_device/disk02/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/disk02/exported
/sys/devices/virtual/target_device/disk02/exported/export0 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_0/luns/1
/sys/devices/virtual/target_device/disk02/exported/export1 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_1/luns/1
/sys/devices/virtual/target_device/disk02/exported/export2 ->
=2E./../../target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:s=
torage/luns/1
/sys/devices/virtual/target_device/disk02/exported/export3 ->
=2E./../../target_driver/scst_local/local/luns/1
/sys/devices/virtual/target_device/disk02/dump_prs
/sys/devices/virtual/target_device/disk02/handler ->
=2E./../device_driver/vdisk_blockio
/sys/devices/virtual/target_device/disk02/threads_num
/sys/devices/virtual/target_device/disk02/threads_pool_type
/sys/devices/virtual/target_device/disk02/size_mb
/sys/devices/virtual/target_device/disk02/blocksize
/sys/devices/virtual/target_device/disk02/read_only
/sys/devices/virtual/target_device/disk02/nv_cache
/sys/devices/virtual/target_device/disk02/removable
/sys/devices/virtual/target_device/disk02/filename
/sys/devices/virtual/target_device/disk02/resync_size
/sys/devices/virtual/target_device/disk02/t10_dev_id
/sys/devices/virtual/target_device/disk02/usn
/sys/devices/virtual/target_device/disk02/thin_provisioned
/sys/devices/virtual/target_device/disk03
/sys/devices/virtual/target_device/disk03/uevent
/sys/devices/virtual/target_device/disk03/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/disk03/type
/sys/devices/virtual/target_device/disk03/power
/sys/devices/virtual/target_device/disk03/power/wakeup
/sys/devices/virtual/target_device/disk03/power/wakeup_count
/sys/devices/virtual/target_device/disk03/power/wakeup_active_count
/sys/devices/virtual/target_device/disk03/power/wakeup_hit_count
/sys/devices/virtual/target_device/disk03/power/wakeup_active
/sys/devices/virtual/target_device/disk03/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/disk03/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/disk03/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/disk03/power/runtime_status
/sys/devices/virtual/target_device/disk03/power/control
/sys/devices/virtual/target_device/disk03/power/runtime_suspended_time
/sys/devices/virtual/target_device/disk03/power/runtime_active_time
/sys/devices/virtual/target_device/disk03/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/disk03/exported
/sys/devices/virtual/target_device/disk03/exported/export0 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_0/luns/2
/sys/devices/virtual/target_device/disk03/exported/export1 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_1/luns/2
/sys/devices/virtual/target_device/disk03/exported/export2 ->
=2E./../../target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:s=
torage/luns/2
/sys/devices/virtual/target_device/disk03/exported/export3 ->
=2E./../../target_driver/scst_local/local/luns/2
/sys/devices/virtual/target_device/disk03/dump_prs
/sys/devices/virtual/target_device/disk03/handler ->
=2E./../device_driver/vdisk_fileio
/sys/devices/virtual/target_device/disk03/threads_num
/sys/devices/virtual/target_device/disk03/threads_pool_type
/sys/devices/virtual/target_device/disk03/size_mb
/sys/devices/virtual/target_device/disk03/blocksize
/sys/devices/virtual/target_device/disk03/read_only
/sys/devices/virtual/target_device/disk03/write_through
/sys/devices/virtual/target_device/disk03/thin_provisioned
/sys/devices/virtual/target_device/disk03/nv_cache
/sys/devices/virtual/target_device/disk03/o_direct
/sys/devices/virtual/target_device/disk03/removable
/sys/devices/virtual/target_device/disk03/filename
/sys/devices/virtual/target_device/disk03/resync_size
/sys/devices/virtual/target_device/disk03/t10_dev_id
/sys/devices/virtual/target_device/disk03/usn
/sys/devices/virtual/target_device/disk04
/sys/devices/virtual/target_device/disk04/uevent
/sys/devices/virtual/target_device/disk04/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/disk04/type
/sys/devices/virtual/target_device/disk04/power
/sys/devices/virtual/target_device/disk04/power/wakeup
/sys/devices/virtual/target_device/disk04/power/wakeup_count
/sys/devices/virtual/target_device/disk04/power/wakeup_active_count
/sys/devices/virtual/target_device/disk04/power/wakeup_hit_count
/sys/devices/virtual/target_device/disk04/power/wakeup_active
/sys/devices/virtual/target_device/disk04/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/disk04/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/disk04/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/disk04/power/runtime_status
/sys/devices/virtual/target_device/disk04/power/control
/sys/devices/virtual/target_device/disk04/power/runtime_suspended_time
/sys/devices/virtual/target_device/disk04/power/runtime_active_time
/sys/devices/virtual/target_device/disk04/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/disk04/exported
/sys/devices/virtual/target_device/disk04/exported/export0 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_0/luns/3
/sys/devices/virtual/target_device/disk04/exported/export1 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_1/luns/3
/sys/devices/virtual/target_device/disk04/exported/export2 ->
=2E./../../target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:s=
torage/luns/3
/sys/devices/virtual/target_device/disk04/exported/export3 ->
=2E./../../target_driver/scst_local/local/luns/3
/sys/devices/virtual/target_device/disk04/dump_prs
/sys/devices/virtual/target_device/disk04/handler ->
=2E./../device_driver/vdisk_fileio
/sys/devices/virtual/target_device/disk04/threads_num
/sys/devices/virtual/target_device/disk04/threads_pool_type
/sys/devices/virtual/target_device/disk04/size_mb
/sys/devices/virtual/target_device/disk04/blocksize
/sys/devices/virtual/target_device/disk04/read_only
/sys/devices/virtual/target_device/disk04/write_through
/sys/devices/virtual/target_device/disk04/thin_provisioned
/sys/devices/virtual/target_device/disk04/nv_cache
/sys/devices/virtual/target_device/disk04/o_direct
/sys/devices/virtual/target_device/disk04/removable
/sys/devices/virtual/target_device/disk04/filename
/sys/devices/virtual/target_device/disk04/resync_size
/sys/devices/virtual/target_device/disk04/t10_dev_id
/sys/devices/virtual/target_device/disk04/usn
/sys/devices/virtual/target_device/disk05
/sys/devices/virtual/target_device/disk05/uevent
/sys/devices/virtual/target_device/disk05/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/disk05/type
/sys/devices/virtual/target_device/disk05/power
/sys/devices/virtual/target_device/disk05/power/wakeup
/sys/devices/virtual/target_device/disk05/power/wakeup_count
/sys/devices/virtual/target_device/disk05/power/wakeup_active_count
/sys/devices/virtual/target_device/disk05/power/wakeup_hit_count
/sys/devices/virtual/target_device/disk05/power/wakeup_active
/sys/devices/virtual/target_device/disk05/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/disk05/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/disk05/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/disk05/power/runtime_status
/sys/devices/virtual/target_device/disk05/power/control
/sys/devices/virtual/target_device/disk05/power/runtime_suspended_time
/sys/devices/virtual/target_device/disk05/power/runtime_active_time
/sys/devices/virtual/target_device/disk05/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/disk05/exported
/sys/devices/virtual/target_device/disk05/exported/export0 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_0/luns/4
/sys/devices/virtual/target_device/disk05/exported/export1 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_1/luns/4
/sys/devices/virtual/target_device/disk05/exported/export2 ->
=2E./../../target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:s=
torage/luns/4
/sys/devices/virtual/target_device/disk05/exported/export3 ->
=2E./../../target_driver/scst_local/local/luns/4
/sys/devices/virtual/target_device/disk05/dump_prs
/sys/devices/virtual/target_device/disk05/handler ->
=2E./../device_driver/vdisk_nullio
/sys/devices/virtual/target_device/disk05/threads_num
/sys/devices/virtual/target_device/disk05/threads_pool_type
/sys/devices/virtual/target_device/disk05/size_mb
/sys/devices/virtual/target_device/disk05/blocksize
/sys/devices/virtual/target_device/disk05/read_only
/sys/devices/virtual/target_device/disk05/removable
/sys/devices/virtual/target_device/disk05/t10_dev_id
/sys/devices/virtual/target_device/disk05/usn
/sys/devices/virtual/target_device/disk06
/sys/devices/virtual/target_device/disk06/uevent
/sys/devices/virtual/target_device/disk06/subsystem ->
=2E./../../../class/target_device
/sys/devices/virtual/target_device/disk06/type
/sys/devices/virtual/target_device/disk06/power
/sys/devices/virtual/target_device/disk06/power/wakeup
/sys/devices/virtual/target_device/disk06/power/wakeup_count
/sys/devices/virtual/target_device/disk06/power/wakeup_active_count
/sys/devices/virtual/target_device/disk06/power/wakeup_hit_count
/sys/devices/virtual/target_device/disk06/power/wakeup_active
/sys/devices/virtual/target_device/disk06/power/wakeup_total_time_ms
/sys/devices/virtual/target_device/disk06/power/wakeup_max_time_ms
/sys/devices/virtual/target_device/disk06/power/wakeup_last_time_ms
/sys/devices/virtual/target_device/disk06/power/runtime_status
/sys/devices/virtual/target_device/disk06/power/control
/sys/devices/virtual/target_device/disk06/power/runtime_suspended_time
/sys/devices/virtual/target_device/disk06/power/runtime_active_time
/sys/devices/virtual/target_device/disk06/power/autosuspend_delay_ms
/sys/devices/virtual/target_device/disk06/exported
/sys/devices/virtual/target_device/disk06/exported/export0 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_0/luns/5
/sys/devices/virtual/target_device/disk06/exported/export1 ->
=2E./../../target_driver/ib_srpt/ib_srpt_target_1/luns/5
/sys/devices/virtual/target_device/disk06/exported/export2 ->
=2E./../../target_driver/iscsi/iqn.2005-03.org.open-iscsi:dbc01e1792b:s=
torage/luns/5
/sys/devices/virtual/target_device/disk06/exported/export3 ->
=2E./../../target_driver/scst_local/local/luns/5
/sys/devices/virtual/target_device/disk06/dump_prs
/sys/devices/virtual/target_device/disk06/handler ->
=2E./../device_driver/vdisk_nullio
/sys/devices/virtual/target_device/disk06/threads_num
/sys/devices/virtual/target_device/disk06/threads_pool_type
/sys/devices/virtual/target_device/disk06/size_mb
/sys/devices/virtual/target_device/disk06/blocksize
/sys/devices/virtual/target_device/disk06/read_only
/sys/devices/virtual/target_device/disk06/removable
/sys/devices/virtual/target_device/disk06/t10_dev_id
/sys/devices/virtual/target_device/disk06/usn
/sys/devices/scst
/sys/devices/scst/uevent
/sys/devices/scst/power
/sys/devices/scst/power/control
/sys/devices/scst/power/wakeup
/sys/devices/scst/power/wakeup_count
/sys/devices/scst/power/wakeup_active_count
/sys/devices/scst/power/wakeup_hit_count
/sys/devices/scst/power/wakeup_active
/sys/devices/scst/power/wakeup_total_time_ms
/sys/devices/scst/power/wakeup_max_time_ms
/sys/devices/scst/power/wakeup_last_time_ms
/sys/devices/scst/power/runtime_status
/sys/devices/scst/power/runtime_suspended_time
/sys/devices/scst/power/runtime_active_time
/sys/devices/scst/power/autosuspend_delay_ms
/sys/devices/scst/mgmt
/sys/devices/scst/threads
/sys/devices/scst/setup_id
/sys/devices/scst/trace_level
/sys/devices/scst/version
/sys/devices/scst/sgv
/sys/devices/scst/sgv/global_stats
/sys/devices/scst/sgv/sgv-dma
/sys/devices/scst/sgv/sgv-dma/stats
/sys/devices/scst/sgv/sgv
/sys/devices/scst/sgv/sgv/stats
/sys/devices/scst/sgv/sgv-clust
/sys/devices/scst/sgv/sgv-clust/stats
