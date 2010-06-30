From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: sg: remove disk while doing IO -> WARNING: at block/blk-core.c:1080 __blk_put_request
Date: Wed, 30 Jun 2010 08:31:56 -0400
Message-ID: <AC1B83CE65082B4DBDDB681ED2F6B2EF866C90@EXHQ.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:46721 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0F3NC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 09:02:29 -0400
Received: from EXHQ.corp.stratus.com (exhq.corp.stratus.com [134.111.201.100])
	by mailhub5.stratus.com (8.12.11/8.12.11) with ESMTP id o5UCVSSh002638
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2010 08:31:28 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I hit the following warning after removing a disk
(/sys/class/scsi_device/.../device/delete) while doing IO via sg_dd:

Jun 29 09:37:47 wyvern kernel: ------------[ cut here ]------------
Jun 29 09:37:47 wyvern kernel: WARNING: at block/blk-core.c:1080
__blk_put_request+0xc6/0xe0()
Jun 29 09:37:47 wyvern kernel: Hardware name: ftServer 4500
Jun 29 09:37:47 wyvern kernel: Modules linked in: autofs4 sunrpc
be2iscsi bnx2i cnic uio cxgb3i iw_cxgb3 cxgb3 mdio ib_iser rdma_cm ib_cm
iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_multipath dm_mod
kvm_intel kvm uinput sg serio_raw shpchp pcspkr ext3 jbd mbcache raid1
sd_mod crc_t10dif lpfc mptsas scsi_transport_fc mptscsih mptbase
scsi_tgt scsi_transport_sas [last unloaded: scsi_wait_scan]
Jun 29 09:37:47 wyvern kernel: Pid: 7176, comm: sg_dd Not tainted 2.6.34
#2
Jun 29 09:37:47 wyvern kernel: Call Trace:
Jun 29 09:37:47 wyvern kernel: [<ffffffff8105d5fb>]
warn_slowpath_common+0x7b/0xc0
Jun 29 09:37:47 wyvern kernel: [<ffffffff8105d654>]
warn_slowpath_null+0x14/0x20
Jun 29 09:37:47 wyvern kernel: [<ffffffff811fdd86>]
__blk_put_request+0xc6/0xe0
Jun 29 09:37:47 wyvern kernel: [<ffffffff811fe53a>]
blk_put_request+0x3a/0x60
Jun 29 09:37:47 wyvern kernel: [<ffffffffa0160a97>]
sg_finish_rem_req+0x67/0x110 [sg]
Jun 29 09:37:47 wyvern kernel: [<ffffffffa0162e27>]
sg_common_write+0x537/0x580 [sg]
Jun 29 09:37:47 wyvern kernel: [<ffffffff811fdc2c>] ?
__freed_request+0x10c/0x140
Jun 29 09:37:47 wyvern kernel: [<ffffffffa0163092>]
sg_new_write+0x222/0x320 [sg]
Jun 29 09:37:47 wyvern kernel: [<ffffffffa0163cf7>] sg_ioctl+0xb67/0xd40
[sg]
Jun 29 09:37:47 wyvern kernel: [<ffffffff8107caa0>] ?
autoremove_wake_function+0x0/0x40
Jun 29 09:37:47 wyvern kernel: [<ffffffff8149f4c7>] ?
_lock_kernel+0x47/0xb3
Jun 29 09:37:47 wyvern kernel: [<ffffffff811512ff>] vfs_ioctl+0x9f/0xf0
Jun 29 09:37:47 wyvern kernel: [<ffffffff811518f4>]
do_vfs_ioctl+0x84/0x590
Jun 29 09:37:47 wyvern kernel: [<ffffffff81151e81>] sys_ioctl+0x81/0xa0
Jun 29 09:37:47 wyvern kernel: [<ffffffff8100b072>]
system_call_fastpath+0x16/0x1b
Jun 29 09:37:47 wyvern kernel: ---[ end trace c893c8e73cd7fd18 ]---

This is:

   1070 void __blk_put_request(struct request_queue *q, struct request
*req)
   1071 {
   1072 	if (unlikely(!q))
   1073 		return;
   1074 	if (unlikely(--req->ref_count))
   1075 		return;
   1076 
   1077 	elv_completed_request(q, req);
   1078 
   1079 	/* this is a bio leak */
   1080 	WARN_ON(req->bio != NULL);

Adding a 1 sec sleep just before this check on sdp->detached makes it
much easier to hit, but I did hit it originally without the sleep.

    707 sg_common_write(Sg_fd * sfp, Sg_request * srp,
    708 		unsigned char *cmnd, int timeout, int blocking)
    709 {
...
    731 	if (sdp->detached) {
    732 		sg_finish_rem_req(srp);
    733 		return -ENODEV;
    734 	}

I'm not sure what needs to be done to fix this (does sg_finish_rem_req
just need to null out req->bio, or is some cleanup actually missing?),
but I'm happy to test out a fix if anyone has any suggestions.

Thanks,

Nate Dailey,
Stratus Technologies

