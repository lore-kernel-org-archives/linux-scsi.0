From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] libsas: move ATA bits into a separate module
Date: Mon, 18 Sep 2006 20:00:33 +0100
Message-ID: <20060918190033.GD17670@infradead.org>
References: <4508A0A2.2080605@us.ibm.com> <450971D3.2040405@garzik.org> <4509DA77.7000508@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13261 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751799AbWIRTA4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 15:00:56 -0400
Content-Disposition: inline
In-Reply-To: <4509DA77.7000508@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

On Thu, Sep 14, 2006 at 03:40:55PM -0700, Darrick J. Wong wrote:
> Jeff Garzik wrote:
> 
> > I disagree completely with this approach.
> > 
> > You don't need a table of hooks for the case where libata is disabled in
> > .config.  Thus, it's only useful for the case where libsas is loaded as
> > a module, but libata is not.
> 
> Indeed, I misunderstood what James Bottomley wanted, so I reworked the
> patch.  It has the same functionality as before, but this module uses
> the module loader/symbol resolver for all the functions in libata, and
> allows libsas to (optionally) call into sas_ata with weak references by
> pushing a table of the necessary function pointers into libsas at
> sas_ata load time.  Thus, libsas doesn't need to load libata/sas_ata
> unless it actually finds a SATA device.

NACK again.  Week references are bad.  Please change it back to normal
hard references so that it works like everything else in the kernel.

