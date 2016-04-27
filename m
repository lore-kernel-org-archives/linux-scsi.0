From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/12] scsi_debug: rework resp_report_luns
Date: Wed, 27 Apr 2016 16:09:58 -0700
Message-ID: <572146C6.4090707@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-9-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0095.outbound.protection.outlook.com ([207.46.100.95]:27456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751019AbcD0XKJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 19:10:09 -0400
In-Reply-To: <1461600999-28893-9-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
> +	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
> +	arr = kzalloc((tlun_cnt * sizeof(lun_p->scsi_lun)) + 8, GFP_ATOMIC);

kzalloc() allocates contiguous memory. There is no guarantee that a 
large contiguous region will be available. Since kernel memory tends to 
fragment after some time, have you considered to use vmalloc() instead?

> +	/*
> +	 * Address method (we use Peripherial = 00b)
> +	 * 10b - Logical unit
> +	 * 00b - Peripherial device - Use this one
> +	 * 01b - Logical device
> +	 * 11b - reserved
> +	 */

In SAM I found the following spelling "Peripheral" instead of 
"Peripherial" (two occurrences). Although everyone will understand the 
intention of the above comment, using the same spelling as in SAM helps 
people who search through the source code using grep.

Bart.
