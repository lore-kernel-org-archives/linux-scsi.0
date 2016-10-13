From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2 07/16] scsi: libfc: don't set
 FC_RQST_STATE_DONE before calling fc_bsg_jobdone()
Date: Thu, 13 Oct 2016 13:38:06 +0200
Message-ID: <6eecb558-bd61-aa08-9582-d836ea2c343c@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <c0be09bd5581f7993618132ed4bced8e5cb62ce1.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <c0be09bd5581f7993618132ed4bced8e5cb62ce1.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "open list:FCOE SUBSYSTEM (libfc,
 libfcoe, fcoe)" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> Don't set FC_RQST_STATE_DONE before calling fc_bsg_jobdone() as
> fc_bsg_jobdone() calls blk_complete_requeust() which raises a soft-IRQ th=
at
> ends up in fc_bsg_sofirq_done() and fc_bsg_softirq_done() sets the
> FC_RQST_STATE_DONE flag.
> =

> Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/scsi/libfc/fc_lport.c | 2 --
>  1 file changed, 2 deletions(-)
> =

> diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
> index 156708a..53d13721 100644
> --- a/drivers/scsi/libfc/fc_lport.c
> +++ b/drivers/scsi/libfc/fc_lport.c
> @@ -1911,7 +1911,6 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, st=
ruct fc_frame *fp,
>  		bsg_reply->result =3D (PTR_ERR(fp) =3D=3D -FC_EX_CLOSED) ?
>  			-ECONNABORTED : -ETIMEDOUT;
>  		job->reply_len =3D sizeof(uint32_t);
> -		job->state_flags |=3D FC_RQST_STATE_DONE;
>  		fc_bsg_jobdone(job, bsg_reply->result,
>  			       bsg_reply->reply_payload_rcv_len);
>  		kfree(info);
> @@ -1947,7 +1946,6 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, st=
ruct fc_frame *fp,
>  			bsg_reply->reply_payload_rcv_len =3D
>  				job->reply_payload.payload_len;
>  		bsg_reply->result =3D 0;
> -		job->state_flags |=3D FC_RQST_STATE_DONE;
>  		fc_bsg_jobdone(job, bsg_reply->result,
>  			       bsg_reply->reply_payload_rcv_len);
>  		kfree(info);
> =

Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
