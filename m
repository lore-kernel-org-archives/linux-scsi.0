From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Tue, 8 Jul 2008 10:51:33 -0600
Message-ID: <200807081051.33892.bjorn.helgaas@hp.com>
References: <bug-11045-10286@http.bugzilla.kernel.org/> <20080708015756.baec287c.akpm@linux-foundation.org> <1215526126.3214.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17326 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYGHQvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 12:51:55 -0400
In-Reply-To: <1215526126.3214.8.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Support, Software" <support@lsi.com>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsi.com>, kurk@shiftmail.org

On Tuesday 08 July 2008 08:08:46 am James Bottomley wrote:
> That said, this line:
> 
> mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
> 
> is absolutely characteristic of a lost interrupt.
> 
> With the current LSI driver, we have two possible causes for this.  One
> is the usual ACPI screw up that we never seem to be able to fix.

Which ACPI screw up is that?  And what's the usual recipe?

I know about the ancient "pci=routeirq" recipe, but as far as I know,
there are no current problems that require that.

> The 
> other is that the driver recently enabled MSI (commit
> 23a274c8a5adafc74a66f16988776fc7dd6f6e51 in v2.6.26-rc1).  For the
> former, just follow the usual ACPI screw up recipe.  For the latter, you
> should see this message in the boot up:
> 
> mptbase: ioc0: PCI-MSI enabled
> 
> MSI can be turned off again by using the module parameter
> mpt_msi_enable=0.
> 
> Unfortunately, the true fix is to find out if the motherboard really has
> a global MSI problem (and I know MSI works with the LSI because I have a
> 1030 in an ia64 system here working just fine) and add it to the PCI
> quirks file as unable to use MSI.
> 
> James
