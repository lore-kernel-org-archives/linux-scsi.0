From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH 1/2] libosd: bug in osd_req_decode_sense_full()
Date: Tue, 10 Nov 2009 17:09:01 +0200
Message-ID: <4AF9820D.3080401@panasas.com>
References: <4AF6B946.8000106@panasas.com> <4AF6B9B1.5040002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:16953 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031AbZKJPI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 10:08:58 -0500
In-Reply-To: <4AF6B9B1.5040002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 11/08/2009 02:29 PM, Boaz Harrosh wrote:
> 
> The (never tested) osd_sense_attribute_identification case
> has never worked. The loop was never advanced on.
> Fix it to work as intended.
> 
> On 10/30/2009 04:39 PM, Roel Kluin wrote:
>   I found this by code analysis, searching for while
>   loops that test a local variable, but do not modify
>   the variable.
> 
> Reported-by: Roel Kluin <roel.kluin@gmail.com>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/osd/osd_initiator.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 60b7ca1..d504e82 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1584,14 +1584,13 @@ int osd_req_decode_sense_full(struct osd_request *or,
>  			struct osd_sense_attributes_data_descriptor
>  				*osadd = cur_descriptor;
>  			int len = min(cur_len, sense_len);

len should be unsigned for the compare with sizeof() below.

I'll repost a second version as reply.

Boaz
> -			int i = 0;
>  			struct osd_sense_attr *pattr = osadd->sense_attrs;
>  
> -			while (len < 0) {
> +			while (len >= sizeof(*pattr)) {
>  				u32 attr_page = be32_to_cpu(pattr->attr_page);
>  				u32 attr_id = be32_to_cpu(pattr->attr_id);
>  
> -				if (i++ == 0) {
> +				if (!osi->attr.attr_page) {
>  					osi->attr.attr_page = attr_page;
>  					osi->attr.attr_id = attr_id;
>  				}
> @@ -1602,6 +1601,8 @@ int osd_req_decode_sense_full(struct osd_request *or,
>  					bad_attr_list++;
>  					max_attr--;
>  				}
> +
> +				len -= sizeof(*pattr);
>  				OSD_SENSE_PRINT2(
>  					"osd_sense_attribute_identification"
>  					"attr_page=0x%x attr_id=0x%x\n",

