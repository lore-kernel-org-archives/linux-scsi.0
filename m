From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH]scsi_dh_rdac: Retry for NOT_READY check
	condition
	(0x02A102, 0x020401, 0x020404 and  0x020407) in rdac_check_sense
Date: Tue, 10 Mar 2009 10:46:31 -0500
Message-ID: <1236699991.14822.0.camel@localhost.localdomain>
References: <0D1E8821739E724A86F4D16902CE275C140E25CA0C@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C140E25CA0C@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-03-10 at 18:30 +0530, Chauhan, Vijay wrote:
> This patch adds retry for NOT_READY check conditions(02/A1/02, 02/04/01, 02/04/04,
> 02/04/07) in rdac_check_sense.
> 
> Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>
> 
> ---
> --- linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-03-10 17:42:27.000000000 +0530
> +++ linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-03-10 18:05:35.000000000 +0530
> @@ -562,6 +562,30 @@ static int rdac_check_sense(struct scsi_
>  			 * Just retry and wait.
>  			 */
>  			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
> +			/* LUN Not Ready - Quiescense in progress
> +			 * or has been achieved
> +			 * Just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;

This is fine, being vendor specific, we don't handle it at the mid-layer

> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
> +			/* LUN Not Ready - Logical Unit Not Ready and is in
> +			 * the process of becoming ready
> +			 * Just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x04)
> +			/* LUN Not Ready - Format In Progress
> +			 *
> +			 * Just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x04  && sense_hdr->ascq == 0x07)
> +			/* LUN Not Ready - Storage controller cannot respond
> +			 * immediately to a PRIN or PROUT command.
> +			 * Just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;

For all of these ... along with a few other not ready types, we already
do a delayed retry at the mid-layer (in scsi_io_completion).  Is there
some problem that causes this to need to be handled here as well?

James
