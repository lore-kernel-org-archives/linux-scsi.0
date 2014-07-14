From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY
 failure
Date: Mon, 14 Jul 2014 08:17:37 +0200
Message-ID: <53C37601.7080008@suse.de>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-7-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1405183712-23967-7-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> On some Windows hosts on FC SANs, TEST_UNIT_READY can return SRB_STAT=
US_ERROR.
> Correctly handle this. Note that there is sufficient sense informatio=
n to
> support scsi error handling even in this case.
>
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 9342ba4..29d0329 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1018,6 +1018,13 @@ static void storvsc_handle_error(struct vmscsi=
_request *vm_srb,
>   		case ATA_12:
>   			set_host_byte(scmnd, DID_PASSTHROUGH);
>   			break;
> +		/*
> +		 * On Some Windows hosts TEST_UNIT_READY command can return
> +		 * SRB_STATUS_ERROR, let the upper level code deal with it
> +		 * based on the sense information.
> +		 */
> +		case TEST_UNIT_READY:
> +			break;
>   		default:
>   			set_host_byte(scmnd, DID_TARGET_FAILURE);
>   		}
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
