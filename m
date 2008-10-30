From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [dm-devel] i/o error due to all path failure with rdac
Date: Thu, 30 Oct 2008 15:23:37 -0700
Message-ID: <1225405417.14830.1001.camel@chandra-ubuntu>
References: <49022078.6010700@datadirectnet.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD3B893@cosmail01.lsi.com>
	 <20081030173453.GB23948@linux.vnet.ibm.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D049@cosmail01.lsi.com>
	 <1225396981.14830.990.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D0AD@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:47384 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYJ3WYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 18:24:40 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9UMNc3C013805
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 16:23:38 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9UMObQ7146406
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 16:24:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9UMO7VU003403
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 16:24:08 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BD9D0AD@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Thu, 2008-10-30 at 14:30 -0600, Moger, Babu wrote:
> This is what happens in my case
> 
> When the active path is failed, the dh handler calls rdac_activate to activate the passive path.
> Then check_ownership is called. As you know check_ownership sends inquiry (page c9). Looking at the
> response this function sets the lun_state(h->lun_state) to RDAC_LUN_OWNED.
> 
> If lun_state is set to RDAC_LUN_OWNED then send_mode_select will not be called. This is what
> happens in my case.

Ok. Now it is clear. I thought the port was disabled.

The rport failure in the log you sent made me think that it was a port
disable. Why was there a rport failure ?

