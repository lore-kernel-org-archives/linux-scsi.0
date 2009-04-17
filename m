From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] LSF: Multipathing and path checking question
Date: Fri, 17 Apr 2009 09:55:34 -0500
Message-ID: <49E89866.50205@cs.wisc.edu>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41662 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZDQO4M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2009 10:56:12 -0400
In-Reply-To: <49E834CD.1090306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> 
> FC Transport already maintains an attribute for the path state, and even
> sends netlink events if and when this attribute changes. For iSCSI I have

Are you referring to fc_host_post_event? Is the same thing we talked 
about last year, where you wanted events? Is this in multipath tools now 
or just in the SLES ones?

For something like FCH_EVT_LINKDOWN, are you going to fail the path at 
that time or when would the multipath path be marked failed?



> to defer to your superior knowledge; of course it would be easiest if
> iSCSI could send out the very same message FC does.

We can do something like fc_host_event_code for iscsi.

Question on what you are needing:

Do you mean you want to make fc_host_event_code more generic (there are 
some FC specific ones like lip_reset)? Put them in scsi-ml and send from 
a new netlink group that just sends these events?

Or do you just want something similar from iscsi? iscsi will hook into 
the iscsi netlink code using the scsi_netlink.c and then send a 
ISCSIH_EVT_LINKUP, ISCSIH_EVT, LINKDOWN, etc.

What do the FCH_EVT_PORT_* ones means?



> 
> Idea was to modify the state machine so that fast_fail_io_tmo is
> being made mandatory, which transitions the sdev into an intermediate
> state 'DISABLED' and sends out a netlink message.


Above when you said, "No, I already do this for FC (should be checking 
the replacement_timeout, too ...)", did you mean that you have mulitpath 
tools always setting fast io fail now?

For iscsi the replacement_timeout is always set already. If from 
multipath tools you are going to add some code so multipth sets this I 
can make iscsi allow the replacement_timeout to be set from sysfs like 
is done for FC's fast io fail.



> 
> sdev state:   RUNNING <-> BLOCKED <-> DISABLED -> CANCEL
> mpath state:  path up <-> <stall> <-> path down -> remove from map
> 
> This will allow us to switch paths early, ie when it moves into
> 'DISABLED' state. But the path structure themselves are still alive,
> so when a path comes back between 'DISABLED' and 'CANCEL' we won't
> have an issue reconnecting it. And we could even allow to set a
> dev_loss_tmo to infinity thereby simulating the 'old' behaviour.
> 
> However, this proposal didn't go through.

You got my hopes up for a solution in the the long explanation, then you 
destroyed them :)


Was the reason people did not like this because of the scsi device 
lifetime issue?


I think we still want someone to set the fast io fail tmo for users when 
multipath is being used, because we want IO out of the queues and 
drivers and sent to the multipath layer before dev_loss_tmo if 
dev_loss_tmo is still going to be a lot longer. fast io fail tmo is 
usually less than 10 or 5 and for dev_loss_tmo seems like we still have 
user setting that to minutes.


Can't the transport layers just send two events?
1. On the initial link down when the port/session is blocked.
2. When there fast io fail tmos fire.

Today, instead of #2, the Red Hat multipath tools guy and I were talking 
about doing a probe with SG_IO. For example we would send down a path 
tester IO and then wait for it to be failed with DID_TRANSPORT_FAILFAST.

Or for #2 if we cannot have a new event, can we send a transport level 
bsg request? For iscsi this would be a nop. For FC, I am not sure what 
it would be?
