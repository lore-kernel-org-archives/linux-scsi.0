From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: export function scsi_scan.c:sanitize_inquiry_string
Date: Wed, 20 Jan 2016 16:52:23 -0600
Message-ID: <40535052-634B-43AC-A917-DFA0D02FAF0A@linux.vnet.ibm.com>
References: <20160120194028.23159.25263.stgit@brunhilda> <20160120194141.23159.5168.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:50048 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbcATWwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 17:52:30 -0500
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 20 Jan 2016 15:52:30 -0700
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id F05C93E4003E
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 15:52:26 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0KMqQVX29425760
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 15:52:26 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0KMqOnI012863
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 15:52:26 -0700
In-Reply-To: <20160120194141.23159.5168.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Jan 20, 2016, at 1:41 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> The hpsa driver uses this function to cleanup inquiry
> data. Our new pqi driver will also use this
> function. This function was copied into both drivers.
> 
> This patch exports sanitize_inquiry_string so the hpsa
> and the pqi drivers can use this function directly.
> 
> Hannes recommended the change in review:
> https://www.marc.info/?l=linux-scsi&m=144619249003064&w=2
> that using the existing function in scsi_scan would be
> preferrable.

I also made this suggestion when reviewing the same patch:
https://www.marc.info/?l=linux-scsi&m=144613827316617&w=2

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/scsi_scan.c |   12 +++++++-----
> 1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6a82066..1f02e84 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -518,7 +518,8 @@ void scsi_target_reap(struct scsi_target *starget)
> }
> 
> /**
> - * sanitize_inquiry_string - remove non-graphical chars from an INQUIRY result string
> + * scsi_sanitize_inquiry_string - remove non-graphical chars from an
> + *                                INQUIRY result string
>  * @s: INQUIRY result string to sanitize
>  * @len: length of the string
>  *
> @@ -531,7 +532,7 @@ void scsi_target_reap(struct scsi_target *starget)
>  *	string terminator, so all the following characters are set to
>  *	spaces.
>  **/
> -static void sanitize_inquiry_string(unsigned char *s, int len)
> +void scsi_sanitize_inquiry_string(unsigned char *s, int len)
> {
> 	int terminated = 0;
> 
> @@ -542,6 +543,7 @@ static void sanitize_inquiry_string(unsigned char *s, int len)
> 			*s = ' ';
> 	}
> }
> +EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
> 
> /**
>  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
> @@ -627,9 +629,9 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
> 	}
> 
> 	if (result == 0) {
> -		sanitize_inquiry_string(&inq_result[8], 8);
> -		sanitize_inquiry_string(&inq_result[16], 16);
> -		sanitize_inquiry_string(&inq_result[32], 4);
> +		scsi_sanitize_inquiry_string(&inq_result[8], 8);
> +		scsi_sanitize_inquiry_string(&inq_result[16], 16);
> +		scsi_sanitize_inquiry_string(&inq_result[32], 4);
> 
> 		response_len = inq_result[4] + 5;
> 		if (response_len > 255)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

