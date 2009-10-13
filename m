From: Alok Kataria <akataria@vmware.com>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Date: Tue, 13 Oct 2009 10:18:50 -0700
Message-ID: <1255454330.12792.34.camel@ank32.eng.vmware.com>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
	 <1254789028.15233.54.camel@ank32.eng.vmware.com>
	 <1255444557.2855.95.camel@localhost.localdomain>
	 <4AD4AEAA.2080209@goop.org>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:47779 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760645AbZJMRT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 13:19:26 -0400
In-Reply-To: <4AD4AEAA.2080209@goop.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Chris Wright <chrisw@sous-sol.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Daniel Walker <dwalker@fifo99.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>

Hi,

On Tue, 2009-10-13 at 09:45 -0700, Jeremy Fitzhardinge wrote:
> On 10/13/09 07:35, James Bottomley wrote:
> >> Yep, below is a patch with the rename, the driver is now called
> >> vmw_pvscsi. Do let me know if you have any other comments. Thanks.
> >>     
> > I'm still curious to know what the 'p' in the name stands for.  Surely
> > this is a fully virtual driver, not a paravirtual one?
> >   

There is a very thin line of difference between para-virtualized and
fully virtualized in this case, and it depends on how we are looking at
it. This device uses the PCI bus for communication rather than
implementing a virtualized bus of some sought and hence is more like any
other PCI device. Though it's not like we are emulating an existing
device, VMware implemented its own device backend which has a particular
ABI, hence this is not a fully virtualized solution either. 
The reason we chose to name the backend as pvscsi is since the solution
is para-virtual in nature. 

As I said earlier, we would prefer to keep pvscsi in the name since the
backend storage adapter is called as PVSCSI and it will be better to
keep the confusion down to minimum if the driver is named something
similar.

Finally, I will like to add that these are just names I don't think we
need to be too picky about them, the driver is prefixed with "vmw",
hence people do know that the driver is VMware specific.

Thanks,
Alok

> 
> I would assume that "pv" does stand for paravirtual.  The terminology is
> a bit screwy: "fully virtualized" means that the device looks like a
> real hardware device that is being emulated.  "Paravirtualized" means
> that it is a completely virtual device which isn't an emulation of
> anything; the guests know this this and talk to it accordingly.





>     J
> 

