From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] lpfc : add module parameter that allows
	adapter	instances to avoid attachment
Date: Fri, 27 Mar 2009 15:33:57 +0000
Message-ID: <1238168037.3292.8.camel@localhost.localdomain>
References: <1238097300.27023.2.camel@ogier>
	 <1238098747.3342.54.camel@localhost.localdomain>
	 <49CBE772.80304@emulex.com>
	 <1238100849.3342.58.camel@localhost.localdomain>
	 <20090327150940.GK8014@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33745 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbZC0PeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 11:34:03 -0400
In-Reply-To: <20090327150940.GK8014@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-03-27 at 09:09 -0600, Matthew Wilcox wrote:
> On Thu, Mar 26, 2009 at 03:54:09PM -0500, James Bottomley wrote:
> > Also (as Randy pointed out) you don't account for the domain.  However,
> > you could just by not bothering to convert the string to numbers for the
> > compare, just compare on dev->bus_id ... which is how a generic one
> > would work.
> 
> I think it needs to be PCI and not device core.  bus_id isn't guaranteed
> to be unique between different bus types.  I don't know of any that
> conflict, but we don't want to inadvertently disable, say, an SBUS
> device while trying to disable a PCI device.

Actually they better be ... we'll get into real trouble if they're not
because of the way we flatten the space for multiple bus binding
drivers.

Even if I accepted your argument, I still can't see why we'd only
implement this for PCI, and thus why it shouldn't be in the generic
device part (except possibly with a bus type name qualifier).

James


