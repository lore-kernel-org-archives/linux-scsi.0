From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] target/iblock: Use -EAGAIN/-ENOMEM to propigate SAM
 BUSY/TASK_SET_FULL
Date: Mon, 8 Feb 2016 08:21:51 +0100
Message-ID: <56B8420F.8060002@suse.de>
References: <1454826157-20877-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbcBHHVy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 02:21:54 -0500
In-Reply-To: <1454826157-20877-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 02/07/2016 07:22 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> This patch updates target/iblock backend driver code to
> check for bio completion status of -EAGAIN / -ENOMEM
> provided by raw block drivers and scsi devices, in order
> to generate the following SCSI status to initiators:
>=20
>   - SAM_STAT_BUSY
>   - SAM_STAT_TASK_SET_FULL
>=20
> Note these two SAM status codes are useful to signal to
> Linux SCSI host side that se_cmd should be retried
> again, or with TASK_SET_FULL case to attempt to lower
> our internal host LLD queue_depth and scsi_cmnd retry.
>=20
> It also updates target_complete_cmd() to parse status
> when signalling success to target_completion_wq.
>=20
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Andy Grover <agrover@redhat.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
