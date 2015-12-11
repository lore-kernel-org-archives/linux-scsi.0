From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] scsi: storvsc: Fix a bug in the layout of the
 hv_fc_wwn_packet
Date: Fri, 11 Dec 2015 09:47:48 +0100
Message-ID: <20151211084748.GC9903@c203.arch.suse.de>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449792860-15447-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 10, 2015 at 04:14:17PM -0800, K. Y. Srinivasan wrote:
> The hv_fc_wwn_packet is exchanged over vmbus. Make the definition in =
Linux match
> the Window's definition.
>=20
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index c41f674..00bb4bd 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -92,9 +92,8 @@ enum vstor_packet_operation {
>   */
> =20
>  struct hv_fc_wwn_packet {
> -	bool	primary_active;
> -	u8	reserved1;
> -	u8	reserved2;
> +	u8	primary_active;
> +	u8	reserved1[3];
>  	u8	primary_port_wwn[8];
>  	u8	primary_node_wwn[8];
>  	u8	secondary_port_wwn[8];
> --=20
> 1.7.4.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Should this go through stable as well?
If yes:
=46ixes: 8b612fa23 '[SCSI] storvsc: Update the storage protocol to win8=
 level'
Cc: stable@vger.kernel.org # v3.11+
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
