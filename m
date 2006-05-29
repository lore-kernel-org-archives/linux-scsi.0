From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 29 May 2006 10:38:13 +0200
Message-ID: <447AB2F5.2000700@s5r6.in-berlin.de>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38313 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1750772AbWE2IkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 May 2006 04:40:24 -0400
In-Reply-To: <20060529031915.GB23405@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Add the scsi_mod.scan kernel parameter to determine how scsi busses
> are scanned.  "sync" is the current behaviour.  "none" punts scanning
> scsi busses to userspace.  "async" is the new default.

This parameter is only relevant with LLDDs which use scsi_scan_host, right?

Furthermore, "sync|async" basically means "serialized|parallelized
across host adapters". Does it also mean "finishing before|after driver
initialization"? (With LLDDs which use scsi_scan_host.)

...
> --- ./include/scsi/scsi_host.h	27 May 2006 15:58:17 -0000	1.27.2.1
> +++ ./include/scsi/scsi_host.h	19 May 2006 02:43:19 -0000	1.27
> @@ -541,6 +541,9 @@ struct Scsi_Host {
>  	 */
>  	unsigned ordered_tag:1;
>  
> +	/* Are we currently performing an async scan? */

Perhaps add "private to scsi core" to the comment.

> +	unsigned async_scan:1;

This flag is written under protection of async_scan_lock but read
without lock protection and without being an atomic variable. Is this
safe? I suppose it is as long as scan methods (by do_scan_async kthread,
by another thread associated to the LLDD or transport, by userspace) are
not mixed.
-- 
Stefan Richter
-=====-=-==- -=-= ===--
http://arcgraph.de/sr/
