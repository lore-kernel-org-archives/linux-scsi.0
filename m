From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] scsi: libosd: Remove VLA usage
Date: Sun, 13 May 2018 12:04:45 +0300
Message-ID: <6713469a-3f36-6768-c6d7-04edbf8714e8@electrozaur.com>
References: <20180502225545.GA45533@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502225545.GA45533@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/05/18 01:55, Kees Cook wrote:
> On the quest to remove all VLAs from the kernel[1] this rearranges the
> code to avoid a VLA warning under -Wvla (gcc doesn't recognize "const"
> variables as not triggering VLA creation). Additionally cleans up variable
> naming to avoid 80 character column limit.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 

ACK-BY: Boaz Harrosh <ooo@electrozaur.com>

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/scsi/osd/osd_initiator.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index e18877177f1b..917a86a2ae8c 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1842,14 +1842,14 @@ int osd_req_decode_sense_full(struct osd_request *or,
>  		case osd_sense_response_integrity_check:
>  		{
>  			struct osd_sense_response_integrity_check_descriptor
> -				*osricd = cur_descriptor;
> -			const unsigned len =
> -					  sizeof(osricd->integrity_check_value);
> -			char key_dump[len*4 + 2]; /* 2nibbles+space+ASCII */
> -
> -			hex_dump_to_buffer(osricd->integrity_check_value, len,
> -				       32, 1, key_dump, sizeof(key_dump), true);
> -			OSD_SENSE_PRINT2("response_integrity [%s]\n", key_dump);
> +				*d = cur_descriptor;
> +			/* 2nibbles+space+ASCII */
> +			char dump[sizeof(d->integrity_check_value) * 4 + 2];
> +
> +			hex_dump_to_buffer(d->integrity_check_value,
> +					sizeof(d->integrity_check_value),
> +					32, 1, dump, sizeof(dump), true);
> +			OSD_SENSE_PRINT2("response_integrity [%s]\n", dump);
>  		}
>  		case osd_sense_attribute_identification:
>  		{
> 
