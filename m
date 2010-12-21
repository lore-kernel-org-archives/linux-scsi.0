From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 4/7] [SCSI] scst: Add SRP target driver
Date: Tue, 21 Dec 2010 10:50:05 +0100
Message-ID: <AANLkTinNGQeA_1sRSj4qLjtHQNdYtPHAsJbxu+j1Sj4j@mail.gmail.com>
References: <201012201849.27639.bvanassche@acm.org> <544F03C80B314396A5517F4CD1A848B6@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <544F03C80B314396A5517F4CD1A848B6-aA8Fybl81pBv1O+Z8WTAqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jack_wang-aA8Fybl81pAAvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-l3A5Bk7waGM@public.gmane.org, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 21, 2010 at 2:50 AM, Jack Wang <jack_wang-aA8Fybl81pAAvxtiuMwx3w@public.gmane.org> wrote:
>
> >
> > This patch adds the kernel module ib_srpt, which is a SCSI RDMA Protocol
> (SRP)
> > target implementation. This driver uses the InfiniBand stack and the SCST
> core.
> [ ... ]
>
> [Jack] This README looks should update to new sysfs interface too.

That's correct - thanks for the feedback. If I do not receive further
feedback, I will apply the patch below:

Subject: [PATCH] [SCSI] scst/ib_srpt: Updated documentation

Make the documentation more clear, update it for the new sysfs interface and
add detailed information about the ib_srpt kernel module parameters.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 Documentation/scst/README.srpt |  235 +++++++++++++++++++++++-----------------
 1 files changed, 136 insertions(+), 99 deletions(-)

diff --git a/Documentation/scst/README.srpt b/Documentation/scst/README.srpt
index 6f8b3ca..c1a1136 100644
--- a/Documentation/scst/README.srpt
+++ b/Documentation/scst/README.srpt
@@ -1,112 +1,149 @@
-SCSI RDMA Protocol (SRP) Target driver for Linux
+SCSI RDMA Protocol (SRP) Target Driver for Linux
 =================================================

