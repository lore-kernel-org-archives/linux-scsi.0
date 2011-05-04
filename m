From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT] isci: remote_device state_handlers and base_object	removal
Date: Wed, 04 May 2011 07:59:57 -0700
Message-ID: <4DC169ED.5050101@intel.com>
References: <1304441142.20102.12.camel@dwillia2-linux> <20110504095507.GA30387@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38279 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab1EDO76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2011 10:59:58 -0400
In-Reply-To: <20110504095507.GA30387@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>

On 5/4/2011 2:55 AM, Christoph Hellwig wrote:
> In general this looks like the way to go.  The only think I'm not overly
> happy wih is how the sci_base_object removal is handled.  In general it
> shouldn't be replaced by untyped void pointers, by proper container_of
> usage.  I guess for most instances it doesn't matter too much as the
> different layers of structures for the same object are in the process of
> beeing merged anyway, but it's fairly significant for the state machine.

As it turns out I gave this same feedback internally when reviewing the 
series.  I grabbed this early version for a couple reasons:

1/ wanted to get wider testing of the removal of structure member 
position assumptions.

2/ this arrived before I had the patches to start killing off the 
substate machines so it was not quite ready for this conversion.

Will circle back and re-add the type-safety after the substate machines 
are gone and the unification is completed.

> All the enter/exit handler should be passed a struct sci_base_state_machine *,
> and then use container_of to get at the containing structure, thus removing
> the need for the state_machine_owner field in struct sci_base_state_machine.

Ah yes, forgot about that field.

> And while you're at it _please_ remove all the utterly pointless kerneldoc
> comments for the state enter/exit handlers.

Looks like I managed to kill them all for remote_device, will double 
check that this gets done for the rest.
