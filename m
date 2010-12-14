From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 14 Dec 2010 15:10:03 +0100
Message-ID: <AANLkTim3py__YdNbM+_SE+CVAm2Lt8ZWrM7q809UPMFP@mail.gmail.com>
References: <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com>
 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
 <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com> <4CE2846C.6070501@vlnb.net>
 <4CE59482.3050002@gmail.com> <20101118214619.GA29097@kroah.com>
 <4CE6BB4A.5060606@gmail.com> <20101119211904.GB28606@kroah.com>
 <AANLkTimJo_ZtQ3uVEBv864pP9f9AZR3D_o0R7T-B3fWL@mail.gmail.com> <20101210193637.GA23113@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101210193637.GA23113@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vvvvvst@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 10, 2010 at 8:36 PM, Greg KH <greg@kroah.com> wrote:
>
> On Fri, Dec 10, 2010 at 01:06:06PM +0100, Bart Van Assche wrote:
> > On Fri, Nov 19, 2010 at 10:19 PM, Greg KH <greg@kroah.com> wrote:
> > > [ ... ]
> > >
> > > None. =A0Use 'struct device'
> >
> > How about using 'struct device' as follows ?
> > * Move /sys/kernel/scst_tgt/targets to /sys/class/target_driver.
>
> Please never create a new class, use 'struct bus_type' instead and
> create a bus and have drivers and devices on it.

How about the hierarchy illustrated below, using the two new bus types
scsi_tgt_dev and scsi_tgt_port ? Note: this time I neither have loaded
the scst_local kernel module nor iscsi-scst in order to keep the
output short.

