From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 20 Jan 2004 18:06:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120180656.B18616@infradead.org>
References: <20040120132052.GA6740@lst.de> <400D5E9F.8030802@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:19464 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265583AbUATSHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 13:07:03 -0500
Content-Disposition: inline
In-Reply-To: <400D5E9F.8030802@us.ibm.com>; from brking@us.ibm.com on Tue, Jan 20, 2004 at 11:00:15AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 11:00:15AM -0600, Brian King wrote:
> If we get rid of scsi_add_timer, could we have a scsi_mod_timer? In the 
> ipr driver I submitted, I would like to be able to simply double the 
> timeout value, I don't necessarily want to change the timeout policy. 
> The adapter firmware is already timing each command, so I would like to 
> use that as the primary timing mechanism if possible.
> 
> For normal SCSI devices under this adapter I could change the philosophy 
> and not let the adapter time the commands, but for disk array devices, 
> the timeout value for reads/writes is too short.

messing with the timer after it's setup sounds like the wrong way to do
that to me.  Overriding the timeout in the host template or the device
sounds like the better idea.  Given that there seem to be other adapters
that need longer timeouts, I wonder whether we should look for a generic
solution to this

> 
> 
> -- 
> Brian King
> eServer Storage I/O
> IBM Linux Technology Center
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---

-- 
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
