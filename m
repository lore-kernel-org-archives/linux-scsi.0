From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hptiop: avoid buffer overflow when returning sense data
Date: Sun, 14 Oct 2007 23:40:14 -0700
Message-ID: <20071014234014.45b5469b.akpm@linux-foundation.org>
References: <200605101704.27491.linux@highpoint-tech.com>
	<200605161438.09717.linux@highpoint-tech.com>
	<200708291510.53793.linux@highpoint-tech.com>
	<200710151442.52230.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbXJOGkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 02:40:21 -0400
In-Reply-To: <200710151442.52230.linux@highpoint-tech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com

On Mon, 15 Oct 2007 14:42:52 +0800 HighPoint Linux Team <linux@highpoint-tech.com> wrote:

> 
> avoid buffer overflow when returning sense data.
> 

That's really not enough information, sorry.

> index 8b384fa..d32a4a9 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -375,8 +375,9 @@ static void hptiop_host_request_callback
>  		scp->result = SAM_STAT_CHECK_CONDITION;
>  		memset(&scp->sense_buffer,
>  				0, sizeof(scp->sense_buffer));
> -		memcpy(&scp->sense_buffer,
> -			&req->sg_list, le32_to_cpu(req->dataxfer_length));
> +		memcpy(&scp->sense_buffer, &req->sg_list,
> +				min(sizeof(scp->sense_buffer),
> +					le32_to_cpu(req->dataxfer_length)));
>  		break;
>  
>  	default:

See, we know what the fix does, but we don't know what the consequences are
if the user's kernel doesn't have this fix.

So we are not able to work out whether this fix should be backported to
2.6.23.x and even to 2.6.22.x?
