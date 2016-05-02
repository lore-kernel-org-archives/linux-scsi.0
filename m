From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2.5 3/6] scsi_debug: add multiple queue support
Date: Mon, 2 May 2016 10:35:53 +0200
Message-ID: <57271169.8020204@suse.de>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-4-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbcEBIf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2016 04:35:56 -0400
In-Reply-To: <1462070687-12689-4-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 05/01/2016 04:44 AM, Douglas Gilbert wrote:
> Add submit_queue parameter (minimum and default: 1; maximum:
> nr_cpu_ids) that controls how many queues are built, each with
> their own lock and in_use bit vector. Add statistics parameter
> which is default on.
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 680 +++++++++++++++++++++++++++++-------=
----------
>  1 file changed, 426 insertions(+), 254 deletions(-)
>=20
Two general questions for this:

- Why do you get rid of the embedded command payload?
  Where's the benefit of allocating the commands yourself?
- Wouldn't it be better to move to a per-cpu structure per queue?
  Each queue will be tacked to a CPU anyway, so you could be using
  per-cpu structures. Otherwise you'll run into synchronization
  issues, and any performance gain you might get from scsi-mq is
  lost as you to synchronize on the lower level.

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
