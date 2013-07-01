From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v12 5/6] Avoid that scsi_device_set_state() triggers a
 race
Date: Mon, 1 Jul 2013 14:49:55 +0000
Message-ID: <1372690195.2385.20.camel@dabdike>
References: <51CC5176.90609@acm.org> <51CC52A5.2010204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:44243 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3GAOuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 10:50:05 -0400
In-Reply-To: <51CC52A5.2010204@acm.org>
Content-Language: en-US
Content-ID: <25C1EB3EDD9D2541975BBA5702144471@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>


On Thu, 2013-06-27 at 16:56 +0200, Bart Van Assche wrote:
> Make concurrent invocations of scsi_device_set_state() safe.

Firstly, I don't understand from this where you think the races are.
Secondly, shouldn't this be the device lock? and thirdly, if we accept
that locking is required, encapsulate it in the function: Having the
callers manage locking is asking for trouble.  The latter may require a
new lock for the state to avoid entanglement.

James





