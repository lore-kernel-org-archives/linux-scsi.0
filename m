From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Allow activation of scsi-mq per-driver
Date: Fri, 22 Jan 2016 14:43:41 +0100
Message-ID: <56A2320D.4070800@suse.de>
References: <1453470088-43959-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbcAVNnm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 08:43:42 -0500
In-Reply-To: <1453470088-43959-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, linux-scsi@vger.kernel.org

On 01/22/2016 02:41 PM, Johannes Thumshirn wrote:
> Allow the activation of the scsi-mq feature on a per-driver bassis as=
 opposed
> to the current stack global (de)activation.
>=20
> This allows us to have setups which can combine "slow" rotational med=
ia and
> fast media on two different HBA types.
>=20
> The following is from a host with rotational disks behind a HP SAS Ad=
apter and
> a fibre channel array behind a Emulex FC Adapter. The hpsa driver doe=
s not
> support scsi-mq yet (and has rotational disks attached to it), but th=
e lpfc
> does. This patch allows an optimal combination of the scsi-mq enabled=
 lpfc
> driver and the hpsa driver which still uses a single queue scsi layer=
 and thus
> can make use of IO schedulers.
>=20
> host:~ # cat /sys/block/sd?/queue/scheduler
> noop deadline [cfq]
> none
> none
> none
> none
> none
> none
> none
> none
> none
> none
> none
> none
> none
> none
> none
> none
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/fnic/fnic_main.c | 10 ++++++++++
>  drivers/scsi/hosts.c          |  2 +-
>  drivers/scsi/lpfc/lpfc_init.c |  8 ++++++++
>  drivers/scsi/virtio_scsi.c    | 11 +++++++++++
>  include/scsi/scsi_host.h      |  3 ---
>  5 files changed, 30 insertions(+), 4 deletions(-)
>=20
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