# find /sys/bus/scsi_tgt_* /sys/devices/scst | while read f; do if [
-h $f ]; then echo "$f -> $(readlink $f)"; else echo $f; fi; done
/sys/bus/scsi_tgt_dev
/sys/bus/scsi_tgt_dev/uevent
/sys/bus/scsi_tgt_dev/devices
/sys/bus/scsi_tgt_dev/devices/2:0:0:0 -> ../../../devices/2:0:0:0
/sys/bus/scsi_tgt_dev/devices/2:0:1:0 -> ../../../devices/2:0:1:0
/sys/bus/scsi_tgt_dev/devices/3:0:0:0 -> ../../../devices/3:0:0:0
/sys/bus/scsi_tgt_dev/devices/disk01 -> ../../../devices/disk01
/sys/bus/scsi_tgt_dev/devices/disk02 -> ../../../devices/disk02
/sys/bus/scsi_tgt_dev/devices/disk03 -> ../../../devices/disk03
/sys/bus/scsi_tgt_dev/devices/disk04 -> ../../../devices/disk04
/sys/bus/scsi_tgt_dev/devices/disk05 -> ../../../devices/disk05
/sys/bus/scsi_tgt_dev/devices/disk06 -> ../../../devices/disk06
/sys/bus/scsi_tgt_dev/drivers
/sys/bus/scsi_tgt_dev/drivers/dev_disk
/sys/bus/scsi_tgt_dev/drivers/dev_disk/module -> ../../../../module/scs=
t_disk
/sys/bus/scsi_tgt_dev/drivers/dev_disk/uevent
/sys/bus/scsi_tgt_dev/drivers/dev_disk/type
/sys/bus/scsi_tgt_dev/drivers/dev_disk/trace_level
/sys/bus/scsi_tgt_dev/drivers/dev_disk_perf
/sys/bus/scsi_tgt_dev/drivers/dev_disk_perf/module ->
=2E./../../../module/scst_disk
/sys/bus/scsi_tgt_dev/drivers/dev_disk_perf/uevent
/sys/bus/scsi_tgt_dev/drivers/dev_disk_perf/type
/sys/bus/scsi_tgt_dev/drivers/dev_disk_perf/trace_level
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/module ->
=2E./../../../module/scst_vdisk
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/uevent
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/type
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/add_device_parameters
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/trace_level
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/disk01 -> ../../../../device=
s/disk01
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/disk02 -> ../../../../device=
s/disk02
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/disk03 -> ../../../../device=
s/disk03
/sys/bus/scsi_tgt_dev/drivers/vdisk_fileio/disk04 -> ../../../../device=
s/disk04
/sys/bus/scsi_tgt_dev/drivers/vdisk_blockio
/sys/bus/scsi_tgt_dev/drivers/vdisk_blockio/module ->
=2E./../../../module/scst_vdisk
/sys/bus/scsi_tgt_dev/drivers/vdisk_blockio/uevent
/sys/bus/scsi_tgt_dev/drivers/vdisk_blockio/type
/sys/bus/scsi_tgt_dev/drivers/vdisk_blockio/add_device_parameters
/sys/bus/scsi_tgt_dev/drivers/vdisk_blockio/trace_level
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio/module ->
=2E./../../../module/scst_vdisk
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio/uevent
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio/type
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio/add_device_parameters
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio/trace_level
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio/disk05 -> ../../../../device=
s/disk05
/sys/bus/scsi_tgt_dev/drivers/vdisk_nullio/disk06 -> ../../../../device=
s/disk06
/sys/bus/scsi_tgt_dev/drivers/vcdrom
/sys/bus/scsi_tgt_dev/drivers/vcdrom/module -> ../../../../module/scst_=
vdisk
/sys/bus/scsi_tgt_dev/drivers/vcdrom/uevent
/sys/bus/scsi_tgt_dev/drivers/vcdrom/type
/sys/bus/scsi_tgt_dev/drivers/vcdrom/trace_level
/sys/bus/scsi_tgt_dev/drivers_probe
/sys/bus/scsi_tgt_dev/drivers_autoprobe
/sys/bus/scsi_tgt_port
/sys/bus/scsi_tgt_port/uevent
/sys/bus/scsi_tgt_port/devices
/sys/bus/scsi_tgt_port/devices/ib_srpt_target_0 ->
=2E./../../devices/ib_srpt_target_0
/sys/bus/scsi_tgt_port/devices/ib_srpt_target_1 ->
=2E./../../devices/ib_srpt_target_1
/sys/bus/scsi_tgt_port/drivers
/sys/bus/scsi_tgt_port/drivers/ib_srpt
/sys/bus/scsi_tgt_port/drivers/ib_srpt/module -> ../../../../module/ib_=
srpt
/sys/bus/scsi_tgt_port/drivers/ib_srpt/uevent
/sys/bus/scsi_tgt_port/drivers/ib_srpt/add_target
/sys/bus/scsi_tgt_port/drivers/ib_srpt/ib_srpt_target_0 ->
=2E./../../../devices/ib_srpt_target_0
/sys/bus/scsi_tgt_port/drivers/ib_srpt/ib_srpt_target_1 ->
=2E./../../../devices/ib_srpt_target_1
/sys/bus/scsi_tgt_port/drivers_probe
/sys/bus/scsi_tgt_port/drivers_autoprobe
/sys/devices/2:0:0:0
/sys/devices/2:0:0:0/uevent
/sys/devices/2:0:0:0/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/2:0:0:0/power
/sys/devices/2:0:0:0/power/wakeup
/sys/devices/2:0:0:0/power/wakeup_count
/sys/devices/2:0:0:0/power/wakeup_active_count
/sys/devices/2:0:0:0/power/wakeup_hit_count
/sys/devices/2:0:0:0/power/wakeup_active
/sys/devices/2:0:0:0/power/wakeup_total_time_ms
/sys/devices/2:0:0:0/power/wakeup_max_time_ms
/sys/devices/2:0:0:0/power/wakeup_last_time_ms
/sys/devices/2:0:0:0/power/runtime_status
/sys/devices/2:0:0:0/power/control
/sys/devices/2:0:0:0/power/runtime_suspended_time
/sys/devices/2:0:0:0/power/runtime_active_time
/sys/devices/2:0:0:0/power/autosuspend_delay_ms
/sys/devices/2:0:0:0/scsi_device
/sys/devices/2:0:1:0
/sys/devices/2:0:1:0/uevent
/sys/devices/2:0:1:0/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/2:0:1:0/power
/sys/devices/2:0:1:0/power/wakeup
/sys/devices/2:0:1:0/power/wakeup_count
/sys/devices/2:0:1:0/power/wakeup_active_count
/sys/devices/2:0:1:0/power/wakeup_hit_count
/sys/devices/2:0:1:0/power/wakeup_active
/sys/devices/2:0:1:0/power/wakeup_total_time_ms
/sys/devices/2:0:1:0/power/wakeup_max_time_ms
/sys/devices/2:0:1:0/power/wakeup_last_time_ms
/sys/devices/2:0:1:0/power/runtime_status
/sys/devices/2:0:1:0/power/control
/sys/devices/2:0:1:0/power/runtime_suspended_time
/sys/devices/2:0:1:0/power/runtime_active_time
/sys/devices/2:0:1:0/power/autosuspend_delay_ms
/sys/devices/2:0:1:0/scsi_device
/sys/devices/3:0:0:0
/sys/devices/3:0:0:0/uevent
/sys/devices/3:0:0:0/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/3:0:0:0/power
/sys/devices/3:0:0:0/power/wakeup
/sys/devices/3:0:0:0/power/wakeup_count
/sys/devices/3:0:0:0/power/wakeup_active_count
/sys/devices/3:0:0:0/power/wakeup_hit_count
/sys/devices/3:0:0:0/power/wakeup_active
/sys/devices/3:0:0:0/power/wakeup_total_time_ms
/sys/devices/3:0:0:0/power/wakeup_max_time_ms
/sys/devices/3:0:0:0/power/wakeup_last_time_ms
/sys/devices/3:0:0:0/power/runtime_status
/sys/devices/3:0:0:0/power/control
/sys/devices/3:0:0:0/power/runtime_suspended_time
/sys/devices/3:0:0:0/power/runtime_active_time
/sys/devices/3:0:0:0/power/autosuspend_delay_ms
/sys/devices/3:0:0:0/scsi_device
/sys/devices/disk01
/sys/devices/disk01/uevent
/sys/devices/disk01/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/disk01/power
/sys/devices/disk01/power/wakeup
/sys/devices/disk01/power/wakeup_count
/sys/devices/disk01/power/wakeup_active_count
/sys/devices/disk01/power/wakeup_hit_count
/sys/devices/disk01/power/wakeup_active
/sys/devices/disk01/power/wakeup_total_time_ms
/sys/devices/disk01/power/wakeup_max_time_ms
/sys/devices/disk01/power/wakeup_last_time_ms
/sys/devices/disk01/power/runtime_status
/sys/devices/disk01/power/control
/sys/devices/disk01/power/runtime_suspended_time
/sys/devices/disk01/power/runtime_active_time
/sys/devices/disk01/power/autosuspend_delay_ms
/sys/devices/disk01/driver -> ../../bus/scsi_tgt_dev/drivers/vdisk_file=
io
/sys/devices/disk01/exported
/sys/devices/disk01/exported/export0 -> ../../ib_srpt_target_0/luns/0
/sys/devices/disk01/exported/export1 -> ../../ib_srpt_target_1/luns/0
/sys/devices/disk01/type
/sys/devices/disk01/threads_num
/sys/devices/disk01/threads_pool_type
/sys/devices/disk01/size_mb
/sys/devices/disk01/blocksize
/sys/devices/disk01/read_only
/sys/devices/disk01/write_through
/sys/devices/disk01/thin_provisioned
/sys/devices/disk01/nv_cache
/sys/devices/disk01/o_direct
/sys/devices/disk01/removable
/sys/devices/disk01/filename
/sys/devices/disk01/resync_size
/sys/devices/disk01/t10_dev_id
/sys/devices/disk01/usn
/sys/devices/disk02
/sys/devices/disk02/uevent
/sys/devices/disk02/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/disk02/power
/sys/devices/disk02/power/wakeup
/sys/devices/disk02/power/wakeup_count
/sys/devices/disk02/power/wakeup_active_count
/sys/devices/disk02/power/wakeup_hit_count
/sys/devices/disk02/power/wakeup_active
/sys/devices/disk02/power/wakeup_total_time_ms
/sys/devices/disk02/power/wakeup_max_time_ms
/sys/devices/disk02/power/wakeup_last_time_ms
/sys/devices/disk02/power/runtime_status
/sys/devices/disk02/power/control
/sys/devices/disk02/power/runtime_suspended_time
/sys/devices/disk02/power/runtime_active_time
/sys/devices/disk02/power/autosuspend_delay_ms
/sys/devices/disk02/driver -> ../../bus/scsi_tgt_dev/drivers/vdisk_file=
io
/sys/devices/disk02/exported
/sys/devices/disk02/exported/export0 -> ../../ib_srpt_target_0/luns/1
/sys/devices/disk02/exported/export1 -> ../../ib_srpt_target_1/luns/1
/sys/devices/disk02/type
/sys/devices/disk02/threads_num
/sys/devices/disk02/threads_pool_type
/sys/devices/disk02/size_mb
/sys/devices/disk02/blocksize
/sys/devices/disk02/read_only
/sys/devices/disk02/write_through
/sys/devices/disk02/thin_provisioned
/sys/devices/disk02/nv_cache
/sys/devices/disk02/o_direct
/sys/devices/disk02/removable
/sys/devices/disk02/filename
/sys/devices/disk02/resync_size
/sys/devices/disk02/t10_dev_id
/sys/devices/disk02/usn
/sys/devices/disk03
/sys/devices/disk03/uevent
/sys/devices/disk03/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/disk03/power
/sys/devices/disk03/power/wakeup
/sys/devices/disk03/power/wakeup_count
/sys/devices/disk03/power/wakeup_active_count
/sys/devices/disk03/power/wakeup_hit_count
/sys/devices/disk03/power/wakeup_active
/sys/devices/disk03/power/wakeup_total_time_ms
/sys/devices/disk03/power/wakeup_max_time_ms
/sys/devices/disk03/power/wakeup_last_time_ms
/sys/devices/disk03/power/runtime_status
/sys/devices/disk03/power/control
/sys/devices/disk03/power/runtime_suspended_time
/sys/devices/disk03/power/runtime_active_time
/sys/devices/disk03/power/autosuspend_delay_ms
/sys/devices/disk03/driver -> ../../bus/scsi_tgt_dev/drivers/vdisk_file=
io
/sys/devices/disk03/exported
/sys/devices/disk03/exported/export0 -> ../../ib_srpt_target_0/luns/2
/sys/devices/disk03/exported/export1 -> ../../ib_srpt_target_1/luns/2
/sys/devices/disk03/type
/sys/devices/disk03/threads_num
/sys/devices/disk03/threads_pool_type
/sys/devices/disk03/size_mb
/sys/devices/disk03/blocksize
/sys/devices/disk03/read_only
/sys/devices/disk03/write_through
/sys/devices/disk03/thin_provisioned
/sys/devices/disk03/nv_cache
/sys/devices/disk03/o_direct
/sys/devices/disk03/removable
/sys/devices/disk03/filename
/sys/devices/disk03/resync_size
/sys/devices/disk03/t10_dev_id
/sys/devices/disk03/usn
/sys/devices/disk04
/sys/devices/disk04/uevent
/sys/devices/disk04/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/disk04/power
/sys/devices/disk04/power/wakeup
/sys/devices/disk04/power/wakeup_count
/sys/devices/disk04/power/wakeup_active_count
/sys/devices/disk04/power/wakeup_hit_count
/sys/devices/disk04/power/wakeup_active
/sys/devices/disk04/power/wakeup_total_time_ms
/sys/devices/disk04/power/wakeup_max_time_ms
/sys/devices/disk04/power/wakeup_last_time_ms
/sys/devices/disk04/power/runtime_status
/sys/devices/disk04/power/control
/sys/devices/disk04/power/runtime_suspended_time
/sys/devices/disk04/power/runtime_active_time
/sys/devices/disk04/power/autosuspend_delay_ms
/sys/devices/disk04/driver -> ../../bus/scsi_tgt_dev/drivers/vdisk_file=
io
/sys/devices/disk04/exported
/sys/devices/disk04/exported/export0 -> ../../ib_srpt_target_0/luns/3
/sys/devices/disk04/exported/export1 -> ../../ib_srpt_target_1/luns/3
/sys/devices/disk04/type
/sys/devices/disk04/threads_num
/sys/devices/disk04/threads_pool_type
/sys/devices/disk04/size_mb
/sys/devices/disk04/blocksize
/sys/devices/disk04/read_only
/sys/devices/disk04/write_through
/sys/devices/disk04/thin_provisioned
/sys/devices/disk04/nv_cache
/sys/devices/disk04/o_direct
/sys/devices/disk04/removable
/sys/devices/disk04/filename
/sys/devices/disk04/resync_size
/sys/devices/disk04/t10_dev_id
/sys/devices/disk04/usn
/sys/devices/disk05
/sys/devices/disk05/uevent
/sys/devices/disk05/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/disk05/power
/sys/devices/disk05/power/wakeup
/sys/devices/disk05/power/wakeup_count
/sys/devices/disk05/power/wakeup_active_count
/sys/devices/disk05/power/wakeup_hit_count
/sys/devices/disk05/power/wakeup_active
/sys/devices/disk05/power/wakeup_total_time_ms
/sys/devices/disk05/power/wakeup_max_time_ms
/sys/devices/disk05/power/wakeup_last_time_ms
/sys/devices/disk05/power/runtime_status
/sys/devices/disk05/power/control
/sys/devices/disk05/power/runtime_suspended_time
/sys/devices/disk05/power/runtime_active_time
/sys/devices/disk05/power/autosuspend_delay_ms
/sys/devices/disk05/driver -> ../../bus/scsi_tgt_dev/drivers/vdisk_null=
io
/sys/devices/disk05/exported
/sys/devices/disk05/exported/export0 -> ../../ib_srpt_target_0/luns/4
/sys/devices/disk05/exported/export1 -> ../../ib_srpt_target_1/luns/4
/sys/devices/disk05/type
/sys/devices/disk05/threads_num
/sys/devices/disk05/threads_pool_type
/sys/devices/disk05/size_mb
/sys/devices/disk05/blocksize
/sys/devices/disk05/read_only
/sys/devices/disk05/removable
/sys/devices/disk05/t10_dev_id
/sys/devices/disk05/usn
/sys/devices/disk06
/sys/devices/disk06/uevent
/sys/devices/disk06/subsystem -> ../../bus/scsi_tgt_dev
/sys/devices/disk06/power
/sys/devices/disk06/power/wakeup
/sys/devices/disk06/power/wakeup_count
/sys/devices/disk06/power/wakeup_active_count
/sys/devices/disk06/power/wakeup_hit_count
/sys/devices/disk06/power/wakeup_active
/sys/devices/disk06/power/wakeup_total_time_ms
/sys/devices/disk06/power/wakeup_max_time_ms
/sys/devices/disk06/power/wakeup_last_time_ms
/sys/devices/disk06/power/runtime_status
/sys/devices/disk06/power/control
/sys/devices/disk06/power/runtime_suspended_time
/sys/devices/disk06/power/runtime_active_time
/sys/devices/disk06/power/autosuspend_delay_ms
/sys/devices/disk06/driver -> ../../bus/scsi_tgt_dev/drivers/vdisk_null=
io
/sys/devices/disk06/exported
/sys/devices/disk06/exported/export0 -> ../../ib_srpt_target_0/luns/5
/sys/devices/disk06/exported/export1 -> ../../ib_srpt_target_1/luns/5
/sys/devices/disk06/type
/sys/devices/disk06/threads_num
/sys/devices/disk06/threads_pool_type
/sys/devices/disk06/size_mb
/sys/devices/disk06/blocksize
/sys/devices/disk06/read_only
/sys/devices/disk06/removable
/sys/devices/disk06/t10_dev_id
/sys/devices/disk06/usn
/sys/devices/ib_srpt_target_0
/sys/devices/ib_srpt_target_0/uevent
/sys/devices/ib_srpt_target_0/subsystem -> ../../bus/scsi_tgt_port
/sys/devices/ib_srpt_target_0/power
/sys/devices/ib_srpt_target_0/power/wakeup
/sys/devices/ib_srpt_target_0/power/wakeup_count
/sys/devices/ib_srpt_target_0/power/wakeup_active_count
/sys/devices/ib_srpt_target_0/power/wakeup_hit_count
/sys/devices/ib_srpt_target_0/power/wakeup_active
/sys/devices/ib_srpt_target_0/power/wakeup_total_time_ms
/sys/devices/ib_srpt_target_0/power/wakeup_max_time_ms
/sys/devices/ib_srpt_target_0/power/wakeup_last_time_ms
/sys/devices/ib_srpt_target_0/power/runtime_status
/sys/devices/ib_srpt_target_0/power/control
/sys/devices/ib_srpt_target_0/power/runtime_suspended_time
/sys/devices/ib_srpt_target_0/power/runtime_active_time
/sys/devices/ib_srpt_target_0/power/autosuspend_delay_ms
/sys/devices/ib_srpt_target_0/driver -> ../../bus/scsi_tgt_port/drivers=
/ib_srpt
/sys/devices/ib_srpt_target_0/enabled
/sys/devices/ib_srpt_target_0/sessions
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/commands
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/active_commands
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/initiator_name
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/req_lim
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/req_lim_delta
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/luns
-> ../../luns
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun0
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun0/active_commands
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun1
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun1/active_commands
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun2
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun2/active_commands
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun3
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun3/active_commands
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun4
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun4/active_commands
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun5
/sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f3=
4b/lun5/active_commands
/sys/devices/ib_srpt_target_0/luns
/sys/devices/ib_srpt_target_0/luns/parameters
/sys/devices/ib_srpt_target_0/luns/0
/sys/devices/ib_srpt_target_0/luns/0/read_only
/sys/devices/ib_srpt_target_0/luns/0/device -> ../../../disk01
/sys/devices/ib_srpt_target_0/luns/1
/sys/devices/ib_srpt_target_0/luns/1/read_only
/sys/devices/ib_srpt_target_0/luns/1/device -> ../../../disk02
/sys/devices/ib_srpt_target_0/luns/2
/sys/devices/ib_srpt_target_0/luns/2/read_only
/sys/devices/ib_srpt_target_0/luns/2/device -> ../../../disk03
/sys/devices/ib_srpt_target_0/luns/3
/sys/devices/ib_srpt_target_0/luns/3/read_only
/sys/devices/ib_srpt_target_0/luns/3/device -> ../../../disk04
/sys/devices/ib_srpt_target_0/luns/4
/sys/devices/ib_srpt_target_0/luns/4/read_only
/sys/devices/ib_srpt_target_0/luns/4/device -> ../../../disk05
/sys/devices/ib_srpt_target_0/luns/5
/sys/devices/ib_srpt_target_0/luns/5/read_only
/sys/devices/ib_srpt_target_0/luns/5/device -> ../../../disk06
/sys/devices/ib_srpt_target_0/ini_groups
/sys/devices/ib_srpt_target_0/rel_tgt_id
/sys/devices/ib_srpt_target_0/addr_method
/sys/devices/ib_srpt_target_0/io_grouping_type
/sys/devices/ib_srpt_target_0/cpu_mask
/sys/devices/ib_srpt_target_0/login_info
/sys/devices/ib_srpt_target_1
/sys/devices/ib_srpt_target_1/uevent
/sys/devices/ib_srpt_target_1/subsystem -> ../../bus/scsi_tgt_port
/sys/devices/ib_srpt_target_1/power
/sys/devices/ib_srpt_target_1/power/wakeup
/sys/devices/ib_srpt_target_1/power/wakeup_count
/sys/devices/ib_srpt_target_1/power/wakeup_active_count
/sys/devices/ib_srpt_target_1/power/wakeup_hit_count
/sys/devices/ib_srpt_target_1/power/wakeup_active
/sys/devices/ib_srpt_target_1/power/wakeup_total_time_ms
/sys/devices/ib_srpt_target_1/power/wakeup_max_time_ms
/sys/devices/ib_srpt_target_1/power/wakeup_last_time_ms
/sys/devices/ib_srpt_target_1/power/runtime_status
/sys/devices/ib_srpt_target_1/power/control
/sys/devices/ib_srpt_target_1/power/runtime_suspended_time
/sys/devices/ib_srpt_target_1/power/runtime_active_time
/sys/devices/ib_srpt_target_1/power/autosuspend_delay_ms
/sys/devices/ib_srpt_target_1/driver -> ../../bus/scsi_tgt_port/drivers=
/ib_srpt
/sys/devices/ib_srpt_target_1/enabled
/sys/devices/ib_srpt_target_1/sessions
/sys/devices/ib_srpt_target_1/luns
/sys/devices/ib_srpt_target_1/luns/parameters
/sys/devices/ib_srpt_target_1/luns/0
/sys/devices/ib_srpt_target_1/luns/0/read_only
/sys/devices/ib_srpt_target_1/luns/0/device -> ../../../disk01
/sys/devices/ib_srpt_target_1/luns/1
/sys/devices/ib_srpt_target_1/luns/1/read_only
/sys/devices/ib_srpt_target_1/luns/1/device -> ../../../disk02
/sys/devices/ib_srpt_target_1/luns/2
/sys/devices/ib_srpt_target_1/luns/2/read_only
/sys/devices/ib_srpt_target_1/luns/2/device -> ../../../disk03
/sys/devices/ib_srpt_target_1/luns/3
/sys/devices/ib_srpt_target_1/luns/3/read_only
/sys/devices/ib_srpt_target_1/luns/3/device -> ../../../disk04
/sys/devices/ib_srpt_target_1/luns/4
/sys/devices/ib_srpt_target_1/luns/4/read_only
/sys/devices/ib_srpt_target_1/luns/4/device -> ../../../disk05
/sys/devices/ib_srpt_target_1/luns/5
/sys/devices/ib_srpt_target_1/luns/5/read_only
/sys/devices/ib_srpt_target_1/luns/5/device -> ../../../disk06
/sys/devices/ib_srpt_target_1/ini_groups
/sys/devices/ib_srpt_target_1/rel_tgt_id
/sys/devices/ib_srpt_target_1/addr_method
/sys/devices/ib_srpt_target_1/io_grouping_type
/sys/devices/ib_srpt_target_1/cpu_mask
/sys/devices/ib_srpt_target_1/login_info
/sys/devices/scst
/sys/devices/scst/uevent
/sys/devices/scst/power
/sys/devices/scst/power/wakeup
/sys/devices/scst/power/wakeup_count
/sys/devices/scst/power/wakeup_active_count
/sys/devices/scst/power/wakeup_hit_count
/sys/devices/scst/power/wakeup_active
/sys/devices/scst/power/wakeup_total_time_ms
/sys/devices/scst/power/wakeup_max_time_ms
/sys/devices/scst/power/wakeup_last_time_ms
/sys/devices/scst/power/runtime_status
/sys/devices/scst/power/control
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
/sys/devices/scst/sgv/sgv
/sys/devices/scst/sgv/sgv/stats
/sys/devices/scst/sgv/sgv-clust
/sys/devices/scst/sgv/sgv-clust/stats
/sys/devices/scst/sgv/sgv-dma
/sys/devices/scst/sgv/sgv-dma/stats

Bart.
