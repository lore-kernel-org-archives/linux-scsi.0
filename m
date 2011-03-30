From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Tue, 29 Mar 2011 18:22:30 -0700
Message-ID: <1301448150.31206.15.camel@dwillia2-linux>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
	 <20110327223256.GB7487@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51989 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1C3BPt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2011 21:15:49 -0400
In-Reply-To: <20110327223256.GB7487@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>

On Sun, 2011-03-27 at 15:32 -0700, Christoph Hellwig wrote:
> Btw, the naming scheme in the driver seems utterly confusing,
> with prefixed split between isci_, sci_ and scic_, where a lot of
> the latter also have a second sds_ or controller_ prefix.  Especially
> the use of controller_ in a lot of the nomenclature seems very
> confusing to me.  Is there a scheme behind all this?
> 

Yes, it needs to be documented, but there is some method behind the
confusion.

The expectation is that the lldd need not understand core internals
outside of a set of interface functions.  Any functions prefixed
scic_sds_ are meant to only be called by other core routines.  We have
broken that rule in places where it added unnecessary indirection, like
the isr handlers and phy enable/disable interface (should probably go
back and make those consistent before the final merge).

Core data-structure definitions are also hidden from the lldd.  All it
has access to are the forward declared structure types.

Any functions prefixed with isci_ belong to the lldd, and to remove
indirection we are teaching the core to call lldd routines and native
Linux routines directly (the bulk of the upstream cleanup effort is
covered by this theme).

During this effort it was found that local variable instances had
inconsistent, sometimes overly verbose (contributing to 80 column
collisions), and sometimes ambiguous names so we are using the following
scheme going forward and converting routines in the course of doing
other cleanups.

object            | lldd instance | core instance
------------------|---------------|---------------
controller / host | ihost         | scic
task / request    | ireq          | sci_req, stp_req, ssp_req, smp_req
sas device        | idev          | sci_dev
sas phy           | iphy          | sci_phy
sas port          | iport         | sci_port


