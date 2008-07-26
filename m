From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] cmd_filter fixes
Date: Sat, 26 Jul 2008 18:03:22 +0900
Message-ID: <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080724123140V.fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49442 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYGZJGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2008 05:06:00 -0400
In-Reply-To: <20080724123140V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, dan.j.williams@intel.com, adel.gadllah@gmail.com, pjones@redhat.com, viro@ZenIV.linux.org.uk, dougg@torque.net, matthew@wil.cx, fujita.tomonori@lab.ntt.co.jp

cmd_filter works only for the block layer SG_IO with SCSI block
devices. It breaks scsi/sg.c, bsg, and the block layer SG_IO with SCSI
character devices (such as st). We might hit a kernel crash with them.

The problem is that cmd_filter code accesses to gendisk (having struct
blk_scsi_cmd_filter) via inode->i_bdev->bd_disk. It works for only
SCSI block device files. With character device files, inode->i_bdev
leads you to struct cdev. inode->i_bdev->bd_disk->blk_scsi_cmd_filter
isn't safe. For example, I got the following kernel crash with bsg:

Pid: 1480, comm: bsg-test Not tainted (2.6.26-06879-gfb2e405 #1)
EIP: 0060:[<c01b02fd>] EFLAGS: 00010202 CPU: 0
EIP is at blk_cmd_filter_verify_command+0x1e/0x41
EAX: 00000000 EBX: 00000237 ECX: 00000011 EDX: 00000003
ESI: df9692ae EDI: de93485c EBP: de8ea3a8 ESP: de937e90
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process bsg-test (pid: 1480, ti=de936000 task=df8b7230 task.ti=de936000)
Stack: de937ec4 df969228 fffffff2 c01b0866 df025030 00000000 de937ec4 c01b1009 
       bf9a5b10 de8ea3a8 c01b110e 00000246 df1985f4 00000051 00000000 00000000 
       00000006 bf9a5bd2 00000000 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<c01b0866>] bsg_map_hdr+0xe7/0x225
 [<c01b1009>] bsg_ioctl+0x0/0x17c
 [<c01b110e>] bsg_ioctl+0x105/0x17c
 [<c01b1009>] bsg_ioctl+0x0/0x17c
 [<c015a11a>] vfs_ioctl+0x16/0x48
 [<c015a332>] do_vfs_ioctl+0x1e6/0x1f9
 [<c01b770c>] trace_hardirqs_on_thunk+0xc/0x10
 [<c015a371>] sys_ioctl+0x2c/0x43
 [<c01028b1>] sysenter_do_call+0x12/0x35
 =======================
Code: 10 89 fa ff d3 89 c2 89 d0 5b 5e 5f c3 57 56 53 89 c3 89 d6 89 cf b8 11 00 00 00 e8 fd 94 f6 ff 85 c0 75 1f 85 db 74 1f 0f b6 16 <0f> a3 13 19 c0 85 c0 75 0f 0f a3 53 20 19 c0 85 c0 74 09 f6 07 
EIP: [<c01b02fd>] blk_cmd_filter_verify_command+0x1e/0x41 SS:ESP 0068:de937e90
---[ end trace 0cceddb2f202a402 ]---


SCSI ULDs don't expose gendisk; they keep it private. bsg needs to be
independent on any protocols. We shouldn't change ULDs to expose their
gendisk.

This patchset moves struct blk_scsi_cmd_filter from gendisk to
request_queue, a common object, which eveyone can access to.

The user interface doesn't change; users can change the filters via
/sys/block/. gendisk has a pointer to request_queue so the cmd_filter
code accesses to struct blk_scsi_cmd_filter.



