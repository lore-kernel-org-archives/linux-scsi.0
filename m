From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_transport_sas: remove local_attached flag
Date: Mon, 28 Aug 2006 10:30:12 +0100
Message-ID: <20060828093012.GB8980@infradead.org>
References: <1156531698.3462.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43399 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932429AbWH1Jae (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 05:30:34 -0400
Content-Disposition: inline
In-Reply-To: <1156531698.3462.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsil.com>

On Fri, Aug 25, 2006 at 01:48:18PM -0500, James Bottomley wrote:
> This flag denotes local attachment of the phy.  There are two problems
> with it:
> 
> 1) It's actually redundant ... you can get the same information simply
> by seeing whether a host is the phys parent
> 2) we condition a lot of phy parameters on it on the false assumption
> that we can only control local phys.  I'm wiring up phy resets in the
> aic94xx now, and it will be able to reset non-local phys as well.
> 
> I fixed 2) by moving the local check into the reset and stats function
> of the mptsas, since that seems to be the only HBA that can't
> (currently) control non-local phys.

You can of course do the reset and stats using the normal smp code from
libsas for fusion aswell.  I just added the flag as a quick hack because
I was waiting for the libsas merge to implement this instead of adding
a mptsas-specific implementation.

