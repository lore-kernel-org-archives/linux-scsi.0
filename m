From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Sun3 SCSI: Make sun3 scsi drivers compile/work again
Date: Tue, 2 Jan 2007 11:31:44 +0000
Message-ID: <20070102113143.GB24951@infradead.org>
References: <Pine.LNX.4.64.0612091036450.12009@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbXABLbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 06:31:46 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612091036450.12009@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Sam Creasey <sammy@sammy.net>

On Sat, Dec 09, 2006 at 10:37:05AM +0100, Geert Uytterhoeven wrote:
> +#include "initio.h"

This is definitly wrong.  This is a header file for a specific driver.
I suspect you want the old-EH definitions for SCSI_RESET_*/SCSI_ABORT_*?

You're returning them from the EH routines which are plugged into the
new EH method slots, so this is not only wrong by including an other
drivers private headers but also functionally deadly.

