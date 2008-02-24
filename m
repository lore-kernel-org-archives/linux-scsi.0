From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/5] aic94xx: plumb in I_T_nexus_reset task management
 function
Date: Sun, 24 Feb 2008 00:51:55 -0500
Message-ID: <47C105FB.8090401@garzik.org>
References: <1203831446.3139.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43687 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYBXFv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 00:51:57 -0500
In-Reply-To: <1203831446.3139.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>

James Bottomley wrote:
> Currently aic94xx has no exported I_T_nexus_reset function.  This is a
> bit of a huge problem, since sas_ata relies on this function to
> perform an ATA phy reset and also it means that if abort fails, we
> really have no bigger hammer to hit everything with.
> 
> Plumb in the I_T_nexus_reset by quiescing the sequencer, sending the
> correct phy reset (link for ATA and hard for SAS) and then carefully
> resuming the sequencer again.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/aic94xx/aic94xx.h      |    1 +
>  drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
>  drivers/scsi/aic94xx/aic94xx_tmf.c  |   58 ++++++++++++++++++++++++++++++++--
>  3 files changed, 56 insertions(+), 5 deletions(-)

Tangent:

Now that patches for ipr and sata_sx4 exist, libsas is the last holdout 
using libata's old error handling paths.

I think Darrick was either scoping that work, or had preliminary patches?

Anyway, that's holding back removal of a lot of libata code, so I wanted 
to make sure the issue remained in people's minds...

	Jeff



