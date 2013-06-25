From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 3/9] Avoid calling __scsi_remove_device() twice
Date: Tue, 25 Jun 2013 10:37:18 +0200
Message-ID: <51C956BE.7070303@acm.org>
References: <51B86E26.6030108@acm.org> <51B86EF9.7080406@acm.org> <1372095492.2013.42.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:50150 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3FYIhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jun 2013 04:37:33 -0400
In-Reply-To: <1372095492.2013.42.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

On 06/24/13 19:38, James Bottomley wrote:
> On Wed, 2013-06-12 at 14:52 +0200, Bart Van Assche wrote:
>> SCSI devices are added to the shost->__devices list from inside
>> scsi_alloc_sdev(). If something goes wrong during LUN scanning,
>> e.g. a transport layer failure occurs, then __scsi_remove_device()
>> can get invoked by the LUN scanning code for a SCSI device in
>> state SDEV_CREATED_BLOCK or SDEV_BLOCKED. If this happens then
>> the SCSI device has not yet been added to sysfs (is_visible == 0).
>> Make sure that if this happens these devices are transitioned
>> into state SDEV_DEL. This avoids that __scsi_remove_device()
>> gets invoked a second time by scsi_forget_host().
> 
> The current principle is that scsi_remove_device can fail, so the
> condition you're avoiding is expected.  If you want to make it always
> succeed, we have to worry about any device state racing with an
> asynchronous remove, which looks like a whole nasty can of worms.
> 
> The change log makes it sound like what you actually want to enable is
> the ability to remove devices which fail probing but which are in the
> blocked state, so why not just respin with only that, which is just
> adding the blocked states to the ->SDEV_DEL state transitions?

If what you had in mind is the patch below, I think we agree:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e3d6276..eaea242 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2185,6 +2185,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_CANCEL:
+		case SDEV_BLOCK:
+		case SDEV_CREATED_BLOCK:
 			break;
 		default:
 			goto illegal;


