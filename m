From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH2/5] mpt fusion: Added msi enable disable for FC,SPI,SAS [Resendig updated patch]
Date: Thu, 8 Jan 2009 07:53:04 -0700
Message-ID: <20090108145303.GA6936@parisc-linux.org>
References: <20090108085716.GA4116@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47398 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZAHOxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 09:53:07 -0500
Content-Disposition: inline
In-Reply-To: <20090108085716.GA4116@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathya.prakash@lsi.com, James.Bottomley@HansenPartnership.com

On Thu, Jan 08, 2009 at 02:27:16PM +0530, Kashyap, Desai wrote:
> Added support for MSI enable/disable for different buses FC,SPI,SAS instead
> of having single MSI enable/disable feature.

Why do you think you need this?

Either the system supports MSI or it doesn't.  The original reason for
only enabling MSI on SPI cards was that it reduced the number of bug
reports since FC and SAS cards are likely to be used on machines with
functional MSI.

This is of course a horrible hack.  The right thing to do is to detect
that you've never received an interrupt, disable MSI, enable regular
interrupts and try again.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