-The SRP Target driver is designed to work directly on top of the
-OpenFabrics OFED-1.x software stack (http://www.openfabrics.org) or
-the Infiniband drivers in the Linux kernel tree
-(http://www.kernel.org). The SRP target driver also interfaces with
-the generic SCSI target mid-level driver called SCST
-(http://scst.sourceforge.net).
-
-How-to run
------------
-
-A. On srp target machine
-1. Please refer to SCST's README for loading scst driver and its
-dev_handlers drivers (scst_disk, scst_vdisk block or file IO mode, nullio, ...)
-
-Example 1: working with real back-end scsi disks
-a. modprobe scst
-b. modprobe scst_disk
-c. cat /proc/scsi_tgt/scsi_tgt
-
-ibstor00:~ # cat /proc/scsi_tgt/scsi_tgt
-Device (host:ch:id:lun or name)                             Device handler
-0:0:0:0                                                     dev_disk
-4:0:0:0                                                     dev_disk
-5:0:0:0                                                     dev_disk
-6:0:0:0                                                     dev_disk
-7:0:0:0                                                     dev_disk
-
-Now you want to exclude the first scsi disk and expose the last 4 scsi disks as
-IB/SRP luns for I/O
-echo "add 4:0:0:0 0" >/proc/scsi_tgt/groups/Default/devices
-echo "add 5:0:0:0 1" >/proc/scsi_tgt/groups/Default/devices
-echo "add 6:0:0:0 2" >/proc/scsi_tgt/groups/Default/devices
-echo "add 7:0:0:0 3" >/proc/scsi_tgt/groups/Default/devices
-
-Example 2: working with VDISK FILEIO mode (using md0 device and file 10G-file)
-a. modprobe scst
-b. modprobe scst_vdisk
-c. echo "open vdisk0 /dev/md0" > /proc/scsi_tgt/vdisk/vdisk
-d. echo "open vdisk1 /10G-file" > /proc/scsi_tgt/vdisk/vdisk
-e. echo "add vdisk0 0" >/proc/scsi_tgt/groups/Default/devices
-f. echo "add vdisk1 1" >/proc/scsi_tgt/groups/Default/devices
-
-Example 3: working with VDISK BLOCKIO mode (using md0 device, sda,
and cciss/c1d0)
-a. modprobe scst
-b. modprobe scst_vdisk
-c. echo "open vdisk0 /dev/md0 BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
-d. echo "open vdisk1 /dev/sda BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
-e. echo "open vdisk2 /dev/cciss/c1d0 BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
-f. echo "add vdisk0 0" >/proc/scsi_tgt/groups/Default/devices
-g. echo "add vdisk1 1" >/proc/scsi_tgt/groups/Default/devices
-h. echo "add vdisk2 2" >/proc/scsi_tgt/groups/Default/devices
-
-2. modprobe ib_srpt
-
-
-B. On initiator machines you can manualy do the following steps:
-1. modprobe ib_srp
-2. ibsrpdm -c (to discover new SRP target)
-3. echo <new target info> > /sys/class/infiniband_srp/srp-mthca0-1/add_target
-4. fdisk -l (will show new discovered scsi disks)
-
-Example:
-Assume that you use port 1 of first HCA in the system ie. mthca0
+The SRP target driver ib_srpt is based on the generic SCSI target
+infrastructure called SCST. It supports both the InfiniBand drivers included
+with the Linux kernel and the OpenFabrics InfiniBand software stack.

-[root@lab104 ~]# ibsrpdm -c -d /dev/infiniband/umad0
-id_ext=0002c90200226cf4,ioc_guid=0002c90200226cf4,
-dgid=fe800000000000000002c90200226cf5,pkey=ffff,service_id=0002c90200226cf4
-[root@lab104 ~]# echo id_ext=0002c90200226cf4,ioc_guid=0002c90200226cf4,
-dgid=fe800000000000000002c90200226cf5,pkey=ffff,service_id=0002c90200226cf4 >
-/sys/class/infiniband_srp/srp-mthca0-1/add_target
+Installation
+------------
+
+A. SRP target configuration
+
+1. Load the ib_srpt kernel module
+
+Add ib_srpt to the SCST_MODULES variable in /etc/init.d/scst such that ib_srpt
+is loaded automatically upon startup. Next, load the ib_srpt kernel module
+e.g. as follows:
+
+  touch /etc/scst.conf
+  /etc/init.d/scst start
+
+2. Configure SCST
+
+How to configure SCST is explained in detail in Documentation/scst/README.scst.
+Once you have finished configuring SCST, save the new configuration to
+/etc/scst.conf:

-OR
+  scstadmin -write_config /etc/scst.conf

-+ You can edit /etc/infiniband/openib.conf to load srp driver and srp HA daemon
-automatically ie. set SRP_LOAD=yes, and SRPHA_ENABLE=yes
-+ To set up and use high availability feature you need dm-multipath driver
-and multipath tool
-+ Please refer to OFED-1.x SRP's user manual for more in-details instructions
-on how-to enable/use HA feature

-To minimize QUEUE_FULL conditions, you can apply scst_increase_max_tgt_cmds
-patch from SRPT package from
http://sourceforge.net/project/showfiles.php?group_id=110471
+B. SRP initiator configuration

+Configure the initiator as follows:

-Performance notes
------------------
+1. Verify whether the InfiniBand subnet manager is operational, e.g.
as follows:
+     ping <IBoIB address of SRP target>

-In some cases, for instance working with SSD devices, which consume 100%
-of a single CPU load for data transfers in their internal threads, to
-maximize IOPS it can be needed to assign for those threads dedicated
-CPUs using Linux CPU affinity facilities. No IRQ processing should be
-done on those CPUs. Check that using /proc/interrupts. See taskset
-command and Documentation/IRQ-affinity.txt in your kernel's source tree
-for how to assign CPU affinity to tasks and IRQs.
+2. Load the SRP initator kernel module.
+     modprobe ib_srp

-The reason for that is that processing of coming commands in SIRQ context
-can be done on the same CPUs as SSD devices' threads doing data
-transfers. As the result, those threads won't receive all the CPU power
-and perform worse.
+3. Run ibsrpdm to obtain a list of available SRP target systems.
+     ibsrpdm -c

-Alternatively to CPU affinity assignment, you can try to enable SRP
-target's internal thread. It will allows Linux CPU scheduler to better
-distribute load among available CPUs. To enable SRP target driver's
-internal thread you should load ib_srpt module with parameter
-"thread=1".
+4. Tell the SRP initiator to log in to the SRP target.
+     echo <target info> > /sys/class/infiniband_srp/${SRP_HCA_NAME}/add_target
+
+5. Verify whether login succeeded, e.g. as follows:
+     lsscsi
+
+   SRP targets can be recognized in the lsscsi output by looking for
+   the disk names assigned to the SCST target ("disk01" in the example below):
+
+     [8:0:0:0]    disk    SCST_FIO disk01            102  /dev/sdb
+
+An example:
+
+[root@lab104 ~]# ibsrpdm -c -d /dev/infiniband/umad0
+id_ext=0002c90200226cf4,ioc_guid=0002c90200226cf4,
+dgid=fe800000000000000002c90200226cf5,pkey=ffff,service_id=0002c90200226cf4
+[root@lab104 ~]# echo id_ext=0002c90200226cf4,ioc_guid=0002c90200226cf4,
+dgid=fe800000000000000002c90200226cf5,pkey=ffff,service_id=0002c90200226cf4 >
+/sys/class/infiniband_srp/srp-mthca0-1/add_target


-Send questions about this driver to scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, CC:
-Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> and Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>.
+C. High Availability
+
+If there are redundant paths in the IB network between initiator and target,
+automatic path failover can be set up on the initiator as follows:
+* Edit /etc/infiniband/openib.conf to load the SRP driver and SRP HA daemon
+  automatically: set SRP_LOAD=yes and SRPHA_ENABLE=yes.
+* To set up and use the high availability feature you need the dm-multipath
+  driver and multipath tool.
+* Please refer to the OFED-1.x user manual for more detailed instructions
+  on how to enable and how to use the HA feature. See e.g.
+  http://www.mellanox.com/related-docs/prod_software/Mellanox_OFED%20_Linux_user
+_manual_1_5_1_2.pdf.
+
+A setup with automatic failover between redundant targets is possible by
+installing and configuring replication software such as DRBD on both
+targets. If the initiator system supports mirroring (e.g. Linux), you can use
+the following approach:
+* Configure the replication software in Active/Active mode.
+* Configure the initiator(s) for mirroring between the redundant targets.
+
+If the initiator system does not support mirroring (e.g. VMware ESX), you
+can use the following approach:
+* Configure DRBD in Active/Passive mode and enable STONITH mode in the
+  Heartbeat software.
+
+
+D. Notes
+
+For workloads with large I/O depths increasing the SCST_MAX_TGT_DEV_COMMANDS
+constant in drivers/scst/scst_priv.h may improve performance.
+
+For latency sensitive applications, using the noop scheduler at the initiator
+side can give significantly better results than with other schedulers.
+
+The following initiator-side parameters have a small but measurable impact on
+SRP performance:
+  * /sys/class/block/${dev}/queue/rotational
+  * /sys/class/block/${dev}/queue/rq_affinity
+  * /proc/irq/${ib_int_no}/smp_affinity
+
+The ib_srpt kernel module supports the following parameters:
+* srp_max_req_size (number)
+  Maximum size of an SRP control message in bytes. Examples of SRP control
+  messages are: login request, logout request, data transfer request, ...
+  The larger this parameter, the more scatter/gather list elements can be
+  sent at once. Use the following formula to compute an appropriate value
+  for this parameter: 68 + 16 * (sg_tablesize). The default value of
+  this parameter is 2116, which corresponds to an sg table size of 128.
+* srp_max_rsp_size (number)
+  Maximum size of an SRP response message in bytes. Sense data is sent back
+  via these messages towards the initiator. The default size is 256 bytes.
+  With this value there remains (256-36) = 220 bytes for sense data.
+* srp_max_rdma_size (number)
+  Maximum number of bytes that may be transferred at once via RDMA. Defaults
+  to 65536 bytes, which is sufficient to use the full bandwidth of low-latency
+  HCAs. Increasing this value may decrease latency for applications
+  transferring large amounts of data at once.
+* srpt_srq_size (number, default 4095)
+  ib_srpt uses a shared receive queue (SRQ) for processing incoming SRP
+  requests. This number may have to be increased when a large number of
+  initiator systems is accessing a single SRP target system.
+* srpt_sq_size (number, default 4096)
+  Per-channel InfiniBand send queue size. The default setting is sufficient
+  for a credit limit of 128. Changing this parameter to a smaller value may
+  cause RDMA requests to be retried and hence may slow down data transfer
+  severely.
+* thread (0, 1 or 2, default 1)
+  Defines the context on which SRP requests are processed:
+  * thread=0: do as much processing in IRQ context as possible. Results in
+    lower latency than the other two modes but may trigger soft lockup
+    complaints when multiple initiators are simultaneously processing
+    workloads with large I/O depths. Scalability of this mode is limited
+    - it exploits only a fraction of the power available on multiprocessor
+    systems.
+  * thread=1: dedicates one kernel thread per initiator. Scales well on
+    multiprocessor systems. This is the recommended mode when multiple
+    initiator systems are accessing the same target system simultaneously.
+  * thread=2: makes one CPU process all IB completions and defer further
+    processing to kernel thread context. Scales better than mode thread=0 but
+    not as good as mode thread=1. May trigger soft lockup complaints when
+    multiple initiators are simultaneously processing workloads with large I/O
+    depths.
+* trace_flag (unsigned integer, only available in debug builds)
+  The individual bits of the trace_flag parameter define which categories of
+  trace messages should be sent to the kernel log and which ones not.
-- 
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
