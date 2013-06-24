From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v11 3/9] Avoid calling __scsi_remove_device() twice
Date: Mon, 24 Jun 2013 17:38:13 +0000
Message-ID: <1372095492.2013.42.camel@dabdike.int.hansenpartnership.com>
References: <51B86E26.6030108@acm.org> <51B86EF9.7080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:54392 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FXRiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 13:38:15 -0400
In-Reply-To: <51B86EF9.7080406@acm.org>
Content-Language: en-US
Content-ID: <DCEF74F35D6EB64F8F8C4E68007AAA9C@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

On Wed, 2013-06-12 at 14:52 +0200, Bart Van Assche wrote:
> SCSI devices are added to the shost->__devices list from inside
> scsi_alloc_sdev(). If something goes wrong during LUN scanning,
> e.g. a transport layer failure occurs, then __scsi_remove_device()
> can get invoked by the LUN scanning code for a SCSI device in
> state SDEV_CREATED_BLOCK or SDEV_BLOCKED. If this happens then
> the SCSI device has not yet been added to sysfs (is_visible == 0).
> Make sure that if this happens these devices are transitioned
> into state SDEV_DEL. This avoids that __scsi_remove_device()
> gets invoked a second time by scsi_forget_host().

The current principle is that scsi_remove_device can fail, so the
condition you're avoiding is expected.  If you want to make it always
succeed, we have to worry about any device state racing with an
asynchronous remove, which looks like a whole nasty can of worms.

The change log makes it sound like what you actually want to enable is
the ability to remove devices which fail probing but which are in the
blocked state, so why not just respin with only that, which is just
adding the blocked states to the ->SDEV_DEL state transitions?

James

