From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: timeout reset timer before command is queued
Date: Tue, 15 Dec 2009 03:40:33 -0700
Message-ID: <20091215104032.GM7812@parisc-linux.org>
References: <4B21B143.0@mvista.com> <4B24B962.4070804@panasas.com> <4B26E38C.1000605@mvista.com> <20091215022126.GK7812@parisc-linux.org> <4B26F70D.6090409@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52180 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbZLOKke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 05:40:34 -0500
Content-Disposition: inline
In-Reply-To: <4B26F70D.6090409@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Min Zhang <mzhang@mvista.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Mon, Dec 14, 2009 at 06:40:13PM -0800, Min Zhang wrote:
> +    /*
> +     * Extend timeout if cmd has not been queued yet, otherwise error
> +     * handler could complete request and free the cmd memory while
> +     * the dispatch handler still uses the cmd pointer.
> +     */
> +    if (scmd->eh_eflags | SCSI_EH_RESET_TIMER)
> +        return BLK_EH_RESET_TIMER;

Oh, and what on earth is this?  The condition will always be true.  I
think you meant '&', not '|'.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
