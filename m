From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] i/o error due to all path failure with rdac
Date: Thu, 30 Oct 2008 10:34:53 -0700
Message-ID: <20081030173453.GB23948@linux.vnet.ibm.com>
References: <49022078.6010700@datadirectnet.com> <E463DF2B2E584B4A82673F53D62C2EF45BD3B893@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:49076 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYJ3RfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 13:35:17 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9UHYvwY016836
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 11:34:57 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9UHZ9v5115562
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 11:35:10 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9UHYwXB010285
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 11:35:09 -0600
Content-Disposition: inline
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BD3B893@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Moger, Babu <Babu.Moger@lsi.com> wrote:
> 
> Hi,
> 
>   I am running an online/offline test. I have two paths to the controller. One is active and one is passive. When I fail (offline) the active path (sde 8:64), the Device mapper is failing passive path(sdf 8:80) as well leading to all path failure.  Any ideas or hints?
> 

What version of multipath tools and kernel are you running? If this is a
newer kernel I would have expected to see "queueing MODE_SELECT command"
during failover.

> Here is output multipath -ll. I have only one lun.
> 
> [root@localhost ~]# multipath -ll
> mpathie (3600a0b80000f6a7d0000cff048fed59c) dm-2 LSI,INF-01-00
> [size=10G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=2][enabled]
>  \_ 3:0:0:0 sde 8:64  [active][undef]
> \_ round-robin 0 [prio=1][enabled]
>  \_ 3:0:1:0 sdf 8:80  [active][undef]
> 
> 
> Here is the detailed log.
> 
> Oct 24 16:50:50 localhost multipathd: sdf: rdac prio = 0
> Oct 24 16:51:06 localhost kernel: sd 3:0:0:0: [sde] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
> Oct 24 16:51:06 localhost kernel: end_request: I/O error, dev sde, sector 1047072
> Oct 24 16:51:06 localhost kernel: device-mapper: multipath: Failing path 8:64.
> Oct 24 16:51:06 localhost multipathd: mpathie: rr_weight = 2 (controller setting)
> Oct 24 16:51:06 localhost multipathd: mpathie: pgfailback = 100 (controller setting)
> Oct 24 16:51:06 localhost multipathd: mpathie: no_path_retry = 10 (controller setting)
> Oct 24 16:51:06 localhost multipathd: pg_timeout = NONE (internal default)
> Oct 24 16:51:06 localhost multipathd: 8:64: mark as failed
> Oct 24 16:51:06 localhost multipathd: uevent 'change' from '/block/dm-2'
> Oct 24 16:51:06 localhost multipathd: UDEV_LOG=3
> Oct 24 16:51:06 localhost multipathd: ACTION=change
> Oct 24 16:51:06 localhost multipathd: DEVPATH=/block/dm-2
> Oct 24 16:51:06 localhost multipathd: SUBSYSTEM=block
> Oct 24 16:51:06 localhost multipathd: DM_TARGET=multipath
> Oct 24 16:51:06 localhost multipathd: DM_ACTION=PATH_FAILED
> Oct 24 16:51:06 localhost multipathd: DM_SEQNUM=1
> Oct 24 16:51:06 localhost multipathd: DM_PATH=8:64
> Oct 24 16:51:06 localhost multipathd: DM_NR_VALID_PATHS=1
> Oct 24 16:51:06 localhost multipathd: DM_NAME=mpathie
> Oct 24 16:51:06 localhost multipathd: DM_UUID=mpath-3600a0b80000f6a7d0000cff048fed59c
> Oct 24 16:51:06 localhost multipathd: MAJOR=253
> Oct 24 16:51:06 localhost multipathd: MINOR=2
> Oct 24 16:51:06 localhost multipathd: DEVTYPE=disk
> Oct 24 16:51:06 localhost multipathd: SEQNUM=1254
> Oct 24 16:51:06 localhost multipathd: UDEVD_EVENT=1
> Oct 24 16:51:06 localhost multipathd: dm-2: add map (uevent)
> Oct 24 16:51:08 localhost kernel: device-mapper: multipath: Failing path 8:80.
> Oct 24 16:51:08 localhost multipathd: mpathie: devmap event #3
> Oct 24 16:51:08 localhost multipathd: mpathie: discover
> Oct 24 16:51:08 localhost multipathd: mpathie: rr_weight = 2 (controller setting)
> Oct 24 16:51:08 localhost multipathd: mpathie: pgfailback = 100 (controller setting)
> Oct 24 16:51:08 localhost multipathd: mpathie: no_path_retry = 10 (controller setting)
> Oct 24 16:51:08 localhost multipathd: pg_timeout = NONE (internal default)
> Oct 24 16:51:08 localhost multipathd: 8:80: mark as failed
> Oct 24 16:51:08 localhost multipathd: mpathie: Entering recovery mode: max_retries=10
> Oct 24 16:51:08 localhost multipathd: uevent 'change' from '/block/dm-2'
> Oct 24 16:51:08 localhost multipathd: UDEV_LOG=3
> Oct 24 16:51:08 localhost multipathd: ACTION=change
> Oct 24 16:51:08 localhost multipathd: DEVPATH=/block/dm-2
> Oct 24 16:51:08 localhost multipathd: SUBSYSTEM=block
> Oct 24 16:51:08 localhost multipathd: DM_TARGET=multipath
> Oct 24 16:51:08 localhost multipathd: DM_ACTION=PATH_FAILED
> Oct 24 16:51:08 localhost multipathd: DM_SEQNUM=2
> Oct 24 16:51:08 localhost multipathd: DM_PATH=8:80
> Oct 24 16:51:08 localhost multipathd: DM_NR_VALID_PATHS=0
> Oct 24 16:51:08 localhost multipathd: DM_NAME=mpathie
> Oct 24 16:51:08 localhost multipathd: DM_UUID=mpath-3600a0b80000f6a7d0000cff048fed59c
> Oct 24 16:51:08 localhost multipathd: MAJOR=253
> Oct 24 16:51:08 localhost multipathd: MINOR=2
> Oct 24 16:51:08 localhost multipathd: DEVTYPE=disk
> Oct 24 16:51:08 localhost multipathd: SEQNUM=1255
> Oct 24 16:51:08 localhost multipathd: UDEVD_EVENT=1
> Oct 24 16:51:08 localhost multipathd: dm-2: add map (uevent)
> Oct 24 16:51:36 localhost kernel:  rport-3:0-2: blocked FC remote port time out: removing target and saving binding
> Oct 24 16:51:36 localhost multipathd: sde: rdac checker reports path is down
> Oct 24 16:51:36 localhost multipathd: sde: mask = 0x8
> Oct 24 16:51:36 localhost kernel: sd 3:0:0:0: [sde] Synchronizing SCSI cache
> Oct 24 16:51:36 localhost kernel: sd 3:0:0:0: [sde] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> Oct 24 16:51:36 localhost kernel: scsi 3:0:0:0: rdac: Detached
> Oct 24 16:51:36 localhost multipathd: uevent 'remove' from '/class/scsi_generic/sg5'
> Oct 24 16:51:36 localhost multipathd: UDEV_LOG=3
> Oct 24 16:51:36 localhost multipathd: ACTION=remove
> Oct 24 16:51:36 localhost multipathd: DEVPATH=/class/scsi_generic/sg5
> Oct 24 16:51:36 localhost multipathd: SUBSYSTEM=scsi_generic
> Oct 24 16:51:36 localhost multipathd: MAJOR=21
> Oct 24 16:51:36 localhost multipathd: MINOR=5
> Oct 24 16:51:36 localhost multipathd: PHYSDEVPATH=/devices/pci0000:00/0000:00:02.0/0000:06:00.3/0000:0b:01.0/host3/rport-3:0-2/target3:0:0/3:0:0:0
> Oct 24 16:51:36 localhost multipathd: PHYSDEVBUS=scsi
> Oct 24 16:51:36 localhost multipathd: PHYSDEVDRIVER=sd
> Oct 24 16:51:36 localhost multipathd: SEQNUM=1256
> Oct 24 16:51:36 localhost multipathd: UDEVD_EVENT=1
> Oct 24 16:51:36 localhost multipathd: DEVNAME=/dev/sg5
> Oct 24 16:51:36 localhost multipathd: uevent 'remove' from '/class/scsi_device/3:0:0:0'
> Oct 24 16:51:36 localhost multipathd: UDEV_LOG=3
> Oct 24 16:51:36 localhost kernel: device-mapper: multipath: Failing path 8:80.
> Oct 24 16:51:36 localhost multipathd: ACTION=remove
> Oct 24 16:51:36 localhost UnixSmash4[9200]: 7:UnixSmash has experienced a write failure.
> 
> Thanks
> Babu Moger
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
