From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 2 Dec 2003 02:15:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202101506.GB31682@praka.local.home>
References: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org> <20031202032253.GA175030@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:15278 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S261659AbTLBJRF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 04:17:05 -0500
Content-Disposition: inline
In-Reply-To: <20031202032253.GA175030@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Mon, 01 Dec 2003, Jeremy Higdon wrote:

> The enable_64bit_addressing flag is set in qla2x00_nvram_config().
> It is then later overridden in qla2x00_config_dma_addressing().
> 
> Since we would like to call qla2x00_config_dma_addressing() before
> consistent allocations in order to set the consistent mask, that
> would mean that the flag set in qla2x00_config_dma_addressing() would
> now be overridden in qla2x00_nvram_config().
> 
> What was your intention here?  It seems to me that you should not
> be touching this flag in qla2x00_nvram_config().  Is that correct?
> 

Yes, in the Linux world, the NVRAM value is irrelevent -- the driver
will determine the ideal value based on the sizeof(dma_addr_t).  I've
already removed the NVRAM reads of the host_p[] from
qla2x00_nvram_config().

> Is there any other problem caused by moving the call to
> qla2x00_config_dma_addressing() to an early position?
> 

I don't see any additional issues with the move.

Thanks again for your feedback.

Regards,
Andrew Vasquez
