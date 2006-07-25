From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [SRP] [RFC] Needed changes to support fail-over drivers
Date: Mon, 24 Jul 2006 22:06:39 -0400
Message-ID: <44C57CAF.7010502@cs.wisc.edu>
References: <20060724165602.GA8600@mellanox.co.il> <ada8xmiiqe1.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40129 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932384AbWGYCJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 22:09:45 -0400
In-Reply-To: <ada8xmiiqe1.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Ishai Rabinovitz <ishai@mellanox.co.il>, linux-scsi@vger.kernel.org, openib-general@openib.org, Roland Dreier <rolandd@cisco.com>, vu@mellanox.com

Roland Dreier wrote:
> [CC'ing linux-scsi as well -- I think we'll get better insight from there]
> 
>  > The current SRP initiator code cannot work with several fail-over mechanisms. 
>  > 
>  > The current srp driver's behavior when a target off-line then online:
>  > 1) The target is offline.
>  > 2) the initiator tries to reconnect and fails
>  > 3) The initiator calls srp_remove_work that removes the scsi_host.
>  > 4) The target is back online.
>  > 5) the user (or the ibsrpdm daemon) is expected to execute a new add_target.
>  > 6) This creates a new scsi_host (with new names to the devices and new index in
>  > the scsi_host directory in sysfs) for this target.
>  > 
>  > Fail-over drivers (e.g., MPP that is used by Engenio and XVM that is used by
>  > SGI) have problems with this behavior (item 3). They need the scsi_host to keep
>  > exist and return errors in the meanwhile until the connection to the target
>  > resumes.
> 
> OK, but is this a valid assumption?  What happens for iSCSI and/or iSER?

I do not see why the host has to remain constant for the above problem.
I can understand why it may be easier to program though. However, this
is not a requirement for other multipath drivers like dm-multipath or md
multpiath and I do not think you should rely on that type of behavior.

The short story is that I think we are moving to something similar to
what srp does very soon.

The long story....

iscsi and iser allocate a host per session (session is allocated in the
host's hostdata). If there are problems with the connection (target goes
unreachable for N number of seconds or we get some error value from the
network layer, etc) we keep the host, session, connection, target and
scsi devices around and try to reconnect. We then have a userspace
daemon that tries to reconnect to the target and relogin.

If we reconnect within X seconds (we call this the replacement_timeout
and it is similar to the FC class dev_loss_tmo), we reuse those structs
and go on as normal. If after replacement_timeout seconds we do not
reconnect, we can remove the host, session, connection, target and
scsi_devices or we can keep them around and reuse them if we later
reconnect. If we remove those structs we later have to allocate new ones
of course and will get a new host number. Whether we use the model of
reusing the structs or removing them is controlled in userspace and we
currently do the wrong thing by default and keep the structs around.

I guess what we are supposed to do is something similar to the FC class
where if dev_loss_tmo expires then we should remove the session,
connection, target and devices. I am not sure if we should be removing
the scsi host though. I think it makes sense to remove that too, since
the host and session are so closely tied in our model. We are in the
process to moving to the model where all the structs are removed as the
default and only model we support, and it looks like we will do this in
2.6.19.
