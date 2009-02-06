From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 3/3] fcoe: Fibre Channel over Ethernet
Date: Fri, 06 Feb 2009 11:05:17 -0800
Message-ID: <1233947117.7785.5.camel@fritz>
References: <20081209231005.17830.92133.stgit@fritz>
	 <20081209231024.17830.97893.stgit@fritz>
	 <20090204182441.4a8def70.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55985 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZBFTFS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 14:05:18 -0500
In-Reply-To: <20090204182441.4a8def70.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jgarzik@redhat.com" <jgarzik@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "james.smart@emulex.com" <james.smart@emulex.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "jeykholt@cisco.com" <jeykholt@cisco.com>, "andi@firstfloor.org" <andi@firstfloor.org>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>

On Wed, 2009-02-04 at 18:24 -0800, Andrew Morton wrote:
> On Tue, 09 Dec 2008 15:10:24 -0800 Robert Love <robert.w.love@intel.com> wrote:
> 
> > Encapsulation protocol for running Fibre Channel over Ethernet interfaces.
> > Creates virtual Fibre Channel host adapters using libfc.
> > 
> > This layer is the LLD to the scsi-ml. It allocates the Scsi_Host, utilizes
> > libfc for Fibre Channel protocol processing and interacts with netdev to
> > send/receive Ethernet packets.
> > 
> 
> I stumbled across this while looking for new and weird kthread API usages..
> 
I just sent a patchset of Open-FCoE updates to linux-scsi. Patches in
that set should take care of the kernel-doc issues, the initialization
ordering problem for fcoe transports, the typos, the timer comments, and
the unnecessary casting problem.

> > ...
> >
> > +/**
> > + * fcoe_transport_lookup - check if the transport is already registered
> > + * @t: the transport to be looked up
> > + *
> > + * This compares the parent device (pci) vendor and device id
> > + *
> > + * Returns: NULL if not found
> > + *
> > + * TODO - return default sw transport if no other transport is found
> > + **/
> 
> The kerneldoc comments consistently close with
> 
> **/
> 
> which is consistently unconventional.  Not wrong, just odd.
> 

I did change the kernel-doc function comment blocks to end with '*/',
since you called it out. I looked at the other comments under
drivers/scsi/ and most did end in '*/'. However, the
Documentation/kernel-doc-nano-HOWTO.txt has an example for function
headers that shows '**/' as the suggested style. Should the kernel-doc
HOWTO be updated?

Example kernel-doc function comment:

/**
 * foobar() - short function description of foobar
 * @arg1:       Describe the first argument to foobar.
 * @arg2:       Describe the second argument to foobar.
 *              One can provide multiple line descriptions
 *              for arguments.
 *
 * A longer description, with more discussion of the function foobar()
 * that might be useful to those using or modifying it.  Begins with
 * empty comment line, and may include additional embedded empty
 * comment lines.
 *
 * The longer description can have multiple paragraphs.
 **/


