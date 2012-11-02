From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v8 05/11] libata-eh: allow defer in ata_exec_internal
Date: Fri, 02 Nov 2012 08:43:00 +0800
Message-ID: <50931714.6090505@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com> <1351501298-3716-6-git-send-email-aaron.lu@intel.com> <20121029152051.GK5171@htj.dyndns.org> <508F42C0.8070807@intel.com> <20121030030144.GG4066@htj.dyndns.org> <508F44E1.3000801@intel.com> <20121031215213.GD2945@htj.dyndns.org> <5091DFDE.1060904@intel.com> <20121101160300.GB9169@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab2KBAnH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Nov 2012 20:43:07 -0400
In-Reply-To: <20121101160300.GB9169@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 11/02/2012 12:03 AM, Tejun Heo wrote:
> Hello, Aaron.
> 
> On Thu, Nov 01, 2012 at 10:35:10AM +0800, Aaron Lu wrote:
>>> You can always add some fields. :)
>>
>> OK. My concern is that, such information is only useful to ZPODD
>> capable device+platforms, so checking this loading mechanism thing for
>> all ATAPI devices during probe time doesn't seem a good idea.
> 
> Hmmm.. but it's not like querying acpi is high cost or anything.
> Maybe I'm missing something but if it can be simpler that way, please
> do so by all means.  I don't care whether you add some extra fields or
> some processing overhead during probing.  It doesn't really matter.

OK, thanks for the suggestion.

> 
>>> Hmm... I see.  Which ACPI binding is it?  The ATA ACPI binding happens
>>> during probing.  It's a different one, I presume?
>>
>> Since commit 6b66d95895c149cbc04d4fac5a2f5477c543a8ae:
>> libata: bind the Linux device tree to the ACPI device tree
>> ACPI binding happens when SCSI devices are added to the device tree. The
>> ata port/device software structure does not have a acpi_handle field
>> anymore.
> 
> Please bear with me.  I haven't paid much attention to zpodd, so it
> probably is my ignorance but at least the ATA <-> ACPI association
> happens during probing by calling ata_acpi_on_devcfg() from
> ata_dev_configure(), and it pretty much has to happen then because
> _SDD/_GTF should be executed after hardreset which happens during
> probing.  So, yeah, I'm confused.

Oh, yes, ACPI handle can be retrieved any time by quering some ACPI
method. And during probe time, it is done that way, while the binding
happens much later... But the ACPI handle can indeed be fetched at that
time :-)
So all the conditions I need to test ZPODD support is ready during probe
time and I'll move the check loading mechanism code there, thanks for
your suggestion.

Thanks,
Aaron

