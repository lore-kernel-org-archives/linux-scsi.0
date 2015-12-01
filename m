From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 15/18] scsi: Add scsi_vpd_lun_id()
Date: Tue, 01 Dec 2015 11:35:20 +0100
Message-ID: <1448966120.3103.14.camel@suse.com>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
	 <1448961418-29013-16-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbbLAKfX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 05:35:23 -0500
In-Reply-To: <1448961418-29013-16-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-12-01 at 10:16 +0100, Hannes Reinecke wrote:
> Add a function scsi_vpd_lun_id() to return a unique device
> identifcation based on the designation descriptors of
> VPD page 0x83.
>=20
> As devices might implement several descriptors the order
> of preference is:
> - NAA IEE Registered Extended
> - EUI-64 based 16-byte
> - EUI-64 based 12-byte
> - NAA IEEE Registered
> - NAA IEEE Extended
> A SCSI name string descriptor is preferred to all of them
> if the identification is longer than 16 bytes.
>=20
> The returned unique device identification will be formatted
> as a SCSI Name string to avoid clashes between different
> designator types.
>=20
> Reviewed-by: Ewan Milne <emilne@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_lib.c=C2=A0=C2=A0=C2=A0=C2=A0| 140
> +++++++++++++++++++++++++++++++++++++++++++++
> =C2=A0include/scsi/scsi_device.h |=C2=A0=C2=A0=C2=A01 +
> =C2=A02 files changed, 141 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index dd8ad2a..5bd8a19 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3154,3 +3154,143 @@ void sdev_enable_disk_events(struct scsi_devi=
ce
> *sdev)
> =C2=A0	atomic_dec(&sdev->disk_events_disable_depth);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(sdev_enable_disk_events);

Nitpick:
kerneldoc comments start with /**

> +
> +/*
> + * scsi_vpd_lun_id - return a unique device identification
> + * @sdev: SCSI device
> + * @id:=C2=A0=C2=A0=C2=A0buffer for the identification
> + * @id_len:=C2=A0=C2=A0length of the buffer
> + *
> + * Copies a unique device identification into @id based
> + * on the information in the VPD page 0x83 of the device.
> + * The string will be formatted as a SCSI name string.
> + *
> + * Returns the length of the identification or error on failure.
> + * If the identifier is longer than the supplied buffer the actual
> + * identifier length is returned and the buffer is not zero-padded.
> + */
> +int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_le=
n)
> +{

Otherwise
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
