From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Thu, 17 Oct 2013 10:27:56 -0400
Message-ID: <1382020076.3812.78.camel@localhost.localdomain>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
	 <1372661455-122384-8-git-send-email-hare@suse.de>
	 <1381936290.1864.11.camel@dabdike>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab3JQO2z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Oct 2013 10:28:55 -0400
In-Reply-To: <1381936290.1864.11.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

On Wed, 2013-10-16 at 19:22 +0000, James Bottomley wrote:
> What about instead:
> 
> static int scsi_host_eh_past_deadline(struct Scsi_Host *shost, int percent) {
> 	if (!shost->last_reset || !shost->eh_deadline)
> 		return 0;
> 
> 	if (time_before(jiffies,
> 			shost->last_reset + shost->eh_deadline * percent/100))
> 		return 0;
> 
> 	return 1;
> }
> 
> which allows us to have
> 
> if (scsi_host_eh_past_deadline(shost, 50)) {
> 
> in scsi_eh_abort_cmds()
> 
> if (scsi_host_eh_past_deadline(shost, 66) {
> 
> in scsi_eh_bus_device_reset()
> 
> say 83 in target reset, and 100 in bus reset.
> 
> Thus ensuring we at least get a crack at the reset chain?
> 
> James
> 

Well, conceptually that seems like a good idea, since if there
is limited time available it is probably wiser to spend it on
higher-level recovery instead of timing out trying to deal with
individual devices, but we didn't do any testing on how long
the bus device reset/target reset/bus reset take.  The host
reset was about 10 seconds for lpfc, and the maximum time was
(command timeout) + (eh deadline) + (host reset time).

However...

With this enhancement, the maximum time could be much longer if
we attempt to e.g. perform a bus reset right before the
eh_deadline expires, because drivers like lpfc iterate over the
targets and send a target reset to each one (with a timeout).

The original problem that prompted this change was that a
target became inaccessible, and nothing the EH did was ever going
to do anything except timeout, until the host reset was performed,
at which point the FC login would fail and the HBA would start
failing commands immediately instead of them timing out.

I guess the main thing is that there should be some way to
explain to people what value to use for eh_deadline in order
for I/O to complete within a specified amount of time (e.g. before
some other node in a cluster shoots us because we are unresponsive).

-Ewan




