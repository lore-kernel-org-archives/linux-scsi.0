From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH 2/5: scsi-scan-blist_replun
Date: Wed, 21 Apr 2004 16:14:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421161412.B6793@infradead.org>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141234.GT28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:60167 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263040AbUDUPOO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:14:14 -0400
Content-Disposition: inline
In-Reply-To: <20040421141234.GT28633@tpkurt.garloff.de>; from garloff@suse.de on Wed, Apr 21, 2004 at 04:12:34PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Wed, Apr 21, 2004 at 04:12:34PM +0200, Kurt Garloff wrote:
> 
> Cleanup/Feature
> 
> Remove CONFIG_SCSI_REPORT_LUNS config option.
> Instead provide BLIST_NOREPORTLUN that can be passed as default_dev_flags
> (but also per device if needed).
> Provide BLIST_REPORTLUN2

Can we make this simply BLIST_REPORTLUN?  I always have to think why the
2 is there until I guess this could mean only for scsi <= 2..

> -#ifdef CONFIG_SCSI_REPORT_LUNS
>  /*
>   * max_scsi_report_luns: the maximum number of LUNS that will be
>   * returned from the REPORT LUNS command. 8 times this value must
> @@ -88,13 +87,12 @@ MODULE_PARM_DESC(max_luns,
>   * in practice, the maximum number of LUNs suppored by any device
>   * is about 16k.
>   */
> -static unsigned int max_scsi_report_luns = 128;
> +static unsigned int max_scsi_report_luns = 511;

Hmm, where does this number come from?

>  	/*
> -	 * Only support SCSI-3 and up devices.
> -	 */
> -	if (sdev->scsi_level < SCSI_3)
> +	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
> +	 * Also allow SCSI-2 if BLIST_REPORTLUN2 is set and host adapter does
> +	 * support more than 8 LUNs.

This comment and the nested if is a little confusing.  Also why shouldn't
the arbitrary SCSI2 limit for BLIST_REPORTLUN2?  I'm sure we won't find
SCSI1 devices supporting it, but there should not be any harm leaving out
that check - and doing so makes the logic much cleaner.

	/*
	 * REPORT_LUN is used by default only for SCSI 3 devices (unless
	 * BLIST_NOREPORTLUN is set).  For other devices BLIST_REPORTLUN
	 * enables it if the HBA does support more than 8 LUNs.

	 if (bflags & BLIST_NOREPORTLUN)
	 	return 1;
	 if (sdev->scsi_level < 3 && sdev->host->max_lun <= 8 &&
	     !(bflags & BLIST_REPORTLUN2))
	     	return 1;

Note that I'd prefer not to add BLIST_NOREPORTLUN if the discussing
about the LUN mapping comes to a useable consensus.

