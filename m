From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Help On Adaptec SAS Controller AD-483000
Date: Wed, 02 Apr 2008 18:45:07 -0500
Message-ID: <1207179907.3082.61.camel@localhost.localdomain>
References: <90500F9127D5CC40BE9D712D8ACCB4860864F5@fre1exch00.hq.exar.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45881 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756300AbYDBXpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 19:45:14 -0400
In-Reply-To: <90500F9127D5CC40BE9D712D8ACCB4860864F5@fre1exch00.hq.exar.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sanjay Gandotra <sanjay.gandotra@exar.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-04-02 at 16:32 -0700, Sanjay Gandotra wrote:
> Hi,
>  
> Ok, the issue I have is the following:
>  
> I have connected a SATA Port Multiplier to AD-483000. And I have two sata drives connected to the Sata port multiplier (one at port 0 and second at port 1)
> My Linux Kernel is 2.6.24.3. I am using the drivers in the kernel.. aic94xx and libsas
>  
> The drive at port 0 of the sata port multiplier is detected nicely. The problem is that the second drive on the port multiplier is not detected. 
> After investigations.. I figured out that no one is trying to do sata port multiplier initialisation and detection. After reading the sata spec etc., I tried to modify libsas so that before detecting any sata device, it would send out FIS (soft reset ) to sata port 15 with SRST bit set to 1 followed by another FIS to sata port 15 with SRST bit set to 0.
>  
> The first FIS goes out. I can see it on a SATA analyzer. The second  FIS never goes out... 
> Adaptec's driver.. is giving errors for the first FIS.

I'm afraid the basic source of the problem is that port multiplier
support in libsas is stubbed out.  No-one developing the driver actually
has a port multiplier (and we assumed that everyone would use expanders
anyway).

The place to begin is in libsas/sas_ata.c:sas_discover_stat_pm() which
basically returns -ENODEV at the moment.

James


