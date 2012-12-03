From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v6 10/13] Make scsi_remove_host() wait for device removal
Date: Mon, 03 Dec 2012 09:23:59 +0100
Message-ID: <50BC619F.7060707@acm.org>
References: <50B60619.4080406@acm.org> <50B608C1.6080803@acm.org> <20121202134515.GJ15930@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:59462 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2LCIYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 03:24:04 -0500
In-Reply-To: <20121202134515.GJ15930@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On 12/02/12 14:45, Tejun Heo wrote:
> On Wed, Nov 28, 2012 at 01:51:13PM +0100, Bart Van Assche wrote:
>> +/* Test whether scsi_remove_host() may finish, and if so, wake it up. */
>> +void __scsi_check_remove_host_done(struct Scsi_Host *shost)
>> +{
>> +	lockdep_assert_held(shost->host_lock);
>> +
>> +	if (__scsi_remove_host_done(shost))
>> +		wake_up(&shost->remove_host);
>> +}
>
> This being an one-time thing.  Using completion could be simpler.  e.g.

Sorry but I'm not sure that would work here. A user can e.g. delete all 
SCSI devices associated with a SCSI host (echo 1 
 >/sys/class/scsi_host/host<n>/device/target<m>/<lun>/delete) and then 
issue a rescan to re-add LUNs. When using a completion the completion 
would be set as soon as the last SCSI device has been deleted instead of 
only after scsi_remove_host() finished removing the re-added SCSI devices.

Bart.

