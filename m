From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 02/22] libfc: additional debugging messages
Date: Wed, 3 Aug 2016 10:33:27 -0700
Message-ID: <e65a6f9e-e81f-5daf-a766-cc6abb7f6beb@sandisk.com>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0047.outbound.protection.outlook.com ([104.47.40.47]:7845
	"EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932860AbcHCRdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 13:33:43 -0400
In-Reply-To: <1470230002-37737-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On 08/03/2016 06:13 AM, Hannes Reinecke wrote:
> @@ -1121,8 +1124,10 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
>  		fc_rport_enter_rtv(rdata);
>
>  	} else {
> -		FC_RPORT_DBG(rdata, "Bad ELS response for PRLI command\n");
> -		fc_rport_error_retry(rdata, fp);
> +		rjt = fc_frame_payload_get(fp, sizeof (*rjt));
> +		FC_RPORT_DBG(rdata, "PRLI ELS rejected, reason %x expl %x\n",
> +			     rjt->er_reason, rjt->er_explan);
> +		fc_rport_error_retry(rdata, NULL);
>  	}

Shouldn't the type of the frame be checked in this code instead of 
assuming that it's a reject?

Bart.
