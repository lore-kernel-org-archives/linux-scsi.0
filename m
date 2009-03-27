From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] lpfc : add module parameter that allows
	adapter	instances to avoid attachment
Date: Fri, 27 Mar 2009 11:41:02 -0500
Message-ID: <1238172062.3292.14.camel@localhost.localdomain>
References: <1238097300.27023.2.camel@ogier>
	 <1238098747.3342.54.camel@localhost.localdomain>
	 <49CBE772.80304@emulex.com>
	 <1238100849.3342.58.camel@localhost.localdomain>
	 <20090327150940.GK8014@parisc-linux.org>
	 <1238168037.3292.8.camel@localhost.localdomain>
	 <20090327161448.GM8014@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53038 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961AbZC0QlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 12:41:07 -0400
In-Reply-To: <20090327161448.GM8014@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-03-27 at 10:14 -0600, Matthew Wilcox wrote:
> On Fri, Mar 27, 2009 at 03:33:57PM +0000, James Bottomley wrote:
> > Actually they better be ... we'll get into real trouble if they're not
> > because of the way we flatten the space for multiple bus binding
> > drivers.
> 
> Er ... where do we do that?  As far as I'm aware, to bind to multiple
> busses, you register multiple foo_driver.  They're separate namespaces.

Yes, you're right.  I was sure there was some way of flattening the
namespace so we mixed bus_ids but perhaps Kay fixed it all.

> > Even if I accepted your argument, I still can't see why we'd only
> > implement this for PCI, and thus why it shouldn't be in the generic
> > device part (except possibly with a bus type name qualifier).
> 
> Adding the bus name qualifier would work.  It seems like much more typing,
> in order to get what advantage over just implementing it for PCI?

The advantage is it's done generically and so works for all buses
instead of just PCI.  The disadvantage, I suppose, is that the matching
must be on only things the generic model knows about, however, the
proposal was PCI IDs, that doesn't seem to be a problem ... if you were
to make it PCIe DSN then yes, it would be harder to do it generically.

James


