From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 85751] iSCSI initiator lockup during logout
Date: Tue, 07 Oct 2014 12:03:53 -0500
Message-ID: <54341CF9.609@cs.wisc.edu>
References: <bug-85751-11613@https.bugzilla.kernel.org/> <bug-85751-11613-AIXQdLQp7t@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36224 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbaJGREB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 13:04:01 -0400
In-Reply-To: <bug-85751-11613-AIXQdLQp7t@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 10/07/2014 11:42 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> * iscsiadm -m discovery -p 192.168.1.124 -t st
> * iscsiadm -m node -p 192.168.1.124 -l
> (something went wrong at the target side and the iSCSI initiator tried to
> relogin)

Did this login command ever complete normally? Did you ctrl-c it or did
you run the logout command below in another terminal?

> * iscsiadm -m node -p 192.168.1.124 -u

The login command looks like it is stuck waiting for scan/setup related
commands to complete:

 [<ffffffff811f54f5>] blk_execute_rq+0x75/0xf0
 [<ffffffff811f16fa>] ? blk_rq_bio_prep+0x6a/0x90
 [<ffffffff811f52b9>] ? blk_rq_map_kern+0xb9/0x160
 [<ffffffff811eef0a>] ? blk_get_request+0x7a/0xc0
 [<ffffffffa0008e3b>] scsi_execute+0xdb/0x160 [scsi_mod]
 [<ffffffffa000a52e>] scsi_execute_req_flags+0x8e/0x100 [scsi_mod]
 [<ffffffffa000c8ed>] scsi_probe_and_add_lun+0x20d/0xc40 [scsi_mod]
 [<ffffffffa0008e69>] ? scsi_execute+0x109/0x160 [scsi_mod]
 [<ffffffffa000db02>] __scsi_scan_target+0x522/0x6c0 [scsi_mod]
 [<ffffffff812e040d>] ? __pm_runtime_resume+0x4d/0x60
 [<ffffffffa000dd90>] scsi_scan_target+0xf0/0x110 [scsi_mod]
 [<ffffffffa0852d6f>] iscsi_user_scan_session.part.13+0x10f/0x150
[scsi_transport_iscsi]
 [<ffffffffa0852db0>] ? iscsi_user_scan_session.part.13+0x150/0x150
[scsi_transport_iscsi]
 [<ffffffffa0852dd1>] iscsi_user_scan_session+0x21/0x30
[scsi_transport_iscsi]


And so above it should have the ihost->mutex held while stuck.

But here it looks the logout command has been run and we have passed the
part where we take the mutex in there and already started to delete the
target.


 [<ffffffff812d41c9>] device_del+0x129/0x1c0
 [<ffffffffa0010005>] __scsi_remove_device+0xd5/0xe0 [scsi_mod]
 [<ffffffffa0010036>] scsi_remove_device+0x26/0x40 [scsi_mod]
 [<ffffffffa00101f0>] scsi_remove_target+0x170/0x230 [scsi_mod]
 [<ffffffffa0851f84>] __iscsi_unbind_session+0xc4/0x1a0
[scsi_transport_iscsi]


Before you ran the logout command, did the login/scan hang? Did we ever
log back in?

Then did you run the logout command to try and clean things up.
