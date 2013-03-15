From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Fri, 15 Mar 2013 12:55:54 +0100
Message-ID: <51430C4A.7090308@suse.de>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab3COLz6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 07:55:58 -0400
In-Reply-To: <51421272.2000706@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

On 03/14/2013 07:09 PM, Steffen Maier wrote:
> Just for my understanding:
> So this is a bit like writing 0 into the failed attribute of a
> zfcp_port in sysfs (zfcp_sysfs_port_failed_store()) which forces a
> port reopen recovery including a sequence of fc_remote_port_delete
> and fc_remote_port_add?
Sorta.
This patch simulates the result of an RSCN where this remote port is=20
missing. So the fast_io_fail / dev_loss_tmo mechanism is triggered=20
(until further notice).
It'll be reset with the next RSCN or by manually resetting the port=20
state.

> If so, it sounds good to have this functionality for any FC LLD in
> common code.

That's why I posted this code :-)
Rationale for this patch is a weird test case with brocade switches;
there you can actually disable a _target_ port. So the port isn't
reachable anymore but no RSCN is send.
And the LLDD is forced into error recovery which'll take _ages_ as=20
each and every command send during error recovery will time out.

> (And I can think about deprecating parts of zfcp code, next we could
> consider the same for zfcp's forced LUN and adapter recovery or
> maybe this already exists as sdev's writable state attribute and the
> adapter recovery can be performed manually by walking all fc_rports
> writing their port_state.)
>
I don't think the sdev 'state' attribute is useable here; it doesn't=20
trigger a rediscovery. You'd want to use 'rescan' here.
But yeah, that would be one of the goals.

Still waiting for some response to the patch, though.
Testing has been successful on our side, plus I've posted
a patchset for multipath-tools utilizing this patch.

So it would be good if it could be included.

James?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
