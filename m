From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] replace dm hw handlers with scsi handlers
Date: Thu, 12 Oct 2006 15:21:15 -0500
Message-ID: <452EA3BB.8020305@cs.wisc.edu>
References: <1160684310.4163.4.camel@madmax>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1160684310.4163.4.camel@madmax>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> +
> +static int clariion_check_sense(struct scsi_sense_hdr *sense_hdr)
> +{
> +	switch (sense_hdr->sense_key) {
> +	case NOT_READY:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x03)
> +			/*
> +			 * LUN Not Ready - Manual Intervention Required
> +			 * indicates this is a passive path.
> +			 *
> +			 * FIXME: However, if this is seen and EVPD C0
> +			 * indicates that this is due to a NDU in
> +			 * progress, we should set FAIL_PATH too.
> +			 * This indicates we might have to do a SCSI
> +			 * inquiry in the end_io path. Ugh.
> +			 */
> +			return FAILED;
> +		break;
> +	case ILLEGAL_REQUEST:
> +		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
> +			/*
> +			 * An array based copy is in progress. Do not
> +			 * fail the path, do not bypass to another PG,
> +			 * do not retry. Fail the IO immediately.
> +			 * (Actually this is the same conclusion as in
> +			 * the default handler, but lets make sure.)
> +			 */
> +			return FAILED;
> +		break;
> +	case UNIT_ATTENTION:
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
> +			/*
> +			 * Unit Attention Code. This is the first IO
> +			 * to the new path, so just retry.
> +			 */
> +			return NEEDS_RETRY;
> +		break;
> +	}
> +
> +	/* success just means we do not care what scsi-ml does */
> +	return SUCCESS;
> +}
> +

Oh yeah, Ed could you tell me where sometimes a commend gets retried
over and over when a path is passive and can you tell me on what error
values it does this so I can add this in? Does the check_sense code
force the retry, or scsi_io_completion or the ULD?