Can you add these two lines at the top of
scsi_dn_rdac.c:rdac_check_sense() function, retest and send me the log.
------------
        sdev_printk(KERN_ERR, sdev, "sense_key:%x; asc %c; ascq %x\n",
                sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
-----------
I want to see if we are getting any special sense that we are not
handling.


> 
> PS: You are right. In case of link failures we need to transfer the luns by sending the mode
> select. But, if you offline (or fail the controller) the Luns are automatically transferred to
> alt controller. This is known behavior.
> 
> 
> Thanks
> Babu Moger
> 
> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Thursday, October 30, 2008 3:03 PM
> To: Moger, Babu
> Cc: device-mapper development; linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] i/o error due to all path failure with rdac
> 
> 
> On Thu, 2008-10-30 at 13:17 -0600, Moger, Babu wrote:
> > I am running multipath-tools v0.4.8 (I just pulled from mainstream last week) and kernel version 2.6.27-rc7.
> >
> > I am not seeing "queueing MODE_SELECT command", because this is online/offline test.  When you offline
> > the controller the luns are automatically transferred to alt controller.
> 
> No, moving the luns to the other controller is done by the rdac hardware
> handler by way of sending a MODE_SELECT to the controller.
> 
> So, we should be seeing a MODE_SELECT to the passive controller.
> 
> >
> > Thanks
> > Babu Moger
> >
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Mike Anderson
> > Sent: Thursday, October 30, 2008 12:35 PM
> > To: device-mapper development; Chandra Seetharaman
> > Cc: linux-scsi@vger.kernel.org
> > Subject: Re: [dm-devel] i/o error due to all path failure with rdac
> >
> > Moger, Babu <Babu.Moger@lsi.com> wrote:
> > >
> > > Hi,
> > >
> > >   I am running an online/offline test. I have two paths to the controller. One is active and one is passive. When I fail (offline) the active path (sde 8:64), the Device mapper is failing passive path(sdf 8:80) as well leading to all path failure.  Any ideas or hints?
> > >
> >
> > What version of multipath tools and kernel are you running? If this is a
> > newer kernel I would have expected to see "queueing MODE_SELECT command"
> > during failover.
> >
> > > Here is output multipath -ll. I have only one lun.
> > >
> > > [root@localhost ~]# multipath -ll
> > > mpathie (3600a0b80000f6a7d0000cff048fed59c) dm-2 LSI,INF-01-00
> > > [size=10G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> > > \_ round-robin 0 [prio=2][enabled]
> > >  \_ 3:0:0:0 sde 8:64  [active][undef]
> > > \_ round-robin 0 [prio=1][enabled]
> > >  \_ 3:0:1:0 sdf 8:80  [active][undef]
> > >
> > >
> > > Here is the detailed log.
> > >
> > > Oct 24 16:50:50 localhost multipathd: sdf: rdac prio = 0
> > > Oct 24 16:51:06 localhost kernel: sd 3:0:0:0: [sde] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
> > > Oct 24 16:51:06 localhost kernel: end_request: I/O error, dev sde, sector 1047072
> > > Oct 24 16:51:06 localhost kernel: device-mapper: multipath: Failing path 8:64.
> > > Oct 24 16:51:06 localhost multipathd: mpathie: rr_weight = 2 (controller setting)
> > > Oct 24 16:51:06 localhost multipathd: mpathie: pgfailback = 100 (controller setting)
> > > Oct 24 16:51:06 localhost multipathd: mpathie: no_path_retry = 10 (controller setting)
> > > Oct 24 16:51:06 localhost multipathd: pg_timeout = NONE (internal default)
> > > Oct 24 16:51:06 localhost multipathd: 8:64: mark as failed
> > > Oct 24 16:51:06 localhost multipathd: uevent 'change' from '/block/dm-2'
> > > Oct 24 16:51:06 localhost multipathd: UDEV_LOG=3
> > > Oct 24 16:51:06 localhost multipathd: ACTION=change
> > > Oct 24 16:51:06 localhost multipathd: DEVPATH=/block/dm-2
> > > Oct 24 16:51:06 localhost multipathd: SUBSYSTEM=block
> > > Oct 24 16:51:06 localhost multipathd: DM_TARGET=multipath
> > > Oct 24 16:51:06 localhost multipathd: DM_ACTION=PATH_FAILED
> > > Oct 24 16:51:06 localhost multipathd: DM_SEQNUM=1
> > > Oct 24 16:51:06 localhost multipathd: DM_PATH=8:64
> > > Oct 24 16:51:06 localhost multipathd: DM_NR_VALID_PATHS=1
> > > Oct 24 16:51:06 localhost multipathd: DM_NAME=mpathie
> > > Oct 24 16:51:06 localhost multipathd: DM_UUID=mpath-3600a0b80000f6a7d0000cff048fed59c
> > > Oct 24 16:51:06 localhost multipathd: MAJOR=253
> > > Oct 24 16:51:06 localhost multipathd: MINOR=2
> > > Oct 24 16:51:06 localhost multipathd: DEVTYPE=disk
> > > Oct 24 16:51:06 localhost multipathd: SEQNUM=1254
> > > Oct 24 16:51:06 localhost multipathd: UDEVD_EVENT=1
> > > Oct 24 16:51:06 localhost multipathd: dm-2: add map (uevent)
> > > Oct 24 16:51:08 localhost kernel: device-mapper: multipath: Failing path 8:80.
> > > Oct 24 16:51:08 localhost multipathd: mpathie: devmap event #3
> > > Oct 24 16:51:08 localhost multipathd: mpathie: discover
> > > Oct 24 16:51:08 localhost multipathd: mpathie: rr_weight = 2 (controller setting)
> > > Oct 24 16:51:08 localhost multipathd: mpathie: pgfailback = 100 (controller setting)
> > > Oct 24 16:51:08 localhost multipathd: mpathie: no_path_retry = 10 (controller setting)
> > > Oct 24 16:51:08 localhost multipathd: pg_timeout = NONE (internal default)
> > > Oct 24 16:51:08 localhost multipathd: 8:80: mark as failed
> > > Oct 24 16:51:08 localhost multipathd: mpathie: Entering recovery mode: max_retries=10
> > > Oct 24 16:51:08 localhost multipathd: uevent 'change' from '/block/dm-2'
> > > Oct 24 16:51:08 localhost multipathd: UDEV_LOG=3
> > > Oct 24 16:51:08 localhost multipathd: ACTION=change
> > > Oct 24 16:51:08 localhost multipathd: DEVPATH=/block/dm-2
> > > Oct 24 16:51:08 localhost multipathd: SUBSYSTEM=block
> > > Oct 24 16:51:08 localhost multipathd: DM_TARGET=multipath
> > > Oct 24 16:51:08 localhost multipathd: DM_ACTION=PATH_FAILED
> > > Oct 24 16:51:08 localhost multipathd: DM_SEQNUM=2
> > > Oct 24 16:51:08 localhost multipathd: DM_PATH=8:80
> > > Oct 24 16:51:08 localhost multipathd: DM_NR_VALID_PATHS=0
> > > Oct 24 16:51:08 localhost multipathd: DM_NAME=mpathie
> > > Oct 24 16:51:08 localhost multipathd: DM_UUID=mpath-3600a0b80000f6a7d0000cff048fed59c
> > > Oct 24 16:51:08 localhost multipathd: MAJOR=253
> > > Oct 24 16:51:08 localhost multipathd: MINOR=2
> > > Oct 24 16:51:08 localhost multipathd: DEVTYPE=disk
> > > Oct 24 16:51:08 localhost multipathd: SEQNUM=1255
> > > Oct 24 16:51:08 localhost multipathd: UDEVD_EVENT=1
> > > Oct 24 16:51:08 localhost multipathd: dm-2: add map (uevent)
> > > Oct 24 16:51:36 localhost kernel:  rport-3:0-2: blocked FC remote port time out: removing target and saving binding
> > > Oct 24 16:51:36 localhost multipathd: sde: rdac checker reports path is down
> > > Oct 24 16:51:36 localhost multipathd: sde: mask = 0x8
> > > Oct 24 16:51:36 localhost kernel: sd 3:0:0:0: [sde] Synchronizing SCSI cache
> > > Oct 24 16:51:36 localhost kernel: sd 3:0:0:0: [sde] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > > Oct 24 16:51:36 localhost kernel: scsi 3:0:0:0: rdac: Detached
> > > Oct 24 16:51:36 localhost multipathd: uevent 'remove' from '/class/scsi_generic/sg5'
> > > Oct 24 16:51:36 localhost multipathd: UDEV_LOG=3
> > > Oct 24 16:51:36 localhost multipathd: ACTION=remove
> > > Oct 24 16:51:36 localhost multipathd: DEVPATH=/class/scsi_generic/sg5
> > > Oct 24 16:51:36 localhost multipathd: SUBSYSTEM=scsi_generic
> > > Oct 24 16:51:36 localhost multipathd: MAJOR=21
> > > Oct 24 16:51:36 localhost multipathd: MINOR=5
> > > Oct 24 16:51:36 localhost multipathd: PHYSDEVPATH=/devices/pci0000:00/0000:00:02.0/0000:06:00.3/0000:0b:01.0/host3/rport-3:0-2/target3:0:0/3:0:0:0
> > > Oct 24 16:51:36 localhost multipathd: PHYSDEVBUS=scsi
> > > Oct 24 16:51:36 localhost multipathd: PHYSDEVDRIVER=sd
> > > Oct 24 16:51:36 localhost multipathd: SEQNUM=1256
> > > Oct 24 16:51:36 localhost multipathd: UDEVD_EVENT=1
> > > Oct 24 16:51:36 localhost multipathd: DEVNAME=/dev/sg5
> > > Oct 24 16:51:36 localhost multipathd: uevent 'remove' from '/class/scsi_device/3:0:0:0'
> > > Oct 24 16:51:36 localhost multipathd: UDEV_LOG=3
> > > Oct 24 16:51:36 localhost kernel: device-mapper: multipath: Failing path 8:80.
> > > Oct 24 16:51:36 localhost multipathd: ACTION=remove
> > > Oct 24 16:51:36 localhost UnixSmash4[9200]: 7:UnixSmash has experienced a write failure.
> > >
> > > Thanks
> > > Babu Moger
> > >
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > -andmike
> > --
> > Michael Anderson
> > andmike@linux.vnet.ibm.com
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

