From: James.Smart@Emulex.Com
Subject: [PATCH  0/2  scsi-rc-fixes-2.6] Repost: FC Remote Port patch (+midlayer rework)
Date: Tue, 8 Feb 2005 23:18:11 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EB45@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:62198 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261776AbVBIESN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2005 23:18:13 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j194ICni006063
	for <linux-scsi@vger.kernel.org>; Tue, 8 Feb 2005 20:18:12 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The following 2 patches address work relative to the FC remote port patch
that was posted several weeks ago.

The patches perform 3 major changes:

- In background discussions with James Bottomley, one area of the patch
  that was disliked was the independence of the remote port object
  and the scsi target. In the original patch, they were both peers under
  the scsi host. There was an attempt to wrap the scsi target and the 
  remote port together, but failed due to the differences in the objects
  and the fact that a remote port can exist which is not a target. 

  Eventually, the decision was to attempt to link the remote port under
  the scsi host, and the scsi target under the remote port. In addition
  to solving the fc transports problem, it also enables for other transports
  to insert transport-specific objects (such as expanders in SAS).
  The first patch modifies the midlayer to enable the linking of transport
  objects between the starget and the shost. The second patch is the
  remote port patch, which utilizes this new functionality.

  NOTE: It is expected that by breaking the parent-child relationship of
  the shost and starget, we will impact some of the hotplug environment
  and things such as udev...

- After James Bottomley reworked the attribute containers/transport routines,
  the remote port patch needed to significantly be reworked. The 2nd patch
  is the updated remote port patch.

- As remote ports are becoming the desired object to interact with in the
  fc transport (not scsi targets), the scsi_target_block/unblock routines
  were replaced by remote_port_block/unblock routines, and the dev_loss
  attribute moved to the remote port.  As there are no consumers of the
  host-level block functions, that functionality was fully removed.

-- James S

PS: the fc remote port patch contains all of the functionality indicated
  by the initial posting. See : 
http://marc.theaimsgroup.com/?l=linux-scsi&m=110546151215663&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=110546207223304&w=2
