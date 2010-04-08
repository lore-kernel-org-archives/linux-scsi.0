From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: PATCH] BNX2I : Bug fixes related to MTU change issue when there
 are active iscsi sessions
Date: Thu, 08 Apr 2010 17:31:06 -0500
Message-ID: <4BBE592A.2070202@cs.wisc.edu>
References: <1270761372.28522.109699.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34519 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0DHWbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2010 18:31:20 -0400
In-Reply-To: <1270761372.28522.109699.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>, James.Bottomley@suse.de, linux scsi <linux-scsi@vger.kernel.org>

On 04/08/2010 04:16 PM, Anil Veerabhadrappa wrote:
> +	/* Wait for all endpoints to be torn down, Chip will be reset once
> +	 *  control returns to network driver. So it is required to cleanup and
> +	 * release all connection resources before returning from this routine.
> +	 */
> +	wait_event_interruptible_timeout(hba->eh_wait,
> +					 (hba->ofld_conns_active == 0),
> +					 hba->hba_shutdown_tmo);


Hey, I just noticed this (sorry I should have seen this earlier), but 
there is no wake_up(hba->eh_wait). Do you want one in bnx2i_free_ep when 
ofld_conns_active goes to 0?
