From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH 5/5: scsi-scan-inq-timeout
Date: Wed, 21 Apr 2004 13:24:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421132454.A19685@beaverton.ibm.com>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141456.GW28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:54745 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262190AbUDUU0O
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 16:26:14 -0400
Content-Disposition: inline
In-Reply-To: <20040421141456.GW28633@tpkurt.garloff.de>; from garloff@suse.de on Wed, Apr 21, 2004 at 04:14:56PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Wed, Apr 21, 2004 at 04:14:56PM +0200, Kurt Garloff wrote:
> 
> Feature
> 
> Make the timeout for INQUIRY during SCSI scan adjustable via boot parameter.
> Note that the second INQUIRY does use a shorter timeout, as the long timeout
> is for recovery from the initial reset, not because existing devices would
> take so long to answer INQUIRY. SPC3 says that INQUIRY should be available
> right away, but real life is different unfortunately.
> 
> diff -uNrp linux-2.6.5.dontattachoffl/drivers/scsi/scsi_scan.c linux-2.6.5.inq_timeout/drivers/scsi/scsi_scan.c
> --- linux-2.6.5.dontattachoffl/drivers/scsi/scsi_scan.c	2004-04-21 14:28:13.000000000 +0200
> +++ linux-2.6.5.inq_timeout/drivers/scsi/scsi_scan.c	2004-04-21 14:32:04.000000000 +0200
> @@ -94,6 +94,13 @@ MODULE_PARM_DESC(max_report_luns,
>  		 "REPORT LUNS maximum number of LUNS received (should be"
>  		 " between 1 and 16384)");
>  
> +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
> +
> +module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(inq_timeout, 
> +		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
> +		 " Default is 5. Some non-compliant devices need more.");
> +
>  /**
>   * scsi_unlock_floptical - unlock device via a special MODE SENSE command
>   * @sreq:	used to send the command
> @@ -344,7 +351,7 @@ static void scsi_probe_lun(struct scsi_r
>  
>  	memset(inq_result, 0, 36);
>  	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result, 36,
> -		      SCSI_TIMEOUT + 4 * HZ, 3);
> +		      HZ/2 + HZ*scsi_inq_timeout, 3);

SCSI_TIMEOUT is 2 * HZ.

So we defaulted to 6 seconds, and now we default to 5.5 seconds. Why?

Why not get rid of the HZ/2, and set scsi_inq_timeout = SCSI_TIMEOUT/HZ +
4 so we default to 6 again?

So if a device needs at least N + .5 seconds then just set the
scsi_inq_timeout to N + 1.

>  
>  	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
>  			" code 0x%x\n", sreq->sr_result ?
> @@ -393,7 +400,7 @@ static void scsi_probe_lun(struct scsi_r
>  		memset(inq_result, 0, possible_inq_resp_len);
>  		scsi_wait_req(sreq, (void *) scsi_cmd,
>  			      (void *) inq_result,
> -			      possible_inq_resp_len, SCSI_TIMEOUT + 4 * HZ, 3);
> +			      possible_inq_resp_len, (1+scsi_inq_timeout)*(HZ/2), 3);

IMO just make the two timeouts the same and avoid any potential problems
(like some funky device always takes 4 seconds to reponsd to an INQUIRY).

-- Patrick Mansfield
