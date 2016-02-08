From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/23] ALUA device handler update, part II
Date: Mon, 8 Feb 2016 15:37:13 +0100
Message-ID: <56B8A819.7040007@suse.de>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbcBHOhP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 09:37:15 -0500
In-Reply-To: <1454942086-128704-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 02/08/2016 03:34 PM, Hannes Reinecke wrote:
> as promised here is now the second part of my ALUA device handler upd=
ate.
> This contains a major rework of the ALUA device handler as execution =
is
> moved onto a workqueue. This has the advantage that we avoid having t=
o
> do multiple calls to the same LUN (as happens frequently when failing
> over a LUN with several paths) and finally retries are handled correc=
tly.
> As some arrays are only capable of handling one STPG at a time I've a=
dded
> a blacklist flag which then uses a singlethreaded workqueue, thereby
> effectively synchronize STPG handling.
> Thanks to Bart for this suggestion.
>=20
> As usual, comments and reviews are welcome.
>=20
> Changes to v4:
> - use kfree_rcu() as suggested by hch
> - Use 'IS_ERR' instead of 'PTR_ERR' when checking for validity
>   of a pointer
> - Simplify pg assignment as suggested by hch
> - Use separate WARN_ON statements a suggested by hch
> - Fixes to avoid I/O stall on failover
>=20
> Changes to v3:
> - Use scsi_device flag for blacklisting as suggested by hch
> - Add Arrays for synchronous ALUA handling
> - Move synchronize_rcu() into release_port_group()
> - Add remaining reviewed tags
>=20
> Changes to v2:
> - Use a SCSI blacklist flag instead of a hardware handler parameter
>   for switching to synchronous ALUA handling
> - Move scsi_get_device_flags{,_keyed} to scsi_devinfo.h
> - Move flush_delayed_work() into release_port_group()
> - Rename alua_lookup_pg() into alua_find_get_pg()
> - Add __rcu annotations to keep sparse happy
>=20
> Changes to v1:
> - Include reviews from hch
> - Switch to hardware handler parameter instead of module option
>=20
> Hannes Reinecke (23):
>   scsi_dh_alua: Pass buffer as function argument
>   scsi_dh_alua: separate out alua_stpg()
>   scsi_dh_alua: Make stpg synchronous
>   scsi_dh_alua: call alua_rtpg() if stpg fails
>   scsi_dh_alua: switch to scsi_execute_req_flags()
>   scsi_dh_alua: allocate RTPG buffer separately
>   scsi_dh_alua: Use separate alua_port_group structure
>   scsi_dh_alua: use unique device id
>   scsi_dh_alua: simplify alua_initialize()
>   revert commit a8e5a2d593cb ("[SCSI] scsi_dh_alua: ALUA handler atta=
ch
>     should succeed while TPG is transitioning")
>   scsi_dh_alua: move optimize_stpg evaluation
>   scsi_dh_alua: remove 'rel_port' from alua_dh_data structure
>   scsi_dh_alua: Use workqueue for RTPG
>   scsi_dh_alua: Allow workqueue to run synchronously
>   scsi_dh_alua: Add new blacklist flag 'BLIST_SYNC_ALUA'
>   scsi_dh_alua: Recheck state on unit attention
>   scsi_dh_alua: update all port states
>   scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
>   scsi_dh: add 'rescan' callback
>   scsi: Add 'access_state' attribute
>   scsi_dh_alua: use common definitions for ALUA state
>   scsi_dh_alua: update 'access_state' field
>   scsi_dh_alua: Update version to 2.0
>=20
>  drivers/scsi/device_handler/scsi_dh_alua.c | 988 +++++++++++++++++++=
+---------
>  drivers/scsi/scsi_devinfo.c                |   2 +
>  drivers/scsi/scsi_lib.c                    |   1 +
>  drivers/scsi/scsi_scan.c                   |  12 +-
>  drivers/scsi/scsi_sysfs.c                  |  49 ++
>  include/scsi/scsi_device.h                 |   2 +
>  include/scsi/scsi_devinfo.h                |   1 +
>  include/scsi/scsi_dh.h                     |   2 +
>  include/scsi/scsi_proto.h                  |  13 +
>  9 files changed, 763 insertions(+), 307 deletions(-)
>=20
And for the impatient I've pushed the entire patchset to my kernel
repository at kernel.org:

kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git alua-2.v5

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
