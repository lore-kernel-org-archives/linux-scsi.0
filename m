From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v11 4/9] Disallow changing the device state via sysfs
 into "deleted"
Date: Mon, 24 Jun 2013 17:59:01 +0000
Message-ID: <1372096740.2013.54.camel@dabdike.int.hansenpartnership.com>
References: <51B86E26.6030108@acm.org> <51B86F40.3020407@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:44491 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3FXR7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 13:59:03 -0400
In-Reply-To: <51B86F40.3020407@acm.org>
Content-Language: en-US
Content-ID: <EF169D7F9994624B8438711C5230D81F@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

On Wed, 2013-06-12 at 14:53 +0200, Bart Van Assche wrote:
> Changing the state of a SCSI device via sysfs into "cancel" or
> "deleted" prevents removal of these devices by scsi_remove_host().
> Hence do not allow this. Also, introduce the symbolic name
> INVALID_SDEV_STATE, representing a value different from any valid
> SCSI device state. Update scsi_device_set_state() such that gcc
> does not issue a warning about an enumeration value not being
> handled inside a switch statement.

zero is the invalid state, that's why the SDEV_ states start at 1.
Using a bare zero also means that gcc doesn't have to consider it in the
switch statement, so there's no need to introduce a new one.

If we want to try to babysit user initiated state changes, then it looks
like OFFLINE<->RUNNING might be the only useful ones?

James

