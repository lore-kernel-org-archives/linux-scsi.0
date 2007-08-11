From: Jurij Smakov <jurij@wooyd.org>
Subject: Re: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Sat, 11 Aug 2007 16:04:54 +0100
Message-ID: <20070811150454.GA5808@droopy.oc.cox.net>
References: <20070419132459.GB1481@korben.rdu.redhat.com> <1176991356.31764.3.camel@mulgrave.il.steeleye.com> <20070419150655.GC1481@korben.rdu.redhat.com> <20070421002345.673d9988.akpm@linux-foundation.org> <20070421135956.GA22873@korben.rdu.redhat.com> <20070423181318.GD22873@korben.rdu.redhat.com> <1177352786.6284.51.camel@mulgrave.il.steeleye.com> <463A3F79.80809@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sumo.dreamhost.com ([66.33.216.29]:34281 "EHLO
	sumo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbXHKPI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Aug 2007 11:08:26 -0400
Content-Disposition: inline
In-Reply-To: <463A3F79.80809@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Josef Bacik <jwhiter@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

[Please keep me on CC, as I'm not on LKML.]

On Thu, May 03, 2007 at 04:00:57PM -0400, James Smart wrote:
> I doubt it's in the fc transport - it's doing what it always did, which has
> nothing to do with coherency of the sdev's.
>
> We're seeing like problems, and it looks like it's related to the 
> scan_mutex
> being held when some of the entry points are being called via the recent
> async scan code (which also still has a bunch of issues around rmmod).
> We should be sending some patches shortly.

Hi James,

I've recently got a Sun Blade 1000 box with a QLA2200 controller, and 
I'm bumping into exact same problem with 2.6.22:

scsi 0:0:0:0: Attached scsi generic sg1 type -1
scsi 0:0:0:0: Direct-Access     HITACHI  DKR1C-J072FC     D7V5 PQ: 0 
ANSI: 3
kobject_add failed for 0:0:0:0 with -EEXIST, don't try to register 
things with the same name in the same directory.
Call Trace:
 [000000001000ac78] scsi_sysfs_add_sdev+0x2c/0x228 [scsi_mod]
 [0000000010008a68] scsi_probe_and_add_lun+0x97c/0xab8 [scsi_mod]
 [00000000100090d8] __scsi_scan_target+0x90/0x660 [scsi_mod]
 [0000000010009ce8] scsi_scan_target+0x94/0xa4 [scsi_mod]
 [00000000100668bc] fc_scsi_scan_rport+0x68/0x8c [scsi_transport_fc]
 [000000000046de88] run_workqueue+0xac/0x138
 [000000000046e414] worker_thread+0xc4/0xd4
 [0000000000471f24] kthread+0x4c/0x78
 [00000000004277f8] kernel_thread+0x38/0x48
 [0000000000471d84] kthreadd+0xbc/0x160
error 1

After that the device fails to initialize. On rare occasions the 
error does not trigger, and then machine boots fine. The complete boot
log can be found at http://www.wooyd.org/misc/dmesg-blade1000-2.6.22.log
 
I'm willing to test any patches you might have, as well as provide any 
additional debugging information.

Best regards,
-- 
Jurij Smakov                                           jurij@wooyd.org
Key: http://www.wooyd.org/pgpkey/                      KeyID: C99E03CC
