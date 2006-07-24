From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [SRP] [RFC] Needed changes to support fail-over drivers
Date: Mon, 24 Jul 2006 15:34:14 -0700
Message-ID: <ada8xmiiqe1.fsf@cisco.com>
References: <20060724165602.GA8600@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:25500 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S932301AbWGXWeT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 18:34:19 -0400
In-Reply-To: <20060724165602.GA8600@mellanox.co.il> (Ishai Rabinovitz's message of "Mon, 24 Jul 2006 19:56:02 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ishai Rabinovitz <ishai@mellanox.co.il>
Cc: linux-scsi@vger.kernel.org, openib-general@openib.org, Roland Dreier <rolandd@cisco.com>, vu@mellanox.com

[CC'ing linux-scsi as well -- I think we'll get better insight from there]

 > The current SRP initiator code cannot work with several fail-over mechanisms. 
 > 
 > The current srp driver's behavior when a target off-line then online:
 > 1) The target is offline.
 > 2) the initiator tries to reconnect and fails
 > 3) The initiator calls srp_remove_work that removes the scsi_host.
 > 4) The target is back online.
 > 5) the user (or the ibsrpdm daemon) is expected to execute a new add_target.
 > 6) This creates a new scsi_host (with new names to the devices and new index in
 > the scsi_host directory in sysfs) for this target.
 > 
 > Fail-over drivers (e.g., MPP that is used by Engenio and XVM that is used by
 > SGI) have problems with this behavior (item 3). They need the scsi_host to keep
 > exist and return errors in the meanwhile until the connection to the target
 > resumes.

OK, but is this a valid assumption?  What happens for iSCSI and/or iSER?

 > In addition remove/re-alloc scsi host is a "heavy" operation instead of
 > disconnect/reconnect the connection only.
 > 
 > In order to support these tools I propose the following changes that will allow
 > the user to move the srp initiator to a disconnected state (when the target
 > leaves the fabric) and reconnect it later (when the target returns to the
 > fabric).

Seems OK but see below...

 > After these changes will be in the ib_srp module, the ibsrpdm daemon will be
 > able to monitor the presence of targets in the fabric and to use this interface
 > (When targets leave or rejoin the fabric).

How does the daemon know when something is gone for good vs. when it
might come back?

 > Here is the description of the new design: (I already implemented most of the
 > code)
 > 
 > 1) Split the function srp_reconnect_target into two functions:
 > _srp_disconnect_target and _srp_reconnect_target 
 > 
 > 2) Adding two new states: SRP_TARGET_DISCONNECTED (The state after
 > _srp_disconnect_target was executed and before _srp_reconnect_target is
 > executed) and SRP_TARGET_DISCONNECTING (The state while in srp_remove_target).
 > 
 > 3) Adding new input files in sysfs:
 > /sys/class/scsi_host/host?/{disconnect_target,connect_target,erase_target}
 > 
 > 4) Writing the string "remove" to /sys/class/scsi_host/host?/disconnect_target
 > calls srp_disconnect_target that moves the corresponding target to a
 > SRP_TARGET_DISCONNECTED state (After closing the cm, and reset all pending
 > requests).  Now when the scsi performs queuecommand to this host the result is
 > DID_NO_CONNECT.  This causes the scsi mid-layer to return to the user with an
 > IO error without initiating the scsi error auto recovery chain.

Why does userspace need to be able to disconnect a connection?

 > 5) Writing anything to /sys/class/scsi_host/host?/reconnect_target calls
 > _srp_reconnect_target that move the target to SRP_TARGET_LIVE state again.
 > 
 > 6) Writing "erase" to /sys/class/scsi_host/host?/erase_target calls
 > srp_remove_work that removes the scsi_host.

Why the asymmetry here?  In other words, why does anything work for
reconnect_target but only the literal "erase" work for erase_target?

 > 7) Adding output files in sysfs to present the HCA and port that the initiator
 > used to connect to the target. Using these files and the target GUID the
 > ibsrpdm can know on which scsi_host to perform the reconnect_target.
