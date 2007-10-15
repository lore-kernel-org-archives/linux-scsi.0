From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] pluto/fc - Remove uses of the scsi_cmnd->done
Date: Mon, 15 Oct 2007 11:56:49 -0600
Message-ID: <20071015175648.GA25488@parisc-linux.org>
References: <4713A175.9020408@panasas.com> <4713A27A.9050009@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48262 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXJOR4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 13:56:50 -0400
Content-Disposition: inline
In-Reply-To: <4713A27A.9050009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

On Mon, Oct 15, 2007 at 07:25:14PM +0200, Boaz Harrosh wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> 
> Remove uses of the scsi_cmnd ->done method from the fc4 driver.  It was
> being abused to flag commands that had already been through queuecommand;
> use the fcmd->proto value for that instead.  The fcmd->done pointer now
> becomes irrelevant.  Reuse the fcp_scsi_done name for an entirely different
> function which provides a handy single place to call ->scsi_done (removing
> some broken places that used to leak scsi_cmnds on error by calling ->done).

Looks right to me.  Thanks for picking this up.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
