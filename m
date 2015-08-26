From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] fix: lpfc_send_rscn_event sends bigger buffer size
Date: Wed, 26 Aug 2015 14:53:13 +0200
Message-ID: <55DDB6B9.4030003@suse.de>
References: <1440070545-15037-1-git-send-email-alnovak@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440070545-15037-1-git-send-email-alnovak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Ales Novak <alnovak@suse.cz>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/20/2015 01:35 PM, Ales Novak wrote:
> lpfc_send_rscn_event() allocates data for sizeof(struct
> lpfc_rscn_event_header) + payload_len, but claims that the data has s=
ize
> of sizeof(struct lpfc_els_event_header) + payload_len. That leads to
> buffer overruns.
>=20
> Signed-off-by: Ales Novak <alnovak@suse.cz>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index 36bf58b..136928e 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -5444,7 +5444,7 @@ lpfc_send_rscn_event(struct lpfc_vport *vport,
> =20
>  	fc_host_post_vendor_event(shost,
>  		fc_get_event_number(),
> -		sizeof(struct lpfc_els_event_header) + payload_len,
> +		sizeof(struct lpfc_rscn_event_header) + payload_len,
>  		(char *)rscn_event_data,
>  		LPFC_NL_VENDOR_ID);
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
