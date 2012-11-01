From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 05/11] libata-eh: allow defer in ata_exec_internal
Date: Thu, 1 Nov 2012 09:03:00 -0700
Message-ID: <20121101160300.GB9169@htj.dyndns.org>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
 <1351501298-3716-6-git-send-email-aaron.lu@intel.com>
 <20121029152051.GK5171@htj.dyndns.org>
 <508F42C0.8070807@intel.com>
 <20121030030144.GG4066@htj.dyndns.org>
 <508F44E1.3000801@intel.com>
 <20121031215213.GD2945@htj.dyndns.org>
 <5091DFDE.1060904@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992489Ab2KAQDF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2012 12:03:05 -0400
Content-Disposition: inline
In-Reply-To: <5091DFDE.1060904@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Hello, Aaron.

On Thu, Nov 01, 2012 at 10:35:10AM +0800, Aaron Lu wrote:
> > You can always add some fields. :)
> 
> OK. My concern is that, such information is only useful to ZPODD
> capable device+platforms, so checking this loading mechanism thing for
> all ATAPI devices during probe time doesn't seem a good idea.

Hmmm.. but it's not like querying acpi is high cost or anything.
Maybe I'm missing something but if it can be simpler that way, please
do so by all means.  I don't care whether you add some extra fields or
some processing overhead during probing.  It doesn't really matter.

> > Hmm... I see.  Which ACPI binding is it?  The ATA ACPI binding happens
> > during probing.  It's a different one, I presume?
> 
> Since commit 6b66d95895c149cbc04d4fac5a2f5477c543a8ae:
> libata: bind the Linux device tree to the ACPI device tree
> ACPI binding happens when SCSI devices are added to the device tree. The
> ata port/device software structure does not have a acpi_handle field
> anymore.

Please bear with me.  I haven't paid much attention to zpodd, so it
probably is my ignorance but at least the ATA <-> ACPI association
happens during probing by calling ata_acpi_on_devcfg() from
ata_dev_configure(), and it pretty much has to happen then because
_SDD/_GTF should be executed after hardreset which happens during
probing.  So, yeah, I'm confused.

Thanks.

-- 
tejun
