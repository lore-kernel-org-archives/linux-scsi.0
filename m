From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Fri, 28 Jun 2013 08:54:07 -0400
Message-ID: <1372424047.3871.461.camel@localhost.localdomain>
References: <1370862713-41323-1-git-send-email-hare@suse.de>
	 <1370862713-41323-8-git-send-email-hare@suse.de>
	 <1372343589.3871.406.camel@localhost.localdomain>
	 <51CD37EE.4000803@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab3F1Myy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 08:54:54 -0400
In-Reply-To: <51CD37EE.4000803@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Fri, 2013-06-28 at 09:14 +0200, Hannes Reinecke wrote:

> >> @@ -232,6 +272,9 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
> >>  		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
> >>  			goto out_unlock;
> >>  
> >> +	if (sdev->eh_deadline && !shost->last_reset)
> >> +		shost->last_reset = jiffies;
> >> +
> > 
> > I think this is supposed to be if (shost->eh_deadline ...
> > 
> No. ->last_reset is set to the time the first command timeout/failure.
> 
> ->last_reset + ->eh_deadline will give you the expiry time.

Sorry, I wasn't clear what I meant.  What I meant was:

          if (shost->eh_deadline && !shost->last_reset)
                  shost->last_reset = jiffies;

...because the eh_deadline field is in struct Scsi_Host, not
in struct scsi_device.

-Ewan



