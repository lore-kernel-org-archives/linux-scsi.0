From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] ipr: Reduce queuecommand lock time
Date: Mon, 16 Jul 2012 20:03:08 -0600
Message-ID: <20120717020308.GA18581@parisc-linux.org>
References: <201207162048.q6GKm8m3018046@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40770 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2GQCDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2012 22:03:10 -0400
Content-Disposition: inline
In-Reply-To: <201207162048.q6GKm8m3018046@d03av01.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On Mon, Jul 16, 2012 at 03:48:08PM -0500, Brian King wrote:
> +static int ipr_queuecommand(struct Scsi_Host *shost,
> +			    struct scsi_cmnd *scsi_cmd)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg;
>  	struct ipr_resource_entry *res;
>  	struct ipr_ioarcb *ioarcb;
>  	struct ipr_cmnd *ipr_cmd;
> +	unsigned long lock_flags = 0;

You don't need to initialise lock_flags.

Looking at the rest of the code, you drop the lock in the middle,
then re-acquire it.  That'll help with hold time, but I'm not convinced
it'll help with performance.  Have you done performance testing with
these changes?  I seem to remember we used an eight-socket box to show
host_lock problems in the past.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
