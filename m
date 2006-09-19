From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptspi : Bug fix to prevent infinite nested domainvalidation
Date: Tue, 19 Sep 2006 12:54:16 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032CD70@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43994 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751006AbWISSy0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 14:54:26 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, markh@osdl.org
Cc: linux-scsi@vger.kernel.org

On Monday, September 18, 2006 8:56 PM, James Bottomley wrote: 
go.
> 
> Erm, but surely, since reset->dv is fairly standard, this must need a
> generic fix.
> 
> Can you check this out.  I think it does the right thing gating
> spi_dv_device() with a new flag.  The pending flag is more used to
> manage scheduled domain validations.   The original idea was 
> that resets
> would trigger scheduled dv that would use this flag correctly (and not
> be in the direct path of DV).  For some reason the mptspi seems to
> manage to entangle DV with the reset inline.
> 

Will the dv thread that issed the host reset, wait for the lld host
reset to complete
itself before going forward? If not, dv will repeat itself.

This issue was reported by the folks at OSDL.  I've asked Mark Haverkamp
to try this patch, and waiting for results.

I provided a different patch to Mark last Friday, that does basically 
the same as your patch does, except from the lld.  That patch failed.
He has a full rack of disks, and the failing disk was at ID8.  By the
time
dv completed on ID=0-7, the dv_pending flag was cleared on I8, and
started
DV again, that again would issue host_reset.

Eric
