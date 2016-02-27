From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Sat, 27 Feb 2016 19:59:56 +0800
Message-ID: <56D18FBC.8050501@suse.de>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
 <1456393335-38294-6-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423506AbcB0MAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Feb 2016 07:00:09 -0500
In-Reply-To: <1456393335-38294-6-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 02/25/2016 05:42 PM, John Garry wrote:
> In high-datarate aging tests, it is found that the
> SCSI framework can periodically issue lu resets as
> some commands timeout.
> Response TASK SET FULL and SAS_QUEUE_FULL may be
> returned many times for the same command, causing the
> timeouts.
> The SAS_QUEUE_FULL errors come from
> TRANS_TX_CREDIT_TIMEOUT_ERR, TRANS_TX_CLOSE_NORMAL_ERR,
> and TRANS_TX_ERR_FRAME_TXED errors. They do not mean
> that the queue is full in the host, but rather it is
> equivalent to meaning the queue is full for the sdev.
> To overcome this, the queue depth for the sdev is
> reduced to 64 (from 256, set in sas_slave_configure()).
> Normally error code SAS_QUEUE_FULL will result in the
> sdev queue depth falling, but it falls too slowly during
> high-datarate tests and commands timeout before it
> has fallen to an adequete level from original value.
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
